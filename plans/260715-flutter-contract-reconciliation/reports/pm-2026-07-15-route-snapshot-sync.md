# Plan sync — contract reconciliation (2026-07-15)

| Phase | Current evidence | Plan status |
|---|---|---|
| 1 — Freeze contracts | Matrix/reports exist; route snapshot baseline now passes at 554 routes in both modes | In progress: all four matrix acceptance criteria are not yet proven |
| 2 — Account deletion | Requires explicit lifecycle/retention decisions | Pending |
| 3 — Learning/exam gaps | Deck queue and server-owned exam draft slices implemented; live test DB/API evidence absent | In progress |
| 4 — Release gates | Static Flutter/backend checks available; disposable-account and physical-device evidence absent | Pending |

## Sync decision

Do not mark any phase complete. The route-snapshot fixture reconciliation closes
only the stale-baseline item in Phase 1; its broader client/server inventory and
live evidence remain open.

## Unresolved questions

- Account deletion lifecycle requires product/legal approval.
- A disposable non-production Postgres/API environment is needed for owned-draft
  and selected-deck integration evidence.
- Physical Android/iOS release-gate testing remains external to this workspace.
