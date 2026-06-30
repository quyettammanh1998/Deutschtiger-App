import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import 'package:deutschtiger/data/listening/podcast_models.dart';

/// Easy German Podcast Player Page - Audio player with transcript, word highlighting, and seek.
class EasyGermanPodcastPlayerPage extends ConsumerStatefulWidget {
  const EasyGermanPodcastPlayerPage({
    super.key,
    required this.episode,
    required this.seriesId,
  });

  final PodcastEpisode episode;
  final String seriesId;

  @override
  ConsumerState<EasyGermanPodcastPlayerPage> createState() =>
      _EasyGermanPodcastPlayerPageState();
}

class _EasyGermanPodcastPlayerPageState
    extends ConsumerState<EasyGermanPodcastPlayerPage> {
  bool _isPlaying = false;
  double _currentPosition = 0.0;
  double _duration = 0.0;
  bool _showTranscript = true;
  bool _showTranslation = true;
  bool _highlightMode = true;
  double _playbackSpeed = 1.0;
  Timer? _progressTimer;
  final Set<String> _highlightedWords = {};
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _duration = widget.episode.durationSeconds.toDouble();
    _startProgressSimulation();
  }

  void _startProgressSimulation() {
    _progressTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_isPlaying && mounted) {
        setState(() {
          _currentPosition += 0.5 * _playbackSpeed;
          if (_currentPosition >= _duration) {
            _currentPosition = _duration;
            _isPlaying = false;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _seek(double position) {
    setState(() {
      _currentPosition = position.clamp(0.0, _duration);
    });
  }

  void _seekForward() {
    _seek(_currentPosition + 10);
  }

  void _seekBackward() {
    _seek(_currentPosition - 10);
  }

  void _toggleHighlightWord(String word) {
    setState(() {
      if (_highlightedWords.contains(word)) {
        _highlightedWords.remove(word);
      } else {
        _highlightedWords.add(word);
      }
    });
  }

  String _formatTime(double seconds) {
    final mins = (seconds / 60).floor();
    final secs = (seconds % 60).floor();
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildAudioPlayer(),
                    _buildControls(),
                    _buildEpisodeInfo(),
                    if (_showTranscript) _buildTranscript(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.foreground),
              onPressed: () => context.pop(),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Easy German Podcast',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.foreground,
                  ),
                ),
                Text(
                  'Tập ${widget.episode.episodeNumber}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              _showTranscript ? Icons.subtitles : Icons.subtitles_outlined,
              color: _showTranscript ? AppColors.primary : Colors.grey,
            ),
            onPressed: () => setState(() => _showTranscript = !_showTranscript),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.foreground),
            onPressed: _showSettingsSheet,
          ),
        ],
      ),
    );
  }

  Widget _buildAudioPlayer() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.15),
            AppColors.tigerOrange.withValues(alpha: 0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          // Podcast cover art
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.podcasts,
              size: 80,
              color: AppColors.tigerOrange,
            ),
          ),
          const SizedBox(height: 24),
          // Title
          Text(
            widget.episode.titleVi,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.foreground,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            widget.episode.descriptionVi,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Progress bar
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
              activeTrackColor: AppColors.tigerOrange,
              inactiveTrackColor: Colors.grey[300],
              thumbColor: AppColors.tigerOrange,
              overlayColor: AppColors.tigerOrange.withValues(alpha: 0.2),
            ),
            child: Slider(
              value: _currentPosition,
              max: _duration > 0 ? _duration : 1,
              onChanged: _seek,
            ),
          ),
          // Time labels
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatTime(_currentPosition),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  _formatTime(_duration),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Playback speed
          GestureDetector(
            onTap: _cyclePlaybackSpeed,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(
                '${_playbackSpeed}x',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Rewind 10s
          IconButton(
            icon: const Icon(Icons.replay_10),
            iconSize: 36,
            color: AppColors.foreground,
            onPressed: _seekBackward,
          ),
          const SizedBox(width: 8),
          // Play/Pause button
          GestureDetector(
            onTap: _togglePlayPause,
            child: Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.tigerOrange],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x40F7931E),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Forward 10s
          IconButton(
            icon: const Icon(Icons.forward_10),
            iconSize: 36,
            color: AppColors.foreground,
            onPressed: _seekForward,
          ),
          const SizedBox(width: 16),
          // Bookmark
          IconButton(
            icon: const Icon(Icons.bookmark_add_outlined),
            color: AppColors.foreground,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã lưu bookmark')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEpisodeInfo() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Thông tin tập',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.foreground,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.timer,
            label: 'Thời lượng',
            value: _formatTime(_duration),
          ),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.mic,
            label: 'Người nói',
            value: 'Native Speakers',
          ),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.translate,
            label: 'Cấp độ',
            value: 'A2-B1',
          ),
        ],
      ),
    );
  }

  Widget _buildTranscript() {
    final lines = widget.episode.transcript.split('\n');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Transcript header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.subtitles, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Transcript',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.foreground,
                  ),
                ),
                const Spacer(),
                // Translation toggle
                GestureDetector(
                  onTap: () => setState(() => _showTranslation = !_showTranslation),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _showTranslation
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.translate,
                          size: 16,
                          color: _showTranslation ? AppColors.primary : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Dịch',
                          style: TextStyle(
                            fontSize: 12,
                            color: _showTranslation ? AppColors.primary : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Highlight mode toggle
                GestureDetector(
                  onTap: () => setState(() => _highlightMode = !_highlightMode),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _highlightMode
                          ? AppColors.tigerOrange.withValues(alpha: 0.1)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.highlight,
                          size: 16,
                          color: _highlightMode ? AppColors.tigerOrange : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Tô đậm',
                          style: TextStyle(
                            fontSize: 12,
                            color: _highlightMode ? AppColors.tigerOrange : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm từ trong transcript...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          // Transcript content
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: lines.length,
            itemBuilder: (context, index) {
              final line = lines[index];
              if (line.trim().isEmpty) {
                return const SizedBox(height: 12);
              }

              final isGerman = RegExp(r'^[A-Za-zäöüßÄÖÜ\s\.\,\!\?\-\:]+$')
                  .hasMatch(line.trim());
              final searchQuery = _searchController.text.toLowerCase();

              return GestureDetector(
                onDoubleTap: isGerman
                    ? () {
                        final word = line.trim().split(' ').first;
                        if (word.isNotEmpty) {
                          _toggleHighlightWord(word);
                        }
                      }
                    : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHighlightedLine(line, searchQuery),
                      if (_showTranslation && !isGerman)
                        Text(
                          line.contains('-') ? line : '',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[500],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedLine(String line, String searchQuery) {
    if (searchQuery.isEmpty && !_highlightMode) {
      return Text(
        line,
        style: const TextStyle(
          fontSize: 15,
          color: AppColors.foreground,
          height: 1.6,
        ),
      );
    }

    final spans = <TextSpan>[];
    final lowerLine = line.toLowerCase();
    final lowerSearch = searchQuery.toLowerCase();
    int start = 0;

    while (start < line.length) {
      int matchIndex = -1;
      if (lowerSearch.isNotEmpty) {
        matchIndex = lowerLine.indexOf(lowerSearch, start);
      }

      if (matchIndex == -1 && !_highlightMode) {
        spans.add(TextSpan(text: line.substring(start)));
        break;
      }

      if (matchIndex > start) {
        spans.add(TextSpan(text: line.substring(start, matchIndex)));
        start = matchIndex;
      }

      if (matchIndex == start) {
        final matchLength = lowerSearch.isNotEmpty ? lowerSearch.length : 1;
        final word = line.substring(start, (start + matchLength).clamp(0, line.length));
        spans.add(TextSpan(
          text: word,
          style: TextStyle(
            backgroundColor: AppColors.tigerOrange.withValues(alpha: 0.3),
            fontWeight: FontWeight.bold,
          ),
        ));
        start += matchLength;
      }
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 15,
          color: AppColors.foreground,
          height: 1.6,
        ),
        children: spans,
      ),
    );
  }

  void _cyclePlaybackSpeed() {
    final speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];
    final currentIndex = speeds.indexOf(_playbackSpeed);
    final nextIndex = (currentIndex + 1) % speeds.length;
    setState(() {
      _playbackSpeed = speeds[nextIndex];
    });
  }

  void _showSettingsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Cài đặt phát',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.foreground,
              ),
            ),
            const SizedBox(height: 24),
            // Playback speed options
            const Text(
              'Tốc độ phát',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.foreground,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [0.5, 0.75, 1.0, 1.25, 1.5, 2.0].map((speed) {
                final isSelected = _playbackSpeed == speed;
                return GestureDetector(
                  onTap: () {
                    setState(() => _playbackSpeed = speed);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${speed}x',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            // Transcript settings
            const Text(
              'Transcript',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.foreground,
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Hiển thị bản dịch'),
              subtitle: const Text('Hiện bản dịch tiếng Việt'),
              value: _showTranslation,
              activeColor: AppColors.primary,
              onChanged: (value) {
                setState(() => _showTranslation = value);
              },
            ),
            SwitchListTile(
              title: const Text('Chế độ tô đậm'),
              subtitle: const Text('Nhấn đúp vào từ để tô đậm'),
              value: _highlightMode,
              activeColor: AppColors.tigerOrange,
              onChanged: (value) {
                setState(() => _highlightMode = value);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[500]),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.foreground,
          ),
        ),
      ],
    );
  }
}
