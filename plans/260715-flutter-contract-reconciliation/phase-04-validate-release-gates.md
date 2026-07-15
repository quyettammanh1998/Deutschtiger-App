---
phase: 4
title: "Validate Release Gates"
status: pending
priority: P0
effort: "2–3d plus device/store wait"
dependencies: [2, 3]
---

# Phase 4: Validate Release Gates

## Overview

Turn implemented contracts into release evidence. This is a gate for Phase 4
exam completion and Phase 6 store submission—not a substitute for their UI or
store-listing work.

## Requirements

- Test backend routes with an authenticated disposable account, not production
  user data.
- Test Flutter on at least one physical Android and iOS device for auth,
  deletion, deep links, audio and exam resume.
- Record exact command, expected result, actual result, date and build/API
  version in the verification log.

## Related Code Files

- Create: `plans/260715-flutter-contract-reconciliation/reports/release-gate-verification.md`
- Modify: relevant Flutter widget/integration tests and Go integration tests
- Modify: store submission checklist only after every prerequisite is evidenced

## Implementation Steps

1. Run `flutter analyze`, focused Flutter tests, `flutter test`, and the
   backend package/router/integration suites introduced in Phases 2–3. Do not
   collapse failures from unrelated stale snapshots into a false green result.
2. With a disposable account, capture authenticated curl/API evidence for
   account deletion, restore/purge lifecycle, selected-deck SRS queue/review,
   exam draft create/autosave/resume/submit, and no cross-user access.
3. Run device QA: native Google/iOS Apple sign-in, reset deep link, device-kick
   modal, account deletion, offline/reconnect, recorded/TTS playback, exam
   audio limit, terminate-and-resume draft.
4. Verify public deletion URL, AASA/assetlinks content and build metadata
   against the actual deployed release environment.
5. Append results in the project verification-table format; only then remove
   the master plan's reconciliation blocker and advance downstream phase status
   using `ck plan check`.

## Success Criteria

- [ ] All new focused contract tests are green and full Flutter test/analyze
  output is recorded.
- [ ] Authenticated curl evidence proves each newly introduced route and its
  ownership/error behavior.
- [ ] Android and iOS manual flows meet the device gates with build identifiers.
- [ ] The verification log has no unresolved required failure; downstream plan
  links/status accurately reflect the evidence.

## Risk Assessment

- Store policies and real identity providers cannot be proven by mocked unit
  tests. Keep them as manual release gates even when CI is green.
