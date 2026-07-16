import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../features/mission/presentation/mission_session_provider.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/journey_daily_plan_section.dart';
import 'widgets/journey_extensions_section.dart';
import 'widgets/journey_header.dart';
import 'widgets/journey_today_session_card.dart';

/// B2 — Learning Journey (Learn Hub) = LEARN tab landing. Mirrors web
/// `learn-home-page.tsx` (mobile), block order: "Hôm nay" header (goal +
/// exam countdown) → "Phiên hôm nay" session card → today's guided plan →
/// secondary browse tiles ("Khám phá theo chủ đề" 1:1 with web; the rest
/// are Flutter-only extensions kept for parity with existing navigation).
class JourneyScreen extends ConsumerWidget {
  const JourneyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missionAsync = ref.watch(todayMissionProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: DesignTokens.background,
      appBar: AppBar(
        backgroundColor: DesignTokens.background,
        title: Text(l10n.learningJourney),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            const JourneyHeader(),
            TodaySessionCard(
              mission: missionAsync,
              onRetry: () => ref.invalidate(todayMissionProvider),
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            const JourneyDailyPlanSection(),
            const SizedBox(height: DesignTokens.spacingMd),
            const JourneyExtensionsSection(),
            const SizedBox(height: DesignTokens.spacingLg),
          ],
        ),
      ),
    );
  }
}
