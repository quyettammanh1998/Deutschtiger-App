import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/release/release_feature_flags.dart';
import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import 'package:deutschtiger/view_models/providers.dart';
import 'widgets/feedback_sheet.dart';
import 'widgets/profile_edit_card.dart';
import 'widgets/settings_app_only_section.dart';
import 'widgets/settings_tiles.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Cài đặt root — web parity: `settings-page.tsx`. Order: back+title+
/// subtitle header, [ProfileEditCard], nav-rows card (learning goals /
/// appearance / notifications / security / [AI memory flag] / app-update),
/// app-only extras (language + sound + About — Quyết định #3 keeper (c),
/// see [SettingsAppOnlySection]), feedback row, red logout row.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(PhosphorIcons.arrowLeft, color: tokens.foreground),
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                  onPressed: () => context.pop(),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    l10n.settings,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: tokens.foreground,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 56, top: 4),
              child: Text(
                l10n.settingsSubtitle,
                style: TextStyle(fontSize: 13, color: tokens.mutedForeground),
              ),
            ),
            const SizedBox(height: 20),

            const ProfileEditCard(),
            const SizedBox(height: 16),

            SettingsNavRowCard(
              children: [
                SettingsNavRow(
                  icon: PhosphorIcons.graduationCap,
                  label: l10n.learningPreferencesTitle,
                  onTap: () => context.push('/settings/learning-preferences'),
                ),
                SettingsNavRow(
                  icon: PhosphorIcons.moon,
                  label: l10n.appearance,
                  onTap: () => context.push('/settings/appearance'),
                ),
                SettingsNavRow(
                  icon: PhosphorIcons.bell,
                  label: l10n.notificationPreferencesTitle,
                  onTap: () => context.push('/settings/notifications'),
                ),
                SettingsNavRow(
                  icon: PhosphorIcons.lock,
                  label: l10n.changePassword,
                  onTap: () => context.push('/settings/security'),
                ),
                if (ReleaseFeatureFlags.aiTutor)
                  SettingsNavRow(
                    icon: PhosphorIcons.sparkle,
                    label: l10n.aiMemorySettings,
                    onTap: () => context.push('/settings/ai-memory'),
                  ),
                SettingsNavRow(
                  icon: PhosphorIcons.downloadSimple,
                  label: l10n.checkForUpdates,
                  onTap: () => context.push('/settings/app-update'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            const SettingsAppOnlySection(),
            const SizedBox(height: 16),

            SettingsNavRowCard(
              children: [
                SettingsNavRow(
                  icon: PhosphorIcons.chatText,
                  label: l10n.sendFeedback,
                  onTap: () => showFeedbackSheet(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            SettingsNavRowCard(
              children: [
                SettingsNavRow(
                  icon: PhosphorIcons.signOut,
                  label: l10n.signOut,
                  destructive: true,
                  onTap: () => _confirmLogout(context, ref),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.signOut),
        content: Text(l10n.logoutConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.signOut),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(authServiceProvider).signOut();
  }
}
