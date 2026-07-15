---
status: partial
date: 2026-07-15
scope: online-first-offline-policy
---

# Online-first policy verification

The policy is intentionally narrower than full offline support. It prevents
uncontracted local writes; it does not provide a durable cache, outbox, export,
or the route gating required to close Phase 3.

| Test | Expected | Actual | Status |
|---|---|---|---|
| `flutter pub get` | Remove unused local database dependency | Removed `sqflite` and platform packages | ✅ |
| `offline_service_policy_test.dart` | No local persistence or fake sync hook | Passed | ✅ |
| Focused Flutter policy/security/l10n tests | Online-first change does not regress covered paths | 9 passed | ✅ |
| `flutter analyze` | No analyzer issues | No issues found | ✅ |
| `bash scripts/check-mobile-secrets.sh` | Source markers clean | Passed; `gitleaks` unavailable | ⚠️ |
| Route release gating | Blocked/feature-flagged routes cannot be discovered | Not implemented yet | ❌ |
| Account export lifecycle | Own-data authenticated download/save is available | Not implemented; UI remains support-directed | ❌ |
