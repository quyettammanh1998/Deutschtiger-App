import 'package:deutschtiger/data/interview/transcript_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/youtube/widgets/dictation_panel.dart';
import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const segments = [
    TranscriptSegment(
      startMs: 0,
      endMs: 2000,
      textDe: 'Hallo Welt',
      textVi: 'Xin chào thế giới',
    ),
    TranscriptSegment(
      startMs: 2000,
      endMs: 4000,
      textDe: 'Wie geht es dir',
      textVi: 'Bạn khoẻ không',
    ),
  ];

  testWidgets('sentence mode: correct answer awards XP and shows diff', (
    tester,
  ) async {
    var seeked = <int>[];
    var awarded = 0;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('vi'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          body: DictationPanel(
            segments: segments,
            onSeek: seeked.add,
            onClose: () {},
            onCorrectSentence: () => awarded++,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(seeked, contains(0));
    expect(find.text('Câu 1/2 · Đúng 0'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Hallo Welt');
    await tester.tap(find.text('Kiểm tra'));
    await tester.pumpAndSettle();

    expect(awarded, 1);
    expect(find.text('Đáp án:'), findsOneWidget);
    expect(find.text('Tiếp →'), findsOneWidget);
  });

  testWidgets('next advances to the following sentence', (tester) async {
    var seeked = <int>[];
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('vi'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          body: DictationPanel(
            segments: segments,
            onSeek: seeked.add,
            onClose: () {},
            onCorrectSentence: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(PhosphorIcons.skipForward));
    await tester.pumpAndSettle();

    expect(find.text('Câu 2/2 · Đúng 0'), findsOneWidget);
    expect(seeked, contains(2000));
  });
}
