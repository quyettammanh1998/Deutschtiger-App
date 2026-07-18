import 'package:deutschtiger/data/listening/podcast_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/previews/preview_auth_service.dart';
import 'package:deutschtiger/screens/listening/easy_german_podcast_page.dart';
import 'package:deutschtiger/view_models/listening/podcast_provider.dart';
import 'package:deutschtiger/view_models/providers.dart';
import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('podcast list renders episodes + completed badge', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authServiceProvider.overrideWithValue(PreviewAuthService()),
          podcastIndexProvider.overrideWith(
            (ref) async => const [
              PodcastEpisode(
                slug: 'ep-1',
                title: 'Im Restaurant',
                duration: 65,
                segments: 4,
              ),
              PodcastEpisode(
                slug: 'ep-2',
                title: 'Am Bahnhof',
                duration: 610,
                segments: 12,
              ),
            ],
          ),
          podcastCompletedIdsProvider.overrideWith((ref) async => ['ep-1']),
          podcastLeaderboardProvider.overrideWith((ref) async => const []),
          podcastUserRankProvider.overrideWith((ref) async => null),
        ],
        child: MaterialApp(
          locale: const Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const EasyGermanPodcastPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Im Restaurant'), findsOneWidget);
    expect(find.text('Am Bahnhof'), findsOneWidget);
    expect(find.byIcon(PhosphorIcons.check), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('podcast list shows empty state when search matches nothing', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authServiceProvider.overrideWithValue(PreviewAuthService()),
          podcastIndexProvider.overrideWith(
            (ref) async => const [
              PodcastEpisode(
                slug: 'ep-1',
                title: 'Im Restaurant',
                duration: 65,
                segments: 4,
              ),
            ],
          ),
          podcastCompletedIdsProvider.overrideWith((ref) async => const []),
          podcastLeaderboardProvider.overrideWith((ref) async => const []),
          podcastUserRankProvider.overrideWith((ref) async => null),
        ],
        child: MaterialApp(
          locale: const Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const EasyGermanPodcastPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'zzz-no-match');
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Không tìm thấy tập nào khớp với'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('podcast list shows error view + retry when index fails', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          podcastIndexProvider.overrideWith(
            (ref) async => throw Exception('boom'),
          ),
          podcastCompletedIdsProvider.overrideWith((ref) async => const []),
        ],
        child: MaterialApp(
          locale: const Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const EasyGermanPodcastPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Không thể tải danh sách tập. Vui lòng thử lại sau.'),
      findsOneWidget,
    );
    expect(find.text('Thử lại'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
