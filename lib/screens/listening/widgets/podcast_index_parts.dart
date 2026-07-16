import 'package:flutter/material.dart';
import 'package:deutschtiger/core/theme/app_tokens.dart';
import 'package:deutschtiger/data/listening/podcast_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';

/// Widget con của `EasyGermanPodcastPage` (stats box + episode row + bộ lọc
/// duration) — tách riêng để giữ file trang chính dưới 200 dòng.
const purple600 = Color(0xFF9333EA);
const purple300 = Color(0xFFD8B4FE);

enum DurationBucket { all, le10, le20, le60, gt60 }

extension DurationBucketX on DurationBucket {
  String label(AppLocalizations l10n) => switch (this) {
        DurationBucket.all => l10n.allFilters,
        DurationBucket.le10 => l10n.podcastDurationLe10,
        DurationBucket.le20 => l10n.podcastDurationLe20,
        DurationBucket.le60 => l10n.podcastDurationLe60,
        DurationBucket.gt60 => l10n.podcastDurationGt60,
      };

  bool matches(int seconds) => switch (this) {
        DurationBucket.all => true,
        DurationBucket.le10 => seconds <= 600,
        DurationBucket.le20 => seconds > 600 && seconds <= 1200,
        DurationBucket.le60 => seconds > 1200 && seconds <= 3600,
        DurationBucket.gt60 => seconds > 3600,
      };
}

String formatPodcastDuration(int seconds) {
  final m = seconds ~/ 60;
  final s = seconds % 60;
  return '$m:${s.toString().padLeft(2, '0')}';
}

class PodcastStatBox extends StatelessWidget {
  const PodcastStatBox({super.key, required this.value, required this.label, required this.tokens});
  final String value;
  final String label;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(color: tokens.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: tokens.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: tokens.foreground)),
          Text(label, style: TextStyle(fontSize: 11, color: tokens.mutedForeground)),
        ],
      ),
    );
  }
}

class PodcastEpisodeRow extends StatelessWidget {
  const PodcastEpisodeRow({
    super.key,
    required this.index,
    required this.episode,
    required this.completed,
    required this.tokens,
    required this.onTap,
  });

  final int index;
  final PodcastEpisode episode;
  final bool completed;
  final AppTokens tokens;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: tokens.card,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: tokens.border)),
          child: Row(
            children: [
              SizedBox(
                width: 22,
                child: completed
                    ? const Icon(Icons.check, size: 16, color: Colors.green)
                    : Text('${index + 1}', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: tokens.mutedForeground)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(episode.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: tokens.foreground)),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(Icons.schedule, size: 12, color: tokens.mutedForeground),
                        const SizedBox(width: 3),
                        Text(formatPodcastDuration(episode.duration), style: TextStyle(fontSize: 11, color: tokens.mutedForeground)),
                        const SizedBox(width: 10),
                        Text(AppLocalizations.of(context).easyGermanSentenceCount(episode.segments), style: TextStyle(fontSize: 11, color: tokens.mutedForeground)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(color: purple600, shape: BoxShape.circle),
                child: const Icon(Icons.play_arrow, color: Colors.white, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
