# UI Fidelity Scout — Shell, Tokens, Icons, Auth, Legal, Landing

Scope: cross-cutting shell + entry screens. Web = source of truth at mobile viewport (<768px, base tailwind classes only).
Web root: `thamkhao/deutschtiger-frontend`. Flutter root: repo.

---

## 1. App shell / Bottom nav

**(a) Web files:** `src/components/layout/bottom-nav.tsx`, `src/components/layout/page-layout.tsx` (sidebar hidden on mobile), `src/components/dashboard/more-features-sheet.tsx`, `src/components/shared/bottom-sheet.tsx`.

**(b) Web mobile visual (bottom-nav):**
- `nav`: fixed bottom, `h-16` (64px) + `pb-[env(safe-area-inset-bottom)]`, `border-t border-border`, `bg-background/95 backdrop-blur-sm` (translucent CREAM, not white), NO shadow, z-40.
- 5 slots, `flex-1` each: **Trang chủ / Thi / Học / Hội thoại / Thêm**.
- Per-tab ACTIVE colors (not one accent):
  - Trang chủ: `text-amber-600` + pill `bg-amber-100` (dark: amber-400 / amber-500/20)
  - Thi: `text-indigo-600` + `bg-indigo-100` (dark indigo-400 / indigo-500/20)
  - Học: `text-emerald-600` + `bg-emerald-100` (dark emerald-400 / emerald-500/20)
  - Hội thoại: `text-teal-600` + `bg-teal-100` (dark teal-400 / teal-500/20)
  - inactive all: `text-slate-500 dark:text-slate-400`, label opacity-70
- Icon sits in an 11×11 (44px) `rounded-lg` container; active state = pastel bg pill. Icon 20px (`h-5 w-5`), custom inline SVG from `FEATURE_ICONS` (Phosphor-style fill: home, exams(school-hat), learn(connected-nodes); conversationHub = stroked chat-bubble + sparkle).
- "Thêm" icon = 3-line hamburger SVG (NOT grid), never active-colored; opens MoreFeaturesSheet (no navigation).
- Label: `text-[10px] font-semibold`, gap-0.5 under icon.

**Web more-features-sheet:** rendered via `BottomSheet` with `centered` → CENTERED modal dialog (not bottom-anchored): `rounded-2xl`, `animate-scale-in`, `max-w-lg`, `bg-card`, backdrop `bg-black/40`, title bar "Tất cả tính năng" (text-base semibold, X button phosphor 20px, `border-b border-border/50`), body px-4 pt-4. Content: 4 groups with emoji labels `text-[11px] font-bold uppercase tracking-wider text-muted-foreground`:
1. 🎬 Luyện thêm — YouTube, Đọc & Nghe, Nghe, Đọc bài, Tin tức, Từ vựng phụ đề, Phiên tập trung
2. 📗 Ngữ pháp & Kỹ năng — Ngữ pháp, Luyện 4 Cách, Chia động từ, Cặp âm dễ nhầm, Phỏng vấn
3. 👥 Cộng đồng & Tiến độ — Thống kê, Bảng xếp hạng, Hồ sơ năng lực, Sẵn sàng thi, Lỗi hay gặp, Tin nhắn, Bạn bè, Tìm bạn ôn thi
4. ⚙️ Tài khoản & Khác — Trích dẫn hằng ngày, Giới thiệu, Nâng cấp Premium, Cài đặt, (Luyện viết flag), (Quản trị admin), Góp ý
Grid `grid-cols-4 gap-2`; tile = 44px `rounded-2xl` pastel bg (per-item: red-100, teal-100, purple-100, orange-100, indigo-100, cyan-100, fuchsia-100, amber-100, blue-100, pink-100, violet-100, emerald-100, slate-100, rose-100; dark = `*-500/20`), icon 24px colored SVG, label `text-[11px] font-medium line-clamp-2` foreground.

**(c) Flutter:** `lib/widgets/common/app_shell.dart`, `lib/shared/widgets/more_features_sheet.dart`, `lib/widgets/common/minimal_shell.dart`.

**(d) Verdict: DIVERGENT (major)**
Shell diffs:
1. Tab set wrong: Flutter = Home/Thi/Học/**AI(smart_toy, flag-gated)**/Thêm. Web 4th tab = **Hội thoại** (conversation hub). No AI tab on web bottom nav.
2. Single active color `tigerOrange` vs web per-tab amber/indigo/emerald/teal + pastel pill behind icon (no pill in Flutter).
3. Material `BottomNavigationBar` (~56px, label ~12-14px, selected label grows) vs web 64px fixed, label 10px semibold both states.
4. Nav bg: Flutter `card` (white) + top shadow; web `background/95` cream translucent, border-t only, NO shadow.
5. Icons: Material (home/assignment/menu_book/grid_view) vs web custom Phosphor-style SVGs; "Thêm" = hamburger on web, grid_view in Flutter.
6. Inactive color: web slate-500 (#64748B); Flutter mutedForeground (#76726F warm gray) — same value light AND dark in Flutter (bug: ternary returns identical branches, app_shell.dart:60-62); web dark = slate-400.

More-sheet diffs:
1. Presentation: Flutter bottom `DraggableScrollableSheet` 75% height w/ drag; web centered scale-in dialog max-w-lg.
2. Content completely different: Flutter 4 groups (Từ vựng & Ôn tập / Luyện thêm / Ngữ pháp & Kỹ năng / Cộng đồng & Tiến độ) w/ 15 items, many not on web sheet (My words, Decks, Daily review, AI chat, Games, Exam, Achievements) and missing ~15 web items (YouTube, News detail set, Konjugation, Minimal pairs, Interview, Learner model, Exam readiness, Error patterns, Messages, Friends, Exam schedule, Daily quote, Affiliate, Premium, Settings, Feedback).
3. Grid 3-col 52px tiles vs web 4-col 44px `rounded-2xl`; no emoji in group labels; header has orange grid icon + title (web: plain title + X only, drag handle none since centered).

**(e) Assets:** none (all icons inline SVG — need SVG-path port or icon pack, see §3).

**PageLayout (web)**: mobile = plain scroll container `px-4 pt-4 pb-28`; sidebar/header desktop-only. Flutter screens each own their padding — verify per-screen `pb` clears 64px nav (out of this scope's per-page detail).

---

## 2. Design tokens — `src/index.css` vs `lib/core/design_tokens.dart`

Web HSL → hex conversions mine; Flutter values as coded.

### Light — MISMATCHES
| Token | Web | Flutter | Verdict |
|---|---|---|---|
| `--primary` | hsl(32,93%,54%) ≈ **#F7941D orange** | `primary` = **#FF8FA3 PINK** | **MAJOR** — ThemeData seeds pink everywhere; web is tiger orange (== tigerOrange #F7931E ✓ exists but isn't primary) |
| `--ring` | = primary orange | pink (follows primary) | major |
| `--sidebar` | hsl(32,50%,95%) ≈ #F9F3EC warm cream | #F7DCE2 pink | divergent (mobile impact low) |
| `--background` | hsl(25,47%,97%) ≈ #FBF7F4 | #FBF4EF | minor (slightly more saturated) |
| `--brand` | ≈ #F7941D | #F59E1B | minor |
| `--brand-dark` | hsl(32,93%,46%) ≈ #E27D08 | #D9850E | minor |
| `cardBackground` #F5F2EA | no web counterpart | — | Flutter-only token, delete/verify usage |

Matches (±1-2/channel, OK): foreground #2E2E2E ✓, muted, mutedForeground, card #FFF ✓, secondary #FADFCC≈, accent #E6ECC6≈, border #E8E5E3≈, destructive #EF4444 ✓, success #22C55E ✓, warning #F59E0B ✓, radius 16 ✓ (`--radius:1rem`).

### Dark — MISMATCHES
| Token | Web `.dark` | Flutter | Verdict |
|---|---|---|---|
| `--primary-foreground` | hsl(0,0%,98%) = #FAFAFA | `darkPrimaryForeground` #08131A (near-black) | **DIVERGENT** |
| `--destructive` | hsl(0,63%,31%) ≈ #811D1D (dark red) | #F87171 (red-400) | DIVERGENT |
| `--sidebar` | hsl(220,13%,12%) ≈ #1B1D23 | #28202A purple-tint | DIVERGENT |
| `--brand` | unchanged orange hsl(32,93%,54%) | `darkBrand` #FBBF24 amber | DIVERGENT |
| `--success` | hsl(142,71%,45%) #22C55E (same as light) | `darkSuccess` #4ADE80 | divergent |
| `--warning` | hsl(38,92%,50%) #F59E0B (same as light) | `darkWarning` #FBBF24 | divergent |
| `--background` | hsl(220,13%,9%) ≈ #14161A | #14171F | minor |
| `--primary` | hsl(200,85%,65%) ≈ #5ABFF2 | #5BB8E6 | minor |

Matches: darkForeground #FAFAFA ✓, darkMuted #383B45≈, darkMutedForeground #B7BCC4≈, darkCard #1F242E≈hsl(220,13%,14%)✓, darkSecondary ✓, darkBorder ✓.

Shadows: `shadowCard` == web `.card` 2-layer ✓. Note web `.card` light = `border: transparent` (shadow only), dark = visible border; Flutter `CardThemeData` always draws border → light-mode cards look edged vs web's soft shadow-only. `card-sm` (radius 12 = radius−4, border always, shadow 0 1px 4px) has no dedicated Flutter token (radiusSm=8 ≠ 12).

`tabActiveColor = primary` (pink) with comment "orange-500" — wrong twice (web is per-tab colors, §1). `bottomNavLabel` 12px w500 vs web 10px w600.

### Fonts — MAJOR GAP
Web: **Inter** 400–700 (body, self-hosted subset), **Fredoka One** 400 (brand wordmark "Deutsch Tiger"), **Grandstander** 700 (landing display headings). Files in `public/fonts/*.woff2`.
Flutter: `DesignTokens.fontFamily = 'Inter'` but **pubspec has NO fonts declared** (section commented out) and `google_fonts` package is a dep but **never imported in lib/** → app actually renders Roboto/system. Fredoka One & Grandstander completely absent.
Action needed: bundle Inter (400/500/600/700 ttf), Fredoka One, Grandstander-700 (latin+vietnamese) or wire google_fonts.

---

## 3. Icon system

- Web: NO lucide. `src/lib/shared/feature-icons.tsx` = hand-inlined SVGs, two styles: 256-viewBox Phosphor-style solid fills (home, exams, dailyReview, games, course, youtube, news, learn) + 24-viewBox 1.6–1.9 stroke rounded line glyphs (vocabulary, notes, conversationHub, sentenceBuilder, listening, interview, affiliate). More-sheet has its own `IC` map (same styles). Legacy `@phosphor-icons/react` only in shared components (X, CaretRight).
- Flutter: **Material Icons only** (`Icons.*`) everywhere in scope; `flutter_svg` available (used for logo).
- Shell-level mapping gaps (web glyph → current Flutter):
  - home (Phosphor house fill) → `Icons.home_outlined/rounded` — different silhouette
  - exams (graduation-cap fill) → `Icons.assignment` — wrong metaphor
  - learn (network-nodes fill) → `Icons.menu_book` — wrong metaphor
  - conversationHub (chat bubble + sparkle stroke) → MISSING (Flutter shows smart_toy AI tab)
  - "Thêm" hamburger 3-line → `Icons.grid_view_rounded` — wrong glyph
  - more-sheet: ~20 item glyphs all Material approximations, colors partially different
- Options: port the exact SVG paths as `flutter_svg` assets/string constants (guarantees parity), or `phosphor_flutter` package (close for the fill set, not the custom sparkle ones).

---

## 4. Shared primitives

Web `src/components/ui/` contains ONLY `button.tsx` (h-10=40px, `rounded-lg`=8, px-4, font-medium; variants default `bg-primary`, ghost, outline `border-input bg-background`). No shadcn card/badge/tabs/dialog/sheet/input/progress — instead global CSS utilities in `index.css`:
- `.card` — bg card, radius 16, transparent border + shadow `0 2px 8px rgba(0,0,0,.06), 0 1px 3px rgba(0,0,0,.03)`; dark: border visible, shadow `0 1px 4px .2`
- `.card-sm` — radius 12, border `--border`, shadow `0 1px 4px .05`
- `.card-interactive` — radius 16, hover translateY(-1px) + shadow lift, active reset
- `.btn-primary` — gradient `primary → primary·75%+black`, white, w600, radius 16
- `.btn-secondary` — bg muted, w500, radius 16
- `BottomSheet` (shared) — mobile bottom-anchored `rounded-t-2xl animate-slide-up`, drag handle 40×4 `bg-muted-foreground/30`, backdrop black/40, max-h 85dvh; `centered` variant = rounded-2xl scale-in.

Flutter counterpart status: `CardThemeData` radius 16 + always-border (≈card-sm look, not .card); `ElevatedButton` height 52 radius 16 (web button h-40 radius 8 — divergent where web `<Button>` used); inputs: theme radius 16 vs web inputs `rounded-lg` 8 (AuthTextField overrides to 8 ✓); no generic bottom-sheet widget matching web handle/title-bar pattern (more_features_sheet hand-rolls one, no drag-handle bar, no bordered title row).

---

## 5. Pages

### 5.1 Landing `/welcome`
- (a) `src/pages/landing/welcome-page.tsx` + `src/components/landing/welcome/*` (nav-header, hero-section w/ phone-mock + 3D badges, stats-bar, how-it-works, features-grid, testimonials, final-cta, footer, auth-modal). All CSS-in-component, no raster assets.
- (b) Mobile top→bottom: sticky nav header (tiger-icon.svg + wordmark); HERO: live pill "**1,247** đang học" (green dot), rating pill avatars+★★★★★, headline Grandstander display "Học tiếng Đức / Chơi. Học. Đỗ!" (multi-color word stack), sub copy, CTA `wel-btn-main` "Bắt đầu hành trình" (opens auth modal) + secondary "Xem cách học", mini-proof line, CSS phone mock with 4 floating 3D badges (streak 27 ngày, +5 XP, Lên cấp B1, Goethe B1·Đỗ); stats bar (Grandstander numerals); how-it-works; features grid; testimonials; final CTA; footer. Page bg `linear-gradient(180deg,#FFF7EC 0%,#FFFBF5 600px)`. Auth = MODAL over landing.
- (c) Flutter: `lib/screens/auth/welcome_screen.dart` (logo + 2-line tagline + 3 feature rows + gradient CTA → `/onboarding` + login link). Plus legacy `lib/features/landing/presentation/landing_screen.dart` (PageView onboarding + duplicate WelcomeScreen, Material defaults, TODO Google sign-in) routed at `/landing` & `/welcome-full`.
- (d) **DIVERGENT (by design?)** — Flutter is a minimal app-store-style welcome, not the marketing landing. If 100% parity required: missing live/rating pills, Grandstander headline stack, phone mock + badges, stats bar, how-it-works, features grid, testimonials, footer, auth modal flow. Also Flutter routes to `/onboarding` carousel which has NO web counterpart.
- (e) Assets: fonts (Grandstander, Fredoka One); everything else is code-drawn.

### 5.2 Login `/login`
- (a) `src/pages/auth/login-page.tsx`; TigerLogo, password-toggle-icons.
- (b) Mobile: page bg `#FFFBF5` (dark: background), content TOP-aligned (`items-start pt-14`); card `max-w-xs rounded-2xl border-orange-100 bg-white p-3 shadow-lg` (dark: border-border bg-card). Order: TigerLogo w-20 → subtitle `text-xs font-semibold text-orange-500` "Đăng nhập để tiếp tục học" → (status/error inline `card-sm` colored alerts: green-50 signup-success, amber-50 device-kicked, red-50 error) → Email label `text-xs gray-700` + input (`rounded-lg border-orange-100 bg-orange-50/60 px-3 py-2 text-sm`, focus border-orange-300 bg-white) → Password + eye toggle 18px → right-aligned "Quên mật khẩu?" `text-xs text-orange-500` → submit `card-interactive bg-gradient-to-r from-orange-500 to-rose-600 py-2.5 text-sm font-semibold` → divider `h-px bg-orange-100` + "hoặc" → **Google button** (white, border-orange-100, official 4-color G 20px, "Đăng nhập với Google") → footer "Chưa có tài khoản? Đăng ký" orange-500.
- (c) Flutter `lib/screens/auth/login_screen.dart` + `widgets/auth_text_field.dart`, `widgets/social_login_button.dart`, `widgets/common/{auth_card,gradient_button,tiger_logo}.dart`.
- (d) **DIVERGENT**: 1) block order — Flutter puts Google/Apple ABOVE the form, web has form first then Google below divider; 2) errors via SnackBar vs inline colored alert cards; 3) card centered vertically (web top-anchored mobile), padding 20 vs 12; 4) GradientButton h-50 radius-12 vs web ~py-2.5 (≈40px) radius-16 (`card-interactive`); 5) no dark-mode variants (hardcoded white card/authBackground); 6) Apple button extra (iOS requirement — keep, but order per web); 7) label color gray-700 hardcoded (no dark). CLOSE on: gradient colors ✓, input style (orange-50/60 bg, orange-100 border, radius 8) ✓, logo ✓, links ✓.
- (e) Assets: none new (logo SVGs already in `assets/logo/`).

### 5.3 Signup `/signup`
- (a) `signup-page.tsx`. (b) Same card style as login (bg #FFFBF5, white card border-orange-100, min-h-60dvh centered). Order: logo w-20 → **h1 "Tạo tài khoản" text-base font-bold** → subtitle orange-500 → error inline → Tên hiển thị → Email → Mật khẩu (min 8, eye) → **Xác nhận mật khẩu** → gradient submit → divider → Google → footer login link.
- (c) `lib/screens/auth/signup_screen.dart`. (d) **DIVERGENT**: missing h1 title; social-first order; **no confirm-password field**; password min 6 vs web 8; SnackBar errors; no dark variants. (e) none.

### 5.4 Forgot password `/forgot-password`
- (a) `forgot-password-page.tsx` + `ParticleWordsCanvas`. (b) **DARK page regardless of theme**: bg `#050118` + animated particle-words canvas; glass card `rounded-2xl border-white/10 bg-black/15 shadow-[0_0_60px_rgba(0,0,0,0.5)]` bottom-anchored mobile (`items-end`); logo w-28; h1 "Quên mật khẩu" white bold; sub gray-400; inputs `bg-white/10 border-white/10 text-white`; submit gradient orange→rose py-3; success = green-900/30 alert; links orange-400.
- (c) `lib/screens/auth/forgot_password_screen.dart`. (d) **DIVERGENT (theme inverted)**: Flutter renders light cream AuthCard; web is dark glass over particle canvas. Every color differs.
- (e) none (canvas is code).

### 5.5 Reset password `/reset-password`
- (a) `reset-password-page.tsx`. (b) Identical dark particle-glass layout as forgot; states: loading spinner, invalid-link error, success, form (Mật khẩu mới + Xác nhận, eye toggle, min 8), gradient submit, "Quay lại đăng nhập" orange-400.
- (c) `lib/screens/auth/reset_password_screen.dart`. (d) **DIVERGENT**: Flutter = light Scaffold + AppBar + `Icons.lock_reset_rounded` 56px orange hero — nothing like web dark glass card. Success → snackbar+`/home` vs web success panel → login link.
- (e) none.

### 5.6 Privacy `/privacy` & 5.7 Terms `/terms`
- (a) `src/pages/legal/privacy-policy-page.tsx`, `terms-of-service-page.tsx`.
- (b) Mobile: bg `#FFFBF5` (dark: background); sticky header `bg-white/90 backdrop-blur border-b border-gray-100` with `tiger-icon.svg` 28px + wordmark "Deutsch Tiger" in **Grandstander** linking `/welcome`; main `px-4 py-12`; h1 `text-3xl font-black`; date line `text-sm text-gray-500` ("Tháng 3, 2026" privacy / "Tháng 7, 2026" terms); sections `space-y-8`, h2 `text-xl font-bold`, body `text-gray-700 dark:text-muted-foreground leading-relaxed`, links `text-orange-600 hover:underline`, bullet `list-disc pl-5`; footer divider + `BackButton` "Về trang chủ". Privacy = 9 sections (contact **admin@deutschtiger.com**); Terms similar structure.
- (c) Flutter routed: `lib/screens/legal/privacy_policy_screen.dart`, `terms_of_service_screen.dart`. Duplicates NOT routed: `lib/features/legal/*` (dead).
- (d) **DIVERGENT**: Material AppBar w/ orange 18px title (web: brand header + in-body h1 3xl black); CONTENT TEXT differs (Flutter privacy = 8 different sections, contact support@ vs web admin@; date = `DateTime.now().year` vs fixed "Tháng 3, 2026"); no dark-mode (hardcoded authBackground/foreground); extra © footer line not on web; no bottom BackButton.
- (e) Assets: tiger-icon.svg ✓ already bundled; Grandstander font needed for brand header.

### 5.8 Delete account page
`legal/delete-account-page.tsx` **does not exist** in web repo (no route, no file — grep confirmed). Task premise stale. → nothing to compare; if Flutter has account-deletion UI (settings scope, not checked here) it's app-store-driven, keep.

---

## 6. Flutter files in scope with NO web counterpart (delete/rebuild candidates)

| File | Note |
|---|---|
| `lib/screens/auth/onboarding_screen.dart` | onboarding carousel — web has none (welcome → login/signup modal). Routed from welcome CTA. Decide keep (native UX) or drop for parity |
| `lib/features/landing/presentation/landing_screen.dart` | legacy `LandingScreen` + duplicate `WelcomeScreen`; Material defaults, `Navigator.pushNamed` (broken w/ go_router), TODO stub Google login. Routed `/landing`, `/welcome-full` — delete + routes |
| `lib/features/legal/privacy_policy_screen.dart`, `terms_of_service_screen.dart` | unrouted duplicates of screens/legal — dead code, delete |
| `lib/features/auth/presentation/` | empty dir |
| `lib/widgets/common/minimal_shell.dart` | Flutter utility, no direct web file; web fullscreen pages hand-roll headers — acceptable infra, keep |
| Flutter AI bottom tab (app_shell) | web bottom nav has no AI tab (Hội thoại instead); AI lives elsewhere on web |

---

## 7. Assets needed from web `public/`

1. `public/fonts/inter-400-700.woff2` → bundle Inter 400/500/600/700 (ttf) in pubspec `fonts:` (currently NOTHING bundled; 'Inter' silently falls back to Roboto).
2. `public/fonts/fredoka-one-400.woff2` → Fredoka One (brand wordmark, legal headers, logo text already baked into logo SVG).
3. `public/fonts/grandstander-700-latin.woff2` + `-vietnamese.woff2` → Grandstander 700 (landing display, legal brand header).
4. `tiger-icon.svg`, `deutsch-tiger-logo.svg` — already in `assets/logo/` ✓.
5. Shell/feature icons: no files — port SVG path data from `feature-icons.tsx` + more-sheet `IC` map into flutter_svg strings/assets.

---

## 8. Priority fix list (this scope)

1. **Light `--primary` pink→orange** (#F7941D) + ring; audit everything seeded from `DesignTokens.primary`.
2. **Bundle Inter** (+ Fredoka One, Grandstander) — global typography currently Roboto.
3. **Bottom nav rebuild**: custom widget (not `BottomNavigationBar`) — 64px, cream/95 blur bg, per-tab colors + pastel pill, 10px labels, Hội thoại tab, hamburger "Thêm", web SVG glyphs.
4. **More-features sheet**: centered dialog, web group/item catalog, 4-col pastel tiles.
5. **Forgot/Reset**: rebuild as dark particle-glass pages.
6. **Login/Signup**: reorder (form first, Google below divider), inline alert cards, confirm-password + min-8 on signup, h1 on signup, dark variants.
7. Dark tokens: darkPrimaryForeground, darkDestructive, darkSidebar, darkBrand, darkSuccess/darkWarning.
8. Legal pages: brand header + h1-in-body layout, sync section text/dates/contact email, dark variants, bottom back button.
9. Delete dead: features/landing, features/legal, `/landing` `/welcome-full` routes.

## Unresolved questions
1. Web bottom nav shows **Hội thoại**, not AI — should Flutter drop/gate its AI tab to match, or is AI-tab an accepted mobile product decision (release_feature_flags suggests deliberate)?
2. Landing: is full marketing page (hero mock, testimonials, footer) wanted in-app, or is simplified native welcome accepted? App-store convention says simplified; "100% identical" says rebuild.
3. Onboarding carousel (`/onboarding`) has no web counterpart — keep or remove?
4. Legal content text differs (Flutter version looks Apple-review-tailored: Crashlytics, data-export wording). Sync to web text or keep app-specific? Contact email conflict: web admin@ vs app support@.
5. `delete-account-page.tsx` from task brief doesn't exist on web — confirm scope item obsolete.
6. Apple Sign-In button (App Store requirement) has no web equivalent — assumed keep, placed per web order.
