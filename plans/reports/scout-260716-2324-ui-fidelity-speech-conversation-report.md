# UI Fidelity Scout — Speech Ecosystem (Sprechen / Conversation / Pronunciation)

Scope: web mobile viewport (<768px, base tailwind classes) vs Flutter app. Web = source of truth (`thamkhao/deutschtiger-frontend`, synced from prod 2026-07-16).

**Bottom line: 0 of 19 live web pages have a faithful Flutter counterpart.** Flutter has 11 speaking/pronunciation screens, all English-labeled prototype scaffolds (Material AppBar + ListTiles) that match neither web layout, colors, typography, block order, nor routes. Recommended: rebuild the whole cluster; delete/replace all existing Flutter speaking screens.

Semantic colors referenced below: `primary` = orange (#F7931E-ish, `--color-primary`), CTA gradient = `from-orange-500 to-orange-600`, cards = `bg-card` + `border-border` + rounded-xl/2xl, `bg-muted` chips.

---

## A. Shared web component: `SprechenExamMode` (powers ALL sprechen exam pages)

File: `src/components/exam/sprechen/sprechen-exam-mode.tsx` (+ `sprechen-exam-header.tsx`, `sprechen-instruction-banner.tsx`, `sprechen-study-panel.tsx`, `sprechen-partner-chat.tsx`, `sprechen-input-area.tsx`, `sprechen-bewertung-panel.tsx`, `sprechen-session-history-sheet.tsx`).

Fullscreen `h-dvh` column, mobile stacks everything vertically (lg: grid 3fr/2fr — ignore):

1. **Sticky header** (`sticky top-0 z-20 border-b bg-background`): left = bold German subheader ("Sprechen, TEIL 2 • Thema diskutieren — slug") + xs muted pill subtitle ("Teil 2 · 30 Punkte · 6 Min"). Right, practice tab: "Zeit/Restzeit" 9px label + mm:ss timer, blue `bg-blue-600` ABGABE button (check-circle icon, label hidden <sm), red `bg-red-600` EXIT button (logout icon). Study tab: bordered "Lịch sử" (clock icon) + "Zurück" (arrow-left) buttons.
2. **Study tab** (route without `/practice`): full-width orange-gradient CTA "Luyện thi ngay / Nói chuyện với AI · Nhận phản hồi tức thì" with white/20 mic circle + arrow; **amber instruction banner** (`bg-amber-50 dark:bg-amber-500/20`, "Aufgabe:" bold red, "Hinweis:" bold green, tappable words); `SprechenStudyPanel` — per-teil study cards: Teil1 = sky strategy-guide accordion + numbered Q&A cards (sky number circle, Bài mẫu, 📌 Redemittel chips); Teil2 = 📄 Lesetexte card (Person A green / B purple), 📝 Zusammenfassung, 🗣️ Argumente & Meinungen accordions (💬 Meinung / 🎯 Erfahrung / ✅ Vorteile / ❌ Nachteile), 🎤 Mustervortrag; Teil3 = 📋 Aufgabe amber card + 📌 Aspekte accordion + 🎯 Musterdialog collapsible. Every German line: speaker button (spinner→equalizer states) + lazy "Dịch" VI translation.
3. **Practice tab**: pre-start card — Teil2 Person A/B selector (border-2, green vs purple selected); đề bài amber cards (`border-amber-200 bg-amber-50/60`, "📝 Aufgabe" 10px bold amber uppercase, SpeakButton, TappableText, 🇻🇳 Dịch toggle pill); collapsible "Xem ảnh đề gốc" `<details>` with task-card image; "Partner đọc (TTS)" checkbox; disabled-aware full-width orange gradient "▶ Bắt đầu". After start: `<details open>` "📄 Đề bài" compact collapsible; then **SprechenPartnerChat**.
4. **SprechenPartnerChat**: rounded-2xl bordered card. Header: Tiger logo avatar in `bg-primary/10` circle, "Tiger — Prüfer / Hỏi cá nhân" bold xs + "Trả lời bằng tiếng Đức"; speed selector (3 segmented pills in `bg-muted`); TTS toggle (speaker / animated 4-bar equalizer while playing / spinner while loading). Messages: user = `bg-primary text-white rounded-2xl rounded-tr-sm` right-aligned, max-w-82%, below it "Dịch" + colored feedback badge pill "x/5 · phản hồi" (green ≥4 / amber ≥3 / red) opening a feedback popup; assistant = `bg-muted rounded-tl-sm` with mini Tiger avatar, replay + Dịch row; typing = 3 bouncing dots.
5. **SprechenInputArea** (border-t): Viết mode = suggestion chips (bulb.webp toggle button, amber ring when open), 2-row textarea (focus ring primary), stacked bulb + orange-gradient send buttons (h-30px w-10); Mic mode = MicPanel: live transcript box ("Chờ kết nối…"/"Hãy nói gì đó…"), action row [Dừng ⏸ / Tiếp tục nói ▶ green] [Sửa ✏ → red-bordered textarea edit] [Hủy ✕] [Gửi orange gradient, right-aligned]; bottom bar = Viết/Mic segmented selector (w-36) + benefit hint text.
6. **SprechenBewertungPanel** (below chat on mobile): card with "✏ Bewertung / max. N"; LAUFEND green-dot status vs Idle; big score `x/N`; **⚡ Live Feedback** amber-bordered box (câu vừa nói italic, điểm câu này /5, comment + Dịch, "Gợi ý sửa" amber sub-box); category rows INHALT / GRAMMATIK & SATZBAU / WORTSCHATZ & FLÜSSIGKEIT (each /N÷3); GESAMT bold row; "Lỗi chính" amber-bullet list (teil2/3).
7. **Result screen** after ABGABE: centered card, green check circle `bg-green-100`, "Hoàn thành!", 3xl black `computedTotal / maxScore` in primary, "Quay lại danh sách" outline + "Luyện lại" orange gradient.
8. **Modals**: "Nộp bài?" (Hủy / Nộp bài orange) and "Thoát bài thi?" (Tiếp tục thi / red "Thoát & Nộp bài") on black/50 backdrop; **SprechenSessionHistorySheet** bottom sheet.

Flutter: **nothing equivalent exists.** This is the single biggest missing component.

---

## B. Page-by-page

### 1. Goethe Sprechen overview — `goethe-sprechen-overview-page.tsx`
- Route `/exams/goethe/b1/sprechen` (standard layout, PracticeScrollWrapper).
- Structure: BackButton + "Nói — Sprechen" (text-lg bold) + "Goethe B1 · 3 phần · 75 Punkte" xs muted → single `card divide-y` with 3 Teil rows → info card.
- Teil row: 10×10 rounded-xl tinted emoji tile (Teil1 🤝 `bg-amber-50`, Teil2 🎤 `bg-rose-50`, Teil3 💬 `bg-blue-50`); bold accent title (amber-600/rose-600/blue-600) + "25 Punkte" 10px badge pill + subtitle (Gemeinsam Planen / Präsentation + Q&A / Diskussion); VI desc truncate; 1px-high gradient progress bar (`from-amber-500 to-amber-600` etc.) + `completed/total`; right: phosphor `CheckCircle` fill green-500 when all done, else chevron-right SVG.
- Flutter: **MISSING**. Verdict: **MISSING**.

### 2. Goethe Sprechen topic list — `goethe-sprechen-topic-list-page.tsx`
- Route `/exams/goethe/:level/sprechen/:teil` (teil ∈ goethe-teil1..3).
- Header: BackButton + "Teil 1 — Gemeinsam Planen" + "N đề · x hoàn thành" (green). Body: collapsible tag-group cards (emoji 📁 fallback, label, `done/total`, rotating chevron; collapsed by default); expanded rows = numbered muted circle (global index), slug-as-words (done → muted), right icon: amber `Lock` (premium & !isPremium → premium toast), green `CheckCircle` fill, or faint `Circle`. Below list (mobile full-width): `SprechenLeaderboard`. Empty state: 🎤 4xl + "Chưa có đề bài". Loading: skeleton rows.
- Flutter: **MISSING**.

### 3. Goethe Sprechen Teil study — `goethe-sprechen-teil-study-page.tsx`
- Route `/exams/:providerLevel/:slug/sprechen/:teilSegment` (fullscreen route).
- Structure: BackButton → header: orange pill "Teil N" (`bg-orange-100 text-orange-700`), xl bold title (Gemeinsam Planen / Präsentation / Diskussion), "📋 Giám khảo chấm gì? →" primary link → `ExaminerRubricSheet` (GOETHE_B1_SPRECHEN rubric) → stacked cards (`space-y-4 pb-32`): `ImageCollapsible` (task-card image), `KeywordCard` (image_text), `TeilCardBody` (description + VI), `BulletHintsPanel`, `VocabularyPanel`, `RedemittelPanel` (all with TTS speak), VI show/hide toggle, `MusterBlock` (musterdialog DE/VI or explanation VI), collapsible card "🤖 Thử nói ngay — AI chấm điểm nhanh" → `SpeakingPromptQuestion` (recorder + AI grade).
- **Fixed bottom CTA bar**: `fixed inset-x-0 bottom-0 border-t bg-background/95 backdrop-blur pb-safe` with full-width orange gradient "🎤 Luyện nói cùng Tiger AI".
- Error/empty: centered card + orange "Quay lại". Flutter: **MISSING**.

### 4. Goethe Sprechen Teil practice — `goethe-sprechen-teil-practice-page.tsx`
- Route `…/:teilSegment/practice` (fullscreen). Thin wrapper: builds markdown from exam JSON (`buildTeilMarkdown`, teil3 links teil2 topic) → `SprechenExamMode` practice tab with partner-role override + examiner prompt. Loading: centered spinner + "Đang tải đề thi...".
- Flutter: **MISSING**.

### 5. Goethe Sprechen exam (topic) — `goethe-sprechen-exam-page.tsx`
- Routes `/exams/goethe/:level/sprechen/:teil/:slug` (study) and `…/practice` (practice); valid teile goethe-teil1/2. Pure wrapper → `SprechenExamMode`; tab change rewrites URL; onComplete saves result → back to topic list.
- Flutter: **MISSING**.

### 6. Goethe Sprechen exam-set overview — `goethe-sprechen-exam-set-overview-page.tsx`
- Route `/exams/:providerLevel/:slug/sprechen` (standard layout).
- BackButton → xl bold exam title + "Luyện Sprechen — chọn phần để bắt đầu" → (non-B1: 🚧 amber beta banner) → 3 `card-sm` buttons: emoji (🤝/🎤/💬), "TEIL N" xs uppercase muted + result badge ("✓ Hoàn thành" green ≥20 else "Best x/25" muted), bold title, 2-line clamped description, chevron. Tap → teil study.
- Flutter: **MISSING**.

### 7–8. `goethe-sprechen-from-exam-page.tsx` / `goethe-sprechen-from-exam-teil-page.tsx`
- **LEGACY / not routed**: `routes.tsx` maps `goetheSprechenFromExam(Teil)` to redirect components (`LegacySprechenFromExam*Redirect`) → new overview/study pages. Files still exported in `lazy-pages.tsx` but dead. **Do NOT port** — Flutter only needs the redirect semantics for deep links `/exams/goethe/:level/sprechen/from-exam/:slug(/:n)`.

### 9. TELC Sprechen overview — `sprechen-overview-page.tsx`
- Routes `/exams/telc-b1/noi`, `/exams/telc/b1/noi`. Identical layout/markup to page 1 but: back → telc b1, subtitle "telc B1 · 3 phần · 75 Punkte"; teile = Teil1 👋 sky (Kennenlernen, 15 Punkte), Teil2 🎤 rose (Vortrag, 30), Teil3 🤝 amber (Gemeinsam planen, 30); info card "Sprechen chiếm 75/300 điểm…".
- Flutter: **MISSING**.

### 10. TELC Sprechen topic list — `sprechen-topic-list-page.tsx`
- Route `/exams/telc/b1/noi/:teil`. Same as page 2 **plus**: search card (`card-sm` with magnifier SVG, `type=search` input "Tìm theo tên đề hoặc nhóm chủ đề...", "Xóa" chip; diacritic-insensitive; count becomes "x/N đề"; search auto-expands groups; no-match state 🎤 + hint), and below-list `CommunityTopicsSection` (provider=telc, skill=speaking) above `SprechenLeaderboard`.
- Flutter: **MISSING**.

### 11. TELC Sprechen exam — `sprechen-exam-page.tsx`
- Routes `/exams/telc/b1/noi/:teil/:slug(/practice)`; teil1 allowed without slug. Wrapper → `SprechenExamMode` (content auto-loaded; teil1 uses question pool).
- Flutter: **MISSING**.

### 12. Conversation hub — `conversation-hub-page.tsx` ⭐ bottom-nav tab 4 "Hội thoại"
- Route `/conversation` (standard layout).
- Mobile top→bottom: back button (h-9 w-9 bordered card) + "Hội thoại (AI)" xl bold + "Alltagsdeutsch · Khám phá & luyện nói" → **tab bar** in bordered card p-1: "Kịch bản" (ChatsCircle) / "Lịch sử luyện tập" (ClockCounterClockwise), active = orange gradient white → *(scenarios tab)* `InterviewLibrarySection` → **HERO**: rounded-3xl gradient `from-orange-50 via-rose-50 to-fuchsia-50` (dark: 950/30 variants) with giant 130px duotone `Microphone` watermark (orange-500/15, rotated −8°), pill "✨ AI tạo hội thoại tức thì" (`bg-white/70`), 2xl extrabold "Bạn muốn luyện nói về điều gì hôm nay?", 52px search input (Sparkle icon left, placeholder "Gõ chủ đề bất kỳ…"), level `<select>` + submit btn (walled → amber "👑" Crown / else ArrowRight, both orange-gradient with colored glow shadow), daily-limit row (free: "Còn x/4 bài miễn phí" + Crown "Không giới hạn"; walled: amber card + "Nâng Plus ✨"), "Thử ngay:" quick-suggest chips (`bg-white/75` rounded-full) → **filter card** (`card-sm`): "Hoặc chọn từ thư viện" + "N chủ đề" + "✕ Xoá lọc"; "THỂ LOẠI" CatPills (ConversationTopicIcon + label + count; active = solid `bg-foreground text-background`); divider; "CẤP ĐỘ" LevelPills (pastel CEFR colors via `levelBadgeClass`) → **results `grid grid-cols-2 gap-3`** of `ScenarioCard`s (gradient tile + icon per scenario) → empty: dashed-border "Tạo chủ đề riêng: „…"" CTA with amber-orange Sparkle tile, or MagnifyingGlass "Không tìm thấy chủ đề". History tab: `ConversationHistoryList`.
- Icons: phosphor CaretLeft, Sparkle, ClockCounterClockwise, ChatsCircle, X, ArrowRight, Microphone, MagnifyingGlass, Crown.
- Flutter: `lib/screens/speaking/conversation_hub_page.dart` at `/speaking/conversation-hub` — feature-flag-gated (`ENABLE_VOICE_CONVERSATIONS`, default off → PremiumGateCard "đang được phát triển"), AppBar "AI Conversation", header card + flat scenario list. **Verdict: DIVERGENT (rebuild)** — no tabs, no hero, no filters, no history, wrong route (web = top-level `/conversation`).

### 13. Conversation scenario (practice) — `conversation-scenario-page.tsx`
- Routes `/conversation/:id`, `/conversation/custom/:slug`, `/conversation/interview/play/:id` (standard layout, exit-guard).
- Gates: daily-limit `GameWallOverlay`; custom topics first show `ConversationSurveyScreen` (focus-point picker).
- Mobile main view: header row (title_de bold sm + ai_role xs; "⚖️ Giám khảo" bordered button with orange avg-score badge; Gear settings button; red `bg-red-500` "Thoát" with SignOut icon) → `ScenarioContextCollapsible` (+`InterviewHintPanel` for interviews) → grammar-targets strip "🗣️ Hôm nay thử dùng: …" (`bg-muted/60`) → **DialogRunner** fills rest:
  - Chat bubbles similar to partner-chat: AI rows with speaker button (spinner→equalizer), Dịch toggle rendering "VI" tagged translation bubble, per-AI-line pronunciation check (`ConversationPronunciationCheck`); user bubbles with colored "x/5 · phản hồi" badge → `FeedbackPopup`; pending = bouncing dots card.
  - **Suggestions panel** (lightbulb): amber rounded-2xl block, numbered suggestion buttons, "⭐ Nâng cao — câu trả lời mẫu đầy đủ" orange-gradient fetch button, VI-typing hint, "Tiger AI Memory" tip link.
  - **Composer**: 42px square mic button (`bg-muted`) · auto-grow textarea (16px font, orange focus ring, placeholder "Nhập hoặc nói tiếng Đức...") · stacked bulb + orange-gradient send (42px).
  - **Voice mode** (`ConversationVoiceMicPanel`): idle = 64px round orange-gradient mic + "Nhấn để nói" + "Quay lại gõ" pill; recording = 64px red button with `animate-ping` halo, mono mm:ss timer, **240×48 waveform canvas**, "Đang thu… nhấn để dừng"; transcribing = spinner; review = [Nghe lại][Thu lại][Gửi orange] buttons h-11, red error lines; free-tier "Còn n lượt nói miễn phí hôm nay"; quota-exhausted amber card ("Nâng cấp Premium ✨" / "Gõ để tiếp tục").
- Examiner bottom sheet (mobile): fixed 82vh rounded-t-2xl, "⚖️ Giám khảo AI" header + `ExaminerPanel`.
- Done screen: ConfettiBurst, 🎉, "Hoàn thành hội thoại!", amber-orange "+N XP" chip, "⚖️ Đánh giá tổng thể" verdict card, "Thực hành lại" orange / "Chọn kịch bản khác" secondary, "Báo lỗi / Góp ý".
- Exit dialog: "Thoát hội thoại? / Tiến trình hiện tại sẽ không được lưu."
- Flutter: `lib/screens/speaking/conversation_scenario_page.dart` — prototype: AppBar + vocab side-panel Row (desktop-style 280px column!), mock alternate bubbles, plain input. **Verdict: DIVERGENT (rebuild)**.

### 14. Conversation history detail — `conversation-history-detail-page.tsx`
- Route `/conversation/history/:id`. Back button + truncated title + "B1 · N lượt · dd/MM/yyyy hh:mm" → verdict card "⚖️ Đánh giá tổng thể" (`ExaminerVerdict`) → `ConversationTranscript` (read-only bubbles + per-turn feedback). Flutter: **MISSING**.

### 15. Interview import — `interview-import-page.tsx`
- Route `/conversation/interview/import` (premium). Back link ("Hội thoại" / "Sửa tài liệu") → 10×10 orange-gradient FileText tile + "Luyện phỏng vấn từ tài liệu" + xs desc → rose error banner. Step input: card with 12-row textarea (placeholder "Dán câu hỏi + câu trả lời…"), "hoặc tải lên tệp .md / .txt" + char counter x/60,000, CEFR pill row (active orange gradient), `btn-primary` "✨ Trích xuất câu hỏi". Step edit: title input card; per-question `card-sm` (Câu N + rose Trash, DE textarea, VI input, hint DE textarea `bg-muted`, hint VI input); `btn-secondary` "+ Thêm câu hỏi"; `btn-primary` "Lưu & bắt đầu luyện" → play route. Flutter: **MISSING**.

### 16. Pronunciation hub — `pronunciation-hub-page.tsx`
- Route `/pronunciation`. Back (→ /games) + xl bold "Luyện Phát Âm Tiếng Đức" → blue info banner (`card-sm bg-blue-50`, blue-900 text) → module grid (1-col mobile): card p-6 centered — 14×14 rounded-2xl gradient emoji tile, base semibold title, xs muted desc: Umlaute 🔤 violet→purple; Ich/Ach 🗣️ blue→cyan; R-Sound 🌀 emerald→teal; Sp/St 💬 amber→orange. (Minimal-pairs page is separate, not linked here.)
- Flutter: `lib/screens/pronunciation/pronunciation_screen.dart` at `/pronunciation` — orange AppBar "Phát âm", 4 ListTile cards (different titles/order/emoji: Âm R, Âm ch, Âm sp, Umlaute), **onTap empty (dead)**. **Verdict: DIVERGENT (rebuild)**.

### 17. Umlaute trainer — `umlaute-trainer-page.tsx`
- Route `/pronunciation/umlaute`. Gates: `GameWallOverlay` (game-plays). Header back + "Luyện Umlaute" → **mode toggle** `bg-muted p-1` segmented "Phát âm" / "Phân biệt" → drill: progress row ("i / 15" + violet umlaut chip) → word card p-8 centered (4xl bold word, `[IPA]` muted, VI meaning) → amber "Mẹo phát âm:" hint card → violet→purple gradient "▶ Nghe phát âm" (TTS `speakDe` 0.85, **no recording**) → emerald→teal "Tôi đã đọc →" (disabled until played). Phân biệt = shared `MinimalPairQuiz`. Completion: ConfettiBurst card, 6xl primary "NN%", "x / N đúng", "+XP" amber-orange chip, "Luyện lại" orange / "Quay lại" secondary.
- Flutter: `lib/screens/speaking/umlaute_trainer_page.dart` at `/speaking/umlaute` — "Umlaut Trainer" AppBar, uses `PronunciationPracticeWidget` recorder (web has NO recorder here), own MinimalPair model. **Verdict: DIVERGENT (rebuild)**.

### 18. Ich-/Ach-Laut — `ich-ach-laut-page.tsx`
- Route `/pronunciation/ich-ach-laut`. Same template as 17 with blue→cyan accents; drill chip = "Ich-laut [ç]" blue / "Ach-laut [x]" amber; word card adds "So sánh: minimal_pair". Quiz: card with 16×16 round blue→cyan play button ("Nghe và chọn từ bạn vừa nghe"), 2-col answer grid (word+IPA vs pair; green correct / red wrong), result strip (✓ Đúng rồi! / ✗ Chưa đúng + "Đang phát cả hai để so sánh..."), streak "🔥 n liên tiếp!", blue→cyan "Tiếp theo →". Flutter: `ich_ach_trainer_page.dart` — **DIVERGENT (rebuild)**.

### 19. R-Sound — `r-sound-page.tsx`
- Route `/pronunciation/r-sound`. Template of 17 with emerald→teal accents; second mode = **"overview"** (not minimal-pair): blue info card "Âm R tiếng Đức có 4 biến thể" + per-position cards (initial / after-vowel / consonant-cluster / vocalic colored chips) containing word+IPA pill grids. Flutter: `r_sound_trainer_page.dart` (English bullet tips + recorder) — **DIVERGENT (rebuild)**.

### 20. Sp/St initial — `sp-st-initial-page.tsx`
- Route `/pronunciation/sp-st`. Same template as 18 with amber→orange accents (drill play btn, quiz play circle, next btn all `from-amber-500 to-orange-600`). Flutter: `sp_st_trainer_page.dart` — **DIVERGENT (rebuild)**.

### 21. Minimal pairs — `minimal-pairs-page.tsx`
- Route `/pronunciation/minimal-pairs`. No game wall. 3 screens: **picker** (contrast list via `ContrastPicker`), **drill** (`DrillRound`: play buttons `speakWithAudioUrl(..., { tryTtsCache: true })`, orange gradient CTAs, per-round A/B choice, "Kết thúc" header button), **summary** (emoji 🎉/💪/🔁, 5xl orange-500 "NN%", "x / N câu đúng", encouragement <60%, "Luyện lại" orange / "Đổi cặp âm" secondary). Header back adapts per screen; drill shows `contrast.focus_label` subtitle. Flutter: **MISSING**.

---

## C. Flutter screens with NO web counterpart — delete/rebuild candidates

| Flutter file | Route | Notes |
|---|---|---|
| `lib/screens/speaking/speaking_screen.dart` | `/speaking` | 3-tab mock (Shadowing/Pronunciation/AI Chat), English, mock providers. No web `/speaking` route. **Delete.** |
| `lib/screens/speaking/speaking_hub_screen.dart` | `/speaking/hub` | SliverAppBar gradient hub, English. No web counterpart. **Delete.** |
| `lib/screens/speaking/shadowing_page.dart` | `/speaking/shadowing` | "Shadowing Practice" mock. No web shadowing page exists. **Delete.** |
| `lib/screens/exam/goethe_speaking_page.dart` | (imported by router) | "Teil A/B/C — Reading Statement / Discussion / Phone Message" — matches no web page (web Goethe = Teil 1–3 Planen/Präsentation/Diskussion). **Delete.** |
| `lib/features/pronunciation/widgets/pronunciation_practice.dart` | — | Claims "synced từ web" but **unreferenced anywhere**. **Delete.** |
| `lib/widgets/speaking/pronunciation_practice_widget.dart` | — | Recorder widget used by the 4 trainers — web trainers are listen-only (no recording). Drop with trainer rebuild. |
| `lib/features/voice/*` (record_button, recording_service, voice_providers) | — | Only used within features/voice; evaluate for reuse in conversation voice mode / SpeakingPromptQuestion, else delete. |
| Trainer routes `/speaking/umlaute|r-sound|ich-ach|sp-st` | — | Web paths are `/pronunciation/umlaute`, `/pronunciation/r-sound`, `/pronunciation/ich-ach-laut`, `/pronunciation/sp-st`. Move + add `/pronunciation/minimal-pairs`. |
| Conversation routes `/speaking/conversation-hub`, `/speaking/conversation/:id` | — | Web: `/conversation`, `/conversation/:id`, `/conversation/custom/:slug`, `/conversation/history/:id`, `/conversation/interview/import`, `/conversation/interview/play/:id`. Conversation hub = **bottom-nav tab 4** on web mobile. |

## D. Assets needed from web `public/`

- `public/bulb.webp` — suggestion lightbulb icon (chat composers, both sprechen + conversation).
- `public/deutsch-tiger-logo.svg` / `tiger-icon.svg` — TigerLogo avatar in partner chat (already have app logo? verify visual match).
- Task-card images (`item.image_url`) are backend-served — no static asset.
- No waveform image: conversation recorder waveform is a live canvas; equalizer animations are CSS (`equalize` keyframes) — reimplement in Flutter animation.
- Phosphor icons used: CaretLeft, CheckCircle, Lock, Circle, Sparkle, ClockCounterClockwise, ChatsCircle, X, ArrowRight, Microphone, MagnifyingGlass, Crown, SignOut, Gear, FileText, Plus, Trash. Most other icons are inline SVGs (heroicons-style paths).

## E. Cross-cutting fidelity notes

- All pages fully theme both light/dark via semantic tokens + explicit `dark:` variants (e.g. `bg-amber-50 dark:bg-amber-950/30`) — Flutter build must map to equivalent dark palette.
- Recurrent primitives worth building once in Flutter: BackButton (h-9 w-9 bordered card), card/card-sm, orange CTA gradient button, segmented `bg-muted p-1` toggle, amber hint card, TTS speaker button with spinner/equalizer states, TappableText word-lookup, "Dịch" lazy translation, ConfettiBurst + "+XP" chip completion card, GameWallOverlay/PremiumGate, bottom sheet.
- Premium/limits UI is part of the visual spec: sprechen topic lock (amber Lock), conversation daily limit rows, voice-turn quota walls, game-plays wall on 4 trainers (not on minimal-pairs).
- Legacy from-exam pages must NOT be ported; only deep-link redirects.
