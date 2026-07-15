import 'package:deutschtiger/features/exam/domain/exam_models.dart';
import 'package:deutschtiger/features/exam/presentation/widgets/exam_mode_toggle.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('exam mode toggle localizes labels and preserves enum callback', (
    tester,
  ) async {
    ExamMode? selected;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('de'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Scaffold(
            body: ExamModeToggle(
              mode: ExamMode.practice,
              onChange: (mode) => selected = mode,
            ),
          ),
        ),
      ),
    );
    expect(find.text('Üben'), findsOneWidget);
    expect(find.text('Test'), findsOneWidget);
    expect(find.text('Prüfen'), findsOneWidget);
    await tester.tap(find.text('Test'));
    expect(selected, ExamMode.test);
    expect(tester.takeException(), isNull);
  });
}
