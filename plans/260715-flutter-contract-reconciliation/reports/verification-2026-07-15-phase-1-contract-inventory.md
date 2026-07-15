# Phase 1 Contract Inventory Verification — 2026-07-15

Scope: Flutter account/device/dashboard, FSRS/decks, daily path, mission, exam
attempt, and translation boundaries listed in `docs/flutter-api-contract-matrix.md`.

## Evidence

| Test | Expected | Actual | Status |
|---|---|---|---|
| `flutter test test/repositories/phase_1_contract_test.dart test/repositories/device_session_repository_test.dart test/repositories/phase_3b_repository_contract_test.dart test/repositories/flashcard_quick_save_repository_test.dart test/features/home/dashboard_phase_3c_test.dart` | Request method/path/payload and parser boundaries pass | 15 tests passed | ✅ |
| `flutter analyze` | No diagnostics | No issues found | ✅ |
| `flutter test` | Full Flutter suite passes | 244 tests passed | ✅ |
| `go test ./cmd/server` from `thamkhao/deutschtiger-backend` | Router/package suite passes | Failed only `TestRouteSnapshot_DevAuthMode` and `TestRouteSnapshot_JWKSMode`: checked-in snapshots lack four pre-existing mounted routes | ⚠️ excluded baseline drift |

## Snapshot exclusion

The Go failure is not evidence that a Flutter-referenced route is absent. The
snapshot diffs are `GET /api/v1/user/grammar-map`,
`GET /api/v1/user/next-action`, `GET /api/v1/user/path`, and
`POST /api/v1/user/exam-results/{examId}/schreiben-score`; this slice did not
alter the Go router or any snapshot. The phase plan explicitly requires stale,
unrelated snapshot drift to be repaired in a separate baseline change or
clearly excluded. Keep this exclusion until a backend owner refreshes and
reviews both route snapshots in a dedicated change.

## Remaining gates

- The contract matrix documents account deletion as intentionally unavailable;
  product/legal approval and a deployed `/user/account` lifecycle remain
  required before Phase 2.
- Selected-deck FSRS queue and server-authoritative exam drafts remain Phase 3
  gaps; client-only filtering is not an acceptable substitute.
- Authenticated live/device evidence remains a Phase 4 release gate.
