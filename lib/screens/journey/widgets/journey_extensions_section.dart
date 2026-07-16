import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/common/app_card.dart';

/// "Khám phá theo chủ đề" — bottom browse tile. Mirrors web
/// `learn-home-page.tsx`'s `card-interactive` button 1:1 (title + subtitle +
/// 🗺️ trailing emoji). The Flutter-only courses/learner-model/focus-session
/// tiles that used to live here are dropped (web `/learn` doesn't show them —
/// they stay reachable via the "Thêm" sheet catalog and readiness cards).
class JourneyExtensionsSection extends StatelessWidget {
  const JourneyExtensionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AppCard.interactive(
        onTap: () => context.push('/learn/topics'),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.topicExploreTitle,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: tokens.foreground,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.topicExploreSubtitle,
                    style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Text('🗺️', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
