import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';

/// Shared error state — web parity: "Không thể tải dữ liệu. Vui lòng thử
/// lại." + orange-gradient "Thử lại" button, used by every pronunciation
/// screen's `isError` branch.
class PronunciationErrorView extends StatelessWidget {
  const PronunciationErrorView({
    super.key,
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: tokens.mutedForeground),
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: Text(retryLabel)),
          ],
        ),
      ),
    );
  }
}

/// Shared empty-data placeholder card.
class PronunciationEmptyView extends StatelessWidget {
  const PronunciationEmptyView({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tokens.border),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(color: tokens.mutedForeground),
      ),
    );
  }
}
