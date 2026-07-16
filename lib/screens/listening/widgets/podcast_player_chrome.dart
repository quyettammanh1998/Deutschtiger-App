import 'package:flutter/material.dart';
import 'package:deutschtiger/core/theme/app_tokens.dart';
import 'package:deutschtiger/data/listening/podcast_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'podcast_reader_settings_sheet.dart';
import 'podcast_sentence_row.dart';

/// Widget con của `EasyGermanPodcastPlayerPage` (header, empty/error state,
/// danh sách transcript) — tách riêng để giữ file trang chính dưới 200 dòng.

class PodcastPlayerHeader extends StatelessWidget {
  const PodcastPlayerHeader({
    super.key,
    required this.tokens,
    required this.title,
    required this.onBack,
    required this.fontScale,
    required this.showTranslation,
    required this.onSettingsSaved,
  });

  final AppTokens tokens;
  final String title;
  final VoidCallback onBack;
  final double fontScale;
  final bool showTranslation;
  final void Function(double scale, bool showVi) onSettingsSaved;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(color: tokens.card, border: Border(bottom: BorderSide(color: tokens.border))),
      child: Row(
        children: [
          InkWell(onTap: onBack, child: Icon(Icons.arrow_back, color: tokens.foreground)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: tokens.foreground)),
                Text('Easy German Podcast', style: TextStyle(fontSize: 11, color: tokens.mutedForeground)),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.settings_outlined, color: tokens.mutedForeground),
            onPressed: () => PodcastReaderSettingsSheet.show(
              context,
              initialScale: fontScale,
              initialShowVi: showTranslation,
              onSave: onSettingsSaved,
            ),
          ),
        ],
      ),
    );
  }
}

class PodcastPlayerErrorView extends StatelessWidget {
  const PodcastPlayerErrorView({super.key, required this.tokens, required this.onBack});

  final AppTokens tokens;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, size: 56, color: tokens.mutedForeground),
          const SizedBox(height: 12),
          Text(l10n.podcastEpisodeLoadError, style: TextStyle(color: tokens.mutedForeground)),
          const SizedBox(height: 12),
          TextButton(onPressed: onBack, child: Text(l10n.podcastBackToList)),
        ],
      ),
    );
  }
}

class PodcastTranscriptList extends StatelessWidget {
  const PodcastTranscriptList({
    super.key,
    required this.tokens,
    required this.episode,
    required this.scrollController,
    required this.sentenceKeys,
    required this.activeSentenceIdx,
    required this.fontScale,
    required this.showTranslation,
    required this.activeWordIndexOf,
    required this.onSentenceTap,
  });

  final AppTokens tokens;
  final PodcastEpisodeDetail episode;
  final ScrollController scrollController;
  final List<GlobalKey> sentenceKeys;
  final int activeSentenceIdx;
  final double fontScale;
  final bool showTranslation;
  final int Function(PodcastSentence sentence) activeWordIndexOf;
  final void Function(int index) onSentenceTap;

  @override
  Widget build(BuildContext context) {
    if (episode.sentences.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context).podcastTranscriptEmpty, style: TextStyle(color: tokens.mutedForeground)),
      );
    }
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(fontScale)),
      child: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
        itemCount: episode.sentences.length,
        itemBuilder: (context, i) {
          final sentence = episode.sentences[i];
          final isActive = i == activeSentenceIdx;
          return KeyedSubtree(
            key: sentenceKeys[i],
            child: PodcastSentenceRow(
              sentence: sentence,
              isActive: isActive,
              activeWordIndex: isActive ? activeWordIndexOf(sentence) : -1,
              showVi: showTranslation,
              onTap: () => onSentenceTap(i),
            ),
          );
        },
      ),
    );
  }
}
