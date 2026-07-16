import 'package:deutschtiger/features/writing/data/official_writing_topic_repository.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/exam/writing/writing_level_topics_page.dart';
import 'package:deutschtiger/view_models/exam/exam_ecosystem_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the empty official-topics state + community section for a known offering', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          officialWritingTopicsProvider.overrideWith((ref, scope) async => const []),
          communityExamListProvider.overrideWith((ref, filter) async => const []),
        ],
        child: MaterialApp(
          locale: const Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const WritingLevelTopicsPage(providerLevel: 'goethe-b2'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Goethe B2 · Viết'), findsOneWidget);
    expect(find.text('Chưa có đề chính thức'), findsOneWidget);
    expect(find.text('Đề cộng đồng'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('unknown provider/level shows the not-found view', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: const Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const WritingLevelTopicsPage(providerLevel: 'nope-x9'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Không tìm thấy trình độ luyện viết này.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
