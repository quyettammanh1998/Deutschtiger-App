---
title: "Architecture Improvements: Design Tokens, Notifications, Auth Fallback"
description: "Incremental TDD architecture improvements: centralized design tokens, notification service abstraction, auth fallback, widget previews"
status: pending
priority: P2
effort: 6h
branch: main
tags: [architecture, refactor, design-tokens, notifications, auth, tdd]
created: 2026-06-30
---

# Architecture Improvements Plan

## Context

Incremental architecture improvements for Deutschtiger-App, following patterns from `flutter-accelerator-ai` reference repo. Goal is to establish foundational patterns that enable better testing, preview generation, and future feature development without breaking existing functionality.

## Reference Architecture

From `/home/qtm/Desktop/flutter-accelerator-ai`:
- Design tokens centralized in static classes (`AppTokens`)
- Notification services use interface + implementation pattern
- Preview fakes enable widget preview generation
- Auth uses repository contract with sealed session states

## Phases

| Phase | Title | Effort | Dependencies |
|-------|-------|--------|-------------|
| 1 | Design Tokens | 1.5h | None |
| 2 | Notification Service | 2h | Phase 1 |
| 3 | Auth Fallback + Previews + Docs | 2.5h | Phase 1 |

---

## Phase 1: Design Tokens

### Overview
Extract all design constants from `app_colors.dart` and `app_theme.dart` into a centralized `DesignTokens` class, enabling consistent spacing, colors, typography, and animation values across the codebase.

### Requirements
- **Functional**: Extract all constants, create getters for derived values
- **Non-functional**: Maintain backward compatibility via re-exports; no breaking changes

### Architecture

```
lib/core/design_tokens.dart  (NEW)
├── Spacing constants (xs=4, sm=8, md=16, lg=24, xl=32)
├── Colors (re-export from AppColors)
├── Typography (TextStyles using Inter font)
├── Animation durations (fast=120ms, medium=220ms, slow=450ms)
├── Gradients (primaryGradient, glass gradient)
└── Border radii

lib/core/theme/app_theme.dart  (MODIFY)
└── Use DesignTokens for all hardcoded values
```

### Related Code Files

| Action | Path |
|--------|------|
| Create | `lib/core/design_tokens.dart` |
| Modify | `lib/core/theme/app_theme.dart` |
| Modify | `lib/core/theme/app_colors.dart` |

### TDD Steps

1. **Write test/preview FIRST**: Create `test/core/design_tokens_test.dart`
   ```dart
   // Verify spacing values
   expect(DesignTokens.spacingXs, 4);
   expect(DesignTokens.spacingMd, 16);
   
   // Verify colors exist
   expect(DesignTokens.primary, isNotNull);
   
   // Verify gradient
   expect(DesignTokens.primaryGradient.colors.length, 2);
   ```

2. **Create `lib/core/design_tokens.dart`** with all extracted values

3. **Update `lib/core/theme/app_colors.dart`** to re-export from DesignTokens for backward compat

4. **Update `lib/core/theme/app_theme.dart`** to use DesignTokens

5. **Run**: `flutter analyze` to verify no lint errors

### Success Criteria
- [ ] `DesignTokens` class contains all spacing, colors, typography, gradients
- [ ] `app_theme.dart` uses `DesignTokens` (zero hardcoded magic numbers)
- [ ] `flutter analyze` passes with zero errors
- [ ] Preview builds successfully

### Risk Assessment
| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Breaking existing imports | Low | High | Re-export from `app_colors.dart` for backward compat |
| Missing values | Medium | Medium | Comprehensive grep of existing code before deletion |

---

## Phase 2: Notification Service

### Overview
Refactor the existing `notification_service.dart` into interface + implementation architecture following the reference repo pattern. This enables testing with fakes and supports both local notifications and FCM.

### Requirements
- **Functional**: Interface with `initialize()`, `hasPermission()`, `requestPermission()`, `scheduleDailyReminder()`, `cancelAll()`
- **Non-functional**: Keep existing Riverpod provider setup; FCM implementation optional

### Architecture

```
lib/core/notifications/
├── notification_contract.dart      (NEW - abstract interface)
├── local_notification_service.dart  (NEW - flutter_local_notifications impl)
├── fcm_notification_service.dart   (NEW - Firebase Cloud Messaging)
└── notification_service.dart        (REFACTOR - delegates to impl)

lib/test/helpers/
└── fake_notification_service.dart   (NEW - for unit testing)

lib/previews/
└── preview_notification_service.dart (NEW - for widget previews)
```

### Interface Contract

```dart
abstract interface class NotificationContract {
  Future<void> initialize();
  Future<bool> hasPermission();
  Future<bool> requestPermission();
  Future<void> scheduleDailyReminder({required int hour, required int minute, String? title, String? body});
  Future<void> cancelAll();
}
```

### Related Code Files

| Action | Path |
|--------|------|
| Create | `lib/core/notifications/notification_contract.dart` |
| Create | `lib/core/notifications/local_notification_service.dart` |
| Create | `lib/core/notifications/fcm_notification_service.dart` |
| Modify | `lib/core/notifications/notification_service.dart` |
| Create | `test/helpers/fake_notification_service.dart` |
| Create | `lib/previews/preview_notification_service.dart` |

### TDD Steps

1. **Write tests FIRST**: Create `test/core/notifications/notification_contract_test.dart`
   ```dart
   test('LocalNotificationService initializes once', () async {
     final service = LocalNotificationServiceImpl();
     await service.initialize();
     await service.initialize(); // Should not throw
   });
   
   test('FakeNotificationService tracks schedule calls', () async {
     final fake = FakeNotificationService();
     await fake.scheduleDailyReminder(hour: 9, minute: 0);
     expect(fake.scheduleCount, 1);
   });
   ```

2. **Create `notification_contract.dart`** with abstract interface

3. **Create `local_notification_service.dart`** following reference implementation

4. **Create `fcm_notification_service.dart`** skeleton (FCM-specific methods)

5. **Refactor `notification_service.dart`** to use composition over inheritance

6. **Create `fake_notification_service.dart`** for testing

7. **Create `preview_notification_service.dart`** for widget previews

8. **Update Riverpod provider** to use new architecture

9. **Run**: `flutter test` to verify tests pass

### Success Criteria
- [ ] `NotificationContract` interface with all required methods
- [ ] `LocalNotificationServiceImpl` implements interface
- [ ] `FakeNotificationService` for unit tests with call tracking
- [ ] `PreviewNotificationService` returns success for previews
- [ ] Existing `notificationServiceProvider` still works (no breaking changes)
- [ ] All tests pass

### Risk Assessment
| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Breaking existing Riverpod usage | Medium | High | Keep provider signature identical; only change internal impl |
| FCM initialization complexity | Medium | Low | FCM implementation is additive; local notifications are MVP |

---

## Phase 3: Auth Fallback + Widget Previews + Documentation

### Overview
Create disabled auth service for offline/demo mode, establish widget preview system, and document architecture in AGENTS.md.

### Requirements
- **Functional**: Disabled auth returns guest session, previews enable @Preview annotation, docs explain architecture
- **Non-functional**: Follow reference repo patterns exactly

### Architecture

```
lib/core/auth/
└── disabled_auth_service.dart  (NEW - offline/demo fallback)

lib/previews/
├── preview_fixtures.dart        (NEW - wrapper functions)
├── preview_sample_data.dart     (NEW - mock data)
└── preview_auth_service.dart    (NEW - preview auth)

AGENTS.md                         (NEW - repo documentation)
```

### Auth Fallback Pattern

```dart
class DisabledAuthService implements AuthService {
  // Returns null session, throws on sign-in attempts
  // Use case: offline mode, demo mode, CI tests
}
```

### Preview Pattern

```dart
// preview_fixtures.dart
Widget previewApp(Widget child) => MaterialApp(
  home: Scaffold(
    backgroundColor: DesignTokens.background,
    body: SafeArea(child: child),
  ),
);

// Usage with @Preview annotation
@Preview(name: 'Login Button', group: 'Auth')
Widget loginButtonPreview() => LoginButton(
  onPressed: () {},
  isLoading: false,
);
```

### Related Code Files

| Action | Path |
|--------|------|
| Create | `lib/core/auth/disabled_auth_service.dart` |
| Create | `lib/previews/preview_fixtures.dart` |
| Create | `lib/previews/preview_sample_data.dart` |
| Create | `lib/previews/preview_auth_service.dart` |
| Create | `AGENTS.md` |

### TDD Steps

1. **Write preview tests FIRST**: Create preview and verify in IDE
   ```dart
   // Verify preview renders correctly
   @Preview(name: 'Disabled Auth Button')
   Widget disabledAuthPreview() => AuthButton(
     onPressed: null,
     label: 'Offline Mode',
   );
   ```

2. **Create `disabled_auth_service.dart`** following auth contract

3. **Create `lib/previews/preview_fixtures.dart`** with wrapper functions

4. **Create `lib/previews/preview_sample_data.dart`** with mock data

5. **Create `lib/previews/preview_auth_service.dart`** with preview auth

6. **Create `AGENTS.md`** documenting:
   - Project structure
   - Build/test commands
   - Coding conventions
   - Testing guidelines
   - Security tips

7. **Run**: `flutter analyze` to verify no lint errors

### Success Criteria
- [ ] `DisabledAuthService` handles offline scenario gracefully
- [ ] Preview wrappers work with @Preview annotation
- [ ] `AGENTS.md` documents architecture and conventions
- [ ] `flutter analyze` passes

### Risk Assessment
| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Preview annotations need IDE support | Low | Low | Works in Android Studio/IntelliJ with Flutter plugin |
| Missing mock data | Medium | Medium | Add as needed during preview creation |

---

## Test Matrix

| Phase | Unit Test | Widget Test | Integration |
|-------|-----------|-------------|-------------|
| Design Tokens | Verify constant values | Verify theme applies | Verify in running app |
| Notification | Contract impl, fake tracking | N/A | Manual notification test |
| Auth Fallback | Auth methods return correct values | Preview renders | N/A |

## Rollback Plan

| Phase | Rollback Action |
|-------|-----------------|
| Phase 1 | Revert `app_theme.dart` to use raw `AppColors.*` values |
| Phase 2 | Revert `notification_service.dart` to single-class version |
| Phase 3 | Delete `disabled_auth_service.dart`, preview files, `AGENTS.md` |

## Dependency Graph

```
Phase 1 (Design Tokens)
    └── Phase 2 (Notification Service)
    └── Phase 3 (Auth + Previews + Docs)

Phase 2 blocks on: Phase 1 (uses DesignTokens for notification UI)
Phase 3 blocks on: Phase 1 (preview fixtures use DesignTokens)
```

## File Ownership

| File | Owner Phase |
|------|-------------|
| `lib/core/design_tokens.dart` | Phase 1 |
| `lib/core/theme/app_colors.dart` | Phase 1 |
| `lib/core/theme/app_theme.dart` | Phase 1 |
| `lib/core/notifications/*.dart` | Phase 2 |
| `lib/core/auth/disabled_auth_service.dart` | Phase 3 |
| `lib/previews/*.dart` | Phase 3 |
| `AGENTS.md` | Phase 3 |

---

## Unresolved Questions

1. **FCM Implementation**: Should FCM share the `NotificationContract` interface or have its own? Recommendation: Share interface, FCM adds `onForegroundMessage` and `onBackgroundMessage` handlers.

2. **Preview Tooling**: Current Flutter SDK supports `@Preview` annotation in Android Studio. Need to verify VSCode extension support. Fallback: Use `flutter preview` CLI.

3. **Backward Compat**: Should `AppColors` continue to exist as re-export or be deprecated? Recommendation: Keep for 1 minor version, mark as deprecated, then remove in next major version.

## Commands Reference

```bash
# Phase 1
flutter test test/core/design_tokens_test.dart
flutter analyze lib/core/design_tokens.dart lib/core/theme/

# Phase 2
flutter test test/core/notifications/
flutter analyze lib/core/notifications/

# Phase 3
flutter analyze lib/previews/ AGENTS.md

# All phases
flutter analyze
flutter test
```
