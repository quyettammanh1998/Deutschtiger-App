import 'package:deutschtiger/services/onboarding_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('completion persists across service instances', () async {
    SharedPreferences.setMockInitialValues({});
    const first = OnboardingService();
    const second = OnboardingService();

    expect(await first.isCompleted(), isFalse);
    await first.complete();
    expect(await second.isCompleted(), isTrue);
  });
}
