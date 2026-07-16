import 'package:deutschtiger/data/listening/easy_german_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/previews/preview_auth_service.dart';
import 'package:deutschtiger/screens/listening/easy_german_level_page.dart';
import 'package:deutschtiger/view_models/listening/easy_german_provider.dart';
import 'package:deutschtiger/view_models/providers.dart';
import 'package:deutschtiger/view_models/youtube/youtube_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders level videos from the static index', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authServiceProvider.overrideWithValue(PreviewAuthService()),
          easyGermanIndexProvider('a1').overrideWith(
            (ref) async => const [
              EasyGermanVideo(videoId: 'abc12345678', title: 'Folge 1', segments: 40),
            ],
          ),
          pendingVideosProvider.overrideWith((ref) async => const []),
          completedVideosProvider.overrideWith((ref) async => const []),
        ],
        child: MaterialApp(
          locale: const Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const EasyGermanLevelPage(level: 'a1'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Easy German A1'), findsNWidgets(2)); // breadcrumb + header
    expect(find.text('Folge 1'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows error state when the index fails to load', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authServiceProvider.overrideWithValue(PreviewAuthService()),
          easyGermanIndexProvider('b1').overrideWith((ref) async => throw Exception('boom')),
          pendingVideosProvider.overrideWith((ref) async => const []),
          completedVideosProvider.overrideWith((ref) async => const []),
        ],
        child: MaterialApp(
          locale: const Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const EasyGermanLevelPage(level: 'b1'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Không thể tải danh sách video. Vui lòng thử lại sau.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
