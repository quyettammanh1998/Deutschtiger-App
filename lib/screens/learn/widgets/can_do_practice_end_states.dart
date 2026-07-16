import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/common/app_button.dart';
import '../../../widgets/common/app_card.dart';

/// Back link ("← Bản đồ năng lực") shown instead of an AppBar — mirrors web
/// `can-do-practice-page.tsx` header.
class CanDoPracticeBackLink extends StatelessWidget {
  const CanDoPracticeBackLink({super.key, required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pop(),
      child: Text(
        l10n.canDoPracticeBackLink,
        style: TextStyle(fontSize: 12, color: context.tokens.mutedForeground),
      ),
    );
  }
}

/// Shown when [CanDoPracticeScreen.canDoId] doesn't resolve in the map.
class CanDoPracticeNotFound extends StatelessWidget {
  const CanDoPracticeNotFound({super.key, required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.canDoPracticeNotFound, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            AppButton(label: l10n.back, onPressed: () => context.pop()),
          ],
        ),
      ),
    );
  }
}

/// All target blocks already at rung ≥ 2 — nothing left to practice. Mirrors
/// web's all-clear card with a "Luyện hội thoại" gradient CTA.
class CanDoPracticeAllClear extends StatelessWidget {
  const CanDoPracticeAllClear({super.key, required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: AppCard.card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🎉', style: TextStyle(fontSize: 40)),
              const SizedBox(height: 12),
              Text(l10n.canDoPracticeAllClear, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: AppGradientButton(
                  label: l10n.canDoPracticeGoConversation,
                  onPressed: () => context.push('/conversation'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Session finished — mirrors web's done card with a "Về bản đồ năng lực"
/// gradient CTA back to `/learner-model`.
class CanDoPracticeDoneCard extends StatelessWidget {
  const CanDoPracticeDoneCard({
    super.key,
    required this.correct,
    required this.total,
    required this.l10n,
  });

  final int correct;
  final int total;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: AppCard.card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🎯', style: TextStyle(fontSize: 40)),
              const SizedBox(height: 12),
              Text(
                l10n.canDoPracticeDone(correct, total),
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: AppGradientButton(
                  label: l10n.canDoPracticeBackToMap,
                  onPressed: () => context.go('/learner-model'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
