# Phase 02 — Entry: welcome, auth, legal, home residuals, daily quote

Scout: `scout-260716-2324-ui-fidelity-shell-theme-auth-legal-report.md` +
`scout-260716-2324-ui-fidelity-home-settings-stats-report.md`.

## Màn & verdict

| Web | Flutter target | Việc |
|---|---|---|
| `landing/welcome-page.tsx` | `lib/screens/auth/welcome_screen.dart` | Rebuild theo web: hero + phone mock, pills, stats, testimonials, footer, auth modal (đã chốt: port full) |
| `auth/login-page.tsx` | `lib/screens/auth/login_screen.dart` | Thứ tự form→divider→Google (Apple giữ, thêm cuối), inline alerts thay SnackBar, card top-anchored, dark variants |
| `auth/signup-page.tsx` | `lib/screens/auth/signup_screen.dart` | Thêm h1, confirm-password, min 8 ký tự, thứ tự form-first |
| `auth/forgot-password-page.tsx` | `forgot_password_screen.dart` | Rebuild: nền tối `#050118` + particle canvas (CustomPainter) + glass card |
| `auth/reset-password-page.tsx` | `reset_password_screen.dart` | Rebuild dark glass; success panel thay redirect thẳng |
| `legal/privacy-policy-page.tsx`, `terms-of-service-page.tsx` | `lib/screens/legal/*` | Sync nội dung + brand header Grandstander + dark mode; email `admin@` theo web (xác nhận lại vì app store cần support email — hỏi owner nếu lệch) |
| `dashboard-page` residuals | `lib/screens/home/home_screen.dart` | 4 diff: thêm ExamHeroCard branch + "Tiếp tục học" resume; bỏ MobileStatsCard thừa + grid "Khám phá" (web đã xóa); PremiumBanner đúng slot; header variant "📚 Đã học N từ" |
| `quotes/daily-quote-page.tsx` | `lib/screens/stats/daily_quote_page.dart` | Rebuild: full-screen vertical snap photo feed (PageView vertical), accent sage `#a8c686`, ảnh `assets/images/quotes/` (P1) |

## Xóa (Flutter-only, không web counterpart)

- `lib/features/landing/landing_screen.dart` + route `/landing`, `/welcome-full`
  (dead, nav hỏng); `lib/features/legal/*` (dupe chết).
- GIỮ: `onboarding_screen.dart` (Quyết định #3b), delete-account UI (#3a).

## Steps

1. Đọc TSX gốc từng trang trước khi code; port block order + màu + icon (AppIcons P1).
2. Legal: trích text từ web page; ARB không cần (nội dung dài giữ tiếng Việt inline như web).
3. Home: chỉ sửa residuals — không đảo lại các block đã match (report rebuild 0256 là baseline).
4. Xóa file chết + route; sửa `app_router.dart` + release redirects.

## Validation

- `flutter test test/features/home/ test/l10n/` + auth widget tests pass.
- Deep-link cũ `/landing` redirect về `/welcome`.
- Screenshot so web: welcome, login, forgot (dark glass), daily quote.

## Risks

- Particle canvas: dùng CustomPainter đơn giản, không thêm package nặng.
- ExamHeroCard cần provider readiness — dùng `examReadiness` contract có sẵn
  (xem unresolved #1 report home; nếu chưa có endpoint → `SizedBox.shrink()`).
