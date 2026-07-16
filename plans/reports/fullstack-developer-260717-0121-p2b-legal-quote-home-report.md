# Phase 2b — Legal content sync, daily-quote feed rebuild, home ExamHeroCard — Report

Plan: `plans/260716-2324-web-mobile-ui-100-fidelity/phase-02-entry-auth-home-quote.md`.
Prior pass: `plans/reports/fullstack-developer-260717-0107-p2-entry-auth-home-quote-report.md`
(deferred items #2, #5, #6, #7 — resume section + hero, quote feed rebuild, legal
content/dark-mode sync — picked up here).

## 1. Legal pages — DONE

- New `lib/screens/legal/widgets/legal_scaffold.dart`: sticky brand header
  (`TigerIcon` 28px + "Deutsch Tiger" in Grandstander, taps → `context.go('/welcome')`,
  NOT a Material `AppBar`), h1 in body, fixed date line, bottom divider +
  "Về trang chủ" back-to-home button. Backed entirely by `context.tokens`
  (light/dark both covered — no `DesignTokens`/`AppColors` statics).
- New `lib/screens/legal/widgets/legal_content_widgets.dart`: `LegalSection`
  (h2 + body), `LegalParagraph`, `LegalLinkParagraph` (inline orange
  `mailto:`/`https:` link via `TapGestureRecognizer` + `url_launcher`),
  `LegalBulletList` (parses a leading `**bold:**` lead-in per item, mirrors
  web `<strong>` inside `<li>`).
- `privacy_policy_screen.dart` / `terms_of_service_screen.dart` rewritten as
  thin content-only files assembling `LegalScaffold` + sections — content
  ported **verbatim** from web (privacy = 9 sections replacing the old
  8 Apple-review-tailored sections; terms = 9 sections). Dates are fixed
  literal strings ("Tháng 3, 2026" / "Tháng 7, 2026"), not `DateTime.now()`.
  Dropped the extra `©` footer line (not on web). Contact email
  `admin@deutschtiger.com` confirmed already correct from the prior pass.
- Terms §9 links to Privacy Policy via `context.push('/privacy-policy')`
  (existing route in `entry_routes.dart` — confirmed, not modified).

## 2. Daily quote page — DONE

- `lib/screens/stats/daily_quote_page.dart` rebuilt: vertical `PageView.builder`
  (`scrollDirection: Axis.vertical` — page-snaps natively), full-bleed photo
  per quote, glass back button (top-left, `Navigator.pop`).
- New `lib/screens/stats/widgets/quote_slide.dart`: photo with
  `borderRadius.bottomLeft: 80` (web's `rounded-bl-[5rem]`), dark gradient
  overlay, card below with 3 sage dots + quote-mark icon + DE/VI text +
  `🌿 category` (accent `#a8c686` = `quoteSage` const), swipe hint on slide 0.
- New `lib/screens/stats/widgets/quote_image_assigner.dart`: pure
  `assignQuoteImages(count)` port of web's Fisher-Yates `assignImages` —
  cycles a shuffled 1..20 pool, swaps away a same-image boundary repeat.
- Data source: `quoteHistoryProvider` (`GET /quotes/random`, already live,
  `limit: 20` — matches the 20 bundled photos). Did not touch the
  repository's `limit` param (web uses 30; repository file is outside my
  ownership) — 20 is a reasonable, still-live substitute, noted as a minor
  deviation below.
- Old `_QuoteCard` gradient-hero + `_QuotesGrid` 2-col layout (deterministic
  `dailyQuoteProvider` card + grid) fully replaced — `dailyQuoteProvider` is
  no longer referenced by this screen (still used elsewhere untouched).
- Updated `test/screens/stats/daily_quote_page_test.dart` to match: feed
  renders from `quoteHistoryProvider`, error view still shows on failure.

## 3. Home residuals — ExamHeroCard + resume section — DONE

- **Resume section ("Tiếp tục học")**: already fully wired in
  `home_screen.dart` via `DashboardContinueLearningSection` /
  `ResumeLearningCard` (`resume_section.dart`) — built by a session after
  the 0107 report, before I started. Verified it uses real
  `dailyPathProvider` data (no mocks); left untouched.
- **ExamHeroCard**: built new, took the **live-data path** — a real
  `examReadinessProvider` (`GET /exam-readiness`) exists and is already
  used elsewhere (`exam_readiness_screen.dart`, `readiness_goal_header.dart`).
  New `lib/screens/home/widgets/exam_hero_card.dart` (+ split-out
  `exam_hero_status_pieces.dart` for the countdown badge / readiness ring /
  CTA button / link row, kept both files <200 LOC): countdown badge, a
  readiness ring using `(readinessLow + readinessHigh) / 2` as the percent
  (the snapshot has a range, not web's single provider/level `percent` —
  reasonable approximation, doc'd in the widget comment), one full-width
  gradient CTA (`/exam` catalog — no per-user "resume in-progress exam" /
  "next weakest skill" routing since Flutter has no equivalent to web's
  `findLatestIncompleteExam`/`nextAction` yet), "Độ sẵn sàng"/"Đổi mục tiêu"
  link row.
- Wired into `home_screen.dart`: when `learnGoalProvider` has a
  `targetDate`, `ExamHeroCard` renders above the daily-path resume card and
  `ExamCornerCard` is hidden (mirrors web `DashboardHeroSection`'s
  hasGoal branch); otherwise unchanged (resume card + `ExamCornerCard`).
  Did **not** implement the "de-emphasized" visual variant of the daily-path
  card web shows in the exam-goal branch (`deemphasized` prop) — out of
  scope for a residual pass, noted below.
- Extracted `_mapMissions`/`_missionIcon` out of `home_screen.dart` into new
  `widgets/dashboard_mission_mapping.dart` to keep `home_screen.dart` <200
  LOC after the branch addition (pure refactor, no behavior change).
- New ARB keys (vi/en/de): `examHeroTitle`, `examHeroToday`,
  `examCornerDaysLeft`, `examHeroNoAttemptsYet`, `examHeroBasedOnAttempts`,
  `examHeroCta`, `examHeroReadyLabel`. Ran `flutter gen-l10n` (regenerated
  `app_localizations*.dart`, not hand-edited).

## Files changed/added

- `lib/screens/legal/privacy_policy_screen.dart`,
  `lib/screens/legal/terms_of_service_screen.dart` (rewritten)
- New: `lib/screens/legal/widgets/legal_scaffold.dart`,
  `lib/screens/legal/widgets/legal_content_widgets.dart`
- `lib/screens/stats/daily_quote_page.dart` (rewritten)
- New: `lib/screens/stats/widgets/quote_slide.dart`,
  `lib/screens/stats/widgets/quote_image_assigner.dart`
- `lib/screens/home/home_screen.dart` (ExamHeroCard branch + mission-mapping
  extraction)
- New: `lib/screens/home/widgets/exam_hero_card.dart`,
  `lib/screens/home/widgets/exam_hero_status_pieces.dart`,
  `lib/screens/home/widgets/dashboard_mission_mapping.dart`
- `lib/l10n/app_{vi,en,de}.arb` + generated `app_localizations*.dart`
- `test/screens/stats/daily_quote_page_test.dart` (rewritten to match new page)

## Validation

- `flutter analyze` on all touched files (`lib/screens/legal`,
  `lib/screens/stats`, `lib/screens/home`, `lib/widgets/dashboard`,
  `lib/l10n`, the rewritten test): **0 issues**.
- Full-repo `flutter analyze` scoped to non-concurrent-phase paths (excluded
  `lib/screens/practice`, `lib/features/exam`, `lib/screens/exam`,
  `lib/features/vocabulary`, `lib/screens/auth`, `lib/screens/vocab`,
  `lib/screens/daily_review` per the concurrent-phase carve-out): **0
  errors**.
- Full `flutter test` (573 tests ran): **568 passed, 5 failed**. All 5
  failures are outside my file ownership and pre-exist from concurrently
  running phases actively editing those files:
  - `test/l10n/app_localizations_test.dart` × 2 ("Reset password route…",
    "Welcome route…") — `lib/screens/auth/welcome/**` /
    `reset_password_screen.dart`, explicitly DO-NOT-TOUCH, another agent
    mid-rebuild.
  - `test/screens/exam/exam_dictation_screen_test.dart` × 2 —
    `lib/screens/exam/**`/`lib/features/exam/**`, DO-NOT-TOUCH.
  - `test/structure/release_live_data_guard_test.dart` — flags
    `lib/screens/practice/practice_items_loader.dart` (`mock` identifier),
    DO-NOT-TOUCH.
- `flutter test test/features/home/ test/l10n/ test/structure/` (run
  standalone earlier, same 3 external failures as above, confirmed
  reproducible/isolated to those files — not mine).
- `flutter test test/screens/stats/daily_quote_page_test.dart`: 2/2 passed.

## Deviations / unresolved

1. Quote feed uses `limit: 20` (repository default) not web's `limit: 30` —
   repository file (`daily_quote_repository.dart`) is outside my file
   ownership for this phase; 20 also exactly matches the 20 bundled photos,
   so no functional loss, just fewer quotes per feed load before refetch.
2. `ExamHeroCard`'s CTA always routes to `/exam` (provider catalog) — web's
   specificity ladder (resume in-progress exam → drill weakest skill →
   catalog) needs `findLatestIncompleteExam`-equivalent cross-device state
   that doesn't exist in the Flutter exam module yet. Flagged as a possible
   follow-up, not fabricated.
3. Daily-path "de-emphasized" visual variant (web's `deemphasized` prop on
   `DailyPathHeroCard` when an exam goal is active) not implemented — the
   resume card renders identically regardless of goal state. Cosmetic-only
   gap.
4. Readiness ring shows the midpoint of `readinessLow`/`readinessHigh`
   (backend gives a range, web's per-provider/level hook gives a single
   `percent`) — closest available live approximation, not fabricated data.

Status: DONE
Summary: Legal pages content/layout/dark-mode synced verbatim from web with
a shared token-driven scaffold; daily-quote page rebuilt as a real vertical
snap photo feed off live `/quotes/random` data; home now branches to a new
live-data `ExamHeroCard` when the user has an exam goal, using the existing
`examReadinessProvider` (no fabricated data). All touched-file analyze clean,
full-suite failures are confirmed pre-existing/out-of-scope from concurrent
phases.
Concerns: none blocking; 4 minor scope-approximation deviations listed above
for owner awareness.
