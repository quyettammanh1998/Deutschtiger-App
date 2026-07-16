import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/exam/writing/widgets/hub/writing_submissions_tab.dart';
import 'package:deutschtiger/screens/exam/writing/writing_catalog_page.dart';
import 'package:deutschtiger/view_models/exam/exam_ecosystem_providers.dart';
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

  testWidgets('renders the 3-tab writing hub, defaulting to Bắt đầu', (tester) async {
    await tester.pumpWidget(
      wrap(
        const WritingCatalogPage(),
        overrides: [
          allWritingSubmissionsProvider.overrideWith((ref) async => const []),
          communityExamListProvider.overrideWith((ref, filter) async => const []),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Luyện viết (AI chấm)'), findsOneWidget);
    expect(find.text('Tự nhập đề của bạn'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('switching to "Bài của tôi" shows the empty state', (tester) async {
    await tester.pumpWidget(
      wrap(
        const WritingCatalogPage(),
        overrides: [
          allWritingSubmissionsProvider.overrideWith((ref) async => const []),
          communityExamListProvider.overrideWith((ref, filter) async => const []),
        ],
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Bài của tôi'));
    await tester.pumpAndSettle();

    expect(find.text('Chưa có bài viết nào'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
