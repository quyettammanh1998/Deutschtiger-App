import 'package:deutschtiger/features/exam/presentation/widgets/exam_audio_controls.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('audio controls localize labels and expose the play action', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('de'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Scaffold(
            body: Column(
              children: [
                AudioPlayPauseButton(
                  isPlaying: false,
                  isLoading: false,
                  canPlayMore: true,
                  onTap: () => taps++,
                ),
                const AudioPlayCounter(used: 1, max: 2),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.bySemanticsLabel('Audio abspielen'), findsOneWidget);
    expect(find.text('1/2 Wiedergaben · noch 1'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Audio abspielen'));
    expect(taps, 1);
  });
}
