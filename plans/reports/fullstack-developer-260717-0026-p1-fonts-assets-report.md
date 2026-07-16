# Phase 1 (Workstream B) — Fonts, Assets, pubspec deps

## Executed Phase
- Phase: phase-01-foundation-tokens-fonts-icons-shell.md (workstream B)
- Plan: plans/260716-2324-web-mobile-ui-100-fidelity/
- Status: completed

## Files Modified
- `pubspec.yaml` — added `phosphor_flutter: ^2.1.0`, `markdown_widget: ^2.3.2+8` deps; added `flutter: fonts:` block (Inter 400/500/600/700, Grandstander 700, Fredoka One 400); extended `flutter: assets:` with `assets/images/game/`, `assets/images/game/tiger-frames/`, `assets/images/game/obstacles/`, `assets/images/quotes/`. `flutter_svg: ^2.3.0` already present, verified.

## Files Created
- `assets/fonts/Inter-Regular.ttf`, `Inter-Medium.ttf`, `Inter-SemiBold.ttf`, `Inter-Bold.ttf`
- `assets/fonts/Grandstander-Bold.ttf`
- `assets/fonts/FredokaOne-Regular.ttf`
- `assets/icons/tiger-icon.svg`, `assets/icons/deutsch-tiger-logo.svg`, `assets/icons/bulb.webp`
- `assets/images/anh1.webp`
- `assets/images/game/game-icon.webp`
- `assets/images/game/tiger-frames/frame-00.webp` … `frame-06.webp` (7 files)
- `assets/images/game/obstacles/*.webp` (9 files: barrel, cactus, cactus2, crate, fence, game-bg, junk, rock, tractor)
- `assets/images/quotes/quote-01.webp` … `quote-20.webp` (20 files, via rsync from `deutschtiger:~/dist/images/quotes/`)

## Font Sourcing Detail
- `thamkhao/.../public/fonts/inter-400-700.woff2` is a **variable font** (wght axis 100–900). Decompressed with `fontTools.ttLib.woff2`, then used `fontTools.varLib.instancer` to cut static instances at wght=400/500/600/700 → 4 static TTFs declared per-weight under family `Inter`.
- `thamkhao/.../public/fonts/grandstander-700-{latin,vietnamese}.woff2` subsets were too narrow (227 + 116 glyphs, split scripts). Instead downloaded the full Google Fonts variable `Grandstander[wght].ttf` (659 glyphs, full Latin+Vietnamese coverage) and instanced wght=700, renamed internal `name` table records to family `Grandstander` / subfamily `Bold`.
- `thamkhao/.../public/fonts/fredoka-one-400.woff2` decompressed to only 12 glyphs (site had subsetted it to the specific title text used on the landing page — insufficient for general app use). Fell back to Google Fonts' consolidated `Fredoka[wdth,wght].ttf` variable font (320 glyphs), instanced at wght=400/wdth=100, and rewrote `name` table (family/subfamily/full/postscript, ID1/2/4/6/16/17, both platform 1 and 3) to `Fredoka One` / `Regular` so the family name matches the required legacy name exactly (Google Fonts merged "Fredoka One" into "Fredoka" upstream; the static instance at wght=400 wdth=100 is the visual equivalent of the legacy Fredoka One face).
- Family names verified via `fontTools` name-table inspection: `Inter`, `Grandstander`, `Fredoka One` — exact match to spec.
- `google_fonts: ^6.2.1` left untouched in pubspec (other code may still use it for on-demand families); the 3 bundled families are fully local and need no runtime fetch.

## Deps Resolution
- `phosphor_flutter: ^2.1.0` → resolved 2.1.0 (latest compatible with Dart SDK ^3.12.1 / current lockfile constraints).
- `markdown_widget: ^2.3.2+8` → resolved 2.3.2+8, pulled in `markdown 7.3.1`, `highlight 0.7.0`, `scroll_to_index 3.0.1`, `visibility_detector 0.4.0+2` as transitive deps.
- `flutter pub get` completed clean (`Changed 7 dependencies!`), no version conflicts.

## Tasks Completed
- [x] Bundle Inter/Grandstander/Fredoka One as TTF, declared in pubspec
- [x] Add phosphor_flutter + markdown_widget deps, `flutter pub get` clean
- [x] Verify flutter_svg present
- [x] Copy web-repo SVG/webp assets into `assets/` tree, declared in pubspec
- [x] rsync 20 quote-*.webp from `deutschtiger` SSH host (host was reachable)
- [x] `flutter analyze` — 0 errors (one transient `pictureInPicture` error appeared on the very first full-repo analyze run before pub get had fully settled the resolved phosphor_flutter version in the analyzer cache; a scoped re-run against that exact file and a second full-repo run both show 0 errors — confirmed `PhosphorIcons.pictureInpicture()` exists in phosphor_flutter 2.1.0 and the code at `lib/core/icons/app_phosphor_icons.dart` matches it exactly)

## Tests Status
- `flutter pub get`: pass
- `flutter analyze`: pass — 0 errors, 5 pre-existing info-level lints (deprecated `groupValue`/`onChanged` RadioGroup API in `de_thi_practice_screen.dart`, 3x `prefer_initializing_formals` in unrelated test files) — none introduced by this change, none of them the previously-flagged `journey_daily_plan_section.dart` error (already resolved by another agent).

## Issues Encountered
None blocking. No missing source assets from the web repo (all files listed in requirements existed).

## Unresolved Questions
- None. Font family-name choices (Inter variable→static instancing, Grandstander/Fredoka One sourced from upstream Google Fonts full variable fonts rather than the site's narrow subsets) were resolved unilaterally per the phase spec's fallback guidance since the primary source assets were insufficient for general app typography — flag for review if pixel-exact glyph shapes from the site's exact font build matter (unlikely, as Google Fonts variable-font default instances match the static webfont releases upstream).

Status: DONE
Summary: Fonts (Inter 4 weights, Grandstander 700, Fredoka One 400) converted to static TTF and bundled; phosphor_flutter + markdown_widget added and resolved; all listed web-repo assets + 20 server quote images copied; pubspec valid, pub get and analyze clean.
Concerns/Blockers: none.
