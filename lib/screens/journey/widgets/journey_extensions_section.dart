import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_tokens.dart';
import '../../../l10n/app_localizations.dart';

/// Secondary browse layer below the guided plan. "Khám phá theo chủ đề"
/// mirrors web `learn-home-page.tsx`'s bottom `card-interactive` button
/// 1:1 (same 🗺️ emoji, same title, card-interactive look). The other tiles
/// (courses / learner model / focus session) are Flutter-only extensions
/// with no dedicated block on the web `/learn` page — kept for parity with
/// existing navigation, restyled to the same card language with an emoji
/// leading glyph instead of a Material icon substitution.
class JourneyExtensionsSection extends StatelessWidget {
  const JourneyExtensionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.screenHorizontalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ExtensionTile(
            emoji: '🎓',
            title: l10n.coursesTileTitle,
            onTap: () => context.push('/journey/courses'),
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          _ExtensionTile(
            emoji: '📊',
            title: l10n.learnerModelTitle,
            onTap: () => context.push('/learner-model'),
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          _ExtensionTile(
            emoji: '🎯',
            title: l10n.focusSessionTitle,
            onTap: () => context.push('/focus-session'),
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          _ExtensionTile(
            emoji: '🗺️',
            title: l10n.topicExploreTitle,
            onTap: () => context.push('/learn/topics'),
          ),
        ],
      ),
    );
  }
}

class _ExtensionTile extends StatelessWidget {
  const _ExtensionTile({
    required this.emoji,
    required this.title,
    required this.onTap,
  });

  final String emoji;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: DesignTokens.card,
      borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
        child: Container(
          padding: const EdgeInsets.all(DesignTokens.cardPadding),
          decoration: BoxDecoration(
            border: Border.all(color: DesignTokens.border),
            borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: DesignTokens.foreground,
                  ),
                ),
              ),
              const SizedBox(width: DesignTokens.spacingSm),
              Text(emoji, style: const TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
