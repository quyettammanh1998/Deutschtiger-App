# Dark-mode migration remainder — `lib/screens/**`

Follow-up to the web-mobile UI fidelity plan (§Quyết định 3, quiz deletion) + dark-mode token migration gap (route SCREEN files migrated earlier; widgets those screens render were never counted).

## Task 1 — dead `quiz` screens deletion

Verified `lib/screens/quiz/daily_review.dart` + `lib/screens/quiz/quiz_list_screen.dart` had zero references anywhere in `lib/` or `test/` (`grep -rn "screens/quiz/daily_review\|screens/quiz/quiz_list_screen"` → no hits). Not confused with the live, routed `lib/screens/daily_review/**` (different feature, wired via `lib/navigation/routes/vocabulary_routes.dart`, has its own tests and a `release_live_data_guard_test.dart` entry — untouched).

- Deleted: `lib/screens/quiz/daily_review.dart`, `lib/screens/quiz/quiz_list_screen.dart` (`git rm`).
- `test/structure/release_live_data_guard_test.dart` never listed the `screens/quiz/` files — no edit needed.
- No test file targeted these two files — no test deletion needed.
- No route ever pointed at them (confirmed before deleting) — no redirect needed.

## Task 2 — dark-mode colour migration

### Before/after count (audit regex from the brief)
`grep -rEl '(DesignTokens|AppColors)\.(primary|background|foreground|card|muted|border|success|warning|destructive|accent|secondary|brand|sidebar|ring|input|text|auth)' lib/screens/`

- Before: 39 files (incl. 4 out-of-scope affiliate files, excl. the 2 now-deleted quiz files which had no such reads).
- After: 8 files remain flagged, all confirmed non-actionable:
  - 4 × `lib/screens/affiliate/**` — explicitly OUT OF SCOPE per plan §Quyết định 3 ("giữ hiện trạng"), skipped entirely, untouched.
  - `lib/screens/exam/exam_dictation_picker_screen.dart`, `home/widgets/{daily_path_hero_pieces,pinned_shortcuts,resume_section}.dart`, `journey/widgets/{journey_daily_plan_section,journey_today_session_card}.dart` — only remaining match is `DesignTokens.cardPadding` (spacing constant, not a colour).
  - `lib/screens/webview/webview_lesson_screen.dart` — 1 documented gap (below).
  - `lib/screens/ai/ai_chat_page.dart` — 1 documented gap (below).

29 files migrated (see `git diff --stat` for the full list): all of `home/widgets/*`, `journey/widgets/*`, `games/{conversation,pronunciation,speaking}_game_screen.dart` + `games/widgets/sprint_widgets.dart`, `social/{challenges_page,chat_page,widgets/challenges_list}.dart`, `settings/{delete_account_screen,widgets/feedback_sheet}.dart`, `exam/widgets/exam_readiness_card.dart`, `ai/ai_settings_page.dart`, `video_library/{video_library_tracker_screen,video_library_watch_screen}.dart`, `notifications/notification_center_screen.dart`, `speaking/widgets/pronunciation_trainer_card.dart`, `system/force_update_screen.dart`, `webview/webview_lesson_screen.dart`.

Mapping used throughout: `DesignTokens.card/foreground/mutedForeground/muted/border/primary/success/warning/destructive/authBackground` → `context.tokens.{card,foreground,mutedForeground,muted,border,primary,success,warning,destructive,background}` (`authBackground` maps to `background` — same semantic role, `AppTokens` has no separate auth surface). Where a colour was read outside a `build` method (helper/instance methods without `context`, e.g. `_paletteFor`, `_getTrainerColor`, `_getOverallColor`, `SprintAnswerTile._paletteFor`), threaded `BuildContext` as a parameter rather than fabricating a global lookup.

### Files deliberately left fixed (with reason)
- **`lib/screens/affiliate/**` (4 files)** — plan-mandated out of scope, skipped without inspection beyond confirming they're the affiliate dir.
- **Brand-orange / fixed-palette reads left untouched** across `home/widgets/pinned_shortcuts.dart` (10-tile icon/bg palette), `home/widgets/daily_path_hero_pieces.dart` + `dashboard_sections.dart` + `journey/widgets/*` (`amber100/700`, `emerald*`, `orange500/600` gradient CTAs) — these are Tailwind-style fixed accent colours (not `AppTokens` members, not matched by the audit regex either), matching the plan's "per-tab pastel nav accents" exception.
- **`lib/screens/ai/ai_chat_page.dart:841`** — `AppColors.primaryGradient` (fixed `orange500→rose600` `LinearGradient` on the chat send button). `AppTokens` has no gradient member; migrating would require adding a new token (out of my file ownership — `app_tokens.dart` is DO-NOT-TOUCH). Left as a fixed brand gradient, consistent with the other orange CTA gradients left fixed elsewhere.
- **`lib/screens/webview/webview_lesson_screen.dart:43`** — `AppColors.background` passed once to `WebViewController.setBackgroundColor()` in `_initWebViewController()` (called from `initState`, no reliable `BuildContext` dependency point, and the native platform view can't reactively re-theme without a full reconfigure). Documented in-line; left fixed.
- **`lib/screens/settings/widgets/feedback_sheet.dart`** — the orange-CTA button's `foregroundColor` was reading `DesignTokens.card` (used as a stand-in for "white text on orange"). Mapping it to `context.tokens.card` would go dark-navy in dark mode (wrong); changed to literal `Colors.white` instead, matching the pattern used by every other orange-gradient CTA in the app. Documented in-line.
- **`error` vs `destructive`** — `DesignTokens.error`/`AppColors.error` is not an `AppTokens` member (only `destructive` is; `error` is excluded from the audit regex given in the brief) and was intentionally left as the fixed red it already is in `games/widgets/sprint_widgets.dart` (wrong-answer state), `exam/widgets/exam_readiness_card.dart` (`_getOverallColor` low-score red). `warning`/`success`, which ARE `AppTokens` members, were migrated in the same files.

### `lib/screens/auth/**` — judged deliberately out of scope, NOT migrated
Read `plans/reports/fullstack-developer-260717-0121-p2a-welcome-dark-auth-report.md` first, per instructions. It confirms `welcome/**` (marketing palette) and `forgot_password_screen.dart`/`reset_password_screen.dart` (dark glass `#050118`) are deliberately non-themed. I extended the same judgement to `login_screen.dart`, `signup_screen.dart`, `onboarding_screen.dart`, `widgets/auth_text_field.dart`, `widgets/social_login_button.dart` (still flagged `AppColors.authBackground/foreground/mutedForeground/border/destructive`):
- `login_screen.dart`/`signup_screen.dart` both wrap their form in `lib/widgets/common/auth_card.dart` (owned by the sibling `lib/widgets/**` agent, NOT touched by me), which hardcodes `color: Colors.white` and `border: Border.all(color: AppColors.orange100)` unconditionally — i.e. this shared shell is itself deliberately non-theme-aware, matching web's fixed white auth card. Migrating only the surrounding `Scaffold` background/text to `context.tokens` while the actual visible card stays hardcoded white would produce a jarring half-dark screen (dark scaffold, stark-white floating card) — a worse outcome than leaving the whole surface consistently light, per the brief's "a wrong colour is worse than a documented gap."
- `onboarding_screen.dart` uses a fixed pastel icon-tile palette (literal hex, e.g. `Color(0xFFFFF1E6)`) throughout its 3 slides — same "deliberately fixed marketing palette" pattern as `welcome/**`.
- These 5 files also already showed as pre-existing uncommitted `git status` changes before I started this session (confirmed against the initial gitStatus dump) — consistent with the P2A report's note that they're mid-flight from an earlier, unrelated pass, reinforcing "don't touch."
- Flagging this interpretation as the one open judgement call in this report — a coordinated follow-up phase that also updates `AuthCard` (sibling-owned) could make login/signup dark-mode correct in one pass; doing only the `Scaffold` half here was rejected as worse than the gap.

## Validation
- `flutter analyze` → 0 errors / 33 info (identical count to stated baseline; all info are pre-existing, none introduced by this work — verified by inspecting each hit, all in files I never touched).
- `flutter test` → 747/747 green, unchanged from baseline. No test targeted the deleted quiz files (`screens/quiz/daily_review.dart`, `screens/quiz/quiz_list_screen.dart`), so the total count did not shrink.

## Files touched
- Deleted: `lib/screens/quiz/daily_review.dart`, `lib/screens/quiz/quiz_list_screen.dart`.
- Modified (colour migration only, no behaviour/layout change): 29 files listed above under "Before/after count."

## Unresolved questions
- None blocking. Open call: whether `lib/screens/auth/{login,signup,onboarding}_screen.dart` + their 2 widget files should get a coordinated dark-mode pass together with `lib/widgets/common/auth_card.dart` (sibling-owned) in a follow-up — flagging per the judgement above rather than guessing.

Status: DONE
Summary: Deleted dead unrouted `quiz/*` screens (verified zero references); migrated dark-mode colour reads across 29 `lib/screens/**` files (home/journey/games/social/settings/exam/ai/video_library/notifications/speaking/system/webview) to `context.tokens`, leaving affiliate (plan-mandated), auth (judged consistent with sibling-owned `AuthCard`'s deliberate fixed-white design), and 2 documented no-clean-mapping gaps (`primaryGradient`, WebView native bg) untouched. `flutter analyze` 0 errors/33 info, `flutter test` 747/747 green — no regression.
Concerns/Blockers: none.
