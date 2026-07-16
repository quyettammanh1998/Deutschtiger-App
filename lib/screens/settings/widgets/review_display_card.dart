import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../view_models/settings/review_display_prefs_provider.dart';
import 'settings_tiles.dart';

/// "Hiển thị ôn tập" card — web parity: `settings-review-display-section.tsx`.
/// Per-device toggles, not synced ([ReviewDisplayPrefsNotifier]).
class ReviewDisplayCard extends ConsumerWidget {
  const ReviewDisplayCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final prefs = ref.watch(reviewDisplayPrefsProvider);
    final notifier = ref.read(reviewDisplayPrefsProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tokens.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.reviewDisplayTitle,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: tokens.foreground),
          ),
          const SizedBox(height: 8),
          SettingsToggleRow(
            label: l10n.reviewDisplayAutoAdvance,
            description: l10n.reviewDisplayAutoAdvanceDesc,
            value: prefs.autoAdvance,
            onChanged: notifier.setAutoAdvance,
          ),
          SettingsToggleRow(
            label: l10n.reviewDisplay4Button,
            description: l10n.reviewDisplay4ButtonDesc,
            value: prefs.show4Button,
            onChanged: notifier.setShow4Button,
            topBorder: true,
          ),
          SettingsToggleRow(
            label: l10n.reviewDisplayContext,
            description: l10n.reviewDisplayContextDesc,
            value: prefs.showContext,
            onChanged: notifier.setShowContext,
            topBorder: true,
          ),
        ],
      ),
    );
  }
}
