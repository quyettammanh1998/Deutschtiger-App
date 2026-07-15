# More-feature release gates verification — 2026-07-15

The More sheet does not discover route families that lack verified production
contracts by default. Local QA can enable a family with its documented compile
time `DEUTSCHTIGER_ENABLE_*` define. This gate intentionally covers the More
sheet only; Home and shell navigation still need their own route audit.

| Test | Expected | Actual | Status |
|---|---|---|---|
| `flutter test test/l10n/app_localizations_test.dart` | Default More sheet hides gated Grammar tile | 4 tests passed | ✅ |
| same with `--dart-define=DEUTSCHTIGER_ENABLE_GRAMMAR=true` | QA build exposes Grammar tile | 4 tests passed | ✅ |
| `flutter analyze` | No static-analysis errors | No issues found | ✅ |
| `curl http://127.0.0.1:8080/api/v1/health` | Local backend is healthy for Flutter verification | `200 {"status":"ok",...}` | ✅ |

Unresolved questions: audit and gate the remaining discoverable Home and shell
entry points before claiming that release navigation contains only live flows.
