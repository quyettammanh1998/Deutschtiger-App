# Exam Tab Landing — Web ↔ Flutter Parity Fix

## Scope
- Web source of truth: `thamkhao/deutschtiger-frontend/src/pages/exam/exam-landing-page.tsx`
- Flutter target: `lib/screens/exam/exam_screen.dart` + new
  `lib/features/exam/presentation/widgets/exam_provider_cards.dart` + header/footer
  support added to `lib/features/exam/presentation/widgets/exam_catalog_list.dart`.

## Diffs found vs fixes applied

| Element | Web | Flutter before | Fix |
|---|---|---|---|
| Landing structure | Header + buddy-finder CTA + 3 provider cards (telc/Goethe/ÖSD) w/ level pills + SEO links | Chip-based ecosystem links bar + filter chips + catalog list — no provider/level cards at all | Added `ExamProviderCards` widget rendering the buddy CTA + 3 provider cards with level pills, inserted as `ExamCatalogList.header` so everything shares one scroll view (no nested scrollables) |
| Buddy-finder CTA (`Tìm bạn ôn thi`) | Orange/amber gradient card, `UsersThree` icon in orange gradient square, "Mới" badge, `CaretRight` arrow | Not present (was a generic chip) | `_BuddyFinderCta`: orange-50→amber-50 gradient bg, orange-200/70 border, orange-500→600 gradient icon square (`Icons.groups_rounded`), "Mới" badge (reused `l10n.statsMasteryNew`), chevron arrow. Navigates to `/exam/schedule` |
| Provider brand pill (telc/Goethe/ÖSD wordmark) | Colored rounded pill w/ brand hex bg (`#0a6cb6`/`#0a8a3c`/`#c8102e`) + white bold wordmark text | Not present | `_ProviderCard` header row: brand-color pill + wordmark + provider name in the provider's accent color |
| Level pills | 2-col grid (3-col desktop), emoji + level code + tier label, ring-2 highlight on the user's current CEFR level, "Đề xuất" label swap | Not present (only global filter chips) | `_LevelGrid`/`_LevelPill`: 2-col grid, same emoji set (🌱🌿🌳🏔️🏆), level code in provider accent color, orange ring (2px border) on the recommended level |
| Provider/level colors | blue-600/50/200 (telc), emerald-600/50/200 (Goethe), red-600/50/200 (ÖSD) | N/A | Reused existing tokens: `DesignTokens.examActive`/`examActiveSoft` (blue-600/50), `DesignTokens.emerald600`/`emerald50` (Goethe), `DesignTokens.examDanger`/`examDangerSoft` (red-600/50). Border tints (`*-200/70`) not in tokens → screen-local inline `const Color(0x...)` per the constraint |
| Icons | Phosphor `UsersThree`, `CaretRight`, `Broadcast` | Material substitutes already used elsewhere; ecosystem bar used `Icons.speed_outlined` etc. | Kept Material icons (`Icons.groups_rounded`, `Icons.chevron_right_rounded`) since Phosphor isn't a Flutter dependency here — closest Material equivalents, consistent with rest of app |
| Level emoji | 🌱🌿🌳🏔️🏆 (A1–C1) | Missing | Rendered as literal emoji text (not Material icons), matching the required substitution rule |
| SEO guide links footer | 4 links to `/thi-b1-telc`, `/thi-b1-goethe`, `/luyen-thi-b1`, `/luyen-noi-tieng-duc-ai` SEO landing pages | N/A | **Intentionally omitted** — these are marketing/organic-search content pages (`src/pages/seo/*`) with no corresponding Flutter screens; out of scope for a mobile app |
| Ecosystem quick-links bar (readiness/schedule/community/dictation chips) | Not present on web landing at all (schedule reached via the one buddy CTA; readiness reached from dashboard `exam-corner-card`; community/dictation reached from other pages) | Present, 4 chips, duplicates web IA | Removed readiness + schedule chips (redundant: readiness already reachable from `home/widgets/exam_corner_card.dart`, schedule now has its dedicated CTA matching web). Kept community + dictation as a small `_MoreExamToolsLinks` row **below** the catalog (footer) since no other Flutter surface currently links to those two screens — dropping them would strand the features. This deliberately diverges from strict 1:1 web parity to avoid a functional regression; flagged below |
| Level-mismatch warning dialog | Modal on tapping a level ≥2 CEFR steps above user's level ("Bạn đang ở trình độ…", "Vẫn tiếp tục") | N/A | **Deferred** — dialog copy has no existing l10n keys and adding new ones is out of scope (l10n owned by a concurrent agent). Tapping any level now just sets the existing provider/level filter directly |
| Header title/subtitle + admin broadcast button + `AnnouncementBanner` | `h1 "Luyện thi"` + subtitle "Chọn chứng chỉ & cấp độ" + admin-only broadcast icon + inline announcement banner | `AppBar(title: examPractice)` only | Kept the existing `AppBar` (app-wide screen convention, e.g. `SocialScreen`, `ExamScheduleScreen` all use `AppBar`, not an inline header — literal back-button/inline-header replication would be inconsistent with the app shell). Title text matches (`l10n.examPractice` = "Luyện thi"). Subtitle line, admin button, and inline `AnnouncementBanner` **deferred** — no Flutter equivalent widget for an inline-body announcement banner exists yet, and subtitle text has no matching l10n key |

## Files modified
- `lib/screens/exam/exam_screen.dart` — replaced `_EcosystemLinksBar` with `ExamProviderCards` header + slimmed-down `_MoreExamToolsLinks` footer; `_CatalogFilters` padding adjusted to avoid double horizontal padding now that the outer `ListView` owns it.
- `lib/features/exam/presentation/widgets/exam_catalog_list.dart` — added optional `header`/`footer` params so the landing content and catalog cards share a single `ListView`/`RefreshIndicator` (avoids nesting scrollables). `exam_list_page.dart`'s existing call site is unaffected (new params default to `null`).
- `lib/features/exam/presentation/widgets/exam_provider_cards.dart` (new, 330 LOC — flagged for a later split if it grows further) — buddy CTA + 3 provider cards + level-pill grid.

## Colors/tokens used (no `design_tokens.dart` edits)
`DesignTokens.orange500/600`, `examActive`, `examActiveSoft`, `emerald600`, `emerald50`, `examDanger`, `examDangerSoft`, `card`, `border`, `foreground`, `mutedForeground`, spacing/radius tokens. Screen-local-only hex: provider brand pill colors (`#0A6CB6`/`#0A8A3C`/`#C8102E`), CTA gradient bg (`#FFF7ED`→`#FFFBEB`), and `*-200/70`-equivalent border tints — all inline `const Color(...)` per the "no token edits" constraint.

## l10n reuse (no `.arb` edits)
- `l10n.examScheduleTitle` → "Tìm bạn ôn thi" (CTA title, exact match)
- `l10n.statsMasteryNew` → "Mới" (badge, reused across-domain for its literal text match)
- `l10n.cefrBeginner`/`cefrPreIntermediate`/`cefrIntermediate`/`cefrUpperIntermediate`/`cefrAdvanced` → level tier labels for A1–C1 (standard 6-tier CEFR naming, semantically correct even though web uses custom short Vietnamese labels — same "progression tier" meaning)
- `l10n.communityExamsTitle`, `l10n.examDictationTitle` → footer quick links (unchanged from before)

## Verify
- `flutter analyze lib/screens/exam/exam_screen.dart lib/features/exam/presentation/widgets/exam_provider_cards.dart lib/features/exam/presentation/widgets/exam_catalog_list.dart` → **No issues found**
- `flutter analyze lib/screens/exam lib/features/exam` (full dirs) → only 2 pre-existing, unrelated `deprecated_member_use` infos in `de_thi_practice_screen.dart` (untouched file)
- No mock/fixture/placeholder literals introduced (grepped touched files for `mock|fixture|placeholder`)
- No image assets needed — web landing uses no `<img>`, emoji-only

## Deferred (needs shared-token/l10n changes in a follow-up serialized pass)
1. Level-mismatch confirmation dialog — needs new l10n strings ("Bạn đang ở trình độ…", "Vẫn tiếp tục", etc.)
2. Header subtitle "Chọn chứng chỉ & cấp độ" — no matching l10n key
3. Admin broadcast button + inline `AnnouncementBanner` in the exam tab body — no Flutter widget exists for an inline announcement banner (only a separate `/social/announcements` page); would need new infra, not a token/string-only change
4. SEO guide links section — no Flutter screens exist for those SEO content pages; not applicable to a mobile app, recommend explicitly excluding from any future parity checklist

Status: DONE_WITH_CONCERNS
Summary: Rebuilt exam-tab landing (buddy CTA + telc/Goethe/ÖSD provider cards w/ CEFR level pills, matching web colors/emoji/gradients/layout) reusing existing tokens and l10n keys; catalog/filters kept below as the in-app "results" section since the per-provider results route is a later wave. flutter analyze clean on all touched files.
Concerns: 4 items deferred above need either new l10n keys (dialog copy, subtitle) or new shared infra (inline announcement banner) — none blockable by token/string reuse alone, recommend a dedicated follow-up pass once l10n/design-token agents are free.
