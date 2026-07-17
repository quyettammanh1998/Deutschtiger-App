# Dark-mode static-token migration — closing the last acceptance criterion

Plan: `plans/260716-2324-web-mobile-ui-100-fidelity/plan.md`. Closes: "Dark
mode theo palette web trên mọi màn rebuild; không màn release-visible nào
còn đọc static light token." Baseline: `flutter analyze` 0 errors (33 info),
`flutter test` 747/747 green, commit `1707a8b`. Source list: audit in
`docs/design-tokens-from-web.md` §"Audit 17/07/2026" and
`plans/reports/fullstack-developer-260717-0549-p12-wave-b-deletion-sweep-qa-report.md`
§5b (34 release-visible files still reading `DesignTokens.`/`AppColors.`).

Status: DONE
Summary: All 33 real colour-carrying files (34 audited minus 1 confirmed
false-positive) migrated from frozen `DesignTokens`/`AppColors` statics to
`context.tokens` (`AppTokens`). `flutter analyze` 0 errors / 33 info (matches
baseline, 0 `deprecated_member_use` warnings project-wide); `flutter test`
747/747 green (matches baseline exactly). No file required a refactor beyond
a colour swap — every deprecated colour read had a `BuildContext` reachable.
Concerns/Blockers: none blocking.

## Method

Work split into 4 disjoint parallel `fullstack-developer` subagents (file
ownership non-overlapping, one dir cluster each: learn/games, reading, news,
misc+`ai_chat_page.dart`), each given the exact `@Deprecated`-member mapping
table from `app_tokens.dart`/`design_tokens.dart`/`app_colors.dart` and an
explicit exclusion list of non-deprecated utility colours/spacing constants
to leave untouched. Each agent self-validated with a scoped `flutter
analyze` on its directories before reporting. I then ran the full-project
`flutter analyze` + `flutter test` centrally and cross-checked every one of
the 33 files by hand (grep for remaining `DesignTokens.`/`AppColors.`
matches + manual classification of each remaining symbol) before writing
this report.

## Before/after count

- **Before**: 34 release-visible files matched `DesignTokens.`/`AppColors.`
  (per the wave-B audit).
- **1 confirmed false positive**: `lib/screens/reading/widgets/
  save_article_words_cta.dart` — its only match is `DesignTokens.spacingXs`
  (a spacing constant, not a colour). Left untouched, not counted below.
- **33 files with real colour reads** → all 33 migrated/verified. 4 of them
  turned out to already be fully theme-aware (grep matches were spacing/
  fixed-utility colours only, not deprecated semantics) and needed no edit:
  `read_listen_hub_screen.dart`, `reading_leaderboard.dart`,
  `reading_detail_screen.dart`, `news_leaderboard.dart`.
- **29 files actually edited** (colour reads migrated to `context.tokens.X`).
- **After**: 0 release-visible files reading a deprecated colour static.
  Full-project `flutter analyze` shows 0 `deprecated_member_use` warnings
  anywhere in `lib/`.

## Per-file notes (non-obvious only)

- `lib/screens/learn/widgets/mastery_ring.dart` — colour was read in a
  `_color` getter/`CustomPainter` with no `BuildContext`. Refactored to a
  `_colorFor(AppTokens tokens)` method called from `build()`, and the
  painter now takes an explicit `trackColor` parameter instead of reading
  the static directly — colour-only refactor, no behaviour change.
- `lib/screens/games/*` — several files had a stray `const TextStyle`/`const
  Icon` wrapping a colour that is no longer a compile-time constant once it
  reads `context.tokens.X`; `const` dropped where needed (verified via
  `flutter analyze`, no leftover const-context violations).
- `lib/screens/exam/exam_dictation_picker_screen.dart` — mixed deprecated
  semantics (`background`, `mutedForeground`, `card`, `border`) with the
  non-deprecated `exam*` utility family (`examActive`, `examSuccess`,
  `examWarn*`, etc, layout tokens); only the former migrated, `exam*` left
  as-is per the audit doc's explicit exclusion.
- `lib/screens/ai/ai_chat_page.dart` (largest, 46 raw matches) — 31 deprecated
  colour uses migrated (`background`, `card`, `border`, `foreground`,
  `success`, `mutedForeground`, `primary`, `warning`, `muted`); left
  `shadowSm`, `orange500`/`rose600` (brand gradient), `error`, `tigerOrange`,
  `primaryGradient` untouched — all non-deprecated, fixed-by-design.

## Deliberately-kept fixed colours (not bugs)

Per task instruction, colours web keeps fixed across both themes stay fixed
here too, confirmed by checking `design_tokens.dart`/`app_colors.dart`
annotations (absence of `@Deprecated` = intentionally not part of
`AppTokens`):
- `tigerOrange`/`tigerOrangeDark`, `orange50/100/500/600`, `rose600`,
  `primaryGradient` — brand orange/gradient, fixed both themes.
- `authBackground` — auth pages' warm-cream background, dark-by-design per
  the plan's own prior decision (not re-litigated here).
- `error`, `info`, `shadowSm`/`shadowMd`/`shadowLg`/`shadowCard` — utility
  colours/shadows never added to `AppTokens`, out of scope.
- Spacing/radius/typography constants (`spacingXs/Sm/Md/Lg/Xl`, `radius`,
  `radiusSm`, `cardPadding`, `screenHorizontalPadding`, `bottomNavHeight`,
  etc) — never colours, correctly excluded per the audit doc's own
  false-positive warning.

## Files that could NOT be migrated

None. Every one of the 33 files had all its deprecated colour reads inside a
reachable `BuildContext` (widget `build()`, `State`/`ConsumerState` instance
methods via `context` getter, or builder callbacks with `context` in scope).
No global/static lookup was introduced; `mastery_ring.dart`'s painter is the
one case that needed a small structural change (parameter threading), done
safely.

## Validation

- `flutter analyze` → 0 errors, 33 info (identical count to baseline; 0
  `deprecated_member_use` warnings anywhere in `lib/`).
- `flutter test` → 747/747 passed (matches baseline exactly, no regressions,
  no tests weakened or removed).
- `test/structure/release_live_data_guard_test.dart` — untouched, not
  weakened (this task made colour-only changes to already-listed
  release-visible files, no guard entries needed changing).

## Files modified

**`lib/` (29):** `screens/ai/ai_chat_page.dart`,
`screens/exam/exam_dictation_picker_screen.dart`,
`screens/games/article_game_screen.dart`,
`screens/games/cases/case_cloze_quiz_screen.dart`,
`screens/games/cases/verb_case_quiz_screen.dart`,
`screens/games/konjugation_game_screen.dart`,
`screens/games/listening_game_screen.dart`,
`screens/games/word_order_game_screen.dart`,
`screens/games/word_sprint_game_screen.dart`, `screens/home/home_screen.dart`,
`screens/learn/focus_session_screen.dart`,
`screens/learn/learner_model_screen.dart`,
`screens/learn/widgets/can_do_card.dart`,
`screens/learn/widgets/mastery_ring.dart`,
`screens/news/news_detail_screen.dart`, `screens/news/news_list_screen.dart`,
`screens/news/widgets/news_cards.dart`,
`screens/news/widgets/news_detail_widgets.dart`,
`screens/news/widgets/news_quiz.dart`,
`screens/notifications/notification_center_screen.dart`,
`screens/notifications/widgets/notification_tile.dart`,
`screens/reading/reading_feed_screen.dart`,
`screens/reading/reading_hub_screen.dart`,
`screens/reading/widgets/reading_detail_widgets.dart`,
`screens/settings/delete_account_screen.dart`,
`screens/social/chat_page.dart`, `screens/stats/widgets/srs_stats_card.dart`,
`screens/video_library/video_library_tracker_screen.dart`,
`screens/video_library/video_library_watch_screen.dart`.

**Docs (1):** `docs/design-tokens-from-web.md` (new migration section under
the existing audit).

**Not touched (per file-ownership boundary):** `lib/core/theme/app_tokens.dart`,
`lib/core/theme/app_theme.dart`, `lib/core/design_tokens.dart`,
`lib/core/theme/app_colors.dart` (both stay frozen+deprecated, no members
un-deprecated or deleted), `lib/navigation/**`, `pubspec.yaml`.

## Unresolved questions

None.

Status: DONE
Summary: 33/33 real colour-carrying release-visible files migrated to
`context.tokens`; 0 remaining, 0 regressions, plan's dark-mode acceptance
criterion is met.
Concerns/Blockers: none.
