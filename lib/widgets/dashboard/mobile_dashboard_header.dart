import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Mobile dashboard header với greeting theo thời gian, streak, XP.
class MobileDashboardHeader extends StatelessWidget {
  const MobileDashboardHeader({
    super.key,
    required this.displayName,
    required this.streak,
    this.avatarUrl,
    this.isPremium = false,
    this.dailyXp,
    this.dailyGoal,
    this.onSettingsTap,
    this.onMessagesTap,
    this.onProfileTap,
  });

  final String displayName;
  final int streak;
  final String? avatarUrl;
  final bool isPremium;
  final int? dailyXp;
  final int? dailyGoal;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onMessagesTap;
  final VoidCallback? onProfileTap;

  /// Greeting theo giờ trong ngày.
  static String timeGreeting() {
    final h = DateTime.now().hour;
    if (h < 11) return 'Chào buổi sáng';
    if (h < 14) return 'Chào buổi trưa';
    if (h < 18) return 'Chào buổi chiều';
    return 'Chào buổi tối';
  }

  @override
  Widget build(BuildContext context) {
    final greetingLabel = timeGreeting();
    final showXp = dailyXp != null && dailyGoal != null && (dailyGoal ?? 0) > 0;
    final xpReached = showXp && (dailyXp ?? 0) >= (dailyGoal ?? 0);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, Color(0xFF1565C0)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Avatar | Greeting | Icons
              Row(
                children: [
                  // Avatar
                  GestureDetector(
                    onTap: onProfileTap,
                    child: _buildAvatar(),
                  ),
                  const SizedBox(width: 12),
                  // Greeting
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          greetingLabel,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.75),
                          ),
                        ),
                        Text(
                          '$displayName 👋',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Icons
                  Row(
                    children: [
                      _buildIconButton(
                        icon: Icons.chat_bubble_outline_rounded,
                        onTap: onMessagesTap ?? () {},
                        showBadge: false,
                      ),
                      const SizedBox(width: 8),
                      _buildIconButton(
                        icon: Icons.settings_outlined,
                        onTap: onSettingsTap ?? () {},
                        showBadge: false,
                      ),
                    ],
                  ),
                ],
              ),

              // Row 2: Stats pills
              if (showXp || streak > 0) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    // XP pill
                    if (showXp)
                      Expanded(
                        child: _XpPill(
                          xp: dailyXp!,
                          goal: dailyGoal!,
                          xpReached: xpReached,
                        ),
                      ),
                    if (showXp && streak > 0) const SizedBox(width: 8),
                    // Streak pill
                    if (streak > 0)
                      Expanded(
                        child: _StreakPill(streak: streak),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.2),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2),
      ),
      child: avatarUrl != null
          ? ClipOval(
              child: Image.network(
                avatarUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildInitials(),
              ),
            )
          : _buildInitials(),
    );
  }

  Widget _buildInitials() {
    return Center(
      child: Text(
        displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
    bool showBadge = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            if (showBadge)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '1',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// XP pill widget.
class _XpPill extends StatelessWidget {
  const _XpPill({required this.xp, required this.goal, required this.xpReached});

  final int xp;
  final int goal;
  final bool xpReached;

  @override
  Widget build(BuildContext context) {
    final pct = goal > 0 ? (xp / goal).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // XP ring
          SizedBox(
            width: 36,
            height: 36,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 36,
                  height: 36,
                  child: CircularProgressIndicator(
                    value: pct,
                    strokeWidth: 3,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      xpReached ? Colors.greenAccent : Colors.yellowAccent,
                    ),
                  ),
                ),
                const Text('⚡', style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'XP hôm nay',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.7),
                    letterSpacing: 0.5,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '$xp',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '/$goal',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                    if (xpReached)
                      const Text(
                        ' ✓',
                        style: TextStyle(fontSize: 14, color: Colors.greenAccent),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Streak pill widget.
class _StreakPill extends StatelessWidget {
  const _StreakPill({required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Streak',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.7),
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  '$streak ngày',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
