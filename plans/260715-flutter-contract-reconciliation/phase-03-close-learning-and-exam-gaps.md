---
phase: 3
title: "Close Learning and Exam Gaps"
status: in-progress
priority: P0
effort: "4–6d"
dependencies: [1]
---

# Phase 3: Close Learning and Exam Gaps

## Overview

Align port claims with server-authoritative learning behavior, then add the
missing persistent exam-attempt lifecycle needed by the Lesen/Hören player.

## Requirements

- FSRS scheduling and due-time decisions remain on Go/Postgres; Flutter sends
  rating and response time only.
- My Words status enum, query name, labels, counts and deck navigation are
  backed by one server contract.
- Starting deck practice scopes the review queue to its selected deck.
- Exam draft persistence supports resume, timer and audio-play enforcement
  without trusting client-only local state.

## Related Code Files

- Modify: `lib/features/my_words/**`, `lib/repositories/decks/deck_repository.dart`, `lib/screens/decks/deck_detail_screen.dart`, `lib/screens/flashcard/flashcard_review_screen.dart`
- Modify: `lib/features/exam/**`, `lib/navigation/app_router.dart`, `test/features/exam/**`
- Modify: `thamkhao/deutschtiger-backend/cmd/server/routes_user_learning.go`, `routes_user_exam.go`, exam handler/repository/migrations/tests
- Create: explicit exam-attempt draft migration, state types and handler tests

## Implementation Steps

1. Adopt or intentionally migrate the mounted learning contract:
   `GET /user/my-words?filter=saved|seen|reviewing`,
   `GET /user/flashcard-decks`, `GET /user/srs/queue`, and
   `POST /user/srs/review`. If product copy requires `learning|known|review`,
   version the server enum and update web + Flutter atomically; do not translate
   query values only on one client.
2. Add selected-deck queue support. Prefer an explicit authenticated server
   filter/endpoint with ownership validation, fixture tests for two decks, and
   a Flutter route/provider that preserves deck ID through completion.
   
   Progress 2026-07-15: `GET /user/srs/queue?deck_id=` now scopes through
   the authenticated backend query, includes unreviewed cards in that deck,
   and Flutter passes `deckId` from deck detail to the review session. A live
   two-user/two-deck database fixture remains required before this item can be
   marked complete.
3. Remove client-side scheduling assumptions. Render server due timestamps in
   the user time zone; add app↔web round-trip tests with one account and log
   server queue counts before/after review.
4. Design and migrate exam attempts as a state machine:
   `in_progress → submitted | abandoned`. Persist exam/part identity, mode,
   answers, remaining seconds, audio play counts, last activity and a version
   for optimistic concurrency. Existing submitted-history rows must remain
   readable or be migrated explicitly.

   Progress 2026-07-15: audit found that Flutter keys answers as `q<entry_id>`,
   while `entry_id` can repeat between sections. The draft foundation therefore
   introduces a canonical `partId/sectionIndex/entryId` reference in mapped
   content and a separate owned/versioned `exam_attempt_drafts` table. Flutter
   now migrates unambiguous cached IDs and uses these references for draft
   persistence and submit.
5. Add authenticated routes: create draft, fetch one owned draft, idempotent
   partial update, and final submit. Server validates question shape/answer
   ownership, derives score/result, and makes submitted attempts immutable.
   A job or read-path transition marks expired drafts abandoned.

   Progress 2026-07-15: submit uses the normalized exam-content snapshot
   captured when the draft is created, rather than client score fields or live
   content that may later change. It records an append-only attempt and result
   in the same transition; Flutter is wired with retry-safe resume/submit. A
   live Postgres fixture remains.
6. Build Go integration tests for cross-user access, concurrent autosaves,
   max-play rejection, expired drafts, and final-submit idempotency. Then wire
   Flutter notifier/renderer tests and a device resume scenario.

## Success Criteria

- [ ] My Words and deck screens show the same statuses and cards the backend
  returns; another user's/deck's cards cannot enter the session.
- [ ] Five ratings from Flutter change the same authenticated web due queue;
  evidence includes before/after API values.
- [ ] An exam draft survives app termination with correct answers, timer and
  audio plays; no other user can read or mutate it.
- [ ] Server rejects a final answer change, stale update conflict and an audio
  replay beyond `max_plays`.
- [ ] Submitted exam score/result is server-derived and remains readable in history.

## Risk Assessment

- Reusing append-only `exam_attempts` for drafts without a status/version
  migration invites corrupted history and client-trusted scoring.
- A deck filter must be enforced server-side; filtering an all-card queue only
  in Flutter leaks queue data and produces incorrect review counts.
