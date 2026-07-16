import 'package:deutschtiger/features/writing/data/sprint/sprint_repository.dart';
import 'package:deutschtiger/features/writing/domain/sprint/sprint_types.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/exam/writing/sprint/exam_writing_sprint_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

SprintTopicData _topic(String slug, int teil) => SprintTopicData(
  slug: slug,
  teil: teil,
  titleDe: slug,
  taskDe: 'Task $slug',
  speedrun: SpeedrunContent(
    outline3: const Outline3(de: ['a', 'b', 'c']),
    miniModel: const MiniModel(de: 'mini'),
  ),
);

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('renders mode picker + start button with topic count, no resume state', (tester) async {
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
          home: ExamWritingSprintPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Marathon'), findsOneWidget);
    expect(find.text('Hằng ngày'), findsOneWidget);
    expect(find.textContaining('Bắt đầu — 3'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
