/// Practice models - simplified without Freezed
enum PracticeType { cloze, listening, matching, writing, translation }

class PracticeSession {
  PracticeSession({
    required this.id,
    required this.type,
    required this.items,
    this.currentIndex = 0,
    this.results = const {},
    this.isCompleted = false,
  });

  final String id;
  final PracticeType type;
  final List<PracticeItem> items;
  int currentIndex;
  Map<String, int> results;
  bool isCompleted;
}

class PracticeItem {
  const PracticeItem({
    required this.id,
    required this.question,
    this.questionAudio,
    required this.answer,
    this.options,
    this.hint,
    this.explanation,
    this.imageUrl,
  });

  final String id;
  final String question;
  final String? questionAudio;
  final String answer;
  final List<String>? options;
  final String? hint;
  final String? explanation;
  final String? imageUrl;
}

class PracticeResult {
  const PracticeResult({
    required this.correct,
    required this.total,
    required this.xpEarned,
    required this.streakBonus,
    required this.answers,
  });

  final int correct;
  final int total;
  final int xpEarned;
  final int streakBonus;
  final List<PracticeAnswer> answers;
}

class PracticeAnswer {
  const PracticeAnswer({
    required this.questionId,
    required this.userAnswer,
    required this.correctAnswer,
    required this.isCorrect,
    this.timeSpentMs,
  });

  final String questionId;
  final String userAnswer;
  final String correctAnswer;
  final bool isCorrect;
  final int? timeSpentMs;
}

/// Practice types with icons and names
class PracticeTypes {
  static const cloze = {
    'id': 'cloze',
    'name': 'Cloze Test',
    'nameVi': 'Điền từ',
    'icon': '📝',
    'description': 'Fill in the blanks',
  };
  
  static const listening = {
    'id': 'listening',
    'name': 'Listening',
    'nameVi': 'Nghe hiểu',
    'icon': '🎧',
    'description': 'Listen and answer',
  };
  
  static const matching = {
    'id': 'matching',
    'name': 'Matching',
    'nameVi': 'Nối từ',
    'icon': '🔗',
    'description': 'Match pairs',
  };
  
  static const writing = {
    'id': 'writing',
    'name': 'Writing',
    'nameVi': 'Viết câu',
    'icon': '✍️',
    'description': 'Write in German',
  };
  
  static const translation = {
    'id': 'translation',
    'name': 'Translation',
    'nameVi': 'Dịch thuật',
    'icon': '🔄',
    'description': 'Translate sentences',
  };

  static List<Map<String, String>> get all => [cloze, listening, matching, writing, translation];
}
