# Phase 10 — Speech: sprechen, conversation, pronunciation — Report

Plan: `plans/260716-2324-web-mobile-ui-100-fidelity/phase-10-speech-conversation-pronunciation.md`.
Executed via 3 parallel sub-agents (sprechen-exam ecosystem, conversation ecosystem,
pronunciation ecosystem) with disjoint file ownership, then integrated by this
coordinator pass (routes, ARB merge + gen-l10n, contract-matrix docs, compile-fix
of a cross-phase breakage). Sub-agent reports:
`plans/reports/fullstack-developer-260717-0310-p10-{sprechen-exam-ecosystem,conversation-ecosystem,pronunciation-ecosystem}-report.md`.

## Contract-before-code (done first, per protocol)

Read the real Go backend (`thamkhao/deutschtiger-backend`) route/handler sources
before any UI code: `internal/feature/exam/sprechen/*`,
`internal/feature/content/conversation/*`, `routes_public.go`,
`routes_user_exam.go`, `routes_user_practice.go`, `routes_ai.go`. Recorded a new
"Speech ecosystem — sprechen / conversation / pronunciation (P10)" section in
`docs/flutter-api-contract-matrix.md` (later extended by the pronunciation
sub-agent's own discovery — see below) and an `docs/api-changelog.md` entry that
explicitly supersedes the 2026-07-16 GĐ2 P4 note that had blanket-skipped this
whole cluster as "blocked-by-voice, KHÔNG làm" — that skip was too broad; only
mic capture / Azure PA is actually voice-dependent, the read-only lists and
text-chat turns are not.

## Per-screen status (scout §B.1–B.21)

| # | Screen | Status | Notes |
|---|---|---|---|
| B.1 | Goethe Sprechen overview | Done | Simplified progress display (no gradient bar) |
| B.2 | Goethe Sprechen topic list | Done | Tag groups + leaderboard; no premium toast |
| B.3 | Goethe Sprechen teil study | Done | Rubric/accordions folded into block renderer, not per-section |
| B.4 | Goethe Sprechen teil practice | Done | |
| B.5 | Goethe Sprechen exam (topic) | Done | Tab switch in-widget, not URL-rewrite |
| B.6 | Goethe Sprechen exam-set overview | Done | No non-B1 beta banner |
| B.7/8 | from-exam legacy | Redirect only (not ported, per spec) | Wired in `speech_routes.dart` |
| B.9 | TELC Sprechen overview | Done | |
| B.10 | TELC Sprechen topic list | Done | Search box implemented; `CommunityTopicsSection` omitted |
| B.11 | TELC Sprechen exam | Done | Teil1-pool-mode caller must supply synthetic slug |
| B.12 | Conversation hub | Done | `InterviewLibrarySection` shortcut row deferred (flagged as open question) |
| B.13 | Conversation scenario (chat) | Done | Per-turn feedback badges / suggestions content / holistic verdict are UI shells (depend on `/ai/sprechen-feedback`, `/ai/sprechen-suggestions`, `/ai/conversation-examiner` — MASTER P8 scope, not documented Live/Review); voice mode is idle-shell only |
| B.14 | Conversation history detail | Done | Verdict shown as pending-text, not fabricated |
| B.15 | Interview import | Done | File upload (.md/.txt) dropped — no `file_picker` dep in this phase's scope; paste-only covers full contract |
| B.16 | Pronunciation hub | Done | Correct titles/order/emoji, dead onTap fixed, AppBar removed |
| B.17 | Umlaute trainer | Done | Listen-only, live backend data (see deviation below) |
| B.18 | Ich-/Ach-Laut trainer | Done | |
| B.19 | R-Sound trainer | Done | 4-position overview mode built |
| B.20 | Sp/St trainer | Done | |
| B.21 | Minimal pairs | Done | picker → drill → summary, no game wall (matches web) |

All 21 web pages have a Flutter counterpart. Nothing was silently deferred outside
what's flagged above.

## Contract discovery beyond the initial matrix

The pronunciation sub-agent found the phase brief's "static content" fallback
was wrong — web's 4 trainers + minimal-pairs hit real backend endpoints
(`GET /user/pronunciation/{umlaute|ich-ach-laut|r-sound|sp-st}`,
`GET /minimal-pairs/{contrasts,}`), not bundled JSON. It built a live repository
instead of hardcoding a duplicate word list (would have violated the no-fake-data
rule and drifted from the corpus). Added to the contract matrix by this
coordinator pass, marked `Review` (typed from the web's TS client, not an
independently re-read Go struct — flagged for a live-token probe).

## Deletions (scout §C, confirmed no web counterpart)

- `lib/screens/exam/goethe_speaking_page.dart`
- `lib/screens/speaking/{speaking_screen,speaking_hub_screen,shadowing_page}.dart`
- `lib/screens/speaking/widgets/{ai_conversation_card,shadowing_session_card}.dart`
- `lib/screens/speaking/{umlaute,ich_ach,r_sound,sp_st}_trainer_page.dart` (ported to `lib/screens/pronunciation/`)
- `lib/features/pronunciation/widgets/pronunciation_practice.dart` (+ empty dirs)
- **Not deleted** (documented, not an oversight): `lib/widgets/speaking/pronunciation_practice_widget.dart` — still referenced by `shadowing_page.dart` at the time the pronunciation sub-agent ran; `shadowing_page.dart` itself was deleted moments later by the conversation sub-agent (parallel run, no ordering guarantee between them). Verified post-integration: **zero remaining references** to `pronunciation_practice_widget.dart` anywhere in `lib/` — safe to delete in a follow-up, left in place here since neither sub-agent's ownership boundary covered "delete after the other agent's deletion landed."

Every deleted file's only referrer was `lib/navigation/routes/speech_routes.dart`
(this coordinator's file) — verified via `grep -rln` before/after.

## Cross-phase compile-fix (necessary, minimal)

Deleting `goethe_speaking_page.dart` broke `lib/navigation/routes/exam_routes.dart`
(P8-owned, imports `GoetheSpeakingPage` at the legacy `/exam/goethe-b1/speaking-topics`
route). That whole `/exam/goethe-b1/*` sub-tree is gated off by default
(`ReleaseFeatureFlags.legacyGoetheB1 = false`), so nothing was release-visible
either way. Fixed with the minimal edit needed to keep it compiling: repointed
the import + route builder to `GoetheSprechenExamSetOverviewPage`/
`GoetheSprechenOverviewPage(level: 'b1')` instead of inventing new content,
with an inline comment flagging it for P9 (the file's actual owner) to revisit.

## Integration work (this coordinator pass)

1. **`lib/navigation/routes/speech_routes.dart`** — rewritten: pronunciation
   hub + 5 trainer routes (4 moved to `/pronunciation/*` paths, 1 new
   `/pronunciation/minimal-pairs`); Goethe Sprechen route tree
   (`/exams/goethe/:level/sprechen(/:teil(/:slug(/practice)))` +
   `from-exam` legacy redirects); TELC Sprechen (`/exams/telc-b1/noi`,
   `/exams/telc/b1/noi(/:teil(/:slug(/practice)))`); generic per-exam
   Sprechen (`/exams/:providerLevel/:examSlug/sprechen(/:teilSegment(/practice))`);
   conversation routes (`/conversation/:id`, `/conversation/custom/:slug`,
   `/conversation/history/:id`, `/conversation/interview/import`,
   `/conversation/interview/play/:id`); `conversationShellRoutes` kept as-is
   (P1-wired, still correct).
2. **`lib/navigation/routes/exam_routes.dart`** — minimal 2-line fix described above (P9's file, only touched to prevent a build break I caused).
3. **`lib/navigation/release_redirect.dart`** — append-only: gated the new
   top-level `/exams/goethe/*/sprechen*` and `/exams/telc{-b1/,/b1/}noi`
   paths behind `ReleaseFeatureFlags.speaking` (same reasoning as the
   existing `/conversation` gate — both depend on MASTER P8's AI-chat/grading
   wiring before shipping). `/pronunciation/*` was already covered by the
   existing prefix-matched `pronunciation` flag gate (also default-off) — no
   change needed there.
4. **ARB merge** — merged the two sub-agents' flat `key: vi | en | de` lists
   (conversation: 65 keys incl. interview-import; pronunciation: 58 keys) into
   `app_{vi,en,de}.arb` (138 new keys × 3 languages = 414 entries, with proper
   `@key` placeholder metadata for the 13 parameterized methods), then ran
   `flutter gen-l10n`. **The sprechen-exam sub-agent did not follow the
   ARB-reference instruction** — it hardcoded ~9 pages/8 widgets of Vietnamese
   UI chrome inline instead of referencing not-yet-existing keys, so there was
   no flat list to merge for that cluster (see Concerns below).
5. **`docs/flutter-api-contract-matrix.md`** — added the pronunciation-cluster
   endpoint row the pronunciation sub-agent flagged but couldn't add itself
   (outside its file ownership).
6. **`test/structure/release_live_data_guard_test.dart`** — **not touched**.
   Verified `ReleaseFeatureFlags.speaking` and `.pronunciation` are both
   `defaultValue: false` (unchanged, per instructions) — none of this phase's
   new/moved screens are release-visible under default flags, matching the
   precedent that the old (also flag-gated) speaking/pronunciation screens
   were never in that guard's allowlist either. No entries added or removed.
7. **`lib/view_models/providers.dart`** — not touched; all 3 sub-agents built
   self-contained provider files under `lib/view_models/speech/` and
   `lib/data/pronunciation/pronunciation_providers.dart`, only importing the
   existing `apiClientProvider` — no append needed.
8. **`lib/navigation/app_router.dart`** — not touched; already consumes
   `speechRoutes`/`conversationShellRoutes` generically from P1's wiring, no
   change required.

## Tab-4 final state

Unchanged from P1's wiring, confirmed still correct: `app_router.dart` swaps
shell branch 3 between `conversationShellRoutes` (→ `ConversationHubPage` at
`/conversation`) and `aiShellRoutes` on `ReleaseFeatureFlags.speaking`. Flag
stays at its existing default (`false`) — **not flipped**, per instructions.
When MASTER P8 or a future release decision flips `DEUTSCHTIGER_ENABLE_SPEAKING`
to `true`, the entire built cluster (conversation hub/scenario/history/import,
all Goethe+TELC Sprechen pages, and the `/exams/goethe|telc/.../sprechen*`
release-redirect gates added in this pass) goes live simultaneously with no
further code change. `/pronunciation/*` is independently gated by
`ReleaseFeatureFlags.pronunciation` (also unchanged, default `false`).

## What MASTER P8 must wire (voice/STT/Azure PA boundary, unchanged scope)

- `ConversationVoiceMicPanel` idle-state shell → real waveform/recording/
  transcribing/review states + `RecordingService`/Azure STT hookup
  (`lib/screens/speaking/widgets/conversation/conversation_voice_mic_panel.dart`,
  wraps `features/voice/RecordButton` with a no-op `onRecordingComplete`).
- `SprechenExamMode`'s mic input path (`sprechen_input_area.dart`) — text
  composer is fully live against `/ai/sprechen-partner`; mic capture is not.
- Per-turn scored feedback (`/ai/sprechen-feedback`), suggestions
  (`/ai/sprechen-suggestions`), holistic verdict (`/ai/conversation-examiner`)
  — UI shells exist (pending-state text), live wiring is P8's.
- `features/voice/*` kept untouched/unmodified per instructions, reused as
  the mic tap-target only.

## Validation

- `flutter analyze` (full repo) → **0 errors in any P10 file**. 3 pre-existing
  errors remain in `lib/screens/decks/guided_lesson_screen.dart` (concurrent
  phase's file, not touched by P10 — confirmed via `git log`/`git diff` that
  the file was already modified before this session started).
- `flutter analyze lib/repositories/speech lib/data/speech lib/view_models/speech
  lib/screens/exam/sprechen lib/screens/speaking lib/screens/conversation
  lib/screens/pronunciation lib/data/pronunciation lib/navigation` → **0
  errors/warnings**, 4 pre-existing `info`-level lints only.
- `flutter test` on all P10 test dirs (`test/repositories/speech/`,
  `test/repositories/pronunciation/`, `test/screens/speaking/`,
  `test/screens/conversation/`, `test/screens/pronunciation/`) → **44/44 pass**.
- `flutter test test/structure/release_live_data_guard_test.dart` → 1 failure,
  **pre-existing and unrelated** (`lib/screens/exam/goethe_b1_hub_page.dart`
  contains the literal word "mock" in a doc comment; file was already modified
  before this session started per `git diff HEAD`, not owned or touched by
  P10 — confirmed no P10 file appears in that guard's failure).
- `flutter test test/l10n/app_localizations_test.dart` → 10/10 pass (ARB merge
  did not break existing l10n widget tests).
- `flutter test test/navigation/` → 2 pre-existing failures, both about
  `/listening/easy-german/episode/1` (listening domain, untouched by P10;
  `release_redirect.dart`'s speech-related additions are additive-only and
  did not appear in either failure).

## Concerns / deviations to flag

1. **Sprechen-exam sub-agent hardcoded ~9 pages/8 widgets of Vietnamese UI
   chrome inline instead of referencing ARB keys**, deviating from the
   explicit STRINGS instruction (it flagged this itself rather than hiding
   it). This is a real gap vs. `development-rules.md`'s "New UI strings → ARB"
   requirement — a follow-up pass should extract these into
   `app_{vi,en,de}.arb`. Does not block compile/tests (no missing-key errors,
   since no keys were referenced) and does not weaken the release guard (no
   `mock|fixture|placeholder` identifiers introduced).
2. **`contentId` (exam-question UUID) routing gap**: `SprechenExamMode` pages
   need a UUID for `GET /exams/official/sprechen-content`, but the public
   `/sprechen/{teil}/topics` list response (`{slug,is_premium,order,tag}`)
   never exposes one — no mounted endpoint resolves slug→uuid. Wired via a
   `?contentId=` query-param passthrough that gracefully degrades to an
   error state when absent, documented inline in `speech_routes.dart`;
   real fix needs either a new backend field/endpoint or an `extra`-carried
   ID from whatever screen lists exam content by slug (out of this phase's
   contract — flagging for backend/product decision).
3. **AI response-shape assumptions** (sprechen results/leaderboard/sessions,
   grade-sprechen, conversation turn/opening) are built from `Review`-status
   matrix entries — request shapes are documented, but several response field
   names are best-effort guesses with raw-JSON fallback. Needs a live-token
   probe before this graduates past UI-only.
4. **`InterviewLibrarySection`** (saved-interview quick-access row on the
   conversation hub) was not built — open question left by the conversation
   sub-agent on whether it's needed now or with the interview-scenario
   provider's next consumer.
5. **File upload in interview import** (web has `.md`/`.txt` picker) dropped —
   no `file_picker`/`file_selector` dependency in `pubspec.yaml`; paste-only
   covers the full backend contract. Flag if product wants the dependency
   added in a follow-up.
6. **GameWallOverlay / XP-award infra** genuinely absent from Flutter (grepped,
   confirmed by the pronunciation sub-agent) — completion screens skip the
   "+XP" chip and no game-wall renders before the 4 trainers, matching web's
   gate list (not on minimal-pairs) minus the actual paywall mechanism, which
   doesn't exist yet anywhere in this codebase to reuse.
7. **`pronunciation_practice_widget.dart`** left undeleted (see Deletions
   section) — zero remaining references confirmed post-integration, safe to
   delete in a follow-up.

Status: DONE_WITH_CONCERNS
Summary: All 21 web pages in the phase's screen table rebuilt to web parity (block order/colors/routes) with live backend wiring wherever a documented or newly-discovered contract exists; mic/voice/AI-grading stays UI-shell-only behind the unchanged `ReleaseFeatureFlags.speaking` default-off gate for MASTER P8; tab-4 wiring from P1 confirmed still correct and unchanged; deletions (8 dead Flutter-only screens) confirmed with zero dangling references after integration; ARB merged for 2 of 3 sub-clusters (conversation + pronunciation) and gen-l10n regenerated; one cross-phase compile break (caused by this phase's deletion) fixed minimally in a file this phase doesn't own; full analyze/test sweep shows zero P10-attributable failures.
Concerns/Blockers: (1) sprechen-exam cluster's hardcoded VI strings need an ARB-extraction follow-up; (2) sprechen `contentId` slug→uuid routing gap needs a backend/product decision; (3) several AI/session response shapes are unverified against a live token (documented per-field in the contract matrix); (4) `InterviewLibrarySection` and interview-import file upload deferred by design, not oversight.
