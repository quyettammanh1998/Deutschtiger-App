import 'package:deutschtiger/features/writing/domain/writing_exam_id.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('buildGoetheB1WritingExamId matches the web format exactly', () {
    expect(
      buildGoetheB1WritingExamId(teil: 2, slug: 'meinung-forum'),
      'goethe-b1-writing-teil-2/meinung-forum/schreiben',
    );
  });
}
