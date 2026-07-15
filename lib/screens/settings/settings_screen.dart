import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/design_tokens.dart';
import '../../core/release/release_feature_flags.dart';
import '../../l10n/app_localizations.dart';
import 'package:deutschtiger/services/force_update_service.dart';
import 'package:deutschtiger/services/notifications/notification_service.dart';
import 'package:deutschtiger/view_models/preferences_provider.dart';
import 'package:deutschtiger/view_models/theme_provider.dart';
import 'widgets/feedback_sheet.dart';
import 'widgets/language_picker_sheet.dart';
import 'widgets/settings_actions.dart';
import 'widgets/settings_tiles.dart';

/// Màn Cài đặt — Phase 05 N1-N3, N6.
///
/// Sections:
///   - Giao diện | Âm thanh | Ngôn ngữ | Thông báo
///   - Bảo mật & tài khoản | AI (memory) | Phản hồi (N6)
///   - Về ứng dụng
///
/// Tile widgets tách sang `widgets/settings_tiles.dart` để file chính
/// < 300 dòng theo plan guideline. Feedback sheet tách sang
/// `widgets/feedback_sheet.dart`.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final notificationsEnabled = ref.watch(notificationEnabledProvider);
    final preferences = ref.watch(preferencesProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: DesignTokens.authBackground,
      appBar: AppBar(
        backgroundColor: DesignTokens.authBackground,
        title: Text(
          l10n.settings,
          style: TextStyle(
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
      body: ListView(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        children: [
          SectionHeader(title: l10n.appearance),
          SettingsCard(
            children: [
              ThemeSettingTile(
                themeMode: themeMode,
                onChanged: (mode) {
                  ref.read(themeModeProvider.notifier).setThemeMode(mode);
                },
              ),
            ],
          ),

          const SizedBox(height: DesignTokens.spacingLg),

          SectionHeader(title: l10n.sound),
          SettingsCard(
            children: [
              SettingsSliderTile(
                icon: Icons.volume_up_outlined,
                title: l10n.pronunciationVolume,
                value: preferences.ttsVolume,
                onChanged: (value) {
                  ref.read(preferencesProvider.notifier).setTtsVolume(value);
                },
              ),
              const Divider(height: 1),
              SettingsSwitchTile(
                icon: Icons.play_circle_outline,
                title: l10n.autoplayPronunciation,
                subtitle: l10n.autoplayDescription,
                value: preferences.autoPlayAudio,
                onChanged: (value) {
                  ref
                      .read(preferencesProvider.notifier)
                      .setAutoPlayAudio(value);
                },
              ),
            ],
          ),

          const SizedBox(height: DesignTokens.spacingLg),

          SectionHeader(title: l10n.language),
          SettingsCard(
            children: [
              SettingsTile(
                icon: Icons.language_outlined,
                title: l10n.appLanguage,
                subtitle: _getLanguageName(preferences.appLanguage),
                onTap: () => _showLanguagePicker(context, ref),
              ),
            ],
          ),

          const SizedBox(height: DesignTokens.spacingLg),

          SectionHeader(title: l10n.notifications),
          SettingsCard(
            children: [
              SettingsSwitchTile(
                icon: Icons.notifications_outlined,
                title: l10n.learningReminders,
                subtitle: l10n.learningRemindersDescription,
                value: notificationsEnabled,
                onChanged: (value) {
                  ref
                      .read(notificationEnabledProvider.notifier)
                      .setEnabled(value);
                },
              ),
              const Divider(height: 1),
              SettingsTile(
                icon: Icons.schedule_outlined,
                title: l10n.reminderTime,
                subtitle:
                    '${preferences.reminderHour.toString().padLeft(2, '0')}:${preferences.reminderMinute.toString().padLeft(2, '0')}',
                onTap: () => _showTimePicker(context, ref),
              ),
              const Divider(height: 1),
              SettingsTile(
                icon: Icons.tune_outlined,
                title: l10n.notificationPreferencesTitle,
                subtitle: l10n.notificationPreferencesEnabledDescription,
                onTap: () => context.push('/settings/notifications'),
              ),
            ],
          ),

          const SizedBox(height: DesignTokens.spacingLg),

          SectionHeader(title: l10n.learningPreferencesTitle),
          SettingsCard(
            children: [
              SettingsTile(
                icon: Icons.school_outlined,
                title: l10n.learningPreferencesTitle,
                subtitle: l10n.learningPreferencesLevel,
                onTap: () => context.push('/settings/learning-preferences'),
              ),
            ],
          ),

          const SizedBox(height: DesignTokens.spacingLg),

          SectionHeader(title: l10n.securityAndAccount),
          SettingsCard(
            children: [
              SettingsTile(
                icon: Icons.lock_outline,
                title: l10n.securityDevices,
                subtitle: l10n.securityDevicesDescription,
                onTap: () => context.push('/settings/security'),
              ),
              const Divider(height: 1),
              SettingsTile(
                icon: Icons.download_outlined,
                title: l10n.exportData,
                subtitle: l10n.exportDataDescription,
                onTap: () => SettingsActions.exportData(context),
              ),
            ],
          ),

          if (ReleaseFeatureFlags.aiTutor) ...[
            const SizedBox(height: DesignTokens.spacingLg),
            SectionHeader(title: l10n.ai),
            SettingsCard(
              children: [
                SettingsTile(
                  icon: Icons.psychology_outlined,
                  title: l10n.aiMemorySettings,
                  subtitle: l10n.aiMemoryDescription,
                  onTap: () => context.push('/ai-tutor/settings'),
                ),
              ],
            ),
          ],

          const SizedBox(height: DesignTokens.spacingLg),

          SectionHeader(title: l10n.sendFeedback),
          SettingsCard(
            children: [
              SettingsTile(
                icon: Icons.rate_review_outlined,
                title: l10n.sendFeedback,
                subtitle: l10n.sendFeedbackDescription,
                onTap: () => showFeedbackSheet(context),
              ),
            ],
          ),

          const SizedBox(height: DesignTokens.spacingLg),

          SectionHeader(title: l10n.about),
          SettingsCard(
            children: [
              SettingsTile(
                icon: Icons.info_outline,
                title: l10n.version,
                subtitle: '1.0.0',
                onTap: _noop,
              ),
              const Divider(height: 1),
              SettingsTile(
                icon: Icons.system_update_outlined,
                title: l10n.checkForUpdates,
                subtitle: l10n.checkForUpdatesDescription,
                onTap: () => _checkForUpdates(context),
              ),
              const Divider(height: 1),
              SettingsTile(
                icon: Icons.description_outlined,
                title: l10n.termsOfService,
                onTap: () => context.push('/terms-of-service'),
              ),
              const Divider(height: 1),
              SettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: l10n.privacyPolicy,
                onTap: () => context.push('/privacy-policy'),
              ),
              const Divider(height: 1),
              SettingsTile(
                icon: Icons.help_outline,
                title: l10n.helpCenter,
                onTap: () => SettingsActions.openUrl(
                  context,
                  'https://deutschtiger.com/help',
                ),
              ),
              const Divider(height: 1),
              SettingsTile(
                icon: Icons.star_outline,
                title: l10n.rateApp,
                onTap: () => SettingsActions.rateApp(context),
              ),
            ],
          ),

          const SizedBox(height: DesignTokens.spacingXl),
        ],
      ),
    );
  }

  static void _noop() {}

  /// Wires the existing [ForceUpdateService] (previously only invoked from
  /// the startup gate) into a manual "check now" settings action.
  Future<void> _checkForUpdates(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final decision = await ForceUpdateService().check();
    if (!context.mounted) return;
    if (!decision.required) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.appUpToDate)));
      return;
    }
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.appUpdateAvailableTitle),
        content: Text(decision.message ?? l10n.appUpdateAvailableBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              SettingsActions.openUrl(context, decision.storeUrl);
            },
            child: Text(l10n.appUpdateAction),
          ),
        ],
      ),
    );
  }

  Future<void> _showTimePicker(BuildContext context, WidgetRef ref) async {
    final prefs = ref.read(preferencesProvider);
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: prefs.reminderHour,
        minute: prefs.reminderMinute,
      ),
    );
    if (time != null) {
      ref
          .read(preferencesProvider.notifier)
          .setReminderTime(time.hour, time.minute);
    }
  }

  Future<void> _showLanguagePicker(BuildContext context, WidgetRef ref) async {
    final currentLang = ref.read(preferencesProvider).appLanguage;
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetCtx) => LanguagePickerSheet(
        currentLanguage: currentLang,
        onSelect: (code) {
          ref.read(preferencesProvider.notifier).setLanguage(code);
        },
      ),
    );
  }

  String _getLanguageName(String code) => switch (code) {
    'vi' => 'Tiếng Việt',
    'en' => 'English',
    'de' => 'Deutsch',
    _ => 'Tiếng Việt',
  };
}
