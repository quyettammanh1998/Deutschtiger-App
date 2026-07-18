import 'package:deutschtiger/features/premium/domain/premium_providers.dart';
import 'package:deutschtiger/features/writing/data/goethe_b1_writing_repository.dart';
import 'package:deutschtiger/features/writing/domain/goethe_b1_writing_leaderboard_entry.dart';
import 'package:deutschtiger/features/writing/domain/goethe_b1_writing_topic_summary.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/exam/writing/goethe_b1_writing_topic_list_page.dart';
import 'package:deutschtiger/view_models/exam/exam_ecosystem_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

GoetheB1WritingTeilData _teilData({int extraLocked = 0}) {
  final topics = [
    const GoetheB1WritingTopicSummary(
      slug: 'mein-hobby',
      titleDe: 'Mein Hobby',
      titleVi: 'Sở thích của tôi',
      difficulty: 'easy',
      frequencyStars: 5,
    ),
    const GoetheB1WritingTopicSummary(
      slug: 'meine-familie',
      titleDe: 'Meine Familie',
      titleVi: 'Gia đình tôi',
      difficulty: 'medium',
      frequencyStars: 3,
    ),
    for (var i = 0; i < extraLocked; i++)
      GoetheB1WritingTopicSummary(
        slug: 'locked-$i',
        titleDe: 'Locked $i',
        titleVi: 'Khóa $i',
      ),
  ];
  return GoetheB1WritingTeilData(
    teil: 1,
    titleVi: 'Thư cá nhân',
    topics: topics,
  );
}

void main() {
  testWidgets(
    'renders topic rows with HOT badge, search bar, leaderboard empty state',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            goetheB1WritingTeilProvider(
              1,
            ).overrideWith((ref) async => _teilData()),
            goetheB1WritingTeilResultsProvider(
              1,
            ).overrideWith((ref) async => const []),
            goetheB1WritingLeaderboardProvider(1).overrideWith(
              (ref) async => const <GoetheB1WritingLeaderboardEntry>[],
            ),
            communityExamListProvider(
              const CommunityExamFilter(
                provider: 'goethe',
                skill: 'writing',
                teil: 1,
              ),
            ).overrideWith((ref) async => const []),
            premiumProvider.overrideWith((ref) async => false),
          ],
          child: const MaterialApp(
            locale: Locale('vi'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: GoetheB1WritingTopicListPage(teil: 1),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Mein Hobby'), findsOneWidget);
      expect(find.text('Meine Familie'), findsOneWidget);
      expect(find.text('HOT'), findsOneWidget);
      expect(find.text('Chưa có ai hoàn thành đề nào'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'shows free-limit banner + Premium badge beyond the free-tier cap',
    (tester) async {
      // Tall viewport so the leaderboard + free-limit banner (below 6 topic
      // rows) are actually laid out inside the lazy ListView, not just
      // off-screen and unbuilt.
      tester.view.physicalSize = const Size(800, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            goetheB1WritingTeilProvider(
              1,
            ).overrideWith((ref) async => _teilData(extraLocked: 4)),
            goetheB1WritingTeilResultsProvider(
              1,
            ).overrideWith((ref) async => const []),
            goetheB1WritingLeaderboardProvider(1).overrideWith(
              (ref) async => const <GoetheB1WritingLeaderboardEntry>[],
            ),
            communityExamListProvider(
              const CommunityExamFilter(
                provider: 'goethe',
                skill: 'writing',
                teil: 1,
              ),
            ).overrideWith((ref) async => const []),
            premiumProvider.overrideWith((ref) async => false),
          ],
          child: const MaterialApp(
            locale: Locale('vi'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: GoetheB1WritingTopicListPage(teil: 1),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Bạn đang xem 5 đề miễn phí của Teil 1'),
        findsOneWidget,
      );
      expect(find.text('Premium'), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );
}
