import 'package:deutschtiger/data/vocab/subtitle_word.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/repositories/vocab/subtitle_words_repository.dart';
import 'package:deutschtiger/screens/vocab/subtitle_words_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpScreen(
    WidgetTester tester, {
    required AsyncValue<List<SubtitleWord>> words,
    _FakeSubtitleWordsRepository? repository,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          subtitleWordsProvider.overrideWith((ref) {
            return switch (words) {
              AsyncData(:final value) => Future.value(value),
              AsyncError(:final error) => Future<List<SubtitleWord>>.error(error),
              _ => Future<List<SubtitleWord>>.delayed(const Duration(days: 1)),
            };
          }),
          if (repository != null)
            subtitleWordsRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const SubtitleWordsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows empty state when there are no subtitle words', (tester) async {
    await pumpScreen(tester, words: const AsyncData([]));

    expect(
      find.text('No new words from subtitles yet. Watch videos with subtitles to collect words here.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows a retry action on error', (tester) async {
    await pumpScreen(tester, words: AsyncError(Exception('network'), StackTrace.empty));

    expect(find.text('Retry'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('happy path: selecting a word and saving calls addWords', (tester) async {
    final repo = _FakeSubtitleWordsRepository();
    await pumpScreen(
      tester,
      words: AsyncData([
        const SubtitleWord(
          learningItemId: 'li-1',
          contentDe: 'Haus',
          contentVi: 'nhà',
          seenCount: 3,
        ),
      ]),
      repository: repo,
    );

    expect(find.text('Haus'), findsOneWidget);

    await tester.tap(find.byKey(const Key('subtitle_word_li-1')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add 1 to review'));
    await tester.pumpAndSettle();

    expect(repo.addedIds, [
      ['li-1'],
    ]);
    expect(find.text('Added 1 words to your review queue'), findsOneWidget);
  });
}

class _FakeSubtitleWordsRepository implements SubtitleWordsRepository {
  final addedIds = <List<String>>[];

  @override
  Future<AddSubtitleWordsResult> addWords(List<String> learningItemIds) async {
    addedIds.add(learningItemIds);
    return AddSubtitleWordsResult(added: learningItemIds.length);
  }

  @override
  Future<Map<String, int>> getCounts({int minSeen = 2}) async => {};

  @override
  Future<List<SubtitleWord>> getWords({List<String>? levels, int minSeen = 2, int limit = 50}) async => [];
}
