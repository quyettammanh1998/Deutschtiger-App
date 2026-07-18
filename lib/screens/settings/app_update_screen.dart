import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/settings_actions.dart';
import 'widgets/settings_tiles.dart';
import 'package:deutschtiger/services/force_update_service.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Cập nhật ứng dụng — web parity: `settings-app-update-page.tsx`. Web's
/// action is "clear cache + reload" (`/reset`, a web-only concept); the
/// native equivalent is checking the store version via the existing
/// [ForceUpdateService] (previously only invoked from the startup gate).
class AppUpdateScreen extends StatelessWidget {
  const AppUpdateScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () => context.pop(),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    l10n.checkForUpdates,
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
                  SettingsCardLabel(l10n.about),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.appUpdateSectionTitle,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: tokens.foreground,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.appUpdateSectionDescription,
                              style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => _checkForUpdates(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [tokens.primary, tokens.brandDark]),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            l10n.checkForUpdates,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
