import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_tokens.dart';
import '../../features/mission/presentation/mission_session_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/page_intro.dart';
import 'widgets/journey_capability_map_snapshot.dart';
import 'widgets/journey_daily_plan_section.dart';
import 'widgets/journey_extensions_section.dart';
import 'widgets/journey_header.dart';
import 'widgets/journey_level_journey_strip.dart';
import 'widgets/journey_today_session_card.dart';

/// B2 — Learning Journey (Learn Hub) = LEARN tab landing. Mirrors web
/// `learn-home-page.tsx` (mobile) block order: header ("Hôm nay" + goal +
/// exam countdown) → `PageIntro` → A1→C2 level strip → "Phiên hôm nay"
/// session card → today's guided plan → weekly missions (deferred, see
/// report) → capability-map snapshot → "Khám phá theo chủ đề". No AppBar —
/// web renders this as a bare scroll page.
class JourneyScreen extends ConsumerWidget {
  const JourneyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missionAsync = ref.watch(todayMissionProvider);
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: ListView(
          children: [
            const JourneyHeader(),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PageIntro(
                pageKey: 'learn',
                why: l10n.learnPageIntroWhy,
                todo: l10n.learnPageIntroTodo,
                next: l10n.learnPageIntroNext,
                nextLabel: l10n.learnPageIntroCta,
                onNextTap: () => context.push('/daily-review'),
              ),
            ),
            const SizedBox(height: 12),
            const JourneyLevelJourneyStrip(),
            const SizedBox(height: 12),
            TodaySessionCard(
              mission: missionAsync,
              onRetry: () => ref.invalidate(todayMissionProvider),
            ),
            const SizedBox(height: 12),
            const JourneyDailyPlanSection(),
            const SizedBox(height: 12),
            const JourneyCapabilityMapSnapshot(),
            const SizedBox(height: 12),
            const JourneyExtensionsSection(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
