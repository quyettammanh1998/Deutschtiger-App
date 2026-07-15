import 'dart:typed_data';

import 'package:deutschtiger/features/vocabulary/data/vocabulary_repository.dart';
import 'package:deutschtiger/features/vocabulary/domain/vocabulary_models.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('fetchPageData parses all vocabulary dashboard sections', () async {
    final fixture = '''{
      "topics":[{"id":"topic-1","key":"christmas","label":"Weihnachten","label_vi":"Giáng sinh","icon":"🎄","created_at":"2026-01-01"}],
      "collections":[{"id":"collection-1","slug":"goethe-a1","name":"Goethe A1","collection_type":"goethe","level":"A1","word_count":10,"created_at":"2026-01-01"}],
      "level_counts":[{"level":"A1","count":4999}],
      "topic_level_counts":[{"topic_id":"topic-1","topic_key":"christmas","label":"Weihnachten","label_vi":"Giáng sinh","level":"A1","count":32,"total_count":76}]
    }''';
    final setup = _repositoryWithResponses([fixture]);

    final data = await setup.repository.fetchPageData();

    expect(data.topics.single.key, 'christmas');
    expect(data.collections.single.level, WordLevel.a1);
    expect(data.levelCounts.single.count, 4999);
    expect(data.topicLevelCounts.single.totalCount, 76);
    expect(setup.adapter.requests.single.path, '/vocabulary-page-data');
  });

  test(
    'topic-level request uses backend query contract and parses details',
    () async {
      final fixture = '''{
      "items":[{
        "id":"machen-1","type":"word","content_de":"machen","content_vi":"làm","level":"A1",
        "audio_url":"https://audio.example/machen.mp3","image_url":"https://img.example/machen.jpg",
        "examples":[{"de":"Was machst du?","vi":"Bạn đang làm gì?"}],
        "meanings":["làm","thực hiện"],"conjugation":{"raw":"machen, macht, machte, hat gemacht"},
        "word_type":"verb","is_separable":false,"sort_order":3
      }],
      "total":1,"page":2,"pageSize":25
    }''';
      final setup = _repositoryWithResponses([fixture]);

      final result = await setup.repository.fetchItemsByTopicLevel(
        topic: 'daily-life',
        level: 'a1',
        page: 2,
        pageSize: 25,
        search: 'machen',
        shuffle: true,
      );

      final request = setup.adapter.requests.single;
      expect(request.path, '/vocabulary/by-topic-level');
      expect(request.queryParameters, containsPair('topic', 'daily-life'));
      expect(request.queryParameters, containsPair('level', 'A1'));
      expect(request.queryParameters, containsPair('pageSize', 25));
      expect(request.queryParameters, containsPair('search', 'machen'));
      expect(request.queryParameters, containsPair('shuffle', true));

      final item = result.items.single;
      expect(result.page, 2);
      expect(result.pageSize, 25);
      expect(item.examples?.single.vi, 'Bạn đang làm gì?');
      expect(item.meanings, ['làm', 'thực hiện']);
      expect(item.conjugation?.raw, 'machen, macht, machte, hat gemacht');
      expect(item.wordType, 'verb');
      expect(item.isSeparable, isFalse);
      expect(item.imageUrl, 'https://img.example/machen.jpg');
    },
  );
}

({VocabularyRepository repository, _QueueAdapter adapter})
_repositoryWithResponses(List<String> responses) {
  final client = ApiClient(
    baseUrl: 'https://example.test/api/v1',
    tokenProvider: _NoTokenProvider(),
  );
  final adapter = _QueueAdapter(responses);
  client.raw.httpClientAdapter = adapter;
  return (repository: VocabularyRepository(client), adapter: adapter);
}

class _NoTokenProvider implements TokenProvider {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> refresh() async => null;
}

class _QueueAdapter implements HttpClientAdapter {
  _QueueAdapter(this._responses);

  final List<String> _responses;
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
      _responses[_index++],
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
