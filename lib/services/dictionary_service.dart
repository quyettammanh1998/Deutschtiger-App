import 'api_client.dart';

class WordEntry {
  const WordEntry({
    required this.id,
    required this.word,
    this.phonetic,
    this.partOfSpeech,
    this.gender,
    this.meanings = const <String>[],
    this.examples = const <WordExample>[],
    this.audioUrl,
  });

  final String id;
  final String word;
  final String? phonetic;
  final String? partOfSpeech;
  final String? gender;
  final List<String> meanings;
  final List<WordExample> examples;
  final String? audioUrl;

  factory WordEntry.fromJson(Map<String, dynamic> json) {
    final examplesJson = json['examples'] as List<dynamic>? ?? const [];
    return WordEntry(
      id: json['id'] as String? ?? '',
      word: json['content_de'] as String? ?? '',
      phonetic: json['ipa'] as String?,
      partOfSpeech: json['word_type'] as String?,
      gender: _articleForGender(json['gender'] as String?),
      meanings: (json['meanings'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .toList(growable: false),
      examples: examplesJson
          .whereType<Map<String, dynamic>>()
          .map(WordExample.fromJson)
          .where((example) => example.de.isNotEmpty)
          .toList(growable: false),
      audioUrl: json['audio_url'] as String?,
    );
  }

  static String? _articleForGender(String? gender) => switch (gender) {
    'm' => 'der',
    'f' => 'die',
    'n' => 'das',
    final value when value != null && value.isNotEmpty => value,
    _ => null,
  };
}

class WordExample {
  const WordExample({required this.de, required this.vi});

  final String de;
  final String vi;

  factory WordExample.fromJson(Map<String, dynamic> json) => WordExample(
    de: json['de'] as String? ?? '',
    vi: json['vi'] as String? ?? '',
  );
}

class DictionaryService {
  const DictionaryService(this._api);

  final ApiClient _api;

  Future<WordEntry?> lookup(String rawWord) async {
    final word = normalizeWord(rawWord);
    if (word.length < 2) return null;

    final response = await _api.get<Map<String, dynamic>>(
      '/vocabulary/search',
      query: {'q': word, 'pageSize': 5},
    );
    final items = response['items'] as List<dynamic>? ?? const [];
    if (items.isEmpty || items.first is! Map<String, dynamic>) return null;
    return WordEntry.fromJson(items.first as Map<String, dynamic>);
  }

  String normalizeWord(String value) => value.trim().toLowerCase().replaceAll(
    RegExp(
      r'''^[.,;:!?„“”'"»«()\[\]{}…\-–—]+|[.,;:!?„“”'"»«()\[\]{}…\-–—]+$''',
    ),
    '',
  );
}
