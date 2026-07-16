# Review synthesis — plan web-mobile-ui-100-fidelity (pre-code)

3 reviewer song song (completeness · feasibility · rules-conflicts), 17/07/2026.
Nguồn: `reviewer-260716-2353-ui-fidelity-plan-{completeness,feasibility,rules-conflicts}-report.md`.
Plan đã cập nhật lên **v2** — disposition từng finding dưới đây.

## CRITICAL (3/3 fixed)

| # | Finding | Disposition |
|---|---|---|
| C1 | Parallel-safety claim sai: 9 phase đụng `app_router.dart` 987 dòng; guard test hardcode ~170 path crash khi xóa file; generated l10n git-tracked conflict | FIXED — plan.md thêm §"Điểm chạm dùng chung — protocol merge" (router split per-domain ở P1 §6, guard-list update bắt buộc mỗi PR, gen-l10n lại thay vì hand-merge, providers.dart thêm-only, commit baseline trước P1) |
| C2 | Token adapter "static getter đọc theme" bất khả thi (không có BuildContext); blast radius 271 file chưa budget | FIXED — P1 §2 viết lại: ThemeExtension AppTokens + static cũ sửa giá trị light rồi đóng băng @Deprecated; migrate per-màn theo phase rebuild; acceptance dời P12 wave B |
| C3 | P9 chiếm scope GĐ2 P2 schreiben không tuyên bố; thiếu frontmatter quan hệ | FIXED — plan.md thêm §Supersede (GĐ2 P1/P2 UI, MASTER P8 → wiring-only, PARITY visual-rebuild, WAVE ưu tiên trước) + frontmatter `supersedes-ui-scope-of`; P9/P10/P11 thêm note supersede |

## IMPORTANT (11/11 fixed)

1. Sprint cheatsheet page (routes.tsx:521) unowned → thêm vào P9 mục 4.
2. `/profile` + EditProfileScreen orphan → P12: `/profile` render public-profile
   của mình, EditProfile gộp settings profile-edit card, xóa màn cũ + redirect;
   ghi vào Quyết định #3e.
3. 5 màn game legacy routed không ai xóa + P4/P7 đụng `/games/*` → P4 own 4
   route practice + xóa 5 file legacy; `/games/writing-sentence` xóa không
   redirect; ranh giới router P4/P7 ghi ở plan.md + P1 §6.
4. Thiếu assets bulb.webp + game-icon.webp → P1 §9.
5. Hidden deps P3→P4, P5→P4, P9→P4, P11→P6 → bảng phase plan.md sửa deps;
   umlaut bar/diff/markdown renderer/selection-lookup hoist lên P1 §5.
6. Icon system underscoped ~6x (125 icon Phosphor/205 file) → P1 §4 dùng
   `phosphor_flutter` + ~20 icon bespoke port tay + mapping doc.
7. Phase sizing → P8 2 wave, P9 4 wave bắt buộc, P11 4 wave bắt buộc, P12 2 wave.
8. Guard test crash/weaken khi xóa màn → protocol plan.md #2 (mọi phase cập
   nhật list, cấm weaken; cảnh báo regex mock|fixture|placeholder).
9. Tab 4 `/conversation` đang gated → Quyết định #1 bổ sung release coordination:
   tab 4 hiện theo flag speech/P10-live, trước đó release giữ tab AI;
   `/conversation` vào release_redirect.
10. Contract-first docs mandate chỉ có ở P9 → chuyển thành Nguyên tắc chung
    plan.md (áp P8/P9/P10/P11).
11. P11 vs GĐ2 P1 (voice condition, YouTube ToS) + P12 duel mock mới vs no-mock
    rule → P11 giữ 2 điều kiện GĐ2 P1; P12 duel = UI shell only, không mock mới,
    live loop thuộc GĐ2 P3 (Quyết định #9).

## MODERATE (fixed trong v2)

- Path sai: `lib/core/theme/app_theme.dart` (P1), WritingPracticePanel =
  `src/components/writing/writing-practice-panel.tsx` (P9).
- P8 player thiếu reader features (settings/guide, highlight toolbar, word-lookup,
  dịch đoạn văn, locked audio, comments) → ghi in-scope.
- De-thi trust blocks pointer sai → sửa: port đủ theo web.
- P5 thiếu MyNotesSection compact → thêm.
- Quotes webp phụ thuộc SSH → P1 §9 ghi làm đầu phase.
- L10n exception (legal/trainer copy inline VN) → ratified ở Nguyên tắc chung.
- Leaderboard `weekly_score` + tab Bạn bè gate → Quyết định #10 + P12.
- Golden baseline WAVE P5 vs P1 token change → Ghi chú sự cố plan.md.
- exam_hub_card, empty dirs, home badge note → P8/P12 sweep.
- Dirty main baseline → protocol #6: commit trước P1.

## Không áp (với lý do)

- Reviewer đề nghị cân nhắc bỏ mục AI khỏi sheet Thêm (web không có): GIỮ vì
  là app-only exception có chủ đích (AI tab bị thay bằng Hội thoại, AI vẫn cần
  entry point) — đánh dấu exception trong code catalog.

## Verified-good (không cần đổi)

Coverage ~95% từ đầu; 5/5 spot-check spec đúng web source; deferred decisions
(affiliate/SePay/calls) không vi phạm; backend contracts writing/sprechen tồn
tại; hotfix journey đặt đúng P1; pink→cam rủi ro test thấp.

## Unresolved questions — ĐÃ GIẢI 17/07 (đọc code, plan v2.1)

1. WAVE P3 "pending" = stale (surfaces LIVE 16/07 qua PARITY) → plan.md ghi
   done-by-evidence khi chạy.
2. Grammar-articles: `GrammarArticlesSection` là dead code trên web (không
   render ở đâu; route article vẫn live) → P6: xóa list Flutter, giữ article
   page + route, không dựng entry.
3. Bonus resolved: leaderboard field = `weekly_score ?? weekly_xp`
   (weekly-leaderboard.tsx:112); vocab slug resolve client-side từ
   `GET /vocabulary/topics` — không cần endpoint mới; sprint SM-2 due = absolute
   ISO timestamps → Hive/prefs restart-safe; ⚠ mới: sprint mindmap steps dùng
   markmap+mermaid — P9 ghi phương án WebView/custom tree.
4. ĐÃ XONG: spec chi tiết goethe-b1-writing-detail (thực tế 30+ component, không
   phải 15) → `scout-260717-0014-goethe-b1-writing-detail-components-spec-report.md`,
   đã link vào P9 W2 kèm 8 điểm dễ sai (autoplay inline↔fixed, TOC≠DOM order,
   3 phosphor icon only, uebungen AI grading, typing suite, official lock,
   client Google Translate).

Không còn câu hỏi mở — plan sẵn sàng thi công (v2.1).
