# P1 Foundation — Tokens + Theme + Build Hotfix Report

Phase: `plans/260716-2324-web-mobile-ui-100-fidelity/phase-01-foundation-tokens-fonts-icons-shell.md` (workstream A)
Status: DONE

## Files Modified/Created
- CREATE `lib/core/theme/app_tokens.dart` (280 lines) — `AppTokens` ThemeExtension, light+dark const instances, `copyWith`/`lerp`, `BuildContext.tokens` extension.
- CREATE `lib/screens/journey/widgets/journey_daily_plan_step_row.dart` (219 lines) — hotfix: missing `JourneyPlanStepRow` widget, mirrors web `daily-path-stepper.tsx` `<li>` (status rail + tappable step card + CTA badge).
- MODIFY `lib/core/theme/app_theme.dart` — light/dark `ColorScheme.fromSeed` now seeded from `AppTokens.light`/`AppTokens.dark`; registered `extensions: [AppTokens.light]` / `[AppTokens.dark]`.
- MODIFY `lib/core/design_tokens.dart` — fixed light semantic color values to real web hex (primary pink #FF8FA3 → orange #F7911D, etc, HSL→hex verified via python colorsys against `thamkhao/.../index.css`); `@Deprecated`'d the light semantic statics (+ dark counterparts, values untouched); added `// ignore: deprecated_member_use_from_same_package` on same-file self-references (`ring=primary`, `tabActiveColor=primary`, 7× `color: foreground` in typography getters, `darkCardBackground=darkCard`, `darkRing=darkPrimary`, `darkError=darkDestructive`, `darkAuthBackground=darkBackground`).
- MODIFY `lib/core/theme/app_colors.dart` — mirrored `@Deprecated` on the same semantic re-exports (light+dark), ignore-commented same-package references to `DesignTokens.*`.
- MODIFY `docs/design-tokens-from-web.md` — rewrote to document 2-layer model (`AppTokens` = source of truth, statics deprecated/light-only) + corrected light/dark HSL→hex tables.
- CREATE `test/core/theme/app_tokens_test.dart` (9 tests) — primary hex assertions (light orange / dark blue), radius, `context.tokens` resolution from `AppTheme.light`/`.dark`, fallback when extension missing, `lerp`, `copyWith`.

## Tasks Completed
- [x] Hotfix: created `JourneyPlanStepRow(step, isCurrent, isLast)` matching call site in `journey_daily_plan_section.dart:98-102`.
- [x] `AppTokens` ThemeExtension with full token set (26 colors + radius), light+dark instances, `copyWith`/`lerp`, `context.tokens` accessor with light fallback.
- [x] Registered both instances on `ThemeData.extensions`; aligned `ColorScheme` seed/primary/surface/error with `AppTokens`.
- [x] Fixed LIGHT statics in `design_tokens.dart`/`app_colors.dart` to real web values; froze legacy semantic statics with `@Deprecated` (light+dark; dark hex values left untouched per explicit "fix LIGHT" scope).
- [x] Docs rewritten with 2-layer model + corrected tables.
- [x] Test file: 9 passing tests covering all acceptance bullets.

## Tests Status
- Type check / `flutter analyze`: PASS — 0 errors, 0 new warnings/infos. Full-repo run shows only 5 pre-existing unrelated infos (Radio deprecation in `de_thi_practice_screen.dart`, 3× `prefer_initializing_formals` in unrelated test files).
- `flutter test test/core/`: PASS — 49/49 (includes the new 9 `app_tokens_test.dart` cases + existing `design_tokens_test.dart` + `translation_service_test.dart`).

## Key Finding: no deprecation-flood risk
Verified empirically (isolated repro + full `flutter analyze`): Dart's analyzer does **not** surface `deprecated_member_use` for same-package usages by default (`deprecated_member_use_from_same_package` is a separate, opt-in diagnostic not enabled by `flutter_lints`). So deprecating ~30 `DesignTokens`/`AppColors` semantic statics used across 112+ consumer files produced **zero** new analyze noise — contingency clause in the brief ("if infos explode, report but don't weaken") did not trigger. Added `// ignore: deprecated_member_use_from_same_package` comments inside the two token files anyway (harmless, documents intent, future-proofs if the rule is ever enabled project-wide).

## Deviations from literal brief
- Did not recompute/change `DesignTokens.dark*` hex values — brief said "Fix the LIGHT static values"; dark statics got `@Deprecated` only (still frozen, still usable, just not re-verified against web `.dark` HSL). Documented explicitly in both `design_tokens.dart` comment block and `docs/design-tokens-from-web.md`.
- `error`/`info`/`cardBackground` and dark equivalents (`darkError`, `darkInfo`, `darkCardBackground`, `darkAuthBackground` values) intentionally NOT deprecated — not part of the `AppTokens` field set (aliases/utility colors), kept as-is per YAGNI.
- New step-row widget (`journey_daily_plan_step_row.dart`) uses `DesignTokens.*` statics (not `context.tokens`) to match the surrounding file's existing style (`journey_daily_plan_section.dart` also uses `DesignTokens.*`) — consistent with "don't mass-migrate consumers" instruction; it's a light-only screen today anyway.

## Unresolved Questions
- None blocking. Open item for a later phase: should `journey_daily_plan_section.dart` + the new step-row widget be migrated to `context.tokens` when journey/dark-mode work lands? Left as-is per file-ownership scope (not in my file list) and since dark-mode isn't wired into any screen yet.

Status: DONE
Summary: Hotfix widget created (build unblocked), AppTokens ThemeExtension complete + registered light/dark, DesignTokens/AppColors light values corrected + frozen with @Deprecated, docs rewritten, 9/9 new tests pass, flutter analyze clean (0 errors, only 5 pre-existing unrelated infos).
Concerns/Blockers: none.
