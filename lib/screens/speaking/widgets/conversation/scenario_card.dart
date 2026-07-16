import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../data/speech/conversation_display.dart';
import 'conversation_topic_icon.dart';
import 'tailwind_gradient.dart';

/// CEFR pastel badge — active-filter pills go solid via [active].
class LevelBadge extends StatelessWidget {
  const LevelBadge({super.key, required this.level, this.active = false});

  final String level;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = levelBadgeColors(level);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: active ? tokens.foreground : Color(colors.background),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        level,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: active ? tokens.background : Color(colors.foreground),
        ),
      ),
    );
  }
}

/// Topic tile for the conversation hub grid: gradient icon tile + German
/// title + Vietnamese gloss + CEFR badge. Web parity: `scenario-card.tsx`.
class ConversationScenarioCard extends StatelessWidget {
  const ConversationScenarioCard({
    super.key,
    required this.titleDe,
    required this.titleVi,
    required this.level,
    required this.gradientFrom,
    required this.gradientTo,
    required this.icon,
    required this.onTap,
  });

  final String titleDe;
  final String titleVi;
  final String level;
  final String gradientFrom;
  final String gradientTo;
  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Material(
      color: tokens.card,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: tokens.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: TailwindGradient.gradient(gradientFrom, gradientTo),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: ConversationTopicIcon(
                    name: icon,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                titleDe,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: tokens.foreground,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                titleVi,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
              ),
              const SizedBox(height: 8),
              LevelBadge(level: level),
            ],
          ),
        ),
      ),
    );
  }
}
