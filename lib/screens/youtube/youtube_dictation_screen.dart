import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import 'package:deutschtiger/screens/listening/widgets/listening_coming_soon.dart';

/// Stub: nghe chép chính tả (dictation) theo transcript YouTube. Web có chế
/// độ luyện tập đầy đủ (`YouTubeDictationPage` — chấm câu, chọn word/sentence
/// mode); ngoài scope wave này (ưu tiên tracker + watch trước). Route được
/// giữ chỗ để không vỡ điều hướng từ màn xem.
class YouTubeDictationScreen extends StatelessWidget {
  const YouTubeDictationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      body: SafeArea(
        child: ListeningComingSoon(
          icon: Icons.keyboard_alt_outlined,
          title: 'Nghe chép chính tả',
          message:
              'Luyện nghe chép chính tả theo transcript YouTube — tính năng '
              'đang được phát triển và sẽ có trong bản cập nhật tiếp theo.',
          onBack: () => context.pop(),
        ),
      ),
    );
  }
}
