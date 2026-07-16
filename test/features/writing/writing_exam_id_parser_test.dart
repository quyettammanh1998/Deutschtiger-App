import 'package:deutschtiger/features/writing/domain/writing_exam_id_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseWritingExamId', () {
    test('parses a Goethe B1 exam id', () {
      final parsed =
          parseWritingExamId('goethe-b1-writing-teil-2/meinung-forum/schreiben');
      expect(parsed, isA<ParsedGoetheB1WritingExamId>());
      final g = parsed as ParsedGoetheB1WritingExamId;
      expect(g.teil, 2);
      expect(g.slug, 'meinung-forum');
    });

    test('parses a generic official schreiben exam id', () {
      final parsed = parseWritingExamId('goethe-b2-official/urlaub/schreiben');
      expect(parsed, isA<ParsedSchreibenExamId>());
      final s = parsed as ParsedSchreibenExamId;
      expect(s.provider, 'goethe');
      expect(s.level, 'b2');
      expect(s.set, 'official');
      expect(s.slug, 'urlaub');
    });

    test('parses a custom exam id with Teil suffix', () {
      final parsed = parseWritingExamId('telc-b1-custom-teil2/c-abc123-xy/schreiben');
      final s = parsed as ParsedSchreibenExamId;
      expect(isCustomWritingSet(s.set), isTrue);
      expect(teilFromWritingSet(s.set), 2);
    });

    test('returns null for an unrecognised id', () {
      expect(parseWritingExamId('not-a-writing-id'), isNull);
    });
  });

  test('buildOfficialWritingExamId matches web format', () {
    expect(
      buildOfficialWritingExamId(provider: 'goethe', level: 'b2', slug: 'urlaub'),
      'goethe-b2-official/urlaub/schreiben',
    );
  });

  test('buildCustomWritingExamId encodes optional Teil', () {
    expect(
      buildCustomWritingExamId(provider: 'telc', level: 'b1', teil: 2, slug: 'x'),
      'telc-b1-custom-teil2/x/schreiben',
    );
    expect(
      buildCustomWritingExamId(provider: 'telc', level: 'b1', slug: 'x'),
      'telc-b1-custom/x/schreiben',
    );
  });

  test('generateCustomWritingSlug is url-safe and unique-ish', () {
    final a = generateCustomWritingSlug();
    final b = generateCustomWritingSlug();
    expect(RegExp(r'^[a-z0-9-]+$').hasMatch(a), isTrue);
    expect(a, isNot(equals(b)));
  });
}
