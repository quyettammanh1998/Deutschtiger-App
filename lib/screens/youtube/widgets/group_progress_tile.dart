import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Divided-list group row shared by video-library and interview roadmap
/// screens — web parity: both use the same visual language (progress bar +
/// motivation, blue level pill, amber "started"/green "complete" states,
/// zero-padded index) per `VideoLibraryTrackerPage`/`InterviewRoadmap`.
class GroupProgressTile extends StatelessWidget {
  const GroupProgressTile({
    super.key,
    required this.order,
    required this.nameDe,
    required this.nameVi,
    required this.videoCount,
    required this.level,
    required this.onTap,
    this.completed = 0,
    this.total = 0,
  });

  final int order;
  final String nameDe;
  final String nameVi;
  final int videoCount;
  final String level;
  final int completed;
  final int total;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final effectiveTotal = total > 0 ? total : videoCount;
    final isComplete = effectiveTotal > 0 && completed >= effectiveTotal;
    final isStarted = completed > 0 && !isComplete;
    return Material(
      color: tokens.card,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border(bottom: BorderSide(color: tokens.border.withValues(alpha: 0.6))),
          ),
          child: Row(
            children: [
              _IndexCircle(
                order: order,
                isComplete: isComplete,
                isStarted: isStarted,
                tokens: tokens,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nameDe,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: tokens.foreground,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '$nameVi · $videoCount video',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                          ),
                        ),
                        if (level.isNotEmpty) ...[
                          const SizedBox(width: 6),
                          _LevelPill(level: level, tokens: tokens),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              if (effectiveTotal > 0)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    '$completed/$effectiveTotal',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isComplete
                          ? tokens.success
                          : (isStarted ? tokens.warning : tokens.mutedForeground),
                    ),
                  ),
                ),
              const SizedBox(width: 4),
              Icon(PhosphorIcons.caretRight, color: tokens.mutedForeground, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _IndexCircle extends StatelessWidget {
  const _IndexCircle({
    required this.order,
    required this.isComplete,
    required this.isStarted,
    required this.tokens,
  });

  final int order;
  final bool isComplete;
  final bool isStarted;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    final bg = isComplete
        ? tokens.success.withValues(alpha: 0.15)
        : isStarted
        ? tokens.warning.withValues(alpha: 0.15)
        : tokens.muted.withValues(alpha: 0.5);
    final fg = isComplete ? tokens.success : (isStarted ? tokens.warning : tokens.mutedForeground);
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: isComplete
          ? Icon(PhosphorIcons.check, color: fg, size: 18)
          : Text(
              order.toString().padLeft(2, '0'),
              style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 13),
            ),
    );
  }
}

class _LevelPill extends StatelessWidget {
  const _LevelPill({required this.level, required this.tokens});

  final String level;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    // Blue level pill — web parity (level badge on group rows).
    const blue = Color(0xFF2563EB);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: blue.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        level,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: blue),
      ),
    );
  }
}

/// Motivation line under the overall progress bar — web shows a short VN
/// phrase keyed by completion percentage on both video-library tracker and
/// interview roadmap.
String motivationForProgress(int completed, int total) {
  if (total <= 0) return 'Bắt đầu hành trình của bạn!';
  final pct = completed / total;
  if (pct >= 1) return 'Xuất sắc — bạn đã hoàn thành tất cả! 🎉';
  if (pct >= 0.66) return 'Sắp về đích rồi, cố lên! 💪';
  if (pct >= 0.33) return 'Đang tiến bộ tốt, tiếp tục nhé! 🔥';
  if (pct > 0) return 'Khởi đầu tốt, giữ nhịp học đều đặn nhé!';
  return 'Bắt đầu hành trình của bạn!';
}
