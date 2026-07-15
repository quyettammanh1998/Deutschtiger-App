import 'dart:typed_data';

import 'package:deutschtiger/repositories/news/news_repository.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'fetchList uses GET /news/list?page=&pageSize=&topic=&level= and parses the page',
    () async {
      final setup = _setup([
        '{"stories":[{"story_group_id":"g1","slug":"eu-gipfel-a1","topic":"politik",'
            '"title":"EU-Gipfel","summary":"s","level":"A1",'
            '"levels_available":["A1","A2"],"image_url":"https://x/img.jpg",'
            '"audio_url":"https://x/a.mp3","published_at":"2026-07-10T00:00:00Z"}],'
            '"total":1,"page":1,"page_size":10}',
      ]);
      final repo = NewsRepository(setup.client);

      final result = await repo.fetchList(topic: 'politik', level: 'A1');

      expect(result.stories.single.storyGroupId, 'g1');
      expect(result.stories.single.levelsAvailable, ['A1', 'A2']);
      expect(result.total, 1);
      expect(setup.adapter.requests.single.path, '/news/list');
      expect(setup.adapter.requests.single.queryParameters['topic'], 'politik');
      expect(setup.adapter.requests.single.queryParameters['level'], 'A1');
      expect(setup.adapter.requests.single.queryParameters['pageSize'], 10);
    },
  );

  test('fetchTopics uses GET /news/topics and parses counts', () async {
    final setup = _setup(['{"topics":{"politik":5,"sport":2}}']);
    final repo = NewsRepository(setup.client);

    final topics = await repo.fetchTopics();

    expect(topics, {'politik': 5, 'sport': 2});
    expect(setup.adapter.requests.single.path, '/news/topics');
  });

  test(
    'fetchStoryBySlug uses GET /news/story-by-slug/{slug} and parses levels',
    () async {
      final setup = _setup([
        '{"levels":[{"id":"a1-id","story_group_id":"g1","slug":"eu-gipfel-a1",'
            '"topic":"politik","level":"a1","title":"EU-Gipfel","summary":"s",'
            '"body":"Satz eins.\\n\\nSatz zwei.","vocab":[{"word_de":"Gipfel",'
            '"meaning_vi":"hội nghị","example_de":"Der Gipfel war lang."}],'
            '"quiz":[{"question":"q?","options":["a","b"],"correct":1,'
            '"explanation_vi":"vì b đúng"}],"sentences":[{"de":"Satz eins.",'
            '"vi":"Câu một."}]}]}',
      ]);
      final repo = NewsRepository(setup.client);

      final levels = await repo.fetchStoryBySlug('eu-gipfel-a1');

      expect(levels.single.level, 'A1');
      expect(levels.single.vocab.single.wordDe, 'Gipfel');
      expect(levels.single.quiz.single.correct, 1);
      expect(levels.single.sentences.single.vi, 'Câu một.');
      expect(levels.single.paragraphs, ['Satz eins.', 'Satz zwei.']);
      expect(
        setup.adapter.requests.single.path,
        '/news/story-by-slug/eu-gipfel-a1',
      );
    },
  );

  test(
    'fetchCompletedIds reads story_group_ids and swallows API errors',
    () async {
      final setup = _setup(['{"story_group_ids":["g1","g2"]}']);
      final repo = NewsRepository(setup.client);

      final ids = await repo.fetchCompletedIds();

      expect(ids, ['g1', 'g2']);
      expect(setup.adapter.requests.single.path, '/user/news-progress');
    },
  );

  test('fetchCompletedIds returns empty list on API failure', () async {
    final client = ApiClient(
      baseUrl: 'https://example.test/api/v1',
      tokenProvider: _NoTokenProvider(),
    );
    client.raw.httpClientAdapter = _FailingAdapter();
    final repo = NewsRepository(client);

    final ids = await repo.fetchCompletedIds();

    expect(ids, isEmpty);
  });

  test(
    'markComplete posts story_group_id and score_pct to /user/news-progress',
    () async {
      final setup = _setup(['{"status":"ok"}']);
      final repo = NewsRepository(setup.client);

      await repo.markComplete(storyGroupId: 'g1', scorePct: 80);

      final request = setup.adapter.requests.single;
      expect(request.method, 'POST');
      expect(request.path, '/user/news-progress');
      expect(request.data, {'story_group_id': 'g1', 'score_pct': 80});
    },
  );

  test('markComplete swallows API failure (best-effort)', () async {
    final client = ApiClient(
      baseUrl: 'https://example.test/api/v1',
      tokenProvider: _NoTokenProvider(),
    );
    client.raw.httpClientAdapter = _FailingAdapter();
    final repo = NewsRepository(client);

    await repo.markComplete(storyGroupId: 'g1', scorePct: 80);
    // No exception → best-effort contract holds.
  });

  test(
    'fetchWeekStats uses GET /user/news-week-stats and returns null on failure',
    () async {
      final setup = _setup(
        ['{"published_this_week":4,"my_completed_this_week":2}'],
      );
      final repo = NewsRepository(setup.client);

      final stats = await repo.fetchWeekStats();

      expect(stats?.publishedThisWeek, 4);
      expect(stats?.myCompletedThisWeek, 2);
      expect(setup.adapter.requests.single.path, '/user/news-week-stats');

      final failingClient = ApiClient(
        baseUrl: 'https://example.test/api/v1',
        tokenProvider: _NoTokenProvider(),
      );
      failingClient.raw.httpClientAdapter = _FailingAdapter();
      final failingRepo = NewsRepository(failingClient);
      expect(await failingRepo.fetchWeekStats(), isNull);
    },
  );
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
