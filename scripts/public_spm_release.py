#!/usr/bin/env python3

from __future__ import annotations

import argparse
import hashlib
import json
import re
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Callable
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen


REPOSITORY = "zetic-ai/ZeticMLangeiOS"
ASSET_NAME = "ZeticMLange.xcframework.zip"
EVENT_TYPE = "ios-sdk-ready"
LOWER_HEX_40 = re.compile(r"^[0-9a-f]{40}$")
LOWER_HEX_64 = re.compile(r"^[0-9a-f]{64}$")
SEMVER = re.compile(
    r"^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)"
    r"(?:-((?:0|[1-9]\d*|\d*[A-Za-z-][0-9A-Za-z-]*)"
    r"(?:\.(?:0|[1-9]\d*|\d*[A-Za-z-][0-9A-Za-z-]*))*))?"
    r"(?:\+[0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*)?$"
)
RUN_URL = re.compile(
    r"^https://github\.com/zetic-ai/ZeticMLangeiOS/actions/runs/[1-9]\d*$"
)
BINARY_TARGET = re.compile(
    r'^\s*\.binaryTarget\(\s*\n'
    r'\s*name: "ZeticMLange",\s*\n'
    r"\s*url:\s*\n"
    r'\s*"(?P<url>[^"]+)",\s*\n'
    r'\s*checksum: "(?P<sha256>[^"]+)"\s*\n'
    r"\s*\)",
    re.MULTILINE,
)


class VerificationError(Exception):
    pass


@dataclass(frozen=True)
class VerifiedRelease:
    ios_version: str
    artifact_url: str
    sha256: str
    manifest_commit: str
    verification_run_url: str

    def client_payload(self) -> dict[str, Any]:
        stable = {
            "artifact_url": self.artifact_url,
            "ios_version": self.ios_version,
            "manifest_commit": self.manifest_commit,
            "sha256": self.sha256,
        }
        readiness_key = hashlib.sha256(
            json.dumps(stable, sort_keys=True, separators=(",", ":")).encode()
        ).hexdigest()
        return {
            "schema_version": 1,
            "readiness_key": readiness_key,
            **stable,
            "verification_run_url": self.verification_run_url,
        }


def artifact_url(version: str) -> str:
    return (
        f"https://github.com/{REPOSITORY}/releases/download/"
        f"{version}/{ASSET_NAME}"
    )


def _require_object(value: Any, name: str) -> dict[str, Any]:
    if not isinstance(value, dict):
        raise VerificationError(f"{name} must be an object")
    return value


def _read_event(path: Path) -> tuple[str, str]:
    try:
        event = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as error:
        raise VerificationError(f"cannot read release event: {error}") from error
    event = _require_object(event, "release event")
    if event.get("action") != "published":
        raise VerificationError("release event action must be published")
    repository = _require_object(event.get("repository"), "release repository")
    if repository.get("full_name") != REPOSITORY:
        raise VerificationError(f"release repository must be {REPOSITORY}")
    release = _require_object(event.get("release"), "release")
    if release.get("draft") is not False:
        raise VerificationError("published release must not be a draft")
    version = release.get("tag_name")
    if not isinstance(version, str) or SEMVER.fullmatch(version) is None:
        raise VerificationError("release tag must be a canonical SemVer value")
    expected_url = artifact_url(version)
    assets = release.get("assets")
    if not isinstance(assets, list):
        raise VerificationError("release assets must be a list")
    matches = [
        asset
        for asset in assets
        if isinstance(asset, dict)
        and (asset.get("name") == ASSET_NAME or asset.get("browser_download_url") == expected_url)
    ]
    if len(matches) != 1:
        raise VerificationError("release must contain exactly one expected archive asset")
    if (
        matches[0].get("name") != ASSET_NAME
        or matches[0].get("browser_download_url") != expected_url
        or matches[0].get("state") != "uploaded"
    ):
        raise VerificationError("release archive asset metadata conflicts with the tag")
    return version, expected_url


def _read_manifest(path: Path, version: str, expected_url: str) -> str:
    try:
        content = path.read_text(encoding="utf-8")
    except (OSError, UnicodeError) as error:
        raise VerificationError(f"cannot read Package.swift: {error}") from error
    matches = list(BINARY_TARGET.finditer(content))
    if len(matches) != 1 or content.count(".binaryTarget(") != 1:
        raise VerificationError(
            "Package.swift must contain exactly one approved ZeticMLange binary target"
        )
    if matches[0].group("url") != expected_url:
        raise VerificationError(f"Package.swift archive URL does not match release {version}")
    checksum = matches[0].group("sha256")
    if LOWER_HEX_64.fullmatch(checksum) is None:
        raise VerificationError("Package.swift checksum must be lowercase 64-hex")
    return checksum


def _download_sha256(
    url: str, opener: Callable[..., Any] = urlopen
) -> str:
    request = Request(url, headers={"User-Agent": "ZeticMLangeiOS-release-verifier"})
    digest = hashlib.sha256()
    try:
        with opener(request, timeout=60) as response:
            if getattr(response, "status", None) != 200:
                raise VerificationError(
                    f"archive download returned HTTP {getattr(response, 'status', 'unknown')}"
                )
            for chunk in iter(lambda: response.read(1024 * 1024), b""):
                digest.update(chunk)
    except VerificationError:
        raise
    except HTTPError as error:
        status = error.code
        error.close()
        raise VerificationError(f"archive download returned HTTP {status}") from error
    except (OSError, URLError) as error:
        raise VerificationError(f"archive download failed: {error}") from error
    return digest.hexdigest()


def verify_release(
    event_path: Path,
    manifest_path: Path,
    manifest_commit: str,
    verification_run_url: str,
    opener: Callable[..., Any] = urlopen,
) -> VerifiedRelease:
    if LOWER_HEX_40.fullmatch(manifest_commit) is None:
        raise VerificationError("manifest commit must be lowercase 40-hex")
    if RUN_URL.fullmatch(verification_run_url) is None:
        raise VerificationError("verification run URL is not an approved Actions URL")
    version, expected_url = _read_event(event_path)
    expected_sha256 = _read_manifest(manifest_path, version, expected_url)
    observed_sha256 = _download_sha256(expected_url, opener)
    if observed_sha256 != expected_sha256:
        raise VerificationError(
            "archive checksum mismatch: "
            f"expected {expected_sha256}, observed {observed_sha256}"
        )
    return VerifiedRelease(
        ios_version=version,
        artifact_url=expected_url,
        sha256=expected_sha256,
        manifest_commit=manifest_commit,
        verification_run_url=verification_run_url,
    )


def _write_payload(path: Path, release: VerifiedRelease) -> None:
    temporary = path.with_suffix(path.suffix + ".tmp")
    temporary.write_text(
        json.dumps(
            {"event_type": EVENT_TYPE, "client_payload": release.client_payload()},
            sort_keys=True,
            separators=(",", ":"),
        )
        + "\n",
        encoding="utf-8",
    )
    temporary.replace(path)


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Verify a published public SPM archive before Flutter notification."
    )
    parser.add_argument("--event", type=Path, required=True)
    parser.add_argument("--manifest", type=Path, required=True)
    parser.add_argument("--manifest-commit", required=True)
    parser.add_argument("--verification-run-url", required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    args.output.unlink(missing_ok=True)
    try:
        release = verify_release(
            args.event,
            args.manifest,
            args.manifest_commit,
            args.verification_run_url,
        )
        _write_payload(args.output, release)
    except (OSError, VerificationError) as error:
        print(f"public SPM verification failed: {error}", file=sys.stderr)
        return 1
    print(f"public SPM archive verified: {release.ios_version}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
