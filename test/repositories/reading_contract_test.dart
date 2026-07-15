import 'dart:typed_data';

import 'package:deutschtiger/data/reading/reading_models.dart';
import 'package:deutschtiger/repositories/reading/reading_repository.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'fetchArticlesByLevel uses GET /reading/articles?level=&limit= and parses the articles array',
    () async {
      final setup = _setup([
        '{"articles":[{"id":"a1-cafe","slug":"im-cafe","source_url":"https://x",'
            '"source_site":"fluencydrop","topic":"Alltag","level":"a1",'
            '"title":"Im Café","summary":"Anna geht ins Café."}],"total":1}',
      ]);
      final repo = ReadingRepository(setup.client);

      final articles = await repo.fetchArticlesByLevel(level: 'A1');

      expect(articles.single.id, 'a1-cafe');
      expect(articles.single.slug, 'im-cafe');
      expect(articles.single.level, 'A1');
      expect(setup.adapter.requests.single.path, '/reading/articles');
      expect(setup.adapter.requests.single.queryParameters['level'], 'A1');
      expect(setup.adapter.requests.single.queryParameters['limit'], 300);
    },
  );

  test(
    'fetchArticle uses GET /reading/articles/{level}/{slug} and splits paragraphs',
    () async {
      final setup = _setup([
        '{"article":{"id":"a1-cafe","slug":"im-cafe","level":"A1",'
            '"title":"Im Café","summary":"s","body":"Satz eins.\\n\\nSatz zwei.",'
            '"body_vi":"Câu một.\\n\\nCâu hai.","glossary":["Café — quán cà phê"],'
            '"audio_url":"/api/v1/reading/audio/A1/im-cafe.mp3"}}',
      ]);
      final repo = ReadingRepository(setup.client);

      final article = await repo.fetchArticle(level: 'A1', slug: 'im-cafe');

      expect(article.id, 'a1-cafe');
      expect(article.paragraphs, hasLength(2));
      expect(article.paragraphs.first.de, 'Satz eins.');
      expect(article.paragraphs.first.vi, 'Câu một.');
      expect(article.glossary, ['Café — quán cà phê']);
      expect(setup.adapter.requests.single.path, '/reading/articles/A1/im-cafe');
    },
  );

  test(
    'fetchArticle falls back to no translation when paragraph counts mismatch',
    () async {
      final setup = _setup([
        '{"article":{"id":"a1-cafe","slug":"im-cafe","level":"A1","title":"t",'
            '"summary":"s","body":"Satz eins.\\n\\nSatz zwei.",'
            '"body_vi":"Chỉ một đoạn."}}',
      ]);
      final repo = ReadingRepository(setup.client);

      final article = await repo.fetchArticle(level: 'A1', slug: 'im-cafe');

      expect(article.paragraphs, hasLength(2));
      expect(article.paragraphs.every((p) => p.vi.isEmpty), isTrue);
    },
  );

  test(
    'fetchCompletedIds reads article_ids and swallows API errors',
    () async {
      final setup = _setup(['{"article_ids":["a1-cafe","a1-familie"]}']);
      final repo = ReadingRepository(setup.client);

      final ids = await repo.fetchCompletedIds();

      expect(ids, ['a1-cafe', 'a1-familie']);
      expect(setup.adapter.requests.single.path, '/user/reading-progress');
    },
  );

  test('fetchCompletedIds returns empty list on API failure', () async {
    final client = ApiClient(
      baseUrl: 'https://example.test/api/v1',
      tokenProvider: _NoTokenProvider(),
    );
    client.raw.httpClientAdapter = _FailingAdapter();
    final repo = ReadingRepository(client);

    final ids = await repo.fetchCompletedIds();

    expect(ids, isEmpty);
  });

  test(
    'markComplete posts article_id, level and optional score to /user/reading-progress',
    () async {
      final setup = _setup(['{"status":"ok"}']);
      final repo = ReadingRepository(setup.client);

      await repo.markComplete(articleId: 'a1-cafe', level: 'A1', score: 80);

      final request = setup.adapter.requests.single;
      expect(request.method, 'POST');
      expect(request.path, '/user/reading-progress');
      expect(request.data, {'article_id': 'a1-cafe', 'level': 'A1', 'score': 80});
    },
  );

  test(
    'fetchFeed uses GET /reading-feed?levels=&limit= and parses coverage_ready wrapper',
    () async {
      final setup = _setup([
        '{"articles":[{"id":"a1-cafe","slug":"im-cafe","title":"Im Café",'
            '"level":"A1","topic":"Alltag","summary":"s","vocab_total":10,'
            '"vocab_known":8,"vocab_new":2,"coverage":0.8,"fit":"ideal"}],'
            '"coverage_ready":true}',
      ]);
      final repo = ReadingRepository(setup.client);

      final result = await repo.fetchFeed(levels: 'A1,A2');

      expect(result.coverageReady, isTrue);
      expect(result.articles.single.fit, ReadingFeedFit.ideal);
      expect(setup.adapter.requests.single.path, '/reading-feed');
      expect(setup.adapter.requests.single.queryParameters['levels'], 'A1,A2');
    },
  );

  test('fetchFeed tolerates the legacy bare-array response', () async {
    final setup = _setup([
      '[{"id":"a1-cafe","slug":"im-cafe","title":"Im Café","level":"A1",'
          '"topic":"Alltag","summary":"s","vocab_total":10,"vocab_known":8,'
          '"vocab_new":2,"coverage":0.8,"fit":"ideal"}]',
    ]);
    final repo = ReadingRepository(setup.client);

    final result = await repo.fetchFeed();

    expect(result.coverageReady, isTrue);
    expect(result.articles.single.id, 'a1-cafe');
  });

  test('resolveAudioUrl joins a relative path with the API host', () {
    final client = ApiClient(
      baseUrl: 'https://example.test/api/v1',
      tokenProvider: _NoTokenProvider(),
    );
    final repo = ReadingRepository(client);

    expect(
      repo.resolveAudioUrl('/api/v1/reading/audio/A1/im-cafe.mp3'),
      'https://example.test/api/v1/reading/audio/A1/im-cafe.mp3',
    );
    expect(repo.resolveAudioUrl(null), isNull);
    expect(repo.resolveAudioUrl(''), isNull);
    expect(
      repo.resolveAudioUrl('https://cdn.test/a.mp3'),
      'https://cdn.test/a.mp3',
    );
  });
}

({ApiClient client, _QueueAdapter adapter}) _setup(List<String> responses) {
  final client = ApiClient(
    baseUrl: 'https://example.test/api/v1',
    tokenProvider: _NoTokenProvider(),
  );
  final adapter = _QueueAdapter(responses);
  client.raw.httpClientAdapter = adapter;
  return (client: client, adapter: adapter);
}

class _NoTokenProvider implements TokenProvider {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> refresh() async => null;
}

class _QueueAdapter implements HttpClientAdapter {
  _QueueAdapter(this.responses);

  final List<String> responses;
  final List<RequestOptions> requests = [];
  var _index = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      responses[_index++],
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class _FailingAdapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    throw DioException(requestOptions: options, error: 'network down');
  }

  @override
  void close({bool force = false}) {}
}
