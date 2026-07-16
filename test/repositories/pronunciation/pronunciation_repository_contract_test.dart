import 'dart:typed_data';

import 'package:deutschtiger/data/pronunciation/pronunciation_repository.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'fetchUmlauteItems uses GET /user/pronunciation/umlaute with limit query',
    () async {
      final setup = _setup([
        '{"items":[{"id":"u1","word":"schön","ipa":"ʃøːn","umlaut":"ö",'
            '"vi_meaning":"đẹp","vi_hint":"tròn môi","minimal_pair":"schon"}]}',
      ]);
      final repo = PronunciationRepository(setup.client);

      final items = await repo.fetchUmlauteItems(limit: 15);

      expect(items.single.word, 'schön');
      expect(items.single.umlaut, 'ö');
      expect(items.single.minimalPair, 'schon');
      expect(setup.adapter.requests.single.path, '/user/pronunciation/umlaute');
      expect(setup.adapter.requests.single.queryParameters['limit'], 15);
    },
  );

  test('fetchIchAchItems parses sound + minimal_pair', () async {
    final setup = _setup([
      '{"items":[{"id":"i1","word":"ich","ipa":"ɪç","sound":"ich-laut",'
          '"vi_meaning":"tôi","vi_hint":"lưỡi cao","minimal_pair":"ach"}]}',
    ]);
    final repo = PronunciationRepository(setup.client);

    final items = await repo.fetchIchAchItems();

    expect(items.single.sound, 'ich-laut');
    expect(items.single.isIchLaut, isTrue);
    expect(
      setup.adapter.requests.single.path,
      '/user/pronunciation/ich-ach-laut',
    );
  });

  test('fetchRSoundItems maps position enum', () async {
    final setup = _setup([
      '{"items":[{"id":"r1","word":"rot","ipa":"ʁoːt","position":"initial",'
          '"vi_meaning":"đỏ","vi_hint":"cổ họng"}]}',
    ]);
    final repo = PronunciationRepository(setup.client);

    final items = await repo.fetchRSoundItems();

    expect(items.single.position.name, 'initial');
    expect(setup.adapter.requests.single.path, '/user/pronunciation/r-sound');
  });

  test('fetchSpStItems maps cluster', () async {
    final setup = _setup([
      '{"items":[{"id":"s1","word":"sprechen","ipa":"ʃpʁɛçən","cluster":"sp",'
          '"vi_meaning":"nói","vi_hint":"sp -> shp"}]}',
    ]);
    final repo = PronunciationRepository(setup.client);

    final items = await repo.fetchSpStItems();

    expect(items.single.isSp, isTrue);
    expect(setup.adapter.requests.single.path, '/user/pronunciation/sp-st');
  });

  test(
    'fetchMinimalPairContrasts uses GET /minimal-pairs/contrasts',
    () async {
      final setup = _setup([
        '[{"contrast_key":"ich-ach","focus_label":"ich vs ach",'
            '"focus_label_vi":"ich và ach","pair_count":12}]',
      ]);
      final repo = PronunciationRepository(setup.client);

      final contrasts = await repo.fetchMinimalPairContrasts();

      expect(contrasts.single.contrastKey, 'ich-ach');
      expect(contrasts.single.pairCount, 12);
      expect(
        setup.adapter.requests.single.path,
        '/minimal-pairs/contrasts',
      );
    },
  );

  test(
    'fetchMinimalPairs sends contrast + limit query and parses A/B words',
    () async {
      final setup = _setup([
        '[{"id":"p1","contrast_key":"ich-ach","focus_label":"ich vs ach",'
            '"focus_label_vi":"ich và ach","level":"A2","word_a_de":"ich",'
            '"word_a_ipa":"ɪç","word_a_gloss_vi":"tôi","word_a_audio_url":null,'
            '"word_b_de":"ach","word_b_ipa":"ax","word_b_gloss_vi":"ôi",'
            '"word_b_audio_url":null}]',
      ]);
      final repo = PronunciationRepository(setup.client);

      final pairs = await repo.fetchMinimalPairs('ich-ach', limit: 40);

      expect(pairs.single.wordADe, 'ich');
      expect(pairs.single.wordBDe, 'ach');
      expect(setup.adapter.requests.single.path, '/minimal-pairs');
      expect(
        setup.adapter.requests.single.queryParameters['contrast'],
        'ich-ach',
      );
      expect(setup.adapter.requests.single.queryParameters['limit'], 40);
    },
  );

  test('fetchUmlauteItems returns empty list when items missing', () async {
    final setup = _setup(['{}']);
    final repo = PronunciationRepository(setup.client);

    final items = await repo.fetchUmlauteItems();

    expect(items, isEmpty);
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
