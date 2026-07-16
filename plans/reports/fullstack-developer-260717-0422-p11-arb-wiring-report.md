# P11 ARB Cleanup Pass — Listening/Podcast/YouTube/Reading/News

Closes the ARB gap flagged by P11 W1 report (deviation #1: "~40 UI-chrome VN
strings kept inline, not migrated"). Followed the P8/P10 cleanup-pass
approach: grep scope for hardcoded VI, dedupe against existing ARB keys, add
new keys vi/en/de, `flutter gen-l10n`, replace call sites, verify German
200%. Split work: listening + reading + news done directly; youtube delegated
to a sequential sub-agent (same conventions) to keep ARB writes serialized.

## Scope executed

1. `lib/screens/listening/**` (hub, easy-german level page, podcast index +
   player, sprechen b1/b2, all `widgets/`) — the W1-flagged gap.
2. `lib/screens/youtube/**` (tracker/watch/dictation/shadowing + widgets) —
   sub-agent pass, same conventions, report:
   `fullstack-developer-260717-0500-p11-arb-wiring-youtube-report.md`.
3. `lib/screens/reading/**` + `lib/screens/news/**` (hub/detail/feed/
   read-listen-hub, list/detail, all `widgets/`).
4. `lib/screens/journey/course*` + `course_*` widgets — **verified clean**,
   no work needed (W3 already ARB-wired everything; grep found only
   Vietnamese in doc-comments, zero literal `Text('...')`).

## LOC extraction (W1 report's flagged item)

`easy_german_podcast_page.dart` 228→157 LOC (extracted `widgets/
podcast_page_chrome.dart`: header/search-filter-bar/pagination-row).
`easy_german_podcast_player_page.dart` 276→197 LOC (extracted `widgets/
podcast_player_chrome.dart`: header/error-view/transcript-list, and
`widgets/podcast_transcript_sync.dart`: pure sentence/word-sync functions).
Mechanical only — no behavior change, all pre-existing tests pass unchanged.

## ARB keys

**Listening scope (mine)**: 61 new keys (`listeningPageTitle`, `listeningIntro*`,
`listeningSource*Desc`, `easyGerman*`, `podcast*`, `videoCollection*`) + 8
reused (`myWords`, `retry`, `practiceModeComingSoon`, `statsMasteryLearning`,
`coursesProgressTitle`, `grammarLeaderboardEmpty`, `allFilters`,
`examSetPagePrev`/`examSetPageNext`). Plus 1 straggler
(`listeningSprechenHeaderSubtitle`) found on a second grep pass in
sprechen_b1/b2_page.dart.

**Youtube scope (sub-agent)**: 43 new keys (`youtube*`, `youtubeDictation*`,
`shadowing*` — deliberately not bare `dictation*`, which the repo already
uses for an unrelated listening feature) + 10 reused.

**Reading/news scope (mine)**: 55 new keys (`readingHub*`, `readingFeed*`,
`readingLeaderboard*`, `readingYourRank*`, `newsHeader*`, `newsFilter*`,
`newsPagination*`, `newsLeaderboard*`, `newsQuiz*`, `saveWordsCta*`, plus
small stragglers `newsStoryNotFound`, `yesterday`,
`readingListenFullStory`/`readingAudioSpeedTooltip` found on a second grep
pass) + 9 reused (`leaderboardTitle`, `allFilters`, `examSetPagePrev`,
`retry`, `saving`, `grammarLeaderboardEmpty`, `writingClearFilters`, `save`,
`coursesLessonCompleted`, `focusSessionLearnNewWordsCta`, `examHideTranslation`,
`today`).

**Total**: 61 + 43 + 55 = 159 new keys × 3 languages = 477 new entries.
Key count: 1660 (session start) → 2081, verified 3-way `vi`/`en`/`de` set
parity via Python set-diff before and after every append (no drift from the
concurrent youtube sub-agent — each pass appended, re-read the file from disk
immediately before its own final write, never overwrote wholesale).
`flutter gen-l10n` run after every append batch; only ever hand-touched the
`.arb` sources, never `app_localizations*.dart`.

## Key-naming / dedup decisions

- Flat camelCase, feature-prefixed (`listening*`, `easyGerman*`, `podcast*`,
  `videoCollection*`, `reading*`, `news*`) — matches the existing
  `sprechen*`/`courses*` convention.
- `VideoStatusFilterOption.label`/`DurationBucketX.label` (enum extension
  getters) converted from const-string switch to methods taking
  `AppLocalizations l10n` — can't reach `BuildContext` from a getter.
- `VideoLeaderboardCard.emptyHint` / `VideoProgressCard.completionLabel` /
  `VideoProgressCard.message`'s default (`_defaultMessage`) converted from
  hardcoded-Vietnamese Dart default-parameter values to nullable fields
  resolved inside `build()` — same pattern P10 used for
  `SprechenPartnerChat.partnerSubtitle`.
- Reused rich-text prefix/suffix split (`readingYourRankPrefix`/`Suffix`) for
  the "Hạng của bạn: #N · M bài" pattern, shared verbatim across
  `reading_leaderboard.dart` and `news_leaderboard.dart` — the bold `#N` rank
  number itself stays a raw Dart string interpolation (not translatable
  content, matches P8's precedent).
- `_ReadingHubTabBar`/`_NewsHubTabBar` (near-duplicate private widgets in
  `reading_hub_screen.dart`/`news_list_screen.dart`) share the same 2 new
  keys (`newsTabLabel`/`readingTabLabel`) rather than duplicating.

## Long-form / brand exceptions (left inline, NOT converted)

- **Lookup-map content** (matches P8's explicit precedent for
  skill/provider-name maps): `lib/screens/reading/widgets/
  reading_level_theme.dart` (`kReadingLevelTheme` — 6 levels × emoji/label/
  desc), `lib/screens/news/widgets/news_cards.dart`'s `newsTopicViMap` (8
  topic codes), `lib/screens/reading/reading_feed_screen.dart`'s
  `_fitLabels`/`_fitColors` (3 fit-tier labels), `lib/screens/youtube/
  widgets/group_progress_tile.dart`'s `motivationForProgress()` (5
  motivational strings — flagged by the youtube sub-agent as shared with
  out-of-scope `video_library`/`interview` callers).
- **German/brand terminology hardcoded as-is** (verified against actual TSX
  where checked): `"Easy German"` / `"Easy German Podcast"` (brand names,
  identical across locales on web), `"YouTube"` (proper noun), `"SPRECHEN"`/
  `"SCHREIBEN"`/`"🎯 Goethe-Übung"` in `news_detail_widgets.dart`'s
  `NewsExamPromptsCard` (matches the P10-established precedent of German
  exam-category labels staying untranslated).
- **Sprechen B1/B2 video-collection DATA** (145+79 hardcoded titles) — content
  ported verbatim from web, not UI chrome; already flagged by W1, untouched
  here.

No long-form marketing/trainer-tip copy exists in this scope (unlike P8's
exam-core sweep) — every converted string was short UI chrome (labels,
hints, errors, empty-states, CTAs, pagination, leaderboard rows).

## German 200%-textscale — bugs found and fixed

New smoke tests (mirroring `course_german_200_percent_test.dart`):
`test/screens/listening/listening_german_200_percent_test.dart` (6 screens),
`test/screens/youtube/youtube_german_200_percent_test.dart` (4 screens, by
sub-agent), `test/screens/reading/reading_news_german_200_percent_test.dart`
(6 screens). All required real overflow fixes before passing — genuine bugs,
not flaky tests:

- **Listening**: `VideoCollectionBreadcrumb`'s label `Text` had no
  `Flexible`/ellipsis — fixed once in the shared `video_collection_layout_
  chrome.dart`, which resolved the same failure on 3 screens (easy-german
  level page, sprechen B1, sprechen B2) simultaneously.
- **Youtube** (sub-agent): `dictation_panel.dart`'s and
  `youtube_shadowing_screen.dart`'s control-button rows needed
  `FittedBox(fit: scaleDown)`; a **pre-existing** overflow in
  `lib/widgets/interview/transcript_panel.dart`'s header row (outside this
  task's file ownership, but embedded by the owned `youtube_watch_screen.dart`
  and blocking its own test) was also fixed with a minimal `Flexible`+
  ellipsis wrap — flagged for that file's actual owner.
- **Reading/news** (mine): `_ReadingHubTabBar`/`_NewsHubTabBar`/
  `read_listen_hub_screen.dart`'s 2–3-tab `Row`s (no `Flexible`),
  `_LevelCard`'s 44×44 progress-ring digits (`FittedBox` needed, same as the
  course pass's precedent), `_LevelCard`'s recommended-article list
  (unbounded height at scale — outer `Column`/`Expanded` restructured to a
  `SingleChildScrollView` so the card degrades to scrolling instead of
  asserting), `_FeedEmptyState` (wrapped `Padding`→`SingleChildScrollView`),
  `_PaginationBar`'s prev/page-info/next `Row` (wrapped each cell in
  `Flexible`+ellipsis), and `reading_detail_screen.dart`'s breadcrumb-style
  header `Row` (`Flexible`+ellipsis on the label).

None of these fixes change layout/color/behavior at normal (100%) text
scale — verified by re-running every pre-existing (non-200%) test in the
scope, all pass unchanged.

## Counts

- **Converted to ARB**: ~185 call sites across 3 sub-scopes (listening ~55,
  youtube 51, reading/news ~79) using 159 new keys + 27 reused keys.
- **Left inline**: lookup-map content (5 files, ~30 entries) and
  German/brand terminology (~5 strings) — both approved exceptions,
  itemized above.
- Sprechen B1/B2's 145+79 hardcoded video titles: unchanged (content, not
  chrome; W1's original classification stands).

## Files touched

**Listening** (mine): `lib/screens/listening/{listening_hub_screen,
easy_german_level_page,easy_german_podcast_page,easy_german_podcast_player_page,
sprechen_b1_page,sprechen_b2_page}.dart`, all 14 files in
`lib/screens/listening/widgets/` (3 new: `podcast_page_chrome.dart`,
`podcast_player_chrome.dart`, `podcast_transcript_sync.dart`), 5 existing
tests updated (`AppLocalizations` delegates added to `MaterialApp` wraps), 1
new test (`listening_german_200_percent_test.dart`),
`test/structure/release_live_data_guard_test.dart` (+3 new widget paths).

**Youtube** (sub-agent, see its own report for the full file list):
4 screens + 6 widgets, 2 existing tests updated, 2 new test files
(`youtube_german_200_percent_test.dart`, `fake_webview_platform.dart`), 1
out-of-scope fix (`lib/widgets/interview/transcript_panel.dart`).

**Reading/news** (mine): `lib/screens/reading/{reading_hub_screen,
reading_detail_screen,reading_feed_screen,read_listen_hub_screen}.dart`,
`lib/screens/reading/widgets/{reading_leaderboard,reading_detail_widgets,
save_article_words_cta}.dart`, `lib/screens/news/{news_list_screen,
news_detail_screen}.dart`, `lib/screens/news/widgets/{news_cards,
news_detail_widgets,news_leaderboard,news_quiz}.dart`, 2 existing tests
updated, 1 new test (`reading_news_german_200_percent_test.dart`).

**Shared** (append-only, all 3 sub-scopes): `lib/l10n/app_{vi,en,de}.arb` +
regenerated `lib/l10n/app_localizations*.dart`.

## Validation

- `flutter analyze` on the full combined scope (`lib/screens/{listening,
  youtube,reading,news,journey}`, `lib/l10n`, `lib/widgets/interview`, and
  all matching `test/` dirs): **0 issues**.
- `flutter analyze` (full repo): 34 pre-existing info/warning-level lints, all
  in files never touched by this pass (writing/decks/speech/social/exam
  test-only issues) — confirmed via path.
- `flutter test` on the full combined scope: **146/146 pass** (listening +
  youtube + reading + news + journey/course + l10n + structure).
- 3-way ARB key-set parity (`vi`==`en`==`de`, 2081 keys each) verified via
  Python set-diff as the final step, after both sub-scopes' writes landed.
- `flutter gen-l10n` clean throughout, generated Dart never hand-edited.

## Unresolved questions

1. `lib/widgets/interview/transcript_panel.dart` still has its own hardcoded
   Vietnamese strings beyond the one overflow bug the youtube sub-agent
   fixed (`'Không có transcript'`, `'Thử lại'` in its `_ErrorView`/
   `_EmptyTranscriptView`) — out of this task's file ownership (shared with
   interview/video_library), flagged for whoever eventually ARB-localizes
   those screens.
2. `lib/screens/youtube/widgets/group_progress_tile.dart`'s
   `motivationForProgress()` (5 VN strings) is shared with out-of-scope
   `video_library_tracker_screen.dart`/`interview_roadmap_screen.dart` —
   needs a coordinated 3-file edit when someone owns that cross-cutting
   ARB pass.
3. Lookup-map content (`reading_level_theme.dart`, `newsTopicViMap`,
   `_fitLabels`) intentionally left inline per the P8 precedent for
   "pre-existing app-wide skill/provider-name lookup patterns" — still an
   open question (same one P8 raised) whether these should get a dedicated
   ARB-ization pass someday.

Status: DONE
Summary: All 4 sub-scopes (listening/podcast W1 gap, youtube, reading/news,
course-verify) ARB-wired — 159 new keys + 27 reused across vi/en/de, 3-way
parity confirmed at 2081 keys/language; 2 podcast files brought under the
200-LOC guideline via mechanical widget extraction; German-200%-textscale
regression tests added for all 3 sub-scopes and found/fixed 6 distinct real
overflow bugs (5 in-scope, 1 pre-existing in an out-of-scope shared widget);
`flutter analyze`/`flutter test` clean across the full combined scope
(146/146).
Concerns/Blockers: none blocking; 3 cross-scope follow-ups flagged above
(transcript_panel.dart, group_progress_tile.dart, lookup-map ARB-ization)
for whoever owns those adjacent areas next.
