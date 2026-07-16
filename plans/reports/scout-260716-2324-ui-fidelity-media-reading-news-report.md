# UI Fidelity Scout — Media / Reading / News surfaces (mobile viewport)

Scope: listening, youtube, video-library, interview, course, reading, news.
Web = source of truth (`thamkhao/deutschtiger-frontend`, mobile = default tailwind classes; md:/lg: ignored).
Verdicts: **MISSING** (no real Flutter equivalent), **DIVERGENT** (exists but visibly different), **CLOSE** (minor diffs).

Shared web building blocks used by most pages here (none exist in Flutter):

- `components/listening/video-collection-layout.tsx` — breadcrumb → header card (icon-in-rounded-square, title/subtitle, `rounded-xl border border-border bg-card px-4 py-3 shadow-sm`) → optional progress card → search input → tabs → status-filter chips (`Tất cả/Mới/Đang học/Đã xem` with counts) → 1-col card grid → pagination ("Trước / Trang x/y / Tiếp"). Sidebar (leaderboard) stacks BELOW the grid on mobile.
- `video-collection-card.tsx` — 16:9 thumbnail card, green ring when completed, status badges top-left (`bg-green-600/90 Đã xem`, `bg-amber-500/90 Đang học`), duration/badge bottom-right `bg-black/70`.
- `listening-source-card.tsx` — hub card: optional 16:9 thumb banner, 44px `bg-primary/10 text-primary` icon tile, "Sắp ra mắt" pill when inactive, "N video" in primary.
- `video-leaderboard-card.tsx`, `podcast-leaderboard.tsx`, `news-leaderboard.tsx`, `news-weekly-ring.tsx`, `reading-leaderboard.tsx`, `interview-leaderboard.tsx` — leaderboards visible on mobile (stacked at bottom). Flutter has none of them on these screens.

Global Flutter style drift seen on every screen in scope: `Scaffold`+`AppBar` with orange bold title vs web inline back-button + header card/breadcrumb inside scroll content; `AppColors.authBackground` light-only vs web semantic `bg-background` (dark-mode capable); orange/tigerOrange gradients where web uses per-surface accents (purple = podcast, red = YouTube, blue = level pills, green/amber = status).

---

## 1. Listening

### 1.1 Listening hub — `/listening`
- Web: `src/pages/listening/listening-hub-page.tsx` (+ `listening-source-card`, `page-intro`).
- Mobile structure: back btn + "Nghe" title + subtitle → PageIntro card (why/todo/next → link Kho từ) → section "Easy German" (5 cards A1–C1, each with YouTube `mqdefault` thumbnail banner, count "N video") → section "Khác": Sprechen B1 (145), Sprechen B2 (79), YouTube (user count), Podcast (48), Audiobook (inactive "Sắp ra mắt").
- Flutter: `lib/screens/listening/listening_hub_screen.dart`.
- Diffs: only 3 cards (Podcast/SprechenB1/SprechenB2 as gradient-icon rows), no Easy German level cards at all, no thumbnails, no PageIntro, extra stats strip (Đã nghe/Tổng số tập) that web doesn't have, title "Luyện nghe" vs "Nghe", no Audiobook/YouTube entries.
- Verdict: **DIVERGENT (major — content set differs, not just styling)**.

### 1.2 Easy German level pages — `/listening/easy-german/:level`
- Web: `easy-german-page.tsx` → `VideoCollectionLayout` + `VideoCollectionCard` + `VideoLeaderboardCard`. Level accent classes (a1 green, a2 teal, b1 blue, b2 orange, c1 red). Progress card, search, status filter, pagination, leaderboard.
- Flutter: **MISSING** — no screen, no route. Flutter `/listening/easy-german` is the *podcast* page (URL collides with web's level page namespace; web podcast lives at `/listening/podcast/easy-german`).
- Verdict: **MISSING**.

### 1.3 Easy German Podcast index — `/listening/podcast/easy-german`
- Web: `easy-german-podcast-page.tsx`. Mobile: back btn + purple hero card (purple-600 mic tile, gradient purple-50→purple-100/40 border-purple-200) → 2-col stats strip (N tập / N phút) → search (focus border-purple-400) → duration chips with counts (Tất cả/≤10/10–20/20–60/>60, active = solid purple-600) → episode rows (index number or green check, title, clock+duration, "N câu", purple play badge right) → pagination 30/page → `PodcastLeaderboard` below.
- Flutter: `easy_german_podcast_page.dart`.
- Diffs: orange theme everywhere (chips, gradient number tile, orange gradient play square) vs purple; filter = Tất cả/Đã nghe/Chưa nghe instead of duration buckets w/ counts; no stats strip; no pagination (full list); no leaderboard; card style boxed white w/ shadow vs bordered rows; light-only.
- Verdict: **DIVERGENT**.

### 1.4 Podcast player — `/listening/podcast/easy-german/:slug`
- Web: `easy-german-podcast-player-page.tsx`. Layout top→bottom: compact header (back, title + "Easy German Podcast", settings gear → `PodcastReaderSettingsDialog` with font-scale + VI toggle) → transcript fills middle (active sentence = purple-tinted rounded row `bg-purple-50/80 border-purple-300`, word-level highlight `bg-purple-500 text-white`, tap word → WordLookup, tap row → seek, auto-scroll centered, VI line purple-600 when active) → bottom sticky player bar (`border-t bg-card`): seek bar w/ purple thumb, controls row: −10s, 64px purple-600 play circle, +10s, speed pill pinned right (0.75/1/1.25/1.5/2, purple pill when ≠1).
- Flutter: `easy_german_podcast_player_page.dart`.
- Diffs: block order inverted — player bar + controls sit at TOP under header, transcript below (web: transcript middle, player pinned bottom); orange slider/gradient play vs purple; speed pill left of controls vs pinned right; header has translate toggle icon instead of settings dialog (no font scaling, no word lookup, no word-level highlight, no auto-scroll); active sentence orange 10% tint vs purple row w/ border; VI italic grey vs purple.
- Verdict: **DIVERGENT**.

### 1.5 Sprechen B1 / B2 — `/listening/sprechen-b1|b2`
- Web: `sprechen-b1-page.tsx` (145 hardcoded videos, tabs Teil 1 "Gemeinsam etwas planen" / Teil 2 "Ein Thema präsentieren"), `sprechen-b2-page.tsx` (79 videos) → full `VideoCollectionLayout` (orange chat-bubble header icon, progress, status filter, leaderboard, duration badges), cards navigate to `/listening/youtube/watch?v=`.
- Flutter: `sprechen_b1_page.dart`, `sprechen_b2_page.dart` = `ListeningComingSoon` placeholder ("sắp ra mắt").
- Verdict: **MISSING** (placeholder only).

## 2. YouTube

### 2.1 Tracker — `/listening/youtube`
- Web: `youtube-tracker-page.tsx` → `VideoCollectionLayout` with toolbarAbove = `YouTubeContinueWatching` + `YouTubePopularVideos` + `YouTubeAddForm`; red YouTube icon header; status filter Tất cả/Chưa xem/Đã xem; `VideoThumbnailCard` grid (thumbnail cards w/ delete); pagination 20/page.
- Flutter: `youtube_tracker_screen.dart` — functional (add form, popular strip, filter chips, list of `YouTubeVideoCard`), plus a stats row (Hôm nay/Tuần này/Tổng) web doesn't show here.
- Diffs: AppBar orange "YouTube" vs breadcrumb (Nghe › YouTube) + white header card w/ red icon; no Continue-Watching resume card; add form placement (Flutter first vs web after popular? web order: continue → popular → add form); Material ChoiceChips vs pill status bar with counts; vertical list rows vs thumbnail card grid; no pagination; extra stats row.
- Verdict: **DIVERGENT**.

### 2.2 Watch — `/listening/youtube/watch?v=`
- Web: `youtube-watch-page.tsx`. Mobile order: small "Quay lại" text-button → player (`YouTubeEmbeddedPlayer` incl. complete button under player) → "Toàn màn hình + song ngữ" cinema button (fixed black stage + rotate, floating subtitle overlay) → `YouTubeWatchVideoInfo` → transcript panel (always mounted, collapsible, float toggle) → `YouTubePracticeButtons` (Nghe chép chính tả / Shadowing) → `YouTubeVideoNotes`. Playlist sidebar hidden on mobile. Practice mode switches to dictation layout in place.
- Flutter: `youtube_watch_screen.dart` — AppBar "Xem video" + notes/transcript toggle icons; player; title + single orange "Đã hoàn thành/Xem lại" button; transcript/notes only via toggles.
- Diffs: no cinema/full-screen bilingual mode, no floating subtitle, no practice buttons (dictation/shadowing entry), transcript hidden behind toggle instead of inline below info, complete button placement/style, no watch-count ×N display, notes panel fixed 200px.
- Verdict: **DIVERGENT (major)**.

### 2.3 Dictation — `/listening/youtube/dictation?v=`
- Web: `youtube-dictation-page.tsx` — header (back, "Nghe chép chính tả" + video title, hide-video eye toggle) → 16:9 player → `DictationPanel` (sentence/word/cloze modes, settings dialog, +1 XP per correct sentence).
- Flutter: `youtube_dictation_screen.dart` = coming-soon stub.
- Verdict: **MISSING** (placeholder only).

### 2.4 Shadowing — `/listening/youtube/shadowing?v=`
- Web: `youtube-shadowing-page.tsx` — header (back, "Shadowing — Luyện phát âm" + title) → `YouTubeShadowingMode` with embedded player slot, auto-seek to sentence 1.
- Flutter: `youtube_shadowing_screen.dart` = coming-soon stub.
- Verdict: **MISSING** (placeholder only).

## 3. Video library

### 3.1 Tracker — `/library/:slug`
- Web: `video-library-tracker-page.tsx`. Mobile: back → title + description → thin progress bar + `x/y` + motivation line → single `card divide-y` list of groups: 40px index circle (green solid check when complete / amber when started / muted `01`-padded number), group_name_de + `name_vi · N video · duration(red)`, blue level pill, amber/green `completed/total`, caret. Group tap swaps in `VideoLibraryGroupDetail` in place.
- Flutter: `video_library_tracker_screen.dart` — same skeleton (progress bar, group tiles w/ check circle, in-place group video list).
- Diffs: AppBar (orange title) vs inline header; no motivation text; no blue level pill; no amber "started" state or per-group mini progress; numbers not zero-padded; separate rounded cards vs one divided card; group video list rows show thumbnails (web group detail = its own component with status cards); orange progress bar vs primary.
- Verdict: **DIVERGENT** (structure kept, styling/state colors off).

### 3.2 Watch — `/library/:slug/watch`
- Web: `video-library-watch-page.tsx`. Mobile: back → sticky player (`sticky top-0 -mx-2`) → title row (+×watch_count) → transcript panel (collapsible, floating subtitle option) → `CommentSection` → "Chưa xem (n)" / "Đã hoàn thành (n)" playlist card (thumbnail rows, active = primary border, completed = green border) → admin JSON upload.
- Flutter: `video_library_watch_screen.dart` — player, transcript behind AppBar toggle, title + orange complete button, plain "Video khác trong nhóm" list (no thumbnails, no pending/completed split).
- Diffs: no sticky player, transcript not inline, no comments, playlist not split by status / no thumbnails / no green-vs-primary borders, no floating subtitle, no ×watch_count.
- Verdict: **DIVERGENT**.

## 4. Interview

### 4.1 Tracker/roadmap — `/course/interview`
- Web: `interview-tracker-page.tsx` (28-line wrapper) = `PurchaseGate(module 'interview')` → back + "Luyện phỏng vấn" → `InterviewRoadmap` (identical visual language to video-library tracker: progress bar + emoji motivation, divided card list, blue level pill, amber/green states) → `InterviewLeaderboard` stacked below on mobile.
- Flutter: `interview_roadmap_screen.dart` (+`widgets/group_card.dart`), route `/lessons`.
- Diffs: no page-level purchase gate (Flutter gates per-group via 403 → PremiumRequiredView), title "Lộ trình video" vs "Luyện phỏng vấn", no total progress bar/motivation, no leaderboard, GroupCard styling differs from web divided list (not verified in file group_card.dart — likely card rows), navigates to a separate group screen instead of in-place swap.
- Verdict: **DIVERGENT**.

### 4.2 Group detail
- Web: `interview-group-detail.tsx` (inside roadmap swap).
- Flutter: `group_detail_screen.dart` — thumbnail rows w/ play overlay, duration, green check. Reasonable equivalent but AppBar style + separate route.
- Verdict: **CLOSE** (visual polish diffs only; not pixel-checked against web group-detail component).

### 4.3 Watch — `/interview/watch?v=&group=`
- Web: `interview-watch-page.tsx`. Mobile order: back → sticky player → title (+×count) → transcript (inline, collapsible, float) → pending/completed playlist card → comments. Notes在desktop column (mobile: stacked after — `YouTubeVideoNotes` renders since right column is w-full).
- Flutter: `video_player_screen.dart` — AppBar toggles for notes/transcript, player, title + complete button only.
- Diffs: same family as 2.2/3.2 — no inline transcript, no playlist card, no comments, no sticky player, no ×count.
- Verdict: **DIVERGENT**.

## 5. Course (DW)

### 5.1 Hub — web `/course` vs Flutter `/journey/courses`
- Web: `course-hub-page.tsx`. Mobile: StatsBar (back, "Course Hub", "N khoá · M+ bài học", level pill row) → search input → level-jump pill buttons → "Khoá học của tôi" grid → "Nổi bật" (star amber) grid → premium upsell banner (orange gradient CTA) → per-level sections "Level A1 …" each a 1-col grid of `CourseCard`s (16:9 poster, level pill + DW/Interview badge overlay, name, name_vi, "N bài", "Xem →"), "Xem thêm N khoá" expander after 8.
- Flutter: `courses_hub_screen.dart`.
- Diffs: no search, no stats bar, no level-jump pills, no premium upsell / lock badges (FREE_COURSE_LIMIT), featured/my-courses = horizontal 160px poster strips vs vertical grids, catalog = ListTile rows (56×42 thumb) vs big poster cards with level/DW pill overlays, level headers = solid orange chip vs "Level X · N khoá" text.
- Verdict: **DIVERGENT**.

### 5.2 Course detail — `/course/:slug`
- Web: `course-detail-page.tsx`. Mobile: back → course name (2xl) + name_vi + blue level pill → single bordered list of lessons: 80×48 poster thumb, "Bài 01" primary + name, name_vi, right pill = emerald "Hoàn thành" / amber "N%" / muted "Chưa học" / lock "Premium" → premium upsell → numbered pagination (page buttons) → "Trang x/y · Hiển thị a–b".
- Flutter: `course_detail_screen.dart` — Card+ListTile rows with check/play CircleAvatar, no posters, no score %/status pills, no lock/premium, no pagination, AppBar title.
- Verdict: **DIVERGENT**.

### 5.3 Lesson — `/course/:slug/lessons/:num`
- Web: `course-lesson-page.tsx` (784 lines). Mobile: back + lesson title + description → horizontal lesson-switcher strip ("Danh sách bài", min-w-110px chips "Bài 01") → sticky video (`<video>` self-hosted w/ resume, or YouTube iframe) → controls card (completion button appears after 80% watch, amber hint pill, floating-subtitle toggle, save state) → transcript card (collapsible "Phụ đề", DE/VI copy buttons, per-segment timestamps + VI) → notes → vocabulary card (paginated 3/page, audio play per word) → comments. Confetti 🎉 on completion, floating subtitle overlay.
- Flutter: `course_lesson_screen.dart` — poster placeholder with "video web-only" notice (no playback!), mark-complete toggle button, exercise-count hint text, flat vocab two-column rows (no audio), notes textarea + save.
- Diffs: no video playback at all, no lesson-switcher strip, no transcript, no vocab pagination/audio, no comments, no completion gating/confetti.
- Verdict: **DIVERGENT (major — core interaction missing)**.

## 6. Reading

### 6.1 Reading home — `/reading`
- Web: `reading-page.tsx` = `ReadingHubShell` tab bar (Tin tức | Truyện, active = primary underline) + header ("Đọc truyện" + subtitle) + `ReadingHome`: **2-col grid** of 6 level cards (A1–C2) with gradient headers (emerald/sky/violet/amber/rose/indigo), emoji, white progress ring (completed/total or check), 3 recommended unread articles with numbered mini-badges, "Xem tất cả →" themed button. `?level=` → `ReadingLevelDetail`: level hero w/ ring, search, topic accordion sections, `ReadingLeaderboard`.
- Flutter: `reading_hub_screen.dart` — AppBar "Luyện đọc" + sparkle icon → level ChoiceChips (all/A1..C1, note: web has C2) → flat list of article cards grouped by level badge.
- Diffs: entirely different IA — no tab shell, no level cards w/ rings/gradients/emoji, no recommendations, no topic grouping/accordion, no completion state, no leaderboard, missing C2.
- Verdict: **DIVERGENT (major)**.

### 6.2 Reading detail — `/reading/:level/:slug`
- Web: `reading-detail-page.tsx`. Mobile: back + "Đọc truyện" label → level pill (primary/10) + "Đã đọc" emerald check → title (tappable words) → sky-blue translate toggle button + hint "Chạm vào từ bất kỳ…" → native `<audio controls>` → paragraphs 17px leading-loose with per-paragraph VI (`ReadingTranslatableParagraph`) → glossary card → `SaveArticleWordsCta` → exercises quiz (completion gated ≥60%) OR manual mark-read gradient button → selection-lookup pill.
- Flutter: `reading_detail_screen.dart` (+`reading_detail_widgets.dart`) — AppBar w/ translate icon, ReadingHeader (title/topic/level/duration/word count — web has no such stat header), custom audio bar, tappable paragraphs + VI, glossary card, mark-read button.
- Diffs: **no exercises/quiz** (web gates completion on it), no save-words CTA, no selection lookup, translate toggle in AppBar vs inline sky button, extra stats header web lacks, no "Đã đọc" pill state inline.
- Verdict: **DIVERGENT**.

### 6.3 Reading feed — `/reading/feed`
- Web: `reading-feed-page.tsx`. Header "Đọc vừa sức" + subtitle, orange filter pills (Tất cả + A1–C1), article cards: 64px image, orange level chip + fit chip (emerald Vừa sức / amber Hơi thử thách / red Khó), title, title_vi, summary, "N từ mới · Đã biết x% từ khó"; empty state w/ "Học từ mới" CTA.
- Flutter: `reading_feed_screen.dart` — same structure & copy: ChoiceChips, fit chips w/ matching hexes (#059669/#B45309/#DC2626), stats line.
- Diffs: no article thumbnail image, level badge color = readingLevelColor vs web orange chip, ChoiceChip look vs solid-orange pills, AppBar vs header/subtitle text, empty state = ErrorView vs card w/ CTA link.
- Verdict: **CLOSE**.

### 6.4 Read & Listen hub — `/read-listen`
- Web: `read-listen-hub-page.tsx` — tab bar Đọc | Nghe | Tin tức mounting ReadingFeedPage / ListeningHubPage / NewsPage (`?tab=`).
- Flutter: **MISSING** (no route, no shell). Related: `ReadingHubShell` tabs on /reading & /news also unreplicated.
- Verdict: **MISSING**.

## 7. News

### 7.1 News list — `/news`
- Web: `news-page.tsx` = `ReadingHubShell` (Tin tức|Truyện tabs) + header "Tin tức Đức" + subtitle → filter bar: "Trình độ:" A1–B2 pills (active solid primary) + "Chủ đề:" orange pills (VI topic names) → story cards (topic orange chip, per-story level chips w/ active highlight, emerald "Đã hoàn thành" badge, title, title_vi sky italic, summary, date + "Có audio", 96px right image) → Trước/Sau pagination → mobile-stacked `NewsWeeklyRing` + `NewsLeaderboard` at bottom.
- Flutter: `news_list_screen.dart` (+`news_cards.dart`) — weekly ring card at TOP, filter bar, story cards (chips/title/titleVi/completed), pagination bar.
- Diffs: no tab shell, weekly ring placed above list (web: below/aside), **no NewsLeaderboard**, AppBar vs header+subtitle, chip styling approximations.
- Verdict: **CLOSE→DIVERGENT (borderline; missing leaderboard + tab shell, ring misplaced)** — recorded as DIVERGENT (minor).

### 7.2 News detail — `/news/:slug`
- Web: `news-detail-page.tsx`. Mobile: back + "Tin tức" label → "Chọn trình độ đọc" pills + tip box → topic + level chips → title + title_vi (sky italic) → lead image (aspect-video max-w-md) → date + attribution link → `NewsAudioPlayer` (normal/slow) → sentence reader (page-level VI toggle button right-aligned; VI = sky-blue left-border block) w/ tap-word lookup → `NewsQuiz` (pass ≥60% completes) → Goethe prompts card (orange left border, Sprechen/Schreiben) → vocab card (word — meaning, italic example) + `SaveArticleWordsCta` → selection lookup pill.
- Flutter: `news_detail_screen.dart` (+widgets, `news_quiz.dart`) — level switcher, badges, title/titleVi (0xFF0284C7 sky), image (fixed 180px vs aspect-video), source line, audio bar (slow supported), sentence reader w/ word tap, quiz w/ ≥60% completion, exam prompts card, vocab list.
- Diffs: no "Chọn trình độ đọc" label/tip box, no save-words CTA, no selection lookup, AppBar title "Tin tức Đức" vs back + label, VI toggle placement (inside NewsSentenceReader vs right-aligned button — not verified in widget file), image sizing.
- Verdict: **CLOSE**.

---

## Flutter screens in scope with NO web counterpart (delete/rebuild candidates)
- `lib/screens/listening/widgets/listening_coming_soon.dart` — placeholder pattern; disappears once real pages are built.
- Listening hub's stats strip (`_buildStats` in `listening_hub_screen.dart`) — web hub has no stats strip.
- YouTube tracker `_StatsRow` (Hôm nay/Tuần này/Tổng) — web tracker page doesn't show stats (they live in achievements/continue-watching context).
- Reading detail `ReadingHeader` (duration/word-count stat header in `reading_detail_widgets.dart`) — no web equivalent.
- Route-shape mismatches to fix during rebuild: Flutter `/listening/easy-german` (podcast) vs web `/listening/podcast/easy-german` + web `/listening/easy-german/:level` (missing); Flutter `/reading/detail` (extra-args) vs web `/reading/:level/:slug`; Flutter `/lessons/group/*` (interview) vs web `/course/interview` + `/interview/watch`; Flutter `/journey/courses*` vs web `/course/*`.

## Assets needed from web `public/`
Essentially none — all imagery on these pages is remote (YouTube `img.youtube.com/vi/{id}/mqdefault.jpg`, DW lesson/course posters from API, news `image_url` hotlinks, reading feed `image_url`). Icons are inline SVGs (need Flutter re-draws: YouTube play, mic, audiobook, B1 speech bubble, seek-10 icons, phosphor Check/CaretRight/CaretLeft/Lock/Star/GraduationCap/BookOpen). No `public/images` files referenced by the pages in scope.

## Priority order for parity work (by visual distance × traffic)
1. Easy German level pages + shared VideoCollection* widget set (unlocks sprechen B1/B2 + youtube tracker facelift for free).
2. YouTube watch (inline transcript, practice buttons, cinema optional) + dictation page (real feature, web core loop).
3. Reading home (level cards + tab shell) & course hub/detail/lesson (lesson video playback is a functional hole).
4. Podcast pages re-theme to purple + layout order fix.
5. Leaderboard/weekly-ring components (news, podcast, easy-german, interview, reading) — one shared Flutter widget.

## Unresolved questions
1. Dictation/shadowing/cinema were explicitly deferred by earlier waves ("Phase 8", mic permission) — does 100%-identical scope now include these interactive modes, or only static layout parity?
2. Web gates interview behind `PurchaseGate` page-level and locks courses/lessons after FREE limits — should Flutter replicate the same lock UI (IAP policy on Android may constrain premium upsell links)?
3. Route alignment (e.g. `/listening/podcast/easy-german`, `/reading/:level/:slug`, `/course/*`) — align now or keep Flutter routes and only match visuals?
4. `youtube_player_iframe` cannot reproduce web's custom complete-button-under-player `YouTubeEmbeddedPlayer` chrome exactly; acceptable deviation?
