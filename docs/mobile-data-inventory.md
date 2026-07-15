# Mobile Data Inventory

## Overview

This is an evidence-based inventory of Flutter data flows as of 2026-07-15.
It supports the in-app policy, store disclosures, export/delete design, and
release review. It is not a retention schedule or a substitute for legal review.

## Observed data flows

| Category | Data observed in client | Destination / protection | Evidence | Disclosure status |
|---|---|---|---|---|
| Authentication | Email, display name, Google/Apple identity token, Supabase session | Supabase Auth; persisted locally in Android Keystore / iOS Keychain. Android app data is excluded from cloud backup and device-to-device extraction. | `lib/services/auth_service.dart`, `lib/services/secure_auth_storage.dart`, `android/app/src/main/AndroidManifest.xml`, `android/app/src/main/res/xml/` | Account identity; linked while signed in. |
| Account profile | Display name, avatar URL | DeutschTiger API with Supabase JWT | `lib/repositories/profile_repository.dart`, `lib/services/api_client.dart` | Linked account data. |
| Learning progress | Mission IDs, word IDs, answer correctness, FSRS/review and exam progress | DeutschTiger API with Supabase JWT | `lib/features/mission/presentation/mission_session_provider.dart`, repositories under `lib/repositories/` | Linked learning data. |
| Translation | Submitted text plus `sourceLang`/`targetLang` | Authenticated `POST /api/v1/ai/translate-sentences`; backend owns model/provider credentials | `lib/core/translation/translation_service.dart`, `internal/shared/aihttp/ai_translate_handler.go` | Content is sent to DeutschTiger backend when user requests translation. |
| Usage analytics | Categorized event name/source and aggregate numeric or boolean values only | `POST /api/v1/user/events` with JWT; backend writes `user_id` with sanitized metadata | `lib/services/event_tracking.dart`, `internal/shared/event/event_handler.go` | Linked analytics; do not describe as anonymous. Learner text, file paths, URLs and nested payloads are dropped client-side. |
| Crash diagnostics | Error runtime type, route, app version, platform | Firebase Crashlytics; client drops raw exception/message content | `lib/services/crash_service.dart`, `lib/app.dart`, `lib/services/api_client.dart` | Diagnostic data; no deliberate draft, translation, recording, token, or provider-response logging. |
| Push notifications | Permission state and FCM registration token can be obtained locally | Firebase Messaging; this Flutter source has no verified token-upload call | `lib/services/notifications/fcm_notification_service.dart` | Declare only after the server token-registration path is enabled and verified. |
| Microphone recordings | Temporary `.m4a` recording path and audio file | Local temporary directory; the inspected recording service has no upload client or API dependency | `lib/features/voice/data/recording_service.dart`, `ios/Runner/Info.plist` | Obtain microphone permission before recording. The current iOS permission text states the temporary local behavior and does not claim server-side grading or retention. |
| Purchases | RevenueCat public SDK key, optional app user ID, purchase/entitlement state | RevenueCat SDK when GĐ2 initialization is enabled | `lib/features/premium/data/revenuecat_service.dart` | Requires its own store disclosure before GĐ2 release. Public SDK keys are identifiers, not provider secrets. |

## Current user-rights state

- The app does not issue a destructive deletion request while no matching
  backend route is verified. Account deletion opens a localized support request
  path instead; it must be replaced by the authenticated deletion lifecycle.
- Settings states that in-app export is unavailable and directs users to
  support. It must be replaced by the authenticated export contract in the
  contract-reconciliation / portability phase.
- No retention claim is made here. Backend owners must document retention and
  deletion timing before store submission.

## Release checks

Run the source and dependency report before producing a mobile candidate:

```bash
bash scripts/check-mobile-secrets.sh
```

Pass one or more built `.apk`, `.aab`, or `.ipa` paths to scan their extracted
strings as well. The script fails on known private-provider markers and writes
the resolved Dart dependency tree to `build/security/dart-dependencies.json`.
If `gitleaks` is installed, it runs an additional redacted repository scan;
otherwise it reports that this extra scan was unavailable. Set
`MOBILE_REQUIRE_GITLEAKS=1` to fail closed instead; the GitHub PR workflow uses
that mode. `.gitleaksignore` contains only the fingerprint of the documented
public Supabase anon-key example; it must not be used for provider, service-role
or user credentials.

## References

- `docs/flutter-api-contract-matrix.md`
- `docs/api-changelog.md`
- `plans/260715-flutter-cross-cutting-readiness/phase-01-security-and-privacy-boundaries.md`
