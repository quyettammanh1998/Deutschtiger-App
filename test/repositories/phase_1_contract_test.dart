import 'dart:typed_data';

import 'package:deutschtiger/repositories/home/dashboard_repository.dart';
import 'package:deutschtiger/repositories/profile_repository.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'profile repository uses GET and sparse PUT profile contracts',
    () async {
      final setup = _setup([
        '{"id":"user-1","display_name":"Mai","total_xp":12}',
        '{"id":"user-1","display_name":"Mai mới","total_xp":12}',
      ]);
      final repository = ProfileRepository(setup.client);

      final current = await repository.fetchMyProfile();
      final updated = await repository.updateProfile(displayName: 'Mai mới');

      expect(current.id, 'user-1');
      expect(updated.displayName, 'Mai mới');
      expect(
        setup.adapter.requests.map(
          (request) => '${request.method} ${request.path}',
        ),
        ['GET /user/profile', 'PUT /user/profile'],
      );
      expect(setup.adapter.requests.last.data, {'display_name': 'Mai mới'});
    },
  );

  test(
    'dashboard repository uses the mounted dashboard-init contract',
    () async {
      final setup = _setup([
        '{"profile":{"display_name":"Mai"},"due_review_count":3}',
      ]);

      final dashboard = await DashboardRepository(
        setup.client,
      ).fetchDashboard();

      expect(dashboard.profile?.displayName, 'Mai');
      expect(dashboard.dueReviewCount, 3);
      expect(setup.adapter.requests.single.method, 'GET');
      expect(setup.adapter.requests.single.path, '/user/dashboard-init');
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
