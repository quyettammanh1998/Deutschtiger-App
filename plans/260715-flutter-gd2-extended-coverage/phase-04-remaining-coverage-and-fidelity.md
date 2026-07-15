---
phase: 4
title: "Remaining Coverage and Fidelity"
status: pending
priority: P2
effort: "2–3w"
dependencies: [1, 2, 3]
---

# Phase 4: Remaining Coverage and Fidelity

## Overview

Close the coverage matrix only after major platform capabilities have shipped.
This phase is a controlled sweep for remaining GĐ2 screens, not permission to
mark a route done because a similarly named Dart file exists.

## Requirements

- Each matrix row has an owner, route, backend contract, feature flag state and
  two-theme/two-viewport fidelity evidence.
- Enable More sheet entries only when their destination, loading/error states
  and auth guard are usable.
- Keep web-only behavior explicitly classified rather than copying it as a
  misleading mobile placeholder.

## Architecture

```text
CoverageMatrixRow
  ├── source route + target Flutter route
  ├── API/permission/feature-flag contract
  ├── state fixtures: loading | empty | error | success
  └── evidence: route test + golden/device capture + owner sign-off
```

The matrix is the release inventory. A feature flag may expose an entry only
when its row has all required evidence; navigation is not used as a substitute
for completion.

## Related Code Files

- Modify: `docs/plan-flutter-app-port-from-web-frontend-09-07-2026.md` coverage matrix and add per-screen evidence references
- Modify: remaining `lib/screens/games/**`, `lib/screens/reading/**`, `lib/screens/stats/**`, `lib/screens/settings/**`, `lib/shared/widgets/more_features_sheet.dart`
- Create: scenario/golden tests under `test/features/**` plus fidelity fixtures
- Modify: `lib/navigation/app_router.dart` only with route/navigation tests

## Implementation Steps

1. Convert every remaining GĐ2 row into a checked inventory record: source web
   route, Flutter route, API owner, gate, fixture, required device permission
   and exact definition of done. Remove duplicate/stale screen candidates first.
2. Finish remaining games and cases/Deutsch Runner with reusable game lifecycle,
   result persistence and accessibility. Do not enable a game whose score or
   retry behavior is local-only when web is server-backed.
3. Finish extended learning/read/news/exam readiness/error-patterns/settings
   and AI attachment surfaces in dependency order. Camera/photo upload needs a
   separate permission, privacy disclosure and backend size/content policy.
4. Remove GĐ1 feature flags in the More sheet incrementally. Each enabled item
   needs an authenticated navigation test, loading/error/empty state and
   analytics event before it becomes discoverable.
5. Capture Flutter golden/device screenshots against the reference web mobile
   view for both light/dark themes and narrow/wide phone widths; document known
   intentional platform differences.

## Success Criteria

- [ ] Every GĐ2 coverage-matrix row is `done`, `web-only` with a reason, or
  has a scoped follow-up—not an unverified file-exists claim.
- [ ] More sheet, bottom navigation and Tiger AI entry points lead only to
  complete, guarded features.
- [ ] Each enabled remaining screen has success, loading, empty and error state
  coverage plus route and golden/device evidence.
- [ ] No user-visible deprecated pricing, GĐ1 placeholder or unavailable
  feature copy remains in enabled GĐ2 flows.

## Risk Assessment

- A large catch-all phase can hide regressions. Keep feature work in small
  vertical slices and rerun matrix audit after every slice.

## Success Criteria

- [ ] ...
