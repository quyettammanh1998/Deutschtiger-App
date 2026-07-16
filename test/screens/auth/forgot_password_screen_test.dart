import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/auth/forgot_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: ForgotPasswordScreen(),
        ),
      ),
    );
  }

  testWidgets('renders the dark particle-glass card with the email form', (
    tester,
  ) async {
    await pumpScreen(tester);
    await tester.pump();

    final l10n = await AppLocalizations.delegate.load(const Locale('vi'));
    expect(find.text(l10n.passwordRecovery), findsOneWidget);
    expect(find.text(l10n.email), findsOneWidget);
    expect(find.text(l10n.sendRecoveryEmail), findsOneWidget);
    expect(find.text(l10n.backToLogin), findsOneWidget);
  });

  testWidgets('email validation blocks submit on an empty field', (
    tester,
  ) async {
    await pumpScreen(tester);
    await tester.pump();

    final l10n = await AppLocalizations.delegate.load(const Locale('vi'));
    await tester.tap(find.text(l10n.sendRecoveryEmail));
    await tester.pump();

    expect(find.text(l10n.emailRequired), findsOneWidget);
  });
}
