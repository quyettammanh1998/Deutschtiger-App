import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/auth/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('welcome screen renders its main marketing sections', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 3200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('vi'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: WelcomeScreen(),
      ),
    );
    // Not `pumpAndSettle`: the hero's live-pill dot runs an infinite
    // repeating fade animation, which would never settle.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Nav header brand + hero headline + CTA.
    expect(find.textContaining('Deutsch'), findsWidgets);
    expect(find.text('Bắt đầu hành trình'), findsWidgets);
    expect(find.text('Học tiếng Đức'), findsOneWidget);

    // Stats bar.
    expect(find.text('10k+'), findsOneWidget);

    // How-it-works section head (eyebrow is upper-cased in the widget).
    expect(find.text('CÁCH HỌC'), findsOneWidget);

    // Features grid — a couple of card titles.
    expect(find.text('Runner Game'), findsOneWidget);
    expect(find.text('Tiger AI'), findsOneWidget);

    // Testimonials eyebrow (upper-cased in the widget).
    expect(find.text('HỌC VIÊN'), findsOneWidget);

    // Footer credit.
    expect(find.textContaining('Vũ Quang Cường'), findsOneWidget);
  });

  testWidgets('primary CTA opens the auth modal with login/signup entries', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 3200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('vi'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: WelcomeScreen(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    await tester.tap(find.text('Bắt đầu hành trình').first);
    // Bottom sheet route transition, bounded (see note above re: infinite
    // hero animation preventing `pumpAndSettle`).
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    final l10n = await AppLocalizations.delegate.load(const Locale('vi'));
    expect(find.text(l10n.logIn), findsOneWidget);
    expect(find.text(l10n.signUp), findsOneWidget);
  });
}
