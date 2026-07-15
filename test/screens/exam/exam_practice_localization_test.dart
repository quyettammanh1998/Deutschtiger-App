import 'package:deutschtiger/features/exam/domain/exam_models.dart';
import 'package:deutschtiger/features/exam/presentation/exam_player_provider.dart';
import 'package:deutschtiger/features/exam/presentation/exam_practice_page.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'exam bootstrap failure stays localized and hides provider detail',
    (tester) async {
      const key = ExamPlayerKey(
        examId: 'missing-exam',
        mode: ExamMode.practice,
        timed: false,
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            examPlayerBootstrapProvider(
              key,
            ).overrideWith((ref) => Future.error(StateError('private detail'))),
          ],
          child: MaterialApp(
            locale: const Locale('de'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: const MediaQuery(
              data: MediaQueryData(textScaler: TextScaler.linear(2)),
              child: ExamPracticePage(examId: 'missing-exam'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text(
          'Prüfungen konnten nicht geladen werden. Bitte versuche es erneut.',
        ),
        findsOneWidget,
      );
      expect(find.textContaining('private detail'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}
