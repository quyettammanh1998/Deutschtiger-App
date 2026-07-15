---
title: "Flutter GĐ2 Extended Coverage — Media, Writing, Social, Reliability"
description: "Mở rộng roadmap sau IAP/Voice: media, Schreiben, social/push, coverage parity và release reliability."
status: pending
priority: P1
branch: "main"
tags: [flutter, phase-2, media, writing, social, release]
blockedBy: [260710-1644-flutter-port-phase-0-to-8]
blocks: []
created: "2026-07-14T17:48:01.197Z"
createdBy: "ck:plan"
source: skill
---

# Flutter GĐ2 Extended Coverage — Media, Writing, Social, Reliability

## Overview

Hoàn tất các surface GĐ2 chưa nằm trong Flutter Port Phase 0–8, theo reference
plan Phase 09–13. Các màn hiện có là điểm xuất phát, không phải evidence rằng
feature đã hoàn thành: mỗi phase yêu cầu backend contract, lifecycle dữ liệu,
compliance và validation trên thiết bị.

## Prerequisites and scope

- GĐ1 store release, IAP/entitlement và voice foundation của
  `260710-1644-flutter-port-phase-0-to-8` phải hoàn thành trước khi bắt đầu
  phase phụ thuộc. Plan đó hiện bị chặn bởi contract reconciliation.
- Không backport video background playback cho YouTube. Background audio chỉ
  cho media do DeutschTiger tự host.
- UGC/realtime không được ship cho đến khi user report + block thực sự hoạt
  động; Firebase packages ở Flutter không chứng minh FCM/APNs backend có sẵn.
- Mọi API mới phải đi qua `docs/flutter-api-contract-matrix.md` và
  `docs/api-changelog.md` trước khi implementation.

## Phases

| Phase | Name | Status |
|-------|------|--------|
| 1 | [Media and Learning Video](./phase-01-media-and-learning-video.md) | Pending |
| 2 | [Schreiben and AI Grading](./phase-02-schreiben-and-ai-grading.md) | Pending |
| 3 | [Social Realtime and Push](./phase-03-social-realtime-and-push.md) | Pending |
| 4 | [Remaining Coverage and Fidelity](./phase-04-remaining-coverage-and-fidelity.md) | Pending |
| 5 | [Stability and Release Operations](./phase-05-stability-and-release-operations.md) | Pending |

## Dependencies

- Blocked by [Flutter Port Phase 0–8](../260710-1644-flutter-port-phase-0-to-8/plan.md): IAP entitlement and voice permission/grading foundations are required.
- Reference: `thamkhao/deutschtiger-frontend/plans/260706-0232-flutter-app-port/phase-09-*` through `phase-13-*`.
- Contract gate: [Flutter Contract Reconciliation](../260715-flutter-contract-reconciliation/plan.md) remains upstream through the master Flutter plan.

## Cross-plan acceptance

- [ ] Every GĐ2 feature has one tested Flutter ↔ backend contract and uses `ApiClient` bearer authentication.
- [ ] New permissions, data collection and store metadata are updated in the same release that enables the capability.
- [ ] No plan status advances from source-file existence alone; each phase needs its stated device/API evidence.

## Open questions

None for plan creation. Vendor and pricing selections are deliberately deferred
to implementation POCs; a failed POC must select its documented fallback before
the corresponding UI is enabled.
