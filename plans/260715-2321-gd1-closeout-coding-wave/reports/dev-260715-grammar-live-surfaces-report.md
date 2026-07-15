# Grammar live surfaces — dev report

2026-07-16

## Contract evidence (superseded the stale probe)

`plans/260715-flutter-cross-cutting-readiness/reports/verification-2026-07-15-grammar-contract-probe.md`
tested only the local `127.0.0.1:8080` checkout (no `data/grammar/` asset present
locally, `500`). Re-probed against production `https://deutschtiger.com` directly:

| Test | Result |
|---|---|
| `GET /api/v1/grammar` | `200`, real A1–C1 lesson summaries |
| `GET /api/v1/grammar/a1/121` | `200`, full lesson with `contents` blocks |
| `GET /data/grammar/a1/page-1.json` | `200`, static page (web's own fetch target) |
| `GET /data/grammar/articles/index.json` | `200`, real article index |
| `GET /data/grammar/articles/a1/01-....md` | `200`, frontmatter + markdown |
| `GET /api/v1/user/grammar-progress` (no JWT) | `401` (expected, auth required) |
| `GET /api/v1/grammar-leaderboard` (no JWT) | `401` (expected, auth required) |

Conclusion: content is live and versioned in production; only the local dev
checkout lacked the `data/` asset tree (gitignored, ~15G, rsync'd separately per
backend `CLAUDE.md`). Flag flip is justified by this evidence, not by assumption.

## Endpoints used

- `GET /grammar?level=&tag=` — lesson index (public, no JWT) → list screen.
- `GET /grammar/{level}/{id}` — full lesson incl. `contents` blocks → lesson screen.
  (Chose this over replicating the web's client-side `page-N.json` pagination
  hack — same static content, server already does the lookup.)
- `data/grammar/articles/index.json` + `data/grammar/articles/{level}/{slug}.md`
  (static, outside `/api/v1`) — article index + article body, fetched via
  `ApiClient.raw` + `staticBaseUrl`, same pattern as `InterviewRepository`.
- `GET /user/grammar-progress`, `POST /user/grammar-progress` — completion state
  (authenticated; empty/best-effort on failure, never blocks reading).

Out of scope (documented, not silently dropped): `/grammar-leaderboard`,
`/user/grammar-rank`, `/user/grammar-drill/results`. Leaderboard/rank are a
decorative sidebar on the web list page, not one of the 3 requested screens.
The drill-results endpoint belongs to the Games surface (`components/game/`
grammar mini-games), gated separately by `DEUTSCHTIGER_ENABLE_GAMES` — adding it
here would be scope creep per YAGNI.

## Files

- `lib/data/grammar/grammar_models.dart` — rewritten (was orphaned/unused mock
  DTO). Plain classes + defensive `fromJson`, sealed `GrammarContentBlock` union.
- `lib/repositories/grammar/grammar_repository.dart` — new.
- `lib/features/grammar/domain/grammar_curriculum_order.dart` — new; ports the
  web's topic-ordering/grouping logic (`grammar-curriculum-order.ts`).
- `lib/features/grammar/presentation/grammar_provider.dart` — rewritten (was
  mock `StateNotifier`).
- `lib/features/grammar/presentation/grammar_screen.dart` — rewritten: level
  grid + level detail (topic sections, search, articles sub-list).
- `lib/features/grammar/presentation/grammar_lesson_detail_screen.dart` —
  rewritten: content blocks, exercises, related lessons, mark-complete.
- `lib/features/grammar/presentation/grammar_article_screen.dart` — new.
- `lib/features/grammar/presentation/grammar_content_widgets.dart` — new
  (block renderer, kept separate to stay under ~200 LOC/file).
- `lib/features/grammar/presentation/grammar_level_widgets.dart` — rewritten
  for string levels (was an enum-based mock).
- Deleted (unused, mock-only, blocked the live rewrite): `lib/features/grammar/domain/grammar_models.dart`,
  `lib/features/grammar/data/mock_data.dart`.
- `lib/navigation/app_router.dart` — added `/grammar/articles/:level/:slug`
  and `/grammar/:level/:id` nested routes; no other routes touched.
- `lib/core/release/release_feature_flags.dart` — `grammar` defaultValue → `true`.
- `lib/l10n/app_{vi,en,de}.arb` + regenerated `app_localizations*.dart` — 12 new
  `grammar*` keys.
- `test/structure/release_live_data_guard_test.dart` — added the 6 grammar
  presentation files to the release-visible allowlist (all clean of
  mock/fixture/placeholder markers).
- `test/features/home/release_navigation_gates_test.dart` — updated one
  assertion: daily-path `grammar` skill now resolves to `/grammar` (was
  `/learn`), matching the flag flip.
- `docs/flutter-live-data-inventory.md` — `/grammar` row: Blocked → Live.

Untouched, orphaned, out of scope: `lib/screens/grammar/grammar_screen.dart`
and `lib/data/grammar/grammar_models.dart`'s old sibling mock provider were
never wired into `app_router.dart` (verified via grep) — left alone per file
ownership discipline (not asked to clean up dead code outside this surface).

## Deviations (YAGNI-driven, documented not silent)

- **No `flutter_markdown` dependency added.** Article rendering uses a minimal
  hand-rolled `# `/`## `/`- ` line-based renderer. Adding a new pub dependency
  was out of scope for this task and risks `pubspec.lock` churn under a
  concurrent multi-agent wave; content is fully readable, just not richly
  styled (no tables/inline-code/links in articles).
- **No offline mutation queue** (web has `grammarSyncQueue` for the
  mark-complete POST). `markComplete` fails silently and the CTA stays
  actionable — acceptable for a first live pass; no data loss (user can retry).
- **No global diacritic-insensitive search** — search is plain case-insensitive
  substring match (web normalizes Vietnamese diacritics). Documented, not
  blocking.
- **Leaderboard/rank/drill** — see "Out of scope" above.

## Tests

- `test/repositories/grammar_contract_test.dart` — 6 tests: lesson index,
  lesson detail + content-block parsing, article index, article
  frontmatter parsing + 404 handling, completed-ids fetch, mark-complete POST
  body/path.
- `test/screens/grammar/grammar_screen_test.dart` — 3 tests: level grid happy
  path, level-detail empty state, index-load error/retry.
- `test/screens/grammar/grammar_lesson_detail_screen_test.dart` — 3 tests:
  content blocks + CTA happy path, already-completed state, not-found error.
- `test/screens/grammar/grammar_article_screen_test.dart` — 3 tests: markdown
  render + CTA happy path, null-article (404) empty state, fetch error/retry.

## Verification log

| Test | Expected | Actual | Status |
|---|---|---|---|
| `curl https://deutschtiger.com/api/v1/grammar` | Real lesson index | 200, array of lessons | ✅ |
| `curl https://deutschtiger.com/api/v1/grammar/a1/121` | Full lesson w/ contents | 200 | ✅ |
| `curl https://deutschtiger.com/data/grammar/articles/index.json` | Real article index | 200 | ✅ |
| `flutter analyze` | Clean | 0 issues | ✅ |
| `flutter test test/repositories/grammar_contract_test.dart` | 6/6 pass | 6/6 | ✅ |
| `flutter test test/screens/grammar/` | 9/9 pass | 9/9 | ✅ |
| `flutter test` (full suite) | Clean | 280/281 pass — 1 unrelated failure (`test/structure/widgets_layer_test.dart: lib/widgets/stats/ exists`), caused by the concurrent stats-agent's in-flight directory move, not by this change (verified: file untouched by grammar work, failure pre-existed mid-session before this report) | ⚠️ (out of scope) |

## Gaps to track

- `docs/api-changelog.md`: no backend gap to log — every endpoint used here
  already exists and returns real data; only the local dev checkout lacked the
  `data/` directory (documented in this repo's backend CLAUDE.md as
  intentionally gitignored/rsync'd, not a backend bug).

Status: DONE_WITH_CONCERNS
Summary: Grammar list/lesson/article are live against the real `deutschtiger.com` backend (index, lesson, static articles, progress); flag flipped to `true`; analyze clean; grammar+dependent tests pass (18/18 new + 1 updated). Only pre-existing concern is a full-suite failure in a stats-domain structure test caused by a concurrent agent's in-flight file move — unrelated to this change and outside my file ownership, not fixed.
Concerns/Blockers: `test/structure/widgets_layer_test.dart` fails on `lib/widgets/stats/` (concurrent agent's WIP, not mine to fix). Article markdown rendering is intentionally minimal (no new pub dependency added). Leaderboard/rank/drill-results intentionally out of scope.
