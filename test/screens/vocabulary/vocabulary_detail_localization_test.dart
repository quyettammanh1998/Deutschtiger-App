import 'package:deutschtiger/features/vocabulary/domain/vocabulary_models.dart';
import 'package:deutschtiger/features/vocabulary/presentation/vocabulary_detail_screen.dart';
import 'package:deutschtiger/features/vocabulary/presentation/vocabulary_provider.dart';
import 'package:deutschtiger/core/release/release_feature_flags.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('vocabulary detail localizes its chrome at 200% text scale', (
    tester,
  ) async {
    const params = TopicLevelItemsParams(topic: 'alltag', pageSize: 50);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          topicLevelItemsProvider(params).overrideWith(
            (ref) async => CollectionItemsResult(items: [_item, _relatedItem]),
          ),
        ],
        child: MaterialApp(
          locale: const Locale('de'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: const VocabularyDetailScreen(topicKey: 'alltag'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Wortschatz: alltag'), findsOneWidget);
    expect(find.text('Geschlecht'), findsOneWidget);
    expect(find.byTooltip('Karte umdrehen'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Bedeutungen'),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Bedeutungen'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Beispiele'),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Beispiele'), findsOneWidget);
    expect(find.text('Verbkonjugation'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Verwandte Wörter'),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Verwandte Wörter'), findsOneWidget);
    expect(
      find.text('Üben'),
      ReleaseFeatureFlags.games ? findsOneWidget : findsNothing,
    );
    expect(tester.takeException(), isNull);
  });
}

final _item = LearningItem(
  id: 'haus',
  contentDe: 'Haus',
  contentVi: 'nhà',
  level: WordLevel.a1,
  gender: 'das',
  plural: 'Häuser',
  wordType: 'Nomen',
  auxiliary: 'haben',
  meanings: const ['nhà'],
  examples: const [Example(de: 'Das Haus ist groß.', vi: 'Ngôi nhà lớn.')],
  conjugation: const ConjugationInfo(praesens: ['ich gehe']),
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
