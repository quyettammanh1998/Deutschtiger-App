import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/auth/login_screen.dart';
import 'package:deutschtiger/screens/auth/widgets/social_login_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('login form renders above the Google divider (web order)', (
    tester,
  ) async {
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
          home: LoginScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
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
}
