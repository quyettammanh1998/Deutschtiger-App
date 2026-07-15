---
title: "Flutter Port Phase 0–8: GĐ1 Launch + GĐ2 IAP + Voice"
description: "Roadmap GĐ1/GĐ2. Các hợp đồng account, learning và exam phải được chốt trong plan reconciliation trước các release gate phụ thuộc."
status: in_progress
priority: P2
branch: "main"
tags: []
blockedBy: [260715-flutter-contract-reconciliation, 260715-flutter-cross-cutting-readiness]
blocks: [260715-flutter-gd2-extended-coverage]
created: "2026-07-10T09:45:55.587Z"
createdBy: "ck:plan"
source: skill
---

# Flutter Port Phase 0–8: GĐ1 Launch + GĐ2 IAP + Voice

## Overview

Port giao diện web DeutschTiger (React 19 + TS) → Flutter iOS+Android. App đã có ~131 màn, mục tiêu hoàn thiện GĐ1 (~35 màn lõi, submit store) và bắt đầu GĐ2 (IAP + Voice). Reference: `thamkhao/deutschtiger-frontend/plans/260706-0232-flutter-app-port/`

**Quyết định đã chốt:** R2 SiA GĐ1 | R3 device cap 3 | R4 phone-only portrait | R6 giá 99/349/449k | R7 report AI bắt buộc | R8 xoá account in-app + web.

### Trạng thái thực thi đã đối chiếu (15/07/2026)

Phase 1–6 có code và audit, nhưng chưa phase nào đủ evidence để chuyển `completed`.
Các contract trong plan gốc không còn khớp hoàn toàn server hiện tại: client gọi
`DELETE /user/profile` trong khi backend chưa có route này và kế hoạch backend
đã chọn `DELETE /user/account` soft-delete 7 ngày; exam draft code is now
additive and server-authoritative in source but still lacks live
Postgres/API evidence; My Words/decks/heartbeat dùng contract khác bản mô tả
ban đầu.
Plan [Contract Reconciliation](../260715-flutter-contract-reconciliation/plan.md)
là release gate bắt buộc cho Phase 4 exam và Phase 6 store submission. Nó không
thay thế scope port UI của roadmap này.

## Phases

| Phase | Tên | GĐ | Ước | Status |
|-------|-----|----|-----|--------|
| 1 | [Phase 0: Foundation — dọn dẹp + tokens + API](./phase-01-phase-0-foundation.md) | 1 | 3–4 ngày | In progress |
| 2 | [Phase 1: Design System + Shell + Shared Widgets](./phase-02-phase-1-design-system-shell.md) | 1 | 1 tuần | In progress |
| 3 | [Phase 2: Auth + Device + Xoá tài khoản](./phase-03-phase-2-auth-device-delete.md) | 1 | 1 tuần | Blocked by deployed BE + links |
| 4 | [Phase 3: Lõi học — Vocab (C1–C4) + Shared Media Widgets](./phase-04-phase-3-core-learning-vocab.md) | 1 | 2.5 tuần | In progress |
| 5 | [Phase 3b: FSRS Daily Review + Flashcards + Learn Hub](./phase-05-fsrs.md) | 1 | (trong 3) | In progress |
| 6 | [Phase 3c: Dashboard B1 + Mission B2–B3](./phase-06-dashboard.md) | 1 | (trong 3) | In progress |
| 7 | [Phase 4: Exam Player Lesen+Hören (D1–D5)](./phase-07-phase-4-exam-player-lesen-h-ren.md) | 1 | 3 tuần | In progress |
| 8 | [Phase 5: Màn GĐ1 còn lại (Reading, Grammar, Games, AI, Stats, Settings)](./phase-08-phase-5-remaining-g-1-screens.md) | 1 | 2 tuần | Pending |
| 9 | [Phase 6: Store Submission — TestFlight + Closed Testing](./phase-09-phase-6-store-submission.md) | 1 | 1 tuần + chờ | Pending |
| 10 | [Phase 7: IAP RevenueCat + Entitlement Unification](./phase-10-phase-7-iap-revenuecat.md) | 2 | 2–3 tuần | Pending |
| 11 | [Phase 8: Voice Recording + Sprechen + Pronunciation](./phase-11-phase-8-voice-recording-sprechen.md) | 2 | 3 tuần | Pending |

## Blockers cần xử lý trước khi submit store

1. **Account deletion contract:** client `DELETE /api/v1/user/profile` chưa được đăng ký. Backend plan đề xuất `DELETE /api/v1/user/account`, soft-delete 7 ngày, re-auth và purge/anonymize. Không ship hoặc test UI xoá tài khoản cho đến khi một contract được chọn và implement.
2. **Trang web `/delete-account`** — Google Data Safety bắt buộc URL; nội dung phải dùng cùng account-deletion contract.
3. **AASA + assetlinks.json trên nginx** — deep links iOS/Android → Phase 2.
4. **Exam draft lifecycle:** additive create/get/PATCH/submit code, canonical
   question references, server scoring and Flutter resume are implemented. A
   disposable Postgres/API run plus device resume/audio evidence is still
   required before Phase 4 can close.
5. **BE: cột `source: sepay|apple|google`** trong `payments`/`user_purchases` → Phase 7.

## Thứ tự tiếp tục

1. Thực hiện [Contract Reconciliation](../260715-flutter-contract-reconciliation/plan.md) trước, bắt đầu bằng quyết định account deletion.
2. Sau khi contract tests đã xanh, hoàn thiện Phase 4–6 theo dependency hiện có.
3. Chỉ chuyển phase sang `completed` khi acceptance criteria của phase và manual device/live-service gates đều có evidence ghi trong verification log.
4. Sau IAP + Voice, tiếp tục [GĐ2 Extended Coverage](../260715-flutter-gd2-extended-coverage/plan.md) cho media, Schreiben, social/push, fidelity và release operations.
5. Hoàn thành [Cross-Cutting Readiness](../260715-flutter-cross-cutting-readiness/plan.md) trước store submission: secrets/privacy, accessibility/i18n, live-data/export/offline policy và CI/fidelity automation.
