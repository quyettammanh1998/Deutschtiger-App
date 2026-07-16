import 'package:flutter/material.dart';

import 'welcome/welcome_auth_modal.dart';
import 'welcome/welcome_features_grid.dart';
import 'welcome/welcome_final_cta.dart';
import 'welcome/welcome_footer.dart';
import 'welcome/welcome_hero_section.dart';
import 'welcome/welcome_how_it_works.dart';
import 'welcome/welcome_nav_header.dart';
import 'welcome/welcome_palette.dart';
import 'welcome/welcome_stats_bar.dart';
import 'welcome/welcome_testimonials.dart';

/// Full marketing landing page — mobile port of
/// `thamkhao/deutschtiger-frontend/src/pages/landing/welcome-page.tsx`.
/// Top→bottom: sticky nav header, hero, stats bar, how-it-works, features
/// grid, testimonials, final CTA, footer. Auth is a modal over this page
/// (web behaviour) via [showWelcomeAuthModal]; `/login` and `/signup`
/// remain independently reachable routes.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _howItWorksKey = GlobalKey();

  void _openAuthModal() => showWelcomeAuthModal(context);

  void _scrollToHowItWorks() {
    final ctx = _howItWorksKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WelPalette.bgBottom,
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: WelPalette.pageGradient),
        child: Column(
          children: [
            WelcomeNavHeader(onCtaPressed: _openAuthModal),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    WelcomeHeroSection(
                      onPrimaryCta: _openAuthModal,
                      onSecondaryCta: _scrollToHowItWorks,
                    ),
                    const WelcomeStatsBar(),
                    KeyedSubtree(key: _howItWorksKey, child: const WelcomeHowItWorks()),
                    const WelcomeFeaturesGrid(),
                    const WelcomeTestimonials(),
                    WelcomeFinalCta(onCtaPressed: _openAuthModal),
                    const WelcomeFooter(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
