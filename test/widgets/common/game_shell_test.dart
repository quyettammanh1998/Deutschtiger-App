import 'package:deutschtiger/core/theme/app_theme.dart';
import 'package:deutschtiger/widgets/common/game_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('back button shows a destructive confirm dialog before exiting', (
    tester,
  ) async {
    var exited = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: GameShell(
          title: 'Ôn từ',
          onExit: () => exited = true,
          child: const Text('body'),
        ),
      ),
    );

    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();

    expect(find.text('Thoát bài luyện tập?'), findsOneWidget);
    expect(exited, isFalse);

    await tester.tap(find.text('Thoát'));
    await tester.pumpAndSettle();

    expect(exited, isTrue);
  });

  testWidgets('cancelling the confirm dialog keeps the game open', (
    tester,
  ) async {
    var exited = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: GameShell(
          title: 'Ôn từ',
          onExit: () => exited = true,
          child: const Text('body'),
        ),
      ),
    );

    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ở lại'));
    await tester.pumpAndSettle();

    expect(exited, isFalse);
    expect(find.text('body'), findsOneWidget);
  });

  testWidgets('exitGuard=false pops immediately without a dialog', (
    tester,
  ) async {
    var exited = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: GameShell(
          title: 'Ôn từ',
          exitGuard: false,
          onExit: () => exited = true,
          child: const Text('body'),
        ),
      ),
    );

    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();

    expect(find.text('Thoát bài luyện tập?'), findsNothing);
    expect(exited, isTrue);
  });

  testWidgets('renders the title and child body', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: GameShell(title: 'Ôn từ', child: const Text('game body')),
      ),
    );

    expect(find.text('Ôn từ'), findsOneWidget);
    expect(find.text('game body'), findsOneWidget);
  });
}
