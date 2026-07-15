/// Game types enum.
enum GameType {
  article,        // Der/Die/Das
  wordSprint,     // Word Sprint 60s
  matching,       // Nối từ
  fillBlank,      // Điền từ
  listening,      // Luyện nghe
  flashcard,      // Flashcards
  runner,        // Deutsch Runner
  typingSprint,   // Typing Sprint
  writingWord,    // Viết từ
  writingSentence, // Viết câu
  wordOrder,      // Wortstellung
  speaking,       // Luyện nói (AI)
  conjugation,    // Konjugationstrainer
  cases,          // Cases Mastery
  conversation,   // Hội thoại
  pronunciation,  // Luyện phát âm
  sentenceBuilder, // Viết câu AI
}

/// Game difficulty levels.
enum GameDifficulty {
  easy,
  medium,
  hard,
}

/// Game result model.
class GameResult {
  final GameType type;
  final int score;
  final int correct;
  final int total;
  final int xpEarned;
  final int maxCombo;
  final Duration timeSpent;
  final List<String> wrongItemIds;
  final DateTime playedAt;

  const GameResult({
    required this.type,
    required this.score,
    required this.correct,
    required this.total,
    required this.xpEarned,
    required this.maxCombo,
    required this.timeSpent,
    required this.wrongItemIds,
    required this.playedAt,
  });

  double get accuracy => total > 0 ? correct / total : 0;
}

/// Game question model for quiz games.
class GameQuestion {
  final String id;
  final String word;
  final String? translation;
  final String? audioUrl;
  final List<String> options;
  final int correctIndex;
  final String? gender; // der/die/das

  const GameQuestion({
    required this.id,
    required this.word,
    this.translation,
    this.audioUrl,
    required this.options,
    required this.correctIndex,
    this.gender,
  });
}

/// Matching pair model.
class MatchingPair {
  final String german;
  final String vietnamese;
  final String id;

  const MatchingPair({
    required this.id,
    required this.german,
    required this.vietnamese,
  });
}

/// Fill in blank model.
class FillBlankQuestion {
  final String id;
  final String sentence;
  final String correctAnswer;
  final List<String> options;

  const FillBlankQuestion({
    required this.id,
    required this.sentence,
    required this.correctAnswer,
    required this.options,
  });
}

/// Listening question model.
class ListeningQuestion {
  final String id;
  final String audioUrl;
  final List<String> options;
  final int correctIndex;

  const ListeningQuestion({
    required this.id,
    required this.audioUrl,
    required this.options,
    required this.correctIndex,
  });
}

/// Game mode metadata.
class GameMode {
  final GameType type;
  final String title;
  final String description;
  final String iconName;
  final int color;
  final GameDifficulty difficulty;
  final int? timeLimit; // seconds, null = no limit
  final bool needsAudio;
  // GĐ1: chỉ hiện games được xác nhận (Apple reject "coming soon" placeholders)
  final bool gd1Available;

  const GameMode({
    required this.type,
    required this.title,
    required this.description,
    required this.iconName,
    required this.color,
    this.difficulty = GameDifficulty.medium,
    this.timeLimit,
    this.needsAudio = false,
    this.gd1Available = false,
  });

  static const List<GameMode> allModes = [
    // Nguồn live: GET /user/learning-items/balanced?type=word (lọc danh từ
    // có gender m/f/n → der/die/das). Tái dùng LearningItemRepository.
    GameMode(
      type: GameType.article,
      title: 'Der/Die/Das',
      description: 'Đoán mạo từ đúng',
      iconName: 'book',
      color: 0xFF14B8A6,
      difficulty: GameDifficulty.easy,
      gd1Available: true,
    ),
    // Nguồn live: GET /vocabulary/learned (VocabularyRepository, tái dùng).
    GameMode(
      type: GameType.wordSprint,
      title: 'Word Sprint',
      description: '60 giây chinh phục từ vựng',
      iconName: 'flash_on',
      color: 0xFFF59E0B,
      timeLimit: 60,
      difficulty: GameDifficulty.hard,
      gd1Available: true,
    ),
    GameMode(
      type: GameType.matching,
      title: 'Nối từ',
      description: 'Ghép cặp Đức - Việt',
      iconName: 'link',
      color: 0xFFEC4899,
      difficulty: GameDifficulty.easy,
      gd1Available: true,
    ),
    // Nguồn live: GET /user/learning-items/balanced?type=word, cloze dựng từ
    // examples đính kèm (tái dùng LearningItemRepository, giống Artikel).
    GameMode(
      type: GameType.fillBlank,
      title: 'Điền từ',
      description: 'Hoàn thành câu',
      iconName: 'edit_note',
      color: 0xFF06B6D4,
      difficulty: GameDifficulty.medium,
      gd1Available: true,
    ),
    // Nguồn live: GET /vocabulary/learned (tái dùng VocabularyRepository) +
    // audio qua AudioService (server TTS cache /user/tts/vocab-cache).
    GameMode(
      type: GameType.listening,
      title: 'Luyện nghe',
      description: 'Nghe và chọn đáp án',
      iconName: 'headphones',
      color: 0xFF8B5CF6,
      needsAudio: true,
      difficulty: GameDifficulty.medium,
      gd1Available: true,
    ),
    // Nguồn live: GET /user/srs/queue + POST /user/srs/review (tái dùng
    // ReviewRepository/reviewSessionProvider, giống màn "Ôn từ").
    GameMode(
      type: GameType.flashcard,
      title: 'Flashcards',
      description: 'Lật thẻ học từ',
      iconName: 'style',
      color: 0xFFA855F7,
      difficulty: GameDifficulty.easy,
      gd1Available: true,
    ),
    // Nguồn live: GET /vocabulary/learned (tái dùng VocabularyRepository).
    GameMode(
      type: GameType.runner,
      title: 'Deutsch Runner',
      description: 'Chạy và trả lời',
      iconName: 'directions_run',
      color: 0xFF3B82F6,
      difficulty: GameDifficulty.medium,
      gd1Available: true,
    ),
    // Nguồn live: GET /user/typing/sentences + POST /user/typing/results
    // (backend chấm điểm + trả XP). gd1Available true kể từ khi chuyển live.
    GameMode(
      type: GameType.typingSprint,
      title: 'Typing Sprint',
      description: 'Gõ câu trong 60s',
      iconName: 'keyboard',
      color: 0xFF0EA5E9,
      timeLimit: 60,
      difficulty: GameDifficulty.hard,
      gd1Available: true,
    ),
    // Nguồn live: GET /vocabulary/learned (tái dùng VocabularyRepository) +
    // chấm qua POST /ai/grade-word-writing (tái dùng, đã live cho bài học).
    GameMode(
      type: GameType.writingWord,
      title: 'Viết từ',
      description: 'Viết từ từ nghĩa',
      iconName: 'edit',
      color: 0xFF22C55E,
      difficulty: GameDifficulty.medium,
      gd1Available: true,
    ),
    // Nguồn live: GET /user/learning-items/balanced?type=sentence (tái dùng
    // LearningItemRepository, giống Artikel).
    GameMode(
      type: GameType.wordOrder,
      title: 'Wortstellung',
      description: 'Xếp từ đúng thứ tự',
      iconName: 'swap_vert',
      color: 0xFFEAB308,
      difficulty: GameDifficulty.medium,
      gd1Available: true,
    ),
    // Nguồn live: GET /vocabulary/learned + chấm qua POST /ai/grade-sentence
    // (tái dùng LearnRepository.gradeSentence, cùng endpoint Sentence Builder).
    GameMode(
      type: GameType.writingSentence,
      title: 'Viết câu',
      description: 'Viết câu tiếng Đức',
      iconName: 'edit_note',
      color: 0xFF6366F1,
      difficulty: GameDifficulty.hard,
      gd1Available: true,
    ),
    GameMode(
      type: GameType.speaking,
      title: 'Luyện Nói',
      description: 'Luyện phát âm với mic',
      iconName: 'mic',
      color: 0xFFEC4899,
      needsAudio: true,
      difficulty: GameDifficulty.medium,
    ),
    // Nguồn live: /user/cases/{akk-dat,adjektiv,wechselprep,verb-case} +
    // /user/grammar-drill/results (Leitner progress). Hub điều hướng tới 4
    // sub-game riêng dưới /games/cases/*.
    GameMode(
      type: GameType.cases,
      title: 'Cases Mastery',
      description: 'Học các trường hợp',
      iconName: 'school',
      color: 0xFF3B82F6,
      difficulty: GameDifficulty.hard,
      gd1Available: true,
    ),
    // Nguồn live: /user/conjugation/exercise (cá nhân hoá theo vốn từ đã
    // học) + /user/grammar-drill/results.
    GameMode(
      type: GameType.conjugation,
      title: 'Konjugation',
      description: 'Chia động từ',
      iconName: 'edit_note',
      color: 0xFF14B8A6,
      difficulty: GameDifficulty.hard,
      gd1Available: true,
    ),
    GameMode(
      type: GameType.pronunciation,
      title: 'Phát âm',
      description: 'Umlaute, ch, r sounds',
      iconName: 'record_voice_over',
      color: 0xFFF43F5E,
      difficulty: GameDifficulty.medium,
    ),
    GameMode(
      type: GameType.conversation,
      title: 'Hội thoại',
      description: 'Đời thường A1-A2',
      iconName: 'chat',
      color: 0xFF8B5CF6,
      difficulty: GameDifficulty.medium,
    ),
    // Nguồn live: /sentence-builder/topics + /sentence-builder/session +
    // /ai/grade-sentence (tái dùng). Các game khác trong danh sách trên vẫn
    // mock — gd1Available giữ false cho tới khi có nguồn thật.
    GameMode(
      type: GameType.sentenceBuilder,
      title: 'Viết câu AI',
      description: 'Viết câu theo chủ đề, AI chấm điểm',
      iconName: 'edit_note',
      color: 0xFFF97316,
      difficulty: GameDifficulty.medium,
      gd1Available: true,
    ),
  ];
}
