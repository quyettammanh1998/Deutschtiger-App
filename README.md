# DeutschTiger

Ứng dụng học tiếng Đức trên Flutter, hỗ trợ Android và iOS. App dùng Riverpod
cho state management, GoRouter cho navigation, Supabase Auth và Go API của
DeutschTiger cho dữ liệu học tập.

## Yêu cầu

- Flutter 3.44 hoặc mới hơn
- Dart 3.12 hoặc mới hơn
- Android Studio/Android SDK để chạy Android
- Xcode và CocoaPods để chạy iOS

Kiểm tra môi trường:

```bash
flutter doctor
flutter --version
```

## Cài đặt

```bash
flutter pub get
cp .env.example .env
```

Cấu hình `.env`:

```dotenv
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-publishable-anon-key
API_BASE_URL=https://deutschtiger.com/api/v1
WEBVIEW_BASE_URL=https://deutschtiger.com
```

Không commit `.env`. Để dùng Firebase Messaging trên Android, đặt file Firebase
của project tại `android/app/google-services.json`. iOS dùng
`ios/Runner/GoogleService-Info.plist`. App vẫn khởi động khi Firebase chưa được
cấu hình, nhưng push notification sẽ không hoạt động.

## Chạy ứng dụng

```bash
flutter run
```

Liệt kê và chọn thiết bị cụ thể:

```bash
flutter devices
flutter run -d <device-id>
```

Để gọi backend local, đổi `API_BASE_URL` trong `.env` sang địa chỉ máy chạy Go
API. Android Emulator truy cập host qua `http://10.0.2.2:<port>` thay vì
`localhost`.

## Kiểm tra chất lượng

```bash
flutter analyze
flutter test
flutter build apk --debug
```

Android emulator/device smoke test:

```bash
flutter test integration_test/welcome_flow_test.dart -d <device-id>
```

This test starts the real app, verifies the unauthenticated welcome screen, and
checks the primary CTA opens onboarding. It requires an Android device or
emulator and a healthy local backend.

Pull requests also run the same formatting, analysis, test and mobile
source-marker checks through `.github/workflows/flutter-ci.yml`. See
[`docs/flutter-fidelity-pipeline.md`](docs/flutter-fidelity-pipeline.md) for
the gates that still require device or release-signing evidence.

Build release:

```bash
flutter build appbundle --release
flutter build ios --release
```

## Cấu trúc chính

```text
lib/
  core/          Design tokens và hạ tầng dùng chung
  data/          Data models
  features/      Feature modules mới
  navigation/    GoRouter configuration
  repositories/  Data access layer
  screens/       App screens
  services/      Auth, API, notifications và config
  shared/        Shared UI/domain utilities
  view_models/   Riverpod providers và notifiers
  widgets/       Shared presentation widgets
test/            Unit, widget và architecture tests
```

Xem thêm [AGENTS.md](AGENTS.md) cho coding conventions và
[docs/v1-config-and-api-map.md](docs/v1-config-and-api-map.md) cho API map.
