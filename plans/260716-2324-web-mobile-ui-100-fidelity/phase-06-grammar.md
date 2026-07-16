# Phase 06 — Grammar

Scout: `scout-260716-2324-ui-fidelity-flashcard-grammar-games-report.md` (grammar).

## Màn & verdict

| Web | Flutter target | Việc |
|---|---|---|
| `/grammar` (`grammar-list-page.tsx`) | `lib/features/grammar/presentation/grammar_screen.dart` | GrammarMap, leaderboard, sync banner; section accent-border + header gradient thay ExpansionTile |
| `/grammar/:level/:id` lesson | `grammar_lesson_detail_screen.dart` | Markdown/HTML renderer + formula + German-highlight; read-gate card (+5 XP) |
| `/grammar/articles/:l/:slug` | `grammar_article_screen.dart` | Markdown đầy đủ (tables/images/audio), level pill, source, gradient CTA |

## Việc kỹ thuật

- Markdown/HTML renderer: dùng renderer chung từ P1 primitives (v2 — đã hoist
  lên P1 vì P6 + P11 dùng chung); phase này chỉ thêm phần German-highlight +
  formula styling đặc thù grammar.
- Entry point danh sách articles — ĐÃ XÁC MINH 17/07: trên web,
  `GrammarArticlesSection` (components/grammar/grammar-articles-section.tsx,
  accordion 12 level + pill màu + Check icon) KHÔNG được render ở bất kỳ trang
  nào (dead entry); route bài viết vẫn live (routes.tsx:460), chỉ reach qua
  deep link. Theo web: XÓA list articles trong level-detail Flutter, GIỮ route
  + article page (deep-link parity), KHÔNG dựng entry point mới. Nếu web mount
  section sau này thì port theo spec file trên.

## Xóa

- `lib/screens/grammar/grammar_screen.dart` (orphan duplicate).

## Validation

- Render 3 loại content thật từ API (lesson markdown, formula, article có bảng).
- analyze + grammar tests pass.
