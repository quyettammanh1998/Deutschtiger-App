# UI Fidelity Scout — Exam Core + Community (mobile viewport)

Scope: web `src/pages/exam/*` core pages + `src/components/exam/mobile/*` player vs Flutter `lib/screens/exam/`, `lib/features/exam/`. Web = source of truth at <768px (default tailwind classes; `md:`/`lg:` ignored).

Legend: **MISSING** = no Flutter surface for the web mobile design · **DIVERGENT** = Flutter surface exists but visuals differ materially · **CLOSE** = minor diffs only.

---

## 1. Exam landing — `/exams`
- **Web:** `src/pages/exam/exam-landing-page.tsx`
- **Mobile structure (top→bottom):** back-button + title "Luyện thi" / subtitle "Chọn chứng chỉ & cấp độ" → AnnouncementBanner(page="exam") → buddy-finder CTA card (orange-50→amber-50 gradient, border orange-200/70, 44px orange-500→600 gradient icon square w/ `UsersThree`, "Tìm bạn ôn thi" + "Mới" pill `bg-orange-500/15 text-orange-600`, subtitle "Kết nối với người cùng ngày thi để ôn cùng nhau", `CaretRight` orange-500/70) → 3 provider cards (telc `#0a6cb6` / Goethe `#0a8a3c` / ÖSD `#c8102e` wordmark chips; name in provider accent color; **shortDesc line** under name; 2-col level pill grid w/ emoji + level + tier label, recommended = `ring-2 ring-primary` + "Đề xuất" label) → level-mismatch confirm dialog (centered modal, orange gradient "Vẫn tiếp tục") → SEO guide-links nav ("Hướng dẫn thi", 4 bordered link rows).
- **Flutter:** `lib/screens/exam/exam_screen.dart` + `lib/features/exam/presentation/widgets/exam_provider_cards.dart` (recently rebuilt).
- **Verdict: CLOSE** (residual diffs):
  1. Header: Flutter uses stock `AppBar(title: examPractice)` — web has back chip + bold title + subtitle "Chọn chứng chỉ & cấp độ".
  2. Provider card missing `shortDesc` line ("Visa, định cư, nhập tịch" / "Chứng chỉ quốc tế uy tín" / "Chứng chỉ tiếng Đức Áo").
  3. Buddy CTA missing subtitle line ("Kết nối với người cùng ngày thi…") — Flutter renders title+badge only.
  4. Recommended pill: web keeps emoji+tier label but swaps label to "Đề xuất" and rings with primary (2px orange ring is right in Flutter; label swap to "Đề xuất" missing — Flutter shows tier name in orange instead).
  5. Level pill tap: web navigates to `/exams/:provider-:level` section page; Flutter filters an inline catalog + shows `ChoiceChip` filter row + flat mock-exam card list — **none of this exists on web landing**. `_CatalogFilters`, `_ExamCatalogCard` list and the ActionChip links row (`_MoreExamToolsLinks`) are Flutter-only inventions.
  6. Missing: AnnouncementBanner, level-mismatch warning dialog, SEO guide-links block (guide links arguably N/A in-app, but dialog matters).
  7. Dark mode: Flutter buddy CTA hardcodes light gradient `0xFFFFF7ED→0xFFFFFBEB`; web has `dark:from-orange-950/30 dark:to-amber-950/20`, pills have `dark:bg-*-950/40` variants.
- **Assets:** none (emoji + CSS only).

## 2. Provider/level section page — `/exams/:provider-:level`
- **Web:** `exam-section-page.tsx`. Three variants: (a) TELC B1 bundle chooser — header (back + "telc Deutsch B1" + "2 bộ đề") → `ExamReadinessCard` → card w/ divide-y rows (emoji in `bg-muted` rounded-xl 40px square, title, desc, chevron); (b) book-cover chooser — 2-col grid of `aspect-[3/4]` cover cards (orange-400→600 gradient fallback + 📚), title + "N đề · skills"; (c) fallthrough → flat `ExamListPage`.
- **Flutter:** **MISSING** — no per-provider/level route exists (exam_screen filters inline instead). `lib/screens/exam/exam_list_page.dart` is a hardcoded "Đề thi Goethe B1" AppBar + generic mock-exam cards; nothing renders bundles, readiness card, or book covers.
- **Assets:** book covers come from backend `/data/{cover}` (runtime URLs, not bundled).

## 3. Exam set list + detail — `/exams/:provider-:level/:slug`
- **Web:** `exam-list-page.tsx` + `listing/exam-list-item.tsx`, `listing/exam-part-card.tsx`, `listing/exam-set-leaderboard.tsx`, `exam-readiness-card.tsx`.
- **Mobile structure — list view:** header (back + provider name + "N bộ đề · X hoàn thành(green) · Y đang làm(amber)") → ExamReadinessCard → single card w/ `divide-y` rows: 40px circular index badge (`bg-muted`; completed = green-500 circle + white `Check`; started = amber-100/amber-700; locked = `Lock` + 50% opacity row) | title + title_vi | mini progress bar + score/N-of-M | chevron → pagination "Trước · Trang X / Y · Tiếp" (chevron SVGs, text-primary) → free users locked after index ≥5.
- **Mobile structure — detail view (slug):** header (back + set title + "N phần") → card w/ divide-y `ExamPartCard` rows (skill icon 40px rounded-xl tinted square: Lesen sky / Hören purple / Schreiben amber / Sprechen rose; title + subtitle; action buttons row: "Luyện thi" orange gradient pill, "Luyện tập" green-600 pill, "Chat AI" sky→indigo gradient pill, dictation shortcut) + special Schreiben row for A-RAP → `ExamSetLeaderboard` below (mobile stacked).
- **Flutter:** **MISSING** as a page. Closest: `exam_catalog_list.dart` card (provider/level orange badges, quiz/timer info row, two full-width buttons) — completely different design and information architecture (no per-skill parts, no completion states, no readiness card, no leaderboard, no pagination, no premium lock).
- **Assets:** none.

## 4. Skill list — `/exams/:provider/:level/:section/:skill`
- **Web:** `exam-skill-list-page.tsx`. Header (back + "📖 Leseverstehen" style emoji+German label + "N đề · X hoàn thành") → card divide-y rows: circular index/Check badge (green completed w/ `bg-green-50/50` row tint), title + title_vi, score % (green ≥80 else amber), violet "Từ vựng" dictation chip on TELC B1 Hörverstehen rows (Headphones icon, violet-50 bg/violet-200 border), CaretRight.
- **Flutter:** **MISSING** — no skill-scoped list route/screen.

## 5. Exam player — `/exams/:providerLevel/:slug/:skill/test|practice|review`
- **Web:** `exam-practice-page.tsx` → mobile components (source of truth): `mobile-test-layout.tsx`, `mobile-practice-layout.tsx`, `mobile-question-panel.tsx` (1036 ln), `mobile-reading-pane.tsx`, `mobile-footer-bar.tsx`, `mobile-nav-sheet.tsx`, plus shared `exam-practice-header.tsx`, `shared/question-nav.tsx`, `shared/highlight-toolbar.tsx`.
- **Mobile structure:**
  - **Header** (`exam-practice-header`, single compact row, `border-b bg-card px-2 py-1`): [Thoát/Kết quả chip when practice/review] · section title (xs, semibold) · **thin flex-1 progress bar** (h-1.5, orange-500→600 gradient fill) · timer (test mode, compact) + **pace dot** (green/amber/red 2px circle) · "?" reader-guide button · reader-settings button (font scale + highlight + word lookup) · "Câu X/Y" counter · **"Nộp bài" blue-500 pill** (test mode).
  - **Body:** section-screen mode (whole Teil per screen) is the norm — `MobileQuestionPanel` scrolls: `MobileReadingPane` (card w/ `border-l-2 border-indigo-400`, "Đoạn văn" indigo heading, optional "Dịch đoạn văn" toggle in review, word-bank chips, numbered "Text N" / lettered-ad sub-cards w/ blue-600 number badges) + question cards; alt swipe mode = 3-panel horizontal strip w/ swipe gestures.
  - **Footer** (`mobile-footer-bar`, `border-t bg-card px-2 py-1.5`): section label (10px uppercase muted, left) · spacer · **prev square button 32px blue-500** (disabled `bg-muted`) · **center pill amber-100/amber-700 (`SquaresFour` icon + "X/Y")** toggles nav sheet · **next square button blue-500**.
  - **Nav sheet** (`mobile-nav-sheet`): fixed bottom sheet, `rounded-t-2xl bg-card`, max-h 70dvh, drag handle bar, title "Danh sách câu hỏi"/"Luyện tập" + X close, then `QuestionNav`: per-Teil groups w/ uppercase header + answered/total counter, 6-col grid of h-10 number buttons — current = blue-500 filled; answered = blue-50 + blue-400 border; review: green/red 2px borders; legend row + Đúng/Sai/Chưa làm stats in practice/review.
  - Confirm dialogs: "Xác nhận nộp bài" (Nộp bài/Làm tiếp), "Thoát khỏi bài thi?" (destructive).
- **Flutter:** `lib/features/exam/presentation/exam_practice_page.dart` + widgets.
- **Verdict: DIVERGENT (heavily)** — Flutter player is an older original design, not the web mobile player:
  1. Header: Flutter = MinimalShell AppBar w/ title + grid/close IconButtons, then a second `_TopBar` w/ ExamModeToggle + timer, then a labeled progress bar, then `ExamSectionTabs` — web has ONE compact row, no mode toggle in player, no section tabs (sections navigated via footer/nav-sheet), submit lives in header as blue pill.
  2. Body: Flutter = one question per screen (`_QuestionView`); web mobile = whole-Teil scroll (section screen mode) with reading pane card design (indigo left-border) and auto-advance to next unanswered.
  3. Footer: Flutter = Outlined "Trước" + Filled "Tiếp"/"Nộp bài" wide buttons; web = 32px blue square arrows + amber counter pill that opens the nav sheet; section label at left.
  4. Palette: Flutter overlay is white sheet w/ title row; web is rounded-t-2xl card sheet w/ drag handle, per-Teil grouping, 6-col grid, color semantics (blue current/blue-50 answered/green/red review) + legend.
  5. Colors: Flutter uses `ExamDesignTokens.examPaperColor` white surfaces and `examSuccess` green submit; web uses semantic bg-card/bg-background, blue-500 nav & submit, orange progress gradient. No dark theme in Flutter player (hardcoded `Colors.white`).
  6. Missing web features w/ visual footprint: pace dot, reader settings/guide buttons, highlight toolbar, word-lookup, "Dịch đoạn văn", locked audio player (test mode), comment section per question (review), swipe strip.
- **Assets:** none (icons phosphor → use equivalent glyphs).

## 6. Exam result — `/exams/.../:skill/result`
- **Web:** `exam-result-page.tsx` + `listing/result-summary.tsx`, `smart-exam-review-card.tsx`, `next-action-card`, `history/attempt-history-list.tsx`, `comment` section. Mobile stack: header (back + part title) → ResultSummary card → SmartExamReviewCard → NextActionCard → "Lịch sử làm bài" AttemptHistoryList → CommentSection.
- **Flutter:** `lib/features/exam/presentation/exam_result_page.dart` — overall score card (white, exam tokens) + section breakdown + actions. **DIVERGENT:** missing smart review card, next-action card, attempt history, comments; header is MinimalShell w/ "Xong" TextButton vs web back+title; styling uses exam tokens not semantic card.
- Note: `lib/screens/exam/exam_result_page.dart` (809 ln) is **dead code** — not referenced by router or any import.

## 7. Exam readiness — `/exam-readiness`
- **Web:** `exam-readiness-page.tsx` (+ `readiness/exam-readiness-goal-header|score-trend|skill-bars|weakness-list`). Structure: back+title "Sẵn sàng thi"+subtitle → `PageIntro` (why/todo/next card) → goal header → ReadinessBand card (3xl bold "low–high%" colored green/amber/red by mid, orange gradient range band on muted track w/ 0/50/100 ticks) → 3 `StatPill`s row (Số lần thi / Điểm TB gần đây / Điểm cao nhất) → score-trend → skill bars → weakness list → "Việc cần làm" card (amber/red bullet links) → "Từ thi sai" checklist (FailWordRow: checkbox accent-orange, word+IPA+🔊, VI gloss, level chip) + "Thêm N từ vào ôn tập" btn-primary.
- **Flutter:** `lib/screens/exam/exam_readiness_screen.dart`. **DIVERGENT:** has band card (plain, no colored % / no range bar visualization w/ ticks), plain label/value stat rows instead of 3 pill boxes, default-blue `LinearProgressIndicator` skill bars (web colored bars), weakness cards ok-ish; missing PageIntro, goal header, score trend, "Việc cần làm", entire fail-words checklist + add-to-review flow.

## 8. Exam schedule / buddy finder — `/tim-ban-on-thi`
- **Web:** `exam-schedule-page.tsx` (+ `exam-buddy-list/form`, `buddy/exam-buddy-aside|trust`). Public page w/ own sticky header (tiger-icon.svg logo + "Deutsch Tiger", login/“Vào học →” link) → h1 + subtitle → orange BuddyCountStrip ("🔥 N bạn còn hạn lịch thi…", orange-50 bg / orange-200 border) → pill tab buttons ("Danh sách bạn ôn thi" / "Thông tin của tôi", active = bg-primary white shadow) → buddy list / form → aside (stacked below on mobile) → trust block (anon).
- **Flutter:** `lib/screens/exam/exam_schedule_screen.dart`. **DIVERGENT:** Material `TabBar` under AppBar instead of pill buttons; missing count strip, aside card, trust block, contact-reveal (known gap, deliberate); buddy card generic bordered card — web buddy rows have their own layout (not read in depth here; see `exam-buddy-list.tsx` when rebuilding).
- **Assets needed:** `public/tiger-icon.svg`.

## 9. Exam dictation — `/exams/:provider-:level/:slug/dictation`
- **Web:** `exam-dictation-page.tsx`. Structure: compact header (ArrowLeft icon btn + "Luyện từ vựng — Bài nghe {TELC B1}") → **activity menu**: 3 `card-interactive rounded-2xl` cards (🧩 Điền từ vào chỗ trống / ✍️ Nghe chép chính tả / 🎧 Nghe & đọc theo) → cloze prep: blue info banner (blue-50/blue-700), collapsible Teil transcript cards (blue Teil pill + "N từ" + ▸/▾), tappable dotted-underline words (selected = orange-100/orange-700), **sticky bottom bar** w/ selected-word chips (orange rounded-full, ×) + full-width orange gradient "Bắt đầu luyện nghe — N từ" (disabled 40%) → practice/dictation/karaoke sub-views (`dictation/exam-dictation-practice|full-practice|karaoke-view`).
- **Flutter:** `exam_dictation_picker_screen.dart` + `exam_dictation_screen.dart`. **DIVERGENT:** no activity menu (cloze only — no full dictation, no karaoke); no word-selection prep screen (auto-preselects first 12 words); inline TextField-per-word check UI instead of chip bar + start CTA; picker screen itself has **no web page equivalent** (web enters dictation from Hörverstehen skill-list rows — acceptable as app entry, but design is a generic card list).

## 10. Đề thi THPT list — `/de-thi`
- **Web:** `de-thi-list-page.tsx` (+ `de-thi/de-thi-site-header.tsx`). Public SEO page: site header → centered hero (h1 "Đề thi tiếng Đức" + sub) → exam cards (rounded-2xl card: level pill `bg-primary` + year pill amber-50/amber-300 border, bold title, skill line, amber disclaimer, "Bắt đầu làm →" primary) → mobile promo banner (orange-50 card w/ deutsch-tiger-logo.svg 36px, "Học tiếng Đức toàn diện hơn", "Thử ngay →") → trust section: FAQ accordion (divide-y card, ▾ rotate), "Giới thiệu Deutsch Tiger" + 4-col stats row (colored numbers #db2777/#0284c7/#7c3aed/#059669), 3 testimonial cards (gradient avatar circles, level pill), founder quote card (tiger-icon.svg 48px), orange-50→amber-50 CTA card → footer line.
- **Flutter:** `de_thi_list_screen.dart`. **DIVERGENT:** plain AppBar + bare bordered cards (title + "level · skill") — missing hero, level/year pills, disclaimer, CTA arrow, promo banner, FAQ, stats, testimonials, founder quote, footer.
- **Assets needed:** `public/deutsch-tiger-logo.svg`, `public/tiger-icon.svg`.

## 11. Đề thi THPT practice — `/de-thi/:code`
- **Web:** `de-thi-practice-page.tsx` (+ `de-thi/de-thi-passage-panel.tsx`, `de-thi-question-card.tsx`). Full-column app-like layout: header (bordered back square, level pill hidden on mobile, title, "answered/total" muted pill, "Nộp bài" orange gradient pill) → amber disclaimer strip (border-b amber-200, info icon) → progress strip (bg-muted/40: "Đoạn X/Y" + amber-400→orange-500 progress bar + x/y; after submit: "N/M câu đúng" + primary score pill + "Làm lại" bordered btn) → passage panel (top) → dashed divider → question cards → **footer bar**: "Đoạn trước" bordered btn · passage dot indicators · "Đoạn tiếp" primary-outline / "Nộp bài" orange gradient. One passage at a time; localStorage persistence; submit reveals translation+explanations.
- **Flutter:** `de_thi_practice_screen.dart`. **DIVERGENT:** renders ALL passages in one scroll, `RadioListTile` options, per-question "reveal answer" TextButton (web has no per-question reveal — submit-all model), no header progress/submit, no passage pagination footer w/ dots, no score strip, no retry, no persistence.

## 12. Community exams list — `/community-exams`
- **Web:** `community-exams-page.tsx`. Back + "Đề thi cộng đồng" → segmented tab bar (`bg-muted p-1` rounded, active `bg-background shadow-sm`): Duyệt đề / Đóng góp / Đề của tôi → Browse: select filter + Teil 1/2/3 toggle chips + search input w/ MagnifyingGlass → topic cards (title de/vi, "Goethe Viết T1" chip, 👤 contributor • date • RealExamBadge) → Contribute: radio type list, textarea, "Tạo đề bằng AI 🪄" primary button, preview card w/ Xuất bản (green-600) / Tạo lại → My topics w/ Trash delete.
- **Flutter:** `community_exams_list_screen.dart`. **DIVERGENT:** read-only single list — no tabs, no filters/search, no contribute flow; card shows vote count + verified icon (web list card doesn't show votes); missing RealExamBadge.

## 13. Community exam detail — `/community-exams/:id`
- **Web:** `community-exam-detail-page.tsx`. "‹ Quay lại" text link → badge row ("Cộng đồng" blue-100 chip, provider label, RealExamBadge) → title de/vi → contributor line → hidden-warning banner (yellow-50) → content sections as bordered cards w/ emoji headings (📝 Đề bài / 📋 Phân tích đề / ✍️ Bài mẫu / 💡 Cụm từ hữu ích / 📖 Ngữ pháp trọng tâm / ⚠️ Lỗi thường gặp — strikethrough wrong → green correct) → actions row: "Tôi vừa thi" emerald-600 + Xóa/Báo cáo → report bottom-sheet + SubmitRealExamModal.
- **Flutter:** `community_exam_detail_screen.dart`. **DIVERGENT:** renders only titles + raw `inputText` in one card + vote/version counters — none of the structured `generated_data` sections, no badges, no actions/report/submit-real modal.

---

## Flutter exam screens with NO web counterpart (delete/rebuild candidates)
| Flutter file | Status |
|---|---|
| `lib/screens/exam/exam_hub_screen.dart` (314 ln) | **Dead** — not imported anywhere. Delete. |
| `lib/screens/exam/exam_result_page.dart` (809 ln) | **Dead** — router uses `features/exam/presentation/exam_result_page.dart`. Delete. |
| `lib/screens/exam/exam_list_page.dart` | Routed but hardcoded "Goethe B1" list; web equivalent is section/list pages (#2/#3) — replace during that rebuild. |
| `lib/screens/exam/exam_dictation_picker_screen.dart` | No web page; web enters dictation from skill-list rows. Keep as app entry or fold into skill list once built. |
| `_CatalogFilters` + `_ExamCatalogCard` (in exam_screen/exam_catalog_list) | Flutter-only IA; web navigates to section pages instead. Remove when #2/#3 land. |
| `lib/screens/exam/widgets/exam_hub_card.dart` | Only used by dead exam_hub_screen (verify) — likely delete. |

## Assets to copy from `thamkhao/deutschtiger-frontend/public/`
- `tiger-icon.svg` (schedule header, login gate, founder quote)
- `deutsch-tiger-logo.svg` (de-thi promo sidebar/banner)
- Book covers are backend-served (`/data/...`) — no bundling needed.

## Cross-cutting fidelity gaps
- **Dark mode:** web styles every hardcoded color with `dark:`; Flutter exam surfaces hardcode light values (`Colors.white`, light gradients) — DesignTokens appear light-only in these files.
- **Semantic palette:** exam player should move off `ExamDesignTokens.examPaper*` to card/background/border tokens to match web.
- **Key shared web molecules to port once:** ExamReadinessCard, ExamListItem, ExamPartCard, QuestionNav sheet, ExamPracticeHeader, MobileFooterBar, MobileReadingPane, ResultSummary, RealExamBadge.

## Unresolved questions
1. Should Flutter adopt the web routing IA (landing → section page → set detail → skill list) or keep the flattened single-screen catalog? All of #2–#4 hinge on this.
2. Player rebuild scope: full section-screen mode + highlight/word-lookup/reader-settings, or visual-shell parity first (header/footer/nav-sheet/colors) with per-question flow retained?
3. Community contribute (AI generate) and buddy contact reveal are gated by product decisions (UGC moderation, PII) — parity for those tabs/actions or read-only stays?
4. De-thi pages are public SEO surfaces on web — does the app need the full promo/FAQ/testimonial trust block, or only the practice UX parity?
