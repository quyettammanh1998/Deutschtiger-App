import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/design_tokens.dart';
import '../../../data/news/news_models.dart';
import '../../../shared/widgets/tappable_sentence.dart';

/// Segmented control chọn CEFR level của bài (level switcher — chỉ hiện khi
/// bài có >1 level, giống `LevelSwitcher` của web).
class NewsLevelSwitcher extends StatelessWidget {
  const NewsLevelSwitcher({
    super.key,
    required this.levels,
    required this.active,
    required this.onChanged,
  });

  final List<String> levels;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: DesignTokens.spacingSm,
      children: [
        for (final level in levels)
          ChoiceChip(
            label: Text(level),
            selected: active == level,
            onSelected: (_) => onChanged(level),
            selectedColor: DesignTokens.tigerOrange,
            labelStyle: TextStyle(
              fontWeight: FontWeight.w700,
              color: active == level ? Colors.white : DesignTokens.foreground,
            ),
          ),
      ],
    );
  }
}

/// Phát audio bài đọc — hỗ trợ tốc độ thường/chậm khi `audioUrlSlow` có mặt
/// (giống `NewsAudioPlayer` của web). Tách stateful player riêng để widget
/// tái sử dụng được không phụ thuộc audio backend cụ thể.
class NewsAudioBar extends StatefulWidget {
  const NewsAudioBar({super.key, required this.audioUrl, this.audioUrlSlow});

  final String audioUrl;
  final String? audioUrlSlow;

  @override
  State<NewsAudioBar> createState() => _NewsAudioBarState();
}

class _NewsAudioBarState extends State<NewsAudioBar> {
  late final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  bool _slow = false;
  String? _loadedUrl;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String get _activeUrl =>
      (_slow ? widget.audioUrlSlow : null) ?? widget.audioUrl;

  Future<void> _togglePlay() async {
    try {
      if (_loadedUrl != _activeUrl) {
        await _player.setUrl(_activeUrl);
        _loadedUrl = _activeUrl;
      }
      if (_player.playing) {
        await _player.pause();
      } else {
        await _player.play();
      }
      if (mounted) setState(() => _isPlaying = _player.playing);
    } catch (_) {
      if (mounted) setState(() => _isPlaying = false);
    }
  }

  Future<void> _toggleSpeed() async {
    final wasPlaying = _player.playing;
    await _player.stop();
    setState(() {
      _slow = !_slow;
      _loadedUrl = null;
      _isPlaying = false;
    });
    if (wasPlaying) await _togglePlay();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingMd),
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingMd,
        vertical: DesignTokens.spacingSm,
      ),
      decoration: BoxDecoration(
        color: DesignTokens.muted,
        borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
      ),
      child: Row(
        children: [
          IconButton.filled(
            onPressed: _togglePlay,
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            style: IconButton.styleFrom(
              backgroundColor: DesignTokens.tigerOrange,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(width: DesignTokens.spacingSm),
          const Expanded(
            child: Text(
              'Nghe bài đọc',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          if (widget.audioUrlSlow != null)
            TextButton(
              onPressed: _toggleSpeed,
              child: Text(_slow ? 'Chậm' : 'Thường'),
            ),
        ],
      ),
    );
  }
}

/// Thân bài — mặc định hiển thị văn xuôi liền mạch; bật "Hiện bản dịch" thì
/// tách từng câu DE + VI bên dưới (giống `SentenceReader` của web). Tap 1 từ
/// gọi [onWordTap] để mở word-lookup sheet.
class NewsSentenceReader extends StatefulWidget {
  const NewsSentenceReader({
    super.key,
    required this.sentences,
    required this.onWordTap,
  });

  final List<NewsSentence> sentences;
  final ValueChanged<String> onWordTap;

  @override
  State<NewsSentenceReader> createState() => _NewsSentenceReaderState();
}

class _NewsSentenceReaderState extends State<NewsSentenceReader> {
  bool _showVi = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: OutlinedButton.icon(
            onPressed: () => setState(() => _showVi = !_showVi),
            icon: const Icon(Icons.translate, size: 16),
            label: Text(_showVi ? 'Ẩn bản dịch' : 'Hiện bản dịch'),
          ),
        ),
        const SizedBox(height: DesignTokens.spacingSm),
        if (_showVi)
          for (final s in widget.sentences)
            Padding(
              padding: const EdgeInsets.only(bottom: DesignTokens.spacingSm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TappableSentence(
                    text: s.de,
                    onWordTap: widget.onWordTap,
                    style: const TextStyle(fontSize: 16, height: 1.6),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.only(left: DesignTokens.spacingSm),
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Color(0xFF7DD3FC), width: 2),
                      ),
                    ),
                    child: Text(
                      s.vi,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF0369A1),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            )
        else
          Wrap(
            children: [
              for (final s in widget.sentences)
                TappableSentence(
                  text: '${s.de} ',
                  onWordTap: widget.onWordTap,
                  style: const TextStyle(fontSize: 16, height: 1.7),
                ),
            ],
          ),
      ],
    );
  }
}

/// Danh sách từ vựng cuối bài (`vocab[]`).
class NewsVocabList extends StatelessWidget {
  const NewsVocabList({super.key, required this.vocab});

  final List<NewsVocab> vocab;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: DesignTokens.card,
        borderRadius: BorderRadius.circular(DesignTokens.radius),
        border: Border.all(color: DesignTokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Từ vựng',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          for (final v in vocab)
            Padding(
              padding: const EdgeInsets.only(bottom: DesignTokens.spacingSm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: v.wordDe,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const TextSpan(text: '  —  '),
                        TextSpan(
                          text: v.meaningVi,
                          style: const TextStyle(
                            color: DesignTokens.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (v.exampleDe.isNotEmpty)
                    Text(
                      v.exampleDe,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                        color: DesignTokens.mutedForeground,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Gợi ý luyện Sprechen/Schreiben cuối bài (B1/B2), khớp card
/// "Goethe-Übung" của web.
class NewsExamPromptsCard extends StatelessWidget {
  const NewsExamPromptsCard({
    super.key,
    this.speakingPrompt,
    this.writingPrompt,
  });

  final String? speakingPrompt;
  final String? writingPrompt;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: DesignTokens.card,
        borderRadius: BorderRadius.circular(DesignTokens.radius),
        border: const Border(
          left: BorderSide(color: DesignTokens.orange500, width: 4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🎯 Goethe-Übung',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          if ((speakingPrompt ?? '').isNotEmpty) ...[
            const SizedBox(height: DesignTokens.spacingSm),
            const Text(
              'SPRECHEN',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: DesignTokens.orange500,
              ),
            ),
            Text(speakingPrompt!),
          ],
          if ((writingPrompt ?? '').isNotEmpty) ...[
            const SizedBox(height: DesignTokens.spacingSm),
            const Text(
              'SCHREIBEN',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: DesignTokens.orange500,
              ),
            ),
            Text(writingPrompt!),
          ],
        ],
      ),
    );
  }
}
