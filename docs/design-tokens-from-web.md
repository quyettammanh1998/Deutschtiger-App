# Design Tokens — trích từ web `src/index.css`

Dùng để dựng `lib/core/theme/app_colors.dart` + `app_theme.dart` cho Flutter, đảm bảo nhất quán thị giác với web.

## Fonts
- **Sans (body):** Inter
- **Display (heading):** Grandstander → fallback Fredoka One
- **Brand:** Fredoka One
- **Radius:** `1rem` = 16px (border-radius mặc định)

## Light theme (`:root`)

| Token | HSL | Hex approx |
|---|---|---|
| background | hsl(25, 47%, 97%) | #FBF4EF |
| foreground | hsl(0, 0%, 18%) | #2E2E2E |
| muted | hsl(25, 10%, 95%) | #F3F1F0 |
| muted-foreground | hsl(25, 5%, 45%) | #76726F |
| card | hsl(0, 0%, 100%) | #FFFFFF |
| card-foreground | hsl(0, 0%, 18%) | #2E2E2E |
| **primary** (hồng) | hsl(351, 100%, 78%) | #FF8FA3 |
| primary-foreground | hsl(0, 0%, 100%) | #FFFFFF |
| secondary | hsl(25, 82%, 89%) | #FAE0CF |
| accent | hsl(70, 50%, 85%) | #E8EFC9 |
| border / input | hsl(25, 10%, 90%) | #E8E4E1 |
| ring | hsl(351, 100%, 78%) | #FF8FA3 |
| destructive | hsl(0, 84%, 60%) | #EF4444 |
| sidebar | hsl(351, 60%, 92%) | #F7DCE2 |
| sidebar-active | hsl(351, 100%, 78%) | #FF8FA3 |
| success | hsl(142, 71%, 45%) | #22C55E |
| warning | hsl(38, 92%, 50%) | #F59E0B |
| **brand** (cam hổ) | hsl(32, 93%, 54%) | #F59E1B |
| brand-dark | hsl(32, 93%, 46%) | #D9850E |

## Dark theme (`.dark`)

| Token | HSL |
|---|---|
| background | hsl(220, 13%, 9%) |
| foreground | hsl(0, 0%, 98%) |
| muted | hsl(220, 13%, 22%) |
| muted-foreground | hsl(220, 9%, 72%) |
| card | hsl(220, 13%, 14%) |
| **primary** (xanh) | hsl(200, 85%, 65%) |
| secondary | hsl(220, 13%, 24%) |
| accent | hsl(200, 85%, 65%) |
| border | hsl(220, 13%, 26%) |
| input | hsl(220, 13%, 24%) |
| ring | hsl(200, 85%, 65%) |
| destructive | hsl(0, 63%, 31%) |
| sidebar | hsl(220, 13%, 12%) |
| success | hsl(142, 71%, 45%) |
| warning | hsl(38, 92%, 50%) |
| brand | hsl(32, 93%, 54%) |

> Light = hồng/cam ấm (tone con hổ Đức). Dark = primary chuyển xanh. V1 chỉ cần light theme là đủ; dark để sẵn cho version sau.

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
