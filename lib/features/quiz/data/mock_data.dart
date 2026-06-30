import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  final String cefrLevel;
  final double difficulty;

  const Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.questionCount,
    required this.estimatedMinutes,
    this.cefrLevel = 'A1',
    this.difficulty = 1.0,
  });
}

/// Mock quizzes.
final mockQuizzes = [
  const Quiz(
    id: 'article-der-die-das',
    title: 'Mạo từ: der, die, das',
    description: 'Xác định giống của danh từ tiếng Đức',
    type: QuizType.multipleChoice,
    questionCount: 10,
    estimatedMinutes: 5,
    cefrLevel: 'A1',
    difficulty: 1.0,
  ),
  const Quiz(
    id: 'verb-sein-haben',
    title: 'Động từ sein & haben',
    description: 'Chia động từ thường gặp nhất',
    type: QuizType.fillInBlank,
    questionCount: 15,
    estimatedMinutes: 8,
    cefrLevel: 'A1',
    difficulty: 1.2,
  ),
  const Quiz(
    id: 'numbers-1-100',
    title: 'Số đếm từ 1-100',
    description: 'Học cách đọc và viết số tiếng Đức',
    type: QuizType.multipleChoice,
    questionCount: 20,
    estimatedMinutes: 5,
    cefrLevel: 'A1',
    difficulty: 0.8,
  ),
  const Quiz(
    id: 'greetings',
    title: 'Lời chào & xã giao',
    description: 'Cách chào hỏi trong các tình huống',
    type: QuizType.trueFalse,
    questionCount: 12,
    estimatedMinutes: 4,
    cefrLevel: 'A1',
    difficulty: 0.5,
  ),
  const Quiz(
    id: 'akkusativ',
    title: 'Tính từ sở hữu',
    description: 'mein, dein, sein trong Akkusativ',
    type: QuizType.multipleChoice,
    questionCount: 15,
    estimatedMinutes: 10,
    cefrLevel: 'A2',
    difficulty: 2.0,
  ),
];

/// Provider for all quizzes.
final quizzesProvider = FutureProvider<List<Quiz>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 300));
  return mockQuizzes;
});

/// Provider for quiz by ID.
final quizByIdProvider = FutureProvider.family<Quiz?, String>((ref, quizId) async {
  await Future.delayed(const Duration(milliseconds: 200));
  try {
    return mockQuizzes.firstWhere((q) => q.id == quizId);
  } catch (_) {
    return null;
  }
});

/// Quiz filters.
class QuizCefrFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  
  void setFilter(String? cefrLevel) => state = cefrLevel;
}

final quizCefrFilterProvider = NotifierProvider<QuizCefrFilterNotifier, String?>(
  QuizCefrFilterNotifier.new,
);

class QuizTypeFilterNotifier extends Notifier<QuizType?> {
  @override
  QuizType? build() => null;
  
  void setFilter(QuizType? type) => state = type;
}

final quizTypeFilterProvider = NotifierProvider<QuizTypeFilterNotifier, QuizType?>(
  QuizTypeFilterNotifier.new,
);
