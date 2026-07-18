import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/settings/learning_preferences_repository.dart';
import '../../view_models/settings/learning_preferences_provider.dart';
import '../../widgets/common/async_state_views.dart';
import 'widgets/review_display_card.dart';
import 'widgets/settings_tiles.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Mục tiêu học tập — web parity: `settings-learning-page.tsx`
/// (`SettingsLearningPreferencesSection` + `SettingsReviewDisplaySection`).
/// `GET`/`PUT /api/v1/user/preferences`. CEFR chips, 5 goal chips, 4
/// daily-minute presets (with computed XP/words-per-day), then the
/// per-device review-display toggles.
class LearningPreferencesScreen extends ConsumerWidget {
  const LearningPreferencesScreen({super.key});

  static const _levels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
  static const _minutePresets = [5, 10, 15, 30];

  // Mirrors web `DAILY_XP_MAP` / `calculateWordsPerDay`
  // (`user-preferences-service.ts`) — an estimated (not backend-derived)
  // preview of what each minute preset implies.
  static const _xpByMinutes = {5: 15, 10: 30, 15: 50, 30: 75};
  static const _wordsByMinutes = {5: 8, 10: 12, 15: 15, 30: 20};

  int _xpFor(int minutes) => _xpByMinutes[minutes] ?? 30;
  int _wordsFor(int minutes) => _wordsByMinutes[minutes] ?? 12;

  static const _goalValues = learningGoalValues;

  String _goalLabel(AppLocalizations l10n, String value) => switch (value) {
    'goethe' => l10n.learningPreferencesGoalGoethe,
    'communication' => l10n.learningPreferencesGoalCommunication,
    'medical' => l10n.learningPreferencesGoalMedical,
    'work' => l10n.learningPreferencesGoalWork,
    _ => l10n.learningPreferencesGoalOther,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(learningPreferencesProvider);
    final notifier = ref.read(learningPreferencesProvider.notifier);

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: state.isLoading
            ? const LoadingView()
            : state.preferences == null
            ? ErrorView(
                message: l10n.learningPreferencesLoadError,
                onRetry: () => ref.invalidate(learningPreferencesProvider),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(PhosphorIcons.arrowLeft, color: tokens.foreground),
                        onPressed: () => context.pop(),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          l10n.learningPreferencesTitle,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: tokens.foreground,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: tokens.card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: tokens.border.withValues(alpha: 0.5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SettingsCardLabel(l10n.learningPreferencesTitle),
                        Text(
                          l10n.learningPreferencesLevel,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: tokens.foreground,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final level in _levels)
                              SettingsChoiceChip(
                                label: level,
                                selected: state.preferences!.cefrLevel == level,
                                onTap: () => notifier
                                    .save(state.preferences!.copyWith(cefrLevel: level)),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.learningPreferencesGoalsLabel,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: tokens.foreground,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final goal in _goalValues)
                              SettingsChoiceChip(
                                label: _goalLabel(l10n, goal),
                                selected: state.preferences!.learningGoals.contains(goal),
                                onTap: () {
                                  final current = state.preferences!.learningGoals;
                                  final next = current.contains(goal)
                                      ? current.where((g) => g != goal).toList()
                                      : [...current, goal];
                                  notifier.save(
                                    state.preferences!.copyWith(learningGoals: next),
                                  );
                                },
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.learningPreferencesMinutesLabel,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: tokens.foreground,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            for (final minutes in _minutePresets) ...[
                              Expanded(
                                child: SettingsChoiceChip(
                                  label:
                                      '${minutes == 30 ? '30+' : minutes} ${l10n.minutesUnit}',
                                  selected: state.preferences!.dailyMinutes == minutes,
                                  onTap: () => notifier.save(
                                    state.preferences!.copyWith(
                                      dailyMinutes: minutes,
                                      dailyXpGoal: _xpFor(minutes),
                                    ),
                                  ),
                                ),
                              ),
                              if (minutes != _minutePresets.last) const SizedBox(width: 8),
                            ],
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.learningPreferencesXpSummary(
                            _xpFor(state.preferences!.dailyMinutes),
                            _wordsFor(state.preferences!.dailyMinutes),
                          ),
                          style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                        ),
                        if (state.error == 'save') ...[
                          const SizedBox(height: 12),
                          Text(
                            l10n.learningPreferencesSaveError,
                            style: TextStyle(fontSize: 12, color: tokens.destructive),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const ReviewDisplayCard(),
                ],
              ),
      ),
    );
  }
}
