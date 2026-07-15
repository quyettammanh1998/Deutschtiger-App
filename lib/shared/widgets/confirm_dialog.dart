import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';

/// Shows a confirmation dialog and resolves to `true` when the user confirms
/// or `false` when they cancel/dismiss.
///
/// Defaults to a Material 3 [AlertDialog]; callers can override the icon and
/// the destructive style via [destructive]. The button labels default to
/// "Hủy" / "Xác nhận" but can be customised.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Xác nhận',
  String cancelLabel = 'Hủy',
  bool destructive = false,
  IconData? icon,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      final theme = Theme.of(ctx);
      return AlertDialog(
        icon: icon == null
            ? null
            : Icon(
                icon,
                size: 32,
                color: destructive
                    ? DesignTokens.error
                    : DesignTokens.orange500,
              ),
        title: Text(title, textAlign: TextAlign.center),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(cancelLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: destructive
                  ? DesignTokens.error
                  : DesignTokens.orange500,
              foregroundColor: DesignTokens.card,
            ),
            child: Text(confirmLabel),
          ),
        ],
      );
    },
  );
  return result ?? false;
}