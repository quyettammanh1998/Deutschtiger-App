import 'package:deutschtiger/features/vocabulary/domain/vocabulary_models.dart';
import 'package:deutschtiger/features/vocabulary/presentation/vocabulary_lesson_screen.dart';
import 'package:deutschtiger/features/vocabulary/presentation/vocabulary_provider.dart';
import 'package:deutschtiger/features/vocabulary/presentation/vocabulary_word_screen.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('vocabulary lesson chrome localizes at 200% text scale', (
    tester,
  ) async {
    const params = TopicLevelItemsParams(topic: 'alltag', pageSize: 100);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          topicLevelItemsProvider(
            params,
          ).overrideWith((ref) async => CollectionItemsResult(items: [_item])),
        ],
        child: _localizedApp(
          child: const VocabularyLessonScreen(topicKey: 'alltag'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Wortschatz: alltag'), findsOneWidget);
    expect(find.text('Im Unterricht suchen…'), findsOneWidget);
    expect(find.text('Alle'), findsOneWidget);
    expect(find.text('Fortschritt: 0 / 1 Wörter'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('vocabulary word chrome and navigation localize at 200%', (
    tester,
  ) async {
    await tester.pumpWidget(
      _localizedApp(
        child: VocabularyWordScreen(
          item: _item,
          items: [_item, _secondItem],
          onOpenDetail: (_) {},
        ),
      ),
    );

    expect(find.text('Bedeutungen'), findsOneWidget);
    expect(find.text('Beispiele'), findsOneWidget);
    expect(find.text('Zurück'), findsOneWidget);
    expect(find.text('Weiter'), findsOneWidget);
    expect(find.byTooltip('Details anzeigen'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Widget _localizedApp({required Widget child}) => MaterialApp(
  locale: const Locale('de'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  home: MediaQuery(
    data: const MediaQueryData(textScaler: TextScaler.linear(2)),
    child: child,
  ),
);

final _item = LearningItem(
  id: 'haus',
  contentDe: 'Haus',
  contentVi: 'nhà',
  meanings: const ['nhà'],
  examples: const [Example(de: 'Das Haus ist groß.', vi: 'Ngôi nhà lớn.')],
  createdAt: '2026-01-01T00:00:00Z',
  updatedAt: '2026-01-01T00:00:00Z',
);

final _secondItem = LearningItem(
  id: 'baum',
  contentDe: 'Baum',
  contentVi: 'cây',
  createdAt: '2026-01-01T00:00:00Z',
  updatedAt: '2026-01-01T00:00:00Z',
);
