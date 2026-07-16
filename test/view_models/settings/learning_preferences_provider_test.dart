import 'package:deutschtiger/repositories/settings/learning_preferences_repository.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:deutschtiger/view_models/settings/learning_preferences_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Regression test for the `unawaited(_load())` race previously in
/// [LearningPreferencesNotifier.build] (fixed to `Future.microtask`): if
/// the repository provider throws *synchronously* during construction,
/// the notifier's `build()` must still return before the error handler
/// writes `state`, otherwise Riverpod throws "Tried to read the state of
/// an uninitialized provider" instead of the notifier's own error state.
void main() {
  test('build() returns before a synchronously-throwing repository can write state', () {
    final container = ProviderContainer(
      overrides: [
        learningPreferencesRepositoryProvider.overrideWith((ref) {
          throw StateError('boom — synchronous provider construction failure');
        }),
      ],
    );
    addTearDown(container.dispose);

    // Must not throw "Tried to read the state of an uninitialized provider".
    final initial = container.read(learningPreferencesProvider);
    expect(initial.isLoading, isTrue);
    expect(initial.preferences, isNull);
  });

  test('build() returns before an async-throwing repository can write state', () async {
    final container = ProviderContainer(
      overrides: [
        learningPreferencesRepositoryProvider.overrideWithValue(
          _ThrowingLearningPreferencesRepository(),
        ),
      ],
    );
    addTearDown(container.dispose);
    // Keep the autoDispose provider alive across the await below — a bare
    // `container.read` with no listener would let it dispose itself
    // between the two reads.
    final sub = container.listen(learningPreferencesProvider, (_, _) {});
    addTearDown(sub.close);

    final initial = container.read(learningPreferencesProvider);
    expect(initial.isLoading, isTrue);

    await Future<void>.delayed(const Duration(milliseconds: 10));
    final settled = container.read(learningPreferencesProvider);
    expect(settled.isLoading, isFalse);
    expect(settled.error, 'load');
  });
}

class _ThrowingLearningPreferencesRepository extends LearningPreferencesRepository {
  _ThrowingLearningPreferencesRepository()
    : super(
        ApiClient(baseUrl: 'https://example.test/api/v1', tokenProvider: _NoTokenProvider()),
      );

  @override
  Future<LearningPreferences> get() async {
    throw Exception('load failed');
  }
}

class _NoTokenProvider implements TokenProvider {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> refresh() async => null;
}
