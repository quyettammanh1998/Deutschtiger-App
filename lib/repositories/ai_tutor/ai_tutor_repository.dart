import '../domain/ai_tutor_models.dart';

class AITutorRepository {
  Future<List<AITutorSession>> getSessions() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockSessions;
  }

  Future<AITutorMode> getCurrentMode() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return const AITutorMode(
      id: 'mode-1',
      name: 'Grammar Teacher',
      nameVi: 'Giáo viên Ngữ pháp',
      description: 'A patient teacher who explains grammar rules clearly',
      descriptionVi: 'Một giáo viên kiên nhẫn giải thích ngữ pháp rõ ràng',
      avatar: 'teacher',
      tone: 'formal',
      focus: 'grammar',
    );
  }

  Future<List<AITutorMode>> getModes() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const [
      AITutorMode(
        id: 'mode-1',
        name: 'Grammar Teacher',
        nameVi: 'Giáo viên Ngữ pháp',
        description: 'A patient teacher who explains grammar rules clearly',
        descriptionVi: 'Một giáo viên kiên nhẫn giải thích ngữ pháp rõ ràng',
        avatar: 'teacher',
        tone: 'formal',
        focus: 'grammar',
      ),
      AITutorMode(
        id: 'mode-2',
        name: 'Conversation Partner',
        nameVi: 'Bạn đối thoại',
        description: 'Practice conversations naturally',
        descriptionVi: 'Thực hành đối thoại một cách tự nhiên',
        avatar: 'friend',
        tone: 'casual',
        focus: 'conversation',
      ),
      AITutorMode(
        id: 'mode-3',
        name: 'Vocabulary Builder',
        nameVi: 'Xây dựng Từ vựng',
        description: 'Helps you learn new words in context',
        descriptionVi: 'Giúp bạn học từ mới trong ngữ cảnh',
        avatar: 'books',
        tone: 'encouraging',
        focus: 'vocabulary',
      ),
      AITutorMode(
        id: 'mode-4',
        name: 'Correction Helper',
        nameVi: 'Trợ giúp Sửa lỗi',
        description: 'Reviews your German and suggests improvements',
        descriptionVi: 'Xem xét tiếng Đức của bạn và đề xuất cải thiện',
        avatar: 'editor',
        tone: 'constructive',
        focus: 'correction',
      ),
    ];
  }

  Future<AITutorMessage> sendMessage({
    required String sessionId,
    required String content,
    required String mode,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    return AITutorMessage(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
      sessionId: sessionId,
      role: 'assistant',
      content: _generateResponse(content),
      translation: _translateResponse(content),
      vocabularyHighlight: _extractVocabulary(content),
    );
  }

  Future<List<AIWritingPractice>> getWritingPractices() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockWritingPractices;
  }

  Future<AIWritingFeedback> submitWriting({
    required String practiceId,
    required String content,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    
    return AIWritingFeedback(
      id: 'feedback-${DateTime.now().millisecondsSinceEpoch}',
      practiceId: practiceId,
      type: 'grammar',
      original: content,
      suggestion: _generateWritingSuggestion(content),
      explanation: 'Consider using more varied sentence structures and connector words.',
    );
  }

  String _generateResponse(String userMessage) {
    final lower = userMessage.toLowerCase();
    if (lower.contains('grammatik') || lower.contains('grammar')) {
      return 'Gute Frage zur Grammatik! Lass mich das erklären... Im Deutschen ist die Wortstellung im Nebensatz wichtig: Das Verb steht am Ende. Zum Beispiel: "Ich weiß, dass du Deutsch lernst." Hier steht "lernst" am Ende des Satzes.';
    } else if (lower.contains('wie geht') || lower.contains('how are')) {
      return 'Mir geht es gut, danke! Und dir? Hast du heute schon geübt?';
    } else if (lower.contains('helfen') || lower.contains('help')) {
      return 'Natürlich helfe ich dir gerne! Was möchtest du lernen? Wir können über Grammatik, Vokabeln oder Konversation sprechen.';
    } else if (lower.contains('danke') || lower.contains('thank')) {
      return 'Bitte schön! Es freut mich, wenn ich helfen kann. Hast du noch weitere Fragen?';
    } else {
      return 'Das ist interessant! Erzähl mir mehr darüber. Was möchtest du auf Deutsch üben?';
    }
  }

  String _translateResponse(String userMessage) {
    final lower = userMessage.toLowerCase();
    if (lower.contains('grammatik') || lower.contains('grammar')) {
      return 'Good question about grammar! Let me explain... In German, word order in subordinate clauses is important: the verb comes at the end. For example: "I know that you are learning German." Here "learning" comes at the end of the sentence.';
    } else if (lower.contains('wie geht') || lower.contains('how are')) {
      return 'I\'m fine, thank you! And you? Have you practiced today?';
    } else {
      return 'That\'s interesting! Tell me more about it. What would you like to practice in German?';
    }
  }

  List<String> _extractVocabulary(String text) {
    final words = text.toLowerCase().split(' ');
    final germanWords = words.where((w) => w.length > 4 && !_commonWords.contains(w));
    return germanWords.take(3).toList();
  }

  static const _commonWords = {
    'und', 'der', 'die', 'das', 'ist', 'ein', 'eine', 'ich', 'du', 'wir',
    'sie', 'es', 'haben', 'sein', 'werden', 'können', 'müssen', 'sollen',
  };

  String _generateWritingSuggestion(String content) {
    if (content.length < 50) {
      return 'Versuchen Sie, längere Sätze zu schreiben. Fügen Sie mehr Details hinzu.';
    }
    return 'Good attempt! Consider adding more connector words like "außerdem", "deshalb", "jedoch" to make your writing more flow.';
  }

  static final List<AITutorSession> _mockSessions = [
    AITutorSession(
      id: 'session-1',
      odlId: 'user1',
      title: 'Grammar Practice',
      messageCount: 15,
      tokensUsed: 1250,
      avgResponseTime: 1.2,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      lastMessageAt: DateTime.now().subtract(const Duration(hours: 5)),
      messages: [
        const AITutorMessage(
          id: 'msg-1',
          sessionId: 'session-1',
          role: 'assistant',
          content: 'Hallo! Ich bin dein AI-Tutor. Wie kann ich dir heute helfen?',
          translation: 'Hello! I am your AI tutor. How can I help you today?',
        ),
        const AITutorMessage(
          id: 'msg-2',
          sessionId: 'session-1',
          role: 'user',
          content: 'Ich habe Fragen über die Vergangenheit.',
          translation: 'I have questions about the past tense.',
        ),
        const AITutorMessage(
          id: 'msg-3',
          sessionId: 'session-1',
          role: 'assistant',
          content: 'Perfekt! Im Deutschen gibt es zwei Vergangenheitsformen: Präteritum und Perfekt. Für reguläre Verben benutzt man meistens das Perfekt im gesprochenen Deutsch.',
          translation: 'Perfect! In German there are two past tense forms: Präteritum and Perfekt. For regular verbs, people mostly use Perfekt in spoken German.',
        ),
      ],
    ),
  ];

  static final List<AIWritingPractice> _mockWritingPractices = [
    const AIWritingPractice(
      id: 'practice-1',
      odlId: 'user1',
      topic: 'Mein Alltag',
      topicVi: 'My Daily Routine',
      prompt: 'Beschreiben Sie Ihren typischen Tag. Was machen Sie morgens, nachmittags und abends?',
      promptVi: 'Describe your typical day. What do you do in the morning, afternoon, and evening?',
      wordLimit: 100,
      isCompleted: true,
      overallScore: 75.0,
      grammarScore: 70.0,
      vocabularyScore: 80.0,
      coherenceScore: 75.0,
    ),
    const AIWritingPractice(
      id: 'practice-2',
      odlId: 'user1',
      topic: 'Urlaub',
      topicVi: 'Vacation',
      prompt: 'Schreiben Sie über Ihren letzten Urlaub. Wo sind Sie hingefahren? Was haben Sie gemacht?',
      promptVi: 'Write about your last vacation. Where did you go? What did you do?',
      wordLimit: 120,
      isCompleted: false,
    ),
  ];
}
