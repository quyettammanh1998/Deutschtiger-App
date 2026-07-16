import 'package:deutschtiger/data/stats/quote_model.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/repositories/settings/learning_preferences_repository.dart';
import 'package:deutschtiger/repositories/stats/daily_quote_repository.dart';
import 'package:deutschtiger/screens/games/game_hub_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeLearningPreferencesRepository
    implements LearningPreferencesRepository {
  @override
  Future<LearningPreferences> get() async =>
      const LearningPreferences(cefrLevel: 'A2');

  @override
  Future<LearningPreferences> save(LearningPreferences preferences) async =>
      preferences;
}

class _FakeDailyQuoteRepository implements DailyQuoteRepository {
  @override
  Future<Quote> getDaily() async =>
      const Quote(id: 'q0', contentDe: 'Alles gut', contentVi: 'Mọi thứ ổn');

  @override
  Future<List<Quote>> getRandom({int limit = 20}) async => const [
        Quote(
          id: 'q1',
          contentDe: 'Übung macht den Meister',
          contentVi: 'Có công mài sắt',
        ),
      ];
}

Widget _app() => ProviderScope(
      overrides: [
        learningPreferencesRepositoryProvider
            .overrideWithValue(_FakeLearningPreferencesRepository()),
        dailyQuoteRepositoryProvider.overrideWithValue(_FakeDailyQuoteRepository()),
      ],
      child: const MaterialApp(
        locale: Locale('vi'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: GameHubScreen(),
      ),
    );

void main() {
  testWidgets('game hub renders level tip, groups and shuffle CTA', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(find.text('Trò chơi'), findsOneWidget);
    expect(find.text('Der/Die/Das'), findsOneWidget);
    expect(find.text('Deutsch Runner'), findsOneWidget);
    expect(find.text('Cases Mastery'), findsOneWidget);
    expect(find.byIcon(Icons.shuffle), findsWidgets);
  });
}
