import 'package:deutschtiger/data/stats/stats_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/stats/error_patterns_page.dart';
import 'package:deutschtiger/view_models/stats/error_patterns_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('error patterns page renders live summary rows', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          errorPatternsSummaryProvider.overrideWith(
            (ref) async => [
              ErrorPatternSummary(
                errorType: 'word_order',
                totalCount: 12,
                exampleOriginal: 'Ich habe gestern gearbeitet nicht.',
                exampleCorrected: 'Ich habe gestern nicht gearbeitet.',
                sources: const ['sprechen'],
              ),
            ],
          ),
        ],
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: ErrorPatternsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Trật tự từ'), findsOneWidget);
    expect(find.text('12 lần'), findsOneWidget);
    expect(find.text('Nói'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('error patterns page shows empty state', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          errorPatternsSummaryProvider.overrideWith((ref) async => const []),
        ],
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: ErrorPatternsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Chưa có dữ liệu lỗi'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('error patterns page shows error view + retry', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          errorPatternsSummaryProvider.overrideWith(
            (ref) async => throw Exception('boom'),
          ),
        ],
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: ErrorPatternsPage(),
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
