import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/design_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../view_models/settings/learning_preferences_provider.dart';
import '../../widgets/common/async_state_views.dart';
import 'widgets/settings_tiles.dart';

/// Learning preferences — CEFR level, daily minutes target, daily XP goal.
/// `GET`/`PUT /api/v1/user/preferences`. Web parity: settings page section
/// with the same three fields (see `LearningPreferencesRepository` doc).
class LearningPreferencesScreen extends ConsumerWidget {
  const LearningPreferencesScreen({super.key});

  static const _levels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(learningPreferencesProvider);
    final notifier = ref.read(learningPreferencesProvider.notifier);

    return Scaffold(
      backgroundColor: DesignTokens.authBackground,
      appBar: AppBar(
        backgroundColor: DesignTokens.authBackground,
        title: Text(
          l10n.learningPreferencesTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: DesignTokens.tigerOrange,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () => context.pop(),
        ),
      ),
      body: state.isLoading
          ? const LoadingView()
          : state.preferences == null
          ? ErrorView(
              message: l10n.learningPreferencesLoadError,
              onRetry: () => ref.invalidate(learningPreferencesProvider),
            )
          : ListView(
              padding: const EdgeInsets.all(DesignTokens.spacingMd),
              children: [
                Text(
                  l10n.learningPreferencesLevel,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: DesignTokens.mutedForeground,
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingSm),
                Wrap(
                  spacing: DesignTokens.spacingSm,
                  children: [
                    for (final level in _levels)
                      ChoiceChip(
                        label: Text(level),
                        selected: state.preferences!.cefrLevel == level,
                        onSelected: (_) => notifier.save(
                          state.preferences!.copyWith(cefrLevel: level),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: DesignTokens.spacingLg),
                SettingsCard(
                  children: [
                    SettingsSliderTile(
                      icon: Icons.timer_outlined,
                      title:
                          '${l10n.learningPreferencesDailyMinutes}: ${state.preferences!.dailyMinutes}',
                      value: (state.preferences!.dailyMinutes / 120).clamp(0.0, 1.0),
                      onChanged: (value) {
                        final minutes = (value * 120).round().clamp(5, 120);
                        notifier.save(
                          state.preferences!.copyWith(dailyMinutes: minutes),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    SettingsSliderTile(
                      icon: Icons.bolt_outlined,
                      title:
                          '${l10n.learningPreferencesDailyXpGoal}: ${state.preferences!.dailyXpGoal}',
                      value: (state.preferences!.dailyXpGoal / 500).clamp(0.0, 1.0),
                      onChanged: (value) {
                        final goal = (value * 500).round().clamp(10, 500);
                        notifier.save(
                          state.preferences!.copyWith(dailyXpGoal: goal),
                        );
                      },
                    ),
                  ],
                ),
                if (state.error == 'save') ...[
                  const SizedBox(height: DesignTokens.spacingMd),
                  Text(
                    l10n.learningPreferencesSaveError,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ],
            ),
    );
  }
}
