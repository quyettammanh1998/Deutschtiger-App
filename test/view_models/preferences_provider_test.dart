import 'package:deutschtiger/view_models/preferences_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'keeps a local language selection when the initial preferences read completes',
    () async {
      SharedPreferences.setMockInitialValues({'app_language': 'de'});
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(preferencesProvider);
      await container.read(preferencesProvider.notifier).setLanguage('en');
      await Future<void>.delayed(Duration.zero);

      expect(container.read(preferencesProvider).appLanguage, 'en');
    },
  );
}
