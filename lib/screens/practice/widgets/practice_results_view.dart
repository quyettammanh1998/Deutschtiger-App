import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/practice/practice_result.dart';
import '../../../l10n/app_localizations.dart';

/// Màn kết quả sau khi hoàn thành 1 phiên luyện tập theo deck.
class PracticeResultsView extends StatelessWidget {
  const PracticeResultsView({
    super.key,
    required this.results,
    required this.onRestart,
    required this.onBackToDeck,
  });

  final List<PracticeResultEntry> results;
  final VoidCallback onRestart;
  final VoidCallback onBackToDeck;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final correctCount = results.where((r) => r.correct).length;
    final accuracy = results.isEmpty
        ? 0
        : (correctCount / results.length * 100).round();

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                accuracy >= 70 ? Icons.emoji_events : Icons.refresh,
                size: 56,
                color: accuracy >= 70 ? Colors.amber : Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.practiceResultsTitle,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                '$accuracy%',
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.tigerOrange),
              ),
              Text(
                l10n.practiceAccuracySummary(correctCount, results.length),
                style: const TextStyle(color: AppColors.mutedForeground),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onBackToDeck,
                      child: Text(l10n.practiceBackToDeck),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: onRestart,
                      child: Text(l10n.practiceRestart),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
