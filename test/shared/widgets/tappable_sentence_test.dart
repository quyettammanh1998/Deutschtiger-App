import 'package:deutschtiger/shared/widgets/tappable_sentence.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('returns a clean German token when a word is tapped', (
    tester,
  ) async {
    String? tappedWord;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TappableSentence(
            text: 'Das Haus, ist groß.',
            onWordTap: (word) => tappedWord = word,
          ),
        ),
      ),
    );

    final richText = tester.widget<RichText>(find.byType(RichText));
    final rootSpan = richText.text as TextSpan;
    final wordSpan = rootSpan.children!.whereType<TextSpan>().firstWhere(
      (span) => span.text == 'Haus,',
    );
    final recognizer = wordSpan.recognizer! as TapGestureRecognizer;
    recognizer.onTap!();

    expect(tappedWord, 'Haus');
  });
}
