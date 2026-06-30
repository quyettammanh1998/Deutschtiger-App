import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/gradient_button.dart';

/// Quiz type enum.
enum QuizType {
  multipleChoice,
  fillInBlank,
  match,
  trueFalse,
}

/// Quiz model.
class Quiz {
  final String id;
  final String title;
  final String description;
  final QuizType type;
  final int questionCount;
  final int estimatedMinutes;

  const Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.questionCount,
    required this.estimatedMinutes,
  });
}

/// Mock quizzes.
final quizzesProvider = FutureProvider<List<Quiz>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 300));
  return [
    const Quiz(
      id: 'article-1',
      title: 'Mạo từ xác định',
      description: 'der, die, das - Chọn đúng loại mạo từ',
      type: QuizType.multipleChoice,
      questionCount: 10,
      estimatedMinutes: 5,
    ),
    const Quiz(
      id: 'verb-conjugation',
      title: 'Chia động từ',
      description: 'Điền đúng dạng chia của động từ',
      type: QuizType.fillInBlank,
      questionCount: 15,
      estimatedMinutes: 10,
    ),
    const Quiz(
      id: 'vocab-basic',
      title: 'Từ vựng cơ bản',
      description: 'Nghĩa của các từ tiếng Đức thông dụng',
      type: QuizType.trueFalse,
      questionCount: 20,
      estimatedMinutes: 5,
    ),
    const Quiz(
      id: 'case-der-die-das',
      title: 'Giống của danh từ',
      description: 'Xác định giống (der/die/das)',
      type: QuizType.multipleChoice,
      questionCount: 12,
      estimatedMinutes: 7,
    ),
  ];
});

/// Màn quiz list.
class QuizListScreen extends ConsumerWidget {
  const QuizListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizzes = ref.watch(quizzesProvider);

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: const Text(
          'Luyện tập',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.tigerOrange,
            fontSize: 18,
          ),
        ),
      ),
      body: quizzes.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Lỗi: $e')),
        data: (list) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final quiz = list[index];
            return _QuizCard(quiz: quiz);
          },
        ),
      ),
    );
  }
}

class _QuizCard extends StatelessWidget {
  const _QuizCard({required this.quiz});

  final Quiz quiz;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _startQuiz(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getTypeColor(quiz.type).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _getTypeLabel(quiz.type),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _getTypeColor(quiz.type),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.timer_outlined,
                    size: 16,
                    color: AppColors.mutedForeground,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${quiz.estimatedMinutes} phút',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                quiz.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                quiz.description,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.mutedForeground,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.quiz_outlined,
                    size: 16,
                    color: AppColors.mutedForeground,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${quiz.questionCount} câu',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                  const Spacer(),
                  GradientButton(
                    label: 'Làm bài',
                    onPressed: () => _startQuiz(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startQuiz(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(quiz.title),
        content: Text(
          'Bạn sẽ làm ${quiz.questionCount} câu hỏi trong khoảng ${quiz.estimatedMinutes} phút. Bắt đầu ngay?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showQuizInProgress(context);
            },
            child: const Text('Bắt đầu'),
          ),
        ],
      ),
    );
  }

  void _showQuizInProgress(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tính năng quiz đang được phát triển'),
      ),
    );
  }

  String _getTypeLabel(QuizType type) {
    switch (type) {
      case QuizType.multipleChoice:
        return 'Trắc nghiệm';
      case QuizType.fillInBlank:
        return 'Điền từ';
      case QuizType.match:
        return 'Nối từ';
      case QuizType.trueFalse:
        return 'Đúng/Sai';
    }
  }

  Color _getTypeColor(QuizType type) {
    switch (type) {
      case QuizType.multipleChoice:
        return AppColors.tigerOrange;
      case QuizType.fillInBlank:
        return Colors.blue;
      case QuizType.match:
        return Colors.green;
      case QuizType.trueFalse:
        return Colors.purple;
    }
  }
}
