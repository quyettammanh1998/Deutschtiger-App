import 'package:deutschtiger/features/writing/domain/writing_submission.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/exam/writing/widgets/hub/writing_submissions_tab.dart';
import 'package:deutschtiger/screens/exam/writing/writing_session_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child, {List<Override> overrides = const []}) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        locale: const Locale('vi'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: child,
      ),
    );
  }

  testWidgets('shows not-found state when the submission id is unknown', (tester) async {
    await tester.pumpWidget(
      wrap(
        const WritingSessionDetailPage(submissionId: 'missing-id'),
        overrides: [allWritingSubmissionsProvider.overrideWith((ref) async => const [])],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Không tìm thấy bài viết này'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders task/answer + Luyện lại for a Goethe B1 submission', (tester) async {
    final submission = WritingSubmission.fromJson({
      'id': 'sub-1',
      'exam_id': 'goethe-b1-writing-teil-1/urlaub-email/schreiben',
      'task_prompt': 'Schreiben Sie eine E-Mail über Ihren Urlaub.',
      'student_answer': 'Liebe Anna, ich war im Urlaub...',
      'ai_score': 78,
      'submitted_at': '2026-07-10T10:00:00Z',
    });

    await tester.pumpWidget(
      wrap(
        const WritingSessionDetailPage(submissionId: 'sub-1'),
        overrides: [allWritingSubmissionsProvider.overrideWith((ref) async => [submission])],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Luyện lại'), findsOneWidget);
    expect(find.textContaining('Schreiben Sie eine E-Mail'), findsOneWidget);
    expect(find.textContaining('Liebe Anna'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
