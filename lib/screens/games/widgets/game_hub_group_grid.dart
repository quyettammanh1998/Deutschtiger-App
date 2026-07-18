import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';

/// One game card within a [GameHubGroup] — web parity: `GameModeCard` in
/// `game-hub-page.tsx` (gradient icon tile, title, description).
class GameHubCard {
  const GameHubCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.to,
    required this.gradient,
  });

  final String title;
  final String description;
  final IconData icon;
  final String to;
  final List<Color> gradient;
}

/// A skill/grammar-topic section of game cards — web parity: `GAME_GROUPS`.
class GameHubGroup {
  const GameHubGroup({required this.title, required this.games});

  final String title;
  final List<GameHubCard> games;
}

/// Renders one [GameHubGroup]: uppercase muted heading + 2-col card grid.
class GameHubGroupSection extends StatelessWidget {
  const GameHubGroupSection({super.key, required this.group});

  final GameHubGroup group;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            group.title.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
              color: tokens.mutedForeground,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.98,
          ),
          itemCount: group.games.length,
          itemBuilder: (context, i) => _GameHubCardTile(card: group.games[i]),
        ),
      ],
    );
  }
}

class _GameHubCardTile extends StatelessWidget {
  const _GameHubCardTile({required this.card});

  final GameHubCard card;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => context.push(card.to),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: tokens.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: tokens.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: card.gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(card.icon, color: Colors.white, size: 22),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                card.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: tokens.foreground,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
            Flexible(
              child: Text(
                card.description,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
