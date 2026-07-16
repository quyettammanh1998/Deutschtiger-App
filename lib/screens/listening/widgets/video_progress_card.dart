import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:deutschtiger/core/theme/app_tokens.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';

/// Progress ring + 3-stat strip cho 1 bộ sưu tập video. Web parity:
/// `components/listening/video-progress-card.tsx`.
class VideoProgressCard extends StatelessWidget {
  const VideoProgressCard({
    super.key,
    required this.completedCount,
    required this.totalVideos,
    required this.pendingCount,
    required this.totalRewatch,
    this.message,
    this.completionLabel,
  });

  final int completedCount;
  final int totalVideos;
  final int pendingCount;
  final int totalRewatch;
  final String Function(int completed, int total)? message;
  final String? completionLabel;

  String _defaultMessage(AppLocalizations l10n, int completed, int total) {
    if (total == 0) return l10n.videoCollectionProgressEmpty;
    if (completed == 0) return l10n.videoCollectionProgressStart;
    if (completed >= total) return l10n.videoCollectionProgressDone;
    if (completed >= (total * 0.7).ceil()) return l10n.videoCollectionProgressFinalStretch;
    if (completed >= (total * 0.4).ceil()) {
      return l10n.videoCollectionProgressGoodPace;
    }
    return l10n.videoCollectionProgressGoodStart;
  }

  Color _ringColor(int completed, int total) {
    if (total == 0) return const Color(0xFF94A3B8);
    final progress = completed / total;
    if (progress >= 1) return const Color(0xFF10B981);
    if (progress < 0.5) return const Color(0xFFF59E0B);
    return const Color(0xFF6366F1);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final progress = totalVideos > 0
        ? math.min(completedCount / totalVideos, 1.0)
        : 0.0;
    final percent = (progress * 100).round();
    final remaining = math.max(totalVideos - completedCount, 0);
    final ringColor = _ringColor(completedCount, totalVideos);
    final msg = message != null
        ? message!(completedCount, totalVideos)
        : _defaultMessage(l10n, completedCount, totalVideos);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 56,
                height: 56,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 5,
                      backgroundColor: tokens.border,
                      valueColor: AlwaysStoppedAnimation(ringColor),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$completedCount',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: percent >= 100
                                ? Colors.green.shade600
                                : tokens.foreground,
                          ),
                        ),
                        Text(
                          '/$totalVideos',
                          style: TextStyle(
                            fontSize: 9,
                            color: tokens.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.coursesProgressTitle,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: tokens.foreground,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      msg,
                      style: TextStyle(
                        fontSize: 11,
                        color: tokens.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _StatCell(label: l10n.statsMasteryLearning, value: '$pendingCount', color: Colors.amber.shade700, tokens: tokens),
              const SizedBox(width: 8),
              _StatCell(label: l10n.videoCollectionStatRewatch, value: '$totalRewatch', color: tokens.primary, tokens: tokens),
              const SizedBox(width: 8),
              _StatCell(label: l10n.videoCollectionStatRemaining, value: '$remaining', color: tokens.foreground, tokens: tokens),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: tokens.muted,
              valueColor: AlwaysStoppedAnimation(
                percent >= 100 ? Colors.green.shade500 : tokens.primary,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.videoCollectionPercentLabel(percent, completionLabel ?? l10n.videoCollectionCompletionLabel),
                style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
              ),
              Text(
                l10n.videoCollectionSavedCount(completedCount + pendingCount),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: tokens.foreground,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.label,
    required this.value,
    required this.color,
    required this.tokens,
  });

  final String label;
  final String value;
  final Color color;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: tokens.muted.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 10, color: tokens.mutedForeground)),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
