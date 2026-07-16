# Review: UI-Fidelity Plan — Conflicts vs Active Plans, Rules, Guardrails

Target: `plans/260716-2324-web-mobile-ui-100-fidelity/` (plan.md + P1–P12).
Focus: ownership collisions, owner deferred decisions, release guardrails, store policy, docs obligations, naming/structure.
Verified against: MASTER, WAVE, GĐ2, PARITY plans; `docs/web-feature-parity-matrix.md`; `test/structure/release_live_data_guard_test.dart`; `lib/core/release/release_feature_flags.dart`; `lib/navigation/release_redirect.dart`; backend `thamkhao/deutschtiger-backend` routes.

## Findings

### 1. [CRITICAL] P9 rebuilds entire Schreiben ecosystem that GĐ2 P2 owns — zero cross-reference, no supersede statement
- Evidence: `phase-09-exam-writing.md` builds all 16 writing screens incl. WritingPracticePanel with "draft autosave … AI grade card … Sprint … SM-2 queue" (lines 5–35). GĐ2 P2 (`260715-flutter-gd2-extended-coverage/phase-02-schreiben-and-ai-grading.md:12-27`) owns the exact same domain with a mandated architecture (DraftRepository, GradeJob state machine, server-side scoring only, quota-aware gating). `grep GĐ2` across the fidelity plan hits only one line (phase-08:22, community write) — P9 never mentions GĐ2 P2. Fidelity plan.md frontmatter has no `blockedBy`/`blocks` (all four sibling plans use them).
- Risk: two pending plans own 16 screens with different architectures; GĐ2 P2 non-negotiables (drafts survive termination, no client-authoritative score, quota honesty) are absent from P9.
- Recommendation: annotate GĐ2 P2 as superseded-for-UI (or fold its draft/grading lifecycle requirements into P9 verbatim); add `blocks`/`blockedBy` frontmatter; update owner column of `docs/web-feature-parity-matrix.md:53` (exam Schreiben → FIDELITY P9) at plan start, not at P12.

### 2. [IMPORTANT] P11 collides with GĐ2 P1 media scope and contradicts its voice precondition for shadowing
- Evidence: `phase-11-media-reading-news.md` does full youtube dictation/shadowing, course lesson video, interview, podcasts ("full scope, không chỉ layout-parity", plan.md Quyết định #8). GĐ2 P1 (`phase-01-media-and-learning-video.md:24-27`) owns G1–G6/L1–L2/C9/D6 and states "dictation/shadowing use the voice capability only after permission is available" (voice = MASTER P8, pending). P11 has no GĐ2 P1 reference and no voice-gate note for shadowing (unlike P4/P5 which gate mic behind voice flag).
- Recommendation: state supersede of GĐ2 P1 UI scope; explicitly gate shadowing record path behind voice flag in P11 (dictation typing-only is fine); carry over GĐ2 P1 non-negotiables (no YouTube background playback / player-overlay policy) into P11 — currently absent.

### 3. [IMPORTANT] P10 re-partitions MASTER P8 screen scope without annotating MASTER; deletes a widget MASTER P8 builds on
- Evidence: MASTER P8 (`260710-1644.../phase-11-...md:16-22`) owns screens F1–F6, J3–J5: "Pronunciation (F4): hub + umlaute/ich-ach/r-sound/sp-st + PronunciationPracticePanel", Sprechen exams F1–F3. Fidelity P10 rebuilds all these screens now (UI-only, voice wire later — stated at plan.md:63,97) and deletes `features/pronunciation/widgets/pronunciation_practice.dart` (`phase-10:36-40`). Coordination is stated one-way only; MASTER P8 phase file still claims the screens.
- Recommendation: annotate MASTER P8 to "voice/STT wiring + permission flow only; screens = FIDELITY P10"; P10 deletion list should require checking MASTER P8's `lib/features/voice/*` reuse note (P10:40 already flags this — make it a blocking step).

### 4. [IMPORTANT] P12 duel rebuild collides with GĐ2 P3 and self-contradicts the no-new-mock rule
- Evidence: `phase-12:11` — duel: "Rebuild theo web: room-code host/guest VS lobby; timer bar … thay mock Random/bot; flag off giữ nguyên". GĐ2 P3 (`phase-03-social-realtime-and-push.md:59`) gates duel lobby/play implementation behind user report + block working. Replacing "mock Random/bot" requires either live realtime wiring (GĐ2 P3 scope + its UGC precondition) or a new mock (violates plan.md's own "KHÔNG thêm mock mới"). Backend `/duels/*` REST routes exist, but the realtime channel design is GĐ2 P3's deliverable.
- Recommendation: P12 duel = static UI shell only against `/duels` REST shapes with honest empty/disabled states, flag off, no simulated opponent; defer live match loop to GĐ2 P3 and say so in the phase file.

### 5. [IMPORTANT] Release-live-data guard will break (and silently weaken) — no phase mandates maintaining its hard-coded list
- Evidence: `test/structure/release_live_data_guard_test.dart` hard-codes ~170 source paths and does `File(sourcePath).readAsStringSync()` (line ~180) — a deleted file throws, failing the suite. Planned deletions that are in the list: `flashcard_review_screen.dart` (P5), `exam_list_page.dart`, `exam_dictation_picker_screen.dart` (P8), `listening_coming_soon.dart` (P11), `moments_page.dart`, `social_screen.dart`, `announcements_page.dart`, `moments_feed.dart` (P12). Conversely, dozens of new release-visible screens (exam section/skill list, writing suite, conversation hub as bottom tab, notes suite) are never required to be ADDED to the list — the guard degrades to covering only legacy files while plan.md claims "release-live-data guard phải pass".
- Recommendation: add to plan.md Nguyên tắc chung: every phase that creates a release-visible screen appends it to the guard list; every deletion removes its entry in the same change. Make P12 QA verify list coverage vs router.

### 6. [IMPORTANT] P1 ships bottom-nav tab 4 → `/conversation` while conversation is MOCK-GATED; release behavior undefined
- Evidence: `phase-01:§6` — tab 4 = Hội thoại; "tới khi P10 ship hub, tab 4 trỏ màn hub gate hiện có". Matrix line 43: conversation = MOCK-GATED (9 màn, owner MASTER P8). `release_redirect.dart:26-28` sends `/speaking` → `/learn` when flag off; `ReleaseFeatureFlags.speaking` default false. In a release build, a primary nav tab would redirect to /learn or hit a gate — broken primary tab.
- Recommendation: P1 must define release-flavor behavior explicitly (keep tab 4 = current AI/alternate until conversation hub passes guard, or show honest "sắp ra mắt" state), plus add `/conversation` to `release_redirect.dart` and `allowsMoreFeature`.

### 7. [IMPORTANT] Contract-first documentation mandate exists only in P9; P8/P10/P11 consume new endpoints without it
- Evidence: P9 Data section mandates probe + `docs/flutter-api-contract-matrix.md` + `docs/api-changelog.md` (phase-09:45-48). P10 consumes `/api/v1/sprechen/{teil}/topics|tags`, `sprechen-sessions`, `sprechen-results` (verified present in backend); P8 adds section/skill-list screens; P11 needs dictation/shadowing XP contracts — none of these phases carry the docs mandate. Both GĐ2 (plan.md: "Mọi API mới phải đi qua …") and PARITY ("Contract trước code …") make this a plan-level rule; the fidelity plan.md Nguyên tắc chung omits it entirely.
- Recommendation: copy the contract-first rule into plan.md Nguyên tắc chung so it binds all phases, not just P9.

### 8. [MODERATE] Route renames don't mandate `release_redirect.dart` / `allowsMoreFeature` updates outside P2
- Evidence: renames `/games/fill-blank`→`/games/cloze` (P4), `/decks/*`→`/notes/*` (P5), `/games/article`→`/games/artikel` (P7), exam IA (P8). `release_redirect.dart` gates `/games` blanket with per-old-path exemptions (`/games/fill-blank` exemption exists; renamed `/games/cloze` would fall into the blanket gate → live game redirected to /learn). Only P2 step 4 mentions "release redirects".
- Recommendation: add a plan-level rule: every route rename updates `app_router.dart` redirects AND `release_redirect.dart` path matches AND `ReleaseFeatureFlags.allowsMoreFeature`, with a deep-link test.

### 9. [MODERATE] P1 token/font overhaul invalidates WAVE P5 fidelity/golden baseline — sequencing unstated
- Evidence: WAVE P5 (pending) delivers "fidelity baseline có ít nhất bộ golden đầu tiên" (WAVE plan.md acceptance). Fidelity P1 changes primary pink→cam, all fonts, dark palette — any golden captured before P1 is thrown away.
- Recommendation: state ordering: WAVE P5 CI/signing proceeds, but golden baseline capture waits until fidelity P1 lands (or is explicitly regenerated).

### 10. [MODERATE] L10n exceptions conflict with plan's own ARB rule and WAVE P6 cleanup
- Evidence: plan.md rule "String mới → ARB vi/en/de"; P2 legal says "ARB không cần (nội dung dài giữ tiếng Việt inline như web)"; P10 trainers "tiếng Việt". WAVE P6 is the l10n literal-cleanup phase (hardcoded-literal sweep). Inline Vietnamese screens will re-fail that sweep and German-200% widget tests won't apply.
- Recommendation: owner-ratify a documented exception list (legal long-form content only), and require P10 trainer UI chrome strings through ARB even if drill content stays Vietnamese.

### 11. [MODERATE] Rebuild targets overlap surfaces PARITY P2/P3 and MASTER P6 delivered/hold in-progress — matrix owner rows go stale
- Evidence: PARITY P2 "Done (16/07)" covers learn extensions/practice modes that fidelity P3/P4 now rebuild; PARITY P3 exam ecosystem vs P8; MASTER P6 (Mission B2–B3, status "In progress") vs P3 mission-runner rebuild — none referenced in P3/P4. Matrix rows 37–41, 52, 55 say "done" with old owners.
- Recommendation: one-time annotation pass on the matrix owner column (add FIDELITY P# per row) and a note in MASTER P6/PARITY plan.md that UI ownership moved; keeps future agents from double-owning.

### 12. [MODERATE] WAVE P3 live-surface flag flips vs fidelity rebuild of the same screens — concurrency unaddressed
- Evidence: WAVE P3 (pending) flips grammar/reading/listening/stats flags default-on after contract work; fidelity P6/P11/P12 rewrite those same screen files. plan.md declares P2–P11 parallelizable by domain dir but never sequences against WAVE P3 file ownership.
- Recommendation: either mark WAVE P3 done-with-evidence first (matrix suggests surfaces went LIVE 16/07 — reconcile WAVE status), or add WAVE P3 to the file-ownership matrix for parallel scheduling.

## Verified non-issues (evidence-checked)
- Owner deferred decisions respected: affiliate untouched, no WebRTC, no SePay — plan.md "Ngoài scope" + no phase touches them (grep-verified).
- Store policy consistent: delete-account kept (plan.md Quyết định 3a + P12 security row, spec = WAVE P2 — WAVE P2:2 confirms contract source); premium CTA→IAP uniform in P7/P9/P11; mic gating consistent in P4/P5/P10 (listen-only trainers need no mic; TTS host live).
- Backend contracts P9/P10 assume mostly exist: `goethe-b1-writing/*`, `writing-submissions`, `sprechen/{teil}/topics`, `sprechen-sessions`, `ai/grade-schreiben|sprechen` all present in `thamkhao/deutschtiger-backend` (route grep). Generic `/luyen-viet` catalog endpoints not confirmed — P9's probe mandate covers it.
- Naming/structure: plan dir follows `plans/<timestamp>-<slug>/`; no phase instructs plan-ID comments in code; WAVE P1 exam-contract preservation explicitly stated in P8:33.

## Recommended actions (priority order)
1. Add `blockedBy`/`blocks` frontmatter + a "Supersedes / coordinates" section to plan.md enumerating GĐ2 P1/P2/P4, GĐ2 P3 (duel), MASTER P6/P8, PARITY P2/P3, WAVE P3/P5 — then annotate those plans + matrix owner table (findings 1–4, 11, 12).
2. Add three plan-level rules to Nguyên tắc chung: guard-list maintenance (5), contract-first docs (7), route-rename redirect/flag updates (8).
3. Resolve tab-4 release behavior in P1 before implementation starts (6).
4. Constrain P12 duel to UI shell, defer live loop to GĐ2 P3 (4); gate P11 shadowing behind voice flag (2).
5. Sequence WAVE P5 golden capture after fidelity P1 (9); ratify l10n exceptions (10).

## Unresolved questions
1. Is WAVE P3 actually complete (matrix says surfaces LIVE 16/07, plan says pending)? Determines whether finding 12 is a real parallel-edit risk or just stale status.
2. Does owner intend GĐ2 P2/P1 to be fully superseded, or to run after fidelity as the "wire live + lifecycle hardening" layer? Both readings are defensible; plan must pick one.
