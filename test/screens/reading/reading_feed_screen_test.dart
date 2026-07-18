import 'package:deutschtiger/data/reading/reading_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/reading/reading_feed_screen.dart';
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

  const feedArticle = ReadingFeedArticle(
    id: 'a1-cafe',
    slug: 'im-cafe',
    title: 'Im Café',
    level: 'A1',
    topic: 'Alltag',
    summary: 'Anna geht ins Café.',
    vocabTotal: 10,
    vocabKnown: 8,
    vocabNew: 2,
    coverage: 0.8,
    fit: ReadingFeedFit.ideal,
  );

  testWidgets('reading feed shows recommended articles (happy path)', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const ReadingFeedScreen(),
        overrides: [
          readingFeedProvider('').overrideWith(
            (ref) async => const ReadingFeedResult(
              articles: [feedArticle],
              coverageReady: true,
            ),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Im Café'), findsOneWidget);
    expect(find.text('Vừa sức'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('reading feed shows empty state when no matching articles', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const ReadingFeedScreen(),
        overrides: [
          readingFeedProvider('').overrideWith(
            (ref) async =>
                const ReadingFeedResult(articles: [], coverageReady: true),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Chưa có bài đọc phù hợp trình độ của bạn lúc này.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('reading feed shows retry button on load error', (tester) async {
    await tester.pumpWidget(
      wrap(
        const ReadingFeedScreen(),
        overrides: [
          readingFeedProvider('').overrideWith(
            (ref) => Future<ReadingFeedResult>.error('network down'),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(PhosphorIcons.arrowClockwise), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
