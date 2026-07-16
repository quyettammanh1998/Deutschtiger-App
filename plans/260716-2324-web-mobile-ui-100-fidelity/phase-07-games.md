# Phase 07 — Games

Scout: `scout-260716-2324-ui-fidelity-flashcard-grammar-games-report.md` (games).
Phụ thuộc P1 (GameShell, icons, assets tiger-frames/obstacles).

## Màn & verdict

| Web | Flutter target | Việc |
|---|---|---|
| `/games` hub | `game_hub_screen.dart` | Rebuild: grouped cards + mascot + LevelTip + shadowing banner; bỏ search/tabs/difficulty/mock-stats tự chế |
| `/games/runner` | `runner_game_screen.dart` | Tiger sprite + obstacle assets (P1), leaderboard panel, personal-best banner |
| `/games/artikel` | `article_game_screen.dart` | Adopt GameShell; route rename `/games/article`→`/games/artikel` |
| `/games/wortstellung` | `word_order_game_screen.dart` | GameShell + level chip; route rename |
| `/games/konjugation` | `konjugation_game_screen.dart` | GameShell; title/subtitle format |
| `/games/listening` | `listening_game_screen.dart` | GameShell + shuffle toggle + retry-wrong |
| `/games/typing-sprint` | `typing_sprint_game_screen.dart` | Per-char typing surface coral, WPM chips, results modal |
| `/games/word-sprint` | `word_sprint_game_screen.dart` | GameShell, shuffle, topic-change |
| `/games/speaking` | `speaking_game_screen.dart` | GameShell; variant `?daily=1` + avg-score screen (voice gate giữ) |
| `/games/cases-mastery` | `cases/cases_mastery_hub_screen.dart` | Icon gradient thay tint phẳng; banner; dark mode |
| `/games/cases-{akk-dat,adjektiv,wechselprep}` | `cases/case_cloze_quiz_screen.dart` | GrammarDrillIntro/Result, streak, colored option grid, AI explain; bỏ level dropdown thừa; routes theo web |
| `/games/cases-verb-case` | `cases/verb_case_quiz_screen.dart` | Như trên |
| `/games/sentence-builder` topics | `sentence_builder_topics_screen.dart` | Card icon-gradient chọn được + sticky CTA |
| `/games/sentence-builder/preview` | mới | Word preview page (đang bị skip) |
| `/games/sentence-builder/play` | `sentence_builder_play_screen.dart` | Plays counter, sticky blur header, confetti, exit guard |

## Xóa

- `conversation_game_screen.dart`, `pronunciation_game_screen.dart`,
  `lib/screens/quiz/*` (không web counterpart).

## Validation

- Từng game: flag riêng giữ nguyên; analyze + games tests; exit-guard test.
- Screenshot hub + 3 game đại diện so web.

## Risks

- GameWallOverlay/FreeLimitOverlay (premium) — hiển thị theo flag premium off
  ⇒ prod chưa thấy; CTA IAP chờ MASTER P7 (Quyết định #5).
