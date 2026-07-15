import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import 'widgets/listening_coming_soon.dart';

/// Sprechen B1 — trên web đây là bộ sưu tập video YouTube (luyện nghe chép
/// chính tả). Tích hợp YouTube chưa nằm trong scope của app này (wave sau),
/// nên màn hình được gate lại thay vì hiển thị dữ liệu giả.
class SprechenB1Page extends StatelessWidget {
  const SprechenB1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      body: SafeArea(
        child: ListeningComingSoon(
          icon: Icons.chat_bubble_outline,
          title: 'Sprechen B1',
          message:
              'Luyện nghe qua video YouTube — tính năng đang được phát triển '
              'và sẽ có trong bản cập nhật tiếp theo.',
          onBack: () => context.pop(),
        ),
      ),
    );
  }
}
