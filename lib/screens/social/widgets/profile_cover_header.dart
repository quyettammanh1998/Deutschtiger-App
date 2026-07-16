import 'package:flutter/material.dart';

import 'package:deutschtiger/core/icons/app_phosphor_icons.dart';
import 'package:deutschtiger/core/theme/app_tokens.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';

/// Web parity: `components/profile/profile-cover-header.tsx` — cover
/// gradient (`from-orange-500/80 to-orange-600/80`) + overlapping avatar
/// (premium amber ring/crown, online dot) + name/title/status line.
class ProfileCoverHeader extends StatelessWidget {
  const ProfileCoverHeader({
    super.key,
    required this.displayName,
    required this.avatarUrl,
    required this.activeTitle,
    required this.isPremium,
    required this.isOnline,
    required this.activityLabel,
    required this.joinedDate,
  });

  final String displayName;
  final String? avatarUrl;
  final String? activeTitle;
  final bool isPremium;
  final bool isOnline;

  /// Localized activity label (`ACTIVITY_LABELS[activity]`) or null.
  final String? activityLabel;
  final String joinedDate;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        SizedBox(
          height: 76,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFF97316).withValues(alpha: 0.8),
                      const Color(0xFFEA580C).withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
              ),
              Positioned(
                top: 16,
                left: 0,
                right: 0,
                child: Center(
                  child: _Avatar(
                    displayName: displayName,
                    avatarUrl: avatarUrl,
                    isPremium: isPremium,
                    isOnline: isOnline,
                    tokens: tokens,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      displayName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: tokens.foreground,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isPremium) ...[
                    const SizedBox(width: 6),
                    Icon(
                      AppPhosphorIcons.crown,
                      size: 16,
                      color: const Color(0xFFF59E0B),
                    ),
                  ],
                ],
              ),
              if (activeTitle != null && activeTitle!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    activeTitle!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                      color: tokens.primary,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: isOnline && activityLabel != null
                    ? Text(
                        activityLabel!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF16A34A),
                        ),
                      )
                    : Text(
                        isOnline
                            ? l10n.socialOnlineNow
                            : l10n.socialJoinedOn(joinedDate),
                        style: TextStyle(
                          fontSize: 12,
                          color: tokens.mutedForeground,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.displayName,
    required this.avatarUrl,
    required this.isPremium,
    required this.isOnline,
    required this.tokens,
  });

  final String displayName;
  final String? avatarUrl;
  final bool isPremium;
  final bool isOnline;
  final AppTokens tokens;

  String get _initials {
    final parts = displayName.trim().split(RegExp(r'\s+'));
    final letters = parts.where((p) => p.isNotEmpty).map((p) => p[0]).take(2);
    final initials = letters.join().toUpperCase();
    return initials.isEmpty ? '?' : initials;
  }

  @override
  Widget build(BuildContext context) {
    const size = 56.0;
    return SizedBox(
      width: size + 8,
      height: size + 8,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: isPremium
                  ? Border.all(color: const Color(0xFFFBBF24), width: 2)
                  : null,
              color: tokens.primary.withValues(alpha: 0.2),
              image: avatarUrl != null && avatarUrl!.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(avatarUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: avatarUrl == null || avatarUrl!.isEmpty
                ? Center(
                    child: Text(
                      _initials,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: tokens.primary,
                      ),
                    ),
                  )
                : null,
          ),
          if (isPremium)
            Positioned(
              top: -6,
              left: 0,
              right: 0,
              child: Icon(
                AppPhosphorIcons.crown,
                size: 20,
                color: const Color(0xFFFBBF24),
              ),
            ),
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isOnline
                    ? const Color(0xFF22C55E)
                    : tokens.mutedForeground.withValues(alpha: 0.4),
                border: Border.all(color: tokens.card, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
