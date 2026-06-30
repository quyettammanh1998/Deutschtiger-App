import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import 'package:deutschtiger/data/listening/podcast_models.dart';

/// Dictation Mode enum
enum DictationMode { sentence, word }

/// Dictation Page - Listening and fill-in-the-blank exercises.
class DictationPage extends ConsumerStatefulWidget {
  const DictationPage({
    super.key,
    required this.dictation,
  });

  final Dictation dictation;

  @override
  ConsumerState<DictationPage> createState() => _DictationPageState();
}

class _DictationPageState extends ConsumerState<DictationPage> {
  DictationMode _mode = DictationMode.sentence;
  int _blurCount = 1;
  bool _showAnswer = false;
  int _currentIndex = 0;
  bool _isPlaying = false;
  double _playbackPosition = 0.0;
  final TextEditingController _answerController = TextEditingController();
  Timer? _playbackTimer;
  int _correctCount = 0;
  int _totalAttempts = 0;

  final List<_DictationQuestion> _questions = [];

  @override
  void initState() {
    super.initState();
    _generateQuestions();
  }

  void _generateQuestions() {
    _questions.clear();
    switch (widget.dictation.level) {
      case 'A1':
        _questions.addAll(_a1Questions);
        break;
      case 'A2':
        _questions.addAll(_a2Questions);
        break;
      case 'B1':
        _questions.addAll(_b1Questions);
        break;
      default:
        _questions.addAll(_a1Questions);
    }
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    _answerController.dispose();
    super.dispose();
  }

  void _startPlayback() {
    setState(() {
      _isPlaying = true;
      _playbackPosition = 0.0;
    });
    _playbackTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted) {
        setState(() {
          _playbackPosition += 0.1;
          if (_playbackPosition >= 10.0) {
            _isPlaying = false;
            timer.cancel();
          }
        });
      }
    });
  }

  void _stopPlayback() {
    _playbackTimer?.cancel();
    setState(() {
      _isPlaying = false;
      _playbackPosition = 0.0;
    });
  }

  void _checkAnswer() {
    final userAnswer = _answerController.text.trim().toLowerCase();
    final correctAnswer = _questions[_currentIndex].answer.toLowerCase();
    final isCorrect = userAnswer == correctAnswer;

    setState(() {
      _showAnswer = true;
      _totalAttempts++;
      if (isCorrect) _correctCount++;
    });

    if (isCorrect) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Chính xác!'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sai rồi. Đáp án: ${_questions[_currentIndex].answer}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _answerController.clear();
        _showAnswer = false;
        _playbackPosition = 0.0;
        _isPlaying = false;
      });
    } else {
      _showResultsDialog();
    }
  }

  void _previousQuestion() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _answerController.clear();
        _showAnswer = false;
      });
    }
  }

  void _showResultsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.emoji_events, color: AppColors.tigerOrange, size: 32),
            SizedBox(width: 12),
            Text('Kết quả'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$_correctCount / ${_questions.length}',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: AppColors.tigerOrange,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${((_correctCount / _questions.length) * 100).toInt()}% đúng',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            if (_correctCount == _questions.length)
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 24),
                  SizedBox(width: 4),
                  Icon(Icons.star, color: Colors.amber, size: 24),
                  SizedBox(width: 4),
                  Icon(Icons.star, color: Colors.amber, size: 24),
                ],
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop();
            },
            child: const Text('Thoát'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentIndex = 0;
                _correctCount = 0;
                _totalAttempts = 0;
                _answerController.clear();
                _showAnswer = false;
              });
            },
            child: const Text('Làm lại'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSettingsBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildAudioPlayer(),
                    const SizedBox(height: 24),
                    _buildQuestionCard(),
                    const SizedBox(height: 24),
                    _buildAnswerInput(),
                    const SizedBox(height: 24),
                    _buildActionButtons(),
                    const SizedBox(height: 24),
                    _buildProgressIndicator(),
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
                Text(
                  widget.dictation.titleVi,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.foreground,
                  ),
                ),
                Text(
                  '${widget.dictation.level} - ${widget.dictation.totalSentences} câu',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.foreground),
            onPressed: _showSettingsSheet,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
      child: Row(
        children: [
          // Mode selector
          _SettingChip(
            label: 'Câu',
            icon: Icons.short_text,
            isSelected: _mode == DictationMode.sentence,
            onTap: () => setState(() => _mode = DictationMode.sentence),
          ),
          const SizedBox(width: 8),
          _SettingChip(
            label: 'Từ',
            icon: Icons.text_fields,
            isSelected: _mode == DictationMode.word,
            onTap: () => setState(() => _mode = DictationMode.word),
          ),
          const Spacer(),
          // Blur count
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.visibility, size: 16, color: AppColors.mutedForeground),
                const SizedBox(width: 4),
                Text(
                  '$_blurCount từ',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioPlayer() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.15),
            AppColors.tigerOrange.withValues(alpha: 0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.replay_10),
                iconSize: 32,
                color: AppColors.foreground,
                onPressed: () {},
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: _isPlaying ? _stopPlayback : _startPlayback,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.tigerOrange],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x40F7931E),
                        blurRadius: 16,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 36,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.forward_10),
                iconSize: 32,
                color: AppColors.foreground,
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
              activeTrackColor: AppColors.tigerOrange,
              inactiveTrackColor: Colors.grey[300],
              thumbColor: AppColors.tigerOrange,
            ),
            child: Slider(
              value: _playbackPosition,
              max: 10.0,
              onChanged: (value) {
                setState(() => _playbackPosition = value);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_playbackPosition.toInt()}s',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              Text(
                '10s',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard() {
    final question = _questions[_currentIndex];
    final sentence = question.sentence;
    final parts = sentence.split(question.answer);

    return Container(
      padding: const EdgeInsets.all(20),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Câu ${_currentIndex + 1}/${_questions.length}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getDifficultyColor(widget.dictation.difficulty).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    widget.dictation.difficulty,
                    (i) => const Icon(Icons.star, size: 14, color: Colors.amber),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Sentence with blanks
          _buildSentenceWithBlanks(sentence, question.answer),
          const SizedBox(height: 16),
          // Vietnamese hint
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.translate, size: 18, color: AppColors.mutedForeground),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    question.hint,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSentenceWithBlanks(String sentence, String answer) {
    final parts = sentence.split(answer);

    if (parts.length < 2) {
      return Text(
        sentence.replaceAll(answer, '_____'),
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: AppColors.foreground,
          height: 1.6,
        ),
      );
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: AppColors.foreground,
          height: 1.6,
        ),
        children: [
          TextSpan(text: parts[0]),
          TextSpan(
            text: _showAnswer ? answer : '_____',
            style: TextStyle(
              backgroundColor: _showAnswer
                  ? AppColors.success.withValues(alpha: 0.2)
                  : AppColors.tigerOrange.withValues(alpha: 0.2),
              color: _showAnswer ? AppColors.success : AppColors.tigerOrange,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: parts.length > 1 ? parts[1] : ''),
        ],
      ),
    );
  }

  Widget _buildAnswerInput() {
    return Container(
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
      child: TextField(
        controller: _answerController,
        enabled: !_showAnswer,
        decoration: InputDecoration(
          hintText: _mode == DictationMode.word
              ? 'Nhập từ còn thiếu...'
              : 'Nhập câu trả lời...',
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: const Icon(Icons.edit, color: AppColors.primary),
          suffixIcon: _showAnswer
              ? const Icon(Icons.check_circle, color: AppColors.success)
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
        onSubmitted: (_) => _checkAnswer(),
      ),
    );
  }

  Widget _buildActionButtons() {
    if (_showAnswer) {
      return Row(
        children: [
          if (_currentIndex > 0)
            Expanded(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _previousQuestion,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Câu trước'),
              ),
            ),
          if (_currentIndex > 0) const SizedBox(width: 12),
          Expanded(
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _nextQuestion,
              icon: Icon(
                _currentIndex < _questions.length - 1 ? Icons.arrow_forward : Icons.done,
              ),
              label: Text(
                _currentIndex < _questions.length - 1 ? 'Câu tiếp' : 'Xem kết quả',
              ),
            ),
          ),
        ],
      );
    }

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: AppColors.tigerOrange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: _checkAnswer,
        icon: const Icon(Icons.check),
        label: const Text('Kiểm tra'),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tiến độ',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            Text(
              '${((_currentIndex + 1) / _questions.length * 100).toInt()}%',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.foreground,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: (_currentIndex + 1) / _questions.length,
          backgroundColor: Colors.grey[200],
          valueColor: const AlwaysStoppedAnimation(AppColors.primary),
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  void _showSettingsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
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
                'Cài đặt Dictation',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.foreground,
                ),
              ),
              const SizedBox(height: 24),
              // Mode selection
              const Text(
                'Chế độ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.foreground,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _ModeOption(
                      label: 'Theo câu',
                      icon: Icons.short_text,
                      isSelected: _mode == DictationMode.sentence,
                      onTap: () {
                        setModalState(() => _mode = DictationMode.sentence);
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ModeOption(
                      label: 'Theo từ',
                      icon: Icons.text_fields,
                      isSelected: _mode == DictationMode.word,
                      onTap: () {
                        setModalState(() => _mode = DictationMode.word);
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Blur count
              const Text(
                'Số từ bị ẩn',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.foreground,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [1, 2, 3, 5].map((count) {
                  final isSelected = _blurCount == count;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setModalState(() => _blurCount = count);
                        setState(() {});
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            '$count',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              // Difficulty
              const Text(
                'Độ khó',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.foreground,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: List.generate(3, (i) {
                  final level = i + 1;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 20,
                            color: level <= widget.dictation.difficulty
                                ? Colors.amber
                                : Colors.grey[300],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Áp dụng'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDifficultyColor(int difficulty) {
    switch (difficulty) {
      case 1:
        return AppColors.success;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      default:
        return AppColors.primary;
    }
  }
}

class _SettingChip extends StatelessWidget {
  const _SettingChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeOption extends StatelessWidget {
  const _ModeOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? AppColors.primary : Colors.grey[600],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primary : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DictationQuestion {
  final String sentence;
  final String answer;
  final String hint;

  const _DictationQuestion({
    required this.sentence,
    required this.answer,
    required this.hint,
  });
}

// A1 Questions
const _a1Questions = [
  _DictationQuestion(
    sentence: 'Ich ___ ein Buch.',
    answer: 'habe',
    hint: 'Có (have)',
  ),
  _DictationQuestion(
    sentence: 'Das ist ___ Hund.',
    answer: 'ein',
    hint: 'Một (a/an)',
  ),
  _DictationQuestion(
    sentence: 'Er ___ nach Hause.',
    answer: 'geht',
    hint: 'Đi (go)',
  ),
  _DictationQuestion(
    sentence: 'Sie ___ eine Lehrerin.',
    answer: 'ist',
    hint: 'Là (is)',
  ),
  _DictationQuestion(
    sentence: 'Wir ___ in Berlin.',
    answer: 'wohnen',
    hint: 'Sống (live)',
  ),
  _DictationQuestion(
    sentence: 'Die Kinder ___ in der Schule.',
    answer: 'sind',
    hint: 'Là (are)',
  ),
  _DictationQuestion(
    sentence: 'Ich ___ Kaffee trinken.',
    answer: 'möchte',
    hint: 'Muốn (want)',
  ),
  _DictationQuestion(
    sentence: 'Das ___ ein Auto.',
    answer: 'ist',
    hint: 'Là (is)',
  ),
  _DictationQuestion(
    sentence: 'Heute ___ Montag.',
    answer: 'ist',
    hint: 'Là (is)',
  ),
  _DictationQuestion(
    sentence: 'Ich ___ 25 Jahre alt.',
    answer: 'bin',
    hint: 'Là (am)',
  ),
];

// A2 Questions
const _a2Questions = [
  _DictationQuestion(
    sentence: 'Ich habe gestern ___ gegessen.',
    answer: 'Pizza',
    hint: 'Bánh pizza',
  ),
  _DictationQuestion(
    sentence: 'Der Zug ___ um 8 Uhr.',
    answer: 'kommt',
    hint: 'Đến (come)',
  ),
  _DictationQuestion(
    sentence: 'Sie ___ seit 10 Jahren hier.',
    answer: 'wohnt',
    hint: 'Sống (live)',
  ),
  _DictationQuestion(
    sentence: 'Ich muss morgen ___ arbeiten.',
    answer: 'früh',
    hint: 'Sớm (early)',
  ),
  _DictationQuestion(
    sentence: 'Das Buch ___ auf dem Tisch.',
    answer: 'liegt',
    hint: 'Nằm (lie)',
  ),
  _DictationQuestion(
    sentence: 'Wir ___ am Wochenende ins Kino.',
    answer: 'gehen',
    hint: 'Đi (go)',
  ),
  _DictationQuestion(
    sentence: 'Er ___ nicht kommen.',
    answer: 'kann',
    hint: 'Có thể (can)',
  ),
  _DictationQuestion(
    sentence: 'Die Kinder ___ in den Garten.',
    answer: 'laufen',
    hint: 'Chạy (run)',
  ),
  _DictationQuestion(
    sentence: 'Ich ___ dir ein Geschenk.',
    answer: 'gebe',
    hint: 'Trao (give)',
  ),
  _DictationQuestion(
    sentence: 'Sie ___很漂亮.',
    answer: 'ist',
    hint: 'Là (is)',
  ),
];

// B1 Questions
const _b1Questions = [
  _DictationQuestion(
    sentence: 'Ich habe gestern Abend ___.',
    answer: 'gearbeitet',
    hint: 'Đã làm việc (worked)',
  ),
  _DictationQuestion(
    sentence: 'Das ist das Buch, ___ ich gelesen habe.',
    answer: 'das',
    hint: 'Mà (which/that)',
  ),
  _DictationQuestion(
    sentence: 'Wenn es regnet, ___ ich zu Hause.',
    answer: 'bleibe',
    hint: 'Ở lại (stay)',
  ),
  _DictationQuestion(
    sentence: 'Er hat gesagt, dass er ___ kommt.',
    answer: 'morgen',
    hint: 'Ngày mai (tomorrow)',
  ),
  _DictationQuestion(
    sentence: 'Ich interessiere mich ___ Musik.',
    answer: 'für',
    hint: 'Cho (for)',
  ),
  _DictationQuestion(
    sentence: 'Die Aufgabe war ___ schwer.',
    answer: 'sehr',
    hint: 'Rất (very)',
  ),
  _DictationQuestion(
    sentence: 'Wir müssen uns ___ den Termin kümmern.',
    answer: 'um',
    hint: 'Về (about)',
  ),
  _DictationQuestion(
    sentence: 'Sie ist seit einem Jahr ___ Deutschland.',
    answer: 'in',
    hint: 'Ở/Tại (in)',
  ),
  _DictationQuestion(
    sentence: 'Ich freue mich ___ das Projekt.',
    answer: 'auf',
    hint: 'Về (looking forward to)',
  ),
  _DictationQuestion(
    sentence: 'Er spricht ___ als ich.',
    answer: 'besser',
    hint: 'Tốt hơn (better)',
  ),
];
