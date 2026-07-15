import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/design_tokens.dart';
import '../../data/notifications/notification_models.dart';
import '../../l10n/app_localizations.dart';
import '../../view_models/notifications/notifications_provider.dart';
import '../../widgets/common/async_state_views.dart';
import 'widgets/settings_tiles.dart';

/// `GET`/`PUT /user/notification-preferences` — enabled + preferred time +
/// content mode. Mobile has no push-subscribe flow yet (that lives behind
/// FCM delivery, out of this phase's scope) — the toggle here only
/// persists the preference row so the value is ready once push ships.
class NotificationPreferencesScreen extends ConsumerWidget {
  const NotificationPreferencesScreen({super.key});

  static const _contentModes = ['word', 'reminder', 'mix'];

  String _contentModeLabel(AppLocalizations l10n, String mode) => switch (mode) {
    'word' => l10n.notificationPreferencesContentWord,
    'reminder' => l10n.notificationPreferencesContentReminder,
    _ => l10n.notificationPreferencesContentMix,
  };

  Future<void> _pickTime(
    BuildContext context,
    WidgetRef ref,
    NotificationPreferences current,
  ) async {
    final parts = current.preferredTime.split(':');
    final initial = TimeOfDay(
      hour: int.tryParse(parts.elementAtOrNull(0) ?? '') ?? 7,
      minute: int.tryParse(parts.elementAtOrNull(1) ?? '') ?? 0,
    );
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked == null) return;
    final time =
        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    await ref
        .read(notificationPreferencesProvider.notifier)
        .save(current.copyWith(preferredTime: time));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(notificationPreferencesProvider);

    return Scaffold(
      backgroundColor: DesignTokens.authBackground,
      appBar: AppBar(
        backgroundColor: DesignTokens.authBackground,
        title: Text(
          l10n.notificationPreferencesTitle,
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
              message: l10n.notificationLoadError,
              onRetry: () =>
                  ref.invalidate(notificationPreferencesProvider),
            )
          : ListView(
              padding: const EdgeInsets.all(DesignTokens.spacingMd),
              children: [
                SettingsCard(
                  children: [
                    SettingsSwitchTile(
                      icon: Icons.notifications_active_outlined,
                      title: l10n.notificationPreferencesEnabledTitle,
                      subtitle: l10n.notificationPreferencesEnabledDescription,
                      value: state.preferences!.enabled,
                      onChanged: (value) => ref
                          .read(notificationPreferencesProvider.notifier)
                          .save(state.preferences!.copyWith(enabled: value)),
                    ),
                    const Divider(height: 1),
                    SettingsTile(
                      icon: Icons.schedule_outlined,
                      title: l10n.notificationPreferencesTime,
                      subtitle: state.preferences!.preferredTime,
                      onTap: () => _pickTime(context, ref, state.preferences!),
                    ),
                  ],
                ),
                const SizedBox(height: DesignTokens.spacingLg),
                Text(
                  l10n.notificationPreferencesContentMode,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: DesignTokens.mutedForeground,
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingSm),
                Wrap(
                  spacing: DesignTokens.spacingSm,
                  children: [
                    for (final mode in _contentModes)
                      ChoiceChip(
                        label: Text(_contentModeLabel(l10n, mode)),
                        selected: state.preferences!.contentMode == mode,
                        onSelected: (_) => ref
                            .read(notificationPreferencesProvider.notifier)
                            .save(state.preferences!.copyWith(contentMode: mode)),
                      ),
                  ],
                ),
                if (state.error == 'save') ...[
                  const SizedBox(height: DesignTokens.spacingMd),
                  Text(
                    l10n.notificationPreferencesSaveError,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ],
            ),
    );
  }
}
