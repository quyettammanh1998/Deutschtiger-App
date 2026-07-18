import 'package:deutschtiger/data/vocab/vocab_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/games/listening_game_screen.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/audio_service.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:deutschtiger/view_models/games/listening_game_provider.dart';
import 'package:deutschtiger/view_models/providers.dart';
import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _app = MaterialApp(
  locale: Locale('vi'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  home: ListeningGameScreen(),
);

const _words = [
  VocabWord(id: '1', word: 'Haus', translation: 'Nhà'),
  VocabWord(id: '2', word: 'Buch', translation: 'Sách'),
  VocabWord(id: '3', word: 'Wasser', translation: 'Nước'),
  VocabWord(id: '4', word: 'Auto', translation: 'Ô tô'),
];

void main() {
  testWidgets('listening game renders live learned words as a quiz', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          listeningGameWordsProvider.overrideWith((ref) async => _words),
          audioServiceProvider.overrideWithValue(_FakeAudioService()),
        ],
        child: _app,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Nghe từ và chọn nghĩa đúng'), findsOneWidget);
    // 4 meaning options rendered (1 correct + 3 distractors).
    expect(
      _words
          .where((w) => find.text(w.translation).evaluate().isNotEmpty)
          .length,
      4,
    );
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('listening game shows error view + retry on fetch failure', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          listeningGameWordsProvider.overrideWith(
            (ref) async => throw Exception('boom'),
          ),
        ],
        child: _app,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(PhosphorIcons.cloudSlash), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'listening game shows a guidance message when too few words are learned',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            listeningGameWordsProvider.overrideWith(
              (ref) async => _words.take(2).toList(),
            ),
          ],
          child: _app,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Cần học ít nhất 4 từ'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}

class _FakeAudioService extends AudioService {
  _FakeAudioService()
    : super(
        ApiClient(
          baseUrl: 'https://example.test/api/v1',
          tokenProvider: _NoTokenProvider(),
        ),
      );

  @override
  Future<bool> play({String? audioUrl, required String text}) async => true;

  @override
  Future<void> stop() async {}

  @override
  Future<void> dispose() async {}
}

class _NoTokenProvider implements TokenProvider {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> refresh() async => null;
}
