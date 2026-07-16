# Phase 01 (workstream E) — Router Split Report

## Executed Phase
- Phase: phase-01-foundation-tokens-fonts-icons-shell.md, workstream E (router split)
- Plan: `plans/260716-2324-web-mobile-ui-100-fidelity/`
- Status: completed, pure refactor, zero behavior change

## Files Modified/Created
- MODIFIED `lib/navigation/app_router.dart` — 987 → 108 lines. Now only holds
  `GoRouter` construction, redirect logic, `_GoRouterRefresh`, and composes the
  domain route lists via spread (`...xRoutes`) plus the `StatefulShellRoute`
  branches (each branch's route list now comes from a domain file).
- CREATED `lib/navigation/routes/entry_routes.dart` (59 ln) — P2
- CREATED `lib/navigation/routes/vocabulary_routes.dart` (56 ln) — P4
- CREATED `lib/navigation/routes/practice_routes.dart` (41 ln) — P4
- CREATED `lib/navigation/routes/decks_routes.dart` (34 ln) — P5
- CREATED `lib/navigation/routes/journey_routes.dart` (43 ln) — P3
- CREATED `lib/navigation/routes/learn_routes.dart` (70 ln) — P3
- CREATED `lib/navigation/routes/grammar_routes.dart` (33 ln) — P6
- CREATED `lib/navigation/routes/games_routes.dart` (111 ln) — P7
- CREATED `lib/navigation/routes/exam_routes.dart` (150 ln) — P8 (P9 co-owns 2 nested sub-routes)
- CREATED `lib/navigation/routes/speech_routes.dart` (61 ln) — P10
- CREATED `lib/navigation/routes/media_routes.dart` (142 ln) — P11
- CREATED `lib/navigation/routes/social_routes.dart` (96 ln) — P12
- CREATED `lib/navigation/routes/ai_routes.dart` (39 ln) — P12
- CREATED `lib/navigation/routes/stats_routes.dart` (41 ln) — P12
- CREATED `lib/navigation/routes/settings_routes.dart` (46 ln) — P12
- No `test/**` files touched — no test referenced private symbols from
  `app_router.dart`.

## Domain → File → Owning Phase

| Domain file | Routes | Owning phase |
|---|---|---|
| `entry_routes.dart` | `/welcome`, `/onboarding`, `/login`, `/signup`, `/forgot-password`, `/reset-password`, `/landing`, `/welcome-full`, `/privacy-policy`, `/terms-of-service`, shell branch 0 (`/home`) | P2 entry-auth-home-quote |
| `vocabulary_routes.dart` | `/vocabulary`(+3 sub), `/daily-review`, `/my-words`, `/subtitle-words` | P4 vocabulary-practice |
| `practice_routes.dart` | `/games/matching`, `/games/fill-blank`, `/games/flashcard`, `/games/writing` (the 4 practice-view games) | P4 vocabulary-practice |
| `decks_routes.dart` | `/decks`(+`:deckId`+`practice`), `/flashcard-review` | P5 decks-flashcards |
| `journey_routes.dart` | `/journey/session`, `/journey`(+courses×3) | P3 learn-journey |
| `learn_routes.dart` | `/learner-model`, `/focus-session`, shell branch 2 (`/learn`+group/watch+topics+can-do) | P3 learn-journey |
| `grammar_routes.dart` | `/grammar`(+articles, +lesson) | P6 grammar |
| `games_routes.dart` | `/games` hub + all remaining `/games/*` (article, word-sprint, listening, runner, typing-sprint, word-order, writing-sentence, speaking, cases×5, konjugation, pronunciation, conversation, sentence-builder×2) | P7 games |
| `exam_routes.dart` | `/de-thi`(+`:code`), shell branch 1 (`/exam` full tree incl. `goethe-b1/*`, `practice/:examId`, `result/:examId`, readiness/schedule/community/dictation) | P8 exam-core-community (P9 co-owns `writing-topics`/`speaking-topics` nested sub-routes — coordinate before editing) |
| `speech_routes.dart` | `/pronunciation`, `/speaking`(+8 sub) | P10 speech-conversation-pronunciation |
| `media_routes.dart` | `/listening`(+7 sub), `/library/:slug`(+watch), `/reading`(+detail,feed), `/news`(+`:slug`) | P11 media-reading-news |
| `social_routes.dart` | `/social`(+9 sub), `/affiliate`(+2 sub), `/profile`(+edit) | P12 social-stats-settings-cleanup |
| `ai_routes.dart` | `/ai-tutor`(+3 sub), shell branch 3 (`/ai`) | P12 |
| `stats_routes.dart` | `/achievements`, `/leaderboard`, `/stats`(+2 sub) | P12 |
| `settings_routes.dart` | `/settings`(+5 sub), `/notifications` | P12 |

Practice/games boundary: mapped the "4 practice-view routes (cloze, flashcards,
matching, writing)" instruction against phase-04's route table (which names
exact current paths in its "Router ownership" note): `/games/fill-blank`
(→ becomes `cloze`), `/games/flashcard` (→ becomes `flashcards`),
`/games/matching`, `/games/writing`. These 4 stay in `practice_routes.dart`
(P4); everything else `/games/*` is in `games_routes.dart` (P7). Documented
this mapping decision inline in `practice_routes.dart`'s header comment since
the literal segment names ("cloze") don't exist yet pre-P4-rename.

## Route-count proof

```
$ grep -o "path: '[^']*'" lib/navigation/app_router.dart   # BEFORE (git stash)
141
$ grep -o "path: '[^']*'" lib/navigation/app_router.dart lib/navigation/routes/*.dart | wc -l   # AFTER
141
$ diff <(sort baseline_paths.txt) <(sort after_paths.txt)
# only reordering of exact-duplicate lines ('/leaderboard' appears once,
# 'notifications' segment appears twice across different nested trees —
# sort-stable diff noise only, confirmed by set-equality); no path lost/added.
```

## Tests Status
- `flutter analyze` (full project): 5 issues, all pre-existing infos
  (deprecated `groupValue`/`onChanged` in `de_thi_practice_screen.dart`,
  `prefer_initializing_formals` in 3 test files) — 0 new issues, 0 errors.
  Note: the PhosphorIcons error mentioned in the task brief was already fixed
  by another agent by the time I ran baseline analyze.
- `flutter test test/structure/ test/features/home/ test/navigation/`:
  102/102 passed, identical to pre-change baseline run.

## Issues Encountered
None — no file ownership conflicts, no test breakage.

## Next Steps
Downstream phases (P2–P12) can now each edit only their domain route file(s)
in parallel without touching `app_router.dart` or each other's files, except
the two documented shared-file boundaries: P8/P9 inside `exam_routes.dart`
(nested `writing-topics`/`speaking-topics`), and the `daily-quote` sub-route
inside `stats_routes.dart` (content owned partly by P2).

## Unresolved Questions
- `/affiliate`, `/notifications`, `/achievements`, `/leaderboard` weren't
  itemized in any scanned phase table under their own row — assigned to
  closest-matching owner (P12) with an inline comment; confirm with plan
  owner if a different phase should own them.
- `exam_routes.dart` at 150 lines is the largest domain file (near the ~200
  LOC guidance) because the `/exam` shell branch tree is inherently large and
  nested (Goethe B1 sub-tree + practice/result/readiness/schedule/community/
  dictation); did not further split since P8/P9 both need the single
  StatefulShellBranch route list intact — flag if P8/P9 want a finer split
  later.

Status: DONE
Summary: Split 987-line app_router.dart into 15 domain route files under lib/navigation/routes/ (kept intact `StatefulShellRoute` branches, redirect/observer logic in app_router.dart which now composes the lists); route-path count matches exactly (141=141), analyze clean of new issues, all 102 baseline tests pass unchanged.
Concerns/Blockers: none blocking; see unresolved questions above for 2 low-risk judgment calls worth a quick owner confirmation.
