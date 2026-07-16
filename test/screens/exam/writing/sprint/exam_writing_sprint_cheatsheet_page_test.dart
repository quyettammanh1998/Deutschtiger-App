import 'package:deutschtiger/features/writing/data/sprint/sprint_repository.dart';
import 'package:deutschtiger/features/writing/domain/sprint/sprint_types.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/exam/writing/sprint/exam_writing_sprint_cheatsheet_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders overview, Teil tables, redemittel and mistakes sections', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sprintClustersProvider.overrideWith(
            (ref) async => [
              const SprintCluster(id: 'c1', titleDe: 'Cluster 1', titleVi: 'Nhóm 1', count: 2),
            ],
          ),
          sprintTopicsProvider.overrideWith(
            (ref) async => [
              SprintTopicData(
                slug: 'a',
                teil: 1,
                titleDe: 'A',
                taskDe: 'Task A',
                speedrun: SpeedrunContent(
                  outline3: const Outline3(de: ['line1']),
                  miniModel: const MiniModel(de: 'mini'),
                  redemittelCore: const [RedemittelItem(de: 'Liebe Anna,', vi: 'x', function: 'opening')],
                ),
              ),
            ],
          ),
        ],
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: ExamWritingSprintCheatsheetPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Cluster 1'), findsOneWidget);
    expect(find.text('Liebe Anna,'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
