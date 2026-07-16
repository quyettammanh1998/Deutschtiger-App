# Baseline test failures — root cause + fix

Scope: 4 pre-existing failing tests (confirmed present at commit 8a66e8b, before current UI-fidelity work). All fixes are test-side; no production layout bug was found — root causes were test-harness gaps, not `RenderFlex` overflows in production widgets.

## 1-3. `test/screens/ai/ai_chat_page_test.dart` (3 tests)

Chain of 4 independent test-setup bugs, each masking the next:

**a) Missing `localizationsDelegates`/`supportedLocales`.** `_InputBar` calls `AppLocalizations.of(context).socialTypeMessageHint` (`lib/screens/ai/ai_chat_page.dart:611`) — present already at 8a66e8b. Test wrapped the widget in a bare `MaterialApp(home: AIChatPage())` with no delegates, so `AppLocalizations.of` returned null → `Null check operator used on a null value` thrown inside `_InputBar.build`, which Flutter surfaced as a giant (99468px) `RenderFlex` overflow in the ancestor `Column` (the real exception occurring during a child's build corrupts that frame's layout — this is the "layout overflow" symptom described in the task, but the trigger was the null-check crash, not a real sizing bug). Fix: added `supportedLocales: AppLocalizations.supportedLocales` / `localizationsDelegates: AppLocalizations.localizationsDelegates` to all 3 `MaterialApp` instances in the test (matches the pattern used by ~15 other localization tests, e.g. `test/screens/journey/mission_session_localization_test.dart`).

**b) Icon renamed, test not updated.** At the test's authoring commit (`d5be09c`), the send button used `Icon(Icons.send)`. Commit `8a66e8b` (part of the design-fidelity pass, already in baseline) changed it to `Icons.send_rounded` (`lib/screens/ai/ai_chat_page.dart:671`) — an intentional icon-style choice, not a bug. Fix: updated `find.byIcon(Icons.send)` → `find.byIcon(Icons.send_rounded)` (3 occurrences).

**c) `enterText` doesn't pump a frame.** After fixing (a)+(b), tap silently no-op'd (no exception, nothing sent). Root cause: `WidgetTester.enterText` calls `showKeyboard` + `testTextInput.enterText` + `idle()`, but never calls `pump()`. The send button's `onTap` is computed inside a `ValueListenableBuilder<TextEditingValue>` from `hasText` (`lib/screens/ai/ai_chat_page.dart:663-676`); until a frame rebuilds, the Element tree still holds the pre-text (disabled, `onTap: null`) callback, so `tester.tap()` on the still-disabled button does nothing. Verified by isolating in a scratch test (`/tmp/.../debug_ai_test.dart`, deleted after use): adding `await tester.pump()` between `enterText` and `tap` made the send succeed; without it, "Mir" never reached the transcript, matching the exact original failure symptom. Fix: added `await tester.pump()` after each `enterText` call, before the icon tap (3 occurrences), with an explanatory comment.

**d) Stale English "Retry" assertion vs. Vietnamese-first UI.** At `d5be09c`, the retry button's label was `Text('Retry')`. `8a66e8b` (baseline, pre-fidelity-work) changed it to `Text('Thử lại')` (`lib/screens/ai/ai_chat_page.dart:532`) as part of making the whole page consistently Vietnamese-hardcoded (matches sibling strings on the same page: `'Dừng'`, `'Gửi tin nhắn'`, `'Đã hết lượt...'`). This is intentional, not a regression — the test's English expectation was stale. Fix: updated `find.text('Retry')` → `find.text('Thử lại')` (3 occurrences).

No production code changed for these 3 tests.

## 4. `test/screens/exam/exam_catalog_localization_test.dart`

Two stacked issues, neither a `RenderFlex` overflow:

**a) `learningPreferencesProvider` crashes synchronously in tests.** `ExamProviderCards` (new widget wired into `ExamScreen` at 8a66e8b) reads `ref.watch(learningPreferencesProvider)` to show the recommended CEFR-level pill. `LearningPreferencesNotifier.build()` (`lib/view_models/settings/learning_preferences_provider.dart:37-40`) does `unawaited(_load()); return const LearningPreferencesState();`. `_load()` calls `ref.read(learningPreferencesRepositoryProvider).get()`, which resolves `apiClientProvider` → `supabaseClientProvider` → `Supabase.instance.client`. Since the test never calls `Supabase.initialize`, that getter throws **synchronously** (not via a real network await), so the whole `try { await ... } catch (_) { state = state.copyWith(...) }` chain runs to completion before `_load()`'s first genuine suspension point is reached — and therefore before the riverpod framework has finished `build()` and set the notifier's internal `_state`. Result: `StateError: Tried to read the state of an uninitialized provider` (riverpod's `element.dart:168`) thrown from inside `state = state.copyWith(...)`. This file is outside the allowed edit scope (`lib/view_models/settings/**`), and in production this race never triggers (Supabase is always initialized first), so it's a test-environment gap, not a shippable bug. Fix: overrode `learningPreferencesProvider.overrideWith(_FixedLearningPreferencesNotifier.new)` in the test with a fixed, already-loaded `LearningPreferencesState`, sidestepping the repository/network path entirely — same pattern as the existing `examCatalogProvider.overrideWith(...)`.

**b) Content below the fold, not overflow.** After (a), the test ran clean with **zero** `RenderFlex overflow` errors (confirmed via `grep -i overflow` on full test output — none). The failure was `find.text('30 Fragen')` returning 0 widgets. Compared against the pre-fidelity-work `ExamScreen` (commit `50bbf1f`, when this test was authored): the catalog list used to be its own `Expanded(ExamCatalogList(...))` inside a `Column` alongside `_EcosystemLinksBar` + `_CatalogFilters` — i.e. its own independently-scrolling viewport, always showing its first item at the top. At 8a66e8b (current baseline), `ExamScreen` was redesigned to merge `ExamProviderCards` + filters into a single `header:` slot inside `ExamCatalogList`'s own `ListView` (`lib/screens/exam/exam_screen.dart:50-77`, `lib/features/exam/presentation/widgets/exam_catalog_list.dart:31-59`) — a deliberate, documented web-parity change ("all in one scroll view", see the comment at `exam_screen.dart:45-49`). At 200% text scale, that merged header (buddy-finder CTA + 3 provider cards with CEFR-level grids) is taller than the default 600px test viewport, so the exam-catalog card is genuinely below the fold — exactly what a real ListView does, and exactly what a real user would scroll to see. The test's assumption that all assertions were visible without scrolling was written against the old, un-merged layout and never updated for the new one. Fix: added a `tester.dragUntilVisible(find.text('30 Fragen'), find.byType(Scrollable).first, const Offset(0, -200))` scroll before asserting on the catalog-card text — minimal, matches real interaction, and `tester.takeException()` stays `isNull` throughout (no overflow, no error).

No production code changed for this test either.

## Validation

- `flutter test test/screens/ai/ai_chat_page_test.dart` → 3/3 pass
- `flutter test test/screens/exam/exam_catalog_localization_test.dart` → 1/1 pass
- `flutter analyze lib/screens/ai/ lib/features/exam/presentation/ test/screens/ai/ai_chat_page_test.dart test/screens/exam/exam_catalog_localization_test.dart` → 0 issues
- `flutter test test/screens/ test/features/exam/` → 197/197 pass, no new failures
- `flutter analyze` (whole repo) → pre-existing errors only, all outside scope: `lib/core/icons/app_phosphor_icons.dart` and `lib/shared/widgets/more_features/*` (missing `phosphor_flutter` pub dependency — `pubspec.yaml` is off-limits per task), and `test/l10n/app_localizations_test.dart` (references `MoreFeaturesSheet` API another agent is mid-changing on `lib/shared/widgets/more_features_sheet.dart`, also off-limits). None touched.

## Files changed

- `test/screens/ai/ai_chat_page_test.dart` — localization delegates, icon rename, frame pump before tap, `Retry` → `Thử lại`
- `test/screens/exam/exam_catalog_localization_test.dart` — fixed `learningPreferencesProvider` override, scroll before below-the-fold assertions

## Unresolved questions

- `LearningPreferencesNotifier.build()`'s `unawaited(_load())` pattern (`lib/view_models/settings/learning_preferences_provider.dart:37-40`) is a latent riverpod anti-pattern: if the awaited call ever throws *synchronously* (as `Supabase.instance.client` does pre-init), it can crash with "uninitialized provider" before `build()` returns. Didn't happen in production so far because Supabase is always initialized first, but out of this task's file-ownership scope to fix (`lib/view_models/settings/**` not in the allowed-edit list). Worth a follow-up ticket for whichever agent owns that path — e.g. wrap in `Future.microtask(_load)` or use `ref.onDispose`-safe deferral.

Status: DONE
Summary: All 4 target tests fixed and passing; root causes were test-harness gaps (missing l10n delegates, uninitialized-provider race exposed by the test lacking Supabase, missing frame pump after `enterText`, and two stale text-string assertions), not production layout bugs — confirmed by zero `RenderFlex overflow` output and `tester.takeException()` staying null throughout. No production code was modified. Full `test/screens/` + `test/features/exam/` suite (197 tests) and scoped `flutter analyze` are clean.
Concerns/Blockers: none blocking; one follow-up noted above (latent riverpod race in `learning_preferences_provider.dart`, out of scope to fix here).
