---
phase: 2
title: "Learn Extensions + Practice Modes"
status: pending
priority: P1
effort: "1.5–2 tuần"
dependencies: []
---

# Phase 2: Learn Extensions + Practice Modes

## Context

Web learn domain có 6 surface Flutter chưa có, cộng practice runner theo deck
và sentence builder. Backend routes đã mount: `/api/v1/user/learn` (12),
`/api/v1/learning-items` (7), `/api/v1/focus-session`, `/api/v1/user/learner-model`,
`/api/v1/sentence-builder/*`, `/api/v1/subtitle-words`. Web
`src/pages/learn/`, `src/pages/practice/` là spec hành vi.

## Requirements (thứ tự ưu tiên)

1. **Practice modes** (giá trị học tập cao nhất): runner theo deck với 4 mode
   cloze / listening / matching / writing. Flutter đã có game screens tương tự
   trong `lib/screens/games/` — TÁI DÙNG widget/lifecycle từ đó thay vì viết
   mới; khác biệt là nguồn item = deck của user (flashcard repo live sẵn).
2. **Can-Do practice**: CEFR can-do task list + session (web
   `can-do-practice-page`); endpoints trong `/user/learn/*` — probe trước.
3. **Topic explore**: browse topic → learning items.
4. **Focus session**: timed study session, start/stop log qua `/focus-session`.
5. **Learner model**: màn read-only capability map / skill estimates
   (`/user/learner-model`) — chart đơn giản, không cần parity pixel với web.
6. **Sentence builder**: topics/preview/play (`/sentence-builder/*`) — nếu
   games sweep GĐ2 P4 chưa nhận, làm ở đây; điều phối để không làm 2 lần.
7. **Subtitle words**: list từ mined từ video (`/subtitle-words`) — màn list +
   save-to-deck, gắn vào vocab hub.

## Files

- Create: `lib/screens/learn/` (can_do, topic_explore, focus_session,
  learner_model), `lib/screens/practice/` (runner + 4 mode),
  `lib/repositories/learn/`, DTO `lib/data/learn/`.
- Modify: learn hub screen (entry points), router, flags nếu rollout dần.
- Reuse: `lib/screens/games/` widgets, flashcard/deck repos.

## Validation

- Contract tests cho learn/practice repos.
- Widget tests: mỗi mode 1 happy path + empty deck + error; German 200%.
- Emulator smoke: 1 practice session end-to-end ghi progress lên server.

## Risks

- `/user/learn` route semantics chưa document — đọc Go handler
  (`internal/feature/learning/`) làm spec, không đoán.
- Practice modes dễ phình scope — mode nào backend thiếu endpoint thì ghi gap
  vào api-changelog và bỏ qua, không độn local-only.
