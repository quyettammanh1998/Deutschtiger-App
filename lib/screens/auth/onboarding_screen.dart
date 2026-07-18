import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_tokens.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import 'package:deutschtiger/widgets/common/gradient_button.dart';
import 'package:deutschtiger/view_models/providers.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Nền trang auth theo web: `bg-[#FFFBF5]` — literal như web, không đọc
/// static token đã deprecated. Dark mode dùng `context.tokens.background`.
const Color _authPageBackground = Color(0xFFFFFBF5);

/// A4 - Màn onboarding slides sau welcome, trước khi vào app chính.
/// Mỗi slide: image placeholder + tiêu đề + mô tả + nút "Tiếp tục".
/// Skip button ở góc trên phải. Sau slide cuối → /login.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  static const _slideCount = 3;

  static List<_OnboardingSlide> _slides(AppLocalizations l10n) => [
    _OnboardingSlide(
      icon: PhosphorIcons.cards,
      iconBg: Color(0xFFFFF1E6),
      iconColor: Color(0xFFEA580C),
      title: l10n.smartVocabularyLearning,
      description: l10n.smartVocabularyLearningDescription,
    ),
    _OnboardingSlide(
      icon: PhosphorIcons.graduationCap,
      iconBg: Color(0xFFE8F5E9),
      iconColor: Color(0xFF22C55E),
      title: l10n.goetheTelcPractice,
      description: l10n.goetheTelcPracticeDescription,
    ),
    _OnboardingSlide(
      icon: PhosphorIcons.trophy,
      iconBg: Color(0xFFFEF3C7),
      iconColor: Color(0xFFF59E0B),
      title: l10n.gamificationAndStreak,
      description: l10n.gamificationAndStreakDescription,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await ref.read(onboardingServiceProvider).complete();
    ref.invalidate(onboardingCompletedProvider);
    if (!mounted) return;
    final loggedIn = ref.read(authServiceProvider).isLoggedIn;
    context.go(loggedIn ? '/home' : '/login');
  }

  void _onNext() {
    if (_currentPage < _slideCount - 1) {
      _controller.nextPage(
        duration: DesignTokens.durationMedium,
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final slides = _slides(l10n);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tokens = context.tokens;
    return Scaffold(
      // Native-only onboarding (no web page); reuse the same auth-surface
      // background as login/signup: light = fixed #FFFBF5, dark = theme bg.
      backgroundColor: isDark ? tokens.background : _authPageBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar — Skip
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacingMd,
                vertical: DesignTokens.spacingSm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _finish,
                    style: TextButton.styleFrom(
                      foregroundColor: tokens.mutedForeground,
                      padding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.spacingMd,
                        vertical: DesignTokens.spacingXs,
                      ),
                    ),
                    child: Text(
                      l10n.skip,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Slide pages
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: slides.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  return _SlideView(slide: slides[index]);
                },
              ),
            ),
            // Indicator dots
            _PageIndicator(count: slides.length, currentIndex: _currentPage),
            const SizedBox(height: DesignTokens.spacingLg),
            // Next button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.screenHorizontalPadding,
              ),
              child: GradientButton(
                label: _currentPage == slides.length - 1
                    ? l10n.startLearning
                    : l10n.continueAction,
                onPressed: _onNext,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingLg),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlide {
  const _OnboardingSlide({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String description;
}

class _SlideView extends StatelessWidget {
  const _SlideView({required this.slide});

  final _OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.screenHorizontalPadding,
                vertical: DesignTokens.spacingLg,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image placeholder container — fixed pastel palette per
                  // slide (marketing icon tiles, no web page to mirror;
                  // same "deliberately fixed" pattern as welcome/**).
                  Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      color: slide.iconBg,
                      shape: BoxShape.circle,
                      boxShadow: DesignTokens.shadowCard,
                    ),
                    child: Icon(slide.icon, size: 100, color: slide.iconColor),
                  ),
                  const SizedBox(height: DesignTokens.spacingXl),
                  Text(
                    slide.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: tokens.foreground,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: DesignTokens.spacingMd),
                  Text(
                    slide.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: tokens.mutedForeground,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.count, required this.currentIndex});

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: DesignTokens.durationFast,
          margin: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingXs,
          ),
          height: 8,
          width: isActive ? 24 : 8,
          decoration: BoxDecoration(
            // Active dot = fixed brand orange; inactive follows theme border.
            color: isActive ? DesignTokens.tigerOrange : tokens.border,
            borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
          ),
        );
      }),
    );
  }
}
