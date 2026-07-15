import 'dart:typed_data';

import 'package:deutschtiger/data/news/news_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/repositories/news/news_repository.dart';
import 'package:deutschtiger/screens/news/news_detail_screen.dart';
import 'package:deutschtiger/screens/news/news_list_screen.dart'
    show newsCompletedIdsProvider;
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  NewsRepository fakeRepo() {
    final client = ApiClient(
      baseUrl: 'https://example.test/api/v1',
      tokenProvider: _NoTokenProvider(),
    );
    client.raw.httpClientAdapter = _NoopAdapter();
    return NewsRepository(client);
  }

  Widget wrap(Widget child, {List<Override> overrides = const []}) {
    return ProviderScope(
      overrides: [
        newsRepositoryProvider.overrideWithValue(fakeRepo()),
        ...overrides,
      ],
      child: MaterialApp(
        locale: const Locale('vi'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: child,
      ),
    );
  }

  const article = NewsLevelArticle(
    id: 'a1-id',
    storyGroupId: 'g1',
    slug: 'eu-gipfel-a1',
    topic: 'politik',
    level: 'A1',
    title: 'EU-Gipfel',
    summary: 'Die EU trifft sich.',
    body: 'Satz eins.\n\nSatz zwei.',
  );

  testWidgets('news detail shows body paragraphs (happy path)', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const NewsDetailScreen(slug: 'eu-gipfel-a1'),
        overrides: [
          newsStoryProvider(
            'eu-gipfel-a1',
          ).overrideWith((ref) async => const [article]),
          newsCompletedIdsProvider.overrideWith((ref) async => <String>[]),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('EU-Gipfel'), findsOneWidget);
    expect(find.text('Satz eins.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('news detail shows not-found message when levels are empty', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const NewsDetailScreen(slug: 'missing'),
        overrides: [
          newsStoryProvider(
            'missing',
          ).overrideWith((ref) async => const <NewsLevelArticle>[]),
          newsCompletedIdsProvider.overrideWith((ref) async => <String>[]),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Không tìm thấy tin tức.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('news detail shows retry button on load error', (tester) async {
    await tester.pumpWidget(
      wrap(
        const NewsDetailScreen(slug: 'eu-gipfel-a1'),
        overrides: [
          newsStoryProvider('eu-gipfel-a1').overrideWith(
            (ref) => Future<List<NewsLevelArticle>>.error('network down'),
          ),
          newsCompletedIdsProvider.overrideWith((ref) async => <String>[]),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.refresh), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('news detail shows level switcher when multiple levels exist', (
    tester,
  ) async {
    const articleB1 = NewsLevelArticle(
      id: 'b1-id',
      storyGroupId: 'g1',
      slug: 'eu-gipfel-b1',
      topic: 'politik',
      level: 'B1',
      title: 'EU-Gipfel (B1)',
      summary: 's',
      body: 'Ein anderer Text.',
    );
    await tester.pumpWidget(
      wrap(
        const NewsDetailScreen(slug: 'eu-gipfel-a1'),
        overrides: [
          newsStoryProvider(
            'eu-gipfel-a1',
          ).overrideWith((ref) async => const [article, articleB1]),
          newsCompletedIdsProvider.overrideWith((ref) async => <String>[]),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ChoiceChip, 'A1'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, 'B1'), findsOneWidget);
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
