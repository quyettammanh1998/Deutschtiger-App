import 'package:deutschtiger/features/vocabulary/domain/vocabulary_models.dart';
import 'package:deutschtiger/features/vocabulary/presentation/vocabulary_word_screen.dart';
import 'package:deutschtiger/features/vocabulary/presentation/widgets/detail_widgets.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const first = LearningItem(
    id: 'one',
    contentDe: 'machen',
    contentVi: 'làm',
    meanings: ['làm', 'thực hiện'],
    createdAt: '',
    updatedAt: '',
  );
  const second = LearningItem(
    id: 'two',
    contentDe: 'lernen',
    contentVi: 'học',
    createdAt: '',
    updatedAt: '',
  );

  testWidgets(
    'word screen advances through the queue via the "Tiếp theo" bottom bar button',
    (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            locale: Locale('vi'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: VocabularyWordScreen(item: first, items: [first, second]),
          ),
        ),
      );

      expect(find.text('machen'), findsWidgets);
      await tester.tap(find.text('Tiếp theo'));
      await tester.pumpAndSettle();

      expect(find.text('lernen'), findsWidgets);
      expect(find.text('2 / 2'), findsOneWidget);
    },
  );

  testWidgets('detail hero flips between the German word and meanings', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(body: VocabHeroCard(item: first)),
        ),
      ),
    );

    await tester.tap(find.byTooltip('Lật thẻ'));
    await tester.pumpAndSettle();

    expect(find.text('• thực hiện'), findsOneWidget);
  });
}
