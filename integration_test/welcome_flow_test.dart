import 'package:deutschtiger/main.dart' as app;
import 'package:deutschtiger/screens/auth/onboarding_screen.dart';
import 'package:deutschtiger/screens/auth/welcome_screen.dart';
import 'package:deutschtiger/widgets/common/gradient_button.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('welcome CTA opens onboarding', (tester) async {
    app.main();
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(find.byType(GradientButton), findsOneWidget);

    await tester.tap(find.byType(GradientButton));
    await tester.pumpAndSettle();

    expect(find.byType(OnboardingScreen), findsOneWidget);
  });
}
