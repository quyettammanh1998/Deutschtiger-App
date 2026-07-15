import 'dart:typed_data';

import 'package:deutschtiger/repositories/grammar/grammar_repository.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'fetchLessonIndex uses the public GET /grammar index contract',
    () async {
      final setup = _setup([
        (
          body: '[{"id":"abc","title":"Akkusativ","level":"A1","tag":["Cases"]}]',
          contentType: 'application/json',
        ),
      ]);
      final repo = GrammarRepository(setup.client, 'https://static.test');

      final lessons = await repo.fetchLessonIndex(level: 'A1');

      expect(lessons.single.id, 'abc');
      expect(lessons.single.title, 'Akkusativ');
      expect(lessons.single.level, 'A1');
      expect(setup.adapter.requests.single.path, '/grammar');
      expect(
        setup.adapter.requests.single.queryParameters['level'],
        'A1',
      );
    },
  );

  test(
    'fetchLesson uses GET /grammar/{level}/{id} and parses content blocks',
    () async {
      final setup = _setup([
        (
          body:
              '{"_id":"abc","title":"Akkusativ","level":"a1","tag":["Cases"],'
              '"contents":[{"text":"Hallo"},{"arr_1":["a","b"]},'
              '{"exercises":[{"question":"q","answer":"a"}]}],'
              '"related":["def"]}',
          contentType: 'application/json',
        ),
      ]);
      final repo = GrammarRepository(setup.client, 'https://static.test');

      final lesson = await repo.fetchLesson('A1', 'abc');

      expect(lesson.id, 'abc');
      expect(lesson.level, 'A1');
      expect(lesson.contents, hasLength(3));
      expect(lesson.related, ['def']);
      expect(setup.adapter.requests.single.path, '/grammar/a1/abc');
    },
  );

  test(
    'fetchArticleIndex reads the static articles/index.json asset',
    () async {
      final setup = _setup([
        (
          body: '{"a1":[{"title":"Bai 1","level":"A1","slug":"bai-1"}]}',
          contentType: 'application/json',
        ),
      ]);
      final repo = GrammarRepository(setup.client, 'https://static.test');

      final index = await repo.fetchArticleIndex();

      expect(index['a1']!.single.slug, 'bai-1');
      expect(
        setup.adapter.requests.single.uri.toString(),
        'https://static.test/data/grammar/articles/index.json',
      );
    },
  );

  test(
    'fetchArticle parses frontmatter and returns null for 404 content',
    () async {
      final setup = _setup([
        (
          body:
              '---\ntitle: "Bai 1"\nlevel: "A1"\nslug: "bai-1"\n---\n\n'
              '# Bai 1\n\nNoi dung du dai de vuot qua nguong 50 ky tu toi thieu.',
          contentType: 'text/plain',
        ),
        (body: 'title: 404', contentType: 'text/plain'),
      ]);
      final repo = GrammarRepository(setup.client, 'https://static.test');

      final article = await repo.fetchArticle('a1', 'bai-1');
      expect(article?.title, 'Bai 1');
      expect(article?.markdown, contains('Bai 1'));

      final missing = await repo.fetchArticle('a1', 'missing');
      expect(missing, isNull);
    },
  );

  test(
    'fetchCompletedLessonIds returns lesson_ids and swallows API errors',
    () async {
      final setup = _setup([
        (body: '{"lesson_ids":["abc","def"]}', contentType: 'application/json'),
      ]);
      final repo = GrammarRepository(setup.client, 'https://static.test');

      final ids = await repo.fetchCompletedLessonIds();

      expect(ids, ['abc', 'def']);
      expect(setup.adapter.requests.single.path, '/user/grammar-progress');
    },
  );

  test('markComplete posts lesson_id and level to /user/grammar-progress', () async {
    final setup = _setup([
      (body: '{"status":"ok"}', contentType: 'application/json'),
    ]);
    final repo = GrammarRepository(setup.client, 'https://static.test');

    await repo.markComplete(lessonId: 'abc', level: 'A1');

    final request = setup.adapter.requests.single;
    expect(request.method, 'POST');
    expect(request.path, '/user/grammar-progress');
    expect(request.data, {'lesson_id': 'abc', 'level': 'A1'});
  });
}

({ApiClient client, _QueueAdapter adapter}) _setup(
  List<({String body, String contentType})> responses,
) {
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

  final List<({String body, String contentType})> responses;
  final List<RequestOptions> requests = [];
  var _index = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final response = responses[_index++];
    return ResponseBody.fromString(
      response.body,
      200,
      headers: {
        Headers.contentTypeHeader: [response.contentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
