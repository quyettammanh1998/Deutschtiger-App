import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  const OnboardingService();

  static const completedKey = 'onboarding_completed_v1';

  Future<bool> isCompleted() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(completedKey) ?? false;
  }

  Future<void> complete() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(completedKey, true);
  }
}
