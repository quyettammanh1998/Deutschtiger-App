# Exam-draft foundation review

## Findings

### P1 — Mutation retries stop being idempotent after the next autosave

`internal/infra/database/exam_draft_repo.go:99-100` records only the most
recent `last_mutation_id`. On a version miss, `:117-129` treats a request as a
successful retry only when that single column still equals the request's
mutation ID. If mutation A commits but its response is lost, then mutation B
commits before A is retried, A returns `409` even though it already succeeded.
This contradicts the retry-safety claim in the repo comment and loses the
authoritative result for normal multi-device or delayed-network retry flows.

Persist mutation receipts per draft (mutation ID plus resulting version/state)
for the retry window, or narrow the API contract to serialized retries before
any subsequent mutation. Add an integration test for A committed → B committed
→ retry A.

### P1 — `answers` and `audio_plays` accept JSON `null`, breaking the map contract

`validAnswerMap` and `validAudioPlayMap`
(`internal/feature/exam/exam/exam_user_draft_handler.go:138-167`) unmarshal
into a map and do not reject a nil map. In Go, unmarshalling JSON `null` into a
map succeeds, so `PATCH {"answers":null}` / `{"audio_plays":null}` passes
validation and stores JSONB `null` via the repository's `COALESCE` update
(`exam_draft_repo.go:92-104`). `NOT NULL` only rejects SQL NULL; it does not
reject JSONB null. This conflicts with the declared object defaults and the
sparse-update comment that says an empty object clears a map.

Reject null explicitly (`map == nil`), and add a database `jsonb_typeof(...) =
'object'` constraint so direct/future writes cannot bypass the handler. Add
validator and persistence coverage for both fields.

### P2 — PATCH accepts a version-only no-op and creates a conflict

`validDraftUpdate` (`exam_user_draft_handler.go:129-136`) returns true when no
mutable field is supplied. A request containing only `version` and
`mutation_id` therefore bumps `version` and `last_activity_at` at
`exam_draft_repo.go:93-101`, causing other clients' legitimate update at the
previous version to conflict despite no state change. Require at least one
mutable field, unless a versioned heartbeat is an intentional, documented
operation with its own endpoint/semantics.

## Verified

- Ownership predicates consistently scope GET, UPDATE, conflict probing, and
  expiry to `user_id`; foreign/missing draft IDs map to the same 404 path.
- The routes are inside the authenticated `/api/v1/user` group and the existing
  exam premium gate. No public draft route was introduced.
- Expiry now runs before create, get, and patch, so an expired draft cannot be
  revived through PATCH.
- The migration's lifecycle check now enforces mutually exclusive
  in-progress/submitted/abandoned timestamp/reference combinations.
- Flutter's `contentReference` is additive and disambiguates repeated entry IDs
  by part and section. It does not yet claim to submit server-authoritative
  drafts.

## Verification

- `go test ./internal/feature/exam/exam` — pass.
- `flutter test test/features/exam/exam_service_test.dart` — pass (3 tests).

## Unresolved questions

- `exam_id` and canonical question references are syntax-validated but not
  checked against the catalog in this foundation. That may be deliberate until
  the submit transition validates content; it must not be represented as
  server-authoritative scoring/content validation yet.
