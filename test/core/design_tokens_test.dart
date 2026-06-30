import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:deutschtiger/core/design_tokens.dart';

void main() {
  group('DesignTokens', () {
    group('Spacing', () {
      test('xs spacing is 4', () {
        expect(DesignTokens.spacingXs, 4);
      });

      test('sm spacing is 8', () {
        expect(DesignTokens.spacingSm, 8);
      });

      test('md spacing is 16', () {
        expect(DesignTokens.spacingMd, 16);
      });

      test('lg spacing is 24', () {
        expect(DesignTokens.spacingLg, 24);
      });

      test('xl spacing is 32', () {
        expect(DesignTokens.spacingXl, 32);
      });
    });

    group('Colors', () {
      test('primary color exists', () {
        expect(DesignTokens.primary, isNotNull);
      });

      test('primary is a Color', () {
        expect(DesignTokens.primary, isA<Color>());
      });

      test('background color exists', () {
        expect(DesignTokens.background, isNotNull);
      });

      test('foreground color exists', () {
        expect(DesignTokens.foreground, isNotNull);
      });

      test('brand color exists', () {
        expect(DesignTokens.brand, isNotNull);
      });

      test('success color exists', () {
        expect(DesignTokens.success, isNotNull);
      });

      test('error color exists', () {
        expect(DesignTokens.error, isNotNull);
      });
    });

    group('Gradients', () {
      test('primaryGradient has two colors', () {
        expect(DesignTokens.primaryGradient.colors.length, 2);
      });

      test('primaryGradient has orange and rose colors', () {
        final colors = DesignTokens.primaryGradient.colors;
        expect(colors.first, isA<Color>());
        expect(colors.last, isA<Color>());
      });
    });

    group('Animation Durations', () {
      test('fast duration is 120ms', () {
        expect(DesignTokens.durationFast, const Duration(milliseconds: 120));
      });

      test('medium duration is 220ms', () {
        expect(DesignTokens.durationMedium, const Duration(milliseconds: 220));
      });

      test('slow duration is 450ms', () {
        expect(DesignTokens.durationSlow, const Duration(milliseconds: 450));
      });
    });

    group('Border Radii', () {
      test('radius is 16', () {
        expect(DesignTokens.radius, 16);
      });

      test('radiusSm is 8', () {
        expect(DesignTokens.radiusSm, 8);
      });

      test('radiusLg is 24', () {
        expect(DesignTokens.radiusLg, 24);
      });
    });

    group('Typography', () {
      test('buttonText style exists', () {
        expect(DesignTokens.buttonText, isNotNull);
      });

      test('buttonText has correct font size', () {
        expect(DesignTokens.buttonText.fontSize, 16);
      });

      test('buttonText has semibold weight', () {
        expect(DesignTokens.buttonText.fontWeight, FontWeight.w600);
      });
    });
  });
}
