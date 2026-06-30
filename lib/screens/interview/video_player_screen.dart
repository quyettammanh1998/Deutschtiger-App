import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../core/theme/app_colors.dart';
import 'interview_provider.dart';
import '../widgets/video_notes_panel.dart';
import '../widgets/transcript_panel.dart';

/// Màn xem một video phỏng vấn: YouTube player + nút đánh dấu hoàn thành + ghi chú + transcript.
/// Tự đánh dấu complete khi video phát xong (PlayerState.ended).
class VideoPlayerScreen extends ConsumerStatefulWidget {
  const VideoPlayerScreen({
    super.key,
    required this.groupId,
    required this.videoId,
    required this.title,
  });

  final String groupId;
  final String videoId;
  final String title;

  @override
  ConsumerState<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

enum _PanelMode { none, notes, transcript }

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen> {
  late final YoutubePlayerController _controller;
  bool _completing = false;
  bool _completed = false;
  bool _autoMarked = false; // tránh tự-mark nhiều lần khi state lặp
  _PanelMode _panelMode = _PanelMode.none;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      autoPlay: false,
      params: const YoutubePlayerParams(showFullscreenButton: true),
    );
    _controller.stream.listen((event) {
      if (event.playerState == PlayerState.ended && !_autoMarked) {
        _autoMarked = true;
        _markComplete();
      }
    });
    // Khôi phục trạng thái đã-hoàn-thành từ DB (nếu xem lại video cũ).
    final list = ref.read(videosByGroupProvider(widget.groupId)).value;
    if (list != null) {
      for (final v in list) {
        if (v.videoId == widget.videoId && v.isCompleted) {
          _completed = true;
          break;
        }
      }
    }
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  /// DB id của video này (cần để gọi complete/rewatch). Null nếu chưa seed.
  String? get _dbId {
    final list = ref.read(videosByGroupProvider(widget.groupId)).value;
    if (list == null) return null;
    for (final v in list) {
      if (v.videoId == widget.videoId) return v.id;
    }
    return null;
  }

  Future<void> _markComplete() async {
    if (_completing) return;
    final id = _dbId;
    if (id == null) return;
    final wasCompleted = _completed;
    setState(() => _completing = true);
    final repo = ref.read(interviewRepositoryProvider);
    try {
      if (wasCompleted) {
        await repo.rewatch(id);
      } else {
        await repo.complete(id);
      }
      _completed = true;
      ref.invalidate(videosByGroupProvider(widget.groupId));
      ref.invalidate(groupProgressProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              wasCompleted ? 'Đã ghi nhận xem lại' : 'Đã đánh dấu hoàn thành',
            ),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không lưu được tiến độ, thử lại sau.')),
        );
      }
    } finally {
      if (mounted) setState(() => _completing = false);
    }
  }

  void _seekTo(int milliseconds) {
    _controller.seekTo(seconds: milliseconds / 1000);
  }

  void _togglePanel(_PanelMode mode) {
    setState(() {
      _panelMode = _panelMode == mode ? _PanelMode.none : mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        foregroundColor: AppColors.tigerOrange,
        title: const Text(
          'Xem video',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.tigerOrange,
            fontSize: 17,
          ),
        ),
        actions: [
          // Notes toggle
          IconButton(
            icon: Icon(
              _panelMode == _PanelMode.notes ? Icons.note : Icons.note_alt_outlined,
              color: _panelMode == _PanelMode.notes ? Colors.white : AppColors.tigerOrange,
            ),
            onPressed: () => _togglePanel(_PanelMode.notes),
            tooltip: 'Ghi chú',
            style: _panelMode == _PanelMode.notes
                ? IconButton.styleFrom(backgroundColor: AppColors.tigerOrange)
                : null,
          ),
          // Transcript toggle
          IconButton(
            icon: Icon(
              _panelMode == _PanelMode.transcript ? Icons.subtitles : Icons.subtitles_outlined,
              color: _panelMode == _PanelMode.transcript ? Colors.white : AppColors.tigerOrange,
            ),
            onPressed: () => _togglePanel(_PanelMode.transcript),
            tooltip: 'Transcript',
            style: _panelMode == _PanelMode.transcript
                ? IconButton.styleFrom(backgroundColor: AppColors.tigerOrange)
                : null,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            YoutubePlayer(controller: _controller, aspectRatio: 16 / 9),
            if (_panelMode == _PanelMode.notes)
              SizedBox(
                height: 200,
                child: VideoNotesPanel(
                  videoId: widget.videoId,
                  videoTitle: widget.title,
                  onSeek: _seekTo,
                ),
              ),
            if (_panelMode == _PanelMode.transcript)
              Expanded(
                child: TranscriptPanel(
                  videoId: widget.videoId,
                  onSegmentTap: _seekTo,
                ),
              ),
            if (_panelMode == _PanelMode.none || _panelMode == _PanelMode.notes)
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.foreground,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.tigerOrange,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: _completing ? null : _markComplete,
                          icon: Icon(
                            _completed ? Icons.replay : Icons.check_circle,
                          ),
                          label: Text(_completed ? 'Xem lại' : 'Đã hoàn thành'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
