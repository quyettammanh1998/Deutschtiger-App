import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import 'package:deutschtiger/data/youtube/youtube_video.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';

/// Private helper widgets for [YouTubeTrackerScreen] — split out to respect
/// the 200-LOC guideline.
class ContinueWatchingStrip extends StatelessWidget {
  const ContinueWatchingStrip({super.key, required this.videos, required this.onTap});

  final List<YouTubeVideo> videos;
  final void Function(YouTubeVideo) onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context).youtubeContinueWatching,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: tokens.foreground),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 130,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: videos.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final v = videos[i];
                return GestureDetector(
                  onTap: () => onTap(v),
                  child: SizedBox(
                    width: 160,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            v.thumbnailUrl ??
                                'https://img.youtube.com/vi/${v.videoId}/mqdefault.jpg',
                            width: 160,
                            height: 90,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                Container(width: 160, height: 90, color: tokens.muted),
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Flexible: the ListView gives this item a fixed
                        // cross-axis height (130), and the 2-line title can
                        // overflow it at German 200% text scale without this.
                        Flexible(
                          child: Text(
                            v.title ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12, color: tokens.foreground),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AddVideoForm extends StatelessWidget {
  const AddVideoForm({
    super.key,
    required this.controller,
    required this.adding,
    required this.error,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final bool adding;
  final String? error;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: l10n.youtubePasteUrlHint,
                  filled: true,
                  fillColor: tokens.card,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: tokens.border),
                  ),
                ),
                onSubmitted: (_) => onSubmit(),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: tokens.primary),
              onPressed: adding ? null : onSubmit,
              child: adding
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(l10n.deckAddCard),
            ),
          ],
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(error!, style: TextStyle(color: tokens.destructive, fontSize: 12)),
          ),
      ],
    );
  }
}

class PopularVideosSection extends StatelessWidget {
  const PopularVideosSection({super.key, required this.videos, required this.onTap});

  final List<YouTubePopularVideo> videos;
  final void Function(YouTubePopularVideo) onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context).youtubePopularVideos,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: tokens.foreground),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: videos.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final v = videos[i];
                return GestureDetector(
                  onTap: () => onTap(v),
                  child: SizedBox(
                    width: 160,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            v.thumbnailUrl,
                            width: 160,
                            height: 90,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                Container(width: 160, height: 90, color: tokens.muted),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Flexible(
                          child: Text(
                            v.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12, color: tokens.foreground),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
