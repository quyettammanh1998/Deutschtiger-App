import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../data/games/runner_personal_best.dart';
import 'runner_leaderboard_panel.dart';

/// Deutsch Runner completion view — record banner (when [isNewRecord]) +
/// score card + [RunnerLeaderboardPanel].
class RunnerResultsView extends StatelessWidget {
  const RunnerResultsView({
    super.key,
    required this.score,
    required this.correct,
    required this.total,
    required this.lives,
    required this.isNewRecord,
    required this.personalBest,
    required this.onPlayAgain,
    required this.onGoHome,
  });

  final int score;
  final int correct;
  final int total;
  final int lives;
  final bool isNewRecord;
  final RunnerPersonalBest? personalBest;
  final VoidCallback onPlayAgain;
  final VoidCallback onGoHome;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return SingleChildScrollView(
      child: Column(
        children: [
          if (isNewRecord)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF59E0B), Color(0xFFF97316)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '🏆 Kỷ lục mới — $score điểm!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: tokens.card,
              borderRadius: BorderRadius.circular(tokens.radius),
              border: Border.all(color: tokens.border),
            ),
            child: Column(
              children: [
                Text(
                  'Hoàn thành!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: tokens.foreground,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$score điểm',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    color: tokens.primary,
                  ),
                ),
                Text(
                  'Đúng $correct/$total · Mạng còn $lives/3',
                  style: TextStyle(color: tokens.mutedForeground),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onGoHome,
                        child: const Text('Về trang chủ'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: onPlayAgain,
                        child: const Text('Chơi lại'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          RunnerLeaderboardPanel(personalBest: personalBest),
        ],
      ),
    );
  }
}
