import 'dart:typed_data';

import 'package:deutschtiger/repositories/listening/podcast_repository.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'fetchIndex loads the static Easy German podcast index JSON',
    () async {
      final setup = _setup([
        '[{"slug":"ep-1","title":"Folge 1","duration":120,"segments":8}]',
      ]);
      final repo = PodcastRepository(setup.client, 'https://static.test');

      final episodes = await repo.fetchIndex();

      expect(episodes, hasLength(1));
      expect(episodes.single.slug, 'ep-1');
      expect(episodes.single.duration, 120);
      expect(
        setup.adapter.requests.single.uri.toString(),
        'https://static.test/data/listening/podcast/easy_german/index.json',
      );
    },
  );

  test(
    'fetchEpisode loads the static per-episode JSON with sentences',
    () async {
      final setup = _setup([
        '{"slug":"ep-1","title":"Folge 1","mp3_url":"https://cdn.test/ep-1.mp3",'
            '"duration":120,"sentences":[{"text":"Hallo","text_vi":"Xin chào",'
            '"start":0,"end":1.5,"words":[{"w":"Hallo","s":0,"e":0.8}]}]}',
      ]);
      final repo = PodcastRepository(setup.client, 'https://static.test');

      final episode = await repo.fetchEpisode('ep-1');

      expect(episode.mp3Url, 'https://cdn.test/ep-1.mp3');
      expect(episode.sentences, hasLength(1));
      expect(episode.sentences.single.textVi, 'Xin chào');
      expect(episode.sentences.single.words.single.text, 'Hallo');
      expect(
        setup.adapter.requests.single.uri.toString(),
        'https://static.test/data/listening/podcast/easy_german/ep-1.json',
      );
    },
  );

  test('audioUrl builds the public backend audio route', () {
    final setup = _setup([]);
    final repo = PodcastRepository(setup.client, 'https://static.test');

    expect(
      repo.audioUrl('ep 1'),
      'https://example.test/api/v1/listening/podcast/easy_german/audio/ep%201',
    );
  });

  test(
    'fetchCompletedEpisodeIds unwraps episode_ids and swallows API errors',
    () async {
      final setup = _setup(['{"episode_ids":["ep-1","ep-2"]}']);
      final repo = PodcastRepository(setup.client, 'https://static.test');

      final ids = await repo.fetchCompletedEpisodeIds();

      expect(ids, ['ep-1', 'ep-2']);
      expect(setup.adapter.requests.single.path, '/user/podcast-progress');
    },
  );

  test('markComplete posts episode_id to the progress contract', () async {
    final setup = _setup(['{"status":"ok"}']);
    final repo = PodcastRepository(setup.client, 'https://static.test');

    await repo.markComplete('ep-1');

    expect(setup.adapter.requests.single.method, 'POST');
    expect(setup.adapter.requests.single.path, '/user/podcast-progress');
    expect(setup.adapter.requests.single.data, {'episode_id': 'ep-1'});
  });

  test('fetchLeaderboard applies the limit query and parses entries', () async {
    final setup = _setup([
      '[{"user_id":"u1","display_name":"Mai","avatar_url":"","completed_count":5,"rank":1}]',
    ]);
    final repo = PodcastRepository(setup.client, 'https://static.test');

    final entries = await repo.fetchLeaderboard(limit: 5);

    expect(entries.single.displayName, 'Mai');
    expect(setup.adapter.requests.single.path, '/podcast-leaderboard');
    expect(setup.adapter.requests.single.queryParameters, {'limit': 5});
  });

  test('fetchUserRank returns null on empty/error response', () async {
    final setup = _setup(['{}']);
    final repo = PodcastRepository(setup.client, 'https://static.test');

    final rank = await repo.fetchUserRank();

    expect(rank, isNull);
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
