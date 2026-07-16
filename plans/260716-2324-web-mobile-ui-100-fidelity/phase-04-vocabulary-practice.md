# Phase 04 — Vocabulary & practice

Scout: `scout-260716-2324-ui-fidelity-learn-vocab-practice-report.md` (vocab+practice).

## Màn & verdict

| Web | Flutter target | Việc |
|---|---|---|
| `vocabulary-page.tsx` (`/vocabulary`) | `lib/features/vocabulary/presentation/vocabulary_screen.dart` | Thêm tab 4 "⭐ Của tôi" (nhúng MyWordsOverview), WordSprint widget, PageIntro, tip card; tabs gradient; đủ 13 goals |
| `vocabulary-detail-page.tsx` (`/vocabulary/:slug`) | `vocabulary_detail_screen.dart` | Rebuild đúng concept: topic word-list (search, tabs, mastery bar, weak filter, sticky practice bar) — màn hiện tại đang là single-word view |
| `vocabulary-lesson-page.tsx` | `vocabulary_lesson_screen.dart` | Rebuild: mode select → SRS session, 7 card renderers, rating grid 😬🤔🙂😎 |
| `vocabulary-word-page.tsx` (+sub-components, practice-views) | `vocabulary_word_screen.dart` | Rebuild: pill/badge row, gender bar, star Đã thuộc, YouGlish, conjugation, practice games/sheets |
| `daily-review-page.tsx` (`/daily-review`) | `lib/screens/daily_review/*` | Bỏ start screen tự chế; mini-game playlist theo web; DailyReviewDone (accuracy/XP/weak words) |
| `subtitle-words-page.tsx` | `lib/screens/vocab/subtitle_words_screen.dart` | Card rows ring-selection, level pills, select-all bar, sticky bottom CTA (bỏ CheckboxListTile+FAB) |
| MyWordsOverview (trong /vocabulary) | `lib/features/my_words/presentation/my_words_screen.dart` | 3 nhóm emoji-headed + source + context quotes; bỏ standalone SegmentedButton (nhúng vào tab vocab) |
| `practice-page.tsx` (`/notes/:deckId/practice`) | `lib/screens/practice/practice_screen.dart` + selector/results | 13 gradient mode cards thay 4 flat icons; results: XP pill + confetti, bỏ trophy tự chế |
| `practice-cloze-page.tsx` (`/games/cloze`) | `practice_cloze_view.dart` | Inline underlined blank thay `_____`; hint/edit/audio/XP; route `/games/cloze` (redirect `/games/fill-blank`) |
| `practice-listening-page.tsx` (`/games/flashcards`) | mới (thay `practice_listening_view.dart`) | Flip-card ListeningPlayer: speed/auto-replay/settings — hiện là MCQ sai concept |
| `practice-matching-page.tsx` (`/games/matching`) | `practice_matching_view.dart` | Rounds + pink-rose bar + XP + column labels; selection tím; shake/audio |
| `practice-writing-page.tsx` (`/games/writing`) | `practice_writing_view.dart` | Nghe pill, umlaut bar, diff display, reinforce loop, mic (mic gate theo voice flag) |

## Xóa

- `lib/screens/vocab_search/vocab_search_screen.dart` (không có web counterpart;
  search nằm trong trang từ vựng web).
- **5 màn game legacy routed** (v2 — reviewer phát hiện chưa ai own):
  `fill_blank/flashcard/matching/writing_word/writing_sentence_game_screen.dart`
  (app_router 92-96, 401, 409) — bị thay bởi 4 practice view mới ở trên;
  `/games/writing-sentence` không có web counterpart → xóa route (không redirect);
  các route cũ khác redirect về route web tương ứng.
- Router ownership: phase này sở hữu 4 route `/games/{cloze,flashcards,matching,writing}`
  trong route file domain (P1 đã tách); phần `/games/*` còn lại thuộc P7.
- Cập nhật guard list `release_live_data_guard_test.dart` theo protocol plan.md.
- Route contract — ĐÃ XÁC MINH 17/07: web dùng `/vocabulary/:slug` với slug dạng
  `topic-{key}` / `level-{level}` / plain, resolve slug→topic CLIENT-SIDE từ
  `GET /vocabulary/topics` (vocabulary-detail-page.tsx:134-147) — không cần
  endpoint backend mới. Flutter làm giống: route `/vocabulary/{slug}` + resolve
  client-side; redirect từ `/vocabulary/detail/{key}` cũ.

## Validation

- Practice views là round types cho mission runner (P3) + daily review — chạy
  regression cả 3 flow.
- `flutter test` vocab/practice/daily_review; l10n test; analyze sạch.

## Risks

- Umlaut bar + diff view lấy từ P1 primitives (đã hoist, v2) — không tự dựng.
