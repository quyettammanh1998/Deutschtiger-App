import 'package:deutschtiger/features/writing/data/sprint/sprint_repository.dart';
import 'package:deutschtiger/features/writing/domain/sprint/sprint_types.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/exam/writing/sprint/exam_writing_sprint_mock_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

SprintTopicData _topic(String slug, int teil) => SprintTopicData(
  slug: slug,
  teil: teil,
  titleDe: slug,
  taskDe: 'Task $slug',
  speedrun: SpeedrunContent(outline3: const Outline3(de: ['a']), miniModel: const MiniModel(de: 'mini')),
);

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('picks 1 topic per Teil on first load without a setState-during-build error', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sprintTopicsProvider.overrideWith(
            (ref) async => [_topic('a', 1), _topic('b', 2), _topic('c', 3)],
          ),
        ],
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: ExamWritingSprintMockPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 3 dot-progress indicators = 3 picked topics (1/Teil), essay input for
    // the first one is showing (task label present).
    expect(find.textContaining('Task '), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
