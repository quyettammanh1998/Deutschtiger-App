# Selected-deck FSRS queue review — 2026-07-15

Scope: read-only review of selected-deck queue backend/Flutter path and named
contract tests. Account deletion and exam drafts excluded.

## Findings

### P1 — Rating request does not enforce its one-identifier contract

`ReviewRepository.rate` serializes both `learning_item_id` and
`source_flashcard_id` unconditionally, while its own contract and
`ReviewItem` documentation require exactly one non-null source identifier.
The handler rejects neither-only input but also accepts both, and the schema
permits both identifiers. A malformed/global queue response can therefore rate
the learning-item identity instead of the intended flashcard identity.

Evidence: `lib/repositories/flashcard/review_repository.dart:56-70`,
`lib/data/flashcard/review_item.dart:8-11`,
`thamkhao/deutschtiger-backend/internal/feature/gamify/game/srs_review_handler.go:150-161`,
`thamkhao/deutschtiger-backend/migrations/039_card_reviews_fsrs.sql:35-47`.
The provider test itself supplies both IDs in its fake card, but never captures
the POST body, so it does not protect this invariant.

## Confirmed behavior

| Requirement | Result | Evidence |
|---|---|---|
| Omitted/blank `deck_id` keeps the global queue | Pass | Handler calls `BuildQueue` when parsed ID is empty. |
| Invalid `deck_id` is rejected | Pass | UUID parser returns an error; handler maps it to HTTP 400. |
| Selected queue is server scoped to user and deck | Pass by code inspection | SQL predicates are `f.user_id = $1` and `f.deck_id = $2`; review join also binds `cr.user_id = $1`. |
| Unreviewed deck cards carry `source_flashcard_id` | Pass by code inspection | Left join permits no `card_reviews` row and selects `f.id` as `source_flashcard_id`; `learning_item_id` is intentionally NULL. |
| Daily review remains global | Pass by code inspection | Daily scope has no deck ID; client omits `deck_id`; backend invokes the unchanged global builder. |

## Verification performed

| Test | Expected | Actual | Status |
|---|---|---|---|
| `go test ./internal/feature/gamify/game` | queue-ID parsing tests pass | passed | ✅ |
| `flutter test test/repositories/phase_3b_repository_contract_test.dart test/view_models/review_session_provider_test.dart` | client/provider contracts pass | 6 tests passed | ✅ |

## Missing evidence

No Go database/integration fixture creates two users, two decks, due and
unreviewed cards, then proves the endpoint returns only the current user's
selected-deck cards. The Go test only exercises `parseQueueDeckID`; the Flutter
test uses a mock transport and a non-UUID deck ID. No authenticated live API
before/after-rating evidence exists. This matches the Phase 3 plan's stated
remaining release gate.

Status: DONE_WITH_CONCERNS
Summary: Server deck filtering and global daily-review routing are correct by code inspection; focused tests pass, but the rating one-ID invariant is not enforced and DB/live ownership evidence is absent.
Concerns/Blockers: Fix the rating identifier invariant and add a two-user/two-deck database fixture plus authenticated live verification before declaring the feature complete.
