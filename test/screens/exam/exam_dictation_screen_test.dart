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

Widget _harness() => ProviderScope(
  overrides: [
    examWordTranscriptProvider(_target).overrideWith((ref) async => _transcript),
  ],
  child: const MaterialApp(
    locale: Locale('vi'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: ExamDictationScreen(provider: 'telc', level: 'b1', slug: 'ex-01'),
  ),
);

void main() {
  // Web-parity rebuild (see `dictation_activity_menu.dart` /
  // `word_selection_panel.dart` / `cloze_practice_view.dart`): the screen now
  // opens on a 3-activity menu, then a tap-to-select prep panel, before the
  // sequential audio-cued cloze quiz. The quiz itself drives forward on
  // `just_audio` position-stream events that never fire against the fixture's
  // empty `audioUrl` in a widget test — so these tests cover the menu → prep
  // → selection flow (reliably testable) rather than the in-quiz typing
  // interaction (needs a real/mocked audio backend, out of scope here).
  testWidgets('activity menu leads to the word-selection prep panel', (
    tester,
  ) async {
    await tester.pumpWidget(_harness());
    await tester.pumpAndSettle();

    // AppBar title (`l10n.examDictationTitle`) is also "Nghe chép chính
    // tả", same as the full-dictation activity card — scope that one
    // assertion to avoid an ambiguous match.
    expect(find.text('Điền từ vào chỗ trống'), findsOneWidget);
    expect(find.text('Nghe chép chính tả'), findsNWidgets(2));
    expect(find.text('Nghe & đọc theo'), findsOneWidget);

    await tester.tap(find.text('Điền từ vào chỗ trống'));
    await tester.pumpAndSettle();

    // Prep panel: Teil badge + non-content word rendered as plain text +
    // both content words tappable for selection.
    expect(find.text('Teil 1'), findsOneWidget);
    expect(find.textContaining('Ich'), findsOneWidget);
    expect(find.text('lerne'), findsOneWidget);
    expect(find.text('Deutsch.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('selecting words enables the start CTA with a live count', (
    tester,
  ) async {
    await tester.pumpWidget(_harness());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Điền từ vào chỗ trống'));
    await tester.pumpAndSettle();

    expect(find.text('Chọn ít nhất 1 từ để bắt đầu'), findsOneWidget);

    await tester.tap(find.text('lerne'));
    await tester.pump();

    expect(find.text('Bắt đầu luyện nghe — 1 từ'), findsOneWidget);
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
