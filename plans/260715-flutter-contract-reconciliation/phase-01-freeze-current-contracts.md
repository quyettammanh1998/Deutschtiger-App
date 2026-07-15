---
phase: 1
title: Freeze Current Contracts
status: in-progress
priority: P0
effort: 1–2d
dependencies: []
---

# Phase 1: Freeze Current Contracts

## Overview

Create an evidence-backed API inventory before changing Flutter or Go behavior.
This prevents updating one client to a route that is only documented, stale, or
implemented with different lifecycle semantics.

## Requirements

- Treat mounted Go Chi routes plus handler request/response types as current
  server truth; route labels alone are not an API contract.
- Enumerate every authenticated Flutter request in Phase 1–6 domains and map it
  to router, handler, request schema, response schema, auth/error behavior and
  owner.
- Preserve the API rule: migrations are additive; breaking changes need a
  versioned transition or coordinated client/server deployment.

## Related Code Files

- Create: `docs/flutter-api-contract-matrix.md`
- Modify: `docs/api-changelog.md`
- Modify: Flutter repository/API tests under `test/repositories/`, `test/services/`
- Modify: backend route/handler tests under `thamkhao/deutschtiger-backend/cmd/server/` and affected feature packages

## Implementation Steps

1. Inventory Flutter calls in profile/deletion, auth/device, SRS/my-words,
   flashcard decks, dashboard heartbeat, missions and exams. Record the exact
   relative path passed to `ApiClient`, HTTP method, request body and expected
   status.
2. For each call, trace the mounted `/api/v1/user/*` Go route to its handler
   and repository. Mark: live, client-only, server-only, or semantic mismatch.
3. Seed the matrix with known evidence: `/user/profile` is GET/PUT only;
   `/user/heartbeat`, `/user/srs/queue`, `/user/srs/review`,
   `/user/my-words`, `/user/flashcard-decks`, and mission routes are mounted;
   exam attempts are create/list only.
4. Add one contract test at each changed boundary: Flutter tests request method,
   path and payload; Go route tests assert that the selected endpoint is
   mounted. Keep labels and route snapshots in sync in the same change.
5. Add planned additions to `docs/api-changelog.md` with owner, migration/
   deployment order, and mobile minimum-app-version handling where needed.

Progress 2026-07-15: the two golden router inventories were reconciled with
the mounted server in a separate baseline update. Both DevAuth and JWKS modes
now assert the same 554 route topology; this does not by itself prove the
remaining client-to-handler contract matrix is complete.

## Success Criteria

- [ ] Matrix lists all Phase 1–6 authenticated requests with a source link on
  both client and server sides.
- [ ] No route used by Flutter is supported only by a label/comment.
- [ ] Every accepted mismatch has a named compatibility strategy and contract test.
- [ ] Existing unrelated route-snapshot drift is either repaired in a separate
  committed baseline or clearly excluded from the new route assertions.

## Risk Assessment

- Route snapshots are already stale; do not use a globally failing snapshot as
  proof that a new route is missing. Add narrow route-presence coverage first,
  then repair the baseline separately.
- API paths must remain relative to the configured `/api/v1` base URL; avoid
  mixing `/api/v1/...` and `/...` in `ApiClient` consumers.
