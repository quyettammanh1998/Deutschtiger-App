import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class PronunciationPracticeWidget extends StatefulWidget {
  final String word;
  final String phonetic;
  final String translation;
  final Function(double score)? onRecordingComplete;

  const PronunciationPracticeWidget({
    super.key,
    required this.word,
    required this.phonetic,
    required this.translation,
    this.onRecordingComplete,
  });

  @override
  State<PronunciationPracticeWidget> createState() => _PronunciationPracticeWidgetState();
}

class _PronunciationPracticeWidgetState extends State<PronunciationPracticeWidget>
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
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          final newScore = 0.7 + (DateTime.now().millisecond % 30) / 100;
          setState(() {
            _isRecording = false;
            _score = newScore;
            _feedback = _getFeedback(newScore);
          });
          widget.onRecordingComplete?.call(newScore);
        }
      });
    }
  }

  String _getFeedback(double score) {
    if (score >= 0.9) return 'Excellent! Perfect pronunciation!';
    if (score >= 0.8) return 'Great job! Almost perfect!';
    if (score >= 0.7) return 'Good! Keep practicing!';
    if (score >= 0.6) return 'Not bad! Try again for better.';
    return 'Keep practicing! Focus on the sound.';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  widget.word,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.foreground,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.phonetic,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.translation,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    setState(() => _isPlaying = !_isPlaying);
                    Future.delayed(const Duration(seconds: 1), () {
                      if (mounted) setState(() => _isPlaying = false);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isPlaying ? Icons.pause : Icons.volume_up,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isPlaying ? 'Playing...' : 'Listen',
                          style: const TextStyle(
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
          const SizedBox(height: 24),
          GestureDetector(
            onTap: _toggleRecording,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final scale = _isRecording ? 1.0 + (_pulseController.value * 0.1) : 1.0;
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 72,
                    height: 72,
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
                      size: 32,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _isRecording ? 'Recording...' : 'Tap to speak',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          if (_score > 0) ...[
            const SizedBox(height: 20),
            _buildScoreDisplay(),
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

  Widget _buildScoreDisplay() {
    Color color;
    IconData icon;
    if (_score >= 0.8) {
      color = Colors.green;
      icon = Icons.star;
    } else if (_score >= 0.6) {
      color = Colors.orange;
      icon = Icons.thumb_up;
    } else {
      color = Colors.red;
      icon = Icons.replay;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${(_score * 100).round()}%',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                'Accuracy',
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
