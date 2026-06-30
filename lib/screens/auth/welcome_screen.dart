import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import 'package:deutschtiger/widgets/common/gradient_button.dart';
import 'package:deutschtiger/widgets/common/tiger_logo.dart';

/// Màn giới thiệu app (welcome) — màn đầu khi chưa đăng nhập.
/// Bám tinh thần web welcome-page: logo + tagline + 3 điểm nổi bật + CTA.
/// Nút dẫn sang /login hoặc /signup (màn riêng, không modal).
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const _features = [
    _Feature(
      icon: Icons.style_outlined,
      title: 'Ôn từ vựng thông minh',
      desc: 'Flashcard lặp lại đúng lúc bạn sắp quên.',
    ),
    _Feature(
      icon: Icons.local_fire_department_outlined,
      title: 'Nhiệm vụ & chuỗi ngày học',
      desc: 'Mục tiêu mỗi ngày, giữ streak đều đặn.',
    ),
    _Feature(
      icon: Icons.trending_up,
      title: 'Theo dõi tiến độ',
      desc: 'XP, cấp độ và số phút học mỗi ngày.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  const TigerLogo(width: 140),
                  const SizedBox(height: 16),
                  // Tagline bám web: "Học tiếng Đức · Chơi. Học. Đỗ!"
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      children: [
                        TextSpan(
                          text: 'Học tiếng Đức\n',
                          style: TextStyle(color: AppColors.foreground),
                        ),
                        TextSpan(
                          text: 'mỗi ngày cùng ',
                          style: TextStyle(color: AppColors.foreground),
                        ),
                        TextSpan(
                          text: 'DeutschTiger',
                          style: TextStyle(color: AppColors.tigerOrange),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'App học tiếng Đức cho người Việt — ôn từ vựng, '
                    'nhiệm vụ hằng ngày và luyện đọc, viết, phỏng vấn.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.mutedForeground,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 28),
                  for (final f in _features) ...[
                    _FeatureRow(feature: f),
                    const SizedBox(height: 14),
                  ],
                  const SizedBox(height: 16),
                  GradientButton(
                    label: 'Bắt đầu học',
                    onPressed: () => context.push('/signup'),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Đã có tài khoản? ',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.push('/login'),
                        child: const Text(
                          'Đăng nhập',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.orange500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Feature {
  const _Feature({required this.icon, required this.title, required this.desc});
  final IconData icon;
  final String title;
  final String desc;
}

/// Một dòng feature: icon tròn nền cam nhạt + tiêu đề + mô tả.
class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.feature});
  final _Feature feature;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.orange50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(feature.icon, color: AppColors.tigerOrange, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                feature.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.foreground,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                feature.desc,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
