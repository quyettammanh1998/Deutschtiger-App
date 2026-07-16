# Phase 01 workstream F — bottom nav + more-features sheet rebuild

Plan: `plans/260716-2324-web-mobile-ui-100-fidelity/phase-01-foundation-tokens-fonts-icons-shell.md` §7+§8.

## Files

New:
- `lib/widgets/common/nav/nav_tab_accents.dart` — per-tab accent color table (amber/indigo/emerald/teal + AI blue + shared inactive slate), documented, exact Tailwind hex.
- `lib/widgets/common/nav/nav_hamburger_icon.dart` — 3-line "Thêm" glyph (CustomPainter, ported from web SVG path data).
- `lib/widgets/common/nav/app_bottom_nav.dart` — custom bottom nav widget (`AppBottomNav`/`AppBottomNavTab`), replaces Material `BottomNavigationBar`.
- `lib/shared/widgets/more_features/more_features_catalog.dart` — data model + the 4 web groups + app-only AI exception item.
- `lib/shared/widgets/more_features/more_features_tile.dart` — 44px pastel tile, disabled/dimmed state.
- `lib/shared/widgets/more_features/more_features_dialog.dart` — centered scale-in dialog (title bar + grid).
- `test/widgets/common/app_shell_test.dart` — 7 tests (5-tab render, per-tab pill colors, "Thêm" never colored + opens dialog not branch nav, light/dark inactive-color regression guard, `appShellTabs` shape).

Modified:
- `lib/widgets/common/app_shell.dart` — rewritten to build `AppBottomNav` + `AppBottomNavTab` list; fixed the light/dark inactive-color ternary bug (was returning the same value both branches); tab-4 release switch on `ReleaseFeatureFlags.speaking`.
- `lib/shared/widgets/more_features_sheet.dart` — reduced to a 12-line facade (`MoreFeaturesSheet.show` → `MoreFeaturesDialog.show`), public API unchanged so `app_shell.dart`'s call site didn't need touching.
- `lib/navigation/app_router.dart` — branch 3 of the shell now swaps `conversationShellRoutes`/`aiShellRoutes` on `ReleaseFeatureFlags.speaking` (compile-time, no runtime cost).
- `lib/navigation/routes/speech_routes.dart` — added `conversationShellRoutes` (`/conversation` → `ConversationHubPage`, already existed at `/speaking/conversation-hub`).
- `lib/navigation/release_redirect.dart` — `/conversation` redirects to `/ai` when `speaking` is off (deep-link safety net, mirrors the existing `/speaking` gate pattern).
- `lib/l10n/app_{vi,en,de}.arb` (+ regenerated `app_localizations*.dart` via `flutter gen-l10n`) — `moreFeaturesTitle` now "Tất cả tính năng"/"All features"/"Alle Funktionen" (was the old bottom-sheet title); +26 new keys (`navConversation`, `groupAccountOther`, `feature*`).
- `test/features/home/release_navigation_gates_test.dart` — tab-4 test now asserts on `speaking` flag / label instead of the removed `aiTutor`-gates-branch-existence assumption (tab 4 always exists now, content swaps).
- `test/l10n/app_localizations_test.dart` — the two `MoreFeaturesSheet(onClose:...)` widget tests rewritten against the new `MoreFeaturesSheet.show(context)` dialog API and new catalog content; removed now-unused `_noop`.

## Implementation notes

**Bottom nav**: 64px, `background@95%` + `BackdropFilter` blur, border-top only (no shadow), 5 `flex-1` slots, 44px icon pill (active only), 20px icon, 10px/w600 label both states (no grow-on-select). Per-tab accents pinned in `nav_tab_accents.dart` (not `AppTokens` — these are tailwind-hardcoded on web, not semantic). Fixed the pre-existing light/dark ternary bug at the old `app_shell.dart:60-62`.

**Tab 4 release gate**: `ReleaseFeatureFlags.speaking` (existing flag, `defaultValue: false`, already gates `/speaking/*` in `release_redirect.dart`) is the single switch. When on: tab 4 = "Hội thoại" (teal accent, `AppIcons.conversationHub`, routes `conversationShellRoutes` → `/conversation` → `ConversationHubPage`). When off (current default): tab 4 = "AI" (existing behavior, `Icons.smart_toy_rounded`, blue accent, `aiShellRoutes` → `/ai`). Branch index stays 3 either way so `AppShell`'s branch-based active-tab lookup needs no change. **P10 flips this by setting `ReleaseFeatureFlags.speaking` true** — no other code change needed; both `app_shell.dart` and `app_router.dart` carry "TAB-4 RELEASE SWITCH" comments pointing at each other.

**More-features dialog**: `showGeneralDialog` (not `DraggableScrollableSheet`), rounded-2xl, max-width 512, `Colors.black@40%` backdrop, scale+fade transition, bordered title row + X (Phosphor bold), 4-col fixed grid (not responsive — matches web's fixed `grid-cols-4`), emoji+uppercase group labels, 44px `rounded-2xl` pastel tiles, `line-clamp-2` labels via `maxLines:2/ellipsis`.

**Catalog gating**: items with no Flutter destination yet (readListenHub/"Đọc & Nghe", pronunciationMinimalPairs/"Cặp âm dễ nhầm", courseInterview/"Phỏng vấn", admin/"Quản trị") render dimmed+non-interactive (`enabled: false`, `path: null`) instead of routing anywhere — no mock screens invented. Items with a live route reuse the *specific* existing flag (`casesMastery`, `konjugation`, `practice`, `social`, `stats`, `affiliate`, `premium`, `aiTutor`, etc.) rather than the coarser `ReleaseFeatureFlags.allowsMoreFeature` switch, since that switch doesn't cover several of the subpaths used here (e.g. `/listening/youtube`, `/games/cases`).

**AI app-only exception**: added "Trợ lý AI" tile in group 4 (`ReleaseFeatureFlags.aiTutor` gated, routes `/ai-tutor/chat`), clearly commented in `more_features_catalog.dart` as the approved deviation from the web catalog (which has no AI tile).

**Icon gaps found**: `AppIcons` had no hamburger glyph (web's 3-line "Thêm" icon isn't a Phosphor "list" either — that renders with bullet dots) → implemented `NavHamburgerIcon` as a local `CustomPainter` in `lib/widgets/common/nav/` (kept out of `lib/core/icons/` per file-ownership boundary). A handful of more-sheet items also have no 1:1 bespoke/Phosphor match to the exact web SVG (cases/konjugation/messages/examSchedule/dailyQuote/admin/leaderboard) — used the closest semantically-reasonable Phosphor icon from `phosphoricons_flutter` directly (`PhosphorIcons.bookOpen`/`target`/`calendarCheck`/`quotes`) or `AppPhosphorIcons` where already listed there.

**Mid-task package swap**: coordinator swapped `phosphor_flutter` → `phosphoricons_flutter` (callable `PhosphorIcons.x()` → const `IconData PhosphorIcons.x`) while I was mid-implementation. Updated all my `PhosphorIcons.bookOpen()`/`.target()`/`.calendarCheck()`/`.quotes()`/`.x(bold)` call sites to the new non-callable API (`PhosphorIcons.bookOpen`, `PhosphorIcons.xBold`, etc.) after the swap landed; did not touch `pubspec.yaml` or `lib/core/icons/**`.

**Known structural gap (not fixed here, pre-existing)**: web highlights "Học" active also on `/daily-review`/`/vocabulary`. In this Flutter app those are top-level routes outside the shell's `StatefulShellRoute`, so the bottom nav isn't even shown there — `matchExtra`-style active-tab matching has no route-based hook to attach to without moving those routes into the learn branch (`vocabulary_routes.dart`, not owned by this phase). Flagging for whichever phase later restructures those routes.

**Test-writing gotcha discovered**: pumping two different `MaterialApp(themeMode: ...)` widget trees back-to-back in the same `testWidgets` body can leave `Theme.of(context)` stale (observed with light→dark) — worked around with `pumpWidget(const SizedBox())` between pumps to force a full unmount/remount. Worth knowing for other widget tests in this codebase that toggle theme mid-test.

## Tests

- `flutter analyze` → 0 errors (5 pre-existing infos, unrelated files).
- `flutter test test/structure/ test/l10n/ test/features/home/ test/widgets/` → 116/116 pass.
- `flutter test test/screens/ai/ai_chat_page_test.dart test/screens/exam/exam_catalog_localization_test.dart` → now pass too (were pre-existing failures per the brief; already fixed by another agent, not touched here).
- `release_live_data_guard_test.dart` untouched/still passes — no release-visible screen entries added/removed.

## Unresolved questions

1. None blocking. The "Học" active-tab-on-`/daily-review`/`/vocabulary` gap above is a pre-existing routing-structure limitation, not something this phase's file ownership can fix.
2. Confirm with P10 owner: `ReleaseFeatureFlags.speaking` is the correct single switch for tab-4 parity (it already gates the whole `/speaking/*` family including `conversation-hub` in `release_redirect.dart`), rather than introducing a narrower flag — went with reusing the existing one per YAGNI/DRY.

Status: DONE
Summary: Bottom nav rebuilt as a custom 64px web-parity widget (per-tab pastel accents, hamburger "Thêm"); more-features sheet rebuilt as a centered dialog with the web's 4-group catalog + one app-only AI tile; tab-4 gated behind `ReleaseFeatureFlags.speaking` with matching `/conversation` redirect; light/dark inactive-color bug fixed; all required suites green.
Concerns/Blockers: none.
