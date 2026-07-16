import 'package:deutschtiger/features/writing/data/goethe_b1_writing_repository.dart';
import 'package:deutschtiger/features/writing/domain/goethe_b1_writing_manifest.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/exam/goethe_b1_writing_teil_pick_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders hero, 3 Teil rows with progress and stat card', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          goetheB1WritingManifestProvider.overrideWith(
            (ref) async => const GoetheB1WritingManifest(
              teils: [
                GoetheB1WritingManifestTeil(teil: 1, titleVi: 'Thư cá nhân', topicCount: 30),
                GoetheB1WritingManifestTeil(teil: 2, titleVi: 'Diễn đàn', topicCount: 25),
                GoetheB1WritingManifestTeil(teil: 3, titleVi: 'Email trang trọng', topicCount: 18),
              ],
            ),
          ),
          goetheB1WritingAllResultsProvider.overrideWith(
            (ref) async => const [
              GoetheB1WritingResult(teil: 1, slug: 'mein-hobby'),
              GoetheB1WritingResult(teil: 1, slug: 'meine-familie'),
            ],
          ),
        ],
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: GoetheB1WritingTeilPickPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Thư cá nhân'), findsOneWidget);
    expect(find.text('Diễn đàn'), findsOneWidget);
    expect(find.text('Email trang trọng'), findsOneWidget);
    // Teil 1 has 2/30 done from the overridden results provider.
    expect(find.text('2/30'), findsOneWidget);
    expect(find.text('0/25'), findsOneWidget);
    // 73 total topics (30+25+18) feeds the hero stat card.
    expect(find.text('73+ chủ đề'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
