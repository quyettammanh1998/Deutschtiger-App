# P11 Wave 2 — YouTube / Video-library / Interview (8 screens)

Scope: `plans/260716-2324-web-mobile-ui-100-fidelity/phase-11-media-reading-news.md` §W2 only.
Web source read per-page before coding (`thamkhao/deutschtiger-frontend/src/{pages,components}/{youtube,listening,video-library,interview}/*`).

## Status per screen

| Screen | Verdict before | Work done | Verdict now |
|---|---|---|---|
| `youtube_tracker_screen.dart` | DIVERGENT | Breadcrumb + header card (icon-in-square, red YouTube accent), "Xem tiếp" strip (continue-watching proxy — see note), popular strip kept, add-form kept, status filter pill bar w/ counts, 2-col thumbnail grid (`VideoCollectionCard`: green ring/badge on completed, amber "Đang học" badge), pagination 20/page. Removed `_StatsRow` (web has none here) and Material `ChoiceChip`s. | CLOSE |
| `youtube_watch_screen.dart` | DIVERGENT (major) | Reordered to web block order: back → player → complete button (under player) → title/×watch-count → practice buttons row (Nghe chép chính tả / Shadowing) → transcript inline (collapsible, default open) → notes (collapsible). | CLOSE (see deviations) |
| `youtube_dictation_screen.dart` | MISSING (stub) | Full rebuild: header (back, title, hide-video toggle), player, `DictationPanel` (sentence + cloze modes, `AnswerDiffView`, `UmlautInputBar`, settings sheet, prev/replay/skip/next, completion dialog), `+1 XP` per correct sentence via new `POST /user/gamification/award-xp` call. | CLOSE (subset — see deviations) |
| `youtube_shadowing_screen.dart` | MISSING (stub) | Full rebuild: header, player (hide toggle), active-sentence card (prev/next/replay), full transcript list w/ tap-to-seek. Mic button present but disabled/tooltipped — gated behind `ReleaseFeatureFlags.speaking` (default off), no STT/AI-eval wiring (MASTER P8). | CLOSE (UI-only, by design) |
| `video_library_tracker_screen.dart` | DIVERGENT | Swapped `_GroupTile` → shared `GroupProgressTile` (zero-padded index, blue level pill, amber "started"/green "complete" circle), added motivation line under the progress bar. | CLOSE |
| `video_library_watch_screen.dart` | DIVERGENT | Player pinned at column top (sticky-equivalent), transcript inline (collapsible, default open) replacing the AppBar toggle, playlist now split "Chưa xem/Đã hoàn thành" with thumbnails + colored borders (primary=active, green=completed), ×watch-count shown. | CLOSE |
| `interview_roadmap_screen.dart` | file did not exist (route unreachable — catalog comment claiming it existed was stale) | Built from scratch: page-level `PremiumGateCard` when `ReleaseFeatureFlags.premium` is off (default), else progress bar + motivation + `GroupProgressTile` list, in-place group→video-list swap (same pattern as video-library tracker). Routed at `/course/interview`. | CLOSE (no leaderboard — see deviations) |
| `video_player_screen.dart` (interview watch) | file did not exist | Built from scratch: player, title/×watch-count, complete/rewatch button, transcript inline, "Chưa xem/Đã hoàn thành" playlist w/ thumbnails (same pattern as video-library watch). Routed at `/interview/watch?v=&group=`. | CLOSE (no comments — see deviations) |

## Files

**New**: `lib/screens/youtube/widgets/{media_header_card,video_status_filter_bar,video_pagination_bar,video_collection_card,youtube_tracker_widgets,group_progress_tile,dictation_panel,dictation_settings_sheet}.dart`, `lib/repositories/youtube/dictation_xp_repository.dart`, `lib/screens/interview/{interview_roadmap_screen,video_player_screen}.dart`, tests `test/screens/youtube/dictation_panel_test.dart`, `test/screens/interview/interview_roadmap_screen_test.dart`.

**Rewritten**: `lib/screens/youtube/{youtube_tracker_screen,youtube_watch_screen,youtube_dictation_screen,youtube_shadowing_screen}.dart`, `lib/screens/video_library/{video_library_tracker_screen,video_library_watch_screen}.dart`.

**Deleted**: `lib/screens/youtube/widgets/youtube_video_card.dart` (superseded by `video_collection_card.dart`, left with zero references).

**Appended**: `lib/navigation/routes/media_routes.dart` (dictation/shadowing routes now pass `videoId`/`title`; added `/course/interview` + `/interview/watch`), `lib/view_models/youtube/youtube_provider.dart` (+`dictationXpRepositoryProvider`), `docs/flutter-api-contract-matrix.md` (+§Generic XP award), `docs/api-changelog.md` (+row), `test/structure/release_live_data_guard_test.dart` (added my new files; removed a stale `listening_coming_soon.dart` entry left by W1's in-progress deletion — see Coordination).

**Not touched**: any listening/podcast/sprechen (W1), course (W3), reading/news (W4) files, `lib/core/**`, `lib/widgets/common/**`, `lib/shared/widgets/**`, `pubspec.yaml`.

## Reuse (confirmed before writing new widgets)

`context.tokens` (`AppTokens`) throughout new/rewritten screens (video_library/youtube_watch still on `AppColors` statics in untouched lines — not converted, out of scope for a targeted fidelity pass but flagged). `TranscriptPanel`/`VideoNotesPanel` (`lib/widgets/interview/`), `UmlautInputBar` + `AnswerDiffView` (dictation input/diff), `PremiumGateCard` (interview PurchaseGate). No new markdown/lookup/save-word primitives — none needed for this wave's screens.

## Deviations (documented per plan requirement)

1. **Player chrome** (pre-approved): `youtube_player_iframe` cannot reproduce web's custom `YouTubeEmbeddedPlayer` chrome — native player controls used, "Đã hoàn thành" button placed below the player as web does.
2. **Cinema mode / floating bilingual subtitle** (youtube watch) and **`YouTubeVideoNotes` right column**: dropped. No safe way to build a floating-subtitle overlay atop `youtube_player_iframe` without violating the "no cover/cache the video" YouTube ToS note reused from GĐ2 P1; notes stayed a collapsible toggle (unchanged from before).
3. **Dictation modes**: sentence + cloze (blank-word) implemented; the third **word-by-word typed mode** and **mic dictation** are not — web's word mode needs the same per-word reveal/retry state machine mic mode reuses, judged lower priority than shipping a working sentence/cloze loop in this pass. Auto-replay/auto-pause-at-sentence-end timing knobs also deferred (manual "Nghe lại"/skip/next control the flow instead).
4. **Shadowing record path**: UI-complete, mic fully disabled regardless of the `speaking` flag value — web's shadowing pipeline needs `useAudioRecorder` + `useSpeechEvaluation` (Soniox STT + AI pronunciation grading + premium play-wall), none of which exist in Flutter yet. This is explicitly MASTER P8 wiring per the plan; UI is ready for it.
5. **Video comments** (video-library watch, interview watch): deferred entirely. No generic video-comment widget exists in Flutter (moments/exam comment widgets are different domains) and no contract was probed — building either is bigger than this wave; flagged for whoever owns the cross-cutting comment widget next.
6. **Leaderboards** (youtube tracker's continue-watching context aside, video-library/interview roadmap "stacked below list"): deferred. Plan §5 itself frames this as "one shared Flutter widget" spanning news/podcast/easy-german/interview — not exclusively W2's scope, and no such widget exists to reuse yet.
7. **"Xem tiếp" (continue watching)** on the tracker uses completed videos sorted by `watchedAt` desc as a proxy for web's `YouTubeContinueWatching` (which reads in-progress dictation/shadowing sessions) — Flutter has no per-session progress record for that; this is the closest live-data equivalent, not a mock.
8. **l10n**: like the untouched sibling screens in this same family (listening/video-library before my edits), all new/rewritten UI strings stayed hardcoded Vietnamese rather than routed through ARB — matches the existing pattern in this exact directory tree (none of `youtube_tracker_screen.dart`, `video_library_*` used `AppLocalizations` before either). Flagged as a pre-existing gap across the whole media area, not something newly introduced here; converting it is a bigger, cross-file undertaking better done in one pass for the whole family.

## Contract work

New endpoint use (not a new backend contract — endpoint already exists, first Flutter caller): `POST /user/gamification/award-xp {amount:1}` for dictation XP, read from `gamification_handler.go` (no live-token probe available in this sandbox). Documented in `docs/flutter-api-contract-matrix.md` §Generic XP award and `docs/api-changelog.md`.

## Coordination note

`test/structure/release_live_data_guard_test.dart` had a stale entry (`lib/screens/listening/widgets/listening_coming_soon.dart`) pointing at a file W1 already deleted (uncommitted, in-progress) without updating the guard list yet — this was breaking the shared test file for everyone. Removed that one entry (commented, attributed to W1) so the suite runs; W1 should still add its own new screen/widget paths when it lands. Separately: W1 is building its own `VideoCollectionLayout`/`VideoCollectionCard`/`VideoStatusFilterBar`/`VideoPagination` family under `lib/screens/listening/widgets/` for Easy German — conceptually the same shared component set I built under `lib/screens/youtube/widgets/` for this wave (`media_header_card`, `video_collection_card`, `video_status_filter_bar`, `video_pagination_bar`). Built independently under wave-isolation rules (couldn't safely import from a concurrently-mutating dir); flagging for P12 wave-B merge/QA to reconcile into one shared set rather than two parallel ones.

`lib/shared/widgets/more_features/more_features_catalog.dart` still has the interview tile `enabled: false` with a stale comment ("InterviewRoadmapScreen exists but isn't routed anywhere yet" — it didn't exist at all until this change). That file is in the DO-NOT-TOUCH list (`lib/shared/widgets/**`); routes now work (`/course/interview`), but someone owning that file needs to flip `enabled` and fix the comment.

## Validation

- `flutter analyze` on all touched files: 0 issues. Full-repo `flutter analyze` run for cross-check: 189 pre-existing errors, none in my files (confirmed by grep — all in concurrent agents' in-progress work, e.g. `pronunciation/ich_ach_trainer_page.dart` missing ARB getters).
- `flutter test` green: `test/structure/release_live_data_guard_test.dart`, `test/repositories/youtube_contract_test.dart`, `test/screens/video_library/*`, `test/screens/youtube/*` (incl. new `dictation_panel_test.dart`), `test/screens/interview/interview_roadmap_screen_test.dart`.

## Unresolved questions

1. Should the shared `VideoCollection*` widget family (mine vs W1's) be unified now or left for P12 wave-B cleanup as I assumed?
2. Video comments and per-collection leaderboards — who owns building the shared widget + probing the contract (news/podcast/easy-german/interview/video-library all need it)?
3. `more_features_catalog.dart` interview tile — needs its owner to flip `enabled: true` now that routes exist.

Status: DONE_WITH_CONCERNS
Summary: All 8 W2 screens rebuilt/shipped with real live data (no new mocks), dictation/shadowing went from stub to functional UI with record-path correctly flag-gated; two structural gaps (comments, leaderboards) and one likely duplicate-widget situation with W1 are documented rather than silently skipped.
Concerns/Blockers: see Unresolved questions above; none block merging this wave's own screens.
