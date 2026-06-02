import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// True nếu lỗi là 403 từ backend (chưa mua premium cho module interview).
bool isPremiumError(Object error) {
  return error is DioException && error.response?.statusCode == 403;
}

/// Màn báo cần Premium — hiện khi API interview trả 403.
/// V1 chưa có flow mua trong app nên chỉ thông báo (theo quyết định scope).
class PremiumRequiredView extends StatelessWidget {
  const PremiumRequiredView({super.key, this.onRetry});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.workspace_premium_outlined,
              size: 56,
              color: AppColors.tigerOrange,
            ),
            const SizedBox(height: 16),
            const Text(
              'Tính năng cần Premium',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.foreground,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Nâng cấp Premium để xem trọn bộ video phỏng vấn.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.mutedForeground),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Thử lại'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
