import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'audio/audio_service.dart';
import 'auth/auth_service.dart';
import 'auth/token_provider.dart';
import 'config/app_config.dart';
import 'identity/app_user.dart';
import 'identity/profile_repository.dart';
import 'network/api_client.dart';

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
  return ApiClient(
    baseUrl: AppConfig.apiBaseUrl,
    tokenProvider: ref.watch(tokenProviderProvider),
  );
});

final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService(ref.watch(apiClientProvider));
  ref.onDispose(service.dispose);
  return service;
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
