---
title: 'Flutter Contract Reconciliation — Account, Learning, Exam Release Gates'
description: >-
  Chốt các API contract đang lệch giữa Flutter, backend và roadmap trước Phase 4
  exam và submit store.
status: in-progress
priority: P0
branch: main
tags:
  - flutter
  - backend-contract
  - release-gate
  - store-compliance
blockedBy: []
blocks:
  - 260710-1644-flutter-port-phase-0-to-8
created: '2026-07-14T17:40:30.592Z'
createdBy: 'ck:plan'
source: skill
---

# Flutter Contract Reconciliation — Account, Learning, Exam Release Gates

## Overview

Đưa roadmap Flutter về contract có thể thực thi. Audit ngày 15/07/2026 xác
nhận code Flutter đã tiến đến Phase 1–6, nhưng các API ghi trong plan cũ không
phải lúc nào cũng tồn tại hoặc có cùng semantics ở bundled Go backend. Plan này
không thay thế port UI: nó tạo source-of-truth, contract tests và release
evidence cho các dependencies chặn GĐ1.

## Evidence baseline

- Flutter gọi `DELETE /user/profile`; Go router chỉ mount `GET`/`PUT /profile`.
- Backend account plan đã chọn `DELETE /user/account`, re-auth, soft-delete bảy
  ngày, restore, rồi purge/anonymize; một vài retention/community decisions vẫn
  cần owner chốt.
- `GET /user/my-words`, `/user/flashcard-decks`, `/user/srs/queue`,
  `/user/heartbeat` là contract server đang mount. Chúng khác một số URL/copy
  trong roadmap cũ.
- Exam attempts hiện append-only (`POST`/list `GET`), nên chưa thể autosave,
  resume hoặc enforce audio plays theo một draft server-authoritative.

## Phases

| Phase | Name | Status |
|-------|------|--------|
| 1 | [Freeze Current Contracts](./phase-01-freeze-current-contracts.md) | In Progress |
| 2 | [Resolve Account Deletion Contract](./phase-02-resolve-account-deletion-contract.md) | Pending |
| 3 | [Close Learning and Exam Gaps](./phase-03-close-learning-and-exam-gaps.md) | Pending |
| 4 | [Validate Release Gates](./phase-04-validate-release-gates.md) | Pending |

## Dependencies

- Blocks [Flutter Port Phase 0–8](../260710-1644-flutter-port-phase-0-to-8/plan.md): Phase 4 exam and Phase 6 store submission must not be marked complete before Phase 4 here passes.
- Reuses backend design: `thamkhao/deutschtiger-backend/plans/260706-1113-account-deletion-data-export/`.
- Requires a product owner decision only for account-deletion semantics listed in Phase 2. All other mismatches are evidence-led engineering work.

## Acceptance criteria

- [ ] Exactly one API source of truth exists per Flutter call; generated or hand-written route/client tests reject drift.
- [ ] Account deletion is implemented, protected by re-auth, exercised end to end, and has a public web deletion URL before store metadata is submitted.
- [ ] Learning/deck and exam flows use server contracts that support their claimed behavior.
- [ ] Device and authenticated API evidence is recorded in the release gate verification log.

## Open decisions

1. Retain the backend proposal `/api/v1/user/account` with seven-day soft deletion and restore, or intentionally choose a different endpoint/lifecycle.
2. For public community contributions, anonymize versus hard-delete.
3. Payment retention period and fields under the applicable accounting/privacy policy.
