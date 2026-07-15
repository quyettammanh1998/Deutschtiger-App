---
phase: 2
title: Accessibility Localization and Device Scope
status: in-progress
priority: P1
effort: 1–2w
dependencies: []
---

# Phase 2: Accessibility Localization and Device Scope

## Overview

Turn the current partial locale map and visual mobile port into an accessible,
deliberately scoped product. Vietnamese, English and German are already exposed
as `AppLocale`; their supported behavior must be real or the option removed.

## Requirements

- Adopt Flutter's generated localization flow (`flutter_localizations`, `intl`,
  `l10n.yaml`, ARB catalogs) and route all product UI strings through it.
- Define semantic labels, focus order, target sizes, contrast and screen-reader
  behavior for shared widgets and critical journeys; German learning content is
  not translated unless it is UI chrome.
- Preserve GĐ1 iPhone/portrait scope. Before GĐ2, explicitly decide either
  continue phone-only or fund tablet/landscape layouts and add their test matrix.

## Architecture

```text
ARB source catalogs → generated AppLocalizations → UI strings / plural/date/number
                                           ↓
                                     locale preference persistence

Shared widgets → semantics/focus/size/contrast contracts → widget + device a11y tests
```

## Progress (2026-07-15)

- Generated ARB localization (`vi`, `en`, `de`) replaces the legacy static
  locale map. The app root, global bottom navigation/offline banner, More
  Features sheet, Settings chrome, and Security & Devices route now resolve
  through `AppLocalizations`, and language selection persists without an
  initial-load race overwriting a newer user choice.
- The language picker and More Features tiles have explicit semantic state or
  names, with 200% text-scale widget coverage. The documented device scope
  remains phone portrait for GĐ1/GĐ2.
- More Features now reflows from three columns at default text size to two
  columns from 130% scaling upward. Its phone-viewport German 200% test covers
  the long deck and vocabulary-library labels without `ellipsis` clipping;
  scrolling remains the overflow mechanism.
- Settings now uses `Ink` for cards containing interactive `ListTile`s, so the
  Material splash is visible rather than hidden behind a decorated container.
  Its default release surface omits unmounted password/email actions and the
  unverified AI settings entry, while preserving Feedback.
- Security error feedback no longer forwards raw API error text to the user;
  it uses a localized recoverable message instead.
- Profile chrome, edit form, avatar field, error state, Premium badge and stat
  labels now resolve through ARB. The stat grid increases its row height at
  larger text scales; German 200% widget coverage exercises that reflow. Its
  account-deletion entry point leads only to the localized support-directed path
  while the backend lifecycle is unavailable.
- The support-directed account-deletion screen now scrolls instead of
  overflowing when its honest German 200% explanation exceeds a 360×640 phone
  viewport. The semantic support CTA remains reachable and no destructive
  success state is introduced.
- iOS microphone permission has native Vietnamese, German and English
  `InfoPlist.strings` resources. Each description matches the current local
  temporary-recording implementation rather than claiming unimplemented
  server-side AI grading; the Runner target declares all three locales in its
  Xcode `knownRegions` metadata.
- The current Home dashboard chrome now uses generated localization: fallback/
  error, search, missions, Quick Actions, greeting, stats, leaderboard and
  daily-path CTA. German widget/unit coverage verifies action labels, greeting
  and elapsed-time formatting. Legacy dashboard widgets that are not rendered
  by the current Home route remain a separate migration audit.
- The mounted Home stats card now exposes each localized statistic as one
  screen-reader summary. Its streak and optional details affordances expose
  labeled button actions, with German 200% coverage proving both callbacks and
  elapsed-time labels still work without changing dashboard data behavior.
- The mounted Home header now gives Profile and Settings localized semantic
  button names and 48px hit targets while preserving their 36px visual
  controls. Its gated Messages control uses the same generated locale key for
  future enabled-feature QA.
- The release-visible Leaderboard now labels only its verified weekly and
  cumulative all-time scopes. Its selector has semantic button/selected state,
  and its error/empty/tile chrome resolves through ARB; a German 200% tile
  test covers fallback-user and streak reflow.
- The release-visible Deck list now localizes its live CRUD chrome, including
  tooltips, error/empty states, card progress, menus, delete confirmation and
  create/edit form. A German 200% widget test exercises a fetched deck without
  translating learner-created deck names or descriptions.
- Daily Review now localizes its start/retry/empty/FSRS control chrome. Its
  rating controls use two columns at large text scales rather than compressing
  four choices into a narrow row; German 200% tests cover the start summary and
  each revealed-answer choice. Server-owned FSRS grading remains unchanged.
- The main Vocabulary library now localizes its title, generic error state,
  aggregate counts, goal/level/topic selector, seven static learning goals and
  CEFR labels. Its selector exposes selected button semantics and wraps labels
  rather than clipping them at large text scales; API-delivered vocabulary data
  stays untouched. German singular/plural CEFR formatting and a 200% route test
  cover the migration.
- Vocabulary lesson and word-detail routes now keep the selected locale through
  lesson title/error/empty/search/filter/progress states, word headings,
  navigation controls and detail tooltip. Their provider/data content remains
  unmodified; German 200% tests cover both screens with real model shapes.
- Vocabulary detail now localizes card-flip semantics, grammar metadata,
  meanings, examples, related words, conjugation and practice chrome without
  translating the vocabulary payload. Its optional practice CTAs remain hidden
  unless the existing games release flag is enabled; 200% German tests cover
  both flag states. Existing direct widget hosts now install the generated
  localization delegates, matching the production app root.
- My Words now localizes its live-data title, filters, count, empty/error and
  retry states. The filter enum retains its backend values while its display
  labels use ARB; the selector can scroll horizontally at large text scales,
  and German 200% plus raw-error containment tests cover the route.
- Deck detail now localizes its live card-list title, due-review CTA and empty
  state. Its card provider is named/exported solely to allow widget tests to
  inject the production `DeckWord` shape; endpoint behavior and review
  navigation are unchanged. German 200% tests cover populated and empty decks.
- Flashcard Review now uses the generated locale for its title, load/save
  error, empty state, reveal prompt, audio tooltip and four FSRS rating labels.
  The client still submits the same numeric rating values; internal error text
  is not exposed. German 200% widget tests cover the interactive card chrome.
- The release-visible Exam catalog now localizes its title, generic load error,
  filter, empty state, question/duration metadata and practice/mock-exam CTAs.
  Catalog titles, provider/level tags and exam navigation remain backend data.
  A German 200% test covers a catalog item with its supported part shape.
- Exam Practice now uses ARB for bootstrap loading/error, question palette,
  close control, question progress and navigation controls. Bootstrap failures
  use a generic localized message rather than exposing provider detail; timer,
  autosave and attempt contracts remain unchanged.
- Exam Practice exit/submit confirmations now localize their safety copy and
  actions. German 200% tests prove the existing exit/submit boolean decisions
  remain intact.
- Exam audio playback now shows a generic localized failure message rather than
  leaking a `just_audio` exception. Playback quota and player-state behavior
  remain unchanged; catalog coverage verifies the German message and a source
  guard verifies no exception text is interpolated into the snackbar.
- Exam audio chrome now localizes the listening title, quota counter and quota
  warning. The icon-only play/pause control exposes a localized semantic action;
  its German 200% widget test keeps the existing playback callback intact.
- Exam Results now localizes its summary, outcome, section analysis and actions,
  while errors use generic localized copy instead of provider detail. A German
  200% test also found and fixed the fixed-size score ring overflowing vertically.
- Exam question chrome now localizes answer status, question badge, matching
  instructions/removal tooltip and gap labels without translating German source
  content. The shared badges wrap on narrow devices, preventing the localized
  question label from overflowing renderer tests.
- The release Learn hub now exposes only the server-backed daily mission rather
  than mounting fixture-backed journey chapters/progress. Its mission title,
  retry, progress summary and start/completed CTA resolve through ARB; roadmap
  routes remain separately feature-gated pending a live source.
- The live mission-session runner now localizes its load/empty states, word
  introduction, recall controls and correct/incorrect feedback without
  translating server-provided German/Vietnamese learning content. A German
  200% widget test covers those controls across the intro, recall and feedback
  states, plus the shared completion-card defaults used by mission and review
  flows. Its score row expands and wraps its labels at larger text scales.
- Mission persistence failures are stored as locale-neutral state codes and
  resolved in the UI, so a failed round or final completion cannot revert the
  selected locale to a hard-coded Vietnamese message. Provider coverage keeps
  the retry state and error code explicit.
- The shared FSRS provider now uses the same locale-neutral failure pattern
  for Daily Review and Flashcard Review. A German 200% error-state test found
  and fixed a 52px bottom overflow: the review surface preserves its spaced
  layout when it fits and becomes scrollable when error copy and rating choices
  need more height.
- The shared `ErrorView` now derives both its default recovery copy and retry
  action from ARB, so a caller that does not supply a route-specific message
  cannot silently fall back to Vietnamese. German 200% coverage protects the
  reusable error surface.
- `SaveCardButton` now localizes its labels, snackbars and deck picker while
  preserving learner-owned deck names. Its star variant describes quick-save
  accurately. A German 200% deck-picker test found and fixed a 63px bottom
  overflow by making the sheet content scrollable.
- Word Lookup now localizes lookup states, headings and sentence-save feedback
  without translating dictionary payloads. Its existing persistence test now
  runs German UI chrome at 200% while asserting the same Vietnamese/German
  sentence payload reaches the API.
- The root-navigator device-kicked dialog now localizes its forced-sign-out
  recovery copy and CTA. German 200% coverage confirms acknowledgement still
  reaches the existing sign-out/navigation callback.
- Login and Sign-up now render a localized generic auth-failure message rather
  than raw provider errors. Social-login button loading follows the actual
  OAuth Future rather than an arbitrary client timer.
- Welcome, Onboarding, Login, Sign-up, Forgot Password and Reset Password
  chrome now resolves through the generated `vi`/`en`/`de` catalogs. Validation
  errors receive the active locale; the Profile caller uses the same validator
  contract. Auth links use accessible `TextButton` controls, and the Welcome
  and Reset Password routes have 200% text-scale/German widget coverage.
  Forgot/Reset Password keep provider error details out of the UI.
- Onboarding slide content now preserves centered presentation when it fits and
  becomes scrollable when enlarged copy exceeds a short phone viewport. German
  200% coverage at 360×640 keeps Skip, the first slide title and Continue
  reachable without a RenderFlex overflow.
- This is a foundation, not a complete locale/a11y migration: enabled routes
  still contain UI literals and require route-by-route ARB/semantics work plus
  device screen-reader smoke evidence before Phase 2 can close.
- The phone-only/portrait scope is now protected by a CI source test for the
  Android manifest and iOS target family. The current environment has no
  Android/iOS device or emulator connected, so this guard does not replace the
  pending TalkBack, VoiceOver or physical-fidelity evidence.

## Related Code Files

- Replace/migrate: `lib/l10n/i18n_service.dart`; review/delete obsolete direct string maps after migration
- Modify: `lib/main.dart`, app theme, settings language preferences, shared widgets and all enabled route surfaces
- Create: `l10n.yaml`, `lib/l10n/app_{vi,en,de}.arb`, localization tests and accessibility test helpers
- Modify: Android/iOS device/orientation config only after documented scope decision
- Create: `docs/flutter-accessibility-and-localization.md` and device support matrix

## Implementation Steps

1. Inventory every user-facing literal on enabled routes and define source
   locale/fallback. Convert UI chrome to ARB; preserve German source examples,
   answers and user content as data rather than translating them.
2. Replace the static notifier with persisted locale preference, generated
   delegates and locale-aware plural/date/number formatting. Test switching
   `vi`, `en`, `de`, process restart and missing-key failure in development.
3. Establish accessibility contracts: semantic name/role/state for buttons,
   images, charts, timers, player controls and question options; keyboard/focus
   traversal; minimum tap target; contrast; reduced-motion behavior.
4. Add widget and device tests at text scales 1.0, 1.3 and 2.0, plus TalkBack
   and VoiceOver smoke paths for login, review rating, exam answer/submit,
   account deletion and purchase/restore.
5. Record GĐ2 device decision. If phone-only continues, enforce and disclose it
   consistently; if tablet/landscape is approved, add responsive layouts,
   fidelity baselines and physical-device coverage before exposing iPad/tablet.
6. Fix discovered hard-coded strings/a11y failures in shared components first,
   then route-by-route; do not hide overflowing text with clipping/ellipsis
   where the value is essential to a learning or exam task.

## Success Criteria

- [ ] All enabled UI chrome resolves through generated localization for the
  declared locales, including plural/date/number cases and persisted selection.
- [ ] Critical flows are operable at 200% text scale with no hidden primary
  action or unreachable exam answer.
- [ ] Widget semantics/focus tests and physical TalkBack/VoiceOver smoke tests
  pass for the defined critical journeys.
- [ ] Device support matrix and iPhone-only/tablet decision match Xcode,
  Android manifest, screenshots and store metadata.

## Risk Assessment

- A global string replacement can corrupt German learning content. Separate UI
  resources from learner data and use tests to preserve content payloads.
- Pixel parity alone conflicts with large text if treated as absolute geometry;
  accessibility behavior takes priority, with intentional fidelity exceptions
  recorded in the screenshot report.
