import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/auth/signup_screen.dart';
import 'package:deutschtiger/screens/auth/widgets/social_login_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpSignup(WidgetTester tester) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    const ProviderScope(
      child: MaterialApp(
        locale: Locale('vi'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: SignupScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('signup shows an h1 title and confirm-password field', (
    tester,
  ) async {
    await _pumpSignup(tester);
    final l10n = await AppLocalizations.delegate.load(const Locale('vi'));

    expect(find.text(l10n.createAccount), findsNWidgets(2));
    expect(find.text(l10n.signupSubtitle), findsOneWidget);
    expect(find.text(l10n.confirmPassword), findsOneWidget);
    expect(find.text(l10n.atLeastEightCharacters), findsNWidgets(2));
  });

  testWidgets('signup form renders above the Google divider (web order)', (
    tester,
  ) async {
    await _pumpSignup(tester);
    final l10n = await AppLocalizations.delegate.load(const Locale('vi'));

    final passwordFieldTop = tester
        .getTopLeft(find.text(l10n.password))
        .dy;
    final dividerTop = tester.getTopLeft(find.text(l10n.or)).dy;
    final googleTop = tester
        .getTopLeft(find.byType(SocialLoginButton).first)
        .dy;

    expect(passwordFieldTop, lessThan(dividerTop));
    expect(dividerTop, lessThan(googleTop));
  });

  testWidgets('confirm-password mismatch blocks submit with an inline error', (
    tester,
  ) async {
    await _pumpSignup(tester);
    final l10n = await AppLocalizations.delegate.load(const Locale('vi'));

    await tester.enterText(
      find.widgetWithText(TextFormField, '').first,
      'Cường',
    );
    final passwordField = find.ancestor(
      of: find.text(l10n.password),
      matching: find.byType(Column),
    );
    expect(passwordField, findsWidgets);

    await tester.enterText(find.byType(TextFormField).at(1), 'abc12345');
    await tester.enterText(find.byType(TextFormField).at(2), 'abc12345');
    await tester.enterText(find.byType(TextFormField).at(3), 'different1');
    await tester.tap(find.text(l10n.createAccount).last);
    await tester.pump();

    expect(find.text(l10n.passwordConfirmationMismatch), findsOneWidget);
  });
}
