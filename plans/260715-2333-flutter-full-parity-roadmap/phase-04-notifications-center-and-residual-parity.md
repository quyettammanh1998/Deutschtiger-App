---
phase: 4
title: "Notifications Center + Residual Parity"
status: pending
priority: P2
effort: "1 tuần"
dependencies: [1]
---

# Phase 4: Notifications Center + Residual Parity

## Context

Các mảnh parity còn lại sau khi mọi plan khác hoàn thành. Phụ thuộc: GĐ2 P3
(FCM delivery) cho phần push; MASTER P8 (voice) cho speak-to-notes.

## Requirements

1. **In-app notification center**: màn list `/user/notifications/*` + unread
   count badge (web dùng realtime; mobile: poll `/user/unread-counts` +
   refresh khi FCM đến). Notification preferences
   (`/user/notification-preferences`) vào settings.
2. **Settings parity**: bổ sung mục còn thiếu so với web — AI Memory (đã có
   backend từ PARITY P1), Learning preferences, App-update check
   (`force_update_service` đã có — wire UI).
3. **Daily quote live**: `lib/screens/stats/daily_quote_page.dart` nối
   `/api/v1/quotes` thay data tĩnh.
4. **Subtitle words + speak-to-notes** (nếu chưa xong ở PARITY P2 / cần voice):
   speak-to-notes = ghi âm → transcribe (`/user/speech/transcribe-soniox`) →
   tạo flashcard; chỉ làm sau MASTER P8 có recording foundation.
5. **Groups/announcements**: nếu GĐ2 P3 không nhận groups
   (`/user/groups`, `/announcements`), thêm màn list/detail tối thiểu ở đây.
6. **Parity gate cuối**: đối chiếu từng dòng `docs/web-feature-parity-matrix.md`,
   cập nhật trạng thái; dòng nào không ship phải có lý do ghi trong matrix
   (decision/owner), không để trống.

## Files

- Create: `lib/screens/notifications/notification_center_screen.dart`,
  `lib/repositories/notifications/`.
- Modify: `lib/screens/settings/*`, `lib/screens/stats/daily_quote_page.dart`,
  home shell badge, `lib/services/force_update_service.dart` wiring.

## Validation

- Contract + widget tests như quy ước chung.
- Emulator smoke: nhận 1 push (từ GĐ2 P3 infra) → badge tăng → mở center →
  đánh dấu đã đọc.
- Parity matrix review cuối cùng có evidence link cho mọi dòng LIVE.

## Risks

- Unread-count poll interval vs battery — dùng khoảng thả lỏng (app resume +
  pull-to-refresh), không poll nền liên tục.
