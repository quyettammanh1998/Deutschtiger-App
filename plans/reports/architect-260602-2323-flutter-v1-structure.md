# DeutschTiger Flutter V1 — Báo cáo đề xuất cấu trúc

**Date:** 2026-06-02 | **Author:** architect

> ⚠️ **CẬP NHẬT 2026-06-03:** Quyết định Auth đã ĐẢO NGƯỢC sau khi phân tích sâu codebase (22 agent + adversarial verify). **Dùng Supabase Auth cho Flutter, KHÔNG dùng Firebase Auth** — vì backend khóa `profiles.id` = JWT `sub`, Firebase Auth gây identity fragmentation (CRITICAL risk verified). Firebase chỉ dùng cho FCM push. Phần "dual-JWKS" bên dưới KHÔNG còn cần thiết. Xem đánh giá đầy đủ: `evaluation-260603-flutter-v1-architecture.md`.

---

## 1. Tổng quan codebase web hiện tại

| Thành phần | Chi tiết |
|---|---|
| Frontend | React 19 + TypeScript + TanStack Query |
| Backend | Go + Chi HTTP API tại `:8080` |
| Auth | Supabase Auth (JWT) — web; Firebase Auth — Flutter mobile |
| DB | PostgreSQL (app data) + Supabase (auth only, web) |
| API pattern | REST `/api/v1/*` với Bearer JWT |
| API client | `src/lib/shared/api-client.ts` — wrapper `fetch` + auto-refresh token |
| JWT validation | Backend dùng JWKS endpoint (configurable via `JWKS_URL` env var) |

**Điểm quan trọng:** Flutter V1 dùng **Firebase Auth** cho login. Storage (audio, exam assets) vẫn giữ Supabase Storage — không thay đổi. Backend Go cần hỗ trợ **dual JWKS**: Supabase (web) + Firebase (mobile), phân biệt qua `iss` claim trong JWT.

---

## 2. V1 Feature Scope (từ recommend.md)

**Có trong V1:**
1. Native Login (email + password, quên mật khẩu)
2. Native Home Dashboard (daily goal, streak, missions)
3. Native Flashcard/Vocab Review (SM-2 đơn giản)
4. WebView cho bài học (reading, writing, interview)
5. Push Notification (daily study reminder)
6. Profile / Progress cơ bản + logout

**Không có trong V1:** IAP, AI chat native, speaking/mic, social, leaderboard, game phức tạp.

---

## 3. Đề xuất cấu trúc thư mục Flutter

```
deutschtiger_app/
├── lib/
│   ├── main.dart                     # Entry point, env setup
│   ├── app.dart                      # MaterialApp + router + theme
│   │
│   ├── core/                         # Không phụ thuộc feature nào
│   │   ├── api/
│   │   │   ├── api_client.dart       # HTTP client + JWT auto-refresh
│   │   │   └── api_endpoints.dart    # Const URL map
│   │   ├── auth/
│   │   │   ├── auth_repository.dart  # Supabase Auth wrapper
│   │   │   └── auth_state.dart       # Riverpod provider
│   │   ├── storage/
│   │   │   └── secure_storage.dart   # flutter_secure_storage wrapper
│   │   ├── router/
│   │   │   └── app_router.dart       # GoRouter config
│   │   └── theme/
│   │       ├── app_theme.dart        # Light/dark theme
│   │       └── app_colors.dart       # Design tokens
│   │
│   ├── features/                     # Mỗi feature = 1 folder độc lập
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   │   └── auth_service.dart
│   │   │   ├── domain/
│   │   │   │   └── user_model.dart
│   │   │   └── presentation/
│   │   │       ├── login_screen.dart
│   │   │       ├── signup_screen.dart
│   │   │       └── forgot_password_screen.dart
│   │   │
│   │   ├── home/
│   │   │   ├── data/
│   │   │   │   ├── gamification_repository.dart  # GET /api/v1/user/gamification
│   │   │   │   └── mission_repository.dart       # GET /api/v1/user/missions/today
│   │   │   ├── domain/
│   │   │   │   ├── gamification_model.dart
│   │   │   │   └── mission_model.dart
│   │   │   └── presentation/
│   │   │       ├── home_screen.dart
│   │   │       ├── widgets/
│   │   │       │   ├── daily_goal_card.dart
│   │   │       │   ├── streak_card.dart
│   │   │       │   └── mission_list.dart
│   │   │       └── home_provider.dart            # Riverpod
│   │   │
│   │   ├── flashcard/
│   │   │   ├── data/
│   │   │   │   ├── flashcard_repository.dart     # GET /api/v1/user/flashcard-decks
│   │   │   │   └── review_repository.dart        # POST /api/v1/user/flashcard-reviews
│   │   │   ├── domain/
│   │   │   │   ├── flashcard_model.dart
│   │   │   │   └── review_rating.dart            # enum: again/hard/good/easy
│   │   │   └── presentation/
│   │   │       ├── deck_list_screen.dart
│   │   │       ├── flashcard_review_screen.dart
│   │   │       └── widgets/
│   │   │           ├── flip_card.dart
│   │   │           └── rating_buttons.dart       # Again/Hard/Good/Easy → gửi 1-4 lên backend
│   │   │
│   │   ├── lessons/
│   │   │   └── presentation/
│   │   │       ├── lessons_screen.dart           # Danh sách bài học
│   │   │       └── webview_screen.dart           # WebView wrapper
│   │   │
│   │   ├── profile/
│   │   │   ├── data/
│   │   │   │   └── profile_repository.dart       # GET /api/v1/user/profile
│   │   │   ├── domain/
│   │   │   │   └── profile_model.dart
│   │   │   └── presentation/
│   │   │       ├── profile_screen.dart
│   │   │       └── widgets/
│   │   │           └── stats_section.dart
│   │   │
│   │   └── notifications/
│   │       ├── data/
│   │       │   └── notification_service.dart     # FCM setup + permission
│   │       └── notification_handler.dart         # foreground/background handler
│   │
│   └── shared/                       # Widget/util dùng nhiều feature
│       ├── widgets/
│       │   ├── loading_indicator.dart
│       │   ├── error_view.dart
│       │   └── bottom_nav.dart
│       └── utils/
│           ├── date_utils.dart
│           └── vietnamese_text.dart
│
├── test/
│   ├── features/
│   │   ├── auth/
│   │   ├── home/
│   │   └── flashcard/
│   └── core/
│
├── assets/
│   ├── images/
│   └── fonts/
│
├── android/
├── ios/
│
├── pubspec.yaml
└── .env                              # FLUTTER_API_URL, SUPABASE_URL, ...
```

---

## 4. Tech Stack đề xuất

| Concern | Package | Lý do |
|---|---|---|
| State management | `riverpod` 2.x + `hooks_riverpod` | Type-safe, testable, không boilerplate như BLoC |
| Navigation | `go_router` 14.x | Declarative, deep link tốt, App Store review pass |
| HTTP client | `dio` 5.x | Interceptors cho JWT auto-refresh (mirror logic web) |
| Auth | `firebase_auth` | Email/password, Google Sign-In, JWT cho Go backend |
| Secure storage | `flutter_secure_storage` 9.x | Keychain/KeyStore cho JWT token |
| WebView | `webview_flutter` 4.x | Official Google plugin, ổn định |
| Push notifications | `firebase_messaging` + `flutter_local_notifications` | FCM cho cả iOS/Android |
| Flip card animation | `flip_card` hoặc tự viết AnimatedBuilder | Đơn giản, nhẹ |
| Environment | `flutter_dotenv` | Map .env file |
| Code gen | `freezed` + `json_serializable` | Model immutable + JSON parse |

**Không dùng:** `get` (quá magic), `mobx` (overkill), `getx` (anti-pattern).

---

## 5. API mapping Web → Flutter

Backend Go không đổi. Flutter gọi thẳng:

| Feature | Endpoint web hiện tại | Flutter dùng |
|---|---|---|
| Auth login | Supabase Auth SDK (web) | `firebase_auth` signInWithEmailAndPassword |
| Gamification | `GET /api/v1/user/gamification` | `GamificationRepository` |
| Missions | `GET /api/v1/user/missions/today` | `MissionRepository` |
| Flashcard decks | `GET /api/v1/user/flashcard-decks` | `FlashcardRepository` |
| Review submit (vocab) | `POST /api/v1/user/word-reviews/rate` | `ReviewRepository` — gửi `{ rating: 1-4 }`, FSRS tính server-side |
| Review submit (flashcard) | `POST /api/v1/user/flashcard-reviews` | `FlashcardReviewRepository` |
| Profile | `GET /api/v1/user/profile` | `ProfileRepository` |
| WebView | N/A | Mở URL `https://deutschtiger.com/...` |

**Auth flow:** `supabase_flutter` giữ session → lấy `access_token` → đính vào `Authorization: Bearer <token>` qua Dio interceptor.

---

## 6. Navigation structure

```
GoRouter
├── /login          → LoginScreen
├── /signup         → SignupScreen  
├── /forgot         → ForgotPasswordScreen
└── /               → ShellRoute (BottomNav 4 tabs)
    ├── /home       → HomeScreen
    ├── /vocab      → DeckListScreen
    │   └── /vocab/review/:deckId → FlashcardReviewScreen
    ├── /lessons    → LessonsScreen
    │   └── /lessons/webview → WebViewScreen
    └── /profile    → ProfileScreen
```

---

## 7. Vấn đề cần xem xét khi chuyển sang Flutter

### 7.1 Dual-JWKS authentication (thay đổi backend duy nhất cho auth)

**Scope:** Flutter dùng Firebase Auth cho login. Web vẫn dùng Supabase Auth. Storage không thay đổi.

Backend Go cần hỗ trợ **2 JWKS song song**:
- Supabase JWKS: `https://<project>.supabase.co/auth/v1/jwks` → web users
- Firebase JWKS: `https://www.googleapis.com/service_accounts/v1/jwk/securetoken@system.gserviceaccount.com` → mobile users

**Cách implement trong `middleware/auth.go`:**
1. Parse JWT header để đọc `iss` claim (không verify trước)
2. `iss` = `https://securetoken.google.com/<project-id>` → dùng Firebase JWKS cache
3. Còn lại → dùng Supabase JWKS cache (hiện tại)
4. `JWKSCache` có thể reuse cho cả 2, chỉ cần khởi tạo 2 instance với URL khác nhau

**User ID:** Firebase UID là string ngắn (28 chars), Supabase UUID là format khác. Backend hiện dùng `sub` claim làm `user_id`. Cần đảm bảo `profiles` table có thể chứa Firebase UID — column `id` kiểu `text` là được, nếu đang là `uuid` type thì cần migration nhỏ.

→ **Kiểm tra trước khi implement:** `SELECT column_name, data_type FROM information_schema.columns WHERE table_name='profiles' AND column_name='id';`

### 7.2 WebView domain
Khi mở WebView trỏ vào `https://deutschtiger.com`, user đã login trên app nhưng chưa login trên web session của WebView. Cần truyền token qua URL hoặc cookie để web nhận ra session.

**Giải pháp:** Thêm endpoint `GET /api/v1/auth/web-token` trả về short-lived token, WebView mở `https://deutschtiger.com/app-login?token=xxx` → web tự login. Đây là thay đổi nhỏ ở backend.

### 7.3 Push notification
Web đang dùng Web Push (VAPID). Flutter cần Firebase Cloud Messaging (FCM).
- Thêm FCM token endpoint vào backend: `POST /api/v1/user/fcm-token`
- Backend gửi push qua FCM thay vì VAPID cho mobile users
- Có thể chạy song song (web push + FCM)

### 7.4 Lỗi hiện tại trên web
Task đề cập có bug cùng chỗ backend + frontend. Khi Flutter call API, nếu bug ở backend thì Flutter cũng bị. Nên fix backend bug trước khi bắt đầu Flutter development để tránh debug chồng chéo.

---

## 8. Thứ tự implementation đề xuất

```
Phase 1 (Setup + Auth)       ~3 ngày
├── Flutter project init + pubspec
├── Core: api_client, auth, router, theme
└── Feature: auth screens (login/signup/forgot)

Phase 2 (Home + Gamification) ~2 ngày  
├── Feature: home screen
├── GamificationRepository + MissionRepository
└── daily_goal_card, streak_card, mission_list widgets

Phase 3 (Flashcard)          ~3 ngày
├── Feature: flashcard
├── FlashcardRepository + ReviewRepository
├── flip_card animation
└── rating_buttons (Again/Hard/Good/Easy)

Phase 4 (Lessons WebView)    ~1 ngày
├── Feature: lessons list screen
├── WebView wrapper
└── Auth bridge (web-token endpoint)

Phase 5 (Profile + Push)     ~2 ngày
├── Feature: profile screen
├── FCM setup (Firebase project)
├── notification_service
└── Backend: fcm-token endpoint

Phase 6 (Polish + Store prep) ~3 ngày
├── App icon, splash screen
├── iOS Info.plist permissions
├── Android AndroidManifest.xml
├── Privacy Policy, Terms screens
└── TestFlight + Internal Testing
```

**Total estimate:** ~14 ngày để có V1 submit-ready.

---

## 9. Điều không cần làm cho V1

- Offline mode (chỉ cần graceful error khi mất mạng)
- Complex animations
- Dark mode toggle (default light là đủ)
- Localization framework (Vietnamese hardcode ok cho V1)
- Analytics (add sau)
- Crash reporting (add sau)

---

## Unresolved Questions

1. **Web bug hiện tại là bug nào?** Cần biết để xác định xem Flutter V1 có bị ảnh hưởng không.
2. **Domain WebView:** `deutschtiger.com` hay subdomain riêng cho app? Auth bridge implementation sẽ khác nhau.
3. **Firebase project:** Đã có chưa? Nếu có thì `project-id` là gì (cần để config JWKS backend)?
4. **Backend deployment:** Go backend chạy trên VPS — khi Flutter app release, cần HTTPS và domain production (không phải localhost).
5. **Thư mục app:** Flutter project để ở `/Users/quangcuong/Desktop/Deutschtiger-App/` luôn hay tạo repo mới?
