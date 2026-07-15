---
phase: 3
title: "Phase 2: Auth + Device-Kicked Modal + Xoá tài khoản (blocker Apple)"
status: in_progress
priority: P0
effort: "1w"
dependencies: [2]
---

# Phase 3: Phase 2 — Auth + Device + Xoá tài khoản

## Overview

Hoàn thiện auth flows, xử lý device-kicked modal (A5), xây xoá tài khoản (A6 — **blocker Apple 5.1.1**). Cần BE handler trước.

## Requirements

- supabase_flutter: verify secure-storage backing (Keychain/EncryptedSharedPreferences)
- Google OAuth: native flow (KHÔNG webview — Google chặn)
- Sign in with Apple: iOS-only, ship GĐ1 (đã chốt R2)
- Deep links: App Links (Android) + Universal Links (iOS) cho reset-password + OAuth callback
- Onboarding A4: 2-3 slide, skippable
- Device-kicked modal (A5): port `device-kicked-modal.tsx` + xử lý 401 trong Dio interceptor
- Xoá tài khoản (A6): UI 2 bước trong Settings → Security
- **BE blocker:** route hiện chưa tồn tại. Không giữ `DELETE /api/v1/user/profile` làm contract mặc định: contract reconciliation phải chọn và implement endpoint duy nhất trước khi Flutter gọi nó.
- **Web blocker**: trang `/delete-account` trên deutschtiger.com (Google Data Safety URL)

## Architecture

```
lib/screens/auth/
├── login_screen.dart          # ✅ có, verify fidelity
├── signup_screen.dart         # ✅ có, verify fidelity
├── forgot_password_screen.dart # ✅ có
├── reset_password_screen.dart  # ❌ thiếu — cần tạo
├── welcome_screen.dart        # ⚠️ cũ → refactor thành onboarding 3 slides
├── onboarding_screen.dart     # có sẵn, check content
└── widgets/

lib/shared/widgets/
└── device_kicked_modal.dart   # ❌ tạo mới
```

## Related Code Files

- Modify: `lib/services/api_client.dart` — 401 device-kicked → DeviceKickedEvent
- Create: `lib/shared/widgets/device_kicked_modal.dart`
- Modify: `lib/screens/auth/welcome_screen.dart` → refactor thành onboarding slides
- Modify: `lib/screens/settings/settings_screen.dart` — thêm Security section
- Modify: `lib/repositories/profile_repository.dart`, `lib/screens/settings/delete_account_screen.dart` — chỉ đổi sau khi backend contract đã được ký off
- Create/Modify: `lib/screens/settings/security_screen.dart` — device management + entry point xoá tài khoản

## Implementation Steps

### 1. Verify supabase_flutter secure storage
```dart
// android/app/src/main/AndroidManifest.xml: android:usesCleartextTraffic="false"
// flutter_secure_storage: check EncryptedSharedPreferences backing
// Kiểm tra refresh token flow: access expired → auto-refresh → retry request
```

### 2. Google OAuth native
```dart
// Dùng google_sign_in package (đã có trong pubspec)
// KHÔNG dùng supabase.auth.signInWithOAuth (webview) — Google reject
// Flow: googleSignIn.signIn() → idToken → supabase.auth.signInWithIdToken()
```

### 3. Sign in with Apple (iOS-only)
```dart
// sign_in_with_apple package (đã có)
// Chỉ render nút trên iOS: if (Platform.isIOS)
// Flow: Apple credential → nonce → supabase.auth.signInWithIdToken()
```

### 4. Deep links setup
- Android: `android/app/src/main/AndroidManifest.xml` — intent-filter cho `app.deutschtiger.com`
- iOS: `ios/Runner/Runner.entitlements` — Associated Domains: `applinks:deutschtiger.com`
- BE/nginx: serve `/.well-known/apple-app-site-association` + `/.well-known/assetlinks.json`
- Test: `adb shell am start -W -a android.intent.action.VIEW -d "https://app.deutschtiger.com/reset-password?token=xxx"`

### 5. Onboarding 3 slides (A4)
- Slide 1: Tiger mascot + "Học tiếng Đức mỗi ngày"
- Slide 2: "Ôn tập thông minh với FSRS"
- Slide 3: "Luyện thi TELC/Goethe"
- Skip button + page indicators + "Bắt đầu" CTA cuối
- Sau hoàn thành → navigate /home (hoặc signup nếu chưa login)

### 6. Device-kicked modal (A5)
```dart
// lib/shared/widgets/device_kicked_modal.dart
// Port device-kicked-modal.tsx: title + message + "Đăng nhập lại" button
// Trigger: api_client nhận 401 với body {"error": "device_kicked"}
// → show modal trên context root (dùng NavigatorKey) → về /login
// KHÔNG retry loop sau device-kicked
```

### 7. Device management screen (N2)
```dart
// GET /api/v1/user/devices → list sessions
// DELETE /api/v1/user/devices/{id} → revoke session
// Màn: Settings → Security → "Quản lý thiết bị"
```

### 8. Xoá tài khoản (A6) — BLOCKER APPLE

**Contract gate (làm trước UI):** follow
`plans/260715-flutter-contract-reconciliation/phase-02-resolve-account-deletion-contract.md`.
Contract backend pending hiện đề xuất `DELETE /api/v1/user/account`, re-auth,
soft-delete 7 ngày, session revoke và hard-purge/anonymize job. Đây là khác biệt
quan trọng so với stale label `/user/profile`; không được ship fallback hoặc gọi
đoán endpoint.

**App UI (sau contract/integration tests):**
- Settings → Security → "Xoá tài khoản".
- Step 1: giải thích grace period và re-auth; Step 2: nhập chính xác `XÁC NHẬN`.
- Gọi endpoint đã chốt, clear local auth/session, rồi về `/welcome`.
- Nếu backend chọn restore path, render trạng thái pending-delete + action restore theo response contract.

**Web (cùng contract):**
- Trang `deutschtiger.com/delete-account`: login → confirm → cùng endpoint.
- URL này là Google Data Safety "Account deletion URL".

### 9. Auth-gate router
```dart
// app_router.dart: redirect logic
// Chưa login → /welcome (onboarding hoặc login)
// Đã login → /home
// Bootstrapping: skeleton 4s timeout như protected-route.tsx web
```

## Success Criteria

- [ ] Login/Signup/Forgot pass — không crash trên iOS + Android thật
- [ ] Google OAuth native (không webview) hoạt động
- [ ] Sign in with Apple iOS-only hiển thị + auth thành công
- [ ] Deep link reset-password mở đúng app
- [ ] Onboarding 3 slides, skip được, không lặp khi đã login
- [ ] Device-kicked: thiết bị 4 login → thiết bị 1 bị kick → modal đúng → về login
- [ ] Xoá tài khoản: re-auth + `XÁC NHẬN` → backend xác nhận pending deletion → session bị revoke; restore/hard-delete được test theo contract đã ký
- [ ] Trang web `/delete-account` live trên deutschtiger.com

## Risk Assessment

- BE endpoint xoá tài khoản cần làm trước → coordinate với BE dev hoặc tự implement nếu có access
- Universal Links iOS cần AASA file trên nginx + Apple review account → test sớm trên TestFlight internal
