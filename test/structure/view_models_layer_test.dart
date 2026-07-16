import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ViewModels Layer Migration', () {
    test('lib/view_models/providers.dart exists', () {
      expect(File('lib/view_models/providers.dart').existsSync(), true);
    });

    test('lib/view_models/theme_provider.dart exists', () {
      expect(File('lib/view_models/theme_provider.dart').existsSync(), true);
    });

    test('lib/view_models/preferences_provider.dart exists', () {
      expect(File('lib/view_models/preferences_provider.dart').existsSync(), true);
    });

    test('Feature providers moved from features/*/presentation/', () {
      final providersToCheck = [
        'lib/view_models/ai/ai_provider.dart',
        'lib/view_models/exam/exam_provider.dart',
        'lib/view_models/flashcard/review_provider.dart',
        'lib/view_models/home/home_provider.dart',
        'lib/view_models/interview/video_note_provider.dart',
        'lib/view_models/interview/transcript_provider.dart',
        'lib/view_models/journey/journey_provider.dart',
        'lib/view_models/listening/podcast_provider.dart',
        'lib/view_models/speaking/speaking_provider.dart',
        'lib/view_models/social/social_repository_providers.dart',
        'lib/view_models/social/friends_provider.dart',
        'lib/view_models/social/messages_provider.dart',
        'lib/view_models/stats/stats_provider.dart',
      ];

      final missing = <String>[];
      for (final provider in providersToCheck) {
        if (!File(provider).existsSync()) {
          missing.add(provider);
        }
      }

      expect(missing, isEmpty, reason: 'Missing providers: ${missing.join(', ')}');
    });
  });
}
