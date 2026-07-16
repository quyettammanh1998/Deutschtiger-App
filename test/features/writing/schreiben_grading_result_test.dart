import 'package:deutschtiger/features/writing/domain/schreiben_grading_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SchreibenGradingResult.fromJson', () {
    test('parses a full backend payload', () {
      final json = {
        'score': 78,
        'grade': 'gut',
        'feedback': {
          'taskCompletion': {'score': 20, 'comment': 'Đủ ý'},
          'grammar': {'score': 18, 'comment': 'Vài lỗi chia động từ'},
          'vocabulary': {'score': 20, 'comment': 'Từ vựng phong phú'},
          'coherence': {'score': 20, 'comment': 'Mạch lạc'},
        },
        'corrections': [
          {
            'original': 'Ich gehe zur Schule',
            'corrected': 'Ich gehe in die Schule',
            'explanation': 'Sai giới từ',
            'error_type': 'preposition',
          },
        ],
        'suggestions': [
          {'original': 'Ich bin froh', 'natural': 'Ich freue mich', 'vi': 'Tôi vui', 'why': 'Tự nhiên hơn'},
        ],
        'summary': 'Bài viết tốt.',
        'goetheRaw': {
          'inhalt': 3,
          'kommunikative': 3.5,
          'formale': 4,
          'teilLabel': 'Teil 1 — Private E-Mail',
        },
      };

      final result = SchreibenGradingResult.fromJson(json);

      expect(result.score, 78);
      expect(result.grade, 'gut');
      expect(result.taskCompletion.score, 20);
      expect(result.taskCompletion.comment, 'Đủ ý');
      expect(result.corrections, hasLength(1));
      expect(result.corrections.single.errorType, 'preposition');
      expect(result.suggestions, hasLength(1));
      expect(result.suggestions.single.natural, 'Ich freue mich');
      expect(result.hasGoetheRaw, isTrue);
      expect(result.goetheRaw!.inhalt, 3);
      expect(result.goetheRaw!.kommunikative, 3.5);
      expect(result.correctedText, isNull);
    });

    test('tolerates missing/malformed optional fields without throwing', () {
      final result = SchreibenGradingResult.fromJson(const {
        'score': 'not-a-number',
        'summary': 'x',
      });

      expect(result.score, 0);
      expect(result.grade, '');
      expect(result.corrections, isEmpty);
      expect(result.suggestions, isEmpty);
      expect(result.hasGoetheRaw, isFalse);
      expect(result.taskCompletion.score, 0);
    });

    test('toJson round-trips through fromJson', () {
      const original = SchreibenGradingResult(
        score: 55,
        grade: 'ausreichend',
        feedback: {},
        corrections: [
          WritingCorrection(original: 'a', corrected: 'b', explanation: 'c', errorType: 'spelling'),
        ],
        suggestions: [],
        summary: 'ok',
        correctedText: 'corrected text',
      );

      final roundTripped = SchreibenGradingResult.fromJson(original.toJson());

      expect(roundTripped.score, 55);
      expect(roundTripped.grade, 'ausreichend');
      expect(roundTripped.corrections.single.errorType, 'spelling');
      expect(roundTripped.correctedText, 'corrected text');
    });
  });
}
