import 'package:deutschtiger/core/theme/app_theme.dart';
import 'package:deutschtiger/widgets/common/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: Center(child: child)),
    );
  }

  testWidgets('regular size is 40px tall with radius-8 corners', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(AppButton(label: 'Lưu', onPressed: () {})),
    );

    final size = tester.getSize(find.byType(AppButton));
    expect(size.height, 40);

    final material = tester.widget<Material>(
      find.descendant(of: find.byType(AppButton), matching: find.byType(Material)),
    );
    final shape = material.shape as RoundedRectangleBorder;
    expect(shape.borderRadius, BorderRadius.circular(8));
  });

  testWidgets('small size is 36px tall', (tester) async {
    await tester.pumpWidget(
      wrap(
        AppButton(
          label: 'X',
          size: AppButtonSize.small,
          onPressed: () {},
        ),
      ),
    );

    final size = tester.getSize(find.byType(AppButton));
    expect(size.height, 36);
  });

  testWidgets('disabled when onPressed is null', (tester) async {
    await tester.pumpWidget(wrap(const AppButton(label: 'Off', onPressed: null)));

    final inkWell = tester.widget<InkWell>(find.byType(InkWell));
    expect(inkWell.onTap, isNull);
  });

  testWidgets('fires onPressed when tapped', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      wrap(AppButton(label: 'Go', onPressed: () => tapped = true)),
    );

    await tester.tap(find.byType(AppButton));
    await tester.pumpAndSettle();
    expect(tapped, isTrue);
  });
}
