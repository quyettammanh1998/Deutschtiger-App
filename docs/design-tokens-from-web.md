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

**Audit + migrate 17/07/2026 (UI-FIDELITY P12 wave B → các pass dark-mode):**
Wave B audit ban đầu đếm **36 file release-visible** còn đọc static token —
nhưng chỉ đếm màn route, CHƯA đếm các widget mà màn đó render. Đếm lại theo
toàn bộ `lib/screens|features|widgets` ra ~56 file match.

Đã migrate xong qua 4 pass (báo cáo:
`fullstack-developer-260717-0641-dark-mode-static-token-migration-report.md`,
`…-0655-dark-mode-screens-remainder-report.md`,
`…-0655-dark-mode-features-widgets-remainder-report.md`,
`…-0730-auth-dark-mode-final-pass-report.md`):

**Trạng thái hiện tại: 0 file release-visible đọc static light token màu**
(trừ `lib/screens/affiliate/**` — plan chốt NGOÀI SCOPE, giữ hiện trạng).
Kiểm chứng:
```
grep -rEl '(DesignTokens|AppColors)\.(primary|background|foreground|card|muted|border|success|warning|destructive|accent|secondary|sidebar|ring|input|authBackground)\b' \
  lib/screens/ lib/features/ lib/widgets/ | grep -v affiliate    # → rỗng
```

Màu CỐ ĐỊNH có chủ đích (không phải vi phạm, đã ghi comment tại chỗ):
brand orange `tigerOrange`; pastel accent per-tab của bottom nav; trang
forgot/reset password nền tối `#050118` (web cũng vậy); welcome marketing
palette port thẳng từ CSS web; nền trang auth `#FFFBF5` (web dùng literal
`bg-[#FFFBF5]`, không phải token → giữ literal `_authPageBackground`, dark
dùng `context.tokens.background`).

**Đã đóng 17/07/2026 (báo cáo:
`fullstack-developer-260717-0801-hardcoded-colors-dark-mode-fix-report.md`):**
5 file panel/text hardcode `Colors.white`/`Colors.grey.shade*`/`Colors.black87`
(nền panel, text, border/divider) → chuyển sang `context.tokens.card` /
`.foreground` / `.mutedForeground` / `.border` / `.muted`:
`streak_claim_modal.dart`, `vocabulary_detail_panel.dart`,
`video_notes_panel.dart` (đã theme-aware sẵn, không cần sửa),
`transcript_panel.dart`, `chat_history_sidebar.dart`. Màu status/semantic
(CEFR badge, gender badge, streak reward amber/green tint, text/icon trên nền
màu) giữ nguyên có chủ đích — xem báo cáo để biết lý do từng chỗ giữ.
Test dark-mode surface: `test/widgets/dark_mode_surface_colors_test.dart`.

**Còn nợ:** không còn — gap dark-mode cuối cùng đã đóng.

Lưu ý: không phải mọi match `DesignTokens.` đều là màu — các hằng số
spacing/radius (`spacingXs`, `cardPadding`, …) không phụ thuộc theme, không
tính là vi phạm dark-mode dù match regex.

**Migration 17/07/2026 (dark-mode static-token migration, đóng acceptance
criterion cuối của plan):** của 34 file report ở trên, 1 file
(`save_article_words_cta.dart`) đã được xác nhận là false-positive (chỉ có
`DesignTokens.spacingXs`, không phải màu) — còn lại **33 file thật sự có
màu light-only cần migrate**. Migrate cả 33 file (4 file trong đó hoá ra đã
theme-aware sẵn, không cần sửa: `read_listen_hub_screen.dart`,
`reading_leaderboard.dart`, `reading_detail_screen.dart`,
`news_leaderboard.dart`; 29 file còn lại được sửa thật). Mọi màu semantic
(`background/foreground/muted/mutedForeground/card/cardForeground/primary/
primaryForeground/secondary/accent/border/ring/destructive/success/warning/
brand/brandDark/sidebar`, kể cả các biến thể `dark*` deprecated dùng trong
ternary `isDark ? ... : ...` thủ công) đã chuyển sang `context.tokens.X`.

Kết quả: `flutter analyze` 0 lỗi, 33 info (bằng baseline, **0**
`deprecated_member_use` warning còn lại trong toàn bộ `lib/`); `flutter test`
747/747 xanh (không đổi so với baseline). Không còn file release-visible nào
đọc `DesignTokens.`/`AppColors.` cho **màu** — các match còn sót lại trong 33
file (grep vẫn ra) đều là hằng số **không phải màu** hoặc màu **cố ý giữ cố
định theo thiết kế** (xem danh sách loại trừ dưới), không phải vi phạm
dark-mode:
- Spacing/radius: `spacingXs/Sm/Md/Lg/Xl`, `radius`, `radiusSm`,
  `cardPadding`, `screenHorizontalPadding`.
- Màu tiện ích cố định cả 2 theme (không nằm trong `AppTokens`, không bị
  deprecate): `tigerOrange`, `tigerOrangeDark`, `orange50/100/500/600`,
  `rose600`, `authBackground` (nền trang auth cố ý tối màu theo thiết kế,
  không đổi theo `Brightness`), `error`, `primaryGradient`, `shadowSm`.

Chi tiết per-file (số lần migrate thật + ghi chú non-obvious) trong
`plans/reports/fullstack-developer-260717-0641-dark-mode-static-token-migration-report.md`.
Acceptance criterion "Dark mode theo palette web trên mọi màn rebuild;
không màn release-visible nào còn đọc static light token" của plan
`260716-2324-web-mobile-ui-100-fidelity` coi như **đã đóng** (colour-only
scope; không đổi layout/behaviour).

**Migration 17/07/2026 (bổ sung — shared widgets remainder, `lib/features/**`
+ `lib/widgets/**`):** pass trước chỉ đếm 33 route-SCREEN file; các shared
widget mà những màn đó render (`lib/features/**`, `lib/widgets/**`) chưa
từng được audit riêng nên vẫn còn màu light-only. Quét lại bằng regex tương
tự → 14 file có match: `lib/features/games/widgets/game_base.dart`,
`lib/features/voice/presentation/widgets/record_button.dart`,
`lib/features/premium/presentation/premium_screen.dart`,
`lib/features/vocabulary/presentation/widgets/detail_widgets.dart`,
`lib/widgets/dashboard/streak_claim_modal.dart`,
`lib/widgets/common/async_state_views.dart`,
`lib/widgets/common/minimal_shell.dart`,
`lib/widgets/vocab_search/vocabulary_detail_panel.dart`,
`lib/widgets/interview/video_notes_panel.dart`,
`lib/widgets/interview/transcript_panel.dart`,
`lib/widgets/ai/chat_history_sidebar.dart`,
`lib/widgets/speaking/pronunciation_practice_widget.dart` (12 file có màu
thật cần migrate) + `lib/features/exam/presentation/widgets/exam_provider_cards.dart`
(đã theme-aware sẵn, match chỉ là `cardPadding` — false positive) +
`lib/widgets/common/gradient_button.dart` (chỉ dùng `AppColors.primaryGradient`
cố định, không phải màu semantic — false positive). Migrate hết
`background/foreground/muted/mutedForeground/card/border/primary/success/
destructive` sang `context.tokens.X`. Giữ nguyên cố định (không migrate, có
lý do): `AppColors.tigerOrange`/`AppColors.error`/`AppColors.authBackground`/
`AppColors.orange50`/`AppColors.rose600`/`AppColors.cardBackground`/
`AppColors.primaryGradient` (cùng lý do như bảng loại trừ ở trên — brand
orange cố định + màu tiện ích ngoài `AppTokens`).

Gap còn lại (không phải static-token nên ngoài phạm vi regex, nhưng vẫn ảnh
hưởng dark mode — ghi nhận để pass sau xử lý nếu cần visual QA riêng): nhiều
widget trong scope này dùng `Colors.white`/`Colors.grey.shade*`/`Colors.black87`
làm nền/màu chữ cứng (`streak_claim_modal.dart`, `vocabulary_detail_panel.dart`,
`video_notes_panel.dart`, `transcript_panel.dart`, `chat_history_sidebar.dart`)
— các literal này không đọc từ `DesignTokens`/`AppColors` nên không match
grep, không bị coi là vi phạm acceptance criterion (chỉ tính static-token
reads), nhưng dark mode ở các panel đó vẫn sẽ hiện nền trắng cứng khi
`Brightness.dark`.

Kết quả pass này: `flutter analyze` 0 lỗi (issue count không đổi so với
baseline ngoài phạm vi của 2 sibling agent song song); `flutter test`
747/747 xanh (không đổi). Chi tiết per-file trong
`plans/reports/fullstack-developer-260717-0655-dark-mode-features-widgets-remainder-report.md`.
Phần `lib/screens/**` (do agent khác xử lý song song cùng thời điểm) — xem
báo cáo riêng `plans/reports/fullstack-developer-260717-0655-dark-mode-screens-remainder-report.md`
nếu đã tồn tại; nếu chưa, số liệu phần đó coi như pending tại thời điểm ghi
chú này.

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
