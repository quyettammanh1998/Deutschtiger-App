import 'dart:typed_data';

import 'package:deutschtiger/repositories/journey/journey_repository.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('getCourseCatalog parses the DW course index by level', () async {
    final setup = _setup([
      '{"levels":{"a1":{"name":"A1","nameVi":"A1","courses":'
          '[{"id":1,"slug":"nicos-weg-a1","name":"Nicos Weg A1","totalLessons":77}]}}}',
    ]);

    final groups = await setup.repo.getCourseCatalog();

    expect(groups.single.level, 'a1');
    expect(groups.single.courses.single.slug, 'nicos-weg-a1');
    expect(groups.single.courses.single.totalLessons, 77);
    expect(setup.adapter.requests.single.path, '/courses');
  });

  test('getCourseDetail parses lessons for a course slug', () async {
    final setup = _setup([
      '{"id":1,"slug":"nicos-weg-a1","name":"Nicos Weg A1","level":"a1",'
          '"totalLessons":1,"lessons":[{"id":1,"number":1,"name":"Lektion 1"}]}',
    ]);

    final detail = await setup.repo.getCourseDetail('nicos-weg-a1');

    expect(detail.lessons.single.number, 1);
    expect(setup.adapter.requests.single.path, '/courses/nicos-weg-a1');
  });

  test('getLesson parses video + vocabulary + exercise count', () async {
    final setup = _setup([
      '{"number":1,"name":"Guten Tag","video":{"title":"Guten Tag","mp4":"https://cdn.test/v.mp4"},'
          '"vocabularies":[{"german":"Hallo","vietnamese":"Xin chào"}],'
          '"exercises":[{"id":1},{"id":2}]}',
    ]);

    final lesson = await setup.repo.getLesson('nicos-weg-a1', 1);

    expect(lesson.video!.isSelfHosted, isTrue);
    expect(lesson.vocabularies.single.german, 'Hallo');
    expect(lesson.exerciseCount, 2);
    expect(setup.adapter.requests.single.path, '/courses/nicos-weg-a1/lessons/1');
  });

  test('getFeaturedCourses parses the featured-courses list', () async {
    final setup = _setup([
      '[{"id":"f1","course_slug":"nicos-weg-a1","is_active":true,"sort_order":0}]',
    ]);

    final featured = await setup.repo.getFeaturedCourses();

    expect(featured.single.courseSlug, 'nicos-weg-a1');
    expect(setup.adapter.requests.single.path, '/featured-courses');
  });

  test('getMyCourses returns entries and swallows API errors as empty', () async {
    final setup = _setup([
      '[{"course_slug":"nicos-weg-a1","lessons_started":3}]',
    ]);
    final entries = await setup.repo.getMyCourses();
    expect(entries.single.courseSlug, 'nicos-weg-a1');
    expect(setup.adapter.requests.single.path, '/user/courses/my-courses');

    final errorSetup = _setup([], statusCode: 403);
    final empty = await errorSetup.repo.getMyCourses();
    expect(empty, isEmpty);
  });

  test('getLessonProgress returns null when not started or unauthorized', () async {
    final notStarted = _setup(['null']);
    expect(await notStarted.repo.getLessonProgress('nicos-weg-a1', 1), isNull);

    final unauthorized = _setup([], statusCode: 401);
    expect(await unauthorized.repo.getLessonProgress('nicos-weg-a1', 1), isNull);
  });

  test('upsertLessonProgress PUTs the progress payload', () async {
    final setup = _setup([
      '{"lesson_number":1,"video_completed":true,"score_percentage":100}',
    ]);

    final progress = await setup.repo.upsertLessonProgress(
      slug: 'nicos-weg-a1',
      lessonNumber: 1,
      videoCompleted: true,
    );

    expect(progress.videoCompleted, isTrue);
    expect(setup.adapter.requests.single.method, 'PUT');
    expect(
      setup.adapter.requests.single.path,
      '/user/courses/nicos-weg-a1/lessons/1/progress',
    );
    expect(
      (setup.adapter.requests.single.data as Map)['video_completed'],
      true,
    );
  });

  test('upsertLessonNote PUTs the note content', () async {
    final setup = _setup(['{"content":"Ghi chú của tôi"}']);

    final note = await setup.repo.upsertLessonNote(
      slug: 'nicos-weg-a1',
      lessonNumber: 1,
      content: 'Ghi chú của tôi',
    );

    expect(note.content, 'Ghi chú của tôi');
    expect(setup.adapter.requests.single.method, 'PUT');
    expect(
      setup.adapter.requests.single.path,
      '/user/courses/nicos-weg-a1/lessons/1/notes',
    );
  });
}

({JourneyRepository repo, _QueueAdapter adapter}) _setup(
  List<String> responses, {
  int statusCode = 200,
}) {
  final client = ApiClient(
    baseUrl: 'https://example.test/api/v1',
    tokenProvider: _NoTokenProvider(),
  );
  final adapter = _QueueAdapter(responses, statusCode: statusCode);
  client.raw.httpClientAdapter = adapter;
  return (repo: JourneyRepository(client), adapter: adapter);
}

class _NoTokenProvider implements TokenProvider {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> refresh() async => null;
}

class _QueueAdapter implements HttpClientAdapter {
  _QueueAdapter(this.responses, {this.statusCode = 200});

  final List<String> responses;
  final int statusCode;
  final List<RequestOptions> requests = [];
  var _index = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    if (statusCode >= 400) {
      throw DioException(
        requestOptions: options,
        response: Response(
          requestOptions: options,
          statusCode: statusCode,
        ),
        type: DioExceptionType.badResponse,
      );
    }
    return ResponseBody.fromString(
      responses[_index++],
      statusCode,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
