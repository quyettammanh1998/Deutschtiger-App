import 'package:flutter/material.dart';

import 'welcome_hero_phone_mock.dart';
import 'welcome_palette.dart';

/// Hero — mirrors `welcome-hero-section.tsx`: live/rating pills, Grandstander
/// display headline "Chơi. Học. Đỗ!", sub copy, primary+secondary CTA, mini
/// proof line, phone mock with floating badges.
class WelcomeHeroSection extends StatelessWidget {
  const WelcomeHeroSection({
    super.key,
    required this.onPrimaryCta,
    required this.onSecondaryCta,
  });

  final VoidCallback onPrimaryCta;
  final VoidCallback onSecondaryCta;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: const [_LivePill(), _RatingPill()],
          ),
          const SizedBox(height: 18),
          _Headline(),
          const SizedBox(height: 12),
          const Text(
            'App học tiếng Đức cho người Việt. Game, khóa học, đề thi mô phỏng — '
            'tất cả trong một. A1–B1 miễn phí trọn đời.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, height: 1.55, color: WelPalette.inkMuted65),
          ),
          const SizedBox(height: 22),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              _PrimaryCta(onPressed: onPrimaryCta),
              _SecondaryCta(onPressed: onSecondaryCta),
            ],
          ),
          const SizedBox(height: 14),
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, size: 16, color: WelPalette.green500),
              SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Cài 30 giây · Không cần thẻ tín dụng · A1–B1 miễn phí',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: WelPalette.inkMuted65),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const WelcomeHeroPhoneMock(),
        ],
      ),
    );
  }
}

class _LivePill extends StatelessWidget {
  const _LivePill();

  @override
  Widget build(BuildContext context) {
    return _PillShell(
      // FittedBox scaleDown keeps this a compact single-line badge even at
      // very high OS text-scale settings (it never scales UP past 1x).
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            _PulsingDot(),
            SizedBox(width: 8),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: '1,247 ', style: TextStyle(fontWeight: FontWeight.w800)),
                  TextSpan(text: 'đang học'),
                ],
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: WelPalette.ink),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 1.0, end: 0.5).animate(_controller),
      child: const DecoratedBox(
        decoration: BoxDecoration(color: WelPalette.green500, shape: BoxShape.circle),
        child: SizedBox(width: 8, height: 8),
      ),
    );
  }
}

class _RatingPill extends StatelessWidget {
  const _RatingPill();

  @override
  Widget build(BuildContext context) {
    return _PillShell(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: '12.5k+ ', style: TextStyle(fontWeight: FontWeight.w800)),
                  TextSpan(text: 'đánh giá'),
                ],
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: WelPalette.ink),
              ),
            ),
            SizedBox(width: 6),
            Text('★★★★★', style: TextStyle(fontSize: 11, color: WelPalette.amber400)),
          ],
        ),
      ),
    );
  }
}

class _PillShell extends StatelessWidget {
  const _PillShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: WelPalette.cardBorder),
      ),
      child: child,
    );
  }
}

class _Headline extends StatelessWidget {
  const _Headline();

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontFamily: WelPalette.displayFont,
      fontWeight: FontWeight.w900,
      height: 1.0,
      letterSpacing: -1,
    );
    return Column(
      children: [
        Text('Học tiếng Đức', textAlign: TextAlign.center, style: style.copyWith(fontSize: 30, color: WelPalette.ink)),
        const SizedBox(height: 4),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          children: [
            Text('Chơi.', style: style.copyWith(fontSize: 44, color: WelPalette.pink500)),
            Text('Học.', style: style.copyWith(fontSize: 44, color: WelPalette.orange500)),
            Text('Đỗ!', style: style.copyWith(fontSize: 44, color: WelPalette.green700)),
          ],
        ),
      ],
    );
  }
}

class _PrimaryCta extends StatelessWidget {
  const _PrimaryCta({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: WelPalette.ctaGradient,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Color(0x80F7931E), blurRadius: 18, offset: Offset(0, 8))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onPressed,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 26, vertical: 15),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Bắt đầu hành trình', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward, size: 16, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryCta extends StatelessWidget {
  const _SecondaryCta({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: WelPalette.cardBorder),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onPressed,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(radius: 11, backgroundColor: WelPalette.ink, child: Icon(Icons.play_arrow, size: 12, color: Colors.white)),
                  SizedBox(width: 10),
                  Text('Xem cách học', style: TextStyle(color: WelPalette.ink, fontWeight: FontWeight.w700, fontSize: 14)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
