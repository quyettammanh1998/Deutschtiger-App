import 'package:deutschtiger/data/games/sentence_builder_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/games/sentence_builder/sentence_builder_topics_screen.dart';
import 'package:deutschtiger/view_models/games/sentence_builder_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _app = MaterialApp(
  locale: Locale('vi'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  home: SentenceBuilderTopicsScreen(),
);

void main() {
  testWidgets('sentence builder topics screen renders live topics', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sentenceBuilderTopicsProvider.overrideWith(
            (ref, level) async => [
              SentenceBuilderTopic(
                id: 't1',
                key: 'essen',
                label: 'Food',
                labelVi: 'Ăn uống',
                icon: 'book',
                wordCount: 12,
                essentialWordCount: 5,
              ),
            ],
          ),
        ],
        child: _app,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ăn uống'), findsOneWidget);
    expect(find.text('12 từ'), findsOneWidget);
    expect(find.text('Ngẫu nhiên'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('sentence builder topics screen shows error view + retry', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sentenceBuilderTopicsProvider.overrideWith(
            (ref, level) async => throw Exception('boom'),
          ),
        ],
        child: _app,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.cloud_off_outlined), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('sentence builder topics screen shows empty state', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sentenceBuilderTopicsProvider.overrideWith(
            (ref, level) async => const [],
          ),
        ],
        child: _app,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Chưa có chủ đề nào cho cấp độ này.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
