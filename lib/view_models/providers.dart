import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:deutschtiger/navigation/router_keys.dart';
import 'package:deutschtiger/services/audio_service.dart';
import 'package:deutschtiger/services/dictionary_service.dart';
import 'package:deutschtiger/services/onboarding_service.dart';
import 'package:deutschtiger/services/auth_service.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:deutschtiger/services/config/app_config.dart';
import 'package:deutschtiger/core/identity/app_user.dart';
import 'package:deutschtiger/repositories/profile_repository.dart';
import 'package:deutschtiger/repositories/flashcard/flashcard_quick_save_repository.dart';
import 'package:deutschtiger/repositories/home/dashboard_repository.dart';
import 'package:deutschtiger/data/home/dashboard_data.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/event_tracking.dart';
import 'package:deutschtiger/shared/widgets/device_kicked_dialog.dart';
import 'package:deutschtiger/core/translation/translation_service.dart';

/// DI gốc cho core layer. Feature đọc các provider này, không tự khởi tạo SDK.

/// SupabaseClient global (đã init trong main qua Supabase.initialize).
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.watch(supabaseClientProvider));
});

final tokenProviderProvider = Provider<TokenProvider>((ref) {
  return SupabaseTokenProvider(ref.watch(supabaseClientProvider));
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final client = ApiClient(
    baseUrl: AppConfig.apiBaseUrl,
    tokenProvider: ref.watch(tokenProviderProvider),
  );
  // Wire device-kicked handler SAU khi GoRouter sẵn sàng (provider này có
  // thể được đọc trước MaterialApp.router). signOut là best-effort — nếu
  // Supabase session đã bị backend thu hồi, lệnh này có thể throw và bị bỏ.
  client.onDeviceKicked = () async {
    try {
      await ref.read(authServiceProvider).signOut();
    } catch (_) {
      // ignore: session đã bị backend thu hồi trước đó.
    }
    await showDeviceKickedDialog(
      rootNavigatorKey: rootNavigatorKey,
      onAcknowledge: () {
        // Lấy context từ root navigator key để tránh import cycle với
        // app_router.dart (nơi GoRouter được tạo).
        final ctx = rootNavigatorKey.currentContext;
        if (ctx != null && ctx.mounted) {
          GoRouter.of(ctx).go('/login');
        }
      },
    );
  };
  return client;
});

final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService(ref.watch(apiClientProvider));
  ref.onDispose(service.dispose);
  return service;
});

final dictionaryServiceProvider = Provider<DictionaryService>((ref) {
  return DictionaryService(ref.watch(apiClientProvider));
});

final translationServiceProvider = Provider<TranslationService>((ref) {
  return TranslationService(ref.watch(apiClientProvider));
});

final flashcardQuickSaveRepositoryProvider =
    Provider<FlashcardQuickSaveRepository>((ref) {
      return FlashcardQuickSaveRepository(ref.watch(apiClientProvider));
    });

final onboardingServiceProvider = Provider<OnboardingService>((ref) {
  return const OnboardingService();
});

final onboardingCompletedProvider = FutureProvider<bool>((ref) {
  return ref.watch(onboardingServiceProvider).isCompleted();
});

/// Stream auth state cho router redirect + UI reactive.
final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(ref.watch(apiClientProvider));
});

/// Profile của user hiện tại (resolve từ backend). Auto-refetch khi auth đổi.
final myProfileProvider = FutureProvider<AppUser>((ref) {
  ref.watch(authStateProvider); // refetch khi login/logout
  return ref.watch(profileRepositoryProvider).fetchMyProfile();
});

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(ref.watch(apiClientProvider));
});

/// Dashboard data — GET /api/v1/user/dashboard-init.
final dashboardProvider = FutureProvider<DashboardData>((ref) {
  ref.watch(authStateProvider); // refetch khi login/logout
  return ref.watch(dashboardRepositoryProvider).fetchDashboard();
});

/// Event tracking buffer (mirrors web `lib/shared/event-tracking.ts`) —
/// `POST /api/v1/user/events`, fire-and-forget, never blocks UI.
final eventTrackingProvider = Provider<EventTracking>((ref) {
  final tracking = EventTracking(apiClient: ref.watch(apiClientProvider));
  ref.onDispose(tracking.dispose);
  return tracking;
});
