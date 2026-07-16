# Goethe B1 Writing Detail Page — Mobile Visual Spec (component deep-read)

Source page: `thamkhao/deutschtiger-frontend/src/pages/exam/goethe-b1-writing-detail-page.tsx`
Component dir: `thamkhao/deutschtiger-frontend/src/components/exam/goethe-b1-writing/`
Scope: mobile viewport (<768px). `md:`/`sm:` desktop-only classes noted where they change mobile behavior (`sm:` = 640px, still applies at 640–767px — flagged below).

Color key (Tailwind → hex): orange-500 `#f97316`, orange-600 `#ea580c`, orange-400 `#fb923c`, orange-50 `#fff7ed`, orange-100 `#ffedd5`; amber-50 `#fffbeb`, amber-200 `#fde68a`, amber-400 `#fbbf24`, amber-500 `#f59e0b`, amber-700 `#b45309`; blue-500 `#3b82f6`, blue-600 `#2563eb`, blue-400 `#60a5fa`, blue-50 `#eff6ff`; green-500 `#22c55e`, green-600 `#16a34a`, emerald-500 `#10b981`, emerald-600 `#059669`; red-500 `#ef4444`, red-600 `#dc2626`; violet-500 `#8b5cf6`, violet-700 `#6d28d9`; sky-500 `#0ea5e9`; rose-500 `#f43f5e`. Semantic: `foreground`, `muted-foreground`, `card`, `muted`, `border`, `primary` (orange) from app theme.

---

## 1. Page states (before main render)

| State | Condition | UI |
|---|---|---|
| Redirect | invalid teil (`teil-1..3`) / invalid slug / topic not found | Navigate away to teil list |
| Loading | `useTopic` pending | 3 pulsing skeleton bars (`h-5 w-1/3`, `h-4 w-1/2`, `h-4 w-1/4`, `bg-muted`, rounded), page padding `px-4 pt-3 pb-5` |
| Intro topic | `topic.isIntro` | BackButton + `titleDe` (text-lg bold) row, then `IntroMarkdownView(bodyMarkdown)` — full markdown prose (orange list markers, orange-tinted blockquotes), words tappable → dictionary sheet |
| Locked | official premium lock OR free-tier limit (5 free topics/teil, `isGoetheB1WritingTopicLocked`) | BackButton + title row; amber card (`border-amber-200 bg-amber-50/70`, dark `border-amber-900/50 bg-amber-950/20`, p-5, rounded card): bold sm "Đề này dành cho tài khoản Premium" + copy (official: "Đây là đề chính thức Premium…" / legacy: "Tài khoản miễn phí chỉ xem 5 đề đầu của mỗi Teil…") + `UpgradeBanner(module='exam')` full variant |

`hasFullAccess = isPremium || hasModule('exam')`.

## 2. Block order, top → bottom (main render)

Whole page wrapped in `WritingAutoplayProvider(onStart=openAllSections)`. Content container `px-4`, main `py-5 pb-28`, font-scaled via `--reader-scale` CSS var (0.85–1.6, step 0.1, persisted key `goethe-b1-writing-reader-scale`).

1. **DetailHeader** (back + title + FontSizeControl in rightSlot; badges; meta row with WritingAutoplayFab start button in metaSlot)
2. **ProvenanceCard** (amber "Đề thật" provenance box) — hidden if no examDates/sources/keywords/lastReviewed
3. Sections in `space-y-3` (each anchor `id` has scrollMarginTop 80):
   - `sec-aufgabe` — **TaskCard** (NOT collapsible; only section always expanded)
   - `sec-task-analysis` — Collapsible "🎯 Phân tích đề (Task analysis)" default OPEN → **TaskAnalysisCard**
   - (no TOC id) — Collapsible "🏗️ Cấu trúc bài viết" defaultOpen → **TextStructureCard** *(note: not in TOC list, uncontrolled — openAllSections does NOT force it open)*
   - `sec-redemittel` — Collapsible "💬 Mẫu câu hữu ích" default OPEN → **UsefulPhrasesCard**
   - `sec-beispiele` — Collapsible "✏️ Câu mẫu theo điểm" default OPEN → **SampleSentencesCard**
   - `sec-muster` — Collapsible "📝 Bài mẫu" default OPEN → **ModelAnswersCard**
   - `sec-grammatik` — Collapsible "📐 Ngữ pháp trọng tâm (tham khảo)" default CLOSED → **GrammarFocusCard**
   - `sec-wortschatz` — Collapsible "📚 Từ vựng trọng tâm (tham khảo)" default CLOSED → **WortschatzBoxCard**
   - `sec-fehler` — Collapsible "⚠️ Lỗi thường gặp (tham khảo)" default CLOSED → **CommonMistakesCard**
     *(NOTE: DOM order is grammatik → wortschatz → fehler, but TOC lists fehler before wortschatz)*
   - `sec-uebungen` — Collapsible "🎯 Bài tập luyện" default OPEN → **UebungenSection** (shown if `uebungen?.length || uebungenRaw`)
   - `sec-luyen-go` — **TypingPracticeStartCard** (pt-2)
   - `sec-luyen-viet` — if `hasFullAccess`: **StartPracticeCta**; else premium-lock mini card + `UpgradeBanner compact` (pt-2; only when `topic.task` exists)
   - **Complete button** (only when logged in): centered pill, gradient emerald-500→600 (`#10b981→#059669`), rounded-xl px-6 py-3 text-sm font-bold white, shadow-md; content "🎯 Đánh dấu hoàn thành"; when already completed: green-500→600 gradient, "✓ Đã hoàn thành — Lưu lại", disabled (opacity-60); pending: "Đang lưu...". On success navigates back to teil list.
4. **FloatingTOC pill** — `fixed bottom-20 right-4 z-50` (above bottom nav)
5. **WritingAutoplayFab active bar** — when autoplay active: `fixed top-3 right-3 z-50`

Each section renders only if its topic field exists. TOC only lists visible sections.

## 3. Floating / sticky elements

### FloatingTOC (defined inline in page file)
- Trigger pill: `rounded-full bg-card border border-border px-3.5 py-2 shadow-lg text-xs font-semibold`, content = active section emoji + label (truncate max-w-140px) + chevron-down svg 12px (rotates 180° when open).
- Popup (opens upward): `absolute bottom-full right-0 mb-2`, `bg-card border border-border rounded-xl shadow-xl p-1.5`, column of rows `min-w-44 max-h-[60vh] overflow-y-auto`; row = emoji + label, `px-3 py-2 rounded-lg text-sm`; active row `bg-orange-50 text-orange-600 font-semibold` (dark `bg-orange-950/30 text-orange-400`), idle `text-foreground` hover `bg-muted/60`. Outside-tap closes.
- TOC entries (id / label / emoji): sec-aufgabe/Đề bài/📋, sec-task-analysis/Phân tích đề/🎯, sec-redemittel/Cụm mẫu/💬, sec-beispiele/Câu mẫu/✏️, sec-muster/Bài mẫu/📝, sec-grammatik/Ngữ pháp/📐, sec-fehler/Lỗi hay gặp/⚠️, sec-wortschatz/Từ vựng/📚, sec-uebungen/Bài tập/🎯.
- Active section tracked by IntersectionObserver (rootMargin `-80px 0px -60% 0px`). Tap: if target collapsible → force open it, wait 60ms, smooth-scroll to anchor.

### FontSizeControl (`components/exam/shared/font-size-control.tsx`) — in header rightSlot
Pill `rounded-lg bg-card border border-border`, 3 segments: `A−` btn (text-xs bold) | `NN%` (text-[10px] muted, tabular-nums, `border-x border-border`) | `A+` btn (text-sm bold). Range 85–160%, step 10, disabled at ends (opacity-40). Persisted in local store.

### WritingAutoplayFab (`writing-autoplay-fab.tsx`)
- **Idle** (rendered inline at right end of header meta row, not fixed): pill button `rounded-full` gradient orange-500→600, `px-4 py-2.5 text-xs font-bold text-white shadow-lg`, play triangle svg 16px + "Phát toàn bộ (N)" where N = total autoplay sentences. Hidden if N=0.
- **Active** (replaces itself with fixed bar `fixed top-3 right-3 z-50`): `rounded-full bg-card border border-border px-2 py-1.5 shadow-lg`, row: prev btn (skip-back svg, muted, disabled at 0) · play/pause circle btn (playing → orange-500 pause icon; paused → green-500 play icon; white icon, p-1.5 rounded-full) · next btn · counter `i/total` text-[11px] semibold muted tabular · close X btn (hover red).

### Autoplay behavior (writing-autoplay-context.tsx)
- `start(sentences)`: registers as exclusive audio, opens ALL controlled collapsible sections (page `openAllSections`), waits 350ms, plays playlist sequentially.
- Per sentence: prefer `audioUrl` (HTMLAudio) else browser TTS (`speakDe`, rate 0.95) else 1.5s dwell → advance. Auto-scrolls current sentence into view (skips scroll if already within comfortable zone: top ≥96px, bottom ≥100px from bottom).
- While active: every card force-shows Vietnamese translations (`useAutoplayActive`), nested Collapsibles force-open, current sentence highlighted `ring-2 ring-orange-500` (+ often `bg-orange-50/60 dark:bg-orange-950/20`); long texts with subSegments highlight the current sub-line `bg-orange-100 dark:bg-orange-900/30` proportional to audio time.
- Playlist = `flattenGroups(collectPracticeSentences(topic))` — document-order groups: task (📋) → task-analysis (🔍, points+subpoints+approaches) → text-structure (🏗️) → phrases-i (💬, per category) → samples-i (✏️, per point) → model-i (📝, whole model as 1 item if audioUrl w/ sentence subSegments, else split) → grammar (📐 examples) → wortschatz (📚 kernwort examples m→f→n→other, then chunks). commonMistakes excluded. Dedup per group, min length 3.

## 4. Shared atoms (used inside almost every card)

### Collapsible (`collapsible.tsx`) — REUSED by topic-list page
`card-sm overflow-hidden` container. Header button full-width `p-3`, title `text-lg font-bold text-orange-600 dark:text-orange-400` left, chevron-down svg 16px muted right (rotate-180 open), hover `bg-muted/50`. Body `p-3 pt-0`, animated height transition 200ms ease-out. Children lazy-mounted on first open. Supports controlled (`open`/`onOpenChange`) and uncontrolled (`defaultOpen`). Emoji lives in the title string.

### AudioPlayBtn (`audio-play-btn.tsx`)
Icon button `p-1.5 rounded-md`. States: idle → phosphor **SpeakerHigh** (16, regular) muted-foreground, hover bg-muted; playing → phosphor **Pause** (16, fill) with `bg-primary/10 text-primary`; loading (TTS only) → spinner svg. Plays `audioUrl` file if present (exclusive-audio singleton: starting one stops all others incl. autoplay); else one-shot TTS of `text` (skips if >1000 chars). Toggle to stop. These are the ONLY phosphor icons on the page besides UpgradeBanner's **Lock**; everything else is inline SVG or emoji.

### ShowTranslationToggle (`show-translation-toggle.tsx`)
Small bordered pill: eye svg 12px + label. OFF: "Hiện dịch", `bg-muted/40 text-muted-foreground border-border`; ON: "Ẩn dịch" (eye-slash icon), `bg-blue-500 text-white border-blue-500`. Sizes: sm `px-2 py-1 text-[11px]`, xs `px-1.5 py-0.5 text-[10px]`. Per-card local state, default OFF; autoplay overrides to shown.

### TappableText / TappableMarkdown + useWordLookupSheet
All German text is word-tappable → opens dictionary word-lookup bottom sheet (each card owns one `sheet` instance). Flutter equivalent: tap-word → dictionary sheet.

### BackButton (`components/shared/back-button.tsx`), variant "header"
Circle 36×36 (`h-9 w-9 rounded-full bg-muted/60 dark:bg-white/10`), chevron-left svg 16px muted, active scale-95.

---

## 5. Per-component specs

### DetailHeader (`detail-header.tsx`)
- Row 1: BackButton(header) + column: `titleDe` text-xl bold leading-tight; `titleVi` text-sm muted italic mt-0.5; rightSlot (FontSizeControl) flex-shrink-0.
- Row 2 badges (`flex-wrap gap-1.5`): textType pill (`rounded-full px-2 py-0.5 bg-amber-50 text-amber-700 text-[11px] font-bold`, dark amber-950/30 / amber-400); difficulty pill — easy "Dễ" green-50/green-700, medium "TB" amber-50/amber-700, hard "Khó" red-50/red-700 (dark `*-900/30` bg, `*-400` text); frequency stars `★★★★☆` text-xs amber-500; "HOT" pill (orange-50/orange-600) when stars ≥5.
- Row 3 meta (`text-xs muted, gap-3, flex-wrap`): `📏 ~{taskWordCount.target} từ` · `📊 {examDates.length} lần thi` · `⏱ {durationMin} phút` · metaSlot (autoplay start pill) pushed right via ml-auto.
- Data: titleDe, titleVi, textType, difficulty, frequencyStars, taskWordCount.target, examDates.length, durationMin.

### ProvenanceCard (`provenance-card.tsx`)
Amber box `rounded-xl border border-amber-200 bg-amber-50/60 px-4 py-3` (dark amber-800/40 / amber-950/20), mb-4.
- Header: 📅 + "Đề thật — {N} lần thi" (text-sm bold) + optional pill `⭐ 5/5` (amber-100/amber-700) when stars ≥5.
- Sources row: "Nguồn:" + per source icon (gdocs 📂, link 🔗, default 📄) + label (link → primary underlined, external) separated by `·`.
- Expander: `▶ Xem ngày ra đề chi tiết` text-xs primary (▶ rotates 90° open) → dates line `dd/mm/yyyy · dd/mm/yyyy …` text-xs muted.
- Keyword chips: `rounded-full bg-muted px-2 py-0.5 text-[11px] muted`.
- Footer: `Reviewed: {lastReviewed}` text-[11px] muted/60.
- Data: examDates[], sources[{label,url,type}], topicKeywords[], frequencyStars, lastReviewed. Hidden when all empty.

### TaskCard (`task-card.tsx`) — sec-aufgabe, plain card (not collapsible)
`card p-4 space-y-3`. Highlight ring-2 orange-500 when autoplay current group=`task`.
- Header row: h2 "📋 Đề bài" text-lg bold orange-600/orange-400 · right: ShowTranslationToggle (if task.vi) + AudioPlayBtn(task.de, task.audioUrl).
- Task quote: blockquote `border-l-4 border-orange-400 bg-orange-50/50 dark:bg-orange-950/20 pl-3 pr-3 py-2 rounded-r-md`. DE markdown text-sm, list markers orange-500. VI ON → line-by-line interleave: per DE line + its VI line below (VI: text-xs blue-600/blue-400 italic); mismatched line counts fall back to DE block then VI block with orange top border. Autoplay sub-line highlight bg-orange-100.
- `taskVariant` (optional): native `<details>` violet box `rounded-md border-violet-200 bg-violet-50/40 px-3 py-2` (dark violet-800/40 / violet-950/20); summary "🔀 Biến thể đề thi" text-xs semibold violet-700/violet-300; body markdown text-xs.
- "Cần đề cập:" (points pulled from `taskAnalysis.points`): top border separator, label text-xs semibold, then `<ol>` decimal, markers orange-500 bold; item DE text-sm medium (+ VI xs blue italic when toggled).
- Data: task.de, task.vi, task.audioUrl, taskVariant, taskAnalysis.points[].de/vi.

### TaskAnalysisCard (`task-analysis-card.tsx`) — inside 🎯 collapsible
- Optional `summaryVi` paragraph: text-sm muted italic.
- Point cards (space-y-2.5), accent rotates by index (orange → sky → violet → emerald), each: `rounded-lg border {accent-300/`dark`-700/50} bg-{accent}-50/40`:
  - Header p-3: numbered circle badge 24px (`bg-{accent}-500 text-white text-xs bold rounded-full`) + point.de text-sm semibold (tappable) + right: ShowTranslationToggle(xs) + AudioPlayBtn. VI below when toggled (text-xs italic blue).
  - Subpoints `<ul>` px-3 pb-3: 1×1 dot in accent color + sp.de text-sm + inline AudioPlayBtn + optional VI.
  - Approaches (Teil 2): footer strip `border-t border-border/40 bg-card/50` with toggle button "💡 {n} cách triển khai" text-xs semibold accent-color + chevron; expanded list: each approach in `rounded-md bg-card/70 p-2.5 ring-1 ring-border/50` with mini number badge 20px + de + AudioPlayBtn + optional VI. Local expand state, forced open by autoplay.
- Data: taskAnalysis.summaryVi, points[].{de,vi,audioUrl,subpoints[],approaches[]}.

### TextStructureCard (`text-structure-card.tsx`) — inside 🏗️ collapsible
Horizontal-scroll table (`overflow-x-auto`, `w-full text-sm border-collapse`). Header row bg-muted, cells `p-2 border border-border` semibold. Columns: Phần (whitespace-nowrap medium) | Tiếng Đức (de tappable + AudioPlayBtn right) | Tiếng Việt (muted) | Tip — Tip column HIDDEN on mobile (`hidden sm:table-cell`). Zebra rows `bg-muted/30`. Autoplay row highlight outline orange.
- Data: textStructure[].{part,de,vi,tip,audioUrl}.

### UsefulPhrasesCard (`useful-phrases-card.tsx`) — inside 💬 collapsible
One NESTED Collapsible per category (title = `cat.category`, default CLOSED, forced open in autoplay). Inside: same table pattern as TextStructure — columns Tiếng Đức (de + AudioPlayBtn) | Tiếng Việt | "Dùng khi" (hidden <640px). Zebra + autoplay outline.
- Data: usefulPhrases[].{category, rows[].{de,vi,whenToUse,audioUrl}}.

### SampleSentencesCard (`sample-sentences-card.tsx`) — inside ✏️ collapsible
Groups (space-y-4), per group: header row with `group.point` text-sm semibold + ShowTranslationToggle(xs), bottom border. Sentences (space-y-2): row card `bg-muted/30 rounded-md p-2` — de text-sm (tappable) + AudioPlayBtn right; VI below when shown (text-xs blue italic). Autoplay: ring-2 orange + orange-50/60 bg.
- Data: sampleSentences[].{point, sentences[].{de,vi,audioUrl}}.

### ModelAnswersCard (`model-answers-card.tsx`) — inside 📝 collapsible
- Tabs when >1 model: `rounded-md px-3 py-1.5 text-xs font-semibold` — active `bg-orange-500 text-white`, idle `bg-muted/40 muted`; label `Model {i+1} ({wordCount}w)`; bottom border under strip. Autoplay auto-switches active tab to the playing model.
- Active model title text-sm semibold.
- Control row: left label uppercase text-xs muted "Tiếng Đức" / "Song ngữ Đức + Việt"; right: ShowTranslationToggle + AudioPlayBtn(model.de, model.audioUrl) + **"Gõ lại" button** (pencil svg 14px + text, gradient orange-500→600, `rounded-md px-2.5 py-1 text-xs font-semibold text-white shadow-sm`) → opens TypingPracticeSheet scoped to this model only.
- Body: `rounded-md p-3 bg-muted/30` (autoplay: ring orange + orange bg) → **BilingualSentenceInterleave**: VI hidden → single DE paragraph text-sm whitespace-pre-wrap; VI shown → per paragraph, DE sentence + VI sentence (text-xs blue italic) interleaved (paragraph/sentence-count fallbacks to block pairing). Autoplay sub-sentence highlight bg-orange-100.
- Annotations: "Chú thích:" text-xs semibold + bullet list (orange • , text-xs muted).
- Data: modelAnswers[].{title,wordCount,de,vi,annotations[],audioUrl}.

### GrammarFocusCard (`grammar-focus-card.tsx`) — inside 📐 collapsible (default closed)
Items (space-y-3): `bg-muted/30 rounded-md p-3 space-y-2`:
- `pattern` text-sm bold; optional `structure` as code chip (`bg-card border rounded px-2 py-1 font-mono text-xs`);
- `example` text-sm in orange-600/orange-400 (tappable) + AudioPlayBtn right;
- "Khi dùng:" note box `bg-amber-50 dark:bg-amber-950/30 border-l-2 border-amber-400 px-2.5 py-1.5 text-xs text-amber-800/amber-300` (uses `when` else `vi`).
- Data: grammarFocus[].{pattern,structure,example,vi,when,audioUrl}.

### WortschatzBoxCard (`wortschatz-box-card.tsx`) — inside 📚 collapsible (default closed)
Legacy fallback: if only `flat[]`, table Tiếng Đức (+AudioPlayBtn) | Tiếng Việt | Ghi chú (hidden <640px).
Structured (space-y-2), three NESTED Collapsibles:
1. **"🔑 Kernwortschatz (N từ)"** defaultOpen: filter pill row — "Tất cả N" (active `bg-foreground text-background`) + genus pills der/die/das/— with counts (der=blue-100/blue-700 idle, blue-500 active; die=rose; das=emerald; other=muted) + optional right button `🌐 Dịch ví dụ` (blue-50/blue-600 rounded-full, spinner while loading; calls Google Translate for examples missing example_vi). List grouped by genus m→f→n→other; group header: genus pill + name (Maskulin/Feminin/Neutrum/Khác) + `· count` (uppercase text-xs muted). Word card: `card-sm p-3 border-l-4 {genus color: blue-500/rose-500/emerald-500}` — `de` text-base semibold + `— vi` muted; example row italic text-sm /80 (tappable) + AudioPlayBtn; `→ example_vi` muted; `Coll: {collocation}` text-xs orange. 1-col grid on mobile (2-col ≥640px). Autoplay forces filter "Tất cả" + ring highlight.
2. **"🧩 Chunks & Wendungen (N cụm)"** default closed: card-sm `border-l-4 border-l-amber-500`, chunk text-sm semibold + AudioPlayBtn, vi text-xs muted, `→ useCase` text-[11px] italic orange.
3. **"🔗 Konnektoren (N từ nối)"** default closed: card-sm `border-l-4 border-l-violet-500 px-3 py-2`, de text-sm bold + `— vi` truncate + AudioPlayBtn; `position` text-[11px] muted below.
- Data: wortschatzBox.{kernwortschatz[].{de,genus,vi,example,example_vi,collocation,audioUrl}, chunks[].{chunk,vi,useCase,audioUrl}, konnektoren[].{de,vi,position,audioUrl}, flat[]}.

### CommonMistakesCard (`common-mistakes-card.tsx`) — inside ⚠️ collapsible (default closed)
Table: columns "❌ Sai" (red-600/red-400 line-through, tappable) | "✅ Đúng" (green-700/green-400 medium + AudioPlayBtn) | "Giải thích" hidden <640px. Zebra rows. Mobile extra: below table, numbered explanation lines `1. {vi}` text-xs muted (`sm:hidden`).
- Data: commonMistakes[].{wrong,correct,vi,audioUrl}.

### UebungenSection (`uebungen/uebungen-section.tsx`) — inside 🎯 collapsible
- Tab pills (flex-wrap gap-1.5): per exercise, `rounded-full px-3 py-1.5 text-xs font-semibold min-h-[34px]` — active gradient orange-500→600 white shadow-sm; idle bg-muted. Content: kind emoji + short label + `i/total` tabular. Kind meta: cloze 🧩 "Điền từ", word-order 🔀 "Sắp xếp", match 🎯 "Ghép cặp", error-correction 🩹 "Sửa lỗi", mini-write ✏️ "Viết câu".
- Active exercise panel: `p-3 rounded-lg border border-border bg-card`.
- Prev/Next row (when >1): bordered buttons "← Trước" / "Tiếp →" (`rounded-lg border px-3 py-2 text-xs min-h-[36px]`, disabled opacity-40) + center counter `i / total`.
- Per-exercise state + active tab persisted in sessionStorage (`exercise-session-storage`, scope = teil+slug).
- Fallback: no structured exercises but `uebungenRaw` → UebungenMarkdownFallback (compact prose markdown).

#### ClozeExercise
Title text-sm semibold. Per question: `rounded-xl border bg-muted/20 p-3`; inline flow: `{i}.` + textBefore + option buttons (`rounded-lg border px-3 py-2 text-sm min-h-[44px] min-w-[72px]`; selected=orange-100/border-orange-500; after check: correct=green-100/border-green-500, wrong-selected=red-100/border-red-500) + textAfter (muted). Optional VI hint bar `bg-blue-50 text-blue-800 text-xs rounded-lg` (dark blue-950/40, blue-200). Options seeded-shuffled (stable). Footer: "Kiểm tra" btn `bg-orange-500 text-white rounded-lg px-4 py-2 min-h-[44px]` (disabled until all answered) → after check per-item explanation (correct: green italic xs; wrong: red xs "Đáp án đúng: **X** — explanation") + **ExerciseResultBanner**.

#### WordOrderExercise
Per question: VI prompt bar (blue-50, `{teilIdx}.{i}.` bold); answer zone `min-h-[44px] rounded-lg border p-2 flex-wrap` (empty: "Chọn từ bên dưới…" xs muted; after check green-50/border-green-400 or red-50/border-red-400) containing placed token chips (tap to remove, shows ×); token pool below: chips `min-h-[44px] rounded-lg border bg-card px-2.5 py-1.5 text-sm` (tap to place; duplicates handled by count). "Kiểm tra" enabled when all pools consumed. Wrong → `Đúng: {correct}` red xs; explanation/note muted xs. Comparison normalizes case+punctuation.

#### MatchExercise (tap-to-pair)
Mobile instruction banner (blue-50 text-xs, "Cách làm: chọn 1 cụm từ ở Cột A…" — desktop variant hidden on mobile). Two stacked columns on mobile (grid 1-col; headers "Cột A — Cụm từ" / "Cột B — Chức năng" uppercase xs, mobile-only). Item buttons `min-h-[52px] rounded-xl border px-3 py-3 text-left text-sm` with number prefix; selected → orange border/bg; wrong pair → red flash 550ms then deselect; correct pair → both disappear. Matched pairs accumulate in "Đáp án đã ghép" box (`border bg-muted/30 p-3`, rows `bg-background p-2 text-xs`: phrase → function, + vi/explanation). All matched → ResultBanner (always 100%). Malformed data → red error card.

#### ErrorCorrectionExercise (AI-graded)
Header: title + bulk "🤖 Chấm N câu" gradient-orange btn (when ≥2 pending). Per question: wrong-sentence card `rounded-lg border bg-red-50/70 p-3` ("{i}. CÂU SAI" uppercase red xs; wrong italic; wrongVi xs on bg-background/70); textarea 2 rows (`rounded-lg border bg-background p-2 text-sm`, focus ring-2 orange-500, umlaut auto-replace oe→ö etc.); button "🤖 Nhờ AI chấm" gradient orange (spinner "Đang chấm…" while loading) + `[errorType]` tag xs muted. Graded result box `rounded-lg border bg-muted/40 p-3`: score pill `X/10` gradient orange rounded-full + "AI đã sửa" blue pill; summary_vi xs; "Câu nên dùng:" box (emerald label + q.correct + correctVi/explanation muted); corrections list (original rose line-through → corrected emerald semibold + explanation). Error → red xs box. All graded → ResultBanner (correct = exact-match count). Exact-match answers skip the AI call (synthetic 10/10).

#### MiniWriteExercise (AI-graded)
Same header/bulk-grade pattern. Per prompt: VI prompt bar (blue-50, numbered); optional `Mẫu: "{patternDe}"` xs orange italic; textarea (same styling, umlaut auto-replace); buttons: "🤖 Nhờ AI chấm" gradient orange + "Xem câu mẫu" bordered ghost (reveals sampleAnswer box blue-50: "Câu mẫu: _..._" + sampleAnswerVi). Idle-prefetch: auto-grades silently 1.5s after typing stops. GradeFeedback box: score pill gradient varies (≥8 emerald, ≥5 amber→orange, else rose) + badge chips ✓/✗ ("Đúng pattern" if patternDe, "Ngữ pháp", "Tự nhiên"; ok=emerald-100/emerald-700, fail=rose-100/rose-700); "Bạn đã gửi:"; summary_vi; "Đã sửa:" (emerald) if corrected differs; corrections list. No ResultBanner.

#### ExerciseResultBanner (shared)
`p-3 rounded-lg border flex justify-between`: `{emoji} {correct}/{total} câu đúng ({pct}%)` — ≥80% green scheme 🎉, ≥50% yellow 💪, else red 📚; right "Làm lại" ghost btn (border-current, min-h-36px).

### TypingPracticeStartCard (`typing-practice/typing-practice-start-card.tsx`) — sec-luyen-go
`card` gradient `from-orange-50 to-amber-50` (dark orange-900/20→amber-900/15) border orange-200. Mobile: centered column (`px-5 py-6 text-center`): ✍️ emoji text-4xl; "Luyện gõ bài này" text-base bold; "Có **{total}** câu tiếng Đức trên trang — chọn câu bạn muốn gõ lại…" text-sm muted; full-width CTA "Bắt đầu gõ →" gradient orange-500→600 `px-5 py-2.5 text-sm font-semibold text-white shadow-md`. Opens **TypingPracticeSheet** (all groups, persisted per `topic.slug`). Hidden when 0 sentences.

### TypingPracticeSheet (modal, portal) + Picker + Runner
- Overlay `fixed inset-0 z-[55] bg-black/60 backdrop-blur-sm`; panel on mobile = full-screen column (`max-h-[100dvh] bg-card`; ≥640px becomes centered rounded-2xl max-w-2xl). Header: orange uppercase xs label "✍️ Chọn câu để gõ lại" / "✍️ Gõ lại từng câu" + subtitle (topic/model title, truncate) + X close. Body scroll-locked; ESC closes. Skips picker if ≤1 sentence.
- **Picker**: top bar "Đã chọn **n** / N câu" + "Chọn hết · Bỏ hết" links; scrollable group list — per group `card-sm`: checkbox (accent-orange, indeterminate state) + `{emoji} {label}` semibold + `sel/total` + chevron expand; expanded → divided list rows: checkbox + de text-sm + vi xs italic muted. Groups auto-expanded when ≤3. Sticky footer full-width CTA gradient orange "Bắt đầu gõ n câu →" (disabled when 0: "Chọn ít nhất 1 câu"). Selection persisted (debounced 250ms).
- **Runner**: top 4px progress bar (gradient orange, animated width). Scroll area: **NavList** (`rounded-xl border bg-muted/20`: header "Danh sách câu" + score glyphs `✓n ✗n ↷n ○n` + "✓ Kết thúc" emerald chip btn; collapsed = horizontal chip strip, chips numbered + status glyph, colors: pending muted, correct green-100/700, wrong red-100/700, skipped amber-100/700, current ring-2 orange, auto-scrolls; expanded = vertical jump list max-h-35vh with truncated DE) + control row: back-to-picker chevron, "Câu i / total" xs, right: "VI" toggle (blue-500 when on), "👁 Xem" reveal toggle (amber-500 when on), AudioPlayBtn, save-to-deck btn (compact SaveCardButton; logged-in only).
- Runner sticky bottom (above keyboard, safe-area padded): optional VI hint box (border-l-2 blue-300 bg-blue-50/50 italic; auto-translates DE→VI when missing); sentence display box `rounded-xl bg-muted/40 p-3 min-h-64px max-h-28vh scroll` — 3 modes: masked (per-word `••••` mono muted/40), revealed (plain text-base semibold), diff after submit (word-by-word: correct green semibold; wrong = user word red line-through + expected green dotted-underline); input = SpecialCharBar (ä ö ü ß, shown while focused) + textarea 2 rows `rounded-xl border bg-card px-4 py-3 text-base` (Enter submits, umlaut auto-replace); action row: "Bỏ qua" secondary + "Kiểm tra ↵" gradient green-500→emerald-600 white. Post-submit feedback card: correct → green-50 "✓ Chính xác!"; wrong → amber-50 "✗ Còn vài chỗ chưa đúng" + hint + "↻ Thử lại" secondary; "Tiếp →"/"Hoàn thành →" gradient orange (auto-focused). Completion screen: giant grade emoji (🎉≥90 👏≥70 👍≥50 💪), grade text 2xl bold, "Bạn đã gõ xong N câu", 3 stat tiles (Đúng green / Sai red / Bỏ qua amber, card-sm), green progress bar + "{pct}% chính xác", buttons "↻ Gõ lại từ đầu" secondary + "Đóng" gradient orange; "← Chọn câu khác" link below. Progress persisted per slug (resume).

### StartPracticeCta (`start-practice-cta.tsx`) — sec-luyen-viet (premium only)
Full-width button `rounded-xl bg-gradient-to-r from-orange-500 to-orange-600 px-4 py-3 text-sm font-semibold text-white` with pencil svg 16px: "Viết bài cá nhân → AI chấm". Navigates to `ROUTE_PATHS.goetheB1WritingPractice(teil, slug)` → goethe-b1-writing-practice-page (hosts **WritingPracticePanel** — separate surface, NOT rendered on this page).

### Premium-lock variant of sec-luyen-viet (non-premium)
Stack: `card-sm border-amber-200 bg-amber-50/80 p-4` (dark amber-900/50 / amber-950/20): "Luyện viết với AI là tính năng Premium" text-sm semibold + xs muted copy; below → **UpgradeBanner compact**: link row `rounded-lg border-l-4 border-primary bg-primary/5 px-3 py-2`, phosphor **Lock** 16 primary + "Mở khóa {module name} — {price}" text-xs medium → premium page.

---

## 6. Interaction summary (Flutter mapping)

| Interaction | Behavior |
|---|---|
| Section header tap | Toggle collapse (animated height 200ms); page keeps per-section open map so TOC/autoplay can force-open |
| TOC pill | Open menu upward → tap = force-open target section + scroll to anchor (80px offset) |
| A−/A+ | Scale all reader text 85–160%, persist |
| "Phát toàn bộ (N)" | Start sequential audio playlist; open all controlled sections; show fixed top-right transport bar (prev/pause-resume/next/counter/stop); highlight + auto-scroll current sentence; force-show all VI + nested collapsibles |
| Any speaker icon | Play that item's audioUrl (fallback TTS); exclusive — stops other audio |
| "Hiện dịch/Ẩn dịch" | Per-card VI reveal (interleaved bilingual) |
| Word tap (any DE text) | Dictionary lookup bottom sheet |
| "Gõ lại" (model) | Typing sheet scoped to that model |
| "Bắt đầu gõ →" | Typing sheet: picker (checkbox groups) → runner (mask/type/diff/score) with localStorage resume |
| Exercises | Local check (cloze/word-order/match) or backend AI grading (`gradeSentence`/`gradeSentencesBatch`, level B1) for error-correction/mini-write; per-exercise sessionStorage persistence |
| "Viết bài cá nhân → AI chấm" | Navigate to writing practice page (premium-gated) |
| "🎯 Đánh dấu hoàn thành" | POST result (`useSaveGoetheB1WritingResult` {teil, slug}) → navigate back to teil list |
| "🌐 Dịch ví dụ" | Batch Google-Translate untranslated Kernwortschatz examples |

## 7. Data fields consumed (DTO checklist)

From `lib/goethe-b1-writing/types.ts` (`GoetheB1WritingTopic`): slug, teil, isIntro, isStub, titleDe, titleVi, difficulty, frequencyStars, topicKeywords[], durationMin, textType, examDates[], taskWordCount{min,target,max}, sources[{label,url,type}], lastReviewed, task{de,vi,audioUrl}, taskVariant, taskAnalysis{summaryVi, points[{de,vi,audioUrl,subpoints[{de,vi,audioUrl}],approaches[{de,vi,audioUrl}]}]}, textStructure[{part,de,vi,tip,audioUrl}], usefulPhrases[{category,rows[{de,vi,whenToUse,audioUrl}]}], sampleSentences[{point,sentences[{de,vi,audioUrl}]}], modelAnswers[{title,wordCount,de,vi,annotations[],audioUrl}], grammarFocus[{pattern,structure,example,vi,when,audioUrl}], wortschatzBox{kernwortschatz[{de,genus,vi,example,example_vi,collocation,audioUrl}],chunks[{chunk,vi,useCase,audioUrl}],konnektoren[{de,vi,position,audioUrl}],flat[{de,vi,note,audioUrl}]}, commonMistakes[{wrong,correct,vi,audioUrl}], uebungen[] (`uebungen-types.ts`: cloze/word-order/match/error-correction/mini-write discriminated union), uebungenRaw, bodyMarkdown. Page also uses: `ResolvedTopic.isOfficialLocked`, manifest teils[].topics (for legacy free-count lock), completed results list (`topic_slug` match), premium/purchase flags.

## 8. Reuse map

- **Shared with goethe-b1-writing-topic-list page**: `Collapsible` (topic-cluster groups), `GoetheB1WritingLeaderboard`, `TopicListItem`, `IntroListItem`, `TeilPickCard` (list/teil pages only — not on detail page). Build `Collapsible` once, reuse.
- **Shared atoms across both + practice**: `AudioPlayBtn`, `ShowTranslationToggle`, `BilingualSentenceInterleave`, `TappableText/TappableMarkdown` + word-lookup sheet, `BackButton`, `FontSizeControl` (also used by other exam readers — generic `useReaderFontScale(storageKey)`), `UpgradeBanner`, `SpecialCharBar` (shared with practice module), `SaveCardButton` (dictionary module), umlaut auto-replace helper, `ExerciseResultBanner`.
- **WritingPracticePanel** (`components/writing/writing-practice-panel.tsx`) is NOT rendered by the detail page — only reached via StartPracticeCta navigation; separate spec needed for the practice page.
- Autoplay context/FAB and typing-practice suite are exclusive to this detail page.

## Unresolved questions

1. TOC order (fehler before wortschatz) vs DOM order (wortschatz section actually renders before fehler? — no: DOM order is grammatik → wortschatz → fehler while TOC lists grammatik → fehler → wortschatz). Decide whether Flutter mirrors DOM or TOC; recommend DOM order + same TOC labels for pixel parity.
2. `sm:` breakpoint (640px) hides table "Tip/Dùng khi/Giải thích/note" columns and switches some layouts — at 640–767px the web already shows desktop-ish variants; for the Flutter "<768 = mobile" rule, confirm using the <640px rendering (recommended).
3. `🌐 Dịch ví dụ` calls the public Google Translate endpoint directly from the client — decide whether Flutter reuses backend translate service instead.
4. Autoplay TTS fallback uses browser SpeechSynthesis; Flutter needs a device-TTS equivalent for sentences without audioUrl.
