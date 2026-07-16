import 'package:deutschtiger/core/theme/app_theme.dart';
import 'package:deutschtiger/widgets/common/app_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(ThemeData theme, Widget child) {
    return MaterialApp(theme: theme, home: Scaffold(body: Center(child: child)));
  }

  BoxDecoration decorationOf(WidgetTester tester) {
    final container = tester.widget<AnimatedContainer>(
      find.byType(AnimatedContainer),
    );
    return container.decoration as BoxDecoration;
  }

  testWidgets('light .card has a transparent border and a soft shadow', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(AppTheme.light, const AppCard.card(child: Text('hi'))),
    );

    final decoration = decorationOf(tester);
    expect(decoration.border, isA<Border>());
    final border = decoration.border as Border;
    expect(border.top.color, Colors.transparent);
    expect(decoration.boxShadow, isNotEmpty);
  });

  testWidgets('dark .card has a visible border', (tester) async {
    await tester.pumpWidget(
      wrap(AppTheme.dark, const AppCard.card(child: Text('hi'))),
    );

    final decoration = decorationOf(tester);
    final border = decoration.border as Border;
    expect(border.top.color, isNot(Colors.transparent));
    expect(decoration.boxShadow, isNotEmpty);
  });

  testWidgets('.card-sm always has a visible border in light mode', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(AppTheme.light, const AppCard.small(child: Text('hi'))),
    );

    final decoration = decorationOf(tester);
    final border = decoration.border as Border;
    expect(border.top.color, isNot(Colors.transparent));
  });

  testWidgets('interactive card fires onTap', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      wrap(
        AppTheme.light,
        AppCard.interactive(onTap: () => tapped = true, child: const Text('hi')),
      ),
    );

    await tester.tap(find.byType(AppCard));
    await tester.pumpAndSettle();
    expect(tapped, isTrue);
  });
}
