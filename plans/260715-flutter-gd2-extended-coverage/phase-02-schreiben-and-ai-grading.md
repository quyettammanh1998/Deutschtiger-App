---
phase: 2
title: "Schreiben and AI Grading"
status: pending
priority: P1
effort: "2–3w"
dependencies: []
---

# Phase 2: Schreiben and AI Grading

## Overview

Deliver E1–E7 and the Schreiben extension of the exam player with durable
drafts, transparent async AI-grading state and quota-aware premium gating.
Existing writing pages and backend submission routes require contract validation
before they can be considered a viable mobile writing workflow.

## Requirements

- A draft survives app termination/backgrounding; grading results are recovered
  from the server rather than retriggered or lost.
- Flutter submits German text through `ApiClient`, observes backend AI quotas
  and renders partial/failed results honestly.
- Exam writing uses the same submit/attempt lifecycle introduced by the exam
  contract reconciliation plan; it must not calculate an authoritative score in
  the client.

## Architecture

```text
WritingEditor → DraftRepository → server draft/submission
      │              │
      ├─ word count, local UI state
      └─ GradeJob state: queued | running | partial | complete | failed
                             ↓
                        FeedbackRenderer
                 (criteria, spans, next action, retry rules)
```

## Related Code Files

- Modify: `lib/screens/ai/ai_writing_practice_page.dart`, `lib/screens/exam/goethe_b1_writing_page.dart`, `lib/screens/exam/widgets/writing_topics_list.dart`
- Create: `lib/features/writing/{data,domain,presentation}/**`, `test/features/writing/**`
- Modify: `lib/features/exam/**` after Phase 4 draft lifecycle is available
- Verify: `thamkhao/deutschtiger-backend/cmd/server/routes_ai.go`, `routes_user_exam.go`, writing handlers/repos and their tests

## Implementation Steps

1. Write the submission/draft/grading contract matrix: public prompts versus
   authenticated drafts/submissions, payload limits, timeout/cancel behavior,
   quota response and result polling/readback. Add backend additions before
   Flutter relies on local-only drafts.
2. Build a focused writing editor: German keyboard hint, word count, accessible
   focus/keyboard handling, local unsaved indicator, debounced authenticated
   draft save and recovery after restart. Never store a bearer token or raw
   private draft in analytics/crash breadcrumbs.
3. Implement catalog, level/topic selection, custom prompts, fullscreen
   Schreiben view and Goethe B1 paths. Reuse one editor/result model instead of
   adding divergent pages.
4. Model AI grading as cancellable asynchronous work. Show a bounded waiting
   state, explicit retry only when safe, partial results for quota/batch limits,
   and feedback spans that tolerate malformed/unknown AI fields.
5. Port writing sprint as a state machine (intro → session → timed writing →
   result), persist resume state server-side, and keep printable cheatsheets
   web-only unless a native share/print design is approved.
6. Add community topics/my submissions and exam Schreiben integration after
   report/moderation requirements from Phase 3 are available. Verify a single
   answer scores consistently with the web under the approved model/version.

## Success Criteria

- [ ] Kill/relaunch during a draft restores text and workflow state without
  duplicate submission or grading.
- [ ] One authenticated writing submission returns/reloads the same grade and
  normalized feedback on Flutter and web.
- [ ] Quota/timeout/partial-result states never imply grading succeeded when it
  did not; retry behavior is idempotent.
- [ ] Writing sprint completes one full flow with timer, resume and explicit
  exit handling.
- [ ] Exam Schreiben result is server-derived and appears correctly in review
  and final result screens.

## Risk Assessment

- AI can take longer than a mobile foreground window. Persist job identity and
  poll/read result after resume; do not hold a widget future for the whole job.
- AI feedback is untrusted structured input: validate ranges/spans before
  rendering and fall back to plain feedback instead of crashing.
