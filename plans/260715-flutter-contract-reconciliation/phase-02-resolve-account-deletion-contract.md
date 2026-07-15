---
phase: 2
title: "Resolve Account Deletion Contract"
status: pending
priority: P0
effort: "3–5d implementation + policy decisions"
dependencies: [1]
---

# Phase 2: Resolve Account Deletion Contract

## Overview

Make in-app deletion real and store-compliant. The current Flutter call to
`DELETE /user/profile` cannot work because the route is not mounted. The
existing backend plan proposes a safer single contract; it becomes authoritative
only after the three product/legal decisions below are approved.

## Decision Gate

Recommended contract, already documented in the backend plan:

- `DELETE /api/v1/user/account`, authenticated and protected by recent re-auth;
- set `profiles.deleted_at`, revoke all sessions, then return pending-delete;
- `POST /api/v1/user/account/restore` during a seven-day grace period;
- scheduled hard purge/anonymization after expiry, then Supabase Auth deletion.

Owner must explicitly approve or replace: (1) seven-day grace versus immediate
deletion, (2) anonymize versus delete public community contributions, and
(3) payment/accounting retention policy. Do not choose these silently in code.

## Related Code Files

- Reuse/complete: `thamkhao/deutschtiger-backend/plans/260706-1113-account-deletion-data-export/phase-02-be-xoa-tai-khoan-purge-anonymize.md`
- Create: backend `internal/feature/user/account/*`, account migration, purge job and focused tests
- Modify: backend account routes/dependencies/route labels and deployment runbook
- Modify: `lib/repositories/profile_repository.dart`, `lib/screens/settings/delete_account_screen.dart`, `lib/screens/settings/security_screen.dart`
- Modify: web deletion page and public URL configuration in the web frontend/deployment repository

## Implementation Steps

1. Record the approved lifecycle and response schema in the contract matrix;
   remove stale `DELETE /user/profile` labels rather than leaving aliases that
   can diverge.
2. Add migration for soft-delete state, a deliberate sentinel/anonymization
   strategy, and indexes. Build a table catalog from all user-owned tables;
   classify every table as hard-delete, anonymize/retain, or out of scope with
   a reason.
3. Implement account handler/repository boundaries. Derive user ID only from
   JWT; verify re-auth evidence; atomically soft-delete and revoke device
   sessions. Put irreversible Supabase operations after durable PostgreSQL
   state and record retryable failure work.
4. Implement restore and an idempotent purge job. Test transaction rollback,
   repeated runs, table coverage, anonymization, and an Auth API failure after
   DB commit.
5. Update Flutter only after live route tests pass: explain lifecycle, require
   `XÁC NHẬN`, clear local auth on success, and present restore state if chosen.
   The web deletion page must use the same endpoint and response contract.

## Success Criteria

- [ ] One documented DELETE route is mounted, labeled, and covered by router and handler tests.
- [ ] Unauthenticated/stale-re-auth requests fail; a valid request revokes sessions.
- [ ] A disposable-user integration test proves soft-delete, restore (if kept),
  purge/anonymization catalog, and idempotency.
- [ ] Flutter and web flows exercise the same endpoint with no fallback to `/user/profile`.
- [ ] `https://deutschtiger.com/delete-account` is reachable and describes the real lifecycle before Data Safety submission.

## Risk Assessment

- Account deletion is destructive and spans local Postgres plus Supabase; never
  claim completion from widget tests alone.
- A purge catalog omission can retain PII. The only adequate proof is a seeded
  database test that checks every table known to store the original user ID.
