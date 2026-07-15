import 'package:deutschtiger/data/news/news_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/news/news_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const initialKey = (page: 1, topic: null, level: null);

  Widget wrap(Widget child, {List<Override> overrides = const []}) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        locale: const Locale('vi'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: child,
      ),
    );
  }

  const story = NewsStorySummary(
    storyGroupId: 'g1',
    slug: 'eu-gipfel-a1',
    topic: 'politik',
    title: 'EU-Gipfel',
    summary: 'Die EU trifft sich.',
    level: 'A1',
    levelsAvailable: ['A1', 'A2'],
  );

  testWidgets('news list shows stories (happy path)', (tester) async {
    await tester.pumpWidget(
      wrap(
        const NewsListScreen(),
        overrides: [
          newsListProvider(
            initialKey,
          ).overrideWith(
            (ref) async =>
                const NewsListResult(stories: [story], total: 1, page: 1, pageSize: 10),
          ),
          newsTopicsProvider.overrideWith((ref) async => <String, int>{}),
          newsCompletedIdsProvider.overrideWith((ref) async => <String>[]),
          newsWeekStatsProvider.overrideWith((ref) async => null),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('EU-Gipfel'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('news list shows empty state when no stories', (tester) async {
    await tester.pumpWidget(
      wrap(
        const NewsListScreen(),
        overrides: [
          newsListProvider(initialKey).overrideWith(
            (ref) async => const NewsListResult(
              stories: [],
              total: 0,
              page: 1,
              pageSize: 10,
            ),
          ),
          newsTopicsProvider.overrideWith((ref) async => <String, int>{}),
          newsCompletedIdsProvider.overrideWith((ref) async => <String>[]),
          newsWeekStatsProvider.overrideWith((ref) async => null),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Chưa có tin tức.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('news list shows retry button on load error', (tester) async {
    await tester.pumpWidget(
      wrap(
        const NewsListScreen(),
        overrides: [
          newsListProvider(initialKey).overrideWith(
            (ref) => Future<NewsListResult>.error('network down'),
          ),
          newsTopicsProvider.overrideWith((ref) async => <String, int>{}),
          newsCompletedIdsProvider.overrideWith((ref) async => <String>[]),
          newsWeekStatsProvider.overrideWith((ref) async => null),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.refresh), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('news list shows weekly ring when week stats present', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const NewsListScreen(),
        overrides: [
          newsListProvider(initialKey).overrideWith(
            (ref) async => const NewsListResult(
              stories: [story],
              total: 1,
              page: 1,
              pageSize: 10,
            ),
          ),
          newsTopicsProvider.overrideWith((ref) async => <String, int>{}),
          newsCompletedIdsProvider.overrideWith((ref) async => <String>[]),
          newsWeekStatsProvider.overrideWith(
            (ref) async =>
                const NewsWeekStats(publishedThisWeek: 4, myCompletedThisWeek: 2),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('2/4 bài'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
