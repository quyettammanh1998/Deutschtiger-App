import 'package:deutschtiger/data/learn/learn_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/learn/focus_session_screen.dart';
import 'package:deutschtiger/view_models/learn/learn_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => ProviderScope(
    overrides: [focusSessionProvider.overrideWith((ref) async => _data)],
    child: MaterialApp(
      locale: const Locale('vi'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: child,
    ),
  );

  testWidgets('focus session screen renders due words + weaknesses', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(const FocusSessionScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Tập trung hôm nay'), findsOneWidget);
    expect(find.text('Từ tới hạn ôn'), findsOneWidget);
    expect(find.text('Hund'), findsOneWidget);
    expect(find.text('Chia động từ'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('focus session screen shows caught-up empty state', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          focusSessionProvider.overrideWith(
            (ref) async => const FocusSessionData(
              dueWords: [],
              examFailWords: [],
              subtitleWords: [],
              weaknesses: [],
            ),
          ),
        ],
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: FocusSessionScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Bạn đang rất ổn!'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('focus session screen shows error view + retry', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          focusSessionProvider.overrideWith(
            (ref) async => throw Exception('boom'),
          ),
        ],
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: FocusSessionScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Không tải được dữ liệu. Vui lòng thử lại.'), findsOneWidget);
    expect(find.text('Thử lại'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

const _data = FocusSessionData(
  dueWords: [
    FocusReviewWord(id: 'r1', contentDe: 'Hund', contentVi: 'chó'),
  ],
  examFailWords: [],
  subtitleWords: [],
  weaknesses: [
    FocusWeakness(errorType: 'verb_conjugation', count: 3),
  ],
);
