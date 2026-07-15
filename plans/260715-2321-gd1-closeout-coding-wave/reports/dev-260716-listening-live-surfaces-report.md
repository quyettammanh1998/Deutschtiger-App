# Listening/Podcast live surfaces — implementation report

Date: 2026-07-16

## Scope resolution (spec discovery)

Probed backend (`internal/feature/learning/listening`, `content/podcastprogress`,
`content/video/podcast_audio_handler.go`) + web (`src/pages/listening/*`,
`src/lib/listening/*`) before coding, per "KHÔNG đoán schema":

- **Easy German Podcast** is the only listening surface with a real contract:
  index/episode content is static JSON (`data/listening/podcast/easy_german/{index,slug}.json`,
  same static-asset pattern as `GrammarRepository`/`ReadingRepository`), audio
  streams via public `GET /api/v1/listening/podcast/easy_german/audio/{slug}`
  (302 redirect to cached/origin mp3, no auth needed), progress via
  `GET/POST /user/podcast-progress`, leaderboard via `GET /podcast-leaderboard`
  + `GET /user/podcast-rank`.
- **Sprechen B1/B2**: web (`sprechen-b1-page.tsx`) shows these are **YouTube
  video collections** (via `youtubeService`/`youtube-tracker`), NOT audio. This
  contradicts the task's framing ("Sprechen B1/B2 audio pages") — real source
  of truth wins. YouTube integration is explicitly out of scope this wave, so
  both screens now render a shared `ListeningComingSoon` gate instead of fake
  episode/video lists.
- **Audiobook + Dictation tabs** (Listening Hub): no backend endpoint and no
  web equivalent exists at all (web listening dir only has Easy German +
  Sprechen B1/B2). These were 100% mock-only Flutter inventions — removed
  entirely (hub, provider, repository methods, widgets, router route,
  `Dictation`/`Audiobook` models) rather than gated, since there is nothing to
  gate toward and keeping them would violate "no fake data".

## Files changed

- `lib/data/listening/podcast_models.dart` (+ generated `.freezed.dart`/`.g.dart`) — rewritten: `PodcastEpisode`, `PodcastWord`, `PodcastSentence`, `PodcastEpisodeDetail`, `PodcastLeaderboardEntry`. Removed `PodcastSeries`, `Audiobook`, `AudiobookChapter`, `Dictation`, `DictationSentence`.
- `lib/repositories/listening/podcast_repository.dart` — rewritten to `ApiClient` + static-base pattern (mirrors `GrammarRepository`). Deleted `lib/repositories/listening/mock_data.dart`.
- `lib/view_models/listening/podcast_provider.dart` — rewritten: `podcastIndexProvider`, `podcastEpisodeProvider` (family), `podcastCompletedIdsProvider`, `podcastLeaderboardProvider`, `podcastUserRankProvider`, `markPodcastEpisodeComplete`.
- `lib/screens/listening/listening_hub_screen.dart` — simplified to Easy German card (live count) + Sprechen B1/B2 cards; removed Audiobook/Dictation tabs and hardcoded fake stats (42/12h/A2).
- `lib/screens/listening/easy_german_podcast_page.dart` — bound to `podcastIndexProvider` + completed-ids set; search/filter chips kept; added retry-on-error state.
- `lib/screens/listening/easy_german_podcast_player_page.dart` — real `just_audio` playback (foreground-only, already in `pubspec.yaml`), seek/speed controls, sentence-synced transcript with VI toggle, marks complete at ≥90% position (mirrors web's `handleTimeUpdate`).
- `lib/screens/listening/sprechen_b1_page.dart`, `sprechen_b2_page.dart` — gated via new `lib/screens/listening/widgets/listening_coming_soon.dart`.
- Deleted: `dictation_page.dart`, `widgets/audiobook_list.dart`, `widgets/dictation_list.dart`, `widgets/podcast_series_card.dart`.
- `lib/navigation/app_router.dart` — episode route now `episode/:slug` (string, no more `extra` object passing); removed dictation route + `Dictation`/`PodcastEpisode` imports.
- `lib/core/release/release_feature_flags.dart` — `listening` defaultValue → `true`. `allowsMoreFeature`/`release_redirect.dart` already handled `/listening` generically — no changes needed there.
- `test/structure/release_live_data_guard_test.dart` — added the 7 listening source files to the release-visible guard list (narrow `Edit`, no other lines touched).
- `test/repositories/listening_contract_test.dart` (new) — 7 cases: index/episode static fetch, audio URL construction, completed-ids unwrap + error swallow, mark-complete POST body, leaderboard limit query, user-rank null-on-empty.
- `test/screens/listening/{listening_hub_screen,easy_german_podcast_page,easy_german_podcast_player_page}_test.dart` (new) — happy/empty/error per screen, provider-override pattern matching `test/screens/stats/daily_quote_page_test.dart`.
- `docs/flutter-live-data-inventory.md` — `/listening/**` row split into Live (Easy German) + Feature-gated placeholder (Sprechen B1/B2).
- `docs/api-changelog.md` — added `(gap, no BE change)` row documenting the Audiobook/Dictation removal + Sprechen YouTube gate, following the existing Stats-surface entry convention.

## Not done / explicitly skipped

- **ARB × 3 + `flutter gen-l10n`**: skipped. None of the listening screens (before or after this change) use `AppLocalizations` — all strings are pre-existing hardcoded Vietnamese, consistent with the original mock screens. Adding i18n now would be new scope beyond "wire to live data" and would touch 3 contended shared ARB files for no functional gain. Flagging for product/i18n decision separately.
- Background audio, YouTube integration — explicitly out of scope per task.

## Tests

- `flutter test test/repositories/listening_contract_test.dart test/screens/listening/ test/navigation/release_redirect_test.dart test/structure/release_live_data_guard_test.dart` → all pass.
- `flutter analyze` (scoped to touched files) → no issues.
- Full-repo `flutter analyze` → 1 pre-existing info-level lint in `lib/repositories/reading/reading_repository.dart` (another agent's concurrent work, not touched by me).
- Full-repo `flutter test` → 3 failures, all in `test/screens/reading/*` (another agent's concurrent reading-domain work in progress). My listening tests are green. Did not touch reading files per file-ownership boundary.

## Status

Status: DONE_WITH_CONCERNS
Summary: Easy German Podcast (list, player w/ real audio+progress+transcript, hub) is live; `listening` flag now defaults true. Sprechen B1/B2 correctly gated (real source is YouTube, out of scope) instead of faked; Audiobook/Dictation removed as pure mock inventions with no backend/web counterpart.
Concerns/Blockers: (1) ARB/i18n step skipped — no existing l10n usage in this feature to extend; flag if product wants Vietnamese-only strings changed. (2) 3 unrelated `test/screens/reading/*` failures from a concurrent agent's in-progress work — not mine to fix, left as-is per file ownership.
