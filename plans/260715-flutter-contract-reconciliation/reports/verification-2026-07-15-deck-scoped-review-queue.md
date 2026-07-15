# Deck-Scoped Review Queue Verification — 2026-07-15

Scope: additive `deck_id` filter on the existing authenticated FSRS queue and
the Flutter handoff from deck detail to review session.

## Contract

- `GET /api/v1/user/srs/queue?deck_id=<uuid>&limit=<n>` keeps the existing
  `QueueCard` response schema.
- The backend query constrains both `flashcards.deck_id` and
  `flashcards.user_id = JWT user`; it returns due deck cards plus cards without
  a `card_reviews` row. The first rating continues to post
  `source_flashcard_id` to the existing `/user/srs/review` endpoint.
- The no-`deck_id` path remains the global FSRS queue.

## Evidence

| Test | Expected | Actual | Status |
|---|---|---|---|
| `go test ./internal/feature/gamify/game ./internal/feature/learning/srs` | Queue query parsing and SRS package tests pass | Passed | ✅ |
| `go test ./cmd/server -run '^$'` | Server compiles with the new handler/queue call | Passed | ✅ |
| `flutter test test/repositories/phase_3b_repository_contract_test.dart test/view_models/review_session_provider_test.dart test/screens/decks/deck_detail_localization_test.dart` | Deck path/query, provider scope, and single-rating-identity regressions pass | 10 tests passed across the final focused rerun | ✅ |
| `flutter analyze` | No diagnostics | No issues found | ✅ |
| `flutter test -r compact` | Full Flutter suite passes | 248 tests passed | ✅ |
| `flutter build apk --debug` | Android debug APK compiles | Built `build/app/outputs/flutter-apk/app-debug.apk` | ✅ |

## Unverified release evidence

- The local API was unavailable, so no authenticated curl/device session was
  run.
- A PostgreSQL integration fixture with two users and two decks is still needed
  to prove ownership isolation and SQL result membership against a real schema.
- The full Go router suite still has the separately documented stale snapshot
  baseline; this slice did not refresh that snapshot.

## Review follow-up

Independent review found that a malformed queue item could previously send both
`learning_item_id` and `source_flashcard_id`. `ReviewRepository.rate` now
rejects zero or dual identities before issuing HTTP, and its regression test
proves a deck card sends only `source_flashcard_id`.
