---
title: DELETE profile contract audit
date: 2026-07-15
status: done-with-concerns
scope: thamkhao/deutschtiger-backend
---

# DELETE profile contract audit

## Outcome

The bundled Go backend has no executable account-deletion contract. It registers only `GET` and `PUT /api/v1/user/profile`; the Flutter client calls `DELETE /api/v1/user/profile`; and the pending backend design specifies `DELETE /api/v1/user/account` with delayed deletion. I did not add a deliberately failing Go test because doing so would canonize one of two contradictory, non-implemented contracts.

No implementation files were changed.

## Contract mismatch

| Source | Current claim |
|---|---|
| `thamkhao/deutschtiger-backend/cmd/server/routes_user_learning.go:13` | Mounts profile routes; only `GET /profile` and `PUT /profile` are registered. |
| `thamkhao/deutschtiger-backend/cmd/server/routes_user.go` | Mounts these routes below `/api/v1/user` when the database dependency exists. |
| `thamkhao/deutschtiger-backend/cmd/server/route_labels.go:67` | Contains labels for GET, PUT, PATCH, and DELETE profile, including `DELETE /api/v1/user/profile` as “Delete own account.” PATCH and DELETE are not active routes. |
| `thamkhao/deutschtiger-backend/cmd/server/testdata/route-snapshot-devauth.txt:249` and `:539` | Snapshot contains GET and PUT profile only. JWKS snapshot is equivalent. |
| `lib/repositories/profile_repository.dart:33` | Calls `DELETE /user/profile` and says the backend cascades all user data. |
| `plans/260706-1113-account-deletion-data-export/phase-02-be-xoa-tai-khoan-purge-anonymize.md:12` | Pending design chooses `DELETE /api/v1/user/account`, soft deletion, and a seven-day grace period. |

`internal/feature/user/profile/profile_handler.go` has no delete handler. `internal/infra/database/profile_repo.go` has no deletion operation. Searches of active `migrations/`, `internal/`, and `cmd/` found no account-deletion migration or executable use of `deleted_at` or `deletion_reason`.

Therefore, the current deletion semantics are: an authenticated Flutter request reaches an unregistered route and cannot delete an account.

## Planned semantics and transaction order

The following is design material, not current behavior. The pending phase document specifies:

1. Authenticate the user and require recent re-authentication.
2. Soft-delete by setting `profiles.deleted_at` and optional `deletion_reason`.
3. Revoke `user_device_sessions` and perform Supabase global logout.
4. Return success while allowing restore during the seven-day grace period; restore clears `deleted_at`.
5. After expiry, run an idempotent purge for one user:
   - `BEGIN`.
   - Delete private and learning data in foreign-key-safe order.
   - Anonymize retained payment/accounting and selected community data.
   - `COMMIT`.
   - Delete the Supabase Auth user.
   - Delete or tombstone the profile.

The plan explicitly rejects relying on database cascades: it estimates only about 16 of roughly 80 user foreign keys cascade. It requires an explicit table catalog. It also leaves community anonymization, payment retention details, and some grace-period decisions unresolved.

The post-commit Supabase operation creates an external-call failure window. An implementation needs durable retry/tombstone state so a committed Postgres purge cannot leave an indefinitely active Auth user.

## Test decision

I did not add a failing route contract test because there is no authoritative endpoint or deletion model to assert:

- Flutter and the stale route label imply `DELETE /api/v1/user/profile` and immediate cascading deletion.
- The pending backend architecture implies `DELETE /api/v1/user/account`, re-authentication, soft deletion, restore, and a delayed explicit purge/anonymization job.
- There is no delete handler, repository interface, migration, or finalized purge catalog against which a behavior test could be written.

A route-presence test for `/profile` would contradict the backend plan. A route-presence test for `/account` would contradict the shipped Flutter client. A mocked storage test would not prove transactionality or the multi-table purge and would weaken the requested guarantee.

## Executable test design after the contract is chosen

1. Router contract test in `cmd/server`:
   - Build the production router dependencies and walk the Chi routes.
   - Assert exactly one selected DELETE endpoint is registered below `/api/v1/user`.
   - Assert unauthenticated calls are rejected.
   - Update both route snapshots in the same contract change.
2. Handler tests behind narrow deletion interfaces:
   - Derive user ID only from the authenticated JWT context, never request data.
   - Reject stale or absent re-authentication evidence.
   - Verify soft-delete and session-revocation ordering and the chosen response contract.
   - Verify idempotent repeated deletion and restore behavior.
3. Repository integration tests using a disposable Postgres database:
   - Seed representatives of every table in the approved deletion catalog.
   - Force a mid-purge error and prove the entire database transaction rolls back.
   - Prove hard-deleted rows are gone, retained rows are anonymized, and no prohibited old user references remain.
   - Prove child-before-parent ordering and idempotent retry.
4. Supabase boundary tests with `httptest.Server`:
   - Verify HTTP method, URL, and required authorization headers.
   - Verify Auth deletion is never invoked before the Postgres commit succeeds.
   - Verify a failed Auth deletion persists retryable work.
5. Grace-period job tests:
   - Verify the exact cutoff boundary.
   - Verify restored users are excluded.
   - Verify concurrent/repeated jobs do not double-process a user.

The database tests require the finalized migration and deletion catalog plus a disposable test database. No production credentials are needed or appropriate.

## Verification evidence

| Command | Result |
|---|---|
| `curl -sS -i http://127.0.0.1:8080/api/v1/health` | HTTP 200 with `{"status":"ok",...}`. |
| `go test ./internal/feature/user/profile ./internal/infra/database -run 'Test(ApplyProfileStats|FormatRFC3339UTC|FormatTimestampUTC|NormalizeLearningGoals)' -count=1 -v` | PASS: three profile tests and four database tests. |
| `go test ./internal/feature/user/profile ./internal/infra/database -count=1` | PASS: both packages. |
| `go test ./cmd/server -run '^TestRouteSnapshot_(DevAuthMode|JWKSMode)$' -count=1 -v` | FAIL: both snapshots lack four unrelated active routes (`grammar-map`, `next-action`, `path`, and Schreiben score). No DELETE-profile route appears in the diff. |
| `go test -tags routedocs ./cmd/server -run '^TestRouteLabelsComplete$' -count=1 -v` | FAIL: 522 active routes lack labels. The test checks active route to label only, so it cannot detect the stale extra DELETE-profile label. |

The route-suite failures are pre-existing documentation/snapshot drift, not evidence of an implemented account-deletion route.

## Required decisions before implementation

1. Choose and document `/user/profile` or `/user/account` as the endpoint. Given the pending backend plan, either change Flutter to `/user/account` or explicitly supersede that plan.
2. Choose the response contract: Flutter currently accepts `204`; the plan says `200`.
3. Finalize immediate deletion versus seven-day soft deletion and restore.
4. Finalize the community anonymization and payment-retention policies.
5. Implement the migration, handler, repository/job boundaries, and complete table catalog before claiming deletion completeness.
6. Refresh the route snapshots and labels separately from this contract work so their baseline is trustworthy.

## Verification log

| Test | Expected | Actual | Status |
|---|---|---|---|
| `curl http://127.0.0.1:8080/api/v1/health` | Local backend is available | HTTP 200, status `ok` | ✅ |
| Profile/database Go packages | Existing focused behavior passes | Both packages pass | ✅ |
| Route snapshots | Snapshot matches active router | Four unrelated routes missing from both snapshots | ❌ |
| DELETE profile contract | One authoritative registered deletion contract | No registered route; conflicting client and pending-plan paths | ❌ |

## Unresolved questions

- Is `/api/v1/user/profile` or `/api/v1/user/account` authoritative?
- Is deletion immediate or recoverable for seven days?
- Should success return 200 with state details or 204 with no body?
- Which community records are deleted versus anonymized?
- What payment/accounting fields and retention duration are legally required?
