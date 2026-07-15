import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import 'package:deutschtiger/screens/listening/widgets/listening_coming_soon.dart';

/// Stub: shadowing (lặp lại theo transcript YouTube, ghi âm + so khớp).
/// Ngoài scope wave này — cần quyền ghi âm (Phase 8) trước khi bật thật.
/// Route giữ chỗ để không vỡ điều hướng từ màn xem.
class YouTubeShadowingScreen extends StatelessWidget {
  const YouTubeShadowingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      body: SafeArea(
        child: ListeningComingSoon(
          icon: Icons.mic_none_outlined,
          title: 'Shadowing',
          message:
              'Luyện shadowing theo transcript YouTube — tính năng đang được '
              'phát triển và sẽ có trong bản cập nhật tiếp theo.',
          onBack: () => context.pop(),
        ),
      ),
    );
  }
}
