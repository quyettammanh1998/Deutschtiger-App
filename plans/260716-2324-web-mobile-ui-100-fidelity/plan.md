---
title: "Web-Mobile UI 100% Fidelity — rebuild mọi màn Flutter giống hệt web frontend (mobile viewport)"
description: >-
  Audit 16/07/2026 (9 scout reports) đối chiếu ~140 trang web (mobile <768px)
  với 142 màn Flutter. Mục tiêu: mọi màn Flutter giống 100% web về bố cục,
  block order, màu sắc, icon, typography, dark/light. Cho phép xóa code màn cũ
  để làm lại. Đã qua review 3-reviewer 17/07 (v2).
status: done (17/07/2026, P1–P12 wave B; visual QA outstanding — see Acceptance)
priority: P1
branch: main
tags: [flutter, ui-fidelity, web-parity, rebuild]
created: "2026-07-16T23:24:00+07:00"
updated: "2026-07-17T00:05:00+07:00"
createdBy: "claude"
source: ui-fidelity-scout-260716 + plan-review-260717
blockedBy: []
blocks: []
supersedes-ui-scope-of:
  - 260715-flutter-gd2-extended-coverage (P1 media UI, P2 schreiben UI)
  - 260710-1644-flutter-port-phase-0-to-8 (P8 — thu hẹp còn voice wiring)
---

# Web-Mobile UI 100% Fidelity (v2 — sau plan review)

## Nguồn sự thật

- Web reference: `thamkhao/deutschtiger-frontend` — **đã sync từ server prod
  16/07/2026** (`deutschtiger:/opt/quangcuong/deutschtiger-frontend`, commit
  `85aadef`). Backend tham khảo: `thamkhao/deutschtiger-backend` (`6e630a4`).
- Mobile viewport = default tailwind classes; `md:`/`lg:` = desktop, bỏ qua.
- 9 scout reports chi tiết từng màn: `plans/reports/scout-260716-2324-ui-fidelity-*-report.md`.
- 3 review reports (đã áp vào v2): `plans/reports/reviewer-260716-2353-ui-fidelity-plan-{completeness,feasibility,rules-conflicts}-report.md`
  + synthesis `plans/reports/review-synthesis-260717-0002-ui-fidelity-plan-report.md`.

## Quan hệ với các plan khác (SUPERSEDE — chốt 17/07)

- **GĐ2 P1 (media) + P2 (schreiben)**: plan này SỞ HỮU toàn bộ UI các mảng đó
  (P11, P9). GĐ2 giữ phần backend/push/data còn lại. Điều kiện GĐ2 P1 "dictation/
  shadowing sau voice permission" được giữ: record-path gate flag voice.
- **MASTER P8 (voice)**: thu hẹp thành wiring voice/STT/Azure PA vào UI do P10
  dựng; không tự dựng màn. MASTER P7 (IAP), P9–P10 giữ nguyên.
- **PARITY P1–P4 (đã done 16/07)**: plan này rebuild lại visual các màn đó —
  data layer giữ nguyên.
- **WAVE**: P1–P6 chạy như cũ; nếu WAVE P3 (live-surface flags) đụng file màn
  đang rebuild → WAVE đi trước, fidelity phase rebase. *Đã xác minh 17/07*:
  WAVE plan status "Pending" là stale — các surface P3 (stats/grammar/reading/
  listening) đã LIVE 16/07 qua PARITY; khi chạy plan này, đánh dấu WAVE P3
  done-by-evidence thay vì code lại.
- Khi bắt đầu chạy plan: cập nhật cột owner trong
  `docs/web-feature-parity-matrix.md` theo mục này.

## Kết quả audit (tóm tắt)

~40 màn MISSING, ~85 DIVERGENT, ~6 CLOSE. Gap hệ thống (ảnh hưởng mọi màn):

1. **Token sai**: Flutter `AppColors.primary` = hồng `#FF8FA3`; web light
   primary = **cam `hsl(32,93%,54%)`**, dark primary = xanh `hsl(200,85%,65%)`
   (`index.css:68/108`). `docs/design-tokens-from-web.md` lỗi thời (P1 cập nhật).
2. **Fonts chưa bundle**: app render Roboto; web = Inter (body), Grandstander
   (heading), Fredoka One (brand).
3. **Icon sai hệ**: web dùng `@phosphor-icons/react` (~125 icon / 205 file) +
   feature-icons.tsx; Flutter dùng Material Icons.
4. **Dark mode hỏng cấu trúc**: widget hardcode static light `DesignTokens`
   (129 file DesignTokens + 142 file AppColors / 503 file lib).
5. **Thiếu primitives dùng chung**: PageIntro, card shadow-only, button 40px/r8,
   pill/badge, sticky bottom CTA, GameShell, gradient headers, umlaut bar,
   diff view, markdown renderer, selection-lookup.
6. **Bottom nav khác web**: web = 64px cream blur, pastel pill per-tab, tab 4
   = Hội thoại; Flutter = Material bar, tab 4 = AI.
7. **Build đang hỏng**: `journey_daily_plan_step_row.dart` bị import
   (`journey_daily_plan_section.dart:10`) nhưng không tồn tại (P1 hotfix).

## Phases

| # | Phase | Phụ thuộc | Status |
|---|-------|-----------|--------|
| 1 | [Foundation: tokens, fonts, icons, primitives, shell, router split, assets](./phase-01-foundation-tokens-fonts-icons-shell.md) | — | **done 17/07** (visual QA dồn P12 wave B) |
| 2 | [Entry: welcome, auth, legal, home residuals, daily quote](./phase-02-entry-auth-home-quote.md) | P1 | **done 17/07** (3 pass: P2/P2a/P2b) |
| 3 | [Learn & journey](./phase-03-learn-journey.md) | P1, **P4** (runner tái dùng practice views) | **done 17/07** (report `fullstack-developer-260717-0247-p3-learn-journey-report.md`) |
| 4 | [Vocabulary & practice](./phase-04-vocabulary-practice.md) | P1 | **done 17/07** (4 pass: P4/P4b/P4c/P4d — P4d closed daily_review/subtitle_words/practice_screen selector+results) |
| 5 | [Decks/flashcards](./phase-05-decks-flashcards.md) | P1, **P4** (guided lesson tái dùng practice views) | **done 17/07** (report `fullstack-developer-260717-0247-p5-decks-flashcards-report.md`) |
| 6 | [Grammar](./phase-06-grammar.md) | P1 (markdown renderer từ P1) | **done 17/07** (report `fullstack-developer-260717-0217-p6-grammar-report.md`) |
| 7 | [Games](./phase-07-games.md) | P1 | **done 17/07** (2 pass: P7 + P7b deferred-items) |
| 8 | [Exam core & community — 2 wave](./phase-08-exam-core-community.md) | P1 | **done 17/07** (wave A + wave B player/result; wave B report notes named concerns, không blocking) |
| 9 | [Writing ecosystem — 4 wave BẮT BUỘC](./phase-09-exam-writing.md) | P1, P8 (IA exam) | **done 17/07** (4 wave: hub/panel → topic-detail → luyện-viết generic → Sprint v2/telc convergence, FINAL) |
| 10 | [Speech: sprechen, conversation, pronunciation](./phase-10-speech-conversation-pronunciation.md) | P1; voice live = MASTER P8 wiring | **done 17/07** (UI done, gated on `speaking` flag chờ MASTER P8 voice wiring — report notes named concerns, không blocking) |
| 11 | [Media — 4 wave BẮT BUỘC](./phase-11-media-reading-news.md) | P1 | **done 17/07** (4 wave: listening/podcast → youtube/video/interview → course → reading/news, FINAL; reading/news report notes named concerns, không blocking) |
| 12 | [Social/AI/stats/settings (wave A) + deletion sweep & QA (wave B)](./phase-12-social-stats-settings-cleanup.md) | wave A: P1; wave B: P2–P11 | **done 17/07** (wave B closes the plan; see phase-12 §Status) |

## Điểm chạm dùng chung — protocol merge (BẮT BUỘC, sửa lỗi "parallel" v1)

Các phase P2–P11 chỉ song song được khi tuân thủ:

1. **`lib/navigation/app_router.dart`** (987 dòng, 9 phase đụng): P1 tách
   thành route file per-domain (`lib/navigation/routes/{domain}_routes.dart`);
   sau P1 mỗi phase chỉ sở hữu file domain của mình. Ranh giới `/games/*`:
   P4 sở hữu 4 route practice-view (`cloze/flashcards/matching/writing`),
   P7 sở hữu phần còn lại.
2. **`test/structure/release_live_data_guard_test.dart`** (hardcode ~170 path):
   MỌI phase xóa/thêm màn release-visible PHẢI cập nhật danh sách guard trong
   cùng PR — xóa entry file đã xóa, thêm entry màn mới. Cấm weaken rule.
   Lưu ý guard cấm identifier `mock|fixture|placeholder` trong màn release.
3. **`lib/navigation/release_redirect.dart` + `allowsMoreFeature`**: mọi phase
   rename route phải thêm redirect path-cũ→mới và cập nhật gate keying.
4. **Generated l10n** (`lib/l10n/app_localizations*.dart`, git-tracked): không
   hand-merge — mỗi merge chạy lại `flutter gen-l10n` từ ARB đã merge.
5. **`lib/view_models/providers.dart`**: thêm-only, merge tuần tự.
6. Baseline: commit working tree hiện tại (main đang dirty) TRƯỚC khi P1 bắt đầu.

## Nguyên tắc chung (mọi phase)

- Web file trích trong scout report = spec; implementer PHẢI đọc TSX gốc trong
  `thamkhao/deutschtiger-frontend` trước khi code.
- Được phép xóa/viết lại màn cũ. Màn Flutter-only: xóa, TRỪ danh sách giữ (§Quyết định 3).
- **Contract trước code** (áp mọi phase dùng endpoint mới — P8/P9/P10/P11):
  probe response thật (curl/Go handler trong `thamkhao/deutschtiger-backend`),
  ghi `docs/flutter-api-contract-matrix.md` + `docs/api-changelog.md`.
- Data: giữ repo/provider live hiện có; màn gated giữ flag default-off; KHÔNG
  mock mới; guard live-data phải pass (xem protocol §trên).
- String UI mới → ARB vi/en/de + gen-l10n + test German 200%. **Ngoại lệ đã
  duyệt**: nội dung long-form web hardcode tiếng Việt (legal, trainer tips,
  SEO-style copy) giữ inline VN như web — không dịch.
- Token/màu: dùng theme-context tokens (P1); cấm thêm static light token mới.
- Mỗi màn xong: `flutter analyze` sạch + test domain pass.

## Acceptance (toàn plan)

- [ ] Mọi trang web mobile trong 9 scout reports có màn Flutter verdict
      CLOSE→MATCH (block order, màu, icon, font đúng web). **Chưa tick** —
      cần visual QA thật (screenshot so sánh), xem box cuối; P12 wave B chỉ
      làm route-sweep + dark-mode audit bằng code, không phải visual diff.
- [x] Không còn màn Flutter-only ngoài danh sách giữ đã chốt. (P12 wave B
      deletion sweep 17/07 — xóa moments/social-hub/groups/announcements-page/
      achievements/progress/reminders/home orphans; còn lại đúng danh sách
      giữ Quyết định #3 + challenges/duel gated giống web tự ẩn route.)
- [ ] Dark mode theo palette web trên mọi màn rebuild; không màn release-visible
      nào còn đọc static light token. **Chưa đạt** — audit 17/07 (P12 wave B)
      tìm thấy 36 file release-visible còn dùng `DesignTokens.`/`AppColors.`
      tĩnh; đã fix 2 file rẻ, còn 34 file cần một pass migrate có visual QA
      riêng (xem `docs/design-tokens-from-web.md` + wave-B report để có danh
      sách file đầy đủ).
- [x] Guard live-data + redirect map cập nhật đủ theo protocol; toàn bộ test pass.
      (17/07 — `flutter analyze` 0 lỗi, `flutter test` 747/747 xanh, guard
      test không bị làm yếu.)
- [x] `docs/design-tokens-from-web.md`, `docs/web-feature-parity-matrix.md`,
      contract matrix + api-changelog cập nhật. (17/07, P12 wave B.)
- [ ] Visual QA cuối: screenshot 390×844 light+dark từng màn so web (P12 wave B).
      **Ngoài phạm vi task này** — controller xử lý riêng (theo brief giao
      việc P12 wave B), cố ý không tick.

## Ngoài scope (giữ quyết định owner 15/07, không đổi)

Admin console, 26 trang SEO, PWA/service worker, SePay QR flow (mobile =
IAP-only), affiliate (giữ hiện trạng), WebRTC calls. Live voice/STT/Azure PA
hookup = MASTER P8 (wiring vào UI của P10/P11).

## Quyết định — ĐÃ CHỐT (owner 16/07, theo đề xuất; bổ sung review 17/07)

1. **Bottom nav tab 4**: đổi AI → "Hội thoại" theo web; AI vào sheet "Thêm"
   (mục AI là app-only exception — sheet web không có AI, ghi chú trong code
   catalog). *Release coordination*: P1 build UI 5 tab; tab 4 chỉ hiện khi flag
   speech bật HOẶC P10 hub đã live — trước đó release build giữ tab AI cũ, và
   `/conversation` thêm vào release_redirect. P1 + P10 phối hợp qua flag này.
2. **Dark mode**: làm ngay tại P1 theo palette dark web (primary xanh).
3. **Màn Flutter-only**: GIỮ (a) delete-account (store policy), (b) onboarding
   carousel, (c) settings ngôn ngữ/âm thanh/About, (d) notification center —
   style theo token web; (e) `/profile` giữ route: render public-profile view
   của chính mình (web `/u/:id`), EditProfile gộp vào profile-edit card của
   settings root (P12). XÓA: moments, groups, announcements page, vocab_search,
   speaking hub/shadowing tự chế, exam_hub cũ, quiz/*, achievements/progress/
   reminders orphans, 5 màn game legacy routed (P4), `/games/writing-sentence`
   (không web counterpart), empty dirs (danh sách trong từng phase).
4. **Route alignment**: route Flutter = path web + redirects (protocol §trên).
5. **Premium/paywall UI**: port visual lock/upsell web, CTA trỏ IAP flow
   (MASTER P7), không SePay; gate flag premium default-off.
6. **Welcome page**: port full marketing page theo web.
7. **Mission runner + daily review**: rebuild theo multi-game engine web.
8. **Interactive modes nặng**: full scope. Riêng shadowing/dictation record-path
   và mic flows: UI đầy đủ, record gate flag voice (GĐ2 P1 condition giữ).
9. **Duel (P12)**: rebuild UI shell theo web (room-code lobby, timer, overlays)
   nhưng KHÔNG viết logic mock mới; live loop + report/block vẫn thuộc GĐ2 P3,
   flag off tới khi GĐ2 P3 wire.
10. **Leaderboard field**: hiển thị theo web (`weekly_score` composite nếu web
    dùng — probe contract khi làm P12); tab "Bạn bè" gate theo flag social.

## Ghi chú sự cố

- 16/07: rsync `--delete` từ server ghi đè WIP local chưa commit trong
  `thamkhao/deutschtiger-frontend` (`delete-account-page.tsx`,
  `src/lib/account/account-service*.ts`). Không khôi phục được. Web hiện KHÔNG
  có trang delete-account → màn delete-account Flutter giữ theo store policy,
  spec từ WAVE P2.
- P1 golden/test baseline: đổi token hồng→cam rủi ro test THẤP (không có golden
  test; token test chỉ assert existence) — nhưng WAVE P5 nếu tạo golden baseline
  trước P1 thì P1 re-baseline lại.
