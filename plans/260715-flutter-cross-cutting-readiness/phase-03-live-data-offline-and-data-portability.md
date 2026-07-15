---
phase: 3
title: "Live Data Offline and Data Portability"
status: in-progress
priority: P0
effort: "1–2w"
dependencies: [1]
---

# Phase 3: Live Data Offline and Data Portability

## Overview

Make the release-visible app truthful about its data. Mock/placeholder sources
may remain in tests/previews only; enabled user journeys need live backend
contracts, an explicit offline policy and a data-export flow aligned with the
account lifecycle work.

## Requirements

- Maintain a route-to-data inventory: every discoverable route is `live`,
  `feature-flagged`, `fixture-only` or `web-only`, with no ambiguous mock
  production path.
- Decide offline scope before adding cache/outbox code. Recommended baseline is
  online-first with read-only last-successful content cache; no offline writes
  except server-idempotent drafts/operations explicitly covered by a contract.
- Expose data export in account settings once the shared backend export endpoint
  is complete; export, deletion and restore descriptions use one privacy policy.

## Architecture

```text
Route registry → DataSource classification → live API / read-only cache / gated route
                                      ↓
                           release inventory + anti-mock test

User export action → ApiClient download/stream → native save/share sheet
```

Offline writes require `operation_id`, server idempotency and conflict behavior;
without all three the UI stays online-only and shows recoverable retry state.

## Progress (2026-07-15)

- `docs/flutter-live-data-inventory.md` classifies every mounted route family
  and records the current release disposition. Several enabled mock routes are
  explicit blockers rather than silently treated as live.
- The app now enforces the safe baseline: connectivity reporting only. The
  unused local SQLite queue and its fake sync hook were removed because no
  backend idempotency/conflict contract exists.
- Account export remains an honest support-directed unavailable state until the
  contract-reconciliation plan supplies an authenticated download lifecycle.
- Fixture landing and full-welcome routes are now protected from authenticated
  deep links. They redirect to Home instead of permitting a direct route to
  unowned local presentation data.
- The unmounted `DELETE /user/profile` client path was removed. Account
  deletion is now a localized support-directed screen that cannot report a
  false deletion success; it remains a release gap until the authenticated
  `/user/account` lifecycle is implemented and verified.
- More-sheet entries with mock, fixture-only or unfrozen contracts now have
  conservative compile-time gates. Home direct affordances and the AI shell
  tab use the same gates; unsupported daily-path skills resolve to the live
  Learn hub. They default off and require an explicit
  `DEUTSCHTIGER_ENABLE_*` build define for local QA. The post-auth router
  redirect prevents deep links from bypassing these gates; remaining route
  families still need a live-contract audit before their gate can turn on.
- The redirect regression test now covers each gated family with a representative
  nested route, including grammar, media, journey, practice, AI, social, stats,
  achievements, affiliate and premium. It guards the route-family redirect
  contract rather than relying only on hidden navigation affordances.
- `OfflineService` now accepts an injected connectivity stream/checker for
  deterministic tests. Coverage verifies online → offline → online state
  transitions and a current connectivity check while retaining the explicit
  no-queue/no-persistence policy; it does not add a cache or offline writes.
- A public production probe verified that the Exam catalog is a non-empty
  array with parts. The local backend's `200 null` catalog response contradicts
  the current handler's empty-array normalization, so it is documented as
  local runtime/fixture drift rather than papered over in Flutter.
- CI now rejects direct `mock`, `fixture` or `placeholder` markers in the
  mounted release-visible route screens. The guard is scoped to route entries,
  so test/previews and disabled route families are not mistaken for a released
  data path.
- The legacy `/exam/goethe-b1/**` route family is now compile-time QA-gated.
  Its hub/readiness repository and writing/speaking topic routes embed fixture
  data, so default release deep links redirect to the live `/exam` catalog
  unless `DEUTSCHTIGER_ENABLE_LEGACY_GOETHE_B1` is explicitly enabled.

## Related Code Files

- Create: `docs/flutter-live-data-inventory.md`, route/data-source tests and production mock-import guard
- Modify: all enabled mock repositories/screens under `lib/repositories/`, `lib/screens/`, `lib/features/`
- Modify: `lib/services/offline/offline_service.dart`, cache implementation and shared loading/error states after the offline decision
- Modify: settings/security/account screens and repositories for export flow
- Reuse: `thamkhao/deutschtiger-backend/plans/260706-1113-account-deletion-data-export/phase-01-be-export-du-lieu-json.md`
- Modify: `docs/api-changelog.md`, `docs/flutter-api-contract-matrix.md` for all new live/cached/export contracts

## Implementation Steps

1. Generate the first inventory from router-reachable pages and repository
   imports. Mark every mock/placeholder occurrence as test-only, preview-only,
   replace-with-live, feature-flagged or delete; assign an owning API endpoint.
2. Add a release test that fails when an enabled route imports mock data or a
   fake repository, while allowing explicit fixtures under test/previews.
3. Replace Phase 1 screens with live repository contracts in dependency order:
   auth/dashboard/vocab/review/exam/reading/grammar/AI/settings. Do not enable
   a screen merely because it renders a static successful state.
4. Decide and document offline behavior. If read-only cache is approved, define
   TTL, encryption/sensitivity class, eviction, stale indicator and clear-on-
   logout semantics. If durable writes are approved, add backend idempotency,
   conflict/version response and retry/outbox telemetry before UI queues them.
5. Implement account data export from the common backend endpoint with an
   authenticated download, native share/save flow, cancellation, expiry and no
   export payload logged to analytics/Crashlytics. Link it from Settings beside
   deletion, not as a hidden developer action.
6. Test logout/cache clearing, network loss/recovery, stale read-only content,
   duplicate request protection and export authorization with two users.

## Success Criteria

- [ ] Every release-discoverable route appears in the live-data inventory with
  a verified source, feature gate or explicit web-only reason.
- [ ] CI rejects mock/placeholder data on enabled production routes.
- [ ] Offline behavior is documented, visible to users and tested; no write is
  queued without server idempotency/conflict semantics.
- [ ] A user exports only their own data through the app; response is not stored
  or logged beyond the intended save/share destination.
- [ ] Privacy policy, deletion/restore and export UI accurately describe data
  lifecycle and cache behavior.

## Risk Assessment

- A broad mock ban can catch test fixtures or previews incorrectly. The guard
  must operate from the route registry/release entry points, not a global grep.
- Cached learning/audio data can be sensitive. Default to no cache until its
  classification, encryption and logout purge behavior are proven.
