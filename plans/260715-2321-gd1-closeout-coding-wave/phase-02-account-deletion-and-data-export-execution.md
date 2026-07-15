---
phase: 2
title: "Account Deletion + Data Export Execution"
status: pending
priority: P0
effort: "4–6d sau khi owner chốt quyết định"
dependencies: []
---

# Phase 2: Account Deletion + Data Export Execution

## Decision gate (CHẶN — không code trước khi chốt)

Owner phải chốt 3 quyết định (đã liệt kê ở plan.md): grace period,
anonymize-vs-delete community content, payment retention. Contract khuyến
nghị (từ backend plan `260706-1113-account-deletion-data-export`):
`DELETE /api/v1/user/account` + re-auth, soft-delete 7 ngày,
`POST /user/account/restore`, purge/anonymize theo lịch.

## Context

- Flutter hiện KHÔNG có delete call nào; `delete_account_screen.dart` là
  placeholder trung thực ("deletion unavailable"). Export cũng là placeholder
  support-directed.
- Store submission (master plan Phase 6) bắt buộc: in-app deletion + public
  web `/delete-account` URL (Google Data Safety).

## Requirements

1. Backend: thực thi theo backend plan — migration soft-delete, account
   handler (`internal/feature/user/account/*`), re-auth verification, revoke
   sessions, purge job, export endpoint (JSON archive) + focused tests.
2. Flutter deletion:
   - `lib/repositories/profile_repository.dart`: thêm `deleteAccount()` gọi
     contract đã chốt (KHÔNG dùng `DELETE /user/profile`).
   - `lib/screens/settings/delete_account_screen.dart`: thay placeholder bằng
     flow thật — re-auth → confirm → pending-delete state → sign-out; hiển thị
     grace period + restore path nếu được chọn.
   - `lib/screens/settings/security_screen.dart`: entry point + copy.
3. Flutter export:
   - Repository method gọi export endpoint, download authenticated + share
     sheet (dùng `ApiClient` bearer; file lưu app-scoped, không external storage).
   - Settings UI thay placeholder.
4. Web `/delete-account` page (repo web frontend) dùng CÙNG contract; ghi URL
   vào store metadata checklist.
5. L10n: toàn bộ string mới vào ARB vi/en/de (3×, giữ 438-key parity tooling).
6. Cập nhật `docs/flutter-api-contract-matrix.md` + `docs/api-changelog.md`
   TRƯỚC khi code client.

## Validation

- Backend focused tests + route snapshot cập nhật có chủ đích.
- Flutter widget tests: delete flow states (re-auth fail, pending, restore),
  export success/error; German 200% text scale.
- E2E trên disposable account: delete → restore → delete → purge; export tải
  được archive. Ghi verification report vào cross-cutting reports/.

## Risks / Rollback

- Đây là hành động phá huỷ dữ liệu — mọi test dùng disposable account, không
  dùng tài khoản thật.
- Nếu owner chọn khác khuyến nghị, cập nhật contract matrix trước, không
  giữ alias route cũ.
