# Verification — exam draft lifecycle (2026-07-15)

Scope: owned/versioned draft persistence, canonical Flutter question references,
server-derived final submit, immutable history, and retry-safe mobile resume.

| Test | Expected | Actual | Status |
|---|---|---|---|
| `go test ./internal/infra/database ./internal/feature/exam/exam` | draft scorer, handler validation, and repository package pass | pass | ✅ |
| `go test ./cmd/server -run '^$'` | server compiles with draft routes/repository | pass | ✅ |
| `DATABASE_URL='' go test ./internal/infra/database -run TestExamAttemptDraftLifecycleIntegration -v` | integration test is safe without an explicit test DB | skipped: `DATABASE_URL not set or DB unavailable` | ⚠️ |
| `flutter analyze` | no static-analysis errors | `No issues found` | ✅ |
| `flutter test test/features/exam/exam_attempt_store_test.dart test/services/api_client_test.dart -r compact` | draft version, canonical-key migration, retry submit, and authenticated PATCH/POST contracts pass | 12 tests passed | ✅ |
| `flutter test -r compact` | full Flutter suite passes | exit code `0` | ✅ |
| `flutter build apk --debug` | debug APK builds | `build/app/outputs/flutter-apk/app-debug.apk` built | ✅ |
| `curl -sf http://127.0.0.1:8080/api/v1/health` | local API available for authenticated integration calls | unavailable | ❌ |
| `go test ./cmd/server -run 'TestRouteSnapshot_(DevAuthMode|JWKSMode)'` | route snapshots match mounted router | both DevAuth and JWKS baselines pass at 554 routes after the separate fixture reconciliation | ✅ |

## Evidence and limitations

- `exam_attempt_drafts` is separate from append-only `exam_attempts`, owner
  scoped, versioned, expiry-aware, and transitions once to `submitted`.
- The server snapshots normalized, gradable Lesen/Hören content at draft create;
  submit uses that snapshot, enforces audio limits, and never accepts a client
  score or answer key outside the snapshot.
- New submissions write canonical `part/section/question` answers separately
  from legacy history replay data. API history reads prefer canonical answers;
  later legacy result writes clear that projection to avoid stale data.
- Flutter uses the server draft path when available, migrates only unambiguous
  legacy cached IDs, sends authenticated PATCH/submit requests, and leaves an
  unsuccessful server submit retryable instead of marking it complete.
- Independent review found and verified the source-index SQL and
  legacy-canonical cleanup fixes.
- A live Postgres/API run remains unavailable: backend health is down and no
  explicit non-production `DATABASE_URL` was supplied. The gated integration
  test is present but did not execute.
