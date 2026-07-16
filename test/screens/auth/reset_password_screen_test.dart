import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/auth/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// [ResetPasswordScreen] reads `Supabase.instance.client.auth` directly
/// (mirrors the original screen's design — Supabase drives the recovery
/// flow, not a Riverpod provider) so it needs a real, if fake-backed,
/// Supabase instance in the widget test. `EmptyLocalStorage` sidesteps the
/// shared_preferences platform channel.
Future<void> _ensureSupabaseInitialized() async {
  try {
    Supabase.instance;
    return;
  } on AssertionError {
    // Not yet initialized — fall through and initialize below.
  }
  SharedPreferences.setMockInitialValues({});
  await Supabase.initialize(
    url: 'https://example.supabase.co',
    anonKey: 'test-anon-key', // ignore: deprecated_member_use — `publishableKey` requires a real Supabase publishable key format; a fake anon key is enough for this offline test double.
    authOptions: const FlutterAuthClientOptions(localStorage: EmptyLocalStorage()),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(_ensureSupabaseInitialized);

  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('vi'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: ResetPasswordScreen(),
      ),
    );
  }

  testWidgets('renders the dark glass card with a loading spinner first', (
    tester,
  ) async {
    await pumpScreen(tester);
    await tester.pump();

    final l10n = await AppLocalizations.delegate.load(const Locale('vi'));
    expect(find.text(l10n.resetPassword), findsOneWidget);
    expect(find.text(l10n.verifyingResetLink), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('falls back to the invalid-link error after the 3s timeout', (
    tester,
  ) async {
    await pumpScreen(tester);
    await tester.pump();
    await tester.pump(const Duration(seconds: 4));

    final l10n = await AppLocalizations.delegate.load(const Locale('vi'));
    expect(find.text(l10n.resetLinkInvalid), findsOneWidget);
    expect(find.text(l10n.resendResetLink), findsOneWidget);
  });
}
