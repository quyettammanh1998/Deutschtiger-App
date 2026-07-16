import 'package:flutter/material.dart';

import '../../../core/icons/app_phosphor_icons.dart';
import '../../../core/theme/app_tokens.dart';
import '../leaderboard_screen.dart';
import 'leaderboard_score_chips.dart';

const _podiumRing = {
  1: Color(0xFFC084FC),
  2: Color(0xFFFBBF24),
  3: Color(0xFFD8B4FE),
};
const _podiumBg = {
  1: Color(0xFFA855F7),
  2: Color(0xFF60A5FA),
  3: Color(0xFFC084FC),
};
const _podiumBadgeBg = {
  1: Color(0xFFFBBF24),
  2: Color(0xFF60A5FA),
  3: Color(0xFFC084FC),
};
const _avatarSize = {1: 56.0, 2: 44.0, 3: 44.0};

/// Top-3 podium card — #1 center/tallest with crown, #2 left, #3 right.
/// Mirror web `weekly-leaderboard.tsx` `Podium`/`PodiumAvatar`.
class LeaderboardPodium extends StatelessWidget {
  const LeaderboardPodium({
    super.key,
    required this.entries,
    required this.onShowDetails,
  });

  final List<LeaderboardEntry> entries;
  final ValueChanged<LeaderboardEntry> onShowDetails;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    if (entries.isEmpty) return const SizedBox.shrink();
    final first = entries[0];
    final second = entries.length > 1 ? entries[1] : null;
    final third = entries.length > 2 ? entries[2] : null;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tokens.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (second != null)
            Padding(
              padding: const EdgeInsets.only(top: 24, right: 8),
              child: _PodiumAvatar(
                entry: second,
                rank: 2,
                onTap: () => onShowDetails(second),
              ),
            ),
          _PodiumAvatar(
            entry: first,
            rank: 1,
            onTap: () => onShowDetails(first),
          ),
          if (third != null)
            Padding(
              padding: const EdgeInsets.only(top: 24, left: 8),
              child: _PodiumAvatar(
                entry: third,
                rank: 3,
                onTap: () => onShowDetails(third),
              ),
            ),
        ],
      ),
    );
  }
}

class _PodiumAvatar extends StatelessWidget {
  const _PodiumAvatar({
    required this.entry,
    required this.rank,
    required this.onTap,
  });

  final LeaderboardEntry entry;
  final int rank;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final size = _avatarSize[rank] ?? 56.0;
    final ring = _podiumRing[rank] ?? tokens.border;
    final bg = _podiumBg[rank] ?? tokens.muted;
    final badgeBg = _podiumBadgeBg[rank] ?? tokens.muted;
    final name = entry.displayName.trim().isEmpty
        ? '?'
        : entry.displayName.trim();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (rank == 1)
            const Icon(Icons.emoji_events, size: 20, color: Color(0xFFFBBF24)),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: bg,
                  border: Border.all(color: ring, width: 3),
                ),
                child: entry.avatarUrl == null
                    ? Center(
                        child: Text(
                          name.characters.first.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: rank == 1 ? 18 : 14,
                          ),
                        ),
                      )
                    : ClipOval(
                        child: Image.network(
                          entry.avatarUrl!,
                          width: size,
                          height: size,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              Positioned(
                bottom: -4,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: badgeBg,
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 2),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '$rank',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 90),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: tokens.foreground,
                    ),
                  ),
                ),
                if (entry.isNewUserDampened) ...[
                  const SizedBox(width: 2),
                  Icon(
                    AppPhosphorIcons.info,
                    size: 10,
                    color: Colors.amber.shade700,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF1F2937),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '${entry.xp}',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 4),
          LeaderboardScoreChips(entry: entry),
        ],
      ),
    );
  }
}
