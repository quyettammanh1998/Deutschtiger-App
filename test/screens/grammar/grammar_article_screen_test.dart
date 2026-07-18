import 'package:deutschtiger/data/grammar/grammar_models.dart';
import 'package:deutschtiger/features/grammar/presentation/grammar_article_screen.dart';
import 'package:deutschtiger/features/grammar/presentation/grammar_provider.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  // `markdown_widget` (article body renderer) uses `VisibilityDetector`
  // internally with a debounced update timer; without a zero interval it
  // leaves a real Timer pending past `pumpAndSettle`, which the test
  // binding flags as a leak on teardown.
  setUpAll(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

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

  const key = (level: 'a1', slug: 'bai-1');
  const article = GrammarArticle(
    title: 'Bài 1',
    level: 'A1',
    slug: 'bai-1',
    markdown: '# Bài 1\n\nNội dung bài đọc đầy đủ.',
  );

  testWidgets('renders article markdown and mark-complete CTA', (tester) async {
    await tester.pumpWidget(
      wrap(
        const GrammarArticleScreen(level: 'a1', slug: 'bai-1'),
        overrides: [
          grammarArticleProvider(key).overrideWith((ref) async => article),
          grammarCompletedIdsProvider.overrideWith((ref) async => <String>[]),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Bài 1'), findsWidgets);
    expect(find.text('Nội dung bài đọc đầy đủ.'), findsOneWidget);
    expect(find.text('Đánh dấu hoàn thành'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows empty state when article is null (404 page)', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const GrammarArticleScreen(level: 'a1', slug: 'bai-1'),
        overrides: [
          grammarArticleProvider(key).overrideWith((ref) async => null),
          grammarCompletedIdsProvider.overrideWith((ref) async => <String>[]),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Không tìm thấy bài viết.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows error view when article fetch throws', (tester) async {
    await tester.pumpWidget(
      wrap(
        const GrammarArticleScreen(level: 'a1', slug: 'bai-1'),
        overrides: [
          grammarArticleProvider(
            key,
          ).overrideWith((ref) => Future<GrammarArticle?>.error('boom')),
          grammarCompletedIdsProvider.overrideWith((ref) async => <String>[]),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(PhosphorIcons.arrowClockwise), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
