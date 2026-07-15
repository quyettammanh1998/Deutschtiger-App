import 'package:deutschtiger/data/stats/quote_model.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/stats/daily_quote_page.dart';
import 'package:deutschtiger/view_models/stats/daily_quote_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('daily quote page renders the live daily quote + history grid', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dailyQuoteProvider.overrideWith(
            (ref) async => const Quote(
              id: '5',
              contentDe: 'Übung macht den Meister.',
              contentVi: 'Có công mài sắt, có ngày nên kim.',
              category: 'Motivation',
            ),
          ),
          quoteHistoryProvider.overrideWith(
            (ref) async => const [
              Quote(
                id: '6',
                contentDe: 'Der Weg ist das Ziel.',
                contentVi: 'Con đường là đích đến.',
                category: 'Philosophy',
              ),
            ],
          ),
        ],
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: DailyQuotePage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('"Übung macht den Meister."'), findsOneWidget);
    expect(find.text('Có công mài sắt, có ngày nên kim.'), findsOneWidget);
    expect(find.text('Der Weg ist das Ziel.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('daily quote page shows error view + retry when quote fails', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dailyQuoteProvider.overrideWith(
            (ref) async => throw Exception('boom'),
          ),
          quoteHistoryProvider.overrideWith((ref) async => const []),
        ],
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: DailyQuotePage(),
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
