import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_tokens.dart';
import '../../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/settings_actions.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Shows an honest support path while the backend account-deletion contract
/// is not available. This screen must not claim an account was deleted.
class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final background = context.tokens.background;
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIcons.arrowLeft),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.deleteAccount,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: DesignTokens.tigerOrange,
          ),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(DesignTokens.screenHorizontalPadding),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    constraints.maxHeight -
                    2 * DesignTokens.screenHorizontalPadding,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        PhosphorIcons.info,
                        color: DesignTokens.tigerOrange,
                        size: 48,
                      ),
                      const SizedBox(height: DesignTokens.spacingMd),
                      Text(
                        l10n.accountDeletionUnavailableTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: context.tokens.foreground,
                        ),
                      ),
                      const SizedBox(height: DesignTokens.spacingSm),
                      Text(
                        l10n.accountDeletionUnavailableBody,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          color: context.tokens.mutedForeground,
                        ),
                      ),
                      const SizedBox(height: DesignTokens.spacingXl),
                      FilledButton.icon(
                        onPressed: () => SettingsActions.openUrl(
                          context,
                          'mailto:support@deutschtiger.com',
                        ),
                        icon: const Icon(PhosphorIcons.envelope),
                        label: Text(l10n.contactSupport),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
