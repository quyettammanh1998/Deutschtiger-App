import 'dart:async';

import 'package:deutschtiger/screens/auth/widgets/social_login_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('social login loading follows the OAuth future, not a timer', (
    tester,
  ) async {
    final completer = Completer<void>();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SocialLoginButton(
            provider: 'google',
            label: 'Continue with Google',
            icon: const GoogleIconSimple(),
            onPressed: () => completer.future,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(OutlinedButton));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete();
    await tester.pump();
    expect(find.text('Continue with Google'), findsOneWidget);
  });
}
