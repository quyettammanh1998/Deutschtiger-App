import 'package:deutschtiger/features/vocabulary/data/vocab_lesson_models.dart';
import 'package:deutschtiger/features/vocabulary/data/vocab_lesson_utils.dart';
import 'package:deutschtiger/features/vocabulary/domain/vocabulary_models.dart';
import 'package:deutschtiger/features/vocabulary/presentation/vocab_lesson_provider.dart';
import 'package:deutschtiger/features/vocabulary/presentation/vocabulary_lesson_screen.dart';
import 'package:deutschtiger/features/vocabulary/presentation/vocabulary_provider.dart';
import 'package:deutschtiger/features/vocabulary/presentation/vocabulary_word_screen.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('vocabulary lesson mode-select renders and localizes at 200% text scale', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          vocabularyTopicsProvider.overrideWith((ref) async => const <VocabularyTopic>[]),
        ],
        child: _localizedApp(
          child: const VocabularyLessonScreen(topicKey: 'alltag'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Nhanh'), findsOneWidget);
    expect(find.text('Đầy đủ'), findsOneWidget);
    expect(find.text('Chuyên sâu'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('picking a mode loads the SRS batch and renders the empty state without exceptions', (
    tester,
  ) async {
    const params = VocabLessonBatchParams(topicKey: 'alltag', mode: VocabLessonMode.standard);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          vocabularyTopicsProvider.overrideWith((ref) async => const <VocabularyTopic>[]),
          vocabLessonBatchProvider(
            params,
          ).overrideWith((ref) async => const LessonBatch(cards: [], degenerate: true, reason: 'empty_collection')),
        ],
        child: _localizedApp(
          child: const VocabularyLessonScreen(topicKey: 'alltag'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Đầy đủ'));
    await tester.pumpAndSettle();

    expect(find.text('Chưa có từ để học'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('vocabulary word chrome and navigation localize at 200%', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: _localizedApp(
          child: VocabularyWordScreen(
            item: _item,
            items: [_item, _secondItem],
            onOpenDetail: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Haus'), findsOneWidget);
    expect(find.text('Trước'), findsOneWidget);
    expect(find.text('Tiếp theo'), findsOneWidget);
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
