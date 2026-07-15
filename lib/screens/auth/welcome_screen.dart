import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import 'package:deutschtiger/widgets/common/gradient_button.dart';
import 'package:deutschtiger/widgets/common/tiger_logo.dart';

/// Màn giới thiệu app (welcome) — màn đầu khi chưa đăng nhập.
/// Bám tinh thần web welcome-page: logo + tagline + 3 điểm nổi bật + CTA.
/// Nút dẫn sang /login hoặc /signup (màn riêng, không modal).
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static List<_Feature> _features(AppLocalizations l10n) => [
    _Feature(
      icon: Icons.style_outlined,
      title: l10n.smartVocabularyReview,
      desc: l10n.smartVocabularyReviewDescription,
    ),
    _Feature(
      icon: Icons.local_fire_department_outlined,
      title: l10n.dailyMissionsAndStreak,
      desc: l10n.dailyMissionsAndStreakDescription,
    ),
    _Feature(
      icon: Icons.trending_up,
      title: l10n.trackProgress,
      desc: l10n.trackProgressDescription,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

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
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      children: [
                        TextSpan(
                          text: '${l10n.welcomeLearnGerman}\n',
                          style: const TextStyle(color: AppColors.foreground),
                        ),
                        TextSpan(
                          text: l10n.welcomeEveryDayWith,
                          style: const TextStyle(color: AppColors.foreground),
                        ),
                        const TextSpan(
                          text: 'DeutschTiger',
                          style: TextStyle(color: AppColors.tigerOrange),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.welcomeDescription,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.mutedForeground,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 28),
                  for (final f in _features(l10n)) ...[
                    _FeatureRow(feature: f),
                    const SizedBox(height: 14),
                  ],
                  const SizedBox(height: 16),
                  GradientButton(
                    label: l10n.startLearning,
                    onPressed: () => context.push('/onboarding'),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        l10n.alreadyHaveAccount,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push('/login'),
                        style: TextButton.styleFrom(
                          minimumSize: const Size(48, 48),
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                        ),
                        child: Text(
                          l10n.logIn,
                          style: const TextStyle(
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
