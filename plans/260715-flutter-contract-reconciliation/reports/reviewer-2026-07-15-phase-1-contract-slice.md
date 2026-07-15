# Phase 1 Flutter contract slice review

## Finding

### P2 — The device-kicked test claims production evidence it does not establish

`test/services/api_client_test.dart:42` names the test `device-kicked error
field matches the production contract`, but it supplies `{"error":"device_kicked"}`
from an in-memory Dio adapter. The reviewed route registrations only establish
that `GET /api/v1/user/profile` is mounted; they do not establish an error-body
schema or header semantics. Keep this as a client parsing/regression test (and
rename it accordingly), or add separate Go handler/integration evidence before
calling it a production contract.

## Verified

- `GET` and `PUT /user/profile` resolve to authenticated
  `/api/v1/user/profile` routes via `mountUserProfile`; the repository test
  asserts both requests and the sparse `display_name` payload.
- `GET /user/dashboard-init` resolves to authenticated
  `/api/v1/user/dashboard-init`; the dashboard repository test asserts the
  intended request and parses the response fixture.
- The matrix's rows backed by `routes_user.go` and
  `routes_user_learning.go` match the registered method/path pairs, including
  devices, heartbeat, streak claim, SRS queue/review, my-words, and learn
  mission/path routes. Routes guarded by handler availability or DB connection
  remain runtime-conditional; the matrix should not be read as a live-runtime
  probe.
- Account deletion is explicitly out of scope. The reviewed registration files
  mount no `/user/account` deletion route, and `ProfileRepository` no longer
  calls one.

## Verification

`flutter test test/repositories/phase_1_contract_test.dart test/services/api_client_test.dart`
passed: 5 tests, 0 failures. The package-info plugin warnings are expected in
the test harness and did not affect results.

## Unresolved questions

- None for the scoped route-registration evidence. Handler-level error schema
  and production-runtime availability require evidence outside this slice.
