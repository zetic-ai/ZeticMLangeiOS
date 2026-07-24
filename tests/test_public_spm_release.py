import hashlib
import io
import json
import sys
import tempfile
import unittest
import zipfile
from pathlib import Path
from urllib.error import HTTPError


sys.path.insert(0, str(Path(__file__).parents[1] / "scripts"))
import public_spm_release as release  # noqa: E402


VERSION = "1.10.0"
COMMIT = "a" * 40
RUN_URL = "https://github.com/zetic-ai/ZeticMLangeiOS/actions/runs/123"


def archive_bytes():
    output = io.BytesIO()
    with zipfile.ZipFile(output, "w") as archive:
        archive.writestr("ZeticMLange.xcframework/Info.plist", "fixture")
    return output.getvalue()


def manifest(checksum, url=None):
    url = url or release.artifact_url(VERSION)
    return f'''// swift-tools-version:5.5
import PackageDescription

let package = Package(
  name: "ZeticMLangeiOS",
  targets: [
    .binaryTarget(
      name: "ZeticMLange",
      url:
        "{url}",
      checksum: "{checksum}"
    )
  ]
)
'''


def event(assets=None):
    if assets is None:
        assets = [{
            "name": release.ASSET_NAME,
            "browser_download_url": release.artifact_url(VERSION),
            "state": "uploaded",
        }]
    return {
        "action": "published",
        "repository": {"full_name": release.REPOSITORY},
        "release": {"draft": False, "tag_name": VERSION, "assets": assets},
    }


class Response:
    def __init__(self, content, status=200):
        self.content = io.BytesIO(content)
        self.status = status

    def __enter__(self):
        return self

    def __exit__(self, *_):
        return False

    def read(self, size):
        return self.content.read(size)


class PublicSpmReleaseTest(unittest.TestCase):
    def verify(self, *, event_value=None, manifest_value=None, content=None, opener=None):
        content = archive_bytes() if content is None else content
        checksum = hashlib.sha256(content).hexdigest()
        manifest_value = manifest_value or manifest(checksum)
        opener = opener or (lambda *_args, **_kwargs: Response(content))
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            event_path = root / "event.json"
            manifest_path = root / "Package.swift"
            event_path.write_text(json.dumps(event_value or event()), encoding="utf-8")
            manifest_path.write_text(manifest_value, encoding="utf-8")
            return release.verify_release(
                event_path, manifest_path, COMMIT, RUN_URL, opener
            )

    def test_known_good_archive_produces_exact_receiver_payload(self):
        verified = self.verify()
        payload = verified.client_payload()
        self.assertEqual(
            {
                "schema_version",
                "readiness_key",
                "ios_version",
                "artifact_url",
                "sha256",
                "manifest_commit",
                "verification_run_url",
            },
            set(payload),
        )
        self.assertEqual(VERSION, payload["ios_version"])
        self.assertEqual(COMMIT, payload["manifest_commit"])
        self.assertRegex(payload["readiness_key"], r"^[0-9a-f]{64}$")
        self.assertEqual(payload["readiness_key"], self.verify().client_payload()["readiness_key"])

    def test_tampered_archive_reports_expected_and_observed_hashes(self):
        original = archive_bytes()
        expected = hashlib.sha256(original).hexdigest()
        observed = hashlib.sha256(original + b"tampered").hexdigest()
        with self.assertRaisesRegex(
            release.VerificationError, f"expected {expected}, observed {observed}"
        ):
            self.verify(manifest_value=manifest(expected), content=original + b"tampered")

    def test_missing_or_conflicting_release_asset_is_rejected(self):
        cases = [[], [{
            "name": release.ASSET_NAME,
            "browser_download_url": "https://example.com/archive.zip",
            "state": "uploaded",
        }]]
        for assets in cases:
            with self.subTest(assets=assets), self.assertRaises(release.VerificationError):
                self.verify(event_value=event(assets))

    def test_http_error_is_rejected(self):
        def missing(request, timeout):
            raise HTTPError(request.full_url, 404, "Not Found", {}, None)

        with self.assertRaisesRegex(release.VerificationError, "HTTP 404"):
            self.verify(opener=missing)

    def test_malformed_or_unexpected_manifest_is_rejected(self):
        checksum = hashlib.sha256(archive_bytes()).hexdigest()
        cases = [
            manifest(checksum.upper()),
            manifest(checksum, "https://example.com/mutable.zip"),
            manifest(checksum) + manifest(checksum),
            manifest(checksum).replace('name: "ZeticMLange"', 'name: "Other"'),
        ]
        for value in cases:
            with self.subTest(value=value), self.assertRaises(release.VerificationError):
                self.verify(manifest_value=value)

    def test_event_and_provenance_fields_fail_closed(self):
        cases = [
            ({**event(), "action": "edited"}, COMMIT, RUN_URL),
            ({**event(), "repository": {"full_name": "other/repo"}}, COMMIT, RUN_URL),
            (event(), "A" * 40, RUN_URL),
            (event(), COMMIT, "https://example.com/run/1"),
        ]
        for event_value, commit, run_url in cases:
            with self.subTest(event=event_value, commit=commit, run_url=run_url):
                with tempfile.TemporaryDirectory() as directory:
                    root = Path(directory)
                    content = archive_bytes()
                    (root / "event.json").write_text(json.dumps(event_value), encoding="utf-8")
                    (root / "Package.swift").write_text(
                        manifest(hashlib.sha256(content).hexdigest()), encoding="utf-8"
                    )
                    with self.assertRaises(release.VerificationError):
                        release.verify_release(
                            root / "event.json",
                            root / "Package.swift",
                            commit,
                            run_url,
                            lambda *_args, **_kwargs: Response(content),
                        )

    def test_dispatch_posts_the_exact_verified_envelope(self):
        captured = []

        def opener(request, timeout):
            captured.append((request, timeout))
            return Response(b"", 204)

        with tempfile.TemporaryDirectory() as directory:
            payload_path = Path(directory) / "payload.json"
            envelope = {
                "event_type": release.EVENT_TYPE,
                "client_payload": self.verify().client_payload(),
            }
            payload_path.write_text(json.dumps(envelope), encoding="utf-8")
            release.dispatch_payload(payload_path, "installation-token", opener)

        request, timeout = captured[0]
        self.assertEqual(release.DISPATCH_URL, request.full_url)
        self.assertEqual("POST", request.method)
        self.assertEqual(30, timeout)
        self.assertEqual(envelope, json.loads(request.data))
        self.assertEqual("Bearer installation-token", request.get_header("Authorization"))

    def test_dispatch_rejects_authentication_failure(self):
        with tempfile.TemporaryDirectory() as directory:
            payload_path = Path(directory) / "payload.json"
            payload_path.write_text(
                json.dumps({
                    "event_type": release.EVENT_TYPE,
                    "client_payload": self.verify().client_payload(),
                }),
                encoding="utf-8",
            )
            for status in (401, 403):
                def unauthorized(request, timeout, response_status=status):
                    raise HTTPError(
                        request.full_url,
                        response_status,
                        "Unauthorized",
                        {},
                        io.BytesIO(),
                    )

                with self.subTest(status=status), self.assertRaisesRegex(
                    release.VerificationError, f"HTTP {status}"
                ):
                    release.dispatch_payload(
                        payload_path, "installation-token", unauthorized
                    )

    def test_dispatch_revalidates_payload_before_network_access(self):
        calls = []
        cases = [
            ("readiness_key", "0" * 64, "readiness_key"),
            ("schema_version", True, "schema version 1"),
        ]
        for field, value, error in cases:
            payload = self.verify().client_payload()
            payload[field] = value
            with self.subTest(field=field), tempfile.TemporaryDirectory() as directory:
                payload_path = Path(directory) / "payload.json"
                payload_path.write_text(
                    json.dumps({
                        "event_type": release.EVENT_TYPE,
                        "client_payload": payload,
                    }),
                    encoding="utf-8",
                )
                with self.assertRaisesRegex(release.VerificationError, error):
                    release.dispatch_payload(
                        payload_path,
                        "installation-token",
                        lambda *_args, **_kwargs: calls.append(True),
                    )
        self.assertEqual([], calls)


if __name__ == "__main__":
    unittest.main()
