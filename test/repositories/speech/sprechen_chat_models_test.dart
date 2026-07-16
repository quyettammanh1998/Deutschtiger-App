import 'package:deutschtiger/data/speech/sprechen_chat_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('SprechenGrading.fromJson parses known fields with 0-fallback', () {
    final grading = SprechenGrading.fromJson({
      'total': 22,
      'max_score': 25,
      'inhalt': 7,
      'grammatik': 8,
      'wortschatz': 7,
      'main_errors': ['Fehler bei Wortstellung'],
    });

    expect(grading.total, 22);
    expect(grading.max, 25);
    expect(grading.mainErrors, ['Fehler bei Wortstellung']);
  });

  test('SprechenGrading.fromJson tolerates a missing/unverified response shape', () {
    final grading = SprechenGrading.fromJson({});

    expect(grading.total, 0);
    expect(grading.max, 25);
    expect(grading.mainErrors, isEmpty);
  });

  test('SprechenChatMessage.copyWith only overrides provided fields', () {
    const original = SprechenChatMessage(
      role: SprechenChatRole.user,
      text: 'Hallo',
    );

    final updated = original.copyWith(feedbackScore: 4, feedbackComment: 'Gut');

    expect(updated.text, 'Hallo');
    expect(updated.feedbackScore, 4);
    expect(updated.feedbackComment, 'Gut');
    expect(updated.pending, isFalse);
  });
}
