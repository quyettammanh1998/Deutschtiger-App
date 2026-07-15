import '../../../services/api_client.dart';
import '../domain/my_word.dart';

class MyWordsRepository {
  const MyWordsRepository(this._api);

  final ApiClient _api;

  Future<MyWordsPage> fetch({
    required MyWordsFilter filter,
    int limit = 100,
    int offset = 0,
  }) async {
    final json = await _api.get<Map<String, dynamic>>(
      '/user/my-words',
      query: {'filter': filter.apiValue, 'limit': limit, 'offset': offset},
    );
    final rawWords = json['words'] as List<dynamic>? ?? const [];
    return MyWordsPage(
      words: rawWords
          .whereType<Map<String, dynamic>>()
          .map(MyWord.fromJson)
          .toList(growable: false),
      total: (json['total'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? limit,
      offset: (json['offset'] as num?)?.toInt() ?? offset,
    );
  }
}
