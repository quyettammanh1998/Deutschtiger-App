---
phase: 5
title: "Stability and Release Operations"
status: pending
priority: P0
effort: "continuous; final gate 1w"
dependencies: [1, 2, 3, 4]
---

# Phase 5: Stability and Release Operations

## Overview

Run reliability and release operations from the first GĐ2 alpha through staged
production rollout. This phase is continuous in execution but its final gate
cannot pass until the preceding feature phases meet their device/API evidence.

## Requirements

- Crash/error telemetry includes route, feature/version and privacy-safe user
  correlation without message, draft or token content.
- Mobile lifecycle failures—permission deny, audio interruption, network flap,
  malformed nullable API payload, deep-link/push auth redirect, and app kill—
  have a tested non-crashing path.
- Release trains have reproducible version/build, signed artifact, metadata and
  staged rollout procedures.

## Architecture

```text
Flutter error/lifecycle boundary
  → privacy-safe Crashlytics + event breadcrumb
  → alert threshold / triage owner
  → isolated hotfix or staged release
  → verification log and post-incident guard
```

Crash handling and release evidence remain separate from feature state: a
telemetry failure must never block the learner's local recovery/error UI.

## Related Code Files

- Modify: `lib/main.dart`, `lib/services/crash_service.dart`, `lib/services/event_tracking.dart`, `lib/services/force_update_service.dart`
- Modify: CI/release scripts and platform build metadata only after reading the current deployment documentation
- Create: `docs/flutter-release-runbook.md`, `plans/260715-flutter-gd2-extended-coverage/reports/release-verification.md`
- Modify: tests for lifecycle, API parsing, routing and feature-specific critical paths

## Implementation Steps

1. Define telemetry schema and redaction policy. Capture Flutter/framework/zone
   errors, route, app version and a one-way user correlation; verify reports do
   not contain tokens, message text, writing drafts or recordings.
2. Add reliability scenarios to every feature phase: async after dispose,
   malformed/null API field, no permission, no network, reconnect storm, audio
   interruption, low-memory image decode, background/kill and deep link/push
   into an auth-gated route.
3. Make API parsing forward compatible: defaults/nullable models, typed error
   surfaces and Crashlytics capture without fatal parse crashes. Parse large
   exam/media payloads off the animation-critical path when profiling proves
   jank.
4. Establish release runbook: version/build number, signing ownership, internal
   → TestFlight/closed test → staged production sequence, rollback/hotfix path,
   Data Safety/Privacy Nutrition Label checklist and screenshot updates.
5. Define operational thresholds and owners: crash-free at least 99.5%, monitor
   Android ANR/Play vitals, investigate new crash affecting >1% sessions in one
   hour, and retain verification evidence for each rollout step.
6. Run a full release rehearsal on signed beta artifacts: smoke every enabled
   capability, run device matrix, check telemetry arrival/redaction, simulate
   rollback and record results.

## Success Criteria

- [ ] All enabled GĐ2 critical journeys survive lifecycle/network/permission
  failures with a recoverable UI and telemetry breadcrumb.
- [ ] Crash reports are received with route/version context and no prohibited
  sensitive content in inspected samples.
- [ ] A signed Android and iOS beta pass the documented smoke/device matrix;
  store metadata exactly matches active permissions/data collection.
- [ ] Release runbook includes staged rollout, halt/rollback criteria and a
  completed rehearsal log.
- [ ] Production stability evidence meets the stated crash-free threshold over
  the agreed observation window before declaring full GĐ2 coverage complete.

## Risk Assessment

- Green unit tests do not measure ANR, OEM audio behavior or store metadata
  correctness. Maintain a physical-device and beta-release gate.
- Telemetry can become a privacy leak; treat redaction as a behavior that must
  be inspected and tested, not a documentation promise.

## Success Criteria

- [ ] ...
