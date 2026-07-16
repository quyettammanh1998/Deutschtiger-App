# P2A: Welcome landing page + dark auth (forgot/reset password)

Web-mobile UI fidelity plan, phase-02 follow-up part A. Full marketing port of the welcome/landing page + dark particle-glass rebuild of forgot/reset password.

## 1. Welcome / landing page — DONE

Web source read in full: `welcome-page.tsx` + all `components/landing/welcome/*.tsx` (nav-header, hero-section, hero-phone-mock, hero-badges, stats-bar, how-it-works, features-grid, testimonials, final-cta, footer, auth-modal).

### Files created
- `lib/screens/auth/welcome/welcome_palette.dart` — literal marketing hex colors (not `context.tokens`; web hardcodes this palette too, independent of `:root`/`.dark`).
- `lib/screens/auth/welcome/welcome_nav_header.dart` — sticky brand + "Bắt đầu" CTA (streak pill dropped: web hides it below 720px via media query, and mobile port is always below that breakpoint; nav link anchors dropped since the port scrolls linearly, no in-page jump).
- `lib/screens/auth/welcome/welcome_hero_badges.dart`, `welcome_hero_phone_mock.dart` — CSS-drawn phone mock + 4 floating proof badges (streak/XP/level-up/trophy), decorative screenshot content pinned to `TextScaler.noScaling` (real screenshots don't reflow with OS font size).
- `lib/screens/auth/welcome/welcome_hero_section.dart` — live pill (animated dot), rating pill, Grandstander "Chơi./Học./Đỗ!" word-stack headline, sub copy, primary CTA (opens auth modal) + secondary CTA (scrolls to how-it-works), mini-proof line.
- `lib/screens/auth/welcome/welcome_stats_bar.dart`, `welcome_section_head.dart`, `welcome_how_it_works.dart` (3-step showcase + mini illustrations), `welcome_features_grid.dart` (9 cards), `welcome_testimonials.dart` (3 cards), `welcome_final_cta.dart`, `welcome_footer.dart`.
- `lib/screens/auth/welcome/welcome_auth_modal.dart` — bottom-sheet auth entry (see deviation below).
- `lib/screens/auth/welcome_screen.dart` — rewritten orchestrator, `StatefulWidget` holding a `GlobalKey` for the how-it-works scroll target.

### Deviations from literal 1:1 web port (documented, not silently dropped)
- **Auth modal**: web embeds a full login/signup form inline in the modal. `LoginScreen`/`SignupScreen` are DO-NOT-TOUCH, full-`Scaffold` screens (not embeddable widgets) owned by another phase, so the modal instead shows a compact "Chào mừng" panel with Đăng nhập/Đăng ký buttons that `context.push('/login')`/`/signup`, plus a tertiary "Xem giới thiệu app trước" link to `/onboarding` (preserves the pre-existing onboarding path per the brief).
- **Footer SEO link cloud**: web ships 25 marketing-only landing links + nav columns to web-only routes (help, mailto, community pages). Dropped — no Flutter destination exists for them. Kept: brand, tagline, Điều khoản/Bảo mật (real routes `/terms-of-service`, `/privacy-policy`), copyright, founder credit.
- **How-it-works illustrations**: simplified single-state mini cards instead of web's full `VocabIllu`/`GameIllu`/`ExamIllu` mockups (still one distinct illustration per step, same copy).
- Marketing copy (headline, sub, stats, feature/testimonial text, footer tagline) stays inline Vietnamese verbatim from web, per the approved ARB exception — not pushed through l10n.

### Layout robustness
Initial pass had several `RenderFlex` overflow bugs at narrow width / 200% text-scale (nav header, hero pills/CTAs, stats bar, features grid, testimonials, footer) — fixed via `Wrap`/`Flexible`/`FittedBox(scaleDown)` on real content, and `TextScaler.noScaling` on the two decorative screenshot mockups (phone + step illustrations), matching how a real screenshot doesn't reflow with OS font size.

## 2. Forgot / reset password — DONE

Web source read in full: `forgot-password-page.tsx`, `reset-password-page.tsx`, `particle-words-canvas.tsx`, `particle-words-engine.ts`.

### Files created
- `lib/screens/auth/widgets/particle_words_canvas.dart` — `CustomPainter` + single `AnimationController`, ~48 ambient dots + 3 cycling German word sets at 4 fixed positions (mirrors engine's mobile 4-word layout), cross-fades on loop boundary. No package added.
- `lib/screens/auth/widgets/auth_dark_glass_card.dart` — shared dark shell: bg `#050118`, particle canvas background, bottom-anchored (`Align(bottom)`) glass card `bg-black/15 border-white/10`, big soft shadow. Hardcodes literal web hex with a doc comment explaining why (deliberately theme-independent, not a `context.tokens` surface).
- `lib/screens/auth/widgets/auth_dark_text_field.dart` — `bg-white/10 border-white/10 text-white` input.

### Files rewritten
- `lib/screens/auth/forgot_password_screen.dart` — form → success panel (green-900/30 alert with the sent-to email), replacing the old snackbar+redirect. Orange→rose gradient submit.
- `lib/screens/auth/reset_password_screen.dart` — state machine `loading → ready|error → success`, listens to Supabase `AuthChangeEvent.passwordRecovery` with a 3s timeout fallback to the invalid-link error panel (mirrors web's `onAuthStateChange` + timeout). Eye-toggle on both password fields, min-8 validation, success panel instead of snackbar+redirect.

### l10n additions (all 3 ARBs + regenerated via `flutter gen-l10n`)
`verifyingResetLink`, `resetLinkInvalid`, `resendResetLink`, `checkEmailForResetLink` (placeholder `{email}`), `showPasswordTooltip`, `hidePasswordTooltip`, `newPasswordHint`, `confirmPasswordHint`. No hand-edits to generated `app_localizations*.dart`.

## Tests added
- `test/screens/auth/welcome_screen_test.dart` — renders all main sections; primary CTA opens the auth modal with localized login/signup entries.
- `test/screens/auth/forgot_password_screen_test.dart` — dark card + form renders; empty-email validation blocks submit.
- `test/screens/auth/reset_password_screen_test.dart` — loading state renders; 3s timeout falls back to invalid-link error. Initializes a fake Supabase instance (`EmptyLocalStorage`, mock `SharedPreferences`) since `ResetPasswordScreen` reads `Supabase.instance.client.auth` directly (matches the original screen's design).
- Updated 2 pre-existing `test/l10n/app_localizations_test.dart` cases that assumed the old designs (old welcome headline/CTA copy, reset form rendering without the new Supabase-driven state machine) — adjusted to match the new, approved screens; added the same Supabase test-init helper there since `ResetPasswordScreen` is exercised in that file too.

## Validation
- `flutter analyze` → 0 errors/warnings in anything I own. Pre-existing errors in `lib/features/vocabulary/**` (broken by a concurrently-running phase per the task brief) are NOT mine — untouched by this work.
- `flutter test` full suite → all green except 2 failures, both compile errors in `lib/features/vocabulary/**` (`vocabulary_detail_mastery_strip.dart`, `vocabulary_screen.dart`, `vocab_lesson_utils.dart` etc.) that block `test/widget_test.dart` and `test/screens/vocabulary/vocabulary_screen_localization_test.dart` from loading — same concurrent-phase files, not touched by me, matches the brief's "failures ONLY in those paths are not yours."
- Net: baseline 578 → now 584 attempted (582 pass + 2 pre-existing-broken), i.e. +6 new tests all green, 0 regressions in files I own.
- `test/structure/release_live_data_guard_test.dart` — welcome/forgot/reset were never in its route list (auth screens aren't in scope of that guard); no update needed. Grepped my new files for `mock|fixture|placeholder` identifiers — only benign "phone mock"/"screenshot mock" prose in comments, no risk.

## Files touched (mine)
- New: `lib/screens/auth/welcome/*.dart` (12 files), `lib/screens/auth/widgets/particle_words_canvas.dart`, `auth_dark_glass_card.dart`, `auth_dark_text_field.dart`.
- Rewritten: `lib/screens/auth/welcome_screen.dart`, `forgot_password_screen.dart`, `reset_password_screen.dart`.
- ARB: `lib/l10n/app_{vi,en,de}.arb` (+ regenerated `app_localizations*.dart`).
- Tests: `test/screens/auth/welcome_screen_test.dart`, `forgot_password_screen_test.dart`, `reset_password_screen_test.dart`; updated `test/l10n/app_localizations_test.dart`.

Note: `lib/screens/auth/login_screen.dart`, `signup_screen.dart`, `widgets/auth_text_field.dart`, `widgets/social_login_button.dart` show as modified in `git status` but were NOT touched by me this session — pre-existing uncommitted work from the prior agent's login/signup reorder pass mentioned in the brief.

## Unresolved questions
- None blocking. Open call: the auth-modal's "reuse login/signup forms" instruction was interpreted as navigation-based reuse (not embeddable-widget reuse) since those screens are full Scaffolds outside this phase's ownership — flag if the owner wants a follow-up phase to extract an embeddable login/signup form widget for a truer inline-modal match to web.

Status: DONE
Summary: Full welcome landing page port (nav/hero/stats/how-it-works/features/testimonials/final-CTA/footer + auth modal) and dark particle-glass forgot/reset password rebuild, both with full state coverage and layout-robust at 200% text scale; 0 analyze errors, +6 new tests green, no regressions in owned files.
Concerns/Blockers: none.
