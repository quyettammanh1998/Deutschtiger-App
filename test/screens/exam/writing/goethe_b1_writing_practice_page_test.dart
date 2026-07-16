import 'package:deutschtiger/features/writing/data/goethe_b1_writing_repository.dart';
import 'package:deutschtiger/features/writing/domain/goethe_b1_writing_topic.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/exam/writing/goethe_b1_writing_practice_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('wraps WritingPracticePanel with the prompt card for a valid task topic', (tester) async {
    final topic = GoetheB1WritingTopic.fromJson({
      'slug': 'mein-hobby',
      'teil': 1,
      'titleDe': 'Mein Hobby',
      'titleVi': 'x',
      'task': {'de': 'Schreiben Sie über Ihr Hobby.', 'vi': 'vi'},
      'taskAnalysis': {
        'summaryVi': '',
        'points': [
          {'de': 'Nennen Sie Ihr Hobby', 'vi': 'Nêu sở thích'},
        ],
      },
      'bodyMarkdown': '',
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          goetheB1WritingTopicProvider((teil: 1, slug: 'mein-hobby')).overrideWith((ref) async => topic),
        ],
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: GoetheB1WritingPracticePage(teil: 1, slug: 'mein-hobby'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mein Hobby'), findsWidgets);
    expect(find.text('Aufgabe'), findsOneWidget);
    expect(find.textContaining('Schreiben Sie über Ihr Hobby'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows a not-found message for an intro topic', (tester) async {
    final topic = GoetheB1WritingTopic.fromJson({
      'slug': 'intro',
      'teil': 1,
      'titleDe': 'Intro',
      'titleVi': 'x',
      'isIntro': true,
      'bodyMarkdown': '# intro',
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          goetheB1WritingTopicProvider((teil: 1, slug: 'intro')).overrideWith((ref) async => topic),
        ],
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: GoetheB1WritingPracticePage(teil: 1, slug: 'intro'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Không tìm thấy đề viết.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
