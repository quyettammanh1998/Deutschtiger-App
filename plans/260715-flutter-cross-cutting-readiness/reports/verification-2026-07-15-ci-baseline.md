---
status: partial
date: 2026-07-15
scope: pull-request-quality-baseline
---

# Pull-request CI baseline verification

The GitHub workflow is validated syntactically and its Flutter commands have
been exercised locally. It has not yet run on GitHub Actions, so this is not
remote-run evidence.

| Test | Expected | Actual | Status |
|---|---|---|---|
| `go run github.com/rhysd/actionlint/cmd/actionlint@v1.7.10` | Valid workflow/action inputs | Passed | ✅ |
| `flutter test` | Full unit/widget suite passes | 184 passed | ✅ |
| `flutter analyze` | No analyzer issues | No issues found | ✅ |
| Device-session repository test | Initializes Flutter binding before `ApiClient` headers resolve | 3 passed; binding warning removed | ✅ |
| Required Gitleaks + mobile secret scan | No unallowlisted committed secret or marker | Passed locally with pinned Gitleaks v8.30.1 | ✅ |
| GitHub Actions run | PR workflow completes on hosted runner | No remote run yet | ❌ |
| Device, visual, signed release gates | Full Phase 4 evidence | Not implemented yet | ❌ |
