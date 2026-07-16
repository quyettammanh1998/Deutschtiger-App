import 'package:deutschtiger/data/exam/exam_ecosystem_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/exam/writing/goethe_b1_community_writing_list_page.dart';
import 'package:deutschtiger/view_models/exam/exam_ecosystem_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders community topic cards scoped to goethe/writing/teil', (tester) async {
    const filter = CommunityExamFilter(provider: 'goethe', skill: 'writing', teil: 1);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          communityExamListProvider(filter).overrideWith(
            (ref) async => const [
              CommunityExamTopic(
                id: 't1',
                provider: 'goethe',
                level: 'b1',
                skill: 'writing',
                teil: 1,
                titleDe: 'Mein Traumjob',
                titleVi: 'Công việc mơ ước',
                contributorName: 'lan',
                contributorAvatar: '',
                voteCount: 2,
                versionCount: 1,
                isVerified: false,
                createdAt: '2026-01-01T00:00:00Z',
              ),
            ],
          ),
        ],
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: GoetheB1CommunityWritingListPage(teil: 1),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mein Traumjob'), findsOneWidget);
    expect(find.text('Đề cộng đồng · Teil 1'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders empty state with no community topics', (tester) async {
    const filter = CommunityExamFilter(provider: 'goethe', skill: 'writing', teil: 2);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          communityExamListProvider(filter).overrideWith((ref) async => const []),
        ],
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: GoetheB1CommunityWritingListPage(teil: 2),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
