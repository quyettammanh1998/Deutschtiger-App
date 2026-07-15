---
status: partial
date: 2026-07-15
scope: security-privacy-and-localization-foundation
---

# Security and localization slice verification

This evidence covers the implemented slice only. Phase 1 and Phase 2 remain
open because a configured translation provider, artifact scanning, full route
localization, and physical accessibility checks are still required.

| Test | Expected | Actual | Status |
|---|---|---|---|
| `go test ./internal/shared/aihttp` | Translation handler contract tests pass | Passed | ✅ |
| `curl` invalid `sourceLang=fr` to `/api/v1/ai/translate-sentences` | `400` safe validation error | `400` `Ngôn ngữ nguồn không được hỗ trợ` | ✅ |
| `curl` valid local translation request without an AI provider | Safe unavailable response | `503` `Tính năng dịch AI chưa sẵn sàng` | ✅ |
| Focused Flutter tests (translation, crash, l10n, preferences, smoke) | All pass | 11 passed | ✅ |
| Settings localization follow-up (`l10n` + app smoke) | Localized feedback/error copy renders and app still starts | 3 passed | ✅ |
| Global navigation/offline localization (`l10n` + app smoke) | Root chrome resolves through generated catalogs | 3 passed | ✅ |
| More Features localization and semantics at 200% scale | German labels and tile semantic name resolve correctly | 4 passed | ✅ |
| Security route localization and error handling | Generated placeholders resolve; no raw API error copied to UI | 3 l10n tests + analyzer passed | ✅ |
| `flutter analyze` | No analyzer issues | No issues found | ✅ |
| `bash scripts/check-mobile-secrets.sh` | Source markers clean and dependency report written | Passed; report written to `build/security/` | ✅ |
| Debug APK build | Build a locally installable Android artifact | `app-debug.apk` built successfully | ✅ |
| Debug APK marker scan | No known private-provider marker in artifact | Passed | ✅ |
| Required Gitleaks history scan | No unallowlisted committed secret | Passed; one documented public anon-key fingerprint allowlisted | ✅ |
| Full localization and screen-reader flow | All enabled routes work across declared locales | Not yet complete | ❌ |
