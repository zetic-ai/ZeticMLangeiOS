import unittest
from pathlib import Path


WORKFLOW = Path(__file__).parents[1] / ".github/workflows/public-spm-release.yml"


class ReleaseWorkflowTest(unittest.TestCase):
    def test_workflow_uses_the_approved_trigger_and_permissions(self):
        content = WORKFLOW.read_text(encoding="utf-8")
        self.assertIn("release:\n    types: [published]", content)
        self.assertIn("permissions:\n  contents: read", content)
        self.assertIn("ref: main", content)
        self.assertIn("persist-credentials: false", content)
        self.assertIn("repositories: mlange_flutter", content)
        self.assertIn("permission-contents: write", content)
        self.assertNotIn("pull-requests:", content)
        self.assertNotIn("permission-pull-requests:", content)

    def test_token_is_created_only_after_archive_verification(self):
        content = WORKFLOW.read_text(encoding="utf-8")
        verify = content.index("name: Verify public manifest and archive")
        token = content.index("name: Create scoped Flutter token")
        dispatch = content.index("name: Dispatch verified metadata to Flutter")
        self.assertLess(verify, token)
        self.assertLess(token, dispatch)


if __name__ == "__main__":
    unittest.main()
