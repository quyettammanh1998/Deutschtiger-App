import 'package:deutschtiger/services/secure_auth_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => FlutterSecureStorage.setMockInitialValues({}));

  test('persists and removes the Supabase session in secure storage', () async {
    final storage = SecureAuthStorage();
    await storage.initialize();

    expect(await storage.hasAccessToken(), isFalse);
    await storage.persistSession('{"refresh_token":"secret"}');
    expect(await storage.hasAccessToken(), isTrue);
    expect(await storage.accessToken(), '{"refresh_token":"secret"}');

    await storage.removePersistedSession();
    expect(await storage.hasAccessToken(), isFalse);
  });

  test('persists and removes OAuth PKCE values in secure storage', () async {
    final storage = SecurePkceStorage();

    await storage.setItem(key: 'verifier', value: 'pkce-secret');
    expect(await storage.getItem(key: 'verifier'), 'pkce-secret');

    await storage.removeItem(key: 'verifier');
    expect(await storage.getItem(key: 'verifier'), isNull);
  });
}
