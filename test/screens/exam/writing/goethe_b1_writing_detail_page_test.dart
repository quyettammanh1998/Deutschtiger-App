import 'package:deutschtiger/features/premium/domain/premium_providers.dart';
import 'package:deutschtiger/features/writing/data/goethe_b1_writing_repository.dart';
import 'package:deutschtiger/features/writing/domain/goethe_b1_writing_topic.dart';
import 'package:deutschtiger/features/writing/domain/goethe_b1_writing_topic_summary.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/exam/writing/goethe_b1_writing_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders header, task card and grammar section for a full-access topic', (tester) async {
    final topic = GoetheB1WritingTopic.fromJson({
      'slug': 'mein-hobby',
      'teil': 1,
      'titleDe': 'Mein Hobby',
      'titleVi': 'Sở thích của tôi',
      'difficulty': 'easy',
      'frequencyStars': 4,
      'task': {'de': 'Schreiben Sie über Ihr Hobby.', 'vi': 'Hãy viết về sở thích của bạn.'},
      'grammarFocus': [
        {'pattern': 'weil-Satz', 'example': 'weil ich Musik mag', 'vi': 'vì tôi thích âm nhạc'},
      ],
      'bodyMarkdown': '',
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          goetheB1WritingTopicProvider((teil: 1, slug: 'mein-hobby')).overrideWith((ref) async => topic),
          goetheB1WritingTeilProvider(1).overrideWith(
            (ref) async => const GoetheB1WritingTeilData(
              teil: 1,
              titleVi: 'T',
              topics: [GoetheB1WritingTopicSummary(slug: 'mein-hobby', titleDe: 'Mein Hobby', titleVi: 'x')],
            ),
          ),
          goetheB1WritingTeilResultsProvider(1).overrideWith((ref) async => const []),
          premiumProvider.overrideWith((ref) async => true),
        ],
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: GoetheB1WritingDetailPage(teil: 1, slug: 'mein-hobby'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mein Hobby'), findsWidgets);
    expect(find.textContaining('Schreiben Sie über Ihr Hobby'), findsOneWidget);
    expect(find.textContaining('📐 Ngữ pháp trọng tâm'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows the premium lock card for a locked topic', (tester) async {
    final topics = [
      const GoetheB1WritingTopicSummary(slug: 'mein-hobby', titleDe: 'Mein Hobby', titleVi: 'x', frequencyStars: 1),
      for (var i = 0; i < 5; i++)
        GoetheB1WritingTopicSummary(slug: 'free-$i', titleDe: 'Free $i', titleVi: 'x', frequencyStars: 5),
    ];
    final topic = GoetheB1WritingTopic.fromJson({
      'slug': 'mein-hobby',
      'teil': 1,
      'titleDe': 'Mein Hobby',
      'titleVi': 'x',
      'task': {'de': 'Aufgabe', 'vi': 'vi'},
      'bodyMarkdown': '',
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          goetheB1WritingTopicProvider((teil: 1, slug: 'mein-hobby')).overrideWith((ref) async => topic),
          goetheB1WritingTeilProvider(1)
              .overrideWith((ref) async => GoetheB1WritingTeilData(teil: 1, titleVi: 'T', topics: topics)),
          goetheB1WritingTeilResultsProvider(1).overrideWith((ref) async => const []),
          premiumProvider.overrideWith((ref) async => false),
        ],
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: GoetheB1WritingDetailPage(teil: 1, slug: 'mein-hobby'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Đề này dành cho tài khoản Premium'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
