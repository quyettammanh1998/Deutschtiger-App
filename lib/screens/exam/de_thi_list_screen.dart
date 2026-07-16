import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/exam/de_thi_repository.dart';
import 'widgets/de_thi/de_thi_exam_card.dart';
import 'widgets/de_thi/de_thi_faq_section.dart';
import 'widgets/de_thi/de_thi_founder_cta_footer.dart';
import 'widgets/de_thi/de_thi_promo_banner.dart';
import 'widgets/de_thi/de_thi_site_header.dart';
import 'widgets/de_thi/de_thi_stats_testimonials_section.dart';

/// Danh sách đề thi public (registry tĩnh) — route `/de-thi` không cần auth,
/// deep-link vào `/de-thi/:code` để làm đề.
///
/// Web parity: `de-thi-list-page.tsx` — site header, hero, exam cards, mobile
/// promo banner, FAQ + stats + testimonials + founder-quote trust block.
class DeThiListScreen extends ConsumerWidget {
  const DeThiListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final entries = ref.watch(deThiRepositoryProvider).listRegistry();

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: Column(
          children: [
            const DeThiSiteHeader(),
            Expanded(
              child: entries.isEmpty
                  ? Center(
                      child: Text(
                        l10n.deThiListEmpty,
                        style: TextStyle(color: tokens.mutedForeground),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      children: [
                        _Hero(tokens: tokens),
                        for (final entry in entries)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: DeThiExamCard(entry: entry),
                          ),
                        const SizedBox(height: 12),
                        const DeThiPromoBanner(),
                        const SizedBox(height: 32),
                        const DeThiFaqSection(),
                        const SizedBox(height: 32),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: tokens.border),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(top: 28),
                            child: DeThiStatsTestimonialsSection(),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const DeThiFounderCtaFooter(),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.tokens});

  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          Text(
            l10n.deThiHeroTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: tokens.foreground,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.deThiHeroSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: tokens.mutedForeground),
          ),
        ],
      ),
    );
  }
}
