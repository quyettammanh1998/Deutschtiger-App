// Regression test for the hardcoded-color dark-mode gap: several shared
// panel widgets used to paint their surfaces with literal `Colors.white`/
// `Colors.grey.shade*` regardless of theme, so they rendered light-coloured
// panels even under the dark theme. This asserts panel surfaces resolve
// from [AppTokens] (dark tokens under a dark theme), not a hardcoded light
// literal. Mirrors the light-vs-dark approach in
// `test/widgets/common/app_card_test.dart`.
import 'package:deutschtiger/core/theme/app_theme.dart';
import 'package:deutschtiger/core/theme/app_tokens.dart';
import 'package:deutschtiger/widgets/dashboard/streak_claim_modal.dart';
import 'package:deutschtiger/widgets/vocab_search/vocabulary_detail_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('dark mode surface colors', () {
    testWidgets(
      'StreakClaimModal panel background resolves to AppTokens.dark.card, '
      'not a hardcoded white literal',
      (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              theme: AppTheme.dark,
              home: Scaffold(
                body: StreakClaimModal(open: true, onClose: () {}),
              ),
            ),
          ),
        );
        await tester.pump();

        final panel = tester.widgetList<Container>(find.byType(Container)).firstWhere(
          (c) =>
              c.decoration is BoxDecoration &&
              (c.decoration as BoxDecoration).borderRadius ==
                  BorderRadius.circular(24),
        );
        final decoration = panel.decoration as BoxDecoration;

        expect(decoration.color, AppTokens.dark.card);
        expect(decoration.color, isNot(Colors.white));
      },
    );

    testWidgets(
      'VocabularyDetailPanel meaning box resolves to AppTokens.dark.muted, '
      'not a hardcoded grey.shade50 literal',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.dark,
            home: const Scaffold(
              body: VocabularyDetailPanel(
                word: 'Haus',
                translation: 'nhà',
              ),
            ),
          ),
        );
        await tester.pump();

        final containers = tester
            .widgetList<Container>(find.byType(Container))
            .where((c) => c.decoration is BoxDecoration)
            .map((c) => c.decoration as BoxDecoration);

        // The "Nghĩa" (meaning) box uses context.tokens.muted for its fill.
        expect(
          containers.any((d) => d.color == AppTokens.dark.muted),
          isTrue,
          reason: 'expected at least one panel surface using AppTokens.dark.muted',
        );
        expect(
          containers.any((d) => d.color == const Color(0xFFFAFAFA)), // grey.shade50
          isFalse,
          reason: 'no surface should still use the old hardcoded grey.shade50',
        );
      },
    );
  });
}
