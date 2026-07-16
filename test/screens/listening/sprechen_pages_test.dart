import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/previews/preview_auth_service.dart';
import 'package:deutschtiger/screens/listening/sprechen_b1_page.dart';
import 'package:deutschtiger/screens/listening/sprechen_b2_page.dart';
import 'package:deutschtiger/view_models/providers.dart';
import 'package:deutschtiger/view_models/youtube/youtube_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

List<Override> _overrides() => [
      authServiceProvider.overrideWithValue(PreviewAuthService()),
      pendingVideosProvider.overrideWith((ref) async => const []),
      completedVideosProvider.overrideWith((ref) async => const []),
    ];

void main() {
  testWidgets('Sprechen B1 renders tabs + first video from hardcoded list', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: _overrides(),
        child: MaterialApp(
          locale: const Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const SprechenB1Page(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sprechen B1'), findsNWidgets(2)); // breadcrumb + header
    expect(find.textContaining('Teil 1'), findsWidgets);
    expect(find.textContaining('Teil 2'), findsWidgets);
    expect(find.text('Besuch eines Freundes am Wochenende'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Sprechen B2 renders the 79-video hardcoded collection', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: _overrides(),
        child: MaterialApp(
          locale: const Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const SprechenB2Page(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sprechen B2 — Vortrag halten'), findsOneWidget);
    expect(find.textContaining('Sprechen B2'), findsWidgets);
    expect(find.text('Wege nach Ende der Schulzeit'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
