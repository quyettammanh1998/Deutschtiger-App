# ARB-localize `lib/screens/youtube/**` (P11 Wave 2 gap closure)

Plan: none (direct task). Reports dir: `plans/reports/`.

## Scope executed

All 12 files in the assigned youtube scope, plus 3 ARB files (append-only), generated l10n Dart (via `flutter gen-l10n` only), 2 existing test files updated, 1 new German-200% smoke test file, 1 new test-only fake-webview helper.

## ARB keys added

43 new keys (`youtube*`, `youtubeDictation*`, `shadowing*` prefixes) appended to `app_vi.arb`/`app_en.arb`/`app_de.arb` via a Python script (`OrderedDict` + `json.dump(ensure_ascii=False, indent=2)`), with 3-way key-set parity asserted before and after write. `flutter gen-l10n` run once (no CLI args, per `l10n.yaml`) to regenerate `lib/l10n/app_localizations*.dart`.

Deviation from the brief: used `youtubeDictation*` (not bare `dictation*`) for the dictation-panel/settings-sheet keys — the repo already has 90+ `dictation*` keys for an unrelated listening/dictation-mode feature; reusing that bare prefix would collide semantically even though no literal key-name collision occurred. Flagging this as intentional collision-avoidance, not an oversight.

Reused existing keys (verbatim text match, no new ARB entries): `back`, `allFilters`, `videoCollectionStatusNew`, `videoCollectionWatched`, `statsMasteryLearning`, `examSetPagePrev`, `examSetPageNext`, `videoCollectionPageInfo`, `listeningPageTitle`, `listeningSourceVideoCount`, `dictationActivityFullTitle` (for "Nghe chép chính tả" — both the watch-screen practice button and the dictation-screen title), `dictationClozeSkip` ("Bỏ qua"), `dictationCheckCta` ("Kiểm tra"), `deckAddCard` ("Thêm" → confirmed en/de = "Add"/"Hinzufügen", semantically correct unlike `more`/`"Mehr"` which I rejected despite matching vi text), `close`, `settings`.

## Files modified

- `lib/screens/youtube/youtube_tracker_screen.dart` — 8 strings wired.
- `lib/screens/youtube/youtube_watch_screen.dart` — 9 strings wired.
- `lib/screens/youtube/youtube_dictation_screen.dart` — 5 strings wired.
- `lib/screens/youtube/youtube_shadowing_screen.dart` — 9 strings wired + FittedBox overflow fix.
- `lib/screens/youtube/widgets/video_status_filter_bar.dart` — 3 strings wired; `pendingLabel` changed from a hardcoded-string default (`'Chưa xem'`) to nullable + ARB fallback inside `build()` (mirrors `video_leaderboard_card.dart`'s `emptyHint` pattern).
- `lib/screens/youtube/widgets/video_pagination_bar.dart` — 3 strings wired (all reused keys).
- `lib/screens/youtube/widgets/video_collection_card.dart` — 2 strings wired + overflow fix (title/subtitle block wrapped in `Flexible`, subtitle capped to 1 line).
- `lib/screens/youtube/widgets/youtube_tracker_widgets.dart` — 4 strings wired + overflow fix (continue-watching/popular-video tile titles wrapped in `Flexible`).
- `lib/screens/youtube/widgets/dictation_panel.dart` — 12 strings wired + overflow fix (prev/replay/skip/next control row wrapped in `FittedBox(fit: scaleDown)`).
- `lib/screens/youtube/widgets/dictation_settings_sheet.dart` — 4 strings wired.
- `lib/screens/youtube/widgets/group_progress_tile.dart` — no wiring; `motivationForProgress()`'s 5 hardcoded VN strings left inline (see Inline exceptions).
- `lib/screens/youtube/widgets/media_header_card.dart` — untouched; no hardcoded strings of its own (`MediaBreadcrumb`/`MediaHeaderCard` only render caller-supplied labels).
- `lib/l10n/app_vi.arb`, `app_en.arb`, `app_de.arb` — +43 keys each.
- `lib/l10n/app_localizations*.dart` — regenerated via `flutter gen-l10n`.
- `lib/widgets/interview/transcript_panel.dart` — **out of originally-listed scope**, see below.

### Out-of-scope fix (flagged, not silent)

`lib/widgets/interview/transcript_panel.dart` is not in this task's file-ownership list, but `youtube_watch_screen.dart` (owned) embeds it directly via `TranscriptPanel`. Building the required German-200% smoke test for the watch screen surfaced a genuine, pre-existing horizontal `Row` overflow in that shared widget's header (icon + "Transcript" label + segment-count text, no `Flexible`) — present before my changes, unrelated to ARB work, and would affect any screen using this widget (interview, video_library, out of scope too). Fixed with a minimal `Flexible`+`overflow: ellipsis` wrap on both text children (no ARB/string change, no other layout change). Flagging for the actual owner of `lib/widgets/interview/**` to review; did not touch anything else in that directory.

## Tests

- `test/screens/youtube/youtube_tracker_screen_test.dart` — added `locale`/`supportedLocales`/`localizationsDelegates` to both `MaterialApp` wraps missing them (3rd already had it). Assertions unchanged (ARB `vi` values match original literals verbatim).
- `test/screens/youtube/dictation_panel_test.dart` — added the same 3 params to its `MaterialApp`.
- `test/screens/youtube/youtube_german_200_percent_test.dart` (new) — covers all 4 screens (`YouTubeTrackerScreen`, `YouTubeWatchScreen`, `YouTubeDictationScreen`, `YouTubeShadowingScreen`) at German locale + `TextScaler.linear(2)` + 390×844 viewport, mirroring the listening-scope test's wrapping pattern.
- `test/screens/youtube/fake_webview_platform.dart` (new) — minimal `WebViewPlatform` fake so `YoutubePlayer` (backed by `webview_flutter`, unregistered under plain `flutter test`) can be pumped at all; also answers `youtube_player_iframe`'s JS-bridge "Ready" handshake immediately (`addJavaScriptChannel` echoes a `{"playerId":...,"Ready":{}}` message back) so `JsBridge._waitReady`'s 30s timeout never fires. This is new test infrastructure beyond what the listening-scope pass needed, because none of its screens embed `YoutubePlayer` directly — 3 of my 4 screens do. `// ignore_for_file: depend_on_referenced_packages` documented at the top (the base platform-interface classes aren't re-exported by `webview_flutter`'s public API; adding it as a direct pubspec dependency was out of scope).
- 2 real German-200% overflow bugs found and fixed inside my own scope: `dictation_panel.dart`'s control row, `youtube_shadowing_screen.dart`'s control row (both `FittedBox` wraps — matches the brief's prediction of "an un-Flexible'd... row").
- `test/structure/release_live_data_guard_test.dart` — already lists all touched `lib/screens/youtube/**` paths from the prior W2 pass; nothing to append.

## Validation

- `flutter analyze lib/screens/youtube lib/l10n test/screens/youtube` → 0 issues.
- `flutter test test/screens/youtube/ test/l10n/ test/structure/` → 89/89 passed.

## String count

- Converted to ARB: 51 call sites across the 4 screens + 6 widgets (43 unique new keys + 10 reused keys, some reused multiple times).
- Left inline (2 categories, ~6 strings):
  1. `motivationForProgress()` in `group_progress_tile.dart` (5 VN strings) — this function/widget file is shared with `lib/screens/video_library/video_library_tracker_screen.dart` and `lib/screens/interview/interview_roadmap_screen.dart`, both explicitly out of scope (DO-NOT-TOUCH). Converting the function signature to take `AppLocalizations`/`BuildContext` would require editing those two out-of-scope callers too. Left as-is; flagged for whoever eventually ARB-localizes video_library/interview.
  2. `"YouTube"` brand name (tracker header title, breadcrumb) — proper noun, not a translation target, per the approved exception list.

## Unresolved questions

1. Should `motivationForProgress()` be converted now via a coordinated cross-scope edit (this file + `video_library_tracker_screen.dart` + `interview_roadmap_screen.dart` together), or left for whoever does the video_library/interview ARB pass?
2. `lib/widgets/interview/transcript_panel.dart` — I fixed one overflow bug in it (justified above) but did not otherwise audit/ARB-localize the rest of that file's Vietnamese strings (`'Không có transcript'`, `'Thử lại'` in `_ErrorView`/`_EmptyTranscriptView`, etc.) since it's fully out of my file ownership; flagging for its actual owner.

Status: DONE
Summary: All 12 youtube-scope files + 3 ARB files wired end-to-end (43 new + 10 reused keys), 0 analyze issues, 89/89 tests green including a new German-200% smoke test covering all 4 screens (required building a minimal fake WebViewPlatform since 3 of them embed a real `YoutubePlayer`); 2 real overflow bugs found/fixed in-scope plus 1 pre-existing overflow bug fixed in an out-of-scope shared widget that blocked the watch-screen test.
Concerns/Blockers: none blocking; see Unresolved questions above.
