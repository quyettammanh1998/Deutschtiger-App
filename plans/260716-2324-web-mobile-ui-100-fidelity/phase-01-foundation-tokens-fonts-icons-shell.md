# Phase 01 — Foundation: tokens, fonts, icons, primitives, shell, assets

Chặn mọi phase khác. Scout: `plans/reports/scout-260716-2324-ui-fidelity-shell-theme-auth-legal-report.md`.

## Context (web refs)

- Tokens: `thamkhao/deutschtiger-frontend/src/index.css` (`:root` + `.dark`)
- Shell: `src/components/layout/bottom-nav.tsx`, `page-layout.tsx`,
  `src/components/dashboard/more-features-sheet.tsx`
- Icons: `src/lib/shared/feature-icons.tsx` (inline Phosphor-style SVG)
- Primitives: `src/components/ui/button.tsx` + CSS `.card`/`.card-sm`/`.btn-*`
- Fonts: `public/fonts/` — Inter 400-700, Grandstander 700 (latin+vietnamese),
  Fredoka One 400

## Requirements

1. **Hotfix build**: tạo `lib/screens/journey/widgets/journey_daily_plan_step_row.dart`
   (đang bị import bởi `journey_daily_plan_section.dart` nhưng không tồn tại)
   hoặc gỡ import — app phải compile trước mọi việc khác.
2. **Tokens** (spec v2 sau review — adapter "static getter đọc theme" là bất khả
   thi vì static không có BuildContext; thay bằng mô hình 2 lớp):
   - Tạo `ThemeExtension` `AppTokens` với instance light + dark đầy đủ theo
     `index.css` (`:root` dòng 68… + `.dark` dòng 108…): light primary
     `hsl(32,93%,54%)` cam, dark primary `hsl(200,85%,65%)` xanh, ring, sidebar,
     darkPrimaryForeground, darkDestructive, darkSidebar, darkBrand,
     darkSuccess/Warning (scout liệt kê từng token sai). Truy cập:
     `context.tokens.primary`.
   - Static consts cũ trong `design_tokens.dart` (129 file dùng) + `AppColors`
     (142 file): SỬA GIÁ TRỊ light cho đúng web rồi ĐÓNG BĂNG (đánh dấu
     `@Deprecated('dùng context.tokens')`), KHÔNG migrate hàng loạt tại P1 —
     mỗi màn migrate khi phase của nó rebuild (P2–P12 rebuild toàn bộ màn nên
     migration tự hoàn tất; acceptance cuối ở P12 wave B).
   - Màn mới/rebuild CẤM đọc static token.
   - Cập nhật `docs/design-tokens-from-web.md` (đang ghi primary hồng — lỗi thời).
3. **Fonts**: bundle TTF Inter (400/500/600/700), Grandstander 700,
   Fredoka One 400 vào `assets/fonts/` + khai báo pubspec (bỏ phụ thuộc runtime
   google_fonts cho 3 font này); textTheme: body=Inter, headings=Grandstander,
   brand=Fredoka One. Nguồn: Google Fonts (subset latin+vietnamese) hoặc convert
   woff2 từ `public/fonts/`.
4. **Icon system** (v2 — web dùng `@phosphor-icons/react` trong 205 file,
   ~125 icon distinct, feature-icons.tsx chỉ là ~20 icon bespoke):
   - Thêm package `phosphor_flutter` (cùng bộ glyph Phosphor) → phủ ~125 icon
     chuẩn; tạo doc mapping `lib/core/icons/README` hoặc constants file
     `app_phosphor_icons.dart` để các phase tra tên web→Flutter.
   - Port riêng ~20 SVG bespoke từ `feature-icons.tsx` vào `lib/core/icons/`
     (flutter_svg đã có trong pubspec). API: `AppIcons.home(size, color)`.
5. **Primitives** (`lib/widgets/common/` — check module hiện có trước):
   - Card: light = shadow-only không viền; dark = border; radius 16.
   - Button: cao 40px, radius 8, variants `.btn-primary/secondary/ghost/outline`.
   - `PageIntro` — **spec đính chính 17/07** (đọc `src/components/shared/page-intro.tsx`):
     KHÔNG phải "tiêu đề + mô tả". Web = strip "Mỗi màn 3 câu" thu gọn được:
     `why`/`todo`/`next` + CTA optional, viền `rounded-xl border-border bg-muted/40`,
     nhớ trạng thái collapse per `pageKey` (device-local `pi:{pageKey}`).
     Flutter dùng SharedPreferences cho persistence.
   - Pill/badge, sticky bottom CTA bar, gradient section header.
   - `GameShell`: header đồng nhất + exit guard + GameWallOverlay/FreeLimitOverlay
     (gate flag premium) + completion confetti+XP (tái dùng `confetti_overlay.dart`
     có sẵn; spec trong scout flashcard-grammar-games).
   - **Hoisted (v2 — nhiều phase dùng chung, tránh dependency ngầm):** umlaut
     input bar + text-diff view (P4/P9), markdown/HTML renderer đủ tables/
     images/audio (P6/P11 — chọn package maintained, vd `markdown_widget`),
     selection-lookup + save-words CTA (P11 reading/news).
6. **Router split**: tách `lib/navigation/app_router.dart` (987 dòng) thành
   `lib/navigation/routes/{domain}_routes.dart` per-domain để P2–P11 sở hữu
   file riêng, không conflict (protocol trong plan.md). Ranh giới `/games/*`:
   P4 sở hữu cloze/flashcards/matching/writing, P7 phần còn lại.
7. **Bottom nav rebuild** (`lib/widgets/common/app_shell.dart`): 64px nền
   cream/95 + blur, pastel pill per-tab (amber/indigo/emerald/teal), label 10px,
   tabs: Trang chủ `/` · Thi `/exams` · Học `/learn` (match thêm /daily-review,
   /vocabulary) · Hội thoại `/conversation` · Thêm (sheet). Đã chốt: tab 4 =
   Hội thoại (AI vào sheet Thêm); tới khi P10 ship hub, tab 4 trỏ màn hub
   gate hiện có.
8. **More-features sheet**: đổi bottom sheet → centered scale-in dialog, 4 cột,
   tile 44px rounded-2xl, catalog nhóm/mục giống `more-features-sheet.tsx`
   + 1 mục AI (app-only exception đã chốt — web sheet không có AI; comment rõ
   trong catalog code).
9. **Assets sync**:
   - từ repo: `public/tiger-icon.svg`, `deutsch-tiger-logo.svg`, `images/anh1.webp`,
     `images/game/tiger-frames/*` (7), `images/game/obstacles/*` (9),
     `images/game/game-icon.webp` (deutsch-runner), `icons/bulb.webp`
     (dialog-runner + sprechen-input-area, P10 cần);
   - từ server deploy (làm ĐẦU phase để khỏi block về sau):
     `deutschtiger:~/dist/images/quotes/quote-*.webp` (20 ảnh) → `assets/images/quotes/`;
   - khai báo pubspec, tối ưu dung lượng (webp giữ nguyên).

## Files

- Modify: `lib/core/design_tokens.dart`, `lib/core/theme/app_theme.dart`, `pubspec.yaml`,
  `lib/navigation/app_router.dart` (tách per-domain),
  `lib/widgets/common/app_shell.dart`, `lib/shared/widgets/more_features_sheet.dart`,
  `docs/design-tokens-from-web.md`
- Create: `lib/screens/journey/widgets/journey_daily_plan_step_row.dart`,
  `lib/core/icons/*`, `lib/widgets/common/{page_intro,app_card,app_button,app_pill,sticky_cta_bar,game_shell}.dart`,
  `assets/fonts/*`, `assets/images/{quotes,game}/*`

## Validation

- `flutter analyze` sạch; `flutter test test/structure/ test/l10n/` pass.
- Golden/widget test cho bottom nav (5 tab, active pill màu đúng từng tab).
- Screenshot app shell light+dark so với web 390×844.

## Risks

- Đổi primary hồng→cam ảnh hưởng MỌI màn cũ → chấp nhận (mục tiêu 100% web);
  rủi ro test thấp (không golden test, token test chỉ assert existence) nhưng
  chạy full suite sau đổi token.
- Token 2 lớp: static cũ đóng băng + deprecated, màn migrate theo phase rebuild
  của nó — KHÔNG mass-migrate 271 file tại P1.
- Quyết định #1/#2 (tab 4 = Hội thoại, dark mode làm ngay) đã chốt 16/07.
