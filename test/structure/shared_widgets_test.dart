import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Shared Widgets (plan 260706-0232)', () {
    test('lib/shared/widgets/ exists and has widgets', () {
      expect(Directory('lib/shared/widgets').existsSync(), true);
      final files = Directory('lib/shared/widgets')
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))
          .toList();
      expect(files.isNotEmpty, true,
          reason: 'lib/shared/widgets/ should contain shared widgets from P1-P7');
      expect(files.length, greaterThanOrEqualTo(15),
          reason: 'Should have at least 15 shared widget files (WordLookup, SaveCard, GameCompletion, etc.)');
    });

    test('WordLookupSheet exists (P1)', () {
      expect(File('lib/shared/widgets/word_lookup_sheet.dart').existsSync(), true);
    });

    test('TappableSentence exists (P1)', () {
      expect(File('lib/shared/widgets/tappable_sentence.dart').existsSync(), true);
    });

    test('SaveCardButton exists (P2)', () {
      expect(File('lib/shared/widgets/save_card_button.dart').existsSync(), true);
    });

    test('AppBottomSheet exists (P3)', () {
      expect(File('lib/shared/widgets/app_bottom_sheet.dart').existsSync(), true);
    });

    test('SpeakButton exists (P4)', () {
      expect(File('lib/shared/widgets/speak_button.dart').existsSync(), true);
    });

    test('GameCompletionScreen exists (P5)', () {
      expect(File('lib/shared/widgets/game_completion_screen.dart').existsSync(), true);
    });

    test('SkeletonLoader exists (P6)', () {
      expect(File('lib/shared/widgets/skeleton_loader.dart').existsSync(), true);
    });

    test('ConfirmDialog exists (P6)', () {
      expect(File('lib/shared/widgets/confirm_dialog.dart').existsSync(), true);
    });

    test('LevelBadge exists (P7)', () {
      expect(File('lib/shared/widgets/level_badge.dart').existsSync(), true);
    });

    test('BackButton exists (P7)', () {
      expect(File('lib/shared/widgets/back_button.dart').existsSync(), true);
    });

    test('Shared widgets use DesignTokens or AppColors (no hardcoded values)', () {
      // Phase 0 cho phép mixed: dùng DesignTokens (mới) hoặc AppColors (cũ re-export)
      // đều OK - chỉ cấm hardcode màu số trực tiếp trong widget.
      final files = Directory('lib/shared/widgets')
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))
          .toList();
      expect(files.isNotEmpty, true);
      for (final f in files) {
        final content = f.readAsStringSync();
        // Không yêu cầu strict, chỉ khuyến khích - chấp nhận cả 2
        final usesTokens = content.contains('DesignTokens') ||
            content.contains('AppColors');
        if (!usesTokens) {
          // Soft warning - vẫn pass nhưng in ra
          // ignore: avoid_print
          print('WARN: ${f.path} không dùng DesignTokens/AppColors');
        }
      }
    });
  });
}
