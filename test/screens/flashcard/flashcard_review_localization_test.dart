import 'package:deutschtiger/data/flashcard/review_item.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/flashcard/widgets/flashcard_view.dart';
import 'package:deutschtiger/screens/flashcard/widgets/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget localized(Widget child) => MaterialApp(
    locale: const Locale('de'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: MediaQuery(
      data: const MediaQueryData(textScaler: TextScaler.linear(2)),
      child: Scaffold(body: child),
    ),
  );

  testWidgets('flashcard prompt and audio semantics localize at 200%', (
    tester,
  ) async {
    await tester.pumpWidget(
      localized(
        FlashcardView(
          item: const ReviewItem(
            cardReviewId: 'card-1',
            contentDe: 'Haus',
            contentVi: 'ngôi nhà',
          ),
          revealed: false,
          onReveal: () {},
          onPlayAudio: (_, _) {},
        ),
      ),
    );

    expect(find.text('Tippe, um die Bedeutung anzuzeigen'), findsOneWidget);
    expect(find.byTooltip('Aussprache anhören'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('flashcard rating labels localize at 200%', (tester) async {
    await tester.pumpWidget(localized(RatingBar(onRate: (_) {})));

    expect(find.text('Nochmals'), findsOneWidget);
    expect(find.text('Schwer'), findsOneWidget);
    expect(find.text('Gut'), findsOneWidget);
    expect(find.text('Leicht'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
