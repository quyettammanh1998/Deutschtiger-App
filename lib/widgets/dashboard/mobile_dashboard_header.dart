import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';
import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';

/// Mobile dashboard header — warm cream card with greeting, streak chip and
/// quick actions. Mirrors web `mobile-dashboard-header.tsx`: a light card
/// (not the old blue gradient banner) with only two icon entry points
/// (messages, settings) — the standalone notification bell moved out, its
/// unread badge now lives on the Messages button.
class MobileDashboardHeader extends StatelessWidget {
  const MobileDashboardHeader({
    super.key,
    required this.displayName,
    required this.streak,
    this.avatarUrl,
    this.isPremium = false,
    this.onSettingsTap,
    this.onMessagesTap,
    this.onProfileTap,
    this.unreadNotificationCount = 0,
    this.wordsLearned = 0,
  });

  final String displayName;
  final int streak;
  final String? avatarUrl;
  final bool isPremium;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onMessagesTap;
  final VoidCallback? onProfileTap;

  /// `GET /user/unread-counts` — badge shown on the Messages icon button.
  final int unreadNotificationCount;

  /// Total distinct words learned — when > 0 the row-2 encouragement text
  /// switches to "📚 Đã học N từ vựng" (mirrors web header row 2 variant).
  final int wordsLearned;

  /// Greeting theo giờ trong ngày.
  static String timeGreeting(AppLocalizations l10n, {DateTime? now}) {
    final hour = (now ?? DateTime.now()).hour;
    if (hour < 11) return l10n.goodMorning;
    if (hour < 14) return l10n.goodNoon;
    if (hour < 18) return l10n.goodAfternoon;
    return l10n.goodEvening;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final greetingLabel = timeGreeting(l10n);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tokens = context.tokens;
    // Warm cream brand gradient in light mode; a theme-aware dark surface in
    // dark mode so the card no longer stays light against the dark dashboard.
    final cardGradient = isDark
        ? LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [tokens.card, tokens.muted],
          )
        : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFFBF7), Color(0xFFFFF1E6)],
          );
    // Near-black title (headerTextDark) is invisible on the dark surface — use
    // the theme foreground there while keeping the brand brown in light mode.
    final titleColor = isDark ? tokens.foreground : DesignTokens.headerTextDark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: SafeArea(
        bottom: false,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
            border: Border.all(
              color: isDark ? tokens.border : DesignTokens.headerCardBorder,
            ),
            gradient: cardGradient,
            boxShadow: const [
              BoxShadow(
                color: Color(0x2ED67828),
                blurRadius: 24,
                spreadRadius: -8,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
            child: Stack(
              children: [
                // Top-right radial glow — mirrors the web `::before` accent.
                const Positioned(top: -32, right: -32, child: _RadialGlow()),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _Avatar(
                            displayName: displayName,
                            avatarUrl: avatarUrl,
                            onTap: onProfileTap,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  greetingLabel,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: DesignTokens.headerMutedBrown,
                                  ),
                                ),
                                Text(
                                  '$displayName 👋',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: titleColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          _HeaderIconButton(
                            icon: Icons.chat_bubble_outline_rounded,
                            semanticLabel: l10n.messages,
                            onTap: onMessagesTap ?? () {},
                            badgeCount: unreadNotificationCount,
                          ),
                          const SizedBox(width: 6),
                          _HeaderIconButton(
                            icon: Icons.settings_outlined,
                            semanticLabel: l10n.settings,
                            onTap: onSettingsTap ?? () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              wordsLearned > 0
                                  ? l10n.headerWordsLearned(wordsLearned)
                                  : l10n.headerEncouragement,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                                color: DesignTokens.headerMutedBrown,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _StreakChip(streak: streak),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RadialGlow extends StatelessWidget {
  const _RadialGlow();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [Color(0x24F96114), Colors.transparent],
          stops: [0, 0.7],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.displayName, this.avatarUrl, this.onTap});

  final String displayName;
  final String? avatarUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Semantics(
      button: onTap != null,
      label: l10n.profile,
      onTap: onTap,
      child: ExcludeSemantics(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: DesignTokens.orange50,
              border: Border.all(
                color: DesignTokens.headerCardBorder,
                width: 2,
              ),
              image: avatarUrl != null
                  ? DecorationImage(
                      image: NetworkImage(avatarUrl!),
                      fit: BoxFit.cover,
                      onError: (_, _) {},
                    )
                  : null,
            ),
            child: avatarUrl != null
                ? null
                : Center(
                    child: Text(
                      displayName.isNotEmpty
                          ? displayName[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: DesignTokens.headerAccentOrange,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.semanticLabel,
    required this.onTap,
    this.badgeCount = 0,
  });

  final IconData icon;
  final String semanticLabel;
  final VoidCallback onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    final showBadge = badgeCount > 0;
    final badgeText = badgeCount > 99 ? '99+' : '$badgeCount';
    return Semantics(
      button: true,
      label: semanticLabel,
      onTap: onTap,
      child: ExcludeSemantics(
        child: GestureDetector(
          onTap: onTap,
          // 48x48 hit target (Material minimum tap size) around the 36x36
          // visual chip — mirrors the tap-target guard the old header used.
          child: SizedBox(
            width: 48,
            height: 48,
            child: Center(
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: DesignTokens.headerCardBorder),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      icon,
                      color: DesignTokens.headerAccentOrange,
                      size: 20,
                    ),
                    if (showBadge)
                      Positioned(
                        right: -4,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            color: DesignTokens.error,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: DesignTokens.headerCardBg,
                              width: 2,
                            ),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            badgeText,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StreakChip extends StatelessWidget {
  const _StreakChip({required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: DesignTokens.streakChipBorder),
      ),
      child: Text(
        '🔥 ${streak > 0 ? l10n.streakDays(streak) : l10n.headerStreakStart}',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: DesignTokens.headerAccentOrange,
        ),
      ),
    );
  }
}
