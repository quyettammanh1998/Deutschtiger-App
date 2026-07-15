import '../domain/daily_path.dart';
import '../../../core/release/release_feature_flags.dart';

/// Resolves a server-suggested daily-path skill to a release-safe route.
/// Unsupported route families stay in the API response, but the app returns
/// learners to the live Learn hub until their feature gate is explicitly on.
String resolveDailyPathRoute(DailyPathStep? step) => switch (step?.skill) {
  'vocab' => '/journey/session',
  'review' || 'flashcard' => '/daily-review',
  'grammar' when ReleaseFeatureFlags.grammar => '/grammar',
  'listening' when ReleaseFeatureFlags.listening => '/listening',
  'reading' when ReleaseFeatureFlags.reading => '/reading',
  'exam' => '/exam',
  _ => '/learn',
};
