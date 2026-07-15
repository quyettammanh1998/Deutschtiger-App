import 'package:deutschtiger/data/exam/exam_ecosystem_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/exam/exam_dictation_screen.dart';
import 'package:deutschtiger/view_models/exam/exam_ecosystem_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _target = ExamDictationTarget(
  provider: 'telc',
  level: 'b1',
  slug: 'ex-01',
);

const _transcript = ExamWordTranscript(
  audios: [
    ExamDictationAudio(
      file: 'a1.mp3',
      audioUrl: '', // empty on purpose — avoid touching just_audio in tests.
      duration: 5,
      teil: 'TEIL 1',
      sentences: [
        ExamDictationSentence(
          text: 'Ich lerne Deutsch.',
          textVi: 'Tôi học tiếng Đức.',
          start: 0,
          end: 2,
          words: [
            ExamWordTiming(word: 'Ich', clean: 'ich', start: 0, end: 0.2),
            ExamWordTiming(word: 'lerne', clean: 'lerne', start: 0.3, end: 0.7),
            ExamWordTiming(word: 'Deutsch.', clean: 'deutsch', start: 0.8, end: 1.2),
          ],
        ),
      ],
    ),
  ],
  words: [
    ExamContentWord(word: 'lerne', clean: 'lerne', textVi: 'học'),
    ExamContentWord(word: 'Deutsch.', clean: 'deutsch', textVi: 'tiếng Đức'),
  ],
);

void main() {
  testWidgets('renders blanks for the selected content words', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          examWordTranscriptProvider(
            _target,
          ).overrideWith((ref) async => _transcript),
        ],
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: ExamDictationScreen(
            provider: 'telc',
            level: 'b1',
            slug: 'ex-01',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('TEIL 1'), findsOneWidget);
    expect(find.text('Ich'), findsOneWidget); // non-blank word rendered as text
    expect(find.byType(TextField), findsNWidgets(2)); // 2 selected content words
    expect(tester.takeException(), isNull);
  });

  testWidgets('checking a correct answer turns the field state to success', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          examWordTranscriptProvider(
            _target,
          ).overrideWith((ref) async => _transcript),
        ],
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: ExamDictationScreen(
            provider: 'telc',
            level: 'b1',
            slug: 'ex-01',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final firstField = find.byKey(const Key('dictation-field-a1.mp3-0-1'));
    expect(firstField, findsOneWidget);
    await tester.enterText(firstField, 'lerne');
    await tester.tap(find.byKey(const Key('dictation-check-a1.mp3-0-1')));
    await tester.pump();

    expect(
      find.byIcon(Icons.check_circle),
      findsOneWidget,
      reason: 'correct answer should flip the check icon to filled/success',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows the not-found error view when the transcript 404s', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          examWordTranscriptProvider(
            _target,
          ).overrideWith((ref) async => throw Exception('404')),
        ],
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: ExamDictationScreen(
            provider: 'telc',
            level: 'b1',
            slug: 'ex-01',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Đề này chưa có dữ liệu luyện nghe chép chính tả.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
