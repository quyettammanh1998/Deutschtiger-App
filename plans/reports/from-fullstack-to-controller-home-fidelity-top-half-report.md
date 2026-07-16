# Home top-half web-parity fidelity — Agent 1 report

Scope: header, search bar, daily-path hero, exam-corner strip, pinned shortcuts
(top half of mobile Home). Agent 2 owns stats/leaderboard/quick-actions/
community/premium-banner/missions — untouched here.

## 1. Header — `lib/widgets/dashboard/mobile_dashboard_header.dart`
Full rewrite: cream card (`headerCardBg`/`headerCardBorder`), diagonal base
gradient + top-right radial glow via `Stack`, inset 16px margin (was
full-bleed blue gradient banner). Exactly two icon buttons remain (Messages,
Settings) — the standalone notification bell is gone; its unread badge now
sits on the Messages button, threshold `>99 → "99+"`. `showMessages` param
removed (icon always renders); `onMessagesTap`/`onSettingsTap` wiring kept as
before. Row 2 (encouragement text + streak chip) now renders unconditionally,
even at streak 0. `_XpPill`/`_StreakPill`/XP ring removed from the header
(XP now lives only in the daily-path hero, single source of truth). Avatar
re-toned for the light card (orange-tinted bg, `headerCardBorder`). Dropped
now-unused `dailyXp`/`dailyGoal`/`showXp`/`onNotificationsTap` params; updated
the `home_screen.dart` call site accordingly (only the constructor call, not
the surrounding screen logic).

## 2. Search bar — `lib/screens/home/widgets/dashboard_sections.dart`
`DashboardSearchBar` boxShadow swapped to `DesignTokens.shadowMd` (two-layer,
heavier). `l10n.searchVocabulary` (vi) updated to the exact web copy "Tìm từ
vựng tiếng Đức...". `DashboardMissionsSection`/`DashboardMissionCard` in the
same file were **not** touched (Agent 2 territory).

## 3. Daily-path hero — `lib/screens/home/widgets/resume_section.dart`
Reworked from a side-by-side row card into the web `DailyPathHeroCard`
layout: header row (title + amber/muted exam-countdown badge) → 64px XP ring
+ plan-summary text → primary full-width gradient CTA (or emerald "all done"
banner) → horizontal-scroll mini-stepper (done/premium-locked/current/
upcoming dots). Split private pieces into a new companion file
`lib/screens/home/widgets/daily_path_hero_pieces.dart` (`DailyPathEmptyCard`,
`DailyPathExamBadge`, `DailyPathXpRing`, `DailyPathCompleteBanner`,
`DailyPathMiniStepper`) to keep both files under ~200 LOC. `ResumeLearningCard`
keeps its public constructor (`path`, `dailyXp`, `dailyGoal`, `streak`,
`onTap`) so `dashboard_phase_3c_test.dart` needed no signature changes — only
a fixed overflow (title row now wraps in `Expanded`+ellipsis; plan-summary
line also ellipsizes) surfaced by the existing 340px-viewport test.

New file `lib/features/daily_path/domain/skill_emoji.dart` — `kSkillEmoji`
map, `skillEmoji()` helper. **Skill-slug mapping gap resolved**: web keys
`SKILL_EMOJI` by German slugs (`wiederholung`, `fortsetzen`, `wortschatz`,
`hoeren`, `lesen`, `schreiben`, `sprechen`, `spiel`, `pruefung`), but the
Flutter `/user/learn/path/today` response actually uses the English-ish slugs
already relied on by `daily_path_route_resolver.dart` and the repository test
fixtures (`vocab`, `review`, `flashcard`, `grammar`, `listening`, `reading`,
`writing`, `speaking`, `game`, `exam` — confirmed via
`test/features/home/dashboard_phase_3c_test.dart` and
`release_navigation_gates_test.dart` fixtures; no backend source available in
this checkout to double-check further). Mapped **both** slug families to the
same emoji buckets so no real Flutter step falls back to the `•` dot.

## 4. Exam corner — `lib/screens/home/widgets/exam_corner_card.dart`
Headline 13→14px, sub-links 11→12px. Sub-links row now has two items:
"Độ sẵn sàng" (existing `/exam/readiness` route) and new "Đổi mục tiêu".
CTA switched from `FilledButton` solid orange to a gradient pill
(`orange500`→`orange600`); label is `"Làm đề →"` (non-overdue) or
"Đặt mục tiêu mới" (overdue).

**Functional gap flagged**: there is no goal-editor screen/sheet in Flutter
(`LearnGoalRepository` only has `fetchGoal()` — no create/update endpoint
wired, no route, no sheet component exists under `lib/screens` or
`lib/shared/widgets`). Per "do NOT fake" — "Đổi mục tiêu" deep-links to the
existing `/exam` hub (closest live surface) rather than fabricating a
goal-setter UI backed by nothing. Needs a dedicated wave once the backend
goal-update contract is confirmed.

## 5. Pinned shortcuts — `lib/screens/home/widgets/pinned_shortcuts.dart`
Fixed the swapped glyphs: Luyện thi → `Icons.school_rounded` (was clipboard),
Khóa học → `Icons.menu_book_rounded` (was mortarboard). Metaphor-drift fixes:
Kho từ vựng → `translate_rounded`, Sổ từ → `bookmark_rounded` (single),
Luyện nói AI → `chat_bubble_outline_rounded`, Viết câu AI → `edit_rounded`,
Nghe → `volume_up_rounded`. All ten tiles moved from `-100` to `-50` shade
backgrounds; Ôn tập recolored to emerald-500/emerald-50 (was olive
accent/success); Trò chơi bg → amber-50; Sổ từ color → violet-500. Label
10px→11px. "Xem tất cả" now reads "Xem tất cả →" in `orange600`.

## Design tokens added (`lib/core/design_tokens.dart`)
`headerCardBg`, `headerCardBorder`, `headerTextDark`, `headerMutedBrown`,
`headerAccentOrange`, `streakChipBorder`, `emerald50/100/600/700`,
`amber100/700`. `orange500`/`orange600` already existed — reused, not
duplicated.

## l10n keys (added `en`/`vi`/`de`, ran `flutter gen-l10n`)
`headerEncouragement`, `headerStreakStart`; hero:
`dailyPathHeroTitle`, `dailyPathExamBadge`, `dailyPathPlanSummary`,
`dailyPathMinutesRemaining`, `dailyPathNextStep`,
`dailyPathCompleteCelebration(WithStreak)`, `dailyPathEmptyTitle/Description/Cta`;
exam corner: `examCornerChangeGoal` (new), `examCornerContinue` value changed
("Continue"/"Tiếp tục" → "Take a test"/"Làm đề"/"Prüfung machen" to match the
new CTA copy — only consumer is `exam_corner_card.dart`, confirmed via grep
before editing). Removed now-dead keys `dailyPathComplete`, `dailyPathStart`,
`keepStreak`, `learnMoreToReinforce`, `dailyProgressHabit`,
`dailyPathProgress` (all were exclusive to the old `resume_section.dart`
layout, confirmed unused elsewhere before deletion). `searchVocabulary` (vi)
updated to exact web copy.

## Test file touched (contract-following change, not scope creep)
`test/features/home/release_navigation_gates_test.dart`: removed the two
`showMessages: false` args (param no longer exists) and updated the "Home
components hide gated navigation affordances" assertion — the messages icon
is now unconditionally visible by design (web parity), so the expectation
changed from `findsNothing` to `findsOneWidget` with a comment explaining why.
Also restored a 48x48 accessible tap target inside the header's icon buttons
(`SizedBox` wrapping the 36x36 visual chip) so the existing "Home header gives
Profile and Settings 48px semantic actions" test kept passing without
weakening it.

## Verify
- `flutter gen-l10n`: clean.
- `flutter analyze`: 5 pre-existing infos only (RadioGroup deprecations in
  `de_thi_practice_screen.dart`, `prefer_initializing_formals` in 3 unrelated
  test files) — no new issues.
- `flutter test test/features/home/ test/structure/ test/l10n/`: 96/96 pass.
- `flutter test` (full suite): 550/550 pass, including
  `release_live_data_guard_test.dart` (no mock/fixture literals introduced).

## Unresolved / flagged for follow-up
1. Goal-setter sheet for "Đổi mục tiêu" — genuinely missing feature (no
   backend update contract wired in Flutter yet); currently routes to `/exam`
   hub as a functional placeholder, not fabricated UI.
2. Exam-corner CTA still routes generically to `/exam` (not a per-provider
   deep link) — pre-existing behavior, called out in the plan as an
   acceptable minor gap, unchanged by this wave.
3. Skill-slug emoji mapping is best-effort inferred from route-resolver +
   test fixtures (no backend source in this checkout) — should be verified
   against the live `/user/learn/path/today` response the next time backend
   access is available.

Status: DONE_WITH_CONCERNS
Summary: All 5 top-half widgets reworked to web parity (header, search bar,
daily-path hero, exam corner, pinned shortcuts); new tokens/l10n/skill-emoji
file added; analyze clean, full test suite green.
Concerns/Blockers: (1) goal-setter sheet is a real missing feature, routed to
/exam as a stopgap — needs its own follow-up wave; (2) skill-emoji slug
mapping inferred from fixtures/route-resolver, not a live backend response —
worth a quick live-payload check later.
