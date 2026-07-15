# Flutter Accessibility and Localization Scope

## Overview

Flutter localization uses generated ARB catalogs under `lib/l10n/`. The app
declares Vietnamese (`vi`), English (`en`), and German (`de`) UI locales. The
preference is persisted through `PreferencesNotifier`; `DeutschTigerApp` passes
it to `MaterialApp.router` with generated localization delegates.

## Localization boundary

- UI chrome must use `AppLocalizations`; do not put new product strings in
  static maps or feature-local dictionaries.
- Native iOS permission prompts use localized `InfoPlist.strings` resources,
  registered in the Runner target. Keep them aligned with the same supported
  `vi`, `de`, and `en` locales and with the inspected platform behavior.
- German examples, questions, answers, translations requested by a learner, and
  other learning content are data. They are not automatically translated by the
  UI locale.
- The root app and Settings/language picker are migrated and covered by
  `test/l10n/app_localizations_test.dart`.
- Remaining screens contain legacy literals and must be migrated route by route
  before the three-locale claim is made for the entire product.

## Accessibility contract

- Shared controls need a semantic label/name, role, selected/disabled state,
  visible focus behavior where keyboard input exists, and a touch target at
  least 48 logical pixels where practical.
- Never hide a primary action, exam option, or learning result by clipping text
  at larger scales. Reflow and scrolling take priority over fixed screenshot
  geometry.
- The language picker exposes a labeled semantic container and selected state;
  the widget test exercises it at a 2.0 text scale.
- Manual device smoke paths remain required for TalkBack/VoiceOver: sign-in,
  review rating, exam answer/submit, account deletion, and purchase/restore.

## Device support matrix

| Release scope | iOS | Android | Orientation | Evidence |
|---|---|---|---|---|
| GĐ1 | iPhone only | Phone | Portrait | `TARGETED_DEVICE_FAMILY = 1` in `ios/Runner.xcodeproj/project.pbxproj`; `android:screenOrientation="portrait"` in the main manifest. |
| GĐ2 current decision | Continue phone-only | Continue phone-only | Portrait | No tablet/landscape layout, screenshot, accessibility, or store-metadata coverage exists yet. |

Do not change iOS target family or remove Android portrait lock until the GĐ2
decision is explicitly approved and tablet/landscape layouts, fidelity
baselines, physical-device tests, and store metadata are supplied.

`test/config/device_scope_test.dart` is the CI source guard for this decision:
it requires the Android portrait lock and iOS `TARGETED_DEVICE_FAMILY = 1`.
It is not a substitute for physical-device accessibility or fidelity evidence.

## Verification

```bash
flutter gen-l10n
flutter test test/l10n/app_localizations_test.dart
flutter analyze
```

Run these with the local backend healthy, as required by the project workflow.
At the last environment check (2026-07-15), the app launched successfully on
the `Pixel6_API34` Android emulator at its native 1080×2400 portrait viewport
and rendered the Vietnamese welcome screen without visible clipping or overlap.
This is launch/screen evidence only: TalkBack, iOS/VoiceOver, authenticated
flows, and platform-provider smoke paths remain pending.

## References

- `l10n.yaml`
- `lib/app.dart`
- `plans/260715-flutter-cross-cutting-readiness/phase-02-accessibility-localization-and-device-scope.md`
