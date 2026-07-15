import 'dart:typed_data';

import 'package:deutschtiger/repositories/stats/daily_quote_repository.dart';
import 'package:deutschtiger/repositories/stats/error_patterns_repository.dart';
import 'package:deutschtiger/repositories/stats/stats_repository.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('stats repository uses the review-stats contract', () async {
    final setup = _setup(['{"total_reviews":42,"words_learned":10}']);
    final repository = StatsRepository(setup.client);

    final stats = await repository.getReviewStats();

    expect(stats.totalReviews, 42);
    expect(stats.wordsLearned, 10);
    expect(setup.adapter.requests.single.method, 'GET');
    expect(setup.adapter.requests.single.path, '/user/review-stats');
  });

  test('stats repository sends days query on xp-daily-log', () async {
    final setup = _setup([
      '[{"log_date":"2026-07-10T00:00:00Z","xp_earned":15}]',
    ]);
    final repository = StatsRepository(setup.client);

    final log = await repository.getXpDailyLog(days: 7);

    expect(log.single.xpEarned, 15);
    expect(setup.adapter.requests.single.path, '/user/xp-daily-log');
    expect(setup.adapter.requests.single.queryParameters['days'], 7);
  });

  test('stats repository maps the srs/mastery contract', () async {
    final setup = _setup([
      '{"new":1,"learning":2,"young":3,"mature":4,"total":10}',
    ]);
    final repository = StatsRepository(setup.client);

    final mastery = await repository.getMastery();

    expect(mastery.newCount, 1);
    expect(mastery.mature, 4);
    expect(mastery.total, 10);
    expect(setup.adapter.requests.single.path, '/user/srs/mastery');
  });

  test('stats repository sends days query on srs/stats/daily', () async {
    final setup = _setup([
      '[{"date":"2026-07-10","reviews_count":5,"retention_rate":0.9,"lapses":1,"new_cards_added":2}]',
    ]);
    final repository = StatsRepository(setup.client);

    final daily = await repository.getDailySrsStats(days: 30);

    expect(daily.single.reviewsCount, 5);
    expect(daily.single.retentionRate, 0.9);
    expect(setup.adapter.requests.single.path, '/user/srs/stats/daily');
    expect(setup.adapter.requests.single.queryParameters['days'], 30);
  });

  test('error patterns repository uses the summary contract', () async {
    final setup = _setup([
      '[{"error_type":"word_order","total_count":5,"last_seen":"2026-07-10T00:00:00Z","example_original":"a","example_corrected":"b","sources":["sprechen"]}]',
    ]);
    final repository = ErrorPatternsRepository(setup.client);

    final patterns = await repository.getSummary();

    expect(patterns.single.errorType, 'word_order');
    expect(patterns.single.totalCount, 5);
    expect(patterns.single.sources, ['sprechen']);
    expect(
      setup.adapter.requests.single.path,
      '/user/error-patterns/summary',
    );
  });

  test('daily quote repository uses the quotes/daily and random contracts', () async {
    final setup = _setup([
      '{"id":"5","content_de":"Übung macht den Meister.","content_vi":"Có công mài sắt.","category":"Motivation"}',
      '[{"id":"6","content_de":"Der Weg ist das Ziel.","content_vi":"Con đường là đích đến.","category":"Philosophy"}]',
    ]);
    final repository = DailyQuoteRepository(setup.client);

    final daily = await repository.getDaily();
    final random = await repository.getRandom(limit: 20);

    expect(daily.id, '5');
    expect(daily.contentVi, 'Có công mài sắt.');
    expect(random.single.category, 'Philosophy');
    expect(setup.adapter.requests[0].path, '/quotes/daily');
    expect(setup.adapter.requests[1].path, '/quotes/random');
    expect(setup.adapter.requests[1].queryParameters['limit'], 20);
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
