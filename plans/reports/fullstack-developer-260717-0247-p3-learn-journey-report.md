# Phase 3 — Learn & journey: implementation report

Plan: `plans/260716-2324-web-mobile-ui-100-fidelity/phase-03-learn-journey.md`

## Per-screen status (6-screen table)

| Web | Flutter | Status |
|---|---|---|
| `learn-home-page.tsx` (`/learn`) | `journey_screen.dart` + widgets | DONE (moderate deviation — see below) |
| `mission-session-page.tsx`+`-runner.tsx` (`/learn/session/:id`) | `features/mission/**` | DONE — full engine rebuild |
| `can-do-practice-page.tsx` | `can_do_practice_screen.dart` | DONE |
| `topic-explore-page.tsx` | `topic_explore_screen.dart` | DONE |
| `focus-session-page.tsx` (`/focus`) | `focus_session_screen.dart` | DONE |
| `learner-model-page.tsx` | `learner_model_screen.dart` | DONE (moderate deviation — see below) |

## 1. Mission runner rebuild (the big one)

Reused P4's `PracticeRoundItem`/`PracticeResultEntry` contract and the
`PracticeListeningView`/`PracticeWritingView` round widgets directly (read-only
reuse per instructions). Deleted the old word-by-word intro/flip-card flow
(`widgets/{word_intro_view,practice_view,result_view}.dart`).

- **Round-based engine**: `mission_session_provider.dart` rewritten —
  `resumePreStep → inRound → completed` state machine, one round at a time
  (not one word at a time). Real backend `game_type` vocabulary is
  `flashcard|recall|typing|sentence|wortstellung|resume` (confirmed from
  `thamkhao/deutschtiger-backend/internal/feature/learning/mission/{types,game_selector}.go`),
  **not** cloze/listening/matching/writing — new
  `mission_game_type.dart` maps `flashcard`/`recall` → recognition
  (`PracticeListeningView` flip-card) and `typing`/`sentence`/`wortstellung` →
  production (`PracticeWritingView`). Matching/cloze views are unused by the
  mission rotation (verified against `gameRotation` in the Go source), so
  this 2-of-4 mapping is intentional, not a shortcut.
- **`ResumePreStep`**: new `resume_pre_step_view.dart`. Added
  `MissionResumeTarget`/`DailyMission.resumeItems` to `mission_models.dart`
  (backend already returns `resume_items` per `mission_service.go` — this was
  previously unparsed).
- **`MissionCompleteOverlay`**: new `mission_complete_overlay.dart` — trophy
  gradient circle, XP badge, "leveled up today" list, streak line, gradient
  CTA. Climbed-rungs data reuses the existing `weeklyRecapProvider`
  (`GET /user/learn/weekly-recap`) — no new endpoint needed, list hides
  gracefully when absent (matches web contract: "never blocks the overlay").
- **Route**: `/learn/session/:id` (in `learn_routes.dart`, fullscreen
  root-navigator route — no AppBar, matches web's bare scroll page). Old
  `/journey/session` now redirects to `/learn/session/today` in
  `release_redirect.dart`. Updated the two other in-app callers
  (`journey_today_session_card.dart`, `daily_path_route_resolver.dart`).

## 2. `/learn` home (journey_screen.dart)

Removed the Material AppBar. Added: `PageIntro` (CTA → `/daily-review`), a new
`JourneyLevelJourneyStrip` (A1→C2 tiles, reuses `learnerModelProvider`'s
`coverage_by_level` — no new endpoint), a new `JourneyCapabilityMapSnapshot`
gradient card (reuses `capabilityMapProvider`). `JourneyExtensionsSection`
trimmed to the single "Khám phá theo chủ đề" tile (web has no
courses/learner-model/focus-session tiles on `/learn`; those routes stay
reachable via the "Thêm" sheet catalog + readiness cards, confirmed before
removing).

**Deviation**: `TodaySessionCard`'s 4-stage bucket grid (Ôn tập/Nạp/Vá điểm
yếu/Dùng) is **not** rebuilt — the Flutter `DailyMission` model has no stage
breakdown, only `rounds_planned`/`rounds_completed`; that's a different
pedagogical construct not exposed by the current backend contract. Kept the
existing round/word-count progress card. `WeeklyMissionsStrip` (bonus
missions with XP) is also **not** added — its only Flutter data source
(`DashboardMission`) lives in `lib/screens/home/widgets/dashboard_mission_mapping.dart`,
owned by a concurrent home-screen agent; pulling it into journey would mean
either duplicating logic or coupling to a file mid-edit by another agent.
Header goal+persona line (`Mục tiêu {level} · Lộ trình: {persona}`) also
deferred — no `persona` field surfaced anywhere in the Flutter learn/daily-path
models.

## 3. Can-do practice, topic explore, focus session

- **`can_do_practice_screen.dart`**: back-link instead of AppBar, orange
  bordered instruction box (`✍️` prefix), `AppGradientButton` CTAs, done/
  all-clear views now cards with gradient CTA ("Về bản đồ năng lực" →
  `/learner-model`, "Luyện hội thoại" → `/conversation`). End-state widgets
  split into `widgets/can_do_practice_end_states.dart` for the LOC guideline.
- **`topic_explore_screen.dart`**: added the "Lộ trình đang ưu tiên" gradient
  steering card (`topic_steering_card.dart` — goal chips from the real
  `goethe/communication/medical/work` goal keys read off `learn-home-page`'s
  web source, pinned-topic chips) and rebuilt `TopicGroupCard`
  (`topic_group_card.dart`) with a gradient icon tile, `{label} · N chủ đề`
  subtitle, and a sub-topic grid (⭐/☆ pin, level pills). Web's `topic.color`
  (a Tailwind class string from the DB) has no Flutter parser — used a
  deterministic id-hash palette instead of parsing Tailwind classes.
- **`focus_session_screen.dart`**: back+h1+subtitle, new `GoalReasonLine`
  widget (`goal_reason_line.dart`, reuses existing `learnGoalProvider`), dual
  empty states (new-user "chưa đủ dữ liệu" vs caught-up "rất ổn", branched on
  `reviewStatsProvider.totalReviews == 0` — same signal web uses via
  `flashcardService.getStats()`), fixed the 2 wrong CTA routes (exam-fail card
  → `/exam/readiness`, subtitle card → `/subtitle-words`), always-visible
  "Xem lỗi hay gặp" footer link → `/stats/error-patterns`.

## 4. Learner model (`learner_model_screen.dart`)

Removed AppBar → back+h1+subtitle+`PageIntro`. Added `LearnerReadinessCard`
(`learner_readiness_card.dart` — the `{low}–{high}%` band + color tiers was
already exposed as `LearnerModel.readiness`, previously unused by this
screen) and `WeeklyRecapCard` (`weekly_recap_card.dart`, reuses
`weeklyRecapProvider`) inserted before the can-do section per web block
order. Coverage bars now use a primary→brandDark gradient with a "Luyện theo
cấp {level} →" link; grammar-weakness rows and weak-word rows now have a
"Luyện ngay" pill button (grammar → `/grammar?source=wrong_answer`, weak word
→ `/daily-review`, unchanged from before — Flutter router has no `?retry=id`
support yet, same gap the old code already documented). Weak-word lapses now
render as a red pill instead of plain text. Section widgets split into
`widgets/learner_model_sections.dart` for the LOC guideline.

**Deviation**: `LearningDepthCard` (Biết/Hiểu/Áp dụng — rung-1/2/3 counts) is
**not** added — no field on `LearnerModel` or any other Flutter-visible
endpoint exposes that specific breakdown; adding it would require a new
backend contract probe, out of this pass's time budget. Documented as a
follow-up.

## 5. Deletions / routing bookkeeping

- Deleted `/learn/group` video browser: `lib/screens/interview/**` (5 files —
  `group_detail_screen.dart`, `video_player_screen.dart`,
  `interview_roadmap_screen.dart` + 2 widgets). Verified unrouted elsewhere
  (`more_features_catalog.dart` already commented "exists but isn't routed
  anywhere yet") before deleting; `flutter analyze` confirms no dangling
  imports.
- `learn_routes.dart`/`journey_routes.dart` updated per the mission-route
  move; `release_redirect.dart` got the one required append (`/journey/session`
  → `/learn/session/today`).
- `test/structure/release_live_data_guard_test.dart`: added entries for every
  new release-visible mission file.
- ARB: ~45 new keys across vi/en/de (mission runner, learn home, can-do,
  topic explore, focus session, learner model); `flutter gen-l10n` run after
  every batch, never hand-edited generated files.

## Validation

- `flutter analyze` on all touched scopes (`lib/features/mission`,
  `lib/screens/journey`, `lib/screens/learn`, `lib/navigation`,
  `lib/data/practice/practice_round_item.dart`): **0 issues**.
- Whole-repo `flutter analyze`: only pre-existing errors in concurrent
  agents' in-progress files (`lib/screens/pronunciation/**`,
  `lib/screens/speaking/widgets/conversation/**`,
  `lib/screens/exam/sprechen/**`, one decks test) — none touch P3 files,
  confirmed via `git diff --stat` scoping.
- `flutter test test/screens/journey test/screens/learn test/features/mission
  test/navigation test/structure` — **all green** (139 tests across those
  dirs, including the full `test/structure/*` suite and
  `release_live_data_guard_test.dart`).
- Existing tests fixed (not weakened) to the new design:
  `mission_session_provider_test.dart` (round-based API),
  `journey_live_mission_test.dart` (AppBar removal, added
  learnerModel/capabilityMap overrides for determinism),
  `mission_session_localization_test.dart` (new resume/complete widgets at
  200% scale — this also caught and fixed a real overflow bug in
  `MissionCompleteOverlay` at 200% scale, now scrollable),
  `learner_model_screen_test.dart` (taller surface for the extra sections),
  `release_redirect_test.dart` (new redirect assertion).
- Regressed the mission flow end-to-end via
  `mission_session_provider_test.dart`: start → round → completeRound →
  completeMission → XP, plus a resume-items case and a round-save-failure
  case (stays on the round, retryable).

## Files changed

**New**: `lib/features/mission/domain/mission_game_type.dart`,
`lib/features/mission/presentation/widgets/{resume_pre_step_view,mission_round_view,mission_complete_overlay}.dart`,
`lib/screens/journey/widgets/{journey_level_journey_strip,journey_capability_map_snapshot}.dart`,
`lib/screens/learn/widgets/{can_do_practice_end_states,goal_reason_line,learner_model_sections,learner_readiness_card,topic_group_card,topic_steering_card,weekly_recap_card}.dart`.

**Modified**: `lib/features/mission/domain/mission_models.dart`,
`lib/features/mission/presentation/{mission_session_page,mission_session_provider}.dart`,
`lib/data/practice/practice_round_item.dart`,
`lib/screens/journey/{journey_screen,widgets/journey_extensions_section,widgets/journey_today_session_card}.dart`,
`lib/screens/learn/{can_do_practice_screen,topic_explore_screen,focus_session_screen,learner_model_screen}.dart`,
`lib/navigation/routes/{journey_routes,learn_routes}.dart`,
`lib/navigation/release_redirect.dart`,
`lib/features/daily_path/presentation/daily_path_route_resolver.dart`,
`lib/l10n/app_{vi,en,de}.arb` + generated l10n,
`test/structure/release_live_data_guard_test.dart`,
`test/navigation/release_redirect_test.dart`,
`test/features/mission/mission_session_provider_test.dart`,
`test/screens/journey/{journey_live_mission_test,mission_session_localization_test}.dart`,
`test/screens/learn/learner_model_screen_test.dart`.

**Deleted**: `lib/features/mission/presentation/widgets/{word_intro_view,practice_view,result_view}.dart`,
`lib/screens/interview/**` (5 files, no test coverage existed for them).

## Unresolved questions / follow-ups

1. `TodaySessionCard`'s 4-stage bucket grid and `WeeklyMissionsStrip` need a
   backend/data-layer decision (new stage-breakdown field on `DailyMission`,
   and a shared bonus-missions provider extracted from the home-screen-owned
   `dashboard_mission_mapping.dart`) before they can be built — flagging for
   plan owner to schedule as a small follow-up pass.
2. `LearningDepthCard` (Biết/Hiểu/Áp dụng) needs a new contract-first probe —
   no existing Flutter-visible field exposes rung-1/2/3 counts split by
   arena.
3. Header goal+persona line on `/learn` needs a `persona` field that isn't
   surfaced anywhere in the current learn/daily-path Flutter models.
4. `docs/web-feature-parity-matrix.md` / `docs/api-changelog.md` were not
   updated this pass (no new backend contract was introduced — `resume_items`
   and `readiness`/`weekly-recap` were already-live fields just previously
   unparsed/unused on the Flutter side) — noting per protocol in case the
   matrix expects an explicit "P3 done" row update.

Status: DONE_WITH_CONCERNS
Summary: Rebuilt the mission runner on the real round-based engine (resume
pre-step → round dispatch via P4's practice views → complete overlay with
XP/streak/climbed-rungs), reworked all 6 screens in the table for web
fidelity (PageIntro, gradient cards, fixed routes, dual empty states), wired
2 previously-unused live fields (`resume_items`, `readiness`), deleted the
Flutter-only `/learn/group` video browser. `flutter analyze` clean on all P3
scopes; all P3 test suites + structure/navigation suites green.
Concerns/Blockers: 3 named deviations above (4-stage session grid, weekly
missions strip, learning-depth card) need backend/data-layer follow-up
beyond this pass's scope — not silently dropped, explicitly documented with
the blocking reason for each.
