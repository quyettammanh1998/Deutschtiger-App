---
phase: 2
title: "Core Layer Consolidation"
status: pending
priority: P1
effort: 2h
dependencies: [phase-01-baseline]
---

# Phase 2: Core Layer Consolidation

## Overview
Move services from `lib/core/` to `lib/services/`, keeping design tokens and theme in core.

## Requirements
- Functional: Move auth, notifications, audio, network, offline, config services
- Non-functional: Keep design_tokens.dart, app_colors.dart, app_theme.dart in core/

## Architecture
```
lib/core/                    lib/services/
├── design_tokens.dart       ├── auth_service.dart
├── theme/                   ├── disabled_auth_service.dart
│   ├── app_colors.dart     ├── auth_provider.dart
│   └── app_theme.dart      ├── notifications/
└── i18n/                   │   ├── notification_contract.dart
                            │   ├── notification_service.dart
                            │   ├── local_notification_service.dart
                            │   └── fcm_notification_service.dart
                            ├── audio_service.dart
                            ├── api_client.dart
                            ├── offline/
                            └── config/
```

## Files to Move
| Source | Target | Type |
|--------|--------|------|
| `lib/core/auth/auth_service.dart` | `lib/services/auth_service.dart` | Move |
| `lib/core/auth/disabled_auth_service.dart` | `lib/services/disabled_auth_service.dart` | Move |
| `lib/core/auth/token_provider.dart` | `lib/services/auth_provider.dart` | Move+Rename |
| `lib/core/notifications/*.dart` | `lib/services/notifications/` | Move dir |
| `lib/core/audio/audio_service.dart` | `lib/services/audio_service.dart` | Move |
| `lib/core/network/api_client.dart` | `lib/services/api_client.dart` | Move |
| `lib/core/offline/*.dart` | `lib/services/offline_service.dart` | Move |
| `lib/core/config/app_config.dart` | `lib/services/config/app_config.dart` | Move |

## Files to KEEP in core/
- `lib/core/design_tokens.dart`
- `lib/core/theme/app_colors.dart`
- `lib/core/theme/app_theme.dart`
- `lib/core/theme/theme_provider.dart`

## Implementation Steps

### 2.1: Write Tests First
```dart
// test/structure/core_to_services_migration_test.dart
test('AuthService moved to services/', () {
  expect(File('lib/services/auth_service.dart').existsSync(), true);
});
test('design_tokens.dart remains in core/', () {
  expect(File('lib/core/design_tokens.dart').existsSync(), true);
});
```

### 2.2: Move Files
```bash
git mv lib/core/auth/auth_service.dart lib/services/
git mv lib/core/auth/disabled_auth_service.dart lib/services/
git mv lib/core/auth/token_provider.dart lib/services/auth_provider.dart
git mv lib/core/notifications lib/services/
git mv lib/core/audio/audio_service.dart lib/services/
git mv lib/core/network/api_client.dart lib/services/
git mv lib/core/offline lib/services/
git mv lib/core/config lib/services/config/
```

### 2.3: Create Barrel Export
```dart
// lib/services/services.dart
export 'auth_service.dart';
export 'disabled_auth_service.dart';
export 'auth_provider.dart';
export 'notifications/notification_service.dart';
// ... etc
```

## Success Criteria
- [ ] All services moved to lib/services/
- [ ] design_tokens, colors, theme remain in lib/core/
- [ ] Tests pass
- [ ] `flutter analyze` passes

## Rollback
```bash
git checkout HEAD -- lib/core/ lib/services/
```

## Risk Assessment
- **Risk:** Medium - Import statements need updating
- **Mitigation:** Use IDE refactor tool, Phase 9 handles remaining
