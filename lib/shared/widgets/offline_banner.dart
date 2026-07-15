import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';

/// Yellow/amber banner shown at the top of the screen when the device is
/// offline. Drop in at the top of any `Scaffold` body or inside a column.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({
    super.key,
    required this.message,
    this.icon = Icons.wifi_off_rounded,
  });

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: DesignTokens.warning,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingMd,
            vertical: 10,
          ),
          child: Row(
            children: [
              Icon(icon, color: DesignTokens.card, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: DesignTokens.card,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
