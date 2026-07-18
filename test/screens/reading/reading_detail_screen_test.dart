import 'dart:typed_data';

import 'package:deutschtiger/data/reading/reading_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/repositories/reading/reading_repository.dart';
import 'package:deutschtiger/screens/reading/reading_detail_screen.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final key = (level: 'A1', slug: 'im-cafe');

  ReadingRepository fakeRepo() {
    final client = ApiClient(
      baseUrl: 'https://example.test/api/v1',
      tokenProvider: _NoTokenProvider(),
    );
    client.raw.httpClientAdapter = _NoopAdapter();
    return ReadingRepository(client);
  }

  Widget wrap(Widget child, {List<Override> overrides = const []}) {
    return ProviderScope(
      overrides: [
        readingRepositoryProvider.overrideWithValue(fakeRepo()),
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

  const article = ReadingArticle(
    id: 'a1-cafe',
    slug: 'im-cafe',
    level: 'A1',
    title: 'Im Café',
    summary: 'Anna geht ins Café.',
    body: 'Satz eins.\n\nSatz zwei.',
  );

  testWidgets(
    'reading detail shows paragraphs and mark-complete button (happy path)',
    (tester) async {
      await tester.pumpWidget(
        wrap(
          const ReadingDetailScreen(
            level: 'A1',
            slug: 'im-cafe',
            title: 'Im Café',
          ),
          overrides: [
            readingArticleProvider(key).overrideWith((ref) async => article),
            readingCompletedIdsProvider.overrideWith((ref) async => <String>[]),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Satz eins.', findRichText: true), findsOneWidget);
      expect(find.text('Đánh dấu đã đọc'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('reading detail shows "Đã đọc" when article already completed', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const ReadingDetailScreen(
          level: 'A1',
          slug: 'im-cafe',
          title: 'Im Café',
        ),
        overrides: [
          readingArticleProvider(key).overrideWith((ref) async => article),
          readingCompletedIdsProvider.overrideWith((ref) async => ['a1-cafe']),
        ],
      ),
    );
    await tester.pumpAndSettle();

    // "Đã đọc" xuất hiện 2 lần: chip trạng thái dưới level pill + nút mark-
    // complete đã disabled (mirror web — cả hai đều hiện khi bài đã đọc).
    expect(find.text('Đã đọc'), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('reading detail shows retry button on load error', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const ReadingDetailScreen(level: 'A1', slug: 'im-cafe'),
        overrides: [
          readingArticleProvider(
            key,
          ).overrideWith((ref) => Future<ReadingArticle>.error('network down')),
          readingCompletedIdsProvider.overrideWith((ref) async => <String>[]),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(PhosphorIcons.arrowClockwise), findsOneWidget);
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
