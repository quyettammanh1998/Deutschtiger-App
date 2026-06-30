import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import 'package:deutschtiger/view_models/interview/video_note_provider.dart';

/// Panel ghi chu cho video YouTube.
/// Hien thi ghi chu hien tai + cho phep chinh sua.
class VideoNotesPanel extends ConsumerStatefulWidget {
  const VideoNotesPanel({
    super.key,
    required this.videoId,
    required this.videoTitle,
    this.onSeek,
  });

  final String videoId;
  final String videoTitle;
  final void Function(int milliseconds)? onSeek;

  @override
  ConsumerState<VideoNotesPanel> createState() => _VideoNotesPanelState();
}

class _VideoNotesPanelState extends ConsumerState<VideoNotesPanel> {
  late final TextEditingController _controller;
  bool _isSaving = false;
  bool _hasChanges = false;
  String? _initialContent;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasChanges = _controller.text != (_initialContent ?? '');
    if (hasChanges != _hasChanges) {
      setState(() => _hasChanges = hasChanges);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    if (!_hasChanges || _isSaving) return;

    setState(() => _isSaving = true);

    try {
      final saveService = ref.read(videoNoteSaveServiceProvider);
      await saveService.saveNote(widget.videoId, _controller.text);
      _initialContent = _controller.text;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã lưu ghi chú')),
        );
        setState(() {
          _hasChanges = false;
          _isSaving = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final noteAsync = ref.watch(videoNoteProvider(widget.videoId));

    // Initialize controller with existing note content
    noteAsync.whenData((note) {
      if (_initialContent == null && note != null) {
        _initialContent = note.content;
        if (_controller.text.isEmpty && note.content.isNotEmpty) {
          _controller.text = note.content;
        }
      }
    });

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.muted.withValues(alpha: 0.3)),
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.note_alt, size: 18, color: AppColors.tigerOrange),
              const SizedBox(width: 8),
              const Text(
                'Ghi chú',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              if (_hasChanges)
                TextButton.icon(
                  onPressed: _isSaving ? null : _saveNote,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save, size: 18),
                  label: Text(_isSaving ? 'Đang lưu...' : 'Lưu'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.tigerOrange,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: noteAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.tigerOrange),
              ),
              error: (e, _) => Center(
                child: Text(
                  'Lỗi: $e',
                  style: const TextStyle(color: AppColors.destructive, fontSize: 12),
                ),
              ),
              data: (note) {
                // Initialize controller on first load
                if (_initialContent == null && note != null) {
                  _initialContent = note.content;
                  if (_controller.text.isEmpty && note.content.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _controller.text = note.content;
                    });
                  }
                }
                return TextField(
                  controller: _controller,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: 'Thêm ghi chú cho video này...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: AppColors.authBackground,
                    contentPadding: const EdgeInsets.all(12),
                  ),
                  style: const TextStyle(fontSize: 14),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
