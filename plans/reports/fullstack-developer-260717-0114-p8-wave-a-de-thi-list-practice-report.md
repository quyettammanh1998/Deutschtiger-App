# De-Thi List + Practice Screen Rebuild — Report

Wave A / Group C, phase 8 web-mobile UI fidelity. Scope: rebuild 2 public
Flutter screens (`/de-thi`, `/de-thi/:code`) to full parity with
`de-thi-list-page.tsx` / `de-thi-practice-page.tsx`, including the SEO
trust-block content.

## Files Modified / Created

- `lib/screens/exam/de_thi_list_screen.dart` (113 LOC, rewritten)
- `lib/screens/exam/de_thi_practice_screen.dart` (167 LOC, rewritten — state container only)
- `lib/screens/exam/widgets/de_thi/de_thi_site_header.dart` (57)
- `lib/screens/exam/widgets/de_thi/de_thi_exam_card.dart` (110)
- `lib/screens/exam/widgets/de_thi/de_thi_promo_banner.dart` (74)
- `lib/screens/exam/widgets/de_thi/de_thi_faq_section.dart` (151)
- `lib/screens/exam/widgets/de_thi/de_thi_stats_testimonials_section.dart` (200)
- `lib/screens/exam/widgets/de_thi/de_thi_founder_cta_footer.dart` (143)
- `lib/screens/exam/widgets/de_thi/de_thi_passage_panel.dart` (188)
- `lib/screens/exam/widgets/de_thi/de_thi_question_card.dart` (130)
- `lib/screens/exam/widgets/de_thi/de_thi_question_option_row.dart` (119)
- `lib/screens/exam/widgets/de_thi/de_thi_question_reveal_blocks.dart` (161)
- `lib/screens/exam/widgets/de_thi/de_thi_practice_header.dart` (134)
- `lib/screens/exam/widgets/de_thi/de_thi_practice_progress_strip.dart` (182)
- `lib/screens/exam/widgets/de_thi/de_thi_practice_footer.dart` (191)
- `lib/screens/exam/widgets/de_thi/de_thi_practice_body.dart` (129)

All 16 files under the 200 LOC cap. No files outside my ownership touched;
no ARB/route/provider files edited.

## de-thi-list Screen — Done

Full rebuild matching `de-thi-list-page.tsx`: `DeThiSiteHeader` (logo +
"Đăng nhập" → pushes `/login`) → centered hero → exam cards (level pill,
amber year pill, title, skill, amber disclaimer, "Bắt đầu làm →" CTA, uses
`AppCard.interactive`) → mobile promo banner (orange-50 card, tiger logo,
"Thử ngay →", launches `https://deutschtiger.com` via `url_launcher`) →
FAQ accordion (5 hardcoded Q&A, chevron rotate) → "Giới thiệu Deutsch Tiger"
4-stat row (pink/blue/purple/green) → 3 testimonial cards (gradient avatar
circles, level pill) → founder quote card (48px tiger icon) → orange→amber
gradient CTA card → footer line. Desktop sidebar promo (`PromoSidebar`) was
**not** built — mobile app has no desktop breakpoint concept, so only the
`MobilePromoBanner` equivalent (always shown) was ported; this is the
correct mobile-parity choice, not an omission.

## de-thi-practice Screen — Done

Full rebuild to paginated single-passage flow (previously rendered all
passages in one scroll). `DeThiPracticeScreen` now owns state (`_answers`
map, `_submitted`, `_passageIndex`) and delegates all rendering to
`DeThiPracticeBody` + sub-widgets, mirroring the web page's structure:
header (back square, level pill, title, answered/total chip, "Nộp bài"
orange-gradient pill) → amber disclaimer strip → progress strip (before
submit: "Đoạn X/Y" + amber→orange bar + x/y; after submit: "N/M câu đúng" +
score pill + "Làm lại") → passage panel (translate toggle gated behind
`submitted`) → dashed-style divider → question cards (submit-all reveal:
translate + explanation toggles, correct/wrong highlighting) → footer
("Đoạn trước" / dot indicators, tap-to-jump / "Đoạn tiếp" or "Nộp bài" on
last passage).

Desktop web splits passage/questions into two independently-scrolling
columns (`md:flex-row`); mobile app (single-column phone viewport) uses one
scrollable `ListView` with passage panel above its questions — correct
mobile-parity choice (web's own mobile layout, `md:hidden` divider, is
single-column too).

## Persistence

Used `shared_preferences` directly (already a pubspec dependency, matches
`ExamAttemptStore`'s `lib/features/exam/data/exam_attempt_store.dart`
pattern) — no new deps added. Key: `de_thi_<code>`, value:
`{"answers": {"<questionNo>": "<optionKey>"}, "submitted": bool}`, mirroring
web's `localStorage` key `de-thi-{code}`. Restored on `initState`; cleared
on retry.

## Assets

No new asset files needed — `lib/widgets/common/tiger_logo.dart`
(`TigerLogo`/`TigerIcon`) already wraps `assets/logo/deutsch-tiger-logo.svg`
and `assets/logo/tiger-icon.svg` (already declared in pubspec.yaml,
`assets/logo/`), matching the web's `/deutsch-tiger-logo.svg` and
`/tiger-icon.svg`. Reused as-is.

## Data / Backend

No gaps. `DeThiRepository.listRegistry()` / `.findEntry()` /
`.fetchExam()` and `deThiExamProvider` used exactly as before — no fixtures,
no mock data. `DeThiQuestion.optionsDe`/`optionsVi`/`answer`/`explanationVi`
fields (from `exam_ecosystem_models.dart`) map 1:1 to what the practice
screen needs.

## Deviations from Web

- No desktop sidebar (web `lg:` breakpoint) — N/A for mobile app.
- Score formatting: kept web's `score` (0–10 scale, 2-decimal round) exactly
  (`(correctCount / totalQ * 10 * 100).round() / 100`).
- Footer submit icon: used `AppPhosphorIcons.caretRight` (web uses an inline
  chevron SVG) — equivalent glyph, no visual regression.

## ARB Strings Needed (coordinator to wire into l10n)

All new UI strings are either the approved-exception SEO/marketing copy
(kept hardcoded inline per instructions, NOT listed below) or short UI
labels. Reused existing getters where equivalent: `l10n.submitExam` ("Nộp
bài"), `l10n.retryExam` ("Làm lại"), `l10n.deThiListTitle`,
`l10n.deThiListEmpty`, `l10n.deThiNotFound`, `l10n.couldNotLoadData`.

New short strings hardcoded in Vietnamese, suggested ARB keys:

| Suggested key | Vietnamese | English | German |
|---|---|---|---|
| `deThiStartCta` | Bắt đầu làm → | Start now → | Jetzt starten → |
| `deThiLoginCta` | Đăng nhập | Log in | Anmelden |
| `deThiPromoTitle` | Học tiếng Đức toàn diện hơn | Learn German more completely | Deutsch umfassender lernen |
| `deThiPromoSubtitle` | Flashcard · Luyện nói AI · Đề thi B1/B2 | Flashcards · AI speaking · B1/B2 exams | Karteikarten · KI-Sprechen · B1/B2-Prüfungen |
| `deThiPromoCta` | Thử ngay → | Try now → | Jetzt testen → |
| `deThiPassageLabel` | Đoạn {index} | Passage {index} | Abschnitt {index} |
| `deThiPassageAnsweredCount` | {answered}/{total} câu | {answered}/{total} questions | {answered}/{total} Fragen |
| `deThiTranslatePassage` | Dịch đoạn văn | Translate passage | Text übersetzen |
| `deThiHideTranslation` | Ẩn bản dịch | Hide translation | Übersetzung ausblenden |
| `deThiTranslateVi` | Dịch tiếng Việt | Translate to Vietnamese | Ins Vietnamesische übersetzen |
| `deThiHideExplanation` | Ẩn giải thích | Hide explanation | Erklärung ausblenden |
| `deThiExplanation` | Giải thích | Explanation | Erklärung |
| `deThiVietnameseTranslationHeading` | BẢN DỊCH TIẾNG VIỆT | VIETNAMESE TRANSLATION | VIETNAMESISCHE ÜBERSETZUNG |
| `deThiPrevPassage` | Đoạn trước | Previous passage | Vorheriger Abschnitt |
| `deThiNextPassage` | Đoạn tiếp | Next passage | Nächster Abschnitt |
| `deThiCorrectCountLabel` | {correct}/{total} câu đúng | {correct}/{total} correct | {correct}/{total} richtig |
| `deThiScoreLabel` | {score} điểm | {score} points | {score} Punkte |

FAQ questions/answers, stats labels, testimonials, and founder quote are
long-form SEO marketing copy kept hardcoded per the plan's approved
exception — not listed as ARB candidates.

## Tests

`flutter analyze lib/screens/exam/de_thi_list_screen.dart
lib/screens/exam/de_thi_practice_screen.dart
lib/screens/exam/widgets/de_thi` → **No issues found**. (Pre-existing
errors in `lib/screens/exam/widgets/schedule/buddy_card.dart` are outside
my ownership — different parallel agent's files, untouched by me.)

No existing widget tests target `DeThiListScreen`/`DeThiPracticeScreen`
directly (checked `test/` — only repository-level and structure-guard tests
reference `de_thi`), so no test breakage.

Status: DONE
Summary: Both screens fully rebuilt to web parity incl. SEO trust block; practice screen now paginated single-passage with local persistence and submit-all reveal.
Concerns/Blockers: None. Coordinator should wire the ARB table above into `app_*.arb` + regenerate localizations when convenient.
