# UI Fidelity Scout — learn / vocabulary / practice (web mobile ↔ Flutter)

Date: 2026-07-16 · Scout: read-only, no code changes
Web source of truth: `thamkhao/deutschtiger-frontend` (synced from prod). Mobile viewport = default tailwind classes; `md:`/`lg:` ignored.

Recurring systemic gaps (apply to nearly every screen):

- Web primary CTA = `bg-gradient-to-r from-orange-500 to-orange-600` pill/`rounded-xl`; Flutter mostly uses flat `FilledButton`/`DesignTokens.tigerOrange` — gradients only exist in the journey hub widgets.
- Web pages are AppBar-less scroll pages with `BackButton` + `h1 text-xl font-bold` header; Flutter wraps everything in a Material `AppBar`.
- Web `card`/`card-sm` = `rounded-2xl` bg-card + border; Flutter often falls back to Material `Card`/`ListTile`/`Chip`/`ExpansionTile` with default elevation and `Icons.chevron_right`.
- Web `PageIntro` ("Mỗi màn 3 câu" collapsible info strip, `rounded-xl border bg-muted/40`, info SVG in `text-primary`) exists on /learn, /vocabulary, /learner-model — missing from ALL Flutter screens.
- Emoji-first iconography on web (☀️ 🔁 📥 🩹 🎯 ⭐ 🗺️ …) partially replaced by Material icons in Flutter.

---

## A. learn/

### A1. `/learn` — learn-home-page.tsx → Flutter `lib/screens/journey/journey_screen.dart` (+ widgets/)

(a) Route `/learn` (LEARN tab). Web components: `PageIntro`, `LevelJourneyStrip`, `TodaySessionCard`, `DailyPathStepper`, `WeeklyMissionsStrip`, `CapabilityMapSnapshot`, topic-browse button.

(b) Web mobile structure top→bottom (`px-4 pt-3 pb-5`, `gap-4`):
1. Header block (no AppBar): `h1 "Hôm nay"` (text-xl bold) + goal line `Mục tiêu {target_level} · Lộ trình: {persona} · ~{min}p` (text-xs, values `font-semibold text-foreground`) + exam countdown `⏳ Còn {n} ngày đến thi {label}` (text-[11px] bold, `text-amber-600 dark:text-amber-400` when ≤28 days else muted).
2. `PageIntro` strip (pageKey "learn", CTA "Tới Ôn tập").
3. `LevelJourneyStrip` — "Hành trình A1→C2" card (`rounded-2xl border bg-card p-3`): horizontal scroll of 6 level tiles (min-w 3.75rem, `rounded-xl border`), per-level tone colors (A1 emerald-600, A2 sky-600, B1 violet-600, B2 amber-600, C1 rose-600, C2 slate-500), orange gradient mini progress bar + `mature/total`, "đang bổ sung" for empty levels, frontier tile `border-primary/50 bg-primary/5`, chevron SVGs between tiles, "Chi tiết →" link to /learner-model; taps open `LevelUnitSheet`.
4. `TodaySessionCard` — "☀️ Phiên hôm nay" (`card rounded-2xl p-4`): `{done}/{total} giai đoạn` counter, h-1.5 orange gradient progress bar, **grid-cols-2 of 4 stage buttons** (Ôn tập 🔁 / Nạp 📥 / Vá điểm yếu 🩹 / Dùng 🎯) — each with 9×9 circle (done: emerald-100 + check SVG; locked: amber-100 + 🔒; current: orange gradient circle white emoji; else bg-background), tile bg emerald-50/amber-50/orange-50+ring-orange-200/muted-60, label text-[11px] (done = line-through) — then `💡 {reason}` why-line, and full-width gradient CTA "Bắt đầu phiên →" (or emerald-50 "🎉 Xong phiên hôm nay!").
5. `DailyPathStepper` — "Lộ trình hôm nay" card: vertical rail (8×8 status dot: done emerald check / premium 🔒 amber / current orange gradient with `SKILL_EMOJI` / muted), w-px border connector, step body button (current = `bg-orange-50 ring-1 ring-orange-200`), right badge "Làm →" (current gradient, else bg-muted) / "Nâng cấp →" (amber-500→600 gradient) / "Đã xong" emerald, description `· ~{est}p`, optional h-1.5 gradient progress, reason line orange-600 (amber-600 when premium).
6. `WeeklyMissionsStrip` — "Nhiệm vụ tuần này" card: rows with emoji icon, title (line-through when done), XP pill (`+{xp} XP` amber-100/emerald-100 when done ✓), h-1.5 progress bar (emerald-500 when done, else orange gradient), `{cur}/{target}`, "Làm →" chip.
7. `CapabilityMapSnapshot` — full-card button, **gradient `from-orange-50 to-amber-50`** (dark: orange-500/10→amber-500/10): "Bản đồ năng lực" + `{pct}%` orange-600, h-2 bar on `bg-white/60`, `{mastered}/{total} việc đã làm được`, `🔥 {streak} ngày`, 2 highlight can-do lines (✨/•), "Xem bản đồ →".
8. Topic-browse button (`card-interactive rounded-2xl p-4`): title "Khám phá theo chủ đề" + subtitle "Xem hướng từ vựng đang ưu tiên · ghim ⭐ để lái lộ trình" + 🗺️ right.

(c) Flutter: `journey_screen.dart`, `widgets/journey_header.dart`, `journey_today_session_card.dart`, `journey_daily_plan_section.dart`, `journey_extensions_section.dart`.

(d) **Verdict: DIVERGENT (major).**
- MISSING blocks: `PageIntro`, `LevelJourneyStrip` (whole A1→C2 card), `WeeklyMissionsStrip`, `CapabilityMapSnapshot` gradient card.
- Extra vs web: Material AppBar titled "learning journey"; three extension tiles (🎓 courses, 📊 learner model, 🎯 focus session) that web does not show on /learn.
- Header: Flutter shows only minutes-remaining; missing `Mục tiêu {level} · Lộ trình: {persona}` line (web shows target level + persona label). Countdown line CLOSE (amber ≤28 days matches).
- `TodaySessionCard`: Flutter renders single mission progress + one CTA — missing the 4-stage bucket grid (emoji circles, per-state tints), the `💡 reason` line, and the "🎉 Xong phiên hôm nay!" emerald banner (Flutter uses text swap on CTA instead). Card itself (white, border, radius-lg, gradient CTA "→") is CLOSE.
- `JourneyDailyPlanSection`: **BROKEN — imports `widgets/journey_daily_plan_step_row.dart` which does not exist** (only 4 files in `lib/screens/journey/widgets/`). Cannot verify step-row fidelity; file must be created/restored. Section header also uses a plain summary string instead of web's title + `{done}/{total} bước` split row.
- Topic tile: missing subtitle line.

(e) Assets: none (emoji + inline SVG only).

### A2. `/learn/session/:id` — mission-session-page.tsx + mission-session-runner.tsx → `lib/features/mission/presentation/mission_session_page.dart`

(a) Web components: `ResumePreStep`, unified `PracticeSession` (multi-game engine: matching/cloze/listening/writing rounds from mission `game_type`), `MissionCompleteOverlay`.

(b) Web mobile structure:
- Skeleton (pulse blocks) → error/finished/mismatch message screens with gradient CTA pill.
- `ResumePreStep` when resume_items exist: "Mở lại bài đang dở" h1, `card-sm` rows (emoji, title, subtitle, `{pct}%` pill using `--exam-active-soft/strong`), centered gradient CTA "Sang vòng từ vựng".
- Main: `PracticeSession` drives the mission's pre-built rounds — real mini-games per round (`game_type`), red error banner (`bg-red-50 text-red-700`, dark red-950/30) on save failure, "Đang lưu..." fixed hint.
- `MissionCompleteOverlay`: fixed `bg-black/60` modal over `card max-w-sm p-8`: 20×20 orange gradient circle w/ white sparkle SVG, "Hoàn thành!" 2xl bold, subtitle, **XP badge** (gradient `rounded-xl px-5 py-2.5` + lightning SVG "+{xp} XP"), "Hôm nay bạn đã leo bậc:" list (🧩/🃏 + rung icons 👂👁️✍️🗣️ `from → to`), "🔥 Streak..." line, full-width gradient CTA "Bước tiếp theo →".

(c) Flutter: `mission_session_page.dart` + `widgets/word_intro_view.dart`, `practice_view.dart`, `result_view.dart`; route `/journey/session` (web: `/learn/session/today`).

(d) **Verdict: DIVERGENT (fundamental).**
- Flutter runs a word-by-word loop: intro card (word + level chip) → self-graded flip card ("Hiện nghĩa" → Không nhớ / Nhớ đúng buttons) → between-word result view. Web runs the mission's actual game rounds (matching/cloze/listening/writing) via the shared practice engine. Entirely different interaction and visuals.
- MISSING: `ResumePreStep`, `MissionCompleteOverlay` (Flutter uses generic `GameCompletionScreen` with score/total — no trophy circle, XP gradient badge, climbed-rungs list or streak line), error banner styling.
- Flutter adds AppBars with `position / total` titles; web shows in-engine progress UI, no AppBar.
- Route mismatch: `/journey/session` vs web `/learn/session/:id` (+ `today` pseudo-id).

(e) Assets: none.

### A3. `/learn/can-do/:id/practice` — can-do-practice-page.tsx → `lib/screens/learn/can_do_practice_screen.dart`

(b) Web mobile: back link "← Bản đồ năng lực" (text-xs muted, no AppBar) → h1 `{label_vi}` + `label_de · cefr · luyện các khối còn yếu` → session inside `card p-4`: "Câu {i}/{n}" → instruction box `rounded-xl border border-orange-200 bg-orange-50` ("✍️ {instruction}" + hint) → textarea `card-sm rounded-xl` focus ring-orange-400 → result card (`✅/❌ {score}/100`, "Sửa: …", summary) → gradient CTA (Nộp câu / Câu tiếp theo / Hoàn thành). Done state: card with 🎯, "Xong! {c}/{t} câu đạt…", gradient CTA "Về bản đồ năng lực". All-clear state: card "Đã viết được hết… 🎉" + gradient CTA "Luyện hội thoại" → conversation hub.

(c/d) **Verdict: DIVERGENT (moderate)** — logic/order parity is good, visuals diverge:
- AppBar instead of "← Bản đồ năng lực" back link; content not wrapped in a web-style card.
- Instruction box lacks `border-orange-200` and the ✍️ prefix.
- CTAs are default `FilledButton` (theme color), not orange gradient pills.
- Done view: centered column (not card), CTA "back" pops instead of "Về bản đồ năng lực" to /learner-model. All-clear view missing the "Luyện hội thoại" CTA button entirely.
- Web textarea has `focus:ring-orange-400`; Flutter default `OutlineInputBorder`.

(e) Assets: none.

### A4. `/learn/topics` — topic-explore-page.tsx → `lib/screens/learn/topic_explore_screen.dart`

(b) Web mobile: h1 "Khám phá theo chủ đề" + subtitle → **"Lộ trình đang ưu tiên" steering card** (`card rounded-2xl bg-gradient-to-br from-orange-50 to-amber-50`): goal chips (`bg-white/70 rounded-full` — 🎓 Thi Goethe / 💬 Giao tiếp / 🏥 Điều dưỡng / ✈️ Du học-làm việc), pinned chips `⭐ {icon} {label}` (`bg-amber-100 text-amber-800`), fallback copy, footer hint text-[11px] → `TopicGroupCard` list: expandable card (`hover:shadow-md`, expanded = `border-primary/30` + `bg-primary/5` header), **11×11 gradient icon tile** (`bg-gradient-to-br ${topic.color}` from DB), title bold + `{label} · {n} chủ đề`, phosphor CaretDown rotating; expanded grid of `card-sm` sub-topic tiles: emoji + label_vi + label, ⭐/☆ pin button (pinned = `bg-amber-100`, unpinned = opacity-40), level chips `{level}·{count}` pills linking with `?level=`.

(c/d) **Verdict: DIVERGENT (major).**
- MISSING: the entire "Lộ trình đang ưu tiên" gradient steering card (goal + pinned chips).
- Flutter uses Material `Card`+`ExpansionTile`+`ListTile`+`Chip`: no gradient icon tile (topic.color unused), no `{label} · N chủ đề` subtitle, star = `Icons.star` amber instead of ⭐/☆ emoji, level chips Material Chips instead of muted pills, plus a pin button on the parent topic row (web pins sub-topics only on this page).
- AppBar instead of h1+subtitle header.
- Flutter routes sub-topic taps to `/vocabulary/detail/{key}`; web goes to `/vocabulary/topic-{key}` (slug prefix `topic-` — check API contract).

(e) Assets: none (topic.color/icon from backend).

### A5. `/focus` — focus-session-page.tsx → `lib/screens/learn/focus_session_screen.dart`

(b) Web mobile: BackButton + h1 "Luyện chỗ yếu" + subtitle + `GoalReasonLine` (🎯 orange prefix "Vì bạn thi {level} sau {n} ngày — hôm nay vá: …") → hero summary strip `rounded-xl bg-orange-50` text-orange-700 → 4 `card rounded-2xl p-4` cards:
1. "Từ tới hạn ôn" — count big `text-2xl text-orange-500` right, muted word pills (max 3, `+N` overflow), CTA `btn-primary rounded-full` "Ôn ngay" → /daily-review.
2. "Từ thi sai" — CTA `btn-secondary rounded-full` "Xem & thêm vào ôn" → exam readiness.
3. "Từ từ video" — CTA btn-secondary "Thêm vào ôn" → /subtitle-words.
4. "Lỗi hay gặp" — weakness items (`rounded-xl border` rows: label + `{n}×` pill `bg-orange-100 text-orange-600`, strikethrough red original → emerald corrected + explanation) + always-visible bordered link "Xem lỗi hay gặp" → error patterns.
Empty states: new user (📊 "Chưa đủ dữ liệu…" + 2 pill CTAs) vs caught-up (🎉 "Bạn đang rất ổn!" + "Học từ mới" CTA).

(c/d) **Verdict: DIVERGENT (moderate).** Structure (hero strip + 4 cards + chips + examples) is mirrored, but:
- MISSING: `GoalReasonLine`, page subtitle, "Xem lỗi hay gặp" footer link in card 4, dual empty states (Flutter has a single 🎉 state with no CTA buttons; cannot distinguish new user).
- `{n}×` badge uses per-error-type color instead of web's fixed orange-100/orange-600; corrected line uses `AppColors.success` (ok ≈ emerald) but original strikethrough is muted instead of red-500.
- Word chips = Material `Chip` vs web muted pills; no `+N` overflow chip.
- CTAs: default FilledButton vs web rounded-full btn-primary/btn-secondary distinction.
- Routing diffs: exam-fail card → `/stats/error-patterns` (web → exam readiness); subtitle card → `/vocabulary` (web → `/subtitle-words`, which exists in Flutter!).
- AppBar instead of BackButton+h1.

(e) Assets: none.

### A6. `/learner-model` — learner-model-page.tsx → `lib/screens/learn/learner_model_screen.dart`

(b) Web mobile order: BackButton + h1 "Hồ sơ năng lực" + subtitle → `PageIntro` → `LearnerReadinessCard` ("Mức sẵn sàng thi (ước lượng)": `{low}–{high}%` colored green/amber/red, band bar (orange gradient segment positioned left:{low}%), "Tính từ: …", "Việc tăng điểm nhanh nhất" action rows `bg-muted/60` + "Làm →") → `LearningDepthCard` ("Chiều sâu học tập": 3 tiles 📖 Biết / 🧠 Hiểu / ✍️ Áp dụng with sky/violet/emerald numbers + chevrons) → mastery card (`MasteryRing` 28×28 SVG ring, color by pct ≥70 green / ≥40 amber / red, center `{pct}%` + "đã thuộc") → 3 `StatTile`s (Tới hạn ôn amber / Điểm yếu red scroll-to-section / Tổng thẻ) → "Độ phủ theo trình độ" card (level bars orange gradient opacity-80 + "Luyện theo cấp {lv} →" links) → "Điểm yếu ngữ pháp" card (rows + level pill + `{n} lần sai` + "Luyện ngay" `bg-primary/10 text-primary` button) → `LearnerCapabilitySection` (WeeklyRecapCard + "Việc làm được bằng tiếng Đức" `{m}/{t}` orange + `CanDoCard` list) → "Điểm yếu cần luyện" section (WeakWordRow: word + level pill + red `{n} lần quên` pill `bg-red-100` + "Luyện ngay" button → daily-review?retry=id).

(c/d) **Verdict: DIVERGENT (major).**
- MISSING cards: `PageIntro`, `LearnerReadinessCard` (readiness band + top actions), `LearningDepthCard` (Biết→Hiểu→Áp dụng), `WeeklyRecapCard`. (Flutter file header admits "rút gọn".)
- Block order shifts: Flutter starts at mastery ring; web starts with readiness + depth.
- Level bars: flat tigerOrange instead of orange gradient; missing per-level "Luyện theo cấp X →" links.
- Grammar weaknesses: missing "Luyện ngay" button per row (web navigates `?source=wrong_answer`).
- Weak words: lapses shown as plain red text, missing red pill styling + "Luyện ngay" `bg-primary/10` button; whole tile taps to generic `/daily-review` (web deep-links `?retry={id}` — noted in code comment as router gap).
- `CanDoCard` (`widgets/can_do_card.dart`) vs web can-do-card.tsx: missing status ring/background tints (mastered = amber-300 border + amber-50/60 bg; in_progress = orange-200 border), member chips lose rung-based tinting (rung≥3 amber-100/amber-800), CTA is default FilledButton + Material edit icon instead of orange gradient chip with optional "sắp mở khóa" white/25 mini badge.
- AppBar instead of BackButton+h1+subtitle.

(e) Assets: none.

---

## B. vocabulary/

Systemic: Flutter vocab screens are a generic Material rewrite — flat theme-orange CTAs (no gradients), AppBars, Material Card/ListTile/Chip rows, most emoji/pill/badge systems dropped.

### B1. `/vocabulary` — vocabulary-page.tsx → `lib/features/vocabulary/presentation/vocabulary_screen.dart`

(b) Web mobile: BackButton + h1 "Kho từ vựng" + "{n} từ · 6 cấp độ" → `PageIntro` → **4-tab segmented control** (`rounded-xl border bg-card p-1`): 🎯 Theo mục tiêu / 🧭 Theo cấp độ / 📚 Theo chủ đề / ⭐ Của tôi — selected = orange gradient white text → tab content: goal `<select>` + topic-chip card (`bg-primary/10 text-primary` chips); level grid of `VocabularyLevelCard` (colored `border-l-4`, emoji, LEVEL_BG pill, top-topic chips); topic dropdown + sub-topic grid with `L·count` chips; mine = `MyWordsOverview` → `LearningTipCard` → "⚡ Luyện tập với chủ đề" + `WordSprintWidget` (start button gradient `from-amber-500 to-orange-600`, "60 giây · 4 đáp án · Combo x3").

(d) **Verdict: DIVERGENT (major).** Only 3 tabs — **⭐ Của tôi tab + `MyWordsOverview` missing**; selected tab flat primary not gradient; missing `PageIntro`, `LearningTipCard`, `WordSprintWidget` section; goal view = card list pushing a separate detail screen instead of in-place dropdown swap, only 7 of 13 goals; level cards missing left-border color/LEVEL_BG pill/top-topic chips; topic view = flat main-topic ListTiles (no dropdown, no sub-topic grid/level chips), taps go to lesson screen instead of detail; extra tinted `_StatsHeader` with Icons.book not on web.

(e) Assets: none.

### B2. `/vocabulary/:slug` — vocabulary-detail-page.tsx → `vocabulary_detail_screen.dart`

(b) Web mobile: `VocabularyDetailHeader` (border-b: breadcrumb, title → `TopicSwitcherSheet`, search) → level-filter dropdown / topic-chip strip (selected = orange gradient) → mastery strip (emerald graduated bar `bg-emerald-500` + "{n}/{n} đã thuộc") + tabs "Danh sách / Từ của tôi" (`border-b-2 border-primary`) + search + red "Yếu" weak filter (`border-red-300 bg-red-50`) → `VocabularyItemList` (rows w/ mastery dot, pagination) → `NextTopicCard` → sticky `VocabLearnBottomBar` (practice modes + pager).

(d) **Verdict: DIVERGENT (wrong screen).** Flutter's "detail" screen is a single-word view (hero flip card, meta table, conjugation, examples, related chips, 2 practice buttons) — the web topic word-LIST experience (search, tabs, mastery bar, weak filter, level filter, pagination, next-topic card, sticky practice bottom bar) has no Flutter equivalent. Word list exists only partially inside `vocabulary_lesson_screen.dart`.

(e) Assets: none.

### B3. `/vocabulary/:slug/lesson` — vocabulary-lesson-page.tsx → `vocabulary_lesson_screen.dart`

(b) Web mobile: phase 1 mode select (3 mode buttons with amber/orange/rose icon tiles, time pill, "Lần trước" badge; "Phiên học gồm" bullet list) → phase 2 study session: orange gradient progress header `n/total`, mode toolbar pill (✏️ Viết / 🃏 Lật thẻ …) + "✓ Đã biết", 7 card-mode renderers (flip/reverse/listen/writing/choice/cloze/compose), FSRS rating grid **😬 Quên / 🤔 Khó / 🙂 Ổn / 😎 Dễ** (red/orange/green/blue gradients) → done/empty phases (🎉/📭/✅).

(d) **Verdict: DIVERGENT (different concept).** Flutter lesson = searchable word list (search + level ChoiceChips + progress header + word tiles) pushing the word screen. Whole web lesson flow missing: mode selection, SRS session, 7 card renderers, emoji rating grid, celebration screens. "Learned" pct derived from `parentId != null`, not SRS.

(e) Assets: none.

### B4. `/vocabulary/:slug/word/:itemId` — vocabulary-word-page.tsx (+sub-components, practice-views) → `vocabulary_word_screen.dart`

(b) Web mobile: header (BackButton + `MobileVocabSearch`, border-b bg-card) → hero card: gender accent bar h-1.5 (blue/pink/green per der/die/das, else orange gradient), badge row (word-type `bg-primary/10`, IPA outline pill, level pill, colored der/die/das pill), big word + plural/lemma, VN meaning `text-primary`, 3-state speak button (idle `bg-primary/10` / amber loading / pulse playing), `SaveCardButton` amber chip, meanings box, image, "Đã thuộc" star (emerald when done), YouGlish toggle (`bg-emerald-500`) → examples card (tappable sentences + per-line audio) → conjugation table → breadcrumb + sibling phrases → inline `FillBlankMiniGame` + `SHEET_GAMES` 4-icon grid (writing/listening/speaking/flashcard — blue/amber/emerald/violet) opening bottom sheets → pronunciation sheet.

(d) **Verdict: DIVERGENT (heavily reduced).** Flutter keeps: queue progress bar, header card (word, gender as rose text, IPA, type, speak, save), meanings, ≤3 examples (🇩🇪/🇻🇳), prev/next bottom nav. Missing: search header, gender accent bar + full pill/badge row, plural/lemma, "Đã thuộc" SRS star, YouGlish, pronunciation panel, conjugation table, image, breadcrumb/siblings, and **all practice games** (FillBlankMiniGame + SHEET_GAMES grid + bottom sheets). Speak button single-state.

(e) Assets: remote `item.image_url` only.

### B5. `/daily-review` — daily-review-page.tsx → `lib/screens/daily_review/daily_review_screen.dart` (+ widgets)

(b) Web mobile: loads straight into playlist (no start screen): optional orange context banner → `DailyReviewPlaylist` interactive mini-game rounds → `DailyReviewDone`: status pill (exam-success/active/danger tokens), 📖 hero, big `{accuracy}%`, `{c}/{t} đúng`, ⚡ +XP gradient pill (`from-amber-400 to-orange-500`), weak-words list (danger-soft), CTAs "Ôn thêm / Luyện lại N từ yếu / Về trang chủ / Tiếp tục học" + secondary "🎧 Luyện nghe / ✨ Hỏi AI".

(d) **Verdict: DIVERGENT.** Flutter adds a non-web start screen (StreakCard with Material fire icon, TodayStatsCard, start button); session = plain flip card + flat tinted FSRS bar (no emoji, no gradient, web uses mini-games); done = generic `GameCompletionScreen` — the entire `DailyReviewDone` design (accuracy hero, weak words, XP pill, secondary CTAs) missing.

(e) Assets: none.

### B6. `/subtitle-words` — subtitle-words-page.tsx → `lib/screens/vocab/subtitle_words_screen.dart`

(b) Web mobile: BackButton + h1 "Từ đã gặp trong video" + subtitle → level-filter pills (`Tất cả` + `{level}·{count}`, selected orange gradient) → "Chọn tất cả/Bỏ chọn" toolbar (text-orange-500) → card rows: checkbox accent-orange-500, selected `ring-2 ring-orange-500/60`, word + IPA mono + VN + "đã thấy {n}x" orange pill + level pill + word-type + 🔊 → 📽️ empty state → sticky bottom bar (`fixed bottom-16`) `btn-primary` "Thêm {n} từ vào ôn tập" / emerald success toast.

(d) **Verdict: DIVERGENT.** Flutter = AppBar + CheckboxListTile list + Dividers + `FloatingActionButton.extended` + SnackBar. Missing: level pills, select-all toolbar, card/ring selection styling, IPA/level/type chips, orange "đã thấy" pill (plain grey text), per-row 🔊, sticky bottom bar, 📽️ empty state.

(e) Assets: none.

### B7. My words — web `MyWordsOverview` (inside /vocabulary, tab ⭐) → `lib/features/my_words/presentation/my_words_screen.dart`

(d) **Verdict: DIVERGENT.** Web = 3 stacked groups (🔁 Trong Ôn tập emerald / 📔 Trong Sổ từ violet / 👀 Đã gặp slate) with count pills and rows showing "nguồn: {source}" + italic context quote + "+N từ nữa". Flutter = standalone screen with Material `SegmentedButton` toggling one list; rows = ListTile + CircleAvatar(level) + chevron. No standalone my-words route exists on web — Flutter screen placement itself diverges.

### B8. `lib/screens/vocab_search/vocab_search_screen.dart` — **NO WEB COUNTERPART**

Claims to mimic vocabulary-detail-page but web has no standalone search route (search is the inline `MobileVocabSearch` in the word-page header). Bespoke design, hardcoded Vietnamese strings, several dead `onTap: () {}`. Candidate to delete or fold into the web-style inline search.

---

## C. practice/

Architectural finding: web has 5 distinct practice routes, each a full page (own header + back `CaretLeft` button + shuffle toggle + rich game component). Flutter collapses everything into ONE merged `PracticeScreen` (route `/decks/:deckId/practice`) whose 4 modes are simplified in-house reimplementations. The 4 web `/games/*` routes map (partially, with route-name drift) to separate screens in `lib/screens/games/` — different games, not the reviewed practice widgets; they need their own fidelity pass.

Cross-cutting practice diffs (all 5 pages):
- **Orange mismatch:** web CTA/progress = `#f97316 → #ea580c` (orange-500→600); Flutter uses `tigerOrange #F7931E → #E07D18` (visibly more yellow). Flutter `AppColors.primary` is pink `#FF8FA3` — token-mapping mismatch.
- Results screens: Flutter `practice_results_view.dart` adds a trophy `Icons.emoji_events` (not on web), and is MISSING the web "+N XP" gradient pill (`from-amber-400 to-orange-500` + ⚡), `ConfettiBurst`, `WrongAnswerRetryButton`, orange-gradient "Chơi tiếp"/"Luyện lại" + `btn-secondary` pair.
- Flutter-only `PracticeProgressHeader` (check-circle counter + orange LinearProgressIndicator) replaces web's per-game inline headers with distinct gradients (orange listening, pink→rose matching).
- Missing web components across modes: `SpeedSelector`, `SpecialCharBar` (umlaut keys), `HintButton` (Lightbulb), `AnswerDiffDisplay` (char diff), reinforce-dots "Lặp lại N lần" loop, mic input, audio "Nghe" pills, edit-cloze.

### C1. `/notes/:deckId/practice` — practice-page.tsx → `lib/screens/practice/practice_screen.dart` + `practice_mode_selector.dart` + `practice_results_view.dart`

(b) Web mobile: back link "← Quay lại bộ thẻ" → "Bao gồm từ đã thuộc" checkbox row (`bg-muted/50`, accent-primary) → `card p-5` with h1 "Chọn chế độ luyện tập" centered + **2-col grid of 13 mode cards**, each a 10×10 `rounded-2xl` `bg-gradient-to-br` icon tile with white stroke SVG (writing purple-500→violet-600, sentence blue→indigo, cloze teal-500→cyan-600, flashcards orange-500→amber-600, listening violet→purple, matching pink-500→rose-600, runner green→emerald, fade amber→yellow, dictation sky→cyan, chaining fuchsia→pink, gist indigo→violet, speaking rose→red) + title + description + "{n} thẻ sẵn sàng" footer. Active state: "← Đổi chế độ" + game component. Results: card with "Hoàn thành!", accuracy `text-5xl text-primary`, "{c}/{n} đúng", XP gradient pill, "Luyện lại" orange gradient + "Quay lại bộ thẻ" btn-secondary.

(d) **Verdict: DIVERGENT (severe).** Flutter mode selector = vertical list of only **4** rows (cloze/listening/matching/writing) with flat tinted Material-icon squares (`Icons.edit_note/headphones/compare_arrows/create`) + chevron — no gradients, no descriptions, no card-count footer; **9 modes missing** (sentence, flashcards, runner, fade, dictation, chaining, gist, speaking, listening-quiz). Writing color orange in Flutter vs purple gradient on web. No mature-words checkbox, no back link. Results diffs per cross-cutting list.

(e) Assets: none (inline SVGs/phosphor/emoji).

### C2. `/games/flashcards[/:mode]` — practice-listening-page.tsx → **route MISSING in Flutter practice**

(b) Web mobile: header (9×9 `rounded-lg border bg-card` back + `CaretLeft` phosphor, h1 "Luyện Flashcards", `ShuffleToggleButton`) → `ListeningPlayer`: "{i}/{n}" + `SpeedSelector`, h-1.5 orange gradient bar, **3D flip card** (front: word text-2xl bold + speaker pill `bg-primary/10` pulse-when-playing + example + "👆 Nhấn để lật"; back: amber meaning pill `bg-amber-50 text-amber-800`, VN, optional image), bottom round controls (12×12 card prev/next, 14×14 orange gradient play/pause), auto-mode toggle pill + gear settings popup (replay presets 1/3/5/7, flip/reveal timing), "🔊 {n}× phát lại". Results `PracticeListeningResults`: 🎧 hero, understood/misunderstood green/red counts, XP pill, auto-continue countdown bar.

(c/d) **Verdict: MISSING/DIVERGENT.** No `/games/flashcards` route in Flutter (only `/games/flashcard` → separate `FlashcardGameScreen`, unreviewed). The reviewed `practice_listening_view.dart` is a different UX entirely: 96×96 purple circle `Icons.volume_up` play button + 4 multiple-choice option tiles (green/red reveal) — web flashcards mode has no MCQ at all. No flip card, speed selector, auto-mode/replay settings, XP, 🎧 results, countdown.

(e) Assets: none (card images from per-card data URLs).

### C3. `/games/matching` — practice-matching-page.tsx → `practice_matching_view.dart` (deck mode) / separate `MatchingGameScreen` for the route

(b) Web mobile: header (back + h1 "Nối từ" + shuffle) → `PracticeMatching`: "Vòng {r}/{n}" | "⚡ {xp} XP" amber with green floating "+xp" | "{done}/{total} từ"; h-2 progress bar **`from-pink-500 to-rose-600`**; column labels "TIẾNG ĐỨC / TIẾNG VIỆT" uppercase; 2-col grid of `card-sm` tiles, 6 pairs/round — selected = **purple** (border-purple-400 bg-purple-50), matched = green-400/green-100 scale-105, wrong = red shake + sound; audio plays on German select. Results: accuracy 5xl, XP pill, retry + "Chơi tiếp" gradient + "Quay lại".

(d) **Verdict: DIVERGENT.** Flutter: two scrolling ListView columns, up to 8 pairs, single round — no round paging, no pink→rose progress bar, no XP counter, no column labels; selected tint = tigerOrange (web purple); wrong answers just deselect (no red shake/sound); no audio-on-select, no confetti/XP results.

### C4. `/games/writing` — practice-writing-page.tsx → `practice_writing_view.dart` (deck mode) / separate `WritingWordGameScreen` for the route

(b) Web mobile: header (back + "Luyện viết từ/câu" + shuffle) → `PracticeWritingUnified`: "{i}/{n}" + ⚡XP + `SpeedSelector`; `card p-5` prompt (VN meaning text-2xl bold + purple "Nghe" pill `bg-purple-100 text-purple-700` SpeakerHigh); feedback green/red/amber-reveal blocks with `AnswerDiffDisplay` + reinforce dots + amber "Lặp lại N lần" stepper; fixed bottom input: `SpecialCharBar`, optional mic (premium), textarea `card-sm` with inline green `bg-green-500` check submit. Results + `NextActionCard`.

(d) **Verdict: DIVERGENT.** Flutter: centered translation headline + plain outlined TextField (white → green/red fill) + full-width "check" FilledButton; one-shot correct/wrong, auto-advance 900ms. Missing: Nghe pill, SpeedSelector, XP counter, SpecialCharBar, mic, 2-attempt reveal, diff display, reinforce loop, NextActionCard.

### C5. `/games/cloze` — practice-cloze-page.tsx → `practice_cloze_view.dart` (deck mode); **route missing** (Flutter has `/games/fill-blank` → separate screen)

(b) Web mobile: header (back + "Điền từ" + shuffle; keyboard-aware bottom padding) → `PracticeCloze`: flowing sentence with **inline underlined blank** (`border-b-2`, `border-primary text-primary` typing / `border-amber-400 text-amber-600` revealed), italic VN hint, purple "Nghe" pill, amber "Gợi ý" Lightbulb, "Sửa" edit button, reinforce dots, SpecialCharBar, centered input. Results identical pattern.

(d) **Verdict: DIVERGENT.** Flutter replaces the inline blank with a plain `_____` string in a centered headline + outlined TextField; missing Nghe/hint/edit buttons, XP, umlaut bar, diff display, reinforce loop; one-shot feedback + 900ms auto-advance.

(e) Assets (all practice): none from public/ — phosphor glyphs (CaretLeft, Play, Pause, ArrowsClockwise, GearSix, SpeakerHigh, Check, Lightbulb, Microphone), inline SVGs, emoji 🎧⚡👆🔊.

---

## D. Flutter screens in scope with no (or mismatched) web counterpart

| Flutter file | Status |
|---|---|
| `lib/screens/vocab_search/vocab_search_screen.dart` | No web route — delete or rebuild as inline word-page search |
| `lib/screens/daily_review/widgets/start_widgets.dart` (start screen) | No web equivalent — web enters the playlist directly |
| `lib/features/my_words/presentation/my_words_screen.dart` | Web has no standalone route — content belongs in /vocabulary tab ⭐ |
| `lib/screens/journey/courses_hub_screen.dart`, `course_detail_screen.dart`, `course_lesson_screen.dart` | Web counterparts exist but at `/course`, `/course/:slug`, `/course/:slug/lesson/:n` (Flutter mounts them under `/journey/courses...`); course pages are outside this scout's page scope — flag route mismatch only |
| `/learn` group video routes (`/learn/group/:groupId`, `watch/:videoId`) | No matching web route found under /learn (web /learn has no group children) — verify before keeping |
| `lib/screens/journey/widgets/journey_daily_plan_step_row.dart` | **Referenced by import but file does not exist — broken build** |

Route mismatches: Flutter `/journey/session` vs web `/learn/session/:id|today`; Flutter `/vocabulary/detail/:topicKey`, `/vocabulary/lesson/:topicKey` vs web `/vocabulary/:slug`, `/vocabulary/:slug/lesson`, `/vocabulary/:slug/word/:itemId`; Flutter `/focus-session` vs web `/focus`.

## E. Assets needed from web `public/`

None for these three page groups — all web iconography is emoji, inline SVG, phosphor icons, or backend-provided data (`topic.color`, `item.image_url`). The work is rebuilding the gradient/pill/emoji visual system, not copying assets.

## Unresolved questions

1. `journey_daily_plan_step_row.dart` is imported but missing — was it deleted mid-refactor or never committed?
2. Should the Flutter mission runner adopt the web's multi-game `PracticeSession` engine (large build) or is the flip-card loop an accepted product decision? (`learner_model_screen.dart` header claims "không cần parity pixel với web theo yêu cầu" — conflicts with the 100%-identical goal.)
3. Topic slug contract: web uses `topic-{key}` slugs (`/vocabulary/topic-xxx`); Flutter passes raw `{key}` to `/vocabulary/detail/{key}` — confirm backend accepts both.
4. Keep or drop the Flutter-only screens (vocab_search, daily-review start screen, standalone my-words, /learn/group video browser)?
5. Practice: should the 4 web `/games/*` pages be measured against `lib/screens/games/*` (MatchingGameScreen, WritingWordGameScreen, FillBlankGameScreen, FlashcardGameScreen, ListeningGameScreen) instead of the deck-practice widgets? Those screens were outside this pass and need their own fidelity audit. Also confirm route naming drift (`/games/flashcard` vs web `/games/flashcards`, `/games/fill-blank` vs web `/games/cloze`).
6. Color tokens: Flutter `tigerOrange #F7931E` vs web orange-500 `#f97316`, and Flutter `AppColors.primary` = pink `#FF8FA3` — is a token realignment planned before per-screen fixes?
