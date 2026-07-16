# Design Tokens — trích từ web `src/index.css`

Dùng để dựng `lib/core/theme/app_tokens.dart` (nguồn chân lý runtime) +
`app_theme.dart` cho Flutter, đảm bảo nhất quán thị giác với web.

## Kiến trúc 2 lớp (2026-07-17)

1. **`AppTokens`** (`lib/core/theme/app_tokens.dart`) — `ThemeExtension`
   đăng ký trên cả `ThemeData.light`/`ThemeData.dark` trong `app_theme.dart`.
   Đây là **nguồn chân lý** — dùng qua `context.tokens.primary`,
   `context.tokens.background`, v.v. Tự resolve đúng theo `Brightness` hiện
   tại (light/dark), có `copyWith`/`lerp` chuẩn Flutter theme-extension.
2. **`DesignTokens`/`AppColors`** (`design_tokens.dart`, `app_colors.dart`) —
   các static `Color` cũ, **chỉ còn giá trị light-theme và đã bị
   `@Deprecated`** cho phần màu semantic trùng với `AppTokens` (background,
   foreground, primary, border, …). Layout tokens (spacing/radius/shadow/
   gradient/typography) và các màu tiện ích không nằm trong `AppTokens`
   (orange500/600, emerald*, amber*, exam-*, auth colors) **không** bị
   deprecate — vẫn dùng bình thường.

Lý do đóng băng thay vì xoá: 271+ file đang tham chiếu `DesignTokens`/
`AppColors` trực tiếp; migrate hàng loạt nằm ngoài phạm vi P1. Code mới
**PHẢI** dùng `context.tokens`; code cũ tiếp tục compile (chỉ hiện info
"deprecated" khi `flutter analyze`, không phải lỗi).

**Audit 17/07/2026 (UI-FIDELITY P12 wave B, QA cuối):** 126 file trong `lib/`
còn tham chiếu `DesignTokens.`/`AppColors.`; đối chiếu với danh sách
release-visible trong `test/structure/release_live_data_guard_test.dart` →
**36 file release-visible** vẫn còn dùng static token (danh sách đầy đủ +
số lần dùng mỗi file trong báo cáo đóng plan
`plans/reports/fullstack-developer-260717-0549-p12-wave-b-deletion-sweep-qa-report.md`).
Đã fix 2 case rẻ trong lần sửa này (`error_patterns_list.dart` màu
`AppColors.success` → `context.tokens.success`; hàm chết
`readingLevelColor()` trong `reading_models.dart` bị xoá hẳn thay vì migrate).
34 file còn lại **CHƯA migrate** — số lượng đủ lớn để một lần swap cơ học
không giám sát rủi ro sai màu cao hơn lợi ích; để dành cho một pass migrate
có visual QA đi kèm (không phải phạm vi wave B, vốn chỉ là dọn dẹp + audit).
Lưu ý: không phải mọi match `DesignTokens.` đều là màu — các hằng số
spacing/radius (`spacingXs`, `cardPadding`, …) không phụ thuộc theme, không
tính là vi phạm dark-mode dù match regex.

## Light theme (`:root`) — giá trị ĐÚNG (đã sửa 2026-07-17)

> Trước đây `DesignTokens.primary` bị set nhầm thành hồng `#FF8FA3`
> (hsl(351,100%,78%)) — đây là dữ liệu **cũ/sai**, không khớp web. Bảng dưới
> là giá trị đã verify lại từ `thamkhao/deutschtiger-frontend/src/index.css`.

| Token | HSL | Hex (verified) |
|---|---|---|
| background | hsl(25, 47%, 97%) | #FBF7F4 |
| foreground | hsl(0, 0%, 18%) | #2E2E2E |
| muted | hsl(25, 10%, 95%) | #F4F2F1 |
| muted-foreground | hsl(25, 5%, 45%) | #78726D |
| card | hsl(0, 0%, 100%) | #FFFFFF |
| card-foreground | hsl(0, 0%, 18%) | #2E2E2E |
| **primary** (cam hổ) | hsl(32, 93%, 54%) | #F7911D |
| primary-foreground | hsl(0, 0%, 100%) | #FFFFFF |
| secondary | hsl(25, 82%, 89%) | #FADFCC |
| secondary-foreground | hsl(0, 0%, 18%) | #2E2E2E |
| accent | hsl(70, 50%, 85%) | #E6ECC6 |
| accent-foreground | hsl(0, 0%, 18%) | #2E2E2E |
| border / input | hsl(25, 10%, 90%) | #E8E5E3 |
| ring | hsl(32, 93%, 54%) | #F7911D |
| destructive | hsl(0, 84%, 60%) | #EF4343 |
| destructive-foreground | hsl(0, 0%, 100%) | #FFFFFF |
| sidebar | hsl(32, 50%, 95%) | #F9F3EC |
| sidebar-active | hsl(32, 93%, 54%) | #F7911D |
| success | hsl(142, 71%, 45%) | #21C45D |
| warning | hsl(38, 92%, 50%) | #F59F0A |
| **brand** (cam hổ) | hsl(32, 93%, 54%) | #F7911D |
| brand-dark | hsl(32, 93%, 46%) | #E27D08 |
| radius | 1rem | 16px |

## Dark theme (`.dark`) — giá trị ĐÚNG (đã sửa 2026-07-17)

| Token | HSL | Hex (verified) |
|---|---|---|
| background | hsl(220, 13%, 9%) | #14161A |
| foreground | hsl(0, 0%, 98%) | #FAFAFA |
| muted | hsl(220, 13%, 22%) | #31363F |
| muted-foreground | hsl(220, 9%, 72%) | #B1B5BE |
| card | hsl(220, 13%, 14%) | #1F2228 |
| **primary** (xanh) | hsl(200, 85%, 65%) | #5ABFF2 |
| primary-foreground | hsl(0, 0%, 98%) | #FAFAFA |
| secondary | hsl(220, 13%, 24%) | #353B45 |
| accent | hsl(200, 85%, 65%) | #5ABFF2 |
| border / input | hsl(220, 13%, 26%) | #3A3F4B |
| ring | hsl(200, 85%, 65%) | #5ABFF2 |
| destructive | hsl(0, 63%, 31%) | #811D1D |
| sidebar | hsl(220, 13%, 12%) | #1B1D23 |
| success | hsl(142, 71%, 45%) | #21C45D |
| warning | hsl(38, 92%, 50%) | #F59F0A |
| brand | hsl(32, 93%, 54%) | #F7911D |

> Light = cam hổ Đức. Dark = primary chuyển xanh dương. `AppTokens` đăng ký
> cả hai trong `app_theme.dart` (`extensions: [AppTokens.light]` /
> `[AppTokens.dark]`) — dark mode giờ đã dùng được qua `context.tokens`,
> không còn "để sẵn cho sau" như trước.

`DesignTokens.dark*` statics (deprecated) **không** được verify lại theo
bảng trên trong lần sửa này (out of scope: chỉ light bị coi là "sai" và cần
fix). Đừng dùng chúng cho code mới — dùng `AppTokens.dark` qua
`context.tokens` (Brightness.dark).

## UI components thật (từ src/pages/auth/login-page.tsx + tiger-logo.tsx)

Để bám sát web 1:1 (không tự chế):

| Element | Web | Flutter tương ứng |
|---|---|---|
| Icon library | **Phosphor** (`@phosphor-icons/react`) | ⚠️ `phosphor_flutter 2.1.0` KHÔNG tương thích Flutter 3.44 (IconData final class) → dùng **Material Icons** tương đương (Icons.visibility_outlined…) |
| Logo | **TigerLogo** SVG (con hổ cam + sao + chữ Deutsch/Tiger + 3 vạch cờ Đức) | `assets/logo/deutsch-tiger-logo.svg` qua flutter_svg → widget `TigerLogo` |
| App icon | `public/icons/icon-512x512.png`, maskable, apple-touch-180 | `assets/icons/` |
| Auth bg | `bg-[#FFFBF5]` kem ấm | `AppColors.authBackground` |
| Auth card | nền trắng, `rounded-2xl`, border `orange-100`, shadow-lg, max-w-sm | widget `AuthCard` |
| Input | bg `orange-50/60`, border `orange-100`, focus border cam, `rounded-lg` (8px) | `AuthTextField` |
| Nút chính | **gradient** `from-orange-500 to-rose-600`, text trắng, semibold | widget `GradientButton` + `AppColors.primaryGradient` |
| Link text | `text-orange-500` hover `orange-600` | `AppColors.orange500` |
| Logo màu | cam `#F7931E`, viền cam đậm `#E07D18`, sao đỏ `#DA251D` + vàng `#FFCC00` | `AppColors.tigerOrange` |

**Shared widgets đã tạo:** `TigerLogo`/`TigerIcon` (tiger_logo.dart), `AuthCard` (auth_card.dart), `GradientButton` (gradient_button.dart). Tái dùng cho mọi phase sau để nhất quán.

**Bài học rút ra:** Luôn ĐỌC component UI thật của web (không chỉ color tokens) trước khi dựng màn Flutter — để khớp logo, icon set, layout, gradient, spacing.
