import 'dart:convert';
import 'dart:typed_data';

import 'package:deutschtiger/data/speech/conversation_models.dart';
import 'package:deutschtiger/repositories/speech/conversation_repository.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('fetchScenarios parses the scenarios list', () async {
    final setup = _setup('{"scenarios":[{"id":"restaurant","title_de":"Im Restaurant","title_vi":"Ở nhà hàng","level":"A2"}]}');

    final scenarios = await setup.repository.fetchScenarios();

    expect(scenarios, hasLength(1));
    expect(scenarios.first.id, 'restaurant');
    expect(scenarios.first.level, 'A2');
    expect(setup.adapter.request!.path, '/user/conversation/scenarios');
  });

  test('fetchScenario parses the full scenario detail', () async {
    final setup = _setup('''
      {"scenario":{"id":"restaurant","title_de":"Im Restaurant","title_vi":"Ở nhà hàng","level":"A2",
      "ai_role":"Kellner","user_role":"Gast","context_de":"ctx de","context_vi":"ctx vi",
      "vocab":[{"de":"die Speisekarte","vi":"thực đơn"}],
      "sample_phrases":[{"de":"Ich hätte gern...","vi":"Tôi muốn..."}],
      "required_points":[{"de":"Bestellung aufgeben","vi":"Gọi món"}],
      "starter_prompt_de":"Guten Tag!","gradient_from":"from-amber-500","gradient_to":"to-orange-600","icon":"restaurant"}}
    ''');

    final scenario = await setup.repository.fetchScenario('restaurant');

    expect(scenario.aiRole, 'Kellner');
    expect(scenario.vocab, hasLength(1));
    expect(scenario.requiredPoints.single.de, 'Bestellung aufgeben');
    expect(setup.adapter.request!.path, '/user/conversation/scenario/restaurant');
  });

  test('postTurn sends history + user_message and parses the reply', () async {
    final setup = _setup('{"ai_message":"Sehr gut!","session_done":true,"coverage":[{"index":0,"label_de":"x","label_vi":"y","covered":true}]}');

    final response = await setup.repository.postTurn(
      scenarioId: 'restaurant',
      history: const [DialogMessage(role: 'ai', text: 'Guten Tag!')],
      userMessage: 'Ich möchte bestellen.',
    );

    expect(response.aiMessage, 'Sehr gut!');
    expect(response.sessionDone, isTrue);
    expect(response.coverage.single.covered, isTrue);

    final body = setup.adapter.request!.data as Map;
    expect(body['scenario_id'], 'restaurant');
    expect(body['user_message'], 'Ich möchte bestellen.');
    expect(body['history'], [
      {'role': 'ai', 'text': 'Guten Tag!'},
    ]);
    expect(body.containsKey('custom_scenario'), isFalse);
  });

  test('fetchOpening includes custom_scenario payload when provided', () async {
    final setup = _setup('{"ai_message":"Hallo!"}');

    final message = await setup.repository.fetchOpening(
      scenarioId: 'custom',
      customScenario: const CustomScenarioPayload(topic: 'Du lịch', level: 'B1'),
    );

    expect(message, 'Hallo!');
    final body = setup.adapter.request!.data as Map;
    expect(body['custom_scenario'], {'topic': 'Du lịch', 'level': 'B1'});
  });
}

({ConversationRepository repository, _Adapter adapter}) _setup(String response) {
  final client = ApiClient(baseUrl: 'https://example.test/api/v1', tokenProvider: _NoTokenProvider());
  final adapter = _Adapter(response);
  client.raw.httpClientAdapter = adapter;
  return (repository: ConversationRepository(client), adapter: adapter);
}

class _NoTokenProvider implements TokenProvider {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> refresh() async => null;
}

class _Adapter implements HttpClientAdapter {
  _Adapter(this.response);

  final String response;
  RequestOptions? request;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    request = options.copyWith(
      data: options.data is String ? jsonDecode(options.data as String) : options.data,
    );
    return ResponseBody.fromString(
      response,
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
