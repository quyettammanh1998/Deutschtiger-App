# Android integration CI wiring verification

| Test | Expected | Actual | Status |
|---|---|---|---|
| YAML parse of `.github/workflows/flutter-ci.yml` | Workflow remains syntactically valid | Parsed successfully with PyYAML | ✅ |
| Workflow references | Clean checkout creates safe config and invokes the Android integration test | `.env.example` copied in both jobs; `android-integration` runs `integration_test/welcome_flow_test.dart` on `emulator-5554` | ✅ |
| Local Android integration command | Referenced test has native execution evidence | Passed earlier on `Pixel6_API34`: welcome reached onboarding | ✅ |
| `gh run list --workflow flutter-ci.yml` against the configured private remote | Hosted emulator runs the new job | GitHub returned 404 because remote `main` does not yet contain the locally uncommitted workflow file. A commit/push or PR is required before the first hosted run. | ⚠️ |

The workflow uses only the tracked placeholder `.env.example`, not a production
credential. The welcome test uses no authenticated account or live backend
request. `actionlint` is not installed in this local environment; YAML parsing
and path/reference checks were run instead. The GitHub repository connection is
healthy; the missing hosted run is a source-publication condition, not a local
workflow or authentication failure.
