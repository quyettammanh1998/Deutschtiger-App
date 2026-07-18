import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Loading indicator căn giữa — dùng chung các màn.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.tigerOrange),
    );
  }
}

/// View lỗi + nút thử lại — dùng chung khi fetch thất bại.
class ErrorView extends StatelessWidget {
  const ErrorView({super.key, this.message, this.onRetry});

  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              PhosphorIcons.cloudSlash,
              size: 48,
              color: context.tokens.mutedForeground,
            ),
            const SizedBox(height: 12),
            Text(
              message ?? l10n.couldNotLoadData,
              textAlign: TextAlign.center,
              style: TextStyle(color: context.tokens.mutedForeground),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(PhosphorIcons.arrowClockwise),
                label: Text(l10n.retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
