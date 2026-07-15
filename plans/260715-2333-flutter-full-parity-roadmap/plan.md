---
title: "Flutter Full Parity Roadmap — AI Chat, Learn Extensions, Exam Ecosystem, Residual"
description: >-
  Phủ nốt các tính năng web chưa plan nào sở hữu, để Flutter đạt đầy đủ tính
  năng như web hiện tại. Đọc cùng docs/web-feature-parity-matrix.md.
status: pending
priority: P1
branch: main
tags:
  - flutter
  - feature-parity
  - ai
  - learning
  - exam
blockedBy:
  - 260715-2321-gd1-closeout-coding-wave
blocks: []
created: "2026-07-15T23:33:00+07:00"
createdBy: "claude"
source: parity-audit
---

# Flutter Full Parity Roadmap

## Overview

Inventory 15/07/2026 (web frontend ~30 domain, backend 554 routes) đối chiếu
với Flutter cho thấy phần lớn tính năng đã có owner trong 3 plan active +
close-out wave. Plan này chỉ chứa phần **chưa plan nào sở hữu**. Ma trận đầy
đủ + bảng owner: `docs/web-feature-parity-matrix.md`.

KHÔNG thuộc plan này (đã có owner): media/youtube/courses (GĐ2 P1), Schreiben
(GĐ2 P2), social/duel/push/FCM (GĐ2 P3), games/news/error-patterns (GĐ2 P4),
IAP (MASTER P7), voice/Sprechen/pronunciation (MASTER P8), deletion/export/
live-surfaces/CI (WAVE). Web-only không port: SEO pages, admin, PWA service
worker, SePay QR web flow.

## Phases

| Phase | Name | Phụ thuộc | Status |
|-------|------|-----------|--------|
| 1 | [AI Chat + Tiger AI Live (SSE)](./phase-01-ai-chat-and-tiger-ai-live.md) | WAVE P1 xong là làm được | Done with concerns |
| 2 | [Learn Extensions + Practice Modes](./phase-02-learn-extensions-and-practice-modes.md) | không | Done (16/07) |
| 3 | [Exam Ecosystem Completion](./phase-03-exam-ecosystem-completion.md) | exam core evidence (WAVE P1) | Done — buddy contact + community write chờ GĐ2 P3 |
| 4 | [Notifications Center + Residual Parity](./phase-04-notifications-center-and-residual-parity.md) | GĐ2 P3 (push), MASTER P8 (voice cho speak-to-notes) | Done phần không phụ thuộc — còn speak-to-notes (voice), groups (gated), FCM push |

## Nguyên tắc chung (áp cho mọi phase)

- Contract trước code: mọi endpoint mới dùng phải ghi vào
  `docs/flutter-api-contract-matrix.md` + `docs/api-changelog.md`, probe
  response shape thật (curl/Go handler), không code theo mock model.
- String mới → ARB vi/en/de + widget test German 200%.
- Repo mới thay mock phải pass release-live-data guard trước khi bật flag.
- SSE client dùng chung một implementation (Phase 1 dựng, các phase sau tái dùng).
- Screen mới theo cấu trúc `lib/screens/<domain>/` + repo `lib/repositories/` +
  DTO `lib/data/`; check module hiện có trước khi tạo mới.

## Acceptance (toàn plan)

- [ ] Mọi dòng `PARITY` trong ma trận parity chuyển sang LIVE có evidence.
- [ ] Không còn domain web nào (ngoài mục "không port") thiếu owner hoặc thiếu
      implementation trong Flutter.
- [ ] Ma trận parity được cập nhật mỗi khi một dòng đổi trạng thái.

## Thứ tự khuyến nghị toàn cục

WAVE (GĐ1 close-out) → MASTER P9 store → MASTER P10–P11 (IAP, voice) song song
PARITY P1 → GĐ2 P1–P3 xen PARITY P2–P3 → PARITY P4 + GĐ2 P4–P5.

## Deferred decisions (owner chốt 15/07/2026: tạm bỏ qua)

1. Affiliate mobile — giữ nguyên hiện trạng, không code thêm.
2. WebRTC calls — loại khỏi scope GĐ2 P3 và plan này.
3. SePay Android — không port; IAP-only (MASTER P7).

Không phase nào trong plan này được implement 3 mục trên cho đến khi owner
mở lại quyết định.
