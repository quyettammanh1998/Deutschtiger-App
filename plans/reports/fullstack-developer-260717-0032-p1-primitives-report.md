# P1 Workstream D — Shared UI Primitives Report

Phase: `plans/260716-2324-web-mobile-ui-100-fidelity/phase-01-foundation-tokens-fonts-icons-shell.md` §5.
Status: DONE_WITH_CONCERNS (see blocker below — worked around within file ownership, needs pubspec fix by icon-system owner).

## Files created/modified

- `lib/widgets/common/app_card.dart` (new) — `AppCard`.
- `lib/widgets/common/app_button.dart` (new) — `AppButton`, `AppGradientButton`.
- `lib/widgets/common/app_pill.dart` (new) — `AppPill`.
- `lib/widgets/common/sticky_cta_bar.dart` (new) — `StickyCtaBar`.
- `lib/widgets/common/gradient_section_header.dart` (new) — `GradientSectionHeader`.
- `lib/widgets/common/game_shell.dart` (new) — `GameShell`, `GameWallOverlay`, `FreeLimitOverlay`.
- `lib/shared/widgets/page_intro.dart` (rewritten) — `PageIntro` (see "PageIntro spec correction" below).
- `test/widgets/common/app_card_test.dart`, `app_button_test.dart`, `game_shell_test.dart` (new).

All widgets read colors exclusively via `context.tokens` (`AppTokens`); none import the deprecated `DesignTokens`/`AppColors` statics.

## CRITICAL blocker found: `phosphor_flutter` doesn't compile on this SDK

`pubspec.yaml` pins `phosphor_flutter: ^2.1.0` (added by the icon-system workstream). That version's `PhosphorIconData extends IconData`. The installed Flutter SDK (3.44.1) marks `IconData` as `final class` (a Flutter breaking change: https://docs.flutter.dev/release/breaking-changes/icondata-class-marked-final). Any file importing `phosphor_flutter` (directly or via `AppPhosphorIcons`) fails to compile — confirmed by running `flutter test`, reproducible in isolation. `flutter analyze` does NOT catch it (static analysis passes; only the kernel/CFE compile step fails), so this was invisible until test execution. 2.1.0 is phosphor_flutter's latest published version (verified on pub.dev) — no newer release fixes it. Confirmed community fix: migrate to `phosphoricons_flutter` (typedef-based, doesn't extend `IconData`), a drop-in replacement.

Impact: this blocks compiling/testing ANY code that touches `AppPhosphorIcons`/`phosphor_flutter`, not just mine — i.e. every later phase's icon usage is currently broken. `pubspec.yaml` is outside my file ownership so I could not fix it directly.

Workaround applied (scoped to my 2 files only): `game_shell.dart` and `page_intro.dart` use Material `Icons.*` instead of `AppPhosphorIcons.*` for now, with inline comments explaining why and what to swap back to. No visual regression of consequence (back-chevron/info/clock/game-controller glyphs are close Material equivalents); functionality unaffected.

**Action needed from whoever owns `pubspec.yaml`/icon system**: replace `phosphor_flutter: ^2.1.0` with `phosphoricons_flutter` (same icon set, API-compatible via typedef) in `pubspec.yaml`, then re-point `app_phosphor_icons.dart`'s import. After that, revert the 4 Material-icon substitutions in `game_shell.dart`/`page_intro.dart` back to `AppPhosphorIcons.*` (marked inline).

## Public API reference

### `AppCard` (`lib/widgets/common/app_card.dart`)
Web parity: `.card` / `.card-sm` / `.card-interactive`.
```dart
AppCard.card({child, onTap, padding, margin})       // radius 16, light=transparent border+2-layer shadow, dark=visible border+1-layer shadow
AppCard.small({child, onTap, padding, margin})       // radius 12, ALWAYS visible border, single shadow (light+dark)
AppCard.interactive({child, required onTap, padding, margin}) // radius 16, press-state shadow change (Flutter has no hover)
```
Also the base `AppCard(variant: AppCardVariant.card|cardSm|interactive, ...)` constructor.

### `AppButton` / `AppGradientButton` (`lib/widgets/common/app_button.dart`)
Two distinct shapes, matching two different web constructs:
- `AppButton` = web `<Button>` component (`components/ui/button.tsx`): 40px (36px `size: small`), `radius 8`, `px-4`, `font-medium`. Variants `AppButtonVariant.primary|ghost|outline`. `AppButton.icon(icon:, onPressed:)` for the 40x40 icon-only shape.
- `AppGradientButton` = `.btn-primary`/`.btn-secondary` CSS utilities: `radius 16` (`tokens.radius`), gradient (`primary` → `Color.lerp(primary, black, .25)` approximating `color-mix(primary 75%, #000)`) for `.primary`, `tokens.muted` fill for `.secondary`. Does NOT replace `lib/widgets/common/gradient_button.dart` (kept as-is; auth screens still use it, per P2 ownership).

### `AppPill` (`lib/widgets/common/app_pill.dart`)
`AppPill({label, background, foreground, icon, fontSize, padding})` — generic rounded-full chip, defaults to `bg-muted` styling. `AppPill.tinted(context, label:, icon:)` factory for the `bg-primary/10 text-primary` variant.

### `StickyCtaBar` (`lib/widgets/common/sticky_cta_bar.dart`)
`StickyCtaBar({child, padding, clearBottomNav})` — bottom bar with top border, `tokens.card` bg, pads for device safe-area; `clearBottomNav: true` adds 64px to also clear `AppShell`'s bottom nav when overlaid on a page that still shows it.

### `GradientSectionHeader` (`lib/widgets/common/gradient_section_header.dart`)
`GradientSectionHeader({title, gradientColors, subtitle, leading, trailing, borderRadius, padding})` — generic gradient hero shell (grammar level-detail hero pattern); caller supplies per-level/section gradient colors.

### `GameShell` (`lib/widgets/common/game_shell.dart`)
```dart
GameShell({
  required title, required child, trailing,
  exitGuard = true, exitConfirmMessage, onExit,
  scrollable = true,
})
```
- No `AppBar` — in-content header row (36px bordered back button + title), matches web §0 pattern.
- `exitGuard` wraps `PopScope`: back button + system back both trigger `showConfirmDialog` ("Thoát bài luyện tập?", destructive) before calling `onExit` (default `Navigator.pop`).
- `GameShell.showCompletion(context, {score, total, onPlayAgain, onGoHome, ...})` — static helper pushing the existing `GameCompletionScreen` (confetti + score card), reused as-is per instructions; NOT modified (out of my file ownership). XP-pill/retry-wrong web-parity gaps on that screen are tracked separately, not fixed here.
- `GameWallOverlay({gameName, playsUsed, maxPlays, onClose, onUpgrade})` and `FreeLimitOverlay({used, max, onUpgrade, onClose})` — both gated behind `ReleaseFeatureFlags.premium` (default `false` per existing flag file, untouched); render `SizedBox.shrink()` until that flag flips on, so wiring them into game screens now is safe/inert. `onUpgrade`/`onClose` are caller-supplied callbacks (no hardcoded route names — navigation/route ownership stays with the router phase).

### `PageIntro` (`lib/shared/widgets/page_intro.dart`)
**Spec correction (verified against source, contradicts phase-file assumption):** the actual web `page-intro.tsx` is NOT a "Grandstander title + muted description" header — it's a collapsible 3-line orienting strip (why/todo/next), collapse-state persisted per `pageKey` in `localStorage`. Confirmed via direct read of `thamkhao/deutschtiger-frontend/src/components/shared/page-intro.tsx` and 8 real `<PageIntro>` usages under `src/pages/`. The Flutter `PageIntro` was previously unused anywhere in `lib/` (grepped before editing), so rebuilding its API to match was a non-breaking change.
```dart
PageIntro({
  required pageKey, required why, required todo, required next,
  nextTo, nextLabel, onNextTap, padding,
})
```
- `pageKey` persists collapse state via `SharedPreferences` (`pi:{pageKey}`), mirroring web's `store.get/set`. Defaults expanded on first visit, like web.
- `nextTo` (route name, `Navigator.pushNamed`) or `onNextTap` (custom navigation) — pick whichever the call site needs.
- Icon: `info_outline`/`keyboard_arrow_down` are Material stand-ins pending the `phosphor_flutter` fix (see blocker above).

## Tests

- `test/widgets/common/app_card_test.dart` — light `.card` has transparent border + shadow; dark `.card` has visible border; `.card-sm` always bordered; interactive card fires `onTap`.
- `test/widgets/common/app_button_test.dart` — 40px height + radius-8 shape; 36px `small` size; disabled state; `onPressed` fires.
- `test/widgets/common/game_shell_test.dart` — back button → confirm dialog → confirm exits / cancel stays; `exitGuard: false` pops without a dialog; renders title + child.

`flutter test test/widgets/common/` → **13/13 pass**. `flutter analyze` on all touched files → **0 issues**. Whole-repo `flutter analyze` has 20 pre-existing issues, none in my files (all in `more_features_dialog.dart`/`release_navigation_gates_test.dart`, owned by another in-flight agent per the task briefing).

## Unresolved questions

1. `phosphor_flutter` → `phosphoricons_flutter` pubspec swap (see blocker) — needs the icon-system/pubspec owner to action; I've left inline markers of exactly what to revert in `game_shell.dart` (3 spots) and `page_intro.dart` (2 spots).
2. `PageIntro`'s new API is a breaking rewrite of the old title/subtitle shape — confirmed zero existing callers before changing it, but flagging explicitly since the phase file's spec text didn't match the actual web component.
3. `GameWallOverlay`/`FreeLimitOverlay` need real `playsUsed`/`maxPlays`/`used`/`max` data sources — out of scope here (shell only, no mock data); whichever phase wires per-game play counts should also flip `ReleaseFeatureFlags.premium` when GĐ2 monetization lands.

Status: DONE_WITH_CONCERNS
Summary: Built all 7 requested primitives (AppCard, AppButton+AppGradientButton, AppPill, StickyCtaBar, GradientSectionHeader, GameShell+overlays, rewritten PageIntro), all token-driven light/dark, with passing widget tests; found and worked around (within file ownership) a critical pre-existing `phosphor_flutter`/Flutter-SDK incompatibility that blocks the whole icon system's tests, needs a pubspec fix from that workstream's owner.
Concerns/Blockers: `phosphor_flutter` pubspec incompatibility (see above) — not fixed by me (pubspec.yaml off-limits), only worked around locally in my 2 files.
