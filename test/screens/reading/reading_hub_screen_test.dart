import 'package:deutschtiger/data/reading/reading_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/reading/reading_hub_screen.dart';
import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
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

  const article = ReadingArticleSummary(
    id: 'a1-cafe',
    slug: 'im-cafe',
    sourceUrl: 'https://x',
    sourceSite: 'fluencydrop',
    topic: 'Alltag',
    level: 'A1',
    title: 'Im Café',
    summary: 'Anna geht ins Café.',
  );

  testWidgets('reading hub shows articles grouped by level (happy path)', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const ReadingHubScreen(),
        overrides: [
          readingArticlesProvider.overrideWith((ref) async => [article]),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Im Café'), findsOneWidget);
    expect(find.textContaining('bài đọc'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('reading hub shows empty state when no articles', (tester) async {
    await tester.pumpWidget(
      wrap(
        const ReadingHubScreen(),
        overrides: [
          readingArticlesProvider.overrideWith(
            (ref) async => <ReadingArticleSummary>[],
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    // Không còn empty-state chặn toàn màn — hub luôn hiện lưới 6 level card,
    // mỗi card rỗng hiện "Chưa có bài đọc" (mirror `reading-home.tsx`).
    expect(find.text('Chưa có bài đọc'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('reading hub shows retry button on load error', (tester) async {
    await tester.pumpWidget(
      wrap(
        const ReadingHubScreen(),
        overrides: [
          readingArticlesProvider.overrideWith(
            (ref) => Future<List<ReadingArticleSummary>>.error('network down'),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(PhosphorIcons.arrowClockwise), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
