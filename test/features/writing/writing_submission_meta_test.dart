import 'package:deutschtiger/features/writing/domain/writing_exam_id_parser.dart';
import 'package:deutschtiger/features/writing/domain/writing_submission_meta.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('getWritingSubmissionMeta', () {
    test('Goethe B1 submissions route to the dedicated practice page', () {
      final parsed = parseWritingExamId(
        'goethe-b1-writing-teil-1/urlaub-email/schreiben',
      )!;
      final meta = getWritingSubmissionMeta(parsed: parsed, taskPrompt: 'Liebe Anna,');
      expect(meta.badge, 'Goethe B1 · Teil 1');
      expect(meta.provider, 'goethe');
      expect(meta.level, 'b1');
      expect(meta.isCustom, isFalse);
      expect(meta.practiceRoute, '/exam/goethe-b1/writing/1/urlaub-email/practice');
    });

    test('custom submissions have no practice route (caller reopens tu-nhap)', () {
      final parsed = parseWritingExamId(
        'goethe-b2-custom-teil3/c-abc-xy/schreiben',
      )!;
      final meta = getWritingSubmissionMeta(
        parsed: parsed,
        taskPrompt: 'Schreiben Sie einen Bericht über Ihre Stadt.',
      );
      expect(meta.isCustom, isTrue);
      expect(meta.teil, 3);
      expect(meta.practiceRoute, isNull);
      expect(meta.title, contains('Schreiben Sie einen Bericht'));
    });

    test('generic official submissions route to the level-practice page', () {
      final parsed = parseWritingExamId('telc-b1-official/wohnung/schreiben')!;
      final meta = getWritingSubmissionMeta(parsed: parsed, taskPrompt: 'Sehr geehrte...');
      expect(meta.isCustom, isFalse);
      expect(meta.practiceRoute, '/exam/telc-b1/writing/wohnung/practice');
    });

    test('unknown provider/level offering degrades practiceRoute to null', () {
      final parsed = parseWritingExamId('unknown-x1-official/foo/schreiben')!;
      final meta = getWritingSubmissionMeta(parsed: parsed, taskPrompt: 'x');
      expect(meta.practiceRoute, isNull);
    });
  });
}
