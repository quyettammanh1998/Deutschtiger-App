import 'package:flutter/material.dart';

import 'package:deutschtiger/core/theme/app_tokens.dart';

/// Shared row-avatar for friends/messages/chat/search lists. Web parity:
/// `components/social/user-avatar.tsx` `sm`/`md` sizes (the `lg` cover-header
/// variant with premium ring/crown lives in [ProfileCoverHeader] instead).
class SocialAvatar extends StatelessWidget {
  const SocialAvatar({
    super.key,
    required this.displayName,
    required this.avatarUrl,
    this.size = 40,
    this.showOnlineDot = false,
    this.isOnline = false,
  });

  final String displayName;
  final String? avatarUrl;
  final double size;
  final bool showOnlineDot;
  final bool isOnline;

  String get _initials {
    final parts = displayName.trim().split(RegExp(r'\s+'));
    final letters = parts.where((p) => p.isNotEmpty).map((p) => p[0]).take(2);
    final initials = letters.join().toUpperCase();
    return initials.isEmpty ? '?' : initials;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final hasUrl = avatarUrl != null && avatarUrl!.isNotEmpty;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: tokens.primary.withValues(alpha: 0.2),
              image: hasUrl
                  ? DecorationImage(image: NetworkImage(avatarUrl!), fit: BoxFit.cover)
                  : null,
            ),
            child: hasUrl
                ? null
                : Center(
                    child: Text(
                      _initials,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: size * 0.35,
                        color: tokens.primary,
                      ),
                    ),
                  ),
          ),
          if (showOnlineDot)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: size * 0.3,
                height: size * 0.3,
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
