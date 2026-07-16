# UI Fidelity Scout — Flashcard / Grammar / Games (mobile viewport)

Scope: web `thamkhao/deutschtiger-frontend` (source of truth, mobile = default tailwind classes) vs Flutter app. Date 2026-07-16.

## 0. Cross-cutting (systemic) divergences

These apply to nearly EVERY game screen and must be fixed once, shared:

1. **Page chrome**: Web games have NO AppBar. Pattern = scrollable page `bg-background px-4 pt-3 pb-5` with in-content header row: 36px bordered back button (`h-9 w-9 rounded-lg border border-border bg-card shadow-sm`, phosphor `CaretLeft`) + `text-xl font-bold` title (+ optional right-slot: ShuffleToggleButton / level chip). Flutter uses Material `AppBar` (often orange title) everywhere → visibly different.
2. **Game wall (paywall)**: every web game checks `useGamePlays(gameId)` → `GameWallOverlay` (gameName, playsUsed/maxPlays). Flutter: absent in ALL game screens.
3. **Exit guard**: web `usePracticeExitGuard` → `ConfirmDialog` "Thoát bài luyện tập?" (destructive). Flutter: back/close pops immediately.
4. **Completion card** (standard for artikel/wortstellung/listening/konjugation/cases/speaking/word-sprint): `ConfettiBurst` + centered card: "Hoàn thành!", `text-6xl font-extrabold text-primary` accuracy %, "{n}/{m} đúng", XP pill `bg-gradient-to-r from-amber-400 to-orange-500 rounded-xl` "⚡ +N XP", buttons "Chơi tiếp" (orange-500→orange-600 gradient) + "Quay lại" (btn-secondary), sometimes `WrongAnswerRetryButton`. Flutter: white rounded card, `48px tigerOrange %`, OutlinedButton "Về trang chủ" + ElevatedButton "Chơi lại" — no confetti, no XP pill, no retry-wrong.
5. **Colors**: web uses semantic tokens (`bg-card`, `text-foreground`, full `dark:` variants). Flutter hardcodes `Colors.white`, `Colors.blue.shade50` etc. → dark mode broken on most screens in scope.
6. **Icons**: web = phosphor / inline SVG stroke icons; Flutter = Material Icons. Different glyph language throughout.

## 1. Flashcard area

### 1.1 `/notes` — Deck list
- Web: `src/pages/flashcard/flashcard-page.tsx` (router) → `src/components/flashcard/flashcard-deck-list.tsx`.
- Mobile structure top→bottom: header (back + "Sổ từ" + subtitle "N bộ thẻ · M thư mục" + round orange gradient **+** button) → `PageIntro` (pageKey notes) → `MyNotesSection compact` (YouTube video notes row) → inline create-folder / create-deck forms (when open) → virtual **Starred** row (amber icon tile, count badge) → **Thư mục** section (card list, rotating 6-color folder icons, subfolder/deck counts) → "Tất cả decks" list: `card-sm` rows with default-deck star (amber, fill/outline), name + "Mặc định" badge, description, `DeckMasteryProgressBar` (segmented new/learning/known/mastered), 3-dot context menu (Chỉnh sửa / Chuyển vào thư mục), chevron → **Luyện tập nhanh** `FlashcardSprintWidget` → BottomSheet "Tạo mới" (Tạo bộ thẻ / Tạo thư mục / Nói ra ghi chú) → `MoveToFolderSheet`.
- Flutter: `lib/screens/decks/deck_list_screen.dart` — AppBar + simple Card rows (colored folder icon square, words count, single orange LinearProgressIndicator, popup edit/delete), AlertDialog create form.
- **Verdict: DIVERGENT (major)**. Missing: folders, starred view, default-deck star, mastery segments, PageIntro, notes row, sprint widget, action bottom sheet, inline edit; extra: delete in menu (web deletes from deck detail), cover-color icon.

### 1.2 `/notes/speak` — Speak to Notes
- Web: `src/pages/flashcard/speak-to-notes-page.tsx`. Structure: back + "Nói ra ghi chú" → card A (helper text, big `SpeechRecordButton`, pulsing orange "Đang nghe…" hint, red STT error) → editable textarea (orange border while recording, live streaming text, auto-scroll) → card B (deck name input default "Nói dd/MM", helper "Mỗi câu sẽ thành một thẻ…", emerald result box "Đã lưu N câu…, Xem bộ thẻ →", full-width orange gradient "Lưu vào Notes").
- Flutter: **MISSING** (no route, no screen).

### 1.3 `/notes/:deckId` — Deck detail
- Web: `src/components/flashcard/flashcard-deck-detail.tsx` (924 lines). Mobile: sticky header (back, editable deck name + pencil, "N thẻ", `DeckMasteryProgressBar`, emerald graduated bar "X/Y đã thuộc", tab bar **Danh sách / Từ của tôi**, search + weak-filter + star-filter) → `DeckAudioGenerator` banner → action bar (teal "Thêm thẻ", blue import, red delete) → paginated card list (20/pg) with star toggles, TTS, tappable words → spacer → **mobile sticky bottom bar `DeckLearnBottomBar` (Học / Chơi)** → practice-mode chooser view (Viết câu / Viết cloze / essay games, gradient icon tiles) → `FlashcardCountChooser`.
- Flutter: `lib/screens/decks/deck_detail_screen.dart` (63 lines) — AppBar + plain ListTile word list + FAB review. **Verdict: DIVERGENT (near-total rebuild)**.
- Missing subpages entirely: `flashcard-card-form.tsx` (`/notes/:deckId/new`, `/edit/:cardId`), `flashcard-folder-detail.tsx` (`/notes/folder/:id`), `flashcard-starred-view.tsx` (`/notes/starred`).

### 1.4 `/flashcard-review` (Flutter) — no direct web page
- Flutter `lib/screens/flashcard/flashcard_review_screen.dart` + widgets. Web flip-review runs inside deck detail practice modes / `deck-learn-bottom-bar` flows. Keep the FSRS logic but re-skin per web deck session, or fold into deck detail parity work.

## 2. Grammar area

### 2.1 `/grammar` — grammar-list-page.tsx
- Web mobile: back + "Ngữ pháp[ X]" header → offline-sync indicator (sky spinner / amber pending) → global search input (`card-sm`, inline SVG magnifier, clear ×) → if searching: result card (`divide-y`, green done rows w/ check circle, level pill badges emerald/sky/violet/amber/rose) → else if level: `GrammarLevelDetail` → else: **`GrammarMap`** ("Bản đồ ngữ pháp" — per-level topic chips, red "Hay sai · N" badges) + **`GrammarHome`** (2-col level cards: gradient header `from-emerald-500 to-emerald-600` etc., emoji, white SVG progress ring w/ count or check, desc line, 3 recommended lessons w/ numbered tinted circles, tinted "Xem tất cả →" pill button).
- `GrammarLevelDetail` (level selected): gradient hero (ring 64px, emoji + level `text-2xl font-extrabold`, "x/y bài đã hoàn thành") → in-level search → topic sections: rounded cards with **left accent border-l-4 (level color)**, numbered/checked circle, level-accent topic title, mini progress bar 80px + x/y, expand chevron rotate-90; solo lessons = standalone rows (green when done); → `GrammarLeaderboard` below list on mobile.
- Flutter: `lib/features/grammar/presentation/grammar_screen.dart` (+`grammar_level_widgets.dart`). Has search, 2-col grid w/ flat color header + ring, recommended (plain "• title" text, no numbered circles), OutlinedButton CTA; level detail = flat color hero + Card/ExpansionTile groups, `_ArticlesSection` ExpansionTile.
- **Verdict: DIVERGENT**. Missing: GrammarMap, offline-sync banner, leaderboard, gradient headers, numbered recommended chips, tinted CTA, left-accent expandable sections w/ per-section progress, in-level search; AppBar with orange title instead of in-content header. Note: Flutter puts Articles inside level detail — web level detail has no articles block (articles accessed via `grammar-articles-section` used only for ID prefix; verify web entry point for article list — see Unresolved Q1).

### 2.2 `/grammar/:level/:id` — grammar-lesson-page.tsx
- Web mobile: back + lesson title → level pill `bg-primary/10` + gray tag pills → "Bạn đã hoàn thành bài này trước đó." (emerald) → content card: rich block renderer — sanitized HTML prose, markdown (h2 underline, primary em), **formula box** `border-2 border-primary/30 bg-primary/5`, plain-text German lines highlighted `bg-sky-50 text-sky-900`, bullet lists, bordered scrollable tables, exercise section (divider + emerald "Bài tập luyện tập" pill; per-exercise: numbered primary chip, pill option buttons → emerald/red states, tinted explanation box) → **read-gate card**: "⏱ Xs / Ys • 📜 Đã cuộn 80%" + button (primary "Đánh dấu hoàn thành (+5 XP)" / amber "Hoàn thành lại" / emerald "✓ Đã hoàn thành", disabled until scroll-80% + min time) + hint text → "Bài liên quan" card (muted rows). Plus `FreeLimitOverlay` free-tier gate.
- Flutter: `grammar_lesson_detail_screen.dart` + `grammar_content_widgets.dart`. Plain Text for text blocks (no markdown/HTML/formula/German-highlight), ChoiceChip exercises, single FilledButton complete (no read gate, no +5 XP label, no amber re-complete, no free limit), Card ListTile related.
- **Verdict: DIVERGENT** (content rendering + completion gate).

### 2.3 `/grammar/articles/:level/:slug` — grammar-article-page.tsx
- Web mobile: level pill → back + title → "Nguồn: deutsch.vn" link → card with full markdown renderer (tables w/ muted thead, blockquote border-l-4 primary, sky inline code, zoomable images, inline `<audio>` for .mp3/.ogg links) → footer row: "‹ Quay lại" ghost link + right-aligned complete button (orange gradient / green done, phosphor Check). FreeLimitOverlay.
- Flutter: `grammar_article_screen.dart` — regex mini-markdown (headings/bullets only; no tables/images/audio/blockquote/code), no level pill/source, plain FilledButton. **Verdict: DIVERGENT**.

## 3. Games (route → flutter mapping + verdicts)

Web shells share the §0 pattern; per-page table:

| Web route | Web page (src/pages/game/) | Key components | Flutter file (lib/screens/games/) | Flutter route | Verdict / top diffs |
|---|---|---|---|---|---|
| `/games` | game-hub-page.tsx | GameModeCard, LevelTip, PageIntro, QuoteCard | game_hub_screen.dart | `/games` | **DIVERGENT (major)** — web: back+title, blue LevelTip card, PageIntro, quote, mascot `anh1.webp` "Bắt đầu nhanh" round button, blue Shadowing banner, games grouped by skill headings, 2-col cards (gradient `h-12 w-12 rounded-xl` icon, no badges). Flutter: mock stats row, search bar, category TabBar, difficulty chips, grid cards w/ difficulty+timer badges & "Chơi ngay" footer — none of this exists on web |
| `/games/runner` | game-runner-page.tsx | DeutschRunner (canvas: tiger sprite frames, obstacles, bg image), RunnerLevelTip, RunnerLeaderboardPanel, GameCompletionScreen, personal-best amber banner | runner_game_screen.dart | `/games/runner` | **DIVERGENT** — Flutter has no sprite/obstacle assets, no leaderboard panel, no personal-best banner, no wall/exit-guard |
| `/notes/:deckId/lesson` | guided-lesson-page.tsx | LessonModeSelector, LessonRoundManager, LessonBatchSummary, LessonCompletedScreen; sticky header w/ deck name + thin progress bar x/y | — | — | **MISSING** (whole guided-lesson flow; batches 7 new + 3 review) |
| `/games/artikel` | artikel-game-page.tsx | ArtikelQuiz | article_game_screen.dart | `/games/article` ⚠ path differs | **DIVERGENT** — shell items §0 (wall, exit guard, confetti completion, header); Flutter own results w/ gradient card |
| `/games/wortstellung` | wortstellung-page.tsx | WortstellungPuzzle; header has level chip `bg-muted rounded-full` | word_order_game_screen.dart | `/games/word-order` ⚠ | **DIVERGENT** — §0 shell + level chip missing |
| `/games/konjugation` | konjugation-trainer-page.tsx | ConjugationInputCard (text input) | konjugation_game_screen.dart | `/games/konjugation` | **DIVERGENT** — §0 shell; title format "Konjugationstrainer (Chia động từ)"; verify input-card visuals |
| `/games/listening` | listening-quiz-page.tsx | ListeningQuiz, ShuffleToggleButton, WrongAnswerRetryButton | listening_game_screen.dart | `/games/listening` | **DIVERGENT** — §0 + shuffle toggle + retry-wrong missing |
| `/games/typing-sprint` | typing-sprint-page.tsx | typing-sprint/* (ParagraphView per-char coloring, ResultsModal, ViHint, TigerMascot `/tiger-icon.svg`), custom `--ts-*` coral theme, key sounds, WPM+timer chips, 3px gradient progress | typing_sprint_game_screen.dart | `/games/typing-sprint` | **DIVERGENT (major)** — Flutter = plain TextField sentence typing; web = themed per-character typing surface w/ live WPM, volume control, results modal |
| `/games/word-sprint` | word-sprint-page.tsx | WordSprint (topic label+icon, subtopic rotation "Đổi chủ đề"), ShuffleToggleButton | word_sprint_game_screen.dart (+widgets/sprint_widgets.dart) | `/games/word-sprint` | **DIVERGENT** — §0 shell, shuffle, topic-change action missing |
| `/games/speaking` | speaking-practice-page.tsx | SpeakingPractice; `?daily=1` mission variant (blue banners, avg-score completion) | speaking_game_screen.dart | `/games/speaking` | **DIVERGENT** — §0 shell; no daily-mission variant, no avg-score screen w/ confetti≥70 |
| `/games/cases-mastery` | cases-mastery-hub-page.tsx | SubDrillCard | cases/cases_mastery_hub_screen.dart | `/games/cases` ⚠ | **CLOSE** — minor: web gradient icon tiles + 2-para blue banner (bold spans, dark variant); Flutter flat tint icons, single-para light-only banner, hardcoded white cards |
| `/games/cases-akk-dat` | akkusativ-dativ-page.tsx | GrammarDrillIntro (stats grid kho/mastered/còn cần ôn + blue promise box + orange CTA), CaseClozeQuiz (streak 🔥, colored 3-col option grid w/ rings, GrammarExplainPanel AI explain, QuizNextButton), GrammarDrillResult (confetti, XP pill, "Nhận xét" weak-case box + 🤖 AI deep-analysis button violet gradient, GrammarMasteryBar) | cases/case_cloze_quiz_screen.dart (game:'akk-dat') | `/games/cases/akk-dat` ⚠ | **DIVERGENT** — no intro screen, no streak/colored options (white rows w/ orange border), no AI explain, minimal results, no wall/exit-guard; Flutter adds level dropdown web doesn't have |
| `/games/cases-adjektiv` | adjektivendungen-page.tsx | same trio | same screen (game:'adjektiv') | `/games/cases/adjektiv` ⚠ | **DIVERGENT** — same as akk-dat |
| `/games/cases-wechselprep` | wechselpraeposition-page.tsx | same trio | same screen (game:'wechselprep') | `/games/cases/wechselprep` ⚠ | **DIVERGENT** — same |
| `/games/cases-verb-case` | verb-case-page.tsx | VerbCaseMatcher (verb `text-4xl extrabold` card, case buttons) + intro/result trio | cases/verb_case_quiz_screen.dart | `/games/cases/verb-case` ⚠ | **DIVERGENT** — same shell gaps |
| `/games/sentence-builder(/topics)` | sentence-builder/topic-select-page.tsx | level pill buttons (orange→red gradient when active), topic card grid (emoji tile w/ per-topic gradient `topic.color`, label DE/VI + word count, ring-2 orange selection + check circle), sticky bottom bar: "Ngẫu nhiên" + gradient "Bắt đầu — {topic}" | sentence_builder/sentence_builder_topics_screen.dart | `/games/sentence-builder` | **DIVERGENT** — Flutter: ChoiceChips + ListTiles, top "Chủ đề ngẫu nhiên" FilledButton, no selection model, no sticky CTA, no topic icons/gradients |
| `/games/sentence-builder/preview` | sentence-builder/word-preview-page.tsx | word-type filter pills w/ counts, WordPreviewCard (type badge colors blue/green/purple, der/die/das prefix, Sparkle essential, audio button, expandable examples), sticky "Bắt đầu luyện tập (N từ)" | — | — | **MISSING** (Flutter deliberately skipped — breaks 1:1 parity) |
| `/games/sentence-builder/play` | sentence-builder/game-page.tsx | sticky blur header (Thoát / title+topic / "x/y lượt" plays counter), SentenceBuilder, ResultsView (🎉 card, 3 stat boxes, amber XP chip, per-sentence detail list w/ score %, "Chọn chủ đề khác" + gradient "Chơi lại") | sentence_builder/sentence_builder_play_screen.dart | `/games/sentence-builder/play` | **DIVERGENT** — Flutter AppBar shell; has _ResultsView/_StatBox (closer than others) but no plays counter, confetti, sticky blur header, exit guard |
| — (legacy, NOT routed) | sentence-builder-page.tsx | — | — | — | Ignore: exported in lazy-pages but absent from routes.tsx |
| `/games/flashcards` | → `src/pages/practice/practice-listening-page.tsx` (out of assigned web list) | — | flashcard_game_screen.dart | `/games/flashcard` ⚠ | Map target is practice page — needs separate practice-scope audit |
| `/games/matching` | → practice-matching-page.tsx | — | matching_game_screen.dart | `/games/matching` | ditto |
| `/games/writing?type=word|sentence` | → practice-writing-page.tsx | — | writing_word_game_screen.dart + writing_sentence_game_screen.dart | `/games/writing`, `/games/writing-sentence` ⚠ | ditto (web = 1 page w/ query param; Flutter = 2 routes) |
| `/games/cloze` | → practice-cloze-page.tsx | — | fill_blank_game_screen.dart | `/games/fill-blank` ⚠ | ditto |

⚠ = Flutter route path differs from web; align if deep links / parity matter.

## 4. Flutter screens in scope with NO web counterpart (delete/reroute candidates)

- `lib/screens/games/conversation_game_screen.dart` (`/games/conversation`) — web has no game route; conversations live at `/speaking` hub (`conversationHub`). Candidate: delete or move under speaking parity work.
- `lib/screens/games/pronunciation_game_screen.dart` (`/games/pronunciation`) — same; web pronunciation lives under `/speaking` (`pronunciationHub`).
- `lib/screens/grammar/grammar_screen.dart` — **orphan** (router uses `lib/features/grammar/presentation/grammar_screen.dart`; no imports found). Delete.
- `lib/screens/flashcard/flashcard_review_screen.dart` + `widgets/` — no standalone web page; web review = deck-detail practice flows. Re-home or re-skin.
- `lib/screens/quiz/daily_review.dart`, `lib/screens/quiz/quiz_list_screen.dart` — not part of game/flashcard/grammar web pages (web daily review = `/review` learn area). Out of this audit's web scope; verify against learn-area scout.
- Game-hub extras (search/tabs/difficulty filter/mock stats) — invented UI, delete during hub rebuild. Hardcoded mock `_userStats` must go.

## 5. Assets needed from web `public/`

- `public/images/anh1.webp` — game hub "Bắt đầu nhanh" mascot button.
- `public/images/game/tiger-frames/frame-00..06.webp` (7 frames), `public/images/game/obstacles/*.webp` (9 files incl. `game-bg.webp`), for Deutsch Runner.
- `public/tiger-icon.svg` — Typing Sprint mascot (header).
- `public/images/game/tiger-mascot.webp`, `game-icon.webp` — used elsewhere in game area (verify usage before copy).
- Flutter `assets/images/` currently only has `premium-banner.webp`.

## 6. Priority order (suggested)

1. Shared game shell (header, wall, exit-guard, completion card w/ confetti + XP pill) — unlocks ~12 screens.
2. Game hub rebuild (highest-traffic, most divergent).
3. Deck list + deck detail (+ card form, folders, starred) — biggest missing feature surface; then speak-to-notes, guided lesson.
4. Grammar lesson/article content renderer (markdown/HTML) + read gate; grammar list polish (map, gradients, level detail sections, leaderboard).
5. Cases trio intro/result + colored quiz options; typing sprint re-theme; sentence-builder topics/preview.

## Unresolved questions

1. Web entry point for grammar articles list: Flutter shows an Articles ExpansionTile in level detail, but web `grammar-level-detail.tsx` has no articles block — need to locate where web lists `grammar-articles-section` (possibly inside GrammarHome level flow or removed). Confirm before deleting Flutter's section.
2. Should Flutter route paths be renamed to web-identical (`/games/artikel`, `/games/wortstellung`, `/games/cases-*`, `/notes/*` vs `/decks/*`)? Affects deep links + release redirect tests.
3. `/games/flashcards|matching|writing|cloze` map to `src/pages/practice/*` — outside this scout's assigned web file list; needs a practice-scope fidelity pass.
4. Markdown rendering in Flutter requires a dependency (e.g. `flutter_markdown` / `gpt_markdown`) — none present; approve adding one before grammar parity work.
5. Free-tier gates (`useFreeActionLimit`, `useGamePlays`) — is monetization parity in scope for the mobile app (App Store policy)? Blocks GameWallOverlay/FreeLimitOverlay ports.
