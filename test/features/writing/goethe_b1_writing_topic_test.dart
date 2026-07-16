import 'package:deutschtiger/features/writing/domain/goethe_b1_writing_topic.dart';
import 'package:deutschtiger/features/writing/domain/writing_topic/uebungen_exercise.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GoetheB1WritingTopic.fromJson', () {
    test('parses every major section from a full payload', () {
      final topic = GoetheB1WritingTopic.fromJson({
        'slug': 'mein-hobby',
        'teil': 1,
        'titleDe': 'Mein Hobby',
        'titleVi': 'Sở thích của tôi',
        'difficulty': 'easy',
        'frequencyStars': 5,
        'examDates': ['2024-01', '2024-06'],
        'taskWordCount': {'min': 30, 'target': 40, 'max': 50},
        'sources': [
          {'label': 'Goethe archive', 'type': 'gdocs'},
        ],
        'task': {'de': 'Schreiben Sie...', 'vi': 'Hãy viết...'},
        'taskAnalysis': {
          'summaryVi': 'Tóm tắt',
          'points': [
            {
              'de': 'Punkt 1',
              'vi': 'Điểm 1',
              'subpoints': [
                {'de': 'Sub', 'vi': 'Phụ'},
              ],
            },
          ],
        },
        'textStructure': [
          {'part': 'Einleitung', 'de': 'de', 'vi': 'vi'},
        ],
        'usefulPhrases': [
          {
            'category': 'Begrüßung',
            'rows': [
              {'de': 'Hallo', 'vi': 'Xin chào'},
            ],
          },
        ],
        'sampleSentences': [
          {
            'point': 'Punkt 1',
            'sentences': [
              {'de': 'Ich mag...', 'vi': 'Tôi thích...'},
            ],
          },
        ],
        'modelAnswers': [
          {'title': 'Model 1', 'de': 'Liebe Anna,', 'vi': 'Anna thân mến,', 'wordCount': 42},
        ],
        'grammarFocus': [
          {'pattern': 'weil-Satz', 'example': 'weil ich...', 'vi': 'vì tôi...'},
        ],
        'wortschatzBox': {
          'kernwortschatz': [
            {'de': 'das Hobby', 'genus': 'n', 'vi': 'sở thích'},
          ],
          'chunks': [
            {'chunk': 'in meiner Freizeit', 'vi': 'trong thời gian rảnh'},
          ],
          'konnektoren': [
            {'de': 'deshalb', 'vi': 'vì vậy'},
          ],
        },
        'commonMistakes': [
          {'wrong': 'Ich bin Hobby', 'correct': 'Mein Hobby ist', 'vi': 'giải thích'},
        ],
        'uebungen': [
          {
            'kind': 'cloze',
            'index': 0,
            'title': 'Điền từ',
            'questions': [
              {
                'id': 'q1',
                'textBefore': 'Ich ',
                'blank': {'options': ['mag', 'magst'], 'correct': 'mag'},
                'textAfter': ' Musik.',
              },
            ],
          },
        ],
        'bodyMarkdown': '# Mein Hobby',
      });

      expect(topic.slug, 'mein-hobby');
      expect(topic.teil, 1);
      expect(topic.taskWordCount?.target, 40);
      expect(topic.sources, hasLength(1));
      expect(topic.task?.de, 'Schreiben Sie...');
      expect(topic.taskAnalysis?.points.single.subpoints.single.de, 'Sub');
      expect(topic.textStructure.single.part, 'Einleitung');
      expect(topic.usefulPhrases.single.rows.single.de, 'Hallo');
      expect(topic.sampleSentences.single.sentences.single.vi, 'Tôi thích...');
      expect(topic.modelAnswers.single.wordCount, 42);
      expect(topic.grammarFocus.single.pattern, 'weil-Satz');
      expect(topic.wortschatzBox?.kernwortschatz.single.genus, 'n');
      expect(topic.wortschatzBox?.chunks.single.chunk, 'in meiner Freizeit');
      expect(topic.wortschatzBox?.konnektoren.single.de, 'deshalb');
      expect(topic.commonMistakes.single.wrong, 'Ich bin Hobby');
      expect(topic.uebungen, hasLength(1));
      expect(topic.uebungen.single, isA<ClozeExercise>());
      expect((topic.uebungen.single as ClozeExercise).questions.single.blank.correct, 'mag');
      expect(topic.bodyMarkdown, '# Mein Hobby');
    });

    test('defaults gracefully on a malformed/empty payload', () {
      final topic = GoetheB1WritingTopic.fromJson(const {});
      expect(topic.slug, '');
      expect(topic.task, isNull);
      expect(topic.taskAnalysis, isNull);
      expect(topic.textStructure, isEmpty);
      expect(topic.uebungen, isEmpty);
      expect(topic.bodyMarkdown, '');
    });
  });

  group('Exercise.fromJson discriminated union', () {
    test('parses word-order, match, error-correction, mini-write kinds', () {
      final wordOrder = Exercise.fromJson({
        'kind': 'word-order',
        'index': 0,
        'title': 'Sắp xếp',
        'questions': [
          {'id': 'w1', 'tokens': ['Ich', 'gehe'], 'correct': 'Ich gehe'},
        ],
      });
      expect(wordOrder, isA<WordOrderExercise>());

      final match = Exercise.fromJson({
        'kind': 'match',
        'index': 1,
        'title': 'Ghép cặp',
        'pairs': [
          {'id': 'p1', 'phrase': 'Meiner Meinung nach', 'correctFunctionIndex': 0},
        ],
        'functions': ['Ý kiến'],
      });
      expect(match, isA<MatchExercise>());

      final errorCorrection = Exercise.fromJson({
        'kind': 'error-correction',
        'index': 2,
        'title': 'Sửa lỗi',
        'questions': [
          {'id': 'e1', 'wrong': 'Ich bin gehen', 'correct': 'Ich gehe'},
        ],
      });
      expect(errorCorrection, isA<ErrorCorrectionExercise>());

      final miniWrite = Exercise.fromJson({
        'kind': 'mini-write',
        'index': 3,
        'title': 'Viết câu',
        'prompts': [
          {'id': 'm1', 'promptVi': 'Viết một câu', 'patternDe': 'weil...'},
        ],
      });
      expect(miniWrite, isA<MiniWriteExercise>());
    });

    test('unknown kind returns null and is filtered out of listFromJson', () {
      expect(Exercise.fromJson({'kind': 'unknown'}), isNull);
      expect(
        Exercise.listFromJson([
          {'kind': 'unknown'},
          {'kind': 'cloze', 'index': 0, 'title': 'x', 'questions': []},
        ]),
        hasLength(1),
      );
    });
  });
}
