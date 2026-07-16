# Phase 05 — Decks/flashcards suite

Scout: `scout-260716-2324-ui-fidelity-flashcard-grammar-games-report.md` (flashcard).

## Màn & verdict

| Web | Flutter target | Việc |
|---|---|---|
| `/notes` deck list (`flashcard-page.tsx`) | `lib/screens/decks/deck_list_screen.dart` | Folders, starred, default-star, mastery bar, PageIntro, sprint widget, bottom action sheet, `MyNotesSection` compact (flashcard-deck-list.tsx:182) |
| `/notes/:id` deck detail | `deck_detail_screen.dart` | Rebuild toàn bộ (web 924 dòng vs stub 63): tabs, search, filters, mastery, audio gen, sticky bar Học/Chơi |
| `/notes/:id/new`, `/edit` | mới | Card form (front/back, ví dụ, audio) |
| `/notes/folder/:id`, `/starred` | mới | Folder detail + starred view |
| `/notes/:id/lesson` guided lesson | mới | Mode selector + round manager + batch summary (tái dùng practice views P4 — phase này PHỤ THUỘC P4, đã ghi bảng plan.md) |
| `/notes/speak` (`speak-to-notes-page.tsx`) | mới | UI mic→text→deck theo web; live voice gate MASTER P8 flag (dựng UI, chưa wire STT) |

## Xóa

- `flashcard_review_screen.dart` (Flutter-only), route `/decks/*` → đổi `/notes/*`
  + redirects (Quyết định #4).

## Validation

- Deck CRUD flows chạy trên contract live hiện có (repo decks đã LIVE — giữ
  data layer, chỉ thay UI).
- analyze + test decks/flashcard pass; l10n mới đủ vi/en/de.

## Risks

- Deck detail lớn — modularize widgets vào `lib/screens/decks/widgets/`.
- Speak-to-notes phụ thuộc voice: UI xong nhưng flag off tới MASTER P8.
