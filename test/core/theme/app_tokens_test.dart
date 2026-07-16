import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:deutschtiger/core/theme/app_theme.dart';
import 'package:deutschtiger/core/theme/app_tokens.dart';

void main() {
  group('AppTokens', () {
    test('light primary matches web hsl(32, 93%, 54%) orange', () {
      expect(AppTokens.light.primary, const Color(0xFFF7911D));
    });

    test('dark primary matches web hsl(200, 85%, 65%) blue', () {
      expect(AppTokens.dark.primary, const Color(0xFF5ABFF2));
    });

    test('radius mirrors web --radius: 1rem (16px)', () {
      expect(AppTokens.light.radius, 16.0);
      expect(AppTokens.dark.radius, 16.0);
    });

    testWidgets('resolves from AppTheme.light via context.tokens', (
      tester,
    ) async {
      late BuildContext capturedContext;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(capturedContext.tokens.primary, const Color(0xFFF7911D));
      expect(capturedContext.tokens.background, AppTokens.light.background);
    });

    testWidgets('resolves from AppTheme.dark via context.tokens', (
      tester,
    ) async {
      late BuildContext capturedContext;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark,
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(capturedContext.tokens.primary, const Color(0xFF5ABFF2));
      expect(capturedContext.tokens.background, AppTokens.dark.background);
    });

    testWidgets('falls back to AppTokens.light when extension missing', (
      tester,
    ) async {
      late BuildContext capturedContext;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(), // no AppTokens extension registered
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(capturedContext.tokens.primary, AppTokens.light.primary);
    });

    test('lerp interpolates colors and radius between light and dark', () {
      final midpoint = AppTokens.light.lerp(AppTokens.dark, 0.5);

      expect(
        midpoint.primary,
        Color.lerp(AppTokens.light.primary, AppTokens.dark.primary, 0.5),
      );
      expect(midpoint.radius, 16.0); // both themes share the same radius
    });

    test('lerp returns this when other extension is null/mismatched', () {
      final result = AppTokens.light.lerp(null, 0.5);
      expect(result, AppTokens.light);
    });

    test('copyWith overrides only the given fields', () {
      final tweaked = AppTokens.light.copyWith(primary: Colors.purple);
      expect(tweaked.primary, Colors.purple);
      expect(tweaked.background, AppTokens.light.background);
      expect(tweaked.radius, AppTokens.light.radius);
    });
  });
}
