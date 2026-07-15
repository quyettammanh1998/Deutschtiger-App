---
title: "GĐ1 Close-out Coding Wave — Deletion/Export, Live Surfaces, Test/Release Automation"
description: >-
  Sóng code tiếp theo sau audit 15/07: thực thi account deletion + export,
  bật live data cho stats/grammar/reading/listening, mở rộng integration
  tests, và dựng release CI + fidelity baseline.
status: pending
priority: P0
branch: main
tags:
  - flutter
  - backend-contract
  - release-gate
  - live-data
  - ci
blockedBy: []
blocks:
  - 260710-1644-flutter-port-phase-0-to-8
created: "2026-07-15T23:21:00+07:00"
createdBy: "claude"
source: gap-audit
---

# GĐ1 Close-out Coding Wave

## Overview

Audit 15/07/2026 (2 Explore agents, xem Evidence) xác nhận: contract tests,
exam draft lifecycle, deck-scoped SRS queue, ARB l10n 3 locale, secret
hygiene, PR CI và release gating cho 9 mock repo đã LÀM XONG trong code.
Plan này chỉ chứa phần **còn phải code** — không lặp lại các gate đã có
evidence trong 2 plan active. Nó là execution sequence cho các open item của
[Contract Reconciliation](../260715-flutter-contract-reconciliation/plan.md)
và [Cross-Cutting Readiness](../260715-flutter-cross-cutting-readiness/plan.md).

## Evidence baseline (audit 15/07)

- Account deletion: Flutter chỉ có placeholder screen; backend chưa có route
  `/user/account`; 3 quyết định product chưa chốt.
- Data export: chưa có backend endpoint, Flutter là support-directed placeholder.
- Exam draft: Flutter wired đủ (create/autosave/resume/submit), nhưng backend
  còn P1 reviewer findings và CHƯA có live Postgres/curl evidence nào.
- 9 repo còn 100% mock, đều gated off release qua
  `lib/core/release/release_feature_flags.dart` (default false). Backend đã
  mount route thật cho stats/grammar/reading/podcast/leaderboard (554-route
  snapshot) → có thể bật live một phần GĐ1.
- CI: PR gates + OSV + SBOM có; CHƯA có signed AAB/IPA job, iOS lane,
  fidelity/golden pipeline; integration test duy nhất là welcome flow.

## Phases

| Phase | Name | Ưu tiên | Status |
|-------|------|---------|--------|
| 1 | [Exam Draft Hardening + Live Evidence](./phase-01-exam-draft-hardening-and-live-evidence.md) | P0 | Pending |
| 2 | [Account Deletion + Data Export Execution](./phase-02-account-deletion-and-data-export-execution.md) | P0 (decision-gated) | Pending |
| 3 | [GĐ1 Live Surfaces: Stats, Grammar, Reading, Listening](./phase-03-gd1-live-surfaces.md) | P1 | Pending |
| 4 | [Integration Test Suite Expansion](./phase-04-integration-test-suite-expansion.md) | P1 | Pending |
| 5 | [Release CI: Signing, iOS Lane, Fidelity Baseline](./phase-05-release-ci-signing-and-fidelity-baseline.md) | P1 | Pending |
| 6 | [L10n Literal Cleanup + Screen-Reader Smoke](./phase-06-l10n-cleanup-and-screen-reader-smoke.md) | P2 | Pending |

## Dependencies

- Phase 1 độc lập, làm ngay — nó unblock recon Phase 3/4.
- Phase 2 bị chặn bởi 3 quyết định owner (xem Open decisions); phần backend
  reuse `thamkhao/deutschtiger-backend/plans/260706-1113-account-deletion-data-export/`.
- Phase 3 không phụ thuộc 1–2; mỗi surface phải qua
  `docs/flutter-api-contract-matrix.md` + `docs/api-changelog.md` trước.
- Phase 4 nên chạy sau khi Phase 1–3 có surface ổn định; welcome-flow test là mẫu.
- Phase 5 độc lập; cần upload keystore/cert từ owner cho signed job.
- Social/speaking/journey/ai/affiliate/legacy-goethe GIỮ NGUYÊN gated off — GĐ2
  ([Extended Coverage](../260715-flutter-gd2-extended-coverage/plan.md)).

## Acceptance criteria

- [ ] Backend exam-draft P1 findings fixed + two-user/two-deck Postgres fixture
      chạy xanh + authenticated curl evidence ghi vào recon Phase 4 log.
- [ ] Xoá tài khoản và export dữ liệu hoạt động end-to-end (app + web URL),
      dùng đúng một contract; placeholder screens bị thay thế.
- [ ] Stats/Grammar/Reading/Listening dùng ApiClient contract thật, pass
      release-live-data guard, và flag tương ứng bật default cho release.
- [ ] ≥5 integration tests chạy trong CI emulator job.
- [ ] CI build được signed AAB (fail-closed giữ nguyên) + artifact secret scan;
      fidelity baseline có ít nhất bộ golden đầu tiên.

## Open decisions (chặn Phase 2 — cần owner)

1. Grace period 7 ngày soft-delete + restore, hay xoá ngay?
2. Community contributions: anonymize hay hard-delete?
3. Payment retention: giữ field nào, bao lâu?

## Unresolved questions

- Games hub (backend không có route game content rõ ràng ngoài
  `/gamification/leaderboard`) — cần quyết định: games chạy trên vocab data
  local hay cần backend contract mới? Để ngoài Phase 3 cho đến khi chốt.
- iOS CI cần macOS runner — GitHub-hosted hay self-hosted? Ảnh hưởng Phase 5 scope.
