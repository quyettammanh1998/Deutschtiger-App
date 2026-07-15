---
phase: 3
title: "Exam Ecosystem Completion"
status: pending
priority: P1
effort: "1.5–2 tuần"
dependencies: []
---

# Phase 3: Exam Ecosystem Completion

## Context

Exam core (player Lesen/Hören, drafts, results, best scores) đã LIVE trong
Flutter. Web còn một vành đai tính năng exam mà chưa plan nào sở hữu. Backend
routes đã mount: `/api/v1/exam-readiness`, `/api/v1/user/exam-registrations`,
`/api/v1/exam-buddies`, community exam routes (exam domain), comments
(`/api/v1/comments`, 5). Web spec: `src/pages/exam/`, `src/pages/community/`.

Phối hợp: GĐ2 P4 có nhắc "exam readiness" trong sweep — phase này là owner
chính, GĐ2 P4 chỉ verify. Sprechen/Schreiben KHÔNG thuộc phase này
(MASTER P8 / GĐ2 P2).

## Requirements

1. **Exam dictation** (cloze dictation từ audio đề thi): dùng lại exam player
   audio widgets + text input; web `exam-dictation` là spec chấm/hiển thị.
2. **Exam readiness**: màn đánh giá mức sẵn sàng theo level/provider
   (`/exam-readiness`) — read-only score + gợi ý luyện.
3. **Exam schedule + registration**: lịch thi public + đăng ký
   (`/user/exam-registrations/*`); nhắc lịch qua reminders hiện có.
4. **Buddy finder** (`/exam-buddies`): list/join tìm bạn thi cùng — chỉ ship
   cùng lúc với block/report của GĐ2 P3 nếu có tương tác user-user; nếu
   read-only match list thì ship được trước.
5. **Community exams**: list + detail đề thi user-shared + comments. Comments
   web dùng Supabase realtime — mobile bắt đầu bằng poll/refresh, realtime để
   GĐ2 P3 quyết chung với social.
6. **De-thi public registry** (`/de-thi/:code`): route public không cần auth —
   deep-link vào practice; kiểm tra release deep-link guard cho route public mới.

## Files

- Create: `lib/screens/exam/` bổ sung (dictation, readiness, schedule,
  community list/detail), `lib/repositories/exam/` live impl mở rộng (thay
  mock `exam_repository.dart` legacy nếu còn), DTO `lib/data/exam/` mở rộng.
- Modify: exam landing/hub entry points, router + deep-link guards,
  reminders wiring.
- Reuse: exam player audio/question chrome widgets, comments widget viết một
  lần dùng cho community + moments (check GĐ2 P3 trước khi tạo).

## Validation

- Contract tests per endpoint family.
- Widget tests: dictation input/scoring states, registration flow, community
  list empty/error; German 200%.
- Emulator smoke: đăng ký 1 lịch thi + làm 1 dictation với backend local.

## Risks

- Community/UGC surface kéo theo nghĩa vụ moderation (Apple) — không bật
  comment-write trước khi GĐ2 P3 ship report/block; read-only trước.
- Dictation chấm phía client hay server — probe handler trước, tránh tự chế
  scoring khác web.
