import 'package:deutschtiger/data/exam/exam_ecosystem_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/exam/community_exams_list_screen.dart';
import 'package:deutschtiger/view_models/exam/exam_ecosystem_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _filter = CommunityExamFilter();

void main() {
  testWidgets('renders community exam cards when topics exist', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          communityExamListProvider(_filter).overrideWith(
            (ref) async => const [
              CommunityExamTopic(
                id: 't1',
                provider: 'goethe',
                level: 'b1',
                skill: 'schreiben',
                teil: 2,
                titleDe: 'Meine Familie',
                titleVi: 'Gia đình tôi',
                contributorName: 'Bình',
                contributorAvatar: '',
                voteCount: 3,
                versionCount: 1,
                isVerified: true,
                createdAt: '2026-07-01T00:00:00Z',
              ),
            ],
          ),
        ],
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: CommunityExamsListScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Meine Familie'), findsOneWidget);
    expect(find.text('Gia đình tôi'), findsOneWidget);
    expect(find.text('Bình'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows the empty state when there are no topics', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          communityExamListProvider(_filter).overrideWith((ref) async => []),
        ],
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: CommunityExamsListScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Chưa có đề thi cộng đồng nào.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows the error view + retry button when the fetch fails', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          communityExamListProvider(
            _filter,
          ).overrideWith((ref) async => throw Exception('boom')),
        ],
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: CommunityExamsListScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Không tải được dữ liệu. Vui lòng thử lại.'),
      findsOneWidget,
    );
    expect(find.text('Thử lại'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
