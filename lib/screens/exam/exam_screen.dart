import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_tokens.dart';
import '../../features/exam/presentation/widgets/exam_provider_cards.dart';
import '../../l10n/app_localizations.dart';
import '../../view_models/settings/learning_preferences_provider.dart';
import '../../widgets/common/app_button.dart';

/// Web parity: `exam-landing-page.tsx` mobile view — back+title header,
/// buddy-finder CTA, provider/level cards. The old inline catalog filter +
/// flat sample-exam list (Flutter-only IA) is gone: a level pill now pushes
/// the `/exam/:provider-:level` section route, matching web navigation.
class ExamScreen extends ConsumerWidget {
  const ExamScreen({super.key});

  static const _cefrOrder = {'A1': 0, 'A2': 1, 'B1': 2, 'B2': 3, 'C1': 4};

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final userLevel =
        (ref.read(learningPreferencesProvider).preferences?.cefrLevel ?? 'A1')
            .toUpperCase();

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                  color: tokens.foreground,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.examPractice,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: tokens.foreground,
                        ),
                      ),
                      Text(
                        l10n.examLandingSubtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: tokens.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ExamProviderCards(
              onLevelSelected: (provider, level) =>
                  _onLevelSelected(context, l10n, userLevel, provider, level),
            ),
          ],
        ),
      ),
    );
  }

  void _onLevelSelected(
    BuildContext context,
    AppLocalizations l10n,
    String userLevel,
    String provider,
    String level,
  ) {
    final gap = (_cefrOrder[level] ?? 0) - (_cefrOrder[userLevel] ?? 0);
    if (gap >= 2) {
      _showMismatchDialog(context, l10n, userLevel, provider, level);
      return;
    }
    context.push('/exam/${provider.toLowerCase()}-${level.toLowerCase()}');
  }

  void _showMismatchDialog(
    BuildContext context,
    AppLocalizations l10n,
    String userLevel,
    String provider,
    String level,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.examLevelMismatchTitle(userLevel)),
        content: Text(l10n.examLevelMismatchBody(level)),
        actions: [
          AppButton(
            label: l10n.examLevelMismatchCancel,
            variant: AppButtonVariant.outline,
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
          AppGradientButton(
            label: l10n.examLevelMismatchContinue,
            height: 40,
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.push(
                '/exam/${provider.toLowerCase()}-${level.toLowerCase()}',
              );
            },
          ),
        ],
      ),
    );
  }
}
