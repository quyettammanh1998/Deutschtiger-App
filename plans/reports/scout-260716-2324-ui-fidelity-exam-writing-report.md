# UI-Fidelity Scout — Schreiben / Writing Ecosystem (web → Flutter parity)

Scope: writing pages under `thamkhao/deutschtiger-frontend/src/pages/exam/` + sprint v2 pages. Mobile viewport only (default tailwind classes). Web is source of truth (synced from prod 2026-07-16, post "unify luyện-viết navigation + retire sprint v1" commit).

Global notes:
- All writing routes are LIVE in `src/app/routes.tsx` (lines 373–542), including Sprint v2 (`/exams/goethe-b1/writing/sprint[/session|/mock|/cheatsheet]`). `exam-writing-sprint-old-*.tsx` retired — skipped.
- Icon system: web uses **inline SVGs + @phosphor-icons/react** (ArrowLeft, Sparkle, ClockCounterClockwise, Trophy, CaretUp/Down, ArrowRight) + emoji glyphs — NOT lucide. Flutter should map to Material icons / emoji text.
- Recurring primitives: `card` (rounded-xl bg-card border-border), `card-sm`, `card-interactive`, CTA gradient `from-orange-500 to-orange-600` (#f97316→#ea580c), semantic tokens (foreground / muted-foreground / bg-muted / border-border), `BackButton` header row `mb-4 flex items-center gap-3` + `text-lg font-bold` title, `PracticeScrollWrapper` page shell (scrollable, px-4 pt/pb).
- **Assets needed from `public/`: NONE** — every page in scope uses inline SVG + emoji only. No raster images.
- Flutter has **no live-parity writing code at all**. The 3 Flutter files that exist (`goethe_b1_hub_page.dart`, `goethe_b1_writing_page.dart`, `ai_writing_practice_page.dart`) are legacy mock screens (English UI, hardcoded fake topics, fake submit → SnackBar). `lib/screens/exam/widgets/writing_topics_list.dart` is orphaned (zero imports). Flutter router has no `/luyen-viet`, `/writing-practice/*`, sprint, or schreiben-view routes.

---

## 1. goethe-b1-hub-page.tsx — `/exams/goethe-b1` (+ aliases)
**Web** (120 L): components `BackButton`, `ExamReadinessCard`, inline hub-card list.
Mobile structure top→bottom:
1. Header row: BackButton → `Goethe-Zertifikat B1` (text-lg bold, truncate) + sub `3 bộ đề luyện thi` (text-xs muted).
2. `ExamReadinessCard provider=goethe level=b1` (mb-4).
3. One `card divide-y divide-border`: 3 tappable rows (official / writing / sprechen). Each row: 10×10 rounded-xl `bg-muted text-primary` icon box (inline stroke SVG: book / pencil / mic), title text-sm semibold (hover→primary), desc text-xs muted, right chevron `h-4 w-4 text-muted-foreground/50`. Copy: "Bộ đề thi chính thức · 30+ đề luyện thi đầy đủ · Lesen · Hören · Schreiben", "Bộ đề viết thực tế · 30 đề Schreiben theo chủ đề · Teil 1 · Teil 2 · Teil 3", "Luyện nói (Sprechen) · Đề nói theo chủ đề · Teil 1 · Teil 2 · Teil 3".

**Flutter**: `lib/screens/exam/goethe_b1_hub_page.dart` — DIVERGENT. AppBar "Goethe B1" orange; "Your Readiness" section; then 4 `_SectionCard` (Lesen/Hören/Schreiben/Sprechen, colored Material icons) + 3 `_PracticeCard` (Writing Topics / Speaking Topics / Past Exams) — English labels, Material Cards, totally different block order and content (web has exactly 3 rows in ONE card, VN copy, no Lesen/Hören rows).
**Verdict: DIVERGENT** (needs full rebuild of body content).

## 2. goethe-b1-writing-teil-pick-page.tsx — `/exams/goethe-b1/writing`
**Web** (114 L): `TeilPickCard`, skeleton cards, hero section.
Mobile structure:
1. Header: BackButton → eyebrow `Goethe B1 · 3 phần · 100 Punkte` (text-xs muted) + H1 `Viết — Schreiben` (text-xl bold, "Schreiben" in `text-orange-500` / dark `orange-400`).
2. Hero section: rounded-xl, `border-orange-200/70`, gradient `from-orange-50 via-background to-amber-50` (dark: `orange-950/30 via-card amber-950/20`), p-4. Inside: 3 pill badges — `Đề thi thật` (bg-orange-100/text-orange-700, uppercase tracking-wide 11px bold), `2023–2026` (emerald-100/emerald-700), `Bài mẫu chất lượng` (blue-100/blue-700); H2 text-lg bold pitch; paragraph text-sm muted; 3 stat mini-cards (1-col stack on mobile: `grid-cols-1 gap-2.5`) each `bg-white/80 border-white/70 backdrop-blur` (dark `bg-white/5 border-white/10`): label 11px uppercase muted + value text-base bold ("Đề thi Goethe thật" / "{n}+ chủ đề" / "Mẫu viết + từng bước").
3. Umbrella nav links row: `← Tất cả kỳ thi luyện viết` (text-primary) + `Bài của tôi →` (muted) — link to /luyen-viet and ?tab=my.
4. `card divide-y` with 3 `TeilPickCard`s. TeilPickCard: 11×11 rounded-xl emoji box (Teil1 ✉️ bg-blue-50, Teil2 💬 bg-violet-50, Teil3 📋 bg-green-50); row: `Teil {n}` bold colored (blue-600/violet-600/green-700) + points pill (`40/40/20 Punkte`, matching tinted badge) + titleVi semibold; subtitle text-xs muted; 1px-high progress bar (bg-border track, teil-colored fill blue-500/violet-500/green-500); right column `done/total` text-xs + chevron.

**Flutter**: `lib/screens/exam/goethe_b1_writing_page.dart` is the closest ("writing-topics" route) but it's a 3-tab mock (Teil 1/2/3 TabBar + hardcoded 10 topics each + bottom-sheet editor) — nothing like the teil-pick page. **Verdict: MISSING** (no equivalent screen; existing file is a different legacy concept).

## 3. goethe-b1-writing-topic-list-page.tsx — `/exams/goethe-b1/writing/:teilNum`
**Web** (364 L): `TopicListItem`, `IntroListItem`, `CommunityTopicFolderCard`, `Collapsible`, `GoetheB1WritingLeaderboard`, `UpgradeBanner`, search input.
Mobile structure:
1. Header: BackButton baseline-aligned with H1 `Teil {n} — {titleVi}` (Teil colored: 1=blue-600, 2=violet-600, 3=green-700); meta line `{count} đề · Theo tần suất`; button row (mobile): ⚡ `Sprint 10h` pill (gradient orange-500→600, rounded-full, white 12px semibold) + 📂 `Nhóm theo chủ đề` toggle pill (gradient `from-primary to-rose-600` — NOTE deviation from standard orange CTA).
2. Search field: `card-sm` row, magnifier inline SVG h-4, input placeholder `Tìm theo tên đề, chủ đề, từ khóa...`, optional `Xóa` clear chip; focus ring = 2px primary shadow.
3. `CommunityTopicFolderCard` — full-width gradient orange-500→600 white button: folder SVG h-6 + "Đề do cộng đồng đóng góp" semibold + count subline (`{n} đề đã được thêm` / "Chưa có đề — hãy là người đầu tiên!") + chevron.
4. Topic list `card divide-y`: optional `IntroListItem` (intro topic, hidden while searching); then `TopicListItem` per topic — 6×6 rounded-full leading badge (position number bg-muted / ✓ green-500 white when done / 🔒 amber when locked); titleDe text-sm semibold truncate + inline pills: `HOT` (orange-50/orange-600, when 5★), `Chính thức` (blue-50/blue-600), `✓ Đã học` (green), `Premium` (amber); titleVi text-xs muted; meta row: amber star string ★★★☆☆ + difficulty chip (Dễ green / TB amber / Khó red, 10px). Locked rows: bg-muted/20, right side `Mua Premium` gradient pill instead of chevron. Grouped mode: collapsible groups `{emoji} {cluster} (n)` (8 VN cluster names, e.g. 🎉 Gia đình & Tiệc tùng). Empty-search state: "Không tìm thấy đề phù hợp".
5. Leaderboard (below list on mobile, `w-full`): `card p-3`, Trophy phosphor icon yellow-500 + `Bảng xếp hạng · Teil {n}`; top-10 rows 🥇🥈🥉/rank + 5×5 avatar + name + green completed count `x/{total}`; current-user row highlighted `bg-primary/8`, outside-top-10 shown after dashed divider.
6. Free-limit footer (non-premium): amber `card-sm` "Bạn đang xem 5 đề miễn phí của Teil {n}" + `UpgradeBanner module=exam`.

**Flutter**: MISSING (goethe_b1_writing_page.dart's tabbed mock again unrelated). **Verdict: MISSING**.

## 4. goethe-b1-writing-detail-page.tsx — `/exams/goethe-b1/writing/:teilNum/:slug`
**Web** (455 L) — the reader page. Components: `DetailHeader` + `FontSizeControl`, `ProvenanceCard`, `TaskCard`, then Collapsible sections in fixed order, `TypingPracticeStartCard`, `StartPracticeCta`, floating TOC pill, `WritingAutoplayFab`.
Mobile structure:
1. Full-scroll reader (`px-4`, content `pb-28`), font-scale CSS var (persisted, `FontSizeControl` in header rightSlot).
2. `DetailHeader` (back, titles) + `ProvenanceCard` (exam provenance) + autoplay FAB slot.
3. Section stack (space-y-3), each a Collapsible with emoji title, default open/closed as noted:
   - `📋 Đề bài` TaskCard (always visible, not collapsible)
   - `🎯 Phân tích đề (Task analysis)` — open
   - `🏗️ Cấu trúc bài viết` — open
   - `💬 Mẫu câu hữu ích` — open
   - `✏️ Câu mẫu theo điểm` — open
   - `📝 Bài mẫu` — open
   - `📐 Ngữ pháp trọng tâm (tham khảo)` — closed
   - `📚 Từ vựng trọng tâm (tham khảo)` — closed
   - `⚠️ Lỗi thường gặp (tham khảo)` — closed
   - `🎯 Bài tập luyện` (UebungenSection) — open
4. `TypingPracticeStartCard` (luyện gõ) → `StartPracticeCta` (premium) OR amber premium-lock card + `UpgradeBanner compact`.
5. Complete button centered: gradient emerald-500→600 rounded-xl `🎯 Đánh dấu hoàn thành` (done state: green-500→600 `✓ Đã hoàn thành — Lưu lại`).
6. **Floating TOC pill** fixed `bottom-20 right-4 z-50`: rounded-full bg-card border shadow-lg, active section emoji+label, opens upward menu (max-h-60vh scroll, active item `bg-orange-50 text-orange-600`).
7. Variants: intro topic → simple markdown view; locked topic → amber card + UpgradeBanner; JSON-LD (skip in Flutter).

**Flutter**: MISSING entirely. **Verdict: MISSING** (largest single build: ~10 sub-card components + collapsible + floating TOC + font scaling).

## 5. goethe-b1-writing-practice-page.tsx — `/exams/goethe-b1/writing/:teil/:slug/practice`
**Web** (117 L): header (ArrowLeft ghost back, title truncate, `Teil {n}` pill `bg-primary/10 text-primary`); single column on mobile: `PracticePromptCard` then `WritingPracticePanel`, footer `AskAiAboutTopicButton`.
- `PracticePromptCard`: card p-4; `Aufgabe` heading text-xl bold **orange-600**; right side: 📏 word-range hint, `ShowTranslationToggle`, `Báo lỗi` report button; bilingual interleaved DE/VI task text; divider; `Yêu cầu viết` heading orange-600 bold + numbered points (5×5 rounded-full `bg-primary/10` index chips, de bold + vi small when toggled).
- `WritingPracticePanel` (shared core, 322 L): top row `Bài của tôi →` link + history-clock icon button with orange count badge (9+ cap); `PracticeEditorCard`; `WritingHistorySheet` bottom sheet.
- `PracticeEditorCard` (371 L, THE editor): card p-4 — header `Bài viết của bạn` + status chips (💾 Đã lưu nháp / `Đã nộp` green pill / word count colored <50 muted, 50–200 green, >200 amber); amber restore-draft banner (savedAt time + `Khôi phục` gradient / `Bỏ` outline); textarea rows=12 `card-sm` w-full, umlaut auto-replace, focus 2px primary ring; `SpecialCharBar` (ä ö ü ß) visible on focus; submit `Nộp bài viết` full-width gradient (disabled <10 words, hint `Tối thiểu 10 từ`); after submit: `Sửa bài viết` outline + `Sửa với AI` gradient (Sparkle icon, spinner while grading) + save-to-deck slot + `GradingRubricInfoButton` right-aligned; error cards red-50; `GradingResultCard`; rewrite card (`Viết lại sau góp ý`: `Tạo bản sửa mẫu` gradient btn → before/after 2-panel diff (muted vs green-50) + `Đưa vào khung để chỉnh tiếp`).
- `GradingResultCard` (248 L): card divide-y — grade badge + `{score}/100` text-2xl bold + summary; Goethe raw bars (Inhalt/Kommunikative/Formale x/4, orange gradient bars h-1.5); `Lỗi hay gặp trong bài này` chips (per-error-type tinted colors: Mạo từ purple, Cách red, Chia động từ orange, Giới từ blue, …); `Chi tiết đánh giá` 4 categories x/25 with band chips + orange bars; collapsible `💡 Gợi ý viết tự nhiên hơn` (blue-50 rows: strikethrough original → blue natural + 🇻🇳 note); collapsible `Sửa lỗi (n)` (muted rows: red strikethrough → green corrected + type chip + explanation); footer link `🔁 Vá lỗi ngữ pháp ở Tập trung (n lỗi)` (orange-50 bordered).

**Flutter**: MISSING. `lib/screens/ai/ai_writing_practice_page.dart` (route `/ai/writing`, 598 L) is a mock list+editor with fake AI feedback — not this page. **Verdict: MISSING** (WritingPracticePanel/PracticeEditorCard/GradingResultCard are the shared core → build once, reuse in pages 5, 8, 9, 11, 13).

## 6. goethe-b1-community-writing-list-page.tsx — `/exams/goethe-b1/writing/community/:teilNum`
**Web** (25 L): header BackButton + `Đề cộng đồng · Teil {n}`; `CommunityWritingList` — cards p-3: `Teil {n}` primary pill + title truncate; meta `👤 contributor · {n} bản · 👍 votes`; empty state card "Chưa có đề cộng đồng / Hãy là người đầu tiên đóng góp đề!".
**Flutter**: MISSING. **Verdict: MISSING**.

## 7. writing-catalog-page.tsx — `/luyen-viet` (unified writing hub)
**Web** (64 L): header: BackButton + `Luyện viết (AI chấm)` + `📋 Cách chấm` outline chip (opens `ExaminerRubricSheet` bottom sheet); `PageIntro` block (pageKey luyen-viet: why/todo/next + link to error patterns); segmented tabs `bg-muted p-1 rounded-lg` — `Bắt đầu` / `Bài của tôi` / `Cộng đồng` (active = bg-background + shadow-sm); tab bodies:
- **Bắt đầu** (`WritingStartTab`): ✍️ `Tự nhập đề của bạn` card row; ⚡ `Sprint luyện cấp tốc` card row; then `grid-cols-2` of provider-level cards (Goethe A1–C1, telc B1–B2, ÖSD B2) — label bold + `Schreiben` subtitle; goethe-b1 routes to dedicated feature.
- **Bài của tôi** (`WritingSubmissionsTab`): `WritingCriteriaTrend` chart; `SubmissionsFilterBar` (provider/level/teil chips + search + sort); `SubmissionListItem` cards (badge pill + title, 100-char snippet, date, right colored score `{n}/100` green≥80 / amber≥60 / red); `Xem thêm` pagination button; empty state ✍️ + `Chọn đề ngay` gradient CTA.
- **Cộng đồng** (`WritingCommunityTab`): 3 Teil sections (Teil 1 — Email thân mật / Teil 2 — Bài luận diễn đàn / Teil 3 — Email trang trọng) each rendering `CommunityTopicsSection`; footer card `Xem tất cả đề cộng đồng →`.

**Flutter**: MISSING (no /luyen-viet route). **Verdict: MISSING**.

## 8. writing-level-topics-page.tsx — `/exams/:providerLevel/writing`
**Web** (81 L): header BackButton + `{label} · Viết`; loading = 3 pulse cards; empty = ✍️ emoji + "Chưa có đề chính thức"; topic buttons (card p-4: `Teil {n}` primary pill + title_de truncate + 🔒 for premium + title_vi subline); `Đề cộng đồng` section header + `➕ Đóng góp đề` gradient chip (routes to /luyen-viet/tu-nhap with prefill) + `CommunityWritingList`. goethe-b1 redirects to its dedicated page.
**Flutter**: MISSING. **Verdict: MISSING**.

## 9. writing-level-practice-page.tsx — `/exams/:providerLevel/writing/:slug/practice`
**Web** (95 L): header ArrowLeft ghost + title truncate + `{offering.label}` primary pill; body = `WritingPracticePanel` only (no prompt card — the task lives inside the panel props). Locked/not-found fallback text.
**Flutter**: MISSING. **Verdict: MISSING** (thin wrapper once panel exists).

## 10. writing-community-topic-page.tsx — `/exams/:providerLevel/writing/community/:teil/:slug`
**Web** (149 L): header BackButton + canonical title; `CommunityVersionSelector` (version chips) + `CommunityVersionCard` (content + edit/delete/report/add-version actions) + `CommentSection`; wizard mode swaps body for `CommunityTopicCreateWizard` in a card; not-found state 🔍 + gradient `Quay lại danh sách`.
**Flutter**: MISSING. **Verdict: MISSING** (depends on community + comments stack, likely later wave).

## 11. writing-custom-page.tsx — `/luyen-viet/tu-nhap`
**Web** (312 L), two phases:
- Setup: header BackButton + `Tự nhập đề`; intro sentence; labeled chip groups (uppercase 12px muted labels): `Kì thi` (Goethe/telc/ÖSD chips — active `bg-primary text-white`, inactive `bg-muted`), `Trình độ` (levels per provider), `Teil (tùy chọn)` (Không/1/2/3); textarea `Đề bài *` rows=5 rounded-xl border bg-card (placeholder switches with AI-polish toggle); textarea `Gợi ý / ý chính (tùy chọn)` rows=4; ✨ AI-polish checkbox card (`accent-orange-600`, ON default, title `✨ Để AI hoàn thiện đề`); full-width gradient CTA `Hoàn thiện & bắt đầu viết` / `Bắt đầu viết` (pending: `Đang hoàn thiện đề…`).
- Started: header `← Sửa đề` ghost + `Đề tự nhập` + provider/level/teil pill; prompt recap card (Đề bài + bullet list `Các ý cần trả lời` + bordered footer `📤 Đóng góp đề này cho cộng đồng` outline button); then `WritingPracticePanel`.

**Flutter**: MISSING. **Verdict: MISSING**.

## 12. writing-session-detail-page.tsx — `/writing-practice/:submissionId`
**Web** (95 L): header BackButton + meta.title truncate + badge pill; full-width gradient `Luyện lại` button (custom → prefills tu-nhap; else practiceRoute); `WritingSessionContent`: `Đề bài` (bg-muted/30 rounded p-3) + `Bài viết của bạn` (bordered p-3) + `GradingAttemptTimeline` (attempt history w/ scores). `/writing-practice` itself redirects to `/luyen-viet?tab=my`.
**Flutter**: MISSING. **Verdict: MISSING**.

## 13. schreiben-view-page.tsx — `/exams/telc/b1/a-rap/schreiben/:slug` (telc B1)
**Web** (560 L, self-contained older flow, NOT using WritingPracticePanel): header: ghost back + name + history-clock w/ orange count badge + mode pill (`Luyện tập` green / `Luyện thi` primary) + tag pills + difficulty pill (leicht green / mittel amber / schwer red). Single column mobile:
1. Aufgabe card: heading + `Tiếng Việt`/`Tiếng Đức` toggle link; prompt text; `Yêu cầu viết` numbered points (primary/10 chips).
2. `CollapsibleHints` (tips + keyPhrases, default closed).
3. Writing card: same editor pattern as PracticeEditorCard (drafts, restore banner, rows=12 textarea, `Nộp bài viết` gate 10 words, submitted → `Sửa bài viết` + `Sửa với AI` + save-to-deck, rubric info) but hand-rolled; grading error card; `GradingResultCard`.
4. `Xem bài mẫu` / `Ẩn bài mẫu` gradient toggle → `InterleavedAnswer` DE/VI card + `Ngữ pháp` card (pattern/example/vi rows).
5. `WritingHistorySheet`.

**Flutter**: MISSING (no telc a-rap routes at all). **Verdict: MISSING**.

## 14. exam-writing-sprint-page.tsx — `/exams/goethe-b1/writing/sprint` (LIVE)
**Web** (126 L): non-wrapper page (`h-full overflow-y-auto`); header BackButton + `Sprint Anki` text-2xl bold + sub "Goethe B1 Writing — ôn 73 đề bằng spaced repetition"; `SRModePicker` — 2 selectable cards (⚡ Marathon "1 session 10h" / 📅 Hằng ngày "SM-2 nhiều ngày", selected = `ring-2 ring-orange-500` + `Đã chọn` orange chip); CTA: gradient `Bắt đầu — {n} đề` OR resume pair (`Tiếp tục session cũ` gradient + `Bắt đầu mới (xoá session cũ)` secondary); divider; secondary: `Thi mock 3 đề ngay` btn-secondary + `Cheatsheet Redemittel` primary text link.
**Flutter**: MISSING. **Verdict: MISSING**.

## 15. exam-writing-sprint-session-page.tsx — `/exams/goethe-b1/writing/sprint/session` (LIVE)
**Web** (104 L): sticky top bar (`bg-background/95 backdrop-blur border-b`): `← Sprint` link + progress bar (h-2 bg-muted track, orange-500 fill, `{seen}/{total}` right-aligned xs) + `Thi mock` muted chip. Body: `SRCard` (front: task + 3 outline bullet inputs + check; back: reveal w/ per-bullet match ✓/✗ + `sr-rating-bar` Anki ratings) or completion state 🎉 `Tất cả đã ôn xong!` + gradient `Thi mock 3 đề →` + `Về Sprint` link. (sr-card-front/back internals not fully scouted — 127+155 L.)
**Flutter**: MISSING. **Verdict: MISSING**.

## 16. exam-writing-sprint-mock-page.tsx — `/exams/goethe-b1/writing/sprint/mock` (LIVE)
**Web** (201 L): sticky bar: `← Sprint` + `Mock 3 đề` + dot progress (h-2 w-6 rounded pills: current orange-500, done orange-300, todo muted). Per-essay: `EssayInput` — task card (`Đề — Teil {n}` + task text), textarea rows=10, word counter `{n} từ (mục tiêu: 50–120)` (red under / green in-range / yellow over) + `Đã lưu nháp`, gradient `Nộp bài ({n} từ)` (min 50 words), shortfall hint; after grade: `MockResultCard` + `Bài tiếp theo →`; grading spinner "AI đang chấm bài... (~5-10 giây)". All-done: avg card `{avg}/100` text-3xl + per-teil MockResultCards + `Quay về Sprint` CTA.
**Flutter**: MISSING. **Verdict: MISSING**.

(Also live but out of scope: `exam-writing-sprint-cheatsheet-page.tsx` — printable Redemittel cheatsheet, 85 L.)

---

## Build-order recommendation (dependency graph)
1. **Shared core first**: `WritingPracticePanel` + `PracticeEditorCard` + `GradingResultCard` + `WritingHistorySheet` + `SpecialCharBar` + umlaut auto-replace → unlocks pages 5, 9, 11, 13 and halves page 8/12 work.
2. Goethe B1 chain (hub → teil-pick → topic list → detail → practice): highest traffic; detail page (#4) is the largest single screen (~10 section card widgets + floating TOC).
3. Hub /luyen-viet (#7) + tu-nhap (#11) + session detail (#12).
4. Sprint v2 trio (#14–16) — self-contained, localStorage queue logic must be ported (SM-2 + marathon intervals in `src/lib/sprint/`).
5. Community pages (#6, #10) — depend on community topics + comments backend surface.

## Key color/type tokens to mirror in Flutter
- CTA gradient: orange-500 #f97316 → orange-600 #ea580c; secondary rose gradient only on topic-list group toggle (`from-primary to-rose-600`).
- Teil identity: 1 = blue (600/50), 2 = violet (600/50), 3 = green (700/50); Teil points 40/40/20.
- Score colors: ≥80 green-600, ≥60 amber-600, else red-600; word count <50 muted / ≤200 green / >200 amber (mock: 50–120 red/green/yellow).
- Error-type chip palette (GradingResultCard): purple/red/orange/amber/yellow/blue/cyan/slate/pink per type.
- Emoji-first iconography: ✉️💬📋⚡📅✍️🎉🥇🥈🥉📏💾📤🔒 etc.

## Unresolved questions
1. Should Flutter port the **legacy telc schreiben-view page (#13)** as-is, or converge it onto the shared WritingPracticePanel (web keeps a duplicated older implementation)?
2. Sprint queue persistence: web uses localStorage card-queue + SM-2; is offline-first persistence (Hive/SharedPreferences) acceptable divergence, and must Marathon timers survive app restarts like web tabs?
3. Detail page (#4) inner card components (TaskCard, UsefulPhrasesCard, ModelAnswersCard, UebungenSection with embedded exercises, autoplay TTS FAB) were not scouted line-by-line (~15 files) — need a follow-up scout before implementing #4.
4. Premium gating (5 free topics/teil, official locked flag, UpgradeBanner) — does the mobile release expose payments, or should locked states deep-link elsewhere?
5. Existing Flutter mocks (`goethe_b1_writing_page.dart`, `ai_writing_practice_page.dart`, orphaned `writing_topics_list.dart`) — delete or keep behind release flags during rebuild?
