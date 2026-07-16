import 'package:flutter/material.dart';
import 'package:deutschtiger/core/theme/app_tokens.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'podcast_index_parts.dart';

/// Widget con của `EasyGermanPodcastPage` (header tím, ô tìm kiếm + chip lọc
/// duration, thanh phân trang) — tách riêng để giữ file trang chính dưới 200
/// dòng.
class PodcastPageHeader extends StatelessWidget {
  const PodcastPageHeader({super.key, required this.tokens, required this.onBack});

  final AppTokens tokens;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(onTap: onBack, child: Icon(Icons.arrow_back, color: tokens.foreground)),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFFAF5FF), Color(0x669333EA)]),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: purple300),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: purple600, borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.mic, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Easy German Podcast', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: tokens.foreground)),
                      Text(AppLocalizations.of(context).podcastDescription, style: TextStyle(fontSize: 11, color: tokens.mutedForeground)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PodcastSearchFilterBar extends StatelessWidget {
  const PodcastSearchFilterBar({
    super.key,
    required this.tokens,
    required this.bucket,
    required this.counts,
    required this.onQueryChanged,
    required this.onBucketChanged,
  });

  final AppTokens tokens;
  final DurationBucket bucket;
  final Map<DurationBucket, int> counts;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<DurationBucket> onBucketChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(color: tokens.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: tokens.border)),
          child: TextField(
            onChanged: onQueryChanged,
            decoration: InputDecoration(
              hintText: l10n.podcastSearchHint,
              prefixIcon: const Icon(Icons.search, size: 18),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: DurationBucket.values.map((b) {
            final active = b == bucket;
            return GestureDetector(
              onTap: () => onBucketChanged(b),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: active ? purple600 : tokens.card,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: active ? purple600 : tokens.border),
                ),
                child: Text(
                  '${b.label(l10n)} ${counts[b]}',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: active ? Colors.white : tokens.mutedForeground),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class PodcastPaginationRow extends StatelessWidget {
  const PodcastPaginationRow({
    super.key,
    required this.tokens,
    required this.page,
    required this.totalPages,
    required this.totalCount,
    required this.onChanged,
  });

  final AppTokens tokens;
  final int page;
  final int totalPages;
  final int totalCount;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: page > 1 ? () => onChanged(page - 1) : null,
            icon: const Icon(Icons.chevron_left, size: 16),
            label: Text(l10n.examSetPagePrev),
          ),
          Text(l10n.podcastPageInfo(page, totalPages, totalCount), style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
          TextButton.icon(
            onPressed: page < totalPages ? () => onChanged(page + 1) : null,
            icon: const Icon(Icons.chevron_right, size: 16),
            label: Text(l10n.examSetPageNext),
          ),
        ],
      ),
    );
  }
}
