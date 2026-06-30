import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Pronunciation practice widget - synced từ web.
class PronunciationPractice extends StatefulWidget {
  const PronunciationPractice({super.key});

  @override
  State<PronunciationPractice> createState() => _PronunciationPracticeState();
}

class _PronunciationPracticeState extends State<PronunciationPractice>
    with SingleTickerProviderStateMixin {
  bool _isRecording = false;
  bool _isPlaying = false;
  String _feedback = '';
  double _score = 0;

  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
      if (_isRecording) {
        _feedback = '';
        _score = 0;
      }
    });

    if (_isRecording) {
      // Simulate recording for 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _isRecording = false;
            _score = 0.85;
            _feedback = 'Khá tốt! Phát âm gần đúng.';
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          const Text(
            'Luyện phát âm',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.foreground,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Nhấn mic và đọc to từ bên dưới',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.mutedForeground,
            ),
          ),

          const SizedBox(height: 32),

          // Word to pronounce
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.pink.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text(
                  'Guten Tag',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.foreground,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '/ˈɡuːtn̩ taːk/',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.mutedForeground,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    setState(() => _isPlaying = !_isPlaying);
                    // Simulate audio playback
                    Future.delayed(const Duration(seconds: 1), () {
                      if (mounted) setState(() => _isPlaying = false);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Nghe mẫu',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Record button
          GestureDetector(
            onTap: _toggleRecording,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final scale = _isRecording
                    ? 1.0 + (_pulseController.value * 0.1)
                    : 1.0;
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isRecording ? Colors.red : AppColors.tigerOrange,
                      boxShadow: [
                        BoxShadow(
                          color: (_isRecording ? Colors.red : AppColors.tigerOrange)
                              .withValues(alpha: 0.4),
                          blurRadius: _isRecording ? 20 : 10,
                          spreadRadius: _isRecording ? 5 : 0,
                        ),
                      ],
                    ),
                    child: Icon(
                      _isRecording ? Icons.stop : Icons.mic,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          Text(
            _isRecording ? 'Đang ghi âm...' : 'Nhấn để nói',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.mutedForeground,
            ),
          ),

          // Feedback
          if (_score > 0) ...[
            const SizedBox(height: 24),
            _ScoreDisplay(score: _score),
            if (_feedback.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                _feedback,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.foreground,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _ScoreDisplay extends StatelessWidget {
  const _ScoreDisplay({required this.score});

  final double score;

  Color get _color {
    if (score >= 0.8) return Colors.green;
    if (score >= 0.6) return Colors.orange;
    return Colors.red;
  }

  String get _label {
    if (score >= 0.9) return 'Xuất sắc!';
    if (score >= 0.8) return 'Tốt lắm!';
    if (score >= 0.6) return 'Khá ổn';
    return 'Cần cải thiện';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            score >= 0.8 ? Icons.star : Icons.thumb_up,
            color: _color,
            size: 24,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${(score * 100).round()}%',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _color,
                ),
              ),
              Text(
                _label,
                style: TextStyle(
                  fontSize: 12,
                  color: _color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
