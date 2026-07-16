import 'package:deutschtiger/data/reading/reading_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/reading/read_listen_hub_screen.dart';
import 'package:deutschtiger/screens/reading/reading_feed_screen.dart';
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

  testWidgets('read-listen hub shows tab bar and defaults to Đọc tab', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const ReadListenHubScreen(),
        overrides: [
          readingFeedProvider(
            '',
          ).overrideWith((ref) async => const ReadingFeedResult(articles: [], coverageReady: true)),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Đọc'), findsOneWidget);
    expect(find.text('Nghe'), findsOneWidget);
    expect(find.text('Tin tức'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
