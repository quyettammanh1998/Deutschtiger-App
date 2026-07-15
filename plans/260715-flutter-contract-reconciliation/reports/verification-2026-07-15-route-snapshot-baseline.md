# Verification — backend route snapshot baseline (2026-07-15)

Scope: reconcile the committed DevAuth/JWKS route fixtures with the mounted
router. No HTTP handler, middleware, response type, or public route changed.

| Test | Expected | Actual | Status |
|---|---|---|---|
| `go test ./cmd/server -run 'TestRouteSnapshot_(DevAuthMode|JWKSMode)' -count=1 -v` | both router snapshots match their committed golden files | both modes report `snapshot OK: 554 routes` | ✅ |
| `go test ./cmd/server -count=1 -v` | server package regression suite passes, including auth/rate-limit/CORS gates | pass | ✅ |
| `curl -sf --max-time 3 http://127.0.0.1:8080/api/v1/health` | running local API returns health JSON | connection unavailable (exit 7); no local API was started for this fixture-only change | ⚠️ |
| UI flow: create → autosave → resume → submit a draft | persisted draft and audio/timer state restored on a physical device | not run: requires the unavailable API plus a physical device | ⚠️ |

## Root cause and prevention

- Both fixtures were stale by four already-mounted routes:
  `GET /user/grammar-map`, `GET /user/next-action`, `GET /user/path`, and
  `POST /user/exam-results/{examId}/schreiben-score`.
- The same reconciliation includes the already-registered draft lifecycle:
  `POST /user/exam-drafts`, `GET /user/exam-drafts/{id}`,
  `PATCH /user/exam-drafts/{id}`, and
  `POST /user/exam-drafts/{id}/submit`. All eight entries are present in both
  DevAuth and JWKS fixtures.
- The test normalizes (sorts) both golden and discovered method/path
  inventories before comparing them. The four routes are present in both auth
  modes; their local GET ordering is kept readable even though the historical
  raw files are not globally sorted by method/path.
- Existing two-mode snapshot tests prevent a future router/fixture drift from
  passing silently.

## Unresolved questions

None for this fixture reconciliation.
