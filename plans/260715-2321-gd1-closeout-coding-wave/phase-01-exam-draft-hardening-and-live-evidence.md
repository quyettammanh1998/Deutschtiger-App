---
phase: 1
title: "Exam Draft Hardening + Live Evidence"
status: pending
priority: P0
effort: "2–3d"
dependencies: []
---

# Phase 1: Exam Draft Hardening + Live Evidence

## Context

- Flutter side XONG: `lib/features/exam/data/exam_attempt_store.dart`
  (POST `/user/exam-drafts`, PATCH với `version`+`mutation_id`, POST
  `.../submit`, local snapshot fallback) và
  `lib/features/exam/presentation/exam_player_provider.dart` (autosave 5s
  debounce, resume, audioPlays, auto-submit timeout).
- Backend còn reviewer P1/P2 findings chưa xác nhận fix, và CHƯA có bất kỳ
  live Postgres/API run nào (integration test skip vì `DATABASE_URL` unset).
- Reports gốc: `plans/260715-flutter-contract-reconciliation/reports/
  reviewer-2026-07-15-exam-draft-foundation.md` và
  `verification-2026-07-15-exam-draft-foundation.md`.

## Requirements

1. Backend fixes (repo `thamkhao/deutschtiger-backend`):
   - Mutation-retry idempotency: PATCH retry với `mutation_id` cũ sau khi đã
     có autosave mới hơn phải trả receipt cũ, không ghi đè (quanh
     `exam_draft_repo.go:99`).
   - Reject JSON `null` cho `answers`/`audio_plays` (hiện accept null map).
   - Version-only no-op PATCH phải trả conflict/no-op rõ ràng, không tăng version.
   - Sửa nhãn test `api_client_test.dart:42` phía Flutter — test dùng in-memory
     Dio, không được ghi "production contract".
2. Live evidence (chạy 1 lần, ghi log):
   - Disposable Postgres + API local; chạy integration fixture two-user/two-deck
     (ownership isolation cho SRS queue + exam drafts).
   - Authenticated curl: draft create → autosave → resume (GET) → submit; deck
     queue before/after rating.
   - Ghi kết quả vào `plans/260715-flutter-contract-reconciliation/reports/`
     theo format verification hiện có; đây là input cho recon Phase 4
     `release-gate-verification.md`.

## Files

- Modify (backend): `thamkhao/deutschtiger-backend/internal/**/exam_draft_repo.go`,
  handler + focused tests cạnh nó.
- Modify (Flutter): `test/services/api_client_test.dart` (đổi tên/mô tả test).
- No Flutter behavior change expected; nếu contract đổi response shape, cập nhật
  `docs/api-changelog.md` + `docs/flutter-api-contract-matrix.md` trước khi sửa client.

## Validation

- Backend focused tests cho 3 fix trên; route snapshot 554 không đổi (trừ khi
  thêm route có chủ đích).
- Integration fixture xanh với `DATABASE_URL` thật.
- `flutter test` suite giữ xanh.

## Risks / Rollback

- Fix idempotency có thể đổi semantics PATCH → kiểm tra Flutter retry path
  trong `exam_attempt_store.dart` vẫn đúng trước khi merge.
- Máy 14GB: không chạy emulator song song với build (memory constraint đã biết).
