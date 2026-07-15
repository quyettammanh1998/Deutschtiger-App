---
phase: 1
title: Security and Privacy Boundaries
status: in-progress
priority: P0
effort: 3–5d
dependencies: []
---

# Phase 1: Security and Privacy Boundaries

## Overview

Remove private provider credentials from Flutter and make the actual data flows,
telemetry and public privacy statements match. This is a release blocker because
the current direct DeepL authorization would expose a provider secret in a
mobile binary.

## Requirements

- All private provider calls (translation, AI, STT, payment server operations)
  originate from Go infrastructure; Flutter calls only DeutschTiger APIs via
  `ApiClient` or uses a short-lived server-minted token whose provider permits
  this model.
- Public client identifiers are documented by type: Supabase publishable/anon
  key and RevenueCat public SDK key are allowed; DeepL/OpenAI/Soniox/Azure/
  service-role keys are forbidden.
- Privacy policy, Data Safety/Privacy Nutrition Label, analytics event schema,
  audio/writing retention and account-export/deletion statements describe the
  same deployed behavior.

## Architecture

```text
Flutter TranslationRepository
  └── ApiClient POST /ai/translate-sentences
        └── Go translation handler
              ├── auth + per-user rate limit + payload validation
              ├── provider credential from server environment
              └── normalized response / safe error code
```

The backend is the sole provider boundary. Error telemetry receives route,
version and categorized code—not raw translation text, tokens, drafts or audio.

## Progress (2026-07-15)

- Flutter no longer calls DeepL or carries a provider authorization header; its
  translation service uses the authenticated `/api/v1/ai/translate-sentences`
  contract instead.
- The reference Go handler validates auth and language/payload bounds before
  provider selection, applies its bounded timeout/concurrency path, and has
  focused contract tests. A local provider is not configured, so only the
  verified `400` validation and `503` unavailable paths have live evidence.
- Crash diagnostics now use error types and an allowlisted event code, with
  route/version/platform metadata. Privacy text and the data inventory now
  disclose the inspected linked telemetry behavior; the app truthfully marks
  in-app data export unavailable rather than simulating a completed export.
- `scripts/check-mobile-secrets.sh` checks source markers and records Dart
  dependencies. The current debug APK passed its marker scan and a required
  Gitleaks history scan. The one documented public Supabase anon-key example is
  allowlisted by its exact finding fingerprint, not a broad pattern.
- A fresh local scan of `app-debug.apk` passed the source and artifact marker
  checks, regenerated the dependency report, and completed the required
  redacted Gitleaks history scan over 19 commits with no leaks found. Signed
  release-artifact evidence is still outstanding.
- The default error boundary no longer renders raw exception text to users;
  it uses a localized generic fallback. A source guard and existing CrashService
  tests protect the separate UI and telemetry redaction boundaries.
- Client event tracking now permits only categorized event/source tokens and
  aggregate numeric or boolean metadata. Mission telemetry no longer includes a
  mission identifier or nested action structure; content-like event names,
  drafts, paths, URLs, tokens and non-finite values are dropped before the
  buffer is sent. The privacy screen and mobile data inventory state this
  behavior explicitly.
- Android release configuration now explicitly disables Auto Backup and
  provides exclusions for cloud backup and device-to-device extraction across
  Android 7–11 and Android 12+. This protects local secure-storage session and
  PKCE material from backup/restore; the compiled debug manifest and a source
  guard verify the policy.
- The iOS microphone permission text now describes the inspected recording
  implementation: a temporary local `.m4a` file with no upload client or API
  dependency. It no longer claims server-side AI grading or retention behavior
  that this source does not implement.
- The iOS app target has no App Transport Security exception or arbitrary-load
  setting. A source guard preserves the default secure transport policy unless
  a reviewed, explicit exception is added later.

## Related Code Files

- Replace: `lib/core/translation/translation_service.dart` with a repository/service using `ApiClient`
- Modify: `lib/services/config/app_config.dart`, `docs/api-changelog.md`, `docs/flutter-api-contract-matrix.md`
- Create: backend translation handler/route/tests under `thamkhao/deutschtiger-backend/`; migration is not needed unless retention/audit requires it
- Modify: `lib/services/crash_service.dart`, `lib/services/event_tracking.dart`, legal/privacy screens and store metadata source docs
- Create: source/binary secret-scan scripts and tests under `scripts/`, `test/services/`

## Implementation Steps

1. Inventory every outbound Flutter host, authorization header and compile-time
   define. Classify it as public identifier, short-lived server token, or
   forbidden private credential. Fail closed on an unclassified production call.
2. Add an authenticated, rate-limited translation API with explicit request
   size, supported source/target languages, timeout and normalized error codes.
   Keep the provider credential only in backend deployment environment; record
   the additive endpoint in the API matrix/changelog.
3. Replace the direct `Dio` DeepL service with the typed `ApiClient` contract.
   Delete `DEEPL_API_KEY` usage from Flutter build inputs and add tests proving
   the client sends no provider authorization header.
4. Add release checks: `gitleaks`/pattern scan over source, Dart defines,
   generated Android/iOS artifacts and symbol/debug files; dependency audit/SBOM
   must report rather than silently ignore vulnerable packages.
5. Build a data inventory for profile, auth, analytics, writing, audio,
   messages, push tokens and payments. Reconcile the privacy screen's current
   “anonymous/not linked” analytics statement with the actual linked-user
   collection or change the implementation/metadata accordingly.
6. Verify Crashlytics/event redaction with injected representative error paths;
   keep content out of logs and provide user-visible handling for provider
   failure/rate limit without exposing vendor details.

## Success Criteria

- [ ] Repository scan and release artifact scan contain no private provider or
  service credential; allowed public identifiers are documented exceptions.
- [ ] Translation succeeds through authenticated Go API, enforces rate/payload
  limits, and the Flutter request has no `DeepL-Auth-Key` or direct DeepL host.
- [ ] Contract tests cover request/response/error mapping on Flutter and Go.
- [ ] Privacy policy, store disclosure and telemetry data inventory agree with
  inspected runtime behavior for every collected data category.
- [ ] An inspected Crashlytics sample has route/version/code but no user text,
  JWT, provider key, writing draft or recording path.

## Risk Assessment

- A client-side secret cannot be made safe by obfuscation. Rotate the exposed
  provider key before release and after removing the path.
- Moving translation behind the backend can add latency/cost; rate limiting,
  short cache policy and quotas belong at the server boundary, not the UI.
