# Stats surface: mock → live API

## Endpoints used
- `GET /user/review-stats` → `total_reviews`, `words_learned`
- `GET /user/xp-daily-log?days=7` → weekly XP chart
- `GET /user/srs/mastery` → FSRS maturity buckets (new/learning/young/mature/total)
- `GET /user/srs/stats/daily?days=30` → 30-day review trend
- `GET /user/error-patterns/summary` → grouped mistake list (matches web `error-patterns-page.tsx`)
- `GET /api/v1/quotes/daily`, `GET /api/v1/quotes/random?limit=` → daily quote page
- Reused existing `dashboardProvider` (`/user/dashboard-init`) for level/total XP/streak — no new call.

Not wired (route exists but unused on Stats surface — matches web, which also doesn't
surface these on the stats page): `GET /user/flashcards/stats`, `GET /user/error-patterns`
(full list), `DELETE /user/error-patterns[/…]`.

## Files
- Rewrite: `lib/repositories/stats/stats_repository.dart`, `lib/data/stats/stats_models.dart` (freezed)
- New: `lib/data/stats/quote_model.dart`, `lib/repositories/stats/error_patterns_repository.dart`,
  `lib/repositories/stats/daily_quote_repository.dart`
- New view-models: `lib/view_models/stats/error_patterns_provider.dart`,
  `lib/view_models/stats/daily_quote_provider.dart`; rewrote `lib/view_models/stats/stats_provider.dart`
- Screens rewritten: `lib/screens/stats/stats_screen.dart`, `error_patterns_page.dart`, `daily_quote_page.dart`
- Widgets: rewrote `widgets/srs_stats_card.dart`, `widgets/error_patterns_list.dart`; new
  `widgets/error_pattern_labels.dart` (VI/EN/DE label+color per `error_type`, mirrors web
  `ERROR_TYPE_CONFIG`); deleted `widgets/near_achievements_list.dart` (no backend source)
- Deleted dead code: `lib/widgets/stats/online_time_card.dart` (orphaned, referenced removed mock
  `TimeStats`, zero call sites) — kept `lib/widgets/stats/` dir empty to satisfy
  `widgets_layer_test.dart` (same pattern as pre-existing empty `lib/widgets/quiz/`)
- l10n: 41 new keys across `app_vi.arb`/`app_en.arb`/`app_de.arb`; ran `flutter gen-l10n`
- Flag: `lib/core/release/release_feature_flags.dart` `stats` defaultValue → `true`
  (`release_redirect.dart`/`allowsMoreFeature` read the flag dynamically, no change needed)
- `test/structure/release_live_data_guard_test.dart`: added the 3 stats screens
- Tests: `test/repositories/stats_contract_test.dart` (6 cases), 3 widget test files under
  `test/screens/stats/` (happy/empty/error each)
- Docs: `docs/flutter-live-data-inventory.md` (`/stats/**` row → Live), `docs/api-changelog.md`
  (gap note)

## Scope decisions (web spec as source of truth)
- Streak/level/XP totals reuse `dashboardProvider` — the web stats page also reads these off
  `useGamification()`, not a Stats-specific endpoint.
- Dropped "Near achievements" (mock `NearAchievement`) and "time-spent-by-feature" chart (mock
  `TimeStats`/`StreakInfo`): no backend endpoint in the given route list, and the web stats page
  derives near-achievements client-side from the (separately mocked, out-of-scope) achievements
  list — not a real contract to copy. Replaced the old time-spent bar chart with the weekly-XP
  chart (`xp-daily-log`), matching web's `StatsXpBarChart`.
- `error-patterns-page.dart`: dropped the old 2-tab (list/grouped-by-category) UI — the backend
  summary endpoint already returns one row per `error_type`, so a client-side re-grouping tab was
  redundant. Sort by count/recency only (no `errorRate` — the aggregate has no attempts denominator).
- Daily quote: kept 2 endpoints (`/quotes/daily` for the hero card, `/quotes/random` for the
  "explore more" grid) rather than copying web's single random-carousel UX, since our existing
  screen shape (hero + grid) already fit; refresh button relabeled "Tải lại" instead of implying
  a new random quote (daily endpoint is deterministic per day).

## Tests
- Focused: `flutter test test/repositories/stats_contract_test.dart test/screens/stats/
  test/structure/release_live_data_guard_test.dart test/structure/widgets_layer_test.dart` → all
  pass (24 tests)
- Final gate: `flutter analyze` clean (0 issues), `flutter test` 282/282 green

## Gaps (logged in docs/api-changelog.md)
- No backend endpoint for "near achievements" or generic "time spent by feature/day" — feature
  intentionally dropped from mobile rather than faked.
- `GET /user/flashcards/stats` and `GET /user/error-patterns` (full list) exist but aren't
  consumed by any Stats UI (mobile or web) — left unimplemented in the repo layer (YAGNI).

Status: DONE
Summary: Stats/error-patterns/daily-quote screens now bind live backend endpoints, `stats` release flag flipped to true, guard/contract/widget tests added, analyze+test suite green.
Concerns/Blockers: none blocking. Two feature drops (near-achievements, time-by-feature) vs. old mock UI — no backend contract exists for either; documented in docs/api-changelog.md and flutter-live-data-inventory.md instead of faking data.
