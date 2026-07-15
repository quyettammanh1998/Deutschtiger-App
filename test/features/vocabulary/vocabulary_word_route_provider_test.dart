import 'package:deutschtiger/features/vocabulary/data/vocabulary_repository.dart';
import 'package:deutschtiger/features/vocabulary/domain/vocabulary_models.dart';
import 'package:deutschtiger/features/vocabulary/presentation/vocabulary_provider.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'ID-only route fetches one learning item without a topic request',
    () async {
      final repository = _FakeVocabularyRepository();
      final container = ProviderContainer(
        overrides: [vocabularyRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      final data = await container.read(
        vocabularyWordRouteProvider((
          itemId: 'item-2',
          topicKey: '',
          level: null,
        )).future,
      );

      expect(repository.fetchItemIds, ['item-2']);
      expect(repository.topicRequests, isEmpty);
      expect(data.item, same(repository.currentItem));
      expect(data.queue, [same(repository.currentItem)]);
    },
  );

  test(
    'topic route keeps the fetched current item in its topic queue',
    () async {
      final repository = _FakeVocabularyRepository();
      final container = ProviderContainer(
        overrides: [vocabularyRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      final data = await container.read(
        vocabularyWordRouteProvider((
          itemId: 'item-2',
          topicKey: 'daily-life',
          level: 'a1',
        )).future,
      );

      expect(repository.topicRequests.single, (
        topic: 'daily-life',
        level: 'a1',
        pageSize: 100,
      ));
      expect(data.item, same(repository.currentItem));
      expect(data.queue.map((item) => item.id), ['item-1', 'item-2']);
      expect(
        data.queue.firstWhere((item) => item.id == data.item.id),
        same(repository.currentItem),
      );
    },
  );
}

class _FakeVocabularyRepository extends VocabularyRepository {
  _FakeVocabularyRepository() : super(_dummyClient());

  final fetchItemIds = <String>[];
  final topicRequests = <({String topic, String? level, int pageSize})>[];

  final currentItem = const LearningItem(
    id: 'item-2',
    contentDe: 'lernen-current',
    contentVi: 'học',
    createdAt: '',
    updatedAt: '',
  );

  @override
  Future<LearningItem> fetchItem(String itemId) async {
    fetchItemIds.add(itemId);
    return currentItem;
  }

  @override
  Future<CollectionItemsResult> fetchItemsByTopicLevel({
    required String topic,
    String? level,
    int page = 1,
    int pageSize = 20,
    String? search,
    bool shuffle = false,
  }) async {
    topicRequests.add((topic: topic, level: level, pageSize: pageSize));
    return CollectionItemsResult(
      items: const [
        LearningItem(
          id: 'item-1',
          contentDe: 'machen',
          createdAt: '',
          updatedAt: '',
        ),
        LearningItem(
          id: 'item-2',
          contentDe: 'lernen-stale-topic-copy',
          createdAt: '',
          updatedAt: '',
        ),
      ],
      total: 2,
      pageSize: pageSize,
    );
  }
}

ApiClient _dummyClient() => ApiClient(
  baseUrl: 'https://example.test/api/v1',
  tokenProvider: _NoTokenProvider(),
);

class _NoTokenProvider implements TokenProvider {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> refresh() async => null;
}
