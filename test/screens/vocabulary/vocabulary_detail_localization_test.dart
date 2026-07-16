import 'package:deutschtiger/features/vocabulary/domain/graduation_stats.dart';
import 'package:deutschtiger/features/vocabulary/domain/vocabulary_models.dart';
import 'package:deutschtiger/features/vocabulary/presentation/vocabulary_detail_screen.dart';
import 'package:deutschtiger/features/vocabulary/presentation/vocabulary_provider.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('vocabulary detail (topic word-list) localizes its chrome at 200% text scale', (
    tester,
  ) async {
    const listParams = TopicLevelItemsParams(topic: 'alltag', pageSize: 20);
    final graduationParams = GraduationStatsParams(topic: 'alltag');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          vocabularyTopicsProvider.overrideWith((ref) async => [_topic]),
          wordCollectionsProvider.overrideWith((ref) async => const []),
          topicLevelItemsProvider(listParams).overrideWith(
            (ref) async => CollectionItemsResult(
              items: [_item, _relatedItem],
              total: 2,
            ),
          ),
          graduationStatsProvider(graduationParams).overrideWith(
            (ref) async => const GraduationStats(total: 2, learned: 1, graduated: 1),
          ),
          itemMasteryStatesProvider(
            const ItemMasteryQuery(['haus', 'wohnung']),
          ).overrideWith((ref) async => const {}),
        ],
        child: MaterialApp(
          locale: const Locale('de'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: const VocabularyDetailScreen(slug: 'topic-alltag'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(_topic.labelVi), findsOneWidget);
    expect(find.text('Liste'), findsOneWidget);
    expect(find.text('Meine Wörter'), findsOneWidget);
    expect(find.text('Wörter suchen...'), findsOneWidget);
    expect(find.text('Schwach'), findsOneWidget);
    expect(find.text('Haus'), findsOneWidget);
    expect(find.text('Lücke füllen'), findsOneWidget);
    expect(find.text('Zuordnen'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

const _topic = VocabularyTopic(
  id: 't1',
  key: 'alltag',
  label: 'Alltag',
  labelVi: 'Đời sống hằng ngày',
  icon: '🏙️',
  createdAt: '',
);

final _item = LearningItem(
  id: 'haus',
  contentDe: 'Haus',
  contentVi: 'nhà',
  level: WordLevel.a1,
  gender: 'das',
  plural: 'Häuser',
  wordType: 'Nomen',
  meanings: const ['nhà'],
  examples: const [Example(de: 'Das Haus ist groß.', vi: 'Ngôi nhà lớn.')],
  createdAt: '2026-01-01T00:00:00Z',
  updatedAt: '2026-01-01T00:00:00Z',
);

final _relatedItem = LearningItem(
  id: 'wohnung',
  contentDe: 'Wohnung',
  contentVi: 'căn hộ',
  level: WordLevel.a1,
  createdAt: '2026-01-01T00:00:00Z',
  updatedAt: '2026-01-01T00:00:00Z',
);
