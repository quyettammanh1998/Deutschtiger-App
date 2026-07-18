import 'dart:typed_data';

import 'package:deutschtiger/data/news/news_models.dart';
import 'package:deutschtiger/data/reading/reading_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/repositories/reading/reading_repository.dart';
import 'package:deutschtiger/screens/news/news_detail_screen.dart';
import 'package:deutschtiger/screens/news/news_list_screen.dart';
import 'package:deutschtiger/screens/reading/read_listen_hub_screen.dart';
import 'package:deutschtiger/screens/reading/reading_detail_screen.dart';
import 'package:deutschtiger/screens/reading/reading_feed_screen.dart';
import 'package:deutschtiger/screens/reading/reading_hub_screen.dart'
    hide readingCompletedIdsProvider;
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:deutschtiger/view_models/listening/easy_german_provider.dart';
import 'package:deutschtiger/view_models/listening/podcast_provider.dart';
import 'package:deutschtiger/view_models/youtube/youtube_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// German 200% text-scale reflow smoke test for the reading/news/read-listen
/// screens — plan protocol requires new UI to not overflow at German 200%.
/// Mirrors `test/screens/journey/course_german_200_percent_test.dart` and
/// `test/screens/listening/listening_german_200_percent_test.dart`.
void main() {
  const readingArticle = ReadingArticleSummary(
    id: 'a1-cafe',
    slug: 'im-cafe',
    sourceUrl: 'https://x',
    sourceSite: 'fluencydrop',
    topic: 'Alltag',
    level: 'A1',
    title: 'Im Café mit Freunden bestellen und bezahlen',
    summary: 'Anna geht ins Café mit ihren Freunden.',
  );

  const newsStory = NewsStorySummary(
    storyGroupId: 'g1',
    slug: 'eu-gipfel-a1',
    topic: 'politik',
    title: 'EU-Gipfel bringt neue Entscheidungen für Europa',
    summary: 'Die EU trifft sich zu wichtigen Verhandlungen.',
    level: 'A1',
    levelsAvailable: ['A1', 'A2'],
  );

  ReadingRepository fakeReadingRepo() {
    final client = ApiClient(
      baseUrl: 'https://example.test/api/v1',
      tokenProvider: _NoTokenProvider(),
    );
    client.raw.httpClientAdapter = _NoopAdapter();
    return ReadingRepository(client);
  }

  Widget wrap(Widget child, List<Override> overrides) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        locale: const Locale('de'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(390, 844),
            textScaler: TextScaler.linear(2),
          ),
          child: child,
        ),
      ),
    );
  }

  void setPhysicalSize(WidgetTester tester) {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('reading hub reflows at German 200% without overflow', (
    tester,
  ) async {
    setPhysicalSize(tester);
    await tester.pumpWidget(
      wrap(const ReadingHubScreen(), [
        readingArticlesProvider.overrideWith((ref) async => [readingArticle]),
      ]),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('reading detail reflows at German 200% without overflow', (
    tester,
  ) async {
    setPhysicalSize(tester);
    await tester.pumpWidget(
      wrap(const ReadingDetailScreen(level: 'a1', slug: 'im-cafe'), [
        readingRepositoryProvider.overrideWithValue(fakeReadingRepo()),
        readingArticleProvider((level: 'a1', slug: 'im-cafe')).overrideWith(
          (ref) async => const ReadingArticle(
            id: 'a1-cafe',
            level: 'A1',
            slug: 'im-cafe',
            title: 'Im Café mit Freunden bestellen und bezahlen',
            summary: 'Anna geht ins Café mit ihren Freunden.',
            body: 'Anna geht ins Café.',
            bodyVi: 'Anna đi đến quán cà phê.',
          ),
        ),
        readingCompletedIdsProvider.overrideWith((ref) async => const []),
      ]),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('reading feed reflows at German 200% without overflow', (
    tester,
  ) async {
    setPhysicalSize(tester);
    await tester.pumpWidget(
      wrap(const ReadingFeedScreen(), [
        readingFeedProvider('').overrideWith(
          (ref) async =>
              const ReadingFeedResult(articles: [], coverageReady: true),
        ),
      ]),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('read-listen hub reflows at German 200% without overflow', (
    tester,
  ) async {
    setPhysicalSize(tester);
    await tester.pumpWidget(
      wrap(const ReadListenHubScreen(), [
        readingFeedProvider('').overrideWith(
          (ref) async =>
              const ReadingFeedResult(articles: [], coverageReady: true),
        ),
        for (final level in const ['a1', 'a2', 'b1', 'b2', 'c1'])
          easyGermanIndexProvider(level).overrideWith((ref) async => const []),
        podcastIndexProvider.overrideWith((ref) async => const []),
        pendingVideosProvider.overrideWith((ref) async => const []),
        completedVideosProvider.overrideWith((ref) async => const []),
      ]),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('news list reflows at German 200% without overflow', (
    tester,
  ) async {
    setPhysicalSize(tester);
    const key = (page: 1, topic: null, level: null);
    await tester.pumpWidget(
      wrap(const NewsListScreen(), [
        newsListProvider(key).overrideWith(
          (ref) async => const NewsListResult(
            stories: [newsStory],
            total: 1,
            page: 1,
            pageSize: 10,
          ),
        ),
        newsTopicsProvider.overrideWith((ref) async => <String, int>{}),
        newsCompletedIdsProvider.overrideWith((ref) async => const []),
        newsWeekStatsProvider.overrideWith(
          (ref) async =>
              const NewsWeekStats(publishedThisWeek: 4, myCompletedThisWeek: 2),
        ),
      ]),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('news detail reflows at German 200% without overflow', (
    tester,
  ) async {
    setPhysicalSize(tester);
    await tester.pumpWidget(
      wrap(const NewsDetailScreen(slug: 'eu-gipfel-a1'), [
        newsStoryProvider('eu-gipfel-a1').overrideWith(
          (ref) async => const [
            NewsLevelArticle(
              id: 'na1',
              storyGroupId: 'g1',
              slug: 'eu-gipfel-a1',
              topic: 'politik',
              level: 'A1',
              title: 'EU-Gipfel bringt neue Entscheidungen für Europa',
              summary: 'Die EU trifft sich zu wichtigen Verhandlungen.',
              body: 'Die EU trifft sich zu wichtigen Verhandlungen.',
            ),
          ],
        ),
      ]),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}

class _NoTokenProvider implements TokenProvider {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> refresh() async => null;
}

class _NoopAdapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    throw DioException(requestOptions: options, error: 'not used in this test');
  }

  @override
  void close({bool force = false}) {}
}
