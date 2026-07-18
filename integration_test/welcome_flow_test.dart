import 'package:deutschtiger/main.dart' as app;
import 'package:deutschtiger/screens/auth/onboarding_screen.dart';
import 'package:deutschtiger/screens/auth/welcome_screen.dart';
import 'package:deutschtiger/widgets/common/gradient_button.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// Bơm frame lặp lại tới khi [finder] xuất hiện hoặc hết [timeout].
///
/// `app.main()` chạy bootstrap bất đồng bộ (Firebase + Supabase +
/// force-update qua mạng) nên `runApp` chỉ được gọi sau khi các future đó
/// hoàn tất. Một `pumpAndSettle()` đơn lẻ có thể trả về trước lúc widget tree
/// tồn tại → không tìm thấy WelcomeScreen. Vòng lặp pump theo thời gian thực
/// cho bootstrap kịp hoàn tất trước khi assert.
Future<void> _pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 30),
  Duration step = const Duration(milliseconds: 200),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    await tester.pump(step);
    if (finder.evaluate().isNotEmpty) return;
  }
  throw StateError('Timed out waiting for $finder after $timeout');
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('welcome CTA opens onboarding', (tester) async {
    app.main();

    await _pumpUntilFound(tester, find.byType(WelcomeScreen));
    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(find.byType(GradientButton), findsOneWidget);

    await tester.tap(find.byType(GradientButton));

    await _pumpUntilFound(tester, find.byType(OnboardingScreen));
    expect(find.byType(OnboardingScreen), findsOneWidget);
  });
}
