# P12 Wave A — Settings Slice

Plan: `plans/260716-2324-web-mobile-ui-100-fidelity/phase-12-social-stats-settings-cleanup.md`
Scope: settings tree only (social/AI, stats/leaderboard = sibling agents, not touched).

## Status: DONE (per-screen table below), with named deviations

## Per-screen

| Screen | Status | Notes |
|---|---|---|
| `settings_screen.dart` (root) | DONE | Rebuilt: back+title+subtitle header, `ProfileEditCard` (avatar/name/email/premium/save), nav-rows card (6 entries: learning goals/appearance/notifications/security/[AI flag]/app-update), `SettingsAppOnlySection` (language+sound+About, keeper (c)), feedback row, red logout row + confirm dialog. |
| `security_screen.dart` | DONE | Added password-change card (`Supabase.updateUser`, matches web `useAuth().updatePassword`). Kept device list + delete-account (keeper (a), web has none — untouched per instructions). |
| `notification_preferences_screen.dart` | DONE | Added timezone line, "Gửi thử" (`POST /user/push/test`), OS-permission-denied banner (native substitute for web's browser-permission states — see Deviations). |
| `learning_preferences_screen.dart` | DONE | 5 goal chips, 4 minute presets (5/10/15/30) with computed XP/words preview, CEFR chips (was sliders), `ReviewDisplayCard` (3 new on-device toggles). |
| `settings-appearance` → `appearance_screen.dart` (NEW) | DONE | Dark-mode toggle (drives existing `AppTokens` themes) + sound/effects toggle. Route `/settings/appearance`. |
| `settings-app-update` → `app_update_screen.dart` (NEW) | DONE | Native adaptation: wraps existing `ForceUpdateService` check (web's action is a browser cache-clear, not portable). Route `/settings/app-update`. |
| `settings-ai-memory` → `ai_settings_page.dart` | ROUTE ONLY | Added `/settings/ai-memory` in `settings_routes.dart` pointing at the existing `AISettingsPage` (import only, zero edits to `lib/screens/ai/**` — owned by the social/AI agent right now). The page's own web-parity diff is out of my file ownership. |
| Announcements → `AnnouncementBanner` | DONE (widget only) | New `lib/widgets/announcements/announcement_banner.dart` + `simple_markdown_text.dart` + `lib/repositories/announcements/announcement_repository.dart`. **Wave B placement:** `AnnouncementBanner(page: 'dashboard')` into `home_screen.dart` right after `MobileDashboardHeader`/before the hero section; `AnnouncementBanner(page: 'exam')` near the top of `exam_screen.dart`'s catalog list. `announcements_page.dart` deletion stays wave B (not deleted here — out of my ownership). |

## Cross-agent coordination (profile-edit merge)

No `fullstack-developer-260717-0402-p12a-social-ai-profile-report.md` existed when I started. Built `ProfileEditCard` (`lib/screens/settings/widgets/profile_edit_card.dart`) against the existing `PUT /user/profile` contract (`displayName`/`avatarUrl`), backed by a **new, self-contained** `lib/view_models/settings/profile_edit_provider.dart` — deliberately does NOT import anything from `lib/screens/profile/**` (owned by the social agent, who is deleting `ProfileScreen`/`EditProfileScreen` concurrently) to avoid a cross-boundary dependency on files that may vanish mid-wave. Reads `myProfileProvider`/`authServiceProvider` from `view_models/providers.dart` only (pre-existing, stable). `EditProfileScreen` itself was left untouched (`lib/screens/profile/**` is off-limits) — its deletion is the social agent's responsibility per the plan.

## Notifier race fix (mandatory item)

Fixed in **two** places (same bug pattern):
- `lib/view_models/settings/learning_preferences_provider.dart` (the one named in the brief).
- `lib/view_models/notifications/notifications_provider.dart` `NotificationPreferencesNotifier` — identical `unawaited(_load())` pattern, directly feeds my rebuilt `notification_preferences_screen.dart`, so fixed it too (file isn't in my listed ownership but has no other owner and blocks correct behavior of a screen I own).

Fix: `unawaited(_load())` → `Future.microtask(_load)`. `unawaited` runs the async function body synchronously up to its first `await`; if the repository provider throws *synchronously* during construction (e.g. `ref.read(...)` fails before any `await`), the `catch` block's `state = ...` assignment executes before `build()` returns, and Riverpod throws "Tried to read the state of an uninitialized provider" instead of surfacing the real error. `Future.microtask` defers to the next microtask, guaranteeing `build()` always installs the initial state first.

Added regression tests: `test/view_models/settings/learning_preferences_provider_test.dart` (sync-throw + async-throw cases, both green). The old test workaround (`test/screens/exam/exam_catalog_localization_test.dart` overriding `learningPreferencesProvider` with a fixed notifier) was left in place — it's a legitimate widget-test isolation pattern (avoids a real Supabase-backed provider in a pure-UI test), not a race-avoidance hack; not owned by me anyway (`lib/screens/exam/**`).

## New contracts (probed + documented)

`docs/flutter-api-contract-matrix.md` + `docs/api-changelog.md` updated (new "Settings, notifications, announcements" section) before writing UI:
- `GET /announcements?page=&public_only=` — curl-verified live (`[]` on prod, confirms shape).
- `POST /user/push/test` — read from Go handler (`webhttp/webpush_handler.go`), pre-existing/unused route.
- `PUT /user/preferences` now also sends `learning_goals: string[]` — pre-existing backend field (`UpdatePreferencesInput.LearningGoals`), previously never sent by Flutter. Repository/test updated (`lib/repositories/settings/learning_preferences_repository.dart`, `test/repositories/learning_preferences_repository_test.dart`).

## l10n

37 new keys added to `app_{vi,en,de}.arb` (3-way parity verified via key-set diff = empty), `flutter gen-l10n` run last. No hardcoded new UI strings. German 200%-scale smoke test added (`test/screens/settings/settings_german_text_scale_test.dart`, 6 screens) — caught and fixed a real overflow (unwrapped `Text` header titles vs. `Expanded`) across all 5 rebuilt/new settings screens before landing.

## Deviations / native substitutions (documented in code comments too)

1. **Notification permission banners**: web has iOS-Safari-not-installed / browser-denied banners (no mobile-app equivalent). Built a native substitute: OS notification-permission-denied banner via the existing `NotificationServiceWrapper.hasPermission()`, wrapped in try/catch (platform channel is unavailable in widget tests — degrades to "unknown", banner hidden, never crashes).
2. **Timezone**: no IANA-timezone-detection package in `pubspec.yaml` (not added — out of scope, `pubspec.yaml` is DO NOT TOUCH). Shows the backend-saved `timezone` string if present, else a `UTC±HH:MM` offset computed from `DateTime.now().timeZoneOffset`.
3. **App-only keepers (language/sound/About)**: kept per Quyết định #3, restyled to the web nav-row/toggle visual language via `context.tokens` (no more `DesignTokens` statics in any file I touched). Sound settings moved from an inline root section to a bottom sheet (`SoundSettingsSheet`) to avoid adding an extra unlisted route.
4. **Review-display toggles**: new on-device (`SharedPreferences`) provider `lib/view_models/settings/review_display_prefs_provider.dart` with 3 documented keys (`reviewDisplay.autoAdvance/show4Button/showContext`). The daily-review screen that should *consume* these three keys is out of my ownership (`lib/screens/journey/**`/`lib/features/daily_path/**`) — doc comment on the provider tells whichever phase builds/owns that screen to read the same keys rather than re-inventing storage.
5. **Announcement markdown**: `lib/widgets/announcements/simple_markdown_text.dart` supports bold/italic/links/newlines only (not heading/`{color:x}` spans — real markdown parity would need a package; announcement content is short blurbs in practice). Flutter `Text.rich` never interprets input as HTML, so this has no XSS surface unlike web's `dangerouslySetInnerHTML` (which needed `DOMPurify`).

## Files touched

**New:**
- `lib/screens/settings/appearance_screen.dart`, `app_update_screen.dart`
- `lib/screens/settings/widgets/profile_edit_card.dart`, `settings_app_only_section.dart`, `sound_settings_sheet.dart`, `security_form_cards.dart`, `review_display_card.dart`
- `lib/view_models/settings/profile_edit_provider.dart`, `review_display_prefs_provider.dart`
- `lib/repositories/announcements/announcement_repository.dart`
- `lib/widgets/announcements/announcement_banner.dart`, `simple_markdown_text.dart`
- `test/view_models/settings/learning_preferences_provider_test.dart`
- `test/screens/settings/settings_german_text_scale_test.dart`

**Modified:**
- `lib/screens/settings/{settings_screen,security_screen,notification_preferences_screen,learning_preferences_screen}.dart`
- `lib/screens/settings/widgets/{settings_tiles,language_picker_sheet}.dart`
- `lib/navigation/routes/settings_routes.dart` (added `appearance`/`app-update`/`ai-memory`)
- `lib/repositories/settings/learning_preferences_repository.dart` (+`learning_goals`)
- `lib/view_models/settings/learning_preferences_provider.dart`, `lib/view_models/notifications/notifications_provider.dart` (race fix)
- `lib/l10n/app_{vi,en,de}.arb` + generated `app_localizations*.dart`
- `docs/flutter-api-contract-matrix.md`, `docs/api-changelog.md`
- `test/structure/release_live_data_guard_test.dart` (added all new/kept settings-tree files)
- `test/screens/settings/{notification_preferences_screen_test,settings_release_gates_test}.dart` (updated to new design, not weakened)

**Not touched (per DO NOT TOUCH):** `lib/screens/{social,ai,duel,profile,stats,home,exam}/**`, `lib/core/**`, `lib/widgets/common/**`, `lib/shared/widgets/**`, `pubspec.yaml`, other route files, `lib/navigation/release_redirect.dart`.

## Tests status

- `flutter analyze`: 0 errors in any file I touched. (Pre-existing errors elsewhere — `writingHubTab*`/`writingCommunity*` missing l10n getters in `lib/features/writing/**`, and an `dashboardProvider` ambiguous-import in `test/screens/stats/stats_screen_test.dart` — are in other phases' active files, confirmed unrelated: the writing l10n keys were never in the ARB at all, and I never touched `dashboardProvider`. Not mine to fix per protocol.)
- `flutter test` green: `test/screens/settings/**` (7 files), `test/screens/notifications/**`, `test/view_models/settings/**`, `test/repositories/learning_preferences_repository_test.dart`, `test/structure/release_live_data_guard_test.dart`, `test/l10n/app_localizations_test.dart`.

## Unresolved questions

1. Notification "content-mode" chips and toggle currently persist via the existing preference row (no FCM subscribe/unsubscribe flow on mobile yet — matches the pre-existing doc-comment on `notification_preferences_screen.dart`). Wave B/whoever wires FCM should also wire the enable-toggle to an actual subscribe call.
2. `AppUpdateScreen`'s native "check now" reuses `ForceUpdateService` (store-version gate); web's `/reset` (clear cache + reload) has no meaningful native analog — flagged as an intentional non-parity, not a gap.

Status: DONE
Summary: Rebuilt settings root/security/notifications/learning-preferences to web IA + tokens, added appearance/app-update pages, wired `/settings/ai-memory` route, built the reusable AnnouncementBanner (placement documented for wave B), fixed the notifier race in both affected providers, and closed all new-string/contract/guard/test protocol items.
Concerns/Blockers: none blocking; see Unresolved questions above.
