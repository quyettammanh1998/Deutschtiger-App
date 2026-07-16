# Phase 08 — Exam core & community

Scout: `scout-260716-2324-ui-fidelity-exam-core-community-report.md`.
Quyết định IA (unresolved #1 report): adopt routing web landing → section →
list/set detail → skill list; catalog phẳng hiện tại thay bằng IA web + redirect.

**Chạy 2 wave (v2 — phase quá lớn cho 1 pass):**
- Wave A: landing residuals, section, list, skill-list, readiness, schedule,
  dictation, de-thi ×2, community ×2.
- Wave B: mobile player rebuild + result (khối lớn nhất, cần wave riêng).

Contract mới (nếu có) theo rule contract-trước-code của plan.md.

## Màn & verdict

| Web | Flutter target | Việc |
|---|---|---|
| `exam-landing-page.tsx` | `exam_screen.dart` + `exam_provider_cards.dart` | Residuals: provider shortDesc, buddy-CTA subtitle, label "Đề xuất", mismatch dialog, pill tap → navigate (bỏ filter inline), dark variants |
| `exam-section-page.tsx` | mới | Provider/level route: bundle chooser, book-cover grid, readiness card |
| `exam-list-page.tsx` | thay `exam_catalog_list.dart`/`exam_list_page.dart` | Numbered rows + completion states, part cards (skill-tinted icon, 3 action pills), leaderboard, pagination, premium lock |
| `exam-skill-list-page.tsx` | mới | Skill-scoped list + chip rows "Từ vựng" cho dictation |
| `exam-practice-page.tsx` + `src/components/exam/mobile/*` (6 file) | `features/exam/presentation/exam_practice_page.dart` | Rebuild player theo mobile-test/practice-layout: compact header (progress bar, pace dot, "Nộp bài" xanh), whole-Teil scroll, footer ô xanh + counter pill hổ phách, nav sheet nhóm Teil + màu ngữ nghĩa, dark mode. **In-scope (v2, reviewer soi thiếu):** reader settings/guide, highlight toolbar, tap-word lookup, "Dịch đoạn văn", locked-audio state, review comments |
| `exam-result-page.tsx` | `exam_result_page.dart` (features) | Smart review card, next-action, attempt history, comments; token exam |
| `exam-readiness-page.tsx` | `exam_readiness_screen.dart` | PageIntro, goal header, trend, stat pills, fail-words checklist, band range bar màu |
| `exam-schedule-page.tsx` | `exam_schedule_screen.dart` | Pill tabs, dải count cam, aside, trust block |
| `exam-dictation-page.tsx` | `exam_dictation_screen.dart` | Menu 3 hoạt động (cloze/dictation/karaoke), word-selection prep + sticky chip/start bar |
| `de-thi-list-page.tsx` | `de_thi_list_screen.dart` | Hero, level/year pills, promo banner, FAQ/stats/testimonials/footer — port đủ theo web (trust blocks nằm trong mục tiêu 100%; sửa pointer sai ở v1) |
| `de-thi-practice-page.tsx` | `de_thi_practice_screen.dart` | Paginated passages, header submit, progress strip, dot footer, retry, persistence |
| `community-exams-page.tsx` | `community_exams_list_screen.dart` | Tabs/filters/search + RealExamBadge; contribute CTA (write vẫn gate GĐ2 P3) |
| `community-exam-detail-page.tsx` | `community_exam_detail_screen.dart` | 6 structured content cards, badges; report/„Tôi vừa thi" theo gate hiện có |

## Xóa

- `exam_hub_screen.dart` + `exam_hub_card.dart`, `screens/exam/exam_result_page.dart`
  (dead), `exam_list_page.dart` (hardcode Goethe B1), `_CatalogFilters`/`_ExamCatalogCard`
  (IA Flutter-only). `exam_dictation_picker_screen.dart`: thay bằng flow web.
- Cập nhật guard list + release_redirect theo protocol plan.md (IA mới đổi route sâu).

## Validation

- Exam draft/attempt contracts giữ nguyên (WAVE P1 evidence) — chỉ thay UI.
- Player: test Lesen + Hören thật; nav sheet; submit; resume draft.
- analyze + `test/features/exam*` pass; screenshot player so mobile-test-layout.

## Risks

- Player rebuild lớn nhất plan — tách widgets `features/exam/presentation/widgets/mobile_player/`.
- IA mới đổi route sâu → redirect map đầy đủ trong `app_router.dart`.
