# Exam Goal Setter — Home Parity Report

## Files added
- `lib/data/learn/exam_goal_providers.dart` — const `examGoalProviders` registry (goethe/telc/osd, id/label/short/levels) + `levelsForProvider`/`examGoalProviderShort` helpers, mirrors web `exam-goal-providers.ts`.
- `lib/screens/home/widgets/exam_goal_setter_sheet.dart` — `ExamGoalSetterSheet` modal bottom sheet (`ConsumerStatefulWidget`) with static `show(context, {existing})`. Provider dropdown, level dropdown (clamped to provider's levels on change), date picker (`firstDate = today`, so past dates unselectable), inline validation, gradient "Lưu mục tiêu"/"Đang lưu..." save button.

## Files changed
- `lib/repositories/learn/learn_goal_repository.dart` — added `upsertGoal({targetLevel, targetProvider, targetDate})` → `POST /user/learn/goals`.
- `lib/screens/home/widgets/exam_corner_card.dart` — no-goal state now renders `_GoalPrompt` (title/subtitle/CTA opening the sheet) instead of `SizedBox.shrink()`; "Đổi mục tiêu" opens `ExamGoalSetterSheet.show(context, existing: goal)` (removed the `/exam` stopgap + its comment); `_providerShortName` removed in favor of `examGoalProviderShort` from the new registry file (DRY, matches web's single source of truth). Countdown strip, readiness link, and primary CTA (`context.push('/exam')`) left untouched per scope.
- `lib/l10n/app_vi.arb`, `app_en.arb`, `app_de.arb` — added `examGoalPromptTitle/Subtitle/Cta` and `examGoalSetterTitle/ProviderLabel/LevelLabel/DateLabel/DateRequired/DateInPast/Save/Saving/SaveFailed`. VN copy matches the web strings verbatim ("Đặt mục tiêu thi", "Đặt ngày thi để theo dõi đếm ngược và luyện đề đúng trình độ.", "Vui lòng chọn ngày thi", "Ngày thi không thể trước hôm nay", "Lưu mục tiêu"/"Đang lưu...").

## Upsert wiring
`ExamGoalSetterSheet._submit` validates (date required → non-null check; date-in-past → compare to local midnight `today`), then calls `learnGoalRepositoryProvider.upsertGoal(...)` with `target_date` formatted `YYYY-MM-DD` from the picked `DateTime`. On success: `ref.invalidate(learnGoalProvider)` + `ref.invalidate(dailyPathProvider)`, then `Navigator.pop`. On error: inline "Lưu thất bại, thử lại sau", button re-enabled. No fake/mock data anywhere — every write hits the real endpoint.

## No-goal + edit flows
- No goal (`goal.targetDate == null`): `ExamCornerCard` renders `_GoalPrompt` — compact card (title + subtitle + gradient "Đặt ngày thi" button) styled like the existing countdown strip (same card/shadow/radius tokens). Tapping opens `ExamGoalSetterSheet.show(context)` with `existing: null` → provider defaults to `goethe`, level defaults to `A1`, date empty.
- Edit ("Đổi mục tiêu"): opens the same sheet with `existing: goal` → prefills provider/level/date from the current goal via `initState` (avoided `widget` access in field initializers — moved to `initState` to fix an `implicit_this_reference_in_initializer` analyzer error).
- Provider change clamps the level selection into that provider's level set (e.g. switching to `telc` while on `A1` snaps to `B1`), matching web's clamp behavior.

## Verify
- `flutter gen-l10n`: ran clean (uses `l10n.yaml`); confirmed generated getters present in `app_localizations_vi.dart`.
- `flutter analyze`: 5 issues, all pre-existing (2 `deprecated_member_use` info in `de_thi_practice_screen.dart`, 3 `prefer_initializing_formals` info in test files) — zero new issues.
- `flutter test test/features/home/ test/structure/ test/l10n/`: 96 tests, all passed (includes `release_live_data_guard_test.dart`).
- No widget test exists specifically for `exam_corner_card.dart`/the new sheet (grepped `test/` — no matches), so per task instructions relied on analyze + the existing suites rather than adding a new test without a nearby pattern to follow.

## Unresolved questions
None — all contracts (endpoint, body shape, provider/level registry, invalidation targets) were given explicitly and verified against the web reference files before implementation.

Status: DONE
Summary: No-goal prompt + editable goal sheet now wired to the real `POST /user/learn/goals` upsert; provider/level registry extracted for DRY reuse; analyze clean, target test suites green (96/96).
Concerns/Blockers: none.
