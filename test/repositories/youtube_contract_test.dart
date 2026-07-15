import 'dart:typed_data';

import 'package:deutschtiger/repositories/youtube/youtube_repository.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('fetchPending parses the tracker contract', () async {
    final setup = _setup([
      '[{"id":"v1","video_id":"abc12345678","title":"Folge 1",'
          '"thumbnail_url":"https://img.test/abc.jpg","status":"pending",'
          '"watch_count":0}]',
    ]);
    final repo = YouTubeRepository(
      setup.client,
      supabaseBaseUrl: 'https://supabase.test',
    );

    final videos = await repo.fetchPending();

    expect(videos, hasLength(1));
    expect(videos.single.videoId, 'abc12345678');
    expect(videos.single.isCompleted, isFalse);
    expect(setup.adapter.requests.single.path, '/user/youtube/videos/pending');
  });

  test('fetchStats parses the aggregate stats contract', () async {
    final setup = _setup([
      '{"total_completed":12,"this_week":3,"this_month":8,"today":1,'
          '"max_watch_count":2,"total_rewatches":4}',
    ]);
    final repo = YouTubeRepository(
      setup.client,
      supabaseBaseUrl: 'https://supabase.test',
    );

    final stats = await repo.fetchStats();

    expect(stats.totalCompleted, 12);
    expect(stats.thisWeek, 3);
    expect(setup.adapter.requests.single.path, '/user/youtube/stats');
  });

  test('addVideo posts the youtube_url/video_id/title contract', () async {
    final setup = _setup([
      '{"id":"v1","video_id":"abc12345678","status":"pending"}',
    ]);
    final repo = YouTubeRepository(
      setup.client,
      supabaseBaseUrl: 'https://supabase.test',
    );

    final video = await repo.addVideo(
      youtubeUrl: 'https://www.youtube.com/watch?v=abc12345678',
      videoId: 'abc12345678',
      title: 'Folge 1',
    );

    expect(video.id, 'v1');
    expect(setup.adapter.requests.single.method, 'POST');
    expect(setup.adapter.requests.single.path, '/user/youtube/videos');
    expect(
      setup.adapter.requests.single.data,
      {
        'youtube_url': 'https://www.youtube.com/watch?v=abc12345678',
        'video_id': 'abc12345678',
        'title': 'Folge 1',
        'thumbnail_url': null,
      },
    );
  });

  test('complete PUTs the complete contract with an empty body', () async {
    final setup = _setup(['{"status":"ok"}']);
    final repo = YouTubeRepository(
      setup.client,
      supabaseBaseUrl: 'https://supabase.test',
    );

    await repo.complete('v1');

    expect(setup.adapter.requests.single.method, 'PUT');
    expect(setup.adapter.requests.single.path, '/user/youtube/videos/v1/complete');
  });

  test('fetchLearningPath reads the Supabase Storage learning-path.json', () async {
    final setup = _setup([
      '{"learning_path":[{"order":1,"group_id":"g1","group_name_vi":"Nhóm 1",'
          '"group_name_de":"Gruppe 1","level":"B1","video_count":1,'
          '"videos":[{"video_id":"abc12345678","title":"Video 1","duration_seconds":90}]}]}',
    ]);
    final repo = YouTubeRepository(
      setup.client,
      supabaseBaseUrl: 'https://supabase.test',
    );

    final groups = await repo.fetchLearningPath('sprechen-b1');

    expect(groups, hasLength(1));
    expect(groups.single.groupId, 'g1');
    expect(groups.single.videos.single.videoId, 'abc12345678');
    expect(
      setup.adapter.requests.single.uri.toString(),
      'https://supabase.test/storage/v1/object/public/video-libraries/sprechen-b1/learning-path.json',
    );
  });

  test('fetchGroupProgress parses the library progress contract', () async {
    final setup = _setup([
      '[{"group_id":"g1","total":10,"completed":3,"percentage":30}]',
    ]);
    final repo = YouTubeRepository(
      setup.client,
      supabaseBaseUrl: 'https://supabase.test',
    );

    final progress = await repo.fetchGroupProgress('sprechen-b1');

    expect(progress.single.completed, 3);
    expect(
      setup.adapter.requests.single.path,
      '/user/youtube/library/sprechen-b1/progress',
    );
  });

  test('addGroupVideos batch-upserts the library group videos contract', () async {
    final setup = _setup(['[]']);
    final repo = YouTubeRepository(
      setup.client,
      supabaseBaseUrl: 'https://supabase.test',
    );

    await repo.addGroupVideos('sprechen-b1', 'g1', const []);

    // Empty input short-circuits without a request.
    expect(setup.adapter.requests, isEmpty);
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
