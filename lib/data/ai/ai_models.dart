/// AI Chat message model
class AIChatMessage {
  final String id;
  final String sessionId;
  final String role;
  final String content;
  final String translation;
  final List<String> vocabularyHighlight;
  final List<GrammarCorrection> grammarCorrections;
  final bool isGrammarHint;
  final DateTime? createdAt;

  const AIChatMessage({
    required this.id,
    required this.sessionId,
    required this.role,
    required this.content,
    this.translation = '',
    this.vocabularyHighlight = const [],
    this.grammarCorrections = const [],
    this.isGrammarHint = false,
    this.createdAt,
  });

  AIChatMessage copyWith({
    String? id,
    String? sessionId,
    String? role,
    String? content,
    String? translation,
    List<String>? vocabularyHighlight,
    List<GrammarCorrection>? grammarCorrections,
    bool? isGrammarHint,
    DateTime? createdAt,
  }) {
    return AIChatMessage(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      role: role ?? this.role,
      content: content ?? this.content,
      translation: translation ?? this.translation,
      vocabularyHighlight: vocabularyHighlight ?? this.vocabularyHighlight,
      grammarCorrections: grammarCorrections ?? this.grammarCorrections,
      isGrammarHint: isGrammarHint ?? this.isGrammarHint,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Grammar correction within a message
class GrammarCorrection {
  final String id;
  final String original;
  final String correction;
  final String explanation;
  final int startIndex;
  final int endIndex;
  final String grammarRule;

  const GrammarCorrection({
    required this.id,
    required this.original,
    required this.correction,
    required this.explanation,
    required this.startIndex,
    required this.endIndex,
    this.grammarRule = '',
  });
}

/// AI Chat session
class AISession {
  final String id;
  final String title;
  final String mode;
  final List<AIChatMessage> messages;
  final int messageCount;
  final int tokensUsed;
  final DateTime? createdAt;
  final DateTime? lastMessageAt;

  const AISession({
    required this.id,
    required this.title,
    required this.mode,
    this.messages = const [],
    this.messageCount = 0,
    this.tokensUsed = 0,
    this.createdAt,
    this.lastMessageAt,
  });

  AISession copyWith({
    String? id,
    String? title,
    String? mode,
    List<AIChatMessage>? messages,
    int? messageCount,
    int? tokensUsed,
    DateTime? createdAt,
    DateTime? lastMessageAt,
  }) {
    return AISession(
      id: id ?? this.id,
      title: title ?? this.title,
      mode: mode ?? this.mode,
      messages: messages ?? this.messages,
      messageCount: messageCount ?? this.messageCount,
      tokensUsed: tokensUsed ?? this.tokensUsed,
      createdAt: createdAt ?? this.createdAt,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
    );
  }
}

/// Writing practice exercise
class WritingPractice {
  final String id;
  final String title;
  final String titleVi;
  final String prompt;
  final String promptVi;
  final int wordLimit;
  final String userText;
  final List<WritingFeedback> feedback;
  final double overallScore;
  final double grammarScore;
  final double vocabularyScore;
  final double coherenceScore;
  final bool isCompleted;
  final DateTime? submittedAt;
  final DateTime? createdAt;

  const WritingPractice({
    required this.id,
    required this.title,
    required this.titleVi,
    required this.prompt,
    required this.promptVi,
    this.wordLimit = 0,
    this.userText = '',
    this.feedback = const [],
    this.overallScore = 0.0,
    this.grammarScore = 0.0,
    this.vocabularyScore = 0.0,
    this.coherenceScore = 0.0,
    this.isCompleted = false,
    this.submittedAt,
    this.createdAt,
  });

  WritingPractice copyWith({
    String? id,
    String? title,
    String? titleVi,
    String? prompt,
    String? promptVi,
    int? wordLimit,
    String? userText,
    List<WritingFeedback>? feedback,
    double? overallScore,
    double? grammarScore,
    double? vocabularyScore,
    double? coherenceScore,
    bool? isCompleted,
    DateTime? submittedAt,
    DateTime? createdAt,
  }) {
    return WritingPractice(
      id: id ?? this.id,
      title: title ?? this.title,
      titleVi: titleVi ?? this.titleVi,
      prompt: prompt ?? this.prompt,
      promptVi: promptVi ?? this.promptVi,
      wordLimit: wordLimit ?? this.wordLimit,
      userText: userText ?? this.userText,
      feedback: feedback ?? this.feedback,
      overallScore: overallScore ?? this.overallScore,
      grammarScore: grammarScore ?? this.grammarScore,
      vocabularyScore: vocabularyScore ?? this.vocabularyScore,
      coherenceScore: coherenceScore ?? this.coherenceScore,
      isCompleted: isCompleted ?? this.isCompleted,
      submittedAt: submittedAt ?? this.submittedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Writing feedback item
class WritingFeedback {
  final String id;
  final String type;
  final String original;
  final String suggestion;
  final String explanation;
  final int startIndex;
  final int endIndex;
  final String category;

  const WritingFeedback({
    required this.id,
    required this.type,
    required this.original,
    required this.suggestion,
    this.explanation = '',
    this.startIndex = 0,
    this.endIndex = 0,
    this.category = '',
  });
}

/// AI tutor mode/personality
class AIMode {
  final String id;
  final String name;
  final String nameVi;
  final String description;
  final String descriptionVi;
  final String avatar;
  final String tone;
  final String focus;
  final bool isExamContext;

  const AIMode({
    required this.id,
    required this.name,
    required this.nameVi,
    required this.description,
    this.descriptionVi = '',
    this.avatar = '',
    this.tone = 'friendly',
    this.focus = 'general',
    this.isExamContext = false,
  });
}

/// User AI settings/memory
class AISettings {
  final String userLevel;
  final List<String> learningGoals;
  final bool includeTranslations;
  final bool showGrammarHints;
  final bool showVocabularyHighlights;
  final String focusExam;
  final int maxTokensPerResponse;

  const AISettings({
    this.userLevel = 'A1',
    this.learningGoals = const [],
    this.includeTranslations = true,
    this.showGrammarHints = true,
    this.showVocabularyHighlights = true,
    this.focusExam = '',
    this.maxTokensPerResponse = 500,
  });

  AISettings copyWith({
    String? userLevel,
    List<String>? learningGoals,
    bool? includeTranslations,
    bool? showGrammarHints,
    bool? showVocabularyHighlights,
    String? focusExam,
    int? maxTokensPerResponse,
  }) {
    return AISettings(
      userLevel: userLevel ?? this.userLevel,
      learningGoals: learningGoals ?? this.learningGoals,
      includeTranslations: includeTranslations ?? this.includeTranslations,
      showGrammarHints: showGrammarHints ?? this.showGrammarHints,
      showVocabularyHighlights: showVocabularyHighlights ?? this.showVocabularyHighlights,
      focusExam: focusExam ?? this.focusExam,
      maxTokensPerResponse: maxTokensPerResponse ?? this.maxTokensPerResponse,
    );
  }
}

/// Voice recording state
enum RecordingState { idle, recording, processing }

/// Chat history item for sidebar
class ChatHistoryItem {
  final String id;
  final String title;
  final String mode;
  final int messageCount;
  final DateTime? lastMessageAt;

  const ChatHistoryItem({
    required this.id,
    required this.title,
    required this.mode,
    this.messageCount = 0,
    this.lastMessageAt,
  });
}
