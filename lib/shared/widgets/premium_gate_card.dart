import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';

/// Neutral paywall gate shown in place of premium-only features in GĐ1.
///
/// Compliance (file 02 in plan 260706-0232):
///   - KHÔNG nhắc giá tiền (gross 99/349/449k là việc GĐ2).
///   - KHÔNG link web pricing (Apple 3.1.1 "steering").
///   - KHÔNG push upgrade CTA — chỉ thông báo tính năng chưa có trên app.
///
/// Dùng ở các màn premium-gated (interview roadmap, voice scenario, ...)
/// thay cho `PremiumRequiredView` cũ (đã giữ lại làm alias cho các màn cũ).
class PremiumGateCard extends StatelessWidget {
  const PremiumGateCard({
    super.key,
    required this.title,
    required this.description,
    this.icon = Icons.lock_outline,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String description;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DesignTokens.spacingLg),
      decoration: BoxDecoration(
        color: DesignTokens.card,
        borderRadius: BorderRadius.circular(DesignTokens.radius),
        border: Border.all(color: DesignTokens.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: DesignTokens.muted,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 32,
              color: DesignTokens.mutedForeground,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: DesignTokens.foreground,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          Text(
            description,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: DesignTokens.mutedForeground,
              height: 1.45,
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: DesignTokens.spacingMd),
            OutlinedButton(
              onPressed: onAction,
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}