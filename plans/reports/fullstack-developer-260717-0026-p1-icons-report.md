# Phase 1 (workstream C) — Icon system

## Files created
- `lib/core/icons/app_phosphor_icons.dart` (117 LOC) — 102 distinct `@phosphor-icons/react` names used in `thamkhao/deutschtiger-frontend/src`, mapped to `PhosphorIconData` getters (regular weight, matching web's default when `weight` prop is omitted).
- `lib/core/icons/feature_icon_svgs.dart` (~110 LOC) — raw SVG string data ported 1:1 from `thamkhao/deutschtiger-frontend/src/lib/shared/feature-icons.tsx`.
- `lib/core/icons/app_icons.dart` (~85 LOC) — `AppIcons` public API, one static method per bespoke icon, rendered via `SvgPicture.string` + `ColorFilter.srcIn` (no pubspec/asset changes needed).

## Survey results
- Distinct web Phosphor icon names: **102** (via `grep -rhoE "import \{...\} from '@phosphor-icons/react'"` across `thamkhao/deutschtiger-frontend/src`).
- Weight usage on web: `bold` 298, `regular` 136 (redundant w/ default), `fill` 75, `duotone` 5, `thin` 3. No global `IconContext` weight override found → default is "regular", which is what every `AppPhosphorIcons` getter resolves. Non-default weights are reachable directly via `PhosphorIcons.<name>(PhosphorIconsStyle.<weight>)` — documented in the file header rather than gated by extra API surface (YAGNI; later migration phases will need per-call-site weight control anyway).
- Bespoke `feature-icons.tsx` icons ported: **15** (`home`, `exams`, `dailyReview`, `vocabulary`, `notes`, `conversationHub`, `games`, `course`, `sentenceBuilder`, `listening`, `youtube`, `interview`, `news`, `affiliate`, `learn`). Task brief estimated "~20" — actual file only exports 15; ported all of them.
- No web Phosphor icon lacked a Flutter equivalent. One naming mismatch: `pictureInPicture` (web/expected camelCase) is `PhosphorIcons.pictureInpicture()` (lowercase "p") in `phosphor_flutter` 2.1.0 — handled with a comment; `AppPhosphorIcons.pictureInPicture` getter name kept camelCase for consistency with the rest of the class.

## Validation
- `phosphor_flutter: ^2.1.0` was already present in `pubspec.yaml` (added by the pubspec-owning agent) by the time I ran `flutter pub get`; resolved cleanly.
- `flutter analyze lib/core/icons/` → **No issues found**.
- Did not touch `pubspec.yaml`, `lib/core/theme/**`, `lib/navigation/**`, `lib/widgets/**`, `lib/shared/widgets/**`, or any screen files, per file-ownership constraints. No SVG assets added under `assets/icons/feature/` — used inline SVG strings instead, so no asset declarations are needed at all.

## Unresolved questions
- None blocking. Confirm with later migration-phase owner that `AppIcons`/`AppPhosphorIcons` naming (matching web export names) is the expected lookup convention before bulk-migrating ~205 files off Material Icons.

Status: DONE
Summary: Ported all 102 distinct web Phosphor icon names and all 15 bespoke feature-icons.tsx SVGs into `lib/core/icons/`; `flutter analyze` clean, no pubspec/asset changes required.
Concerns/Blockers: none
