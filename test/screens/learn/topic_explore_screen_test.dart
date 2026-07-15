import 'package:deutschtiger/data/learn/learn_models.dart';
import 'package:deutschtiger/features/vocabulary/domain/vocabulary_models.dart';
import 'package:deutschtiger/features/vocabulary/presentation/vocabulary_provider.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/learn/topic_explore_screen.dart';
import 'package:deutschtiger/view_models/learn/learn_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('topic explore screen renders main topics', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          vocabularyTopicsProvider.overrideWith((ref) async => _topics),
          topicLevelCountsProvider.overrideWith((ref) async => const []),
          learnPreferencesProvider.overrideWith(
            (ref) async => const LearnPreferences(
              learningGoals: ['goethe'],
              priorityTopics: ['essen'],
            ),
          ),
        ],
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: TopicExploreScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Khám phá theo chủ đề'), findsOneWidget);
    expect(find.text('Ăn uống'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('topic explore screen shows empty state', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          vocabularyTopicsProvider.overrideWith((ref) async => const []),
          topicLevelCountsProvider.overrideWith((ref) async => const []),
          learnPreferencesProvider.overrideWith(
            (ref) async => const LearnPreferences(
              learningGoals: [],
              priorityTopics: [],
            ),
          ),
        ],
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: TopicExploreScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Chưa có chủ đề nào.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('topic explore screen shows error view + retry', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          vocabularyTopicsProvider.overrideWith(
            (ref) async => throw Exception('boom'),
          ),
        ],
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: TopicExploreScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Không tải được dữ liệu. Vui lòng thử lại.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

final _topics = [
  VocabularyTopic(
    id: 't1',
    key: 'essen',
    label: 'Food',
    labelVi: 'Ăn uống',
    icon: '🍔',
    createdAt: '2026-01-01T00:00:00Z',
  ),
];
