import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';

const _kCefrOrder = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
const _kLevelLabels = {
  'A1': 'Sơ cấp',
  'A2': 'Tiền trung cấp',
  'B1': 'Trung cấp',
  'B2': 'Trung cấp cao',
  'C1': 'Cao cấp',
  'C2': 'Thành thạo',
};

/// Every CEFR level up to and including [level] — web parity:
/// `getLevelsUpTo` (`hooks/game/use-runner-words.ts`).
List<String> levelsUpTo(String level) {
  final idx = _kCefrOrder.indexOf(level);
  return idx >= 0 ? _kCefrOrder.sublist(0, idx + 1) : [level];
}

/// Blue info card showing which CEFR levels the games will draw from — web
/// parity: `LevelTip` in `game-hub-page.tsx`.
class GameHubLevelTip extends StatelessWidget {
  const GameHubLevelTip({super.key, required this.userLevel});

  final String userLevel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final levels = levelsUpTo(userLevel);
    final levelLabel = _kLevelLabels[userLevel] ?? userLevel;
    final mixNote = levels.length > 1
        ? ' (50% $userLevel, 50% trình độ thấp hơn)'
        : ' (100% $userLevel)';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? Colors.blue.shade900.withValues(alpha: 0.3) : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tokens.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline,
              size: 16, color: isDark ? Colors.blue.shade300 : Colors.blue.shade500),
          const SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: isDark ? Colors.blue.shade300 : Colors.blue.shade700,
                ),
                children: [
                  TextSpan(
                    text: 'Trình độ của bạn: $userLevel ($levelLabel)',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const TextSpan(text: '\nCác trò chơi sẽ luyện từ vựng ở: '),
                  TextSpan(
                    text: levels.join(', '),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: mixNote),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
