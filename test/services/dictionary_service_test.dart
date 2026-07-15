import 'package:deutschtiger/services/dictionary_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WordEntry', () {
    test('parses the vocabulary search response used by the lookup sheet', () {
      final entry = WordEntry.fromJson({
        'id': 'haus-1',
        'content_de': 'das Haus',
        'word_type': 'noun',
        'gender': 'n',
        'ipa': 'haʊs',
        'audio_url': 'https://audio.example/haus.mp3',
        'meanings': ['nhà', 'căn nhà'],
        'examples': [
          {'de': 'Das Haus ist groß.', 'vi': 'Ngôi nhà lớn.'},
        ],
      });

      expect(entry.id, 'haus-1');
      expect(entry.word, 'das Haus');
      expect(entry.gender, 'das');
      expect(entry.meanings, ['nhà', 'căn nhà']);
      expect(entry.examples.single.de, 'Das Haus ist groß.');
      expect(entry.audioUrl, 'https://audio.example/haus.mp3');
    });

    test('keeps an unknown non-empty gender instead of dropping it', () {
      final entry = WordEntry.fromJson({
        'id': 'plural-1',
        'content_de': 'die Leute',
        'gender': 'plural',
      });

      expect(entry.gender, 'plural');
    });
  });
}
