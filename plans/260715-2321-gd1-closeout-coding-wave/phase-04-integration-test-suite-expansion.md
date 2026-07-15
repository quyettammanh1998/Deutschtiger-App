---
phase: 4
title: "Integration Test Suite Expansion"
status: pending
priority: P1
effort: "3–5d"
dependencies: [1, 3]
---

# Phase 4: Integration Test Suite Expansion

## Context

- Hiện chỉ có `integration_test/welcome_flow_test.dart`, chạy trong CI
  emulator job (API35). Cross-cutting Phase 4 xác nhận gap: chưa có
  integration test cho auth, review, exam resume, deep link, device kick.
- Máy dev 14GB: emulator + build song song sẽ crash — CI job hoặc chạy tuần tự.

## Requirements

Thêm tối thiểu 5 integration tests (mỗi file một flow, đặt trong
`integration_test/`, theo pattern welcome test — real app, local backend):

1. `auth_login_logout_test.dart` — login email → home shell → logout → welcome.
2. `daily_review_submit_test.dart` — mở daily review, rate 1 thẻ, verify queue
   giảm (dùng seeded test user).
3. `exam_resume_test.dart` — bắt đầu exam practice, trả lời 1 câu, kill/restart
   app, verify resume từ draft (khớp Phase 1 evidence).
4. `deep_link_release_gate_test.dart` — deep link vào route gated (vd
   `/social`) → verify redirect an toàn; link vào route live → verify đến đúng
   màn.
5. `device_session_kick_test.dart` — đăng nhập thiết bị thứ 4 (cap 3) → verify
   kicked dialog + sign-out flow.

Cộng thêm khi Phase 2 xong: `account_delete_restore_test.dart` (disposable
account).

## Files

- Create: `integration_test/*.dart` như trên.
- Modify: `.github/workflows/flutter-ci.yml` — mở rộng android-integration job
  chạy cả suite; seed data script nếu cần (`scripts/`).
- Helpers chung: tách `integration_test/helpers/` (login helper, backend
  health check) — tái dùng từ welcome test thay vì copy.

## Validation

- Toàn bộ suite xanh trên emulator local (tuần tự) và trong CI job.
- Test flake: retry policy CI tối đa 1, không mask failure.

## Risks

- Cần backend local healthy + seeded users; script seed phải idempotent.
- Thời gian CI tăng — nếu >15 phút, tách integration job chạy trên main +
  nightly thay vì mọi PR.
