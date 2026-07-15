---
phase: 1
title: "Phase 0: Foundation — Dọn dẹp + Tokens + API stability"
status: in_progress
priority: P0
effort: "3-4d"
dependencies: []
---

# Phase 1: Phase 0 — Foundation

## Overview

Dọn dẹp codebase hiện tại, chuẩn hoá design tokens, thiết lập API stability conventions. Làm TRƯỚC mọi thứ khác. Không viết UI mới ở phase này.

## Requirements

- Chốt 1 bản duy nhất cho mỗi màn (xoá file `*_screen_new.dart` / `*_new_screen.dart` trùng)
- Export design tokens từ web sang Flutter (`lib/core/design_tokens.dart` đã có — bổ sung exam-tokens + dark mode đầy đủ)
- Quy ước API additive-only + `docs/api-changelog.md`
- Tạo 2 tài khoản test seed cố định cho fidelity testing

## Architecture

Không thay đổi cấu trúc thư mục lớn (đã làm BigBang restructure). Chỉ cleanup + bổ sung.

## Related Code Files

- Modify: `lib/core/design_tokens.dart` — bổ sung exam-tokens (background-exam, border-exam, accent-exam per `exam-tokens.css` web), dark mode token đầy đủ
- Modify: `lib/core/theme/app_colors.dart` — sync với web `index.css` variables
- Delete: duplicate screens (xác định bên dưới)
- Create: `docs/api-changelog.md` — quy ước additive-only cho `/api/v1`

## Implementation Steps

### 1. Kiểm kê và xoá file trùng lặp
```bash
# Tìm file trùng
find lib/screens -name "*.dart" | sort
find lib/features -name "*.dart" | sort
# Xác định: home_screen_new.dart vs home_screen.dart → chốt 1
# game_hub_screen.dart vs game_hub_screen_new.dart → chốt 1
# listening_hub_new_screen.dart → review
```
Nguyên tắc: giữ file có nhiều nội dung hơn + đúng spec hơn; cập nhật import trong router.

### 2. Bổ sung exam design tokens
Đọc `thamkhao/deutschtiger-frontend/src/styles/exam-tokens.css` → map sang Dart:
```dart
// Thêm vào lib/core/design_tokens.dart
// Exam tokens
static const Color examBackground = Color(0xFF...);
static const Color examBorder = Color(0xFF...);
static const Color examAccent = Color(0xFF...);
// Dark mode exam variants
static const Color examBackgroundDark = Color(0xFF...);
```

### 3. Chuẩn hoá dark mode tokens
Đọc web `index.css` `.dark` class → đảm bảo mọi token trong `DesignTokens` có đủ cặp light/dark. Không hardcode màu ở bất kỳ widget nào — luôn dùng `DesignTokens.*`.

### 4. API changelog + quy ước additive
Tạo `docs/api-changelog.md`:
```markdown
# API Changelog — /api/v1
Quy ước: additive-only. Không đổi tên field, không xoá field, không đổi kiểu.
Mỗi thay đổi ghi thêm 1 dòng dưới.
```
Ghi chú vào api_client.dart: header `X-App-Version` cho force-update detection.

### 5. Tài khoản test seed
- 1 tài khoản reviewer: `reviewer@deutschtiger.app` — có streak 5, 1 deck, 1 exam attempt mẫu
- 1 tài khoản fidelity: `fidelity@deutschtiger.app` — seed cố định cho screenshot compare

## Success Criteria

- [ ] Không còn file `*_new.dart` trùng nội dung với bản chính
- [ ] `DesignTokens` có đủ exam-tokens + dark mode vars
- [ ] `docs/api-changelog.md` tạo xong, quy ước ghi rõ
- [ ] Router không có import nào bị broken sau cleanup
- [ ] `flutter analyze` pass (0 error)
- [ ] `flutter build apk --debug` pass

## Risk Assessment

- Xoá nhầm file đang được import → chạy `flutter analyze` ngay sau mỗi lần xoá để catch sớm
