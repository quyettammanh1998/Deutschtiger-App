# Deutschtiger App - Repository Guidelines

## Project Structure

```
lib/
├── core/                    # Core services and utilities
│   ├── auth/               # Authentication services
│   ├── design_tokens.dart   # Centralized design constants
│   ├── i18n/               # Internationalization
│   ├── network/            # API client
│   ├── notifications/      # Notification services
│   ├── preferences/        # User preferences
│   ├── router/             # App routing
│   └── theme/              # Theme configuration
├── features/                # Feature modules
│   ├── achievements/
│   ├── affiliate/
│   ├── ai/
│   ├── auth/
│   ├── deck/
│   ├── exam/
│   ├── flashcard/
│   ├── games/
│   ├── grammar/
│   ├── home/
│   ├── interview/
│   ├── journey/
│   ├── leaderboard/
│   ├── listening/
│   ├── profile/
│   ├── progress/
│   ├── quiz/
│   ├── reminders/
│   ├── settings/
│   ├── social/
│   └── speaking/
├── features.dart
├── app.dart
└── main.dart

test/
├── core/                    # Core unit tests
├── features/               # Feature unit tests
├── helpers/                # Shared test helpers (fakes, mocks)
└── widget_test.dart

lib/previews/               # Widget preview files
```

## Build, Test, and Development Commands

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Analyze code for errors and warnings
flutter analyze

# Run all tests
flutter test

# Run specific test file
flutter test test/core/design_tokens_test.dart

# Run tests with coverage
flutter test --coverage

# Build for Android
flutter build apk --debug

# Build for iOS
flutter build ios --debug
```

## Architecture

### Design Tokens

All design constants are centralized in `lib/core/design_tokens.dart`:

- **Spacing**: `spacingXs` (4), `spacingSm` (8), `spacingMd` (16), `spacingLg` (24), `spacingXl` (32)
- **Border Radii**: `radiusSm` (8), `radius` (16), `radiusLg` (24)
- **Colors**: All theme colors (primary, background, foreground, etc.)
- **Typography**: Pre-configured TextStyles via Google Fonts Inter
- **Gradients**: Primary gradient, glass gradient, auth button gradient
- **Animation**: Duration constants (fast=120ms, medium=220ms, slow=450ms)

Use `DesignTokens` directly in new code. The `AppColors` class re-exports these for backward compatibility.

### Notification Services

Architecture uses interface + implementation pattern:

- `notification_contract.dart` - Abstract interface defining all notification operations
- `local_notification_service.dart` - Local notifications using flutter_local_notifications
- `fcm_notification_service.dart` - Firebase Cloud Messaging implementation
- `notification_service.dart` - Riverpod providers and wrapper

For testing, use `test/helpers/fake_notification_service.dart`.

### Authentication

Auth service is in `lib/core/auth/auth_service.dart` using Supabase:

- Sign in with Google, Apple, email/password
- Session management via Supabase Auth

For offline/demo mode, use `lib/core/auth/disabled_auth_service.dart`.

## Coding Style

- Dart files: `snake_case.dart`
- Classes: `PascalCase`
- Constants: `camelCase` or `SCREAMING_SNAKE_CASE` for compile-time constants
- Use `const` constructors when possible
- Two-space indentation
- Helpful trailing commas
- Files under 200 lines preferred
- Favor composition over inheritance

## Testing Guidelines

- Test files: `feature_name_test.dart`
- Mirror source structure in test directory
- Reusable fakes go in `test/helpers/`
- Unit tests for business logic
- Widget tests for UI behavior
- Don't weaken assertions to pass CI

## Git Conventions

Use conventional commits:

- `feat(auth): add Google sign-in`
- `fix(theme): correct primary color`
- `docs(readme): update setup instructions`
- `test(deck): add deck repository tests`

## Security

- Never commit secrets, API keys, or credentials
- Use environment variables or dart-defines for configuration
- Supabase config via `SUPABASE_URL` and `SUPABASE_PUBLISHABLE_KEY`
- Google Auth via `GOOGLE_WEB_CLIENT_ID` and `GOOGLE_IOS_CLIENT_ID`

## Dependencies

Key packages:

- `flutter_riverpod` - State management
- `supabase_flutter` - Backend/auth
- `go_router` - Navigation
- `google_sign_in` - Google authentication
- `sign_in_with_apple` - Apple authentication
- `flutter_local_notifications` - Local notifications
- `firebase_messaging` - Push notifications (optional)
- `google_fonts` - Typography
