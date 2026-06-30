import 'dart:math';
import '../domain/ai_models.dart';
import 'mock_data.dart';

/// Repository for AI features - handles mock data and AI responses
class AIRepository {
  /// Get all chat sessions
  Future<List<AISession>> getSessions() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return AIMockData.mockSessions;
  }

  /// Get chat history items for sidebar
  Future<List<ChatHistoryItem>> getChatHistory() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return AIMockData.mockHistory;
  }

  /// Get a specific session by ID
  Future<AISession?> getSession(String sessionId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    try {
      return AIMockData.mockSessions.firstWhere((s) => s.id == sessionId);
    } catch (_) {
      return null;
    }
  }

  /// Get available AI modes
  Future<List<AIMode>> getModes() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return AIMockData.mockModes;
  }

  /// Get current AI mode
  Future<AIMode> getCurrentMode(String modeId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    try {
      return AIMockData.mockModes.firstWhere((m) => m.id == modeId);
    } catch (_) {
      return AIMockData.mockModes.first;
    }
  }

  /// Send a message and get AI response
  Future<AIChatMessage> sendMessage({
    required String sessionId,
    required String content,
    required String mode,
  }) async {
    await Future.delayed(Duration(milliseconds: 500 + Random().nextInt(500)));
    
    return AIChatMessage(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
      sessionId: sessionId,
      role: 'assistant',
      content: _generateResponse(content, mode),
      translation: _generateTranslation(content, mode),
      vocabularyHighlight: _extractVocabulary(content),
      grammarCorrections: _checkGrammar(content),
      createdAt: DateTime.now(),
    );
  }

  /// Get writing practices
  Future<List<WritingPractice>> getWritingPractices() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return AIMockData.mockWritingPractices;
  }

  /// Submit writing for AI feedback
  Future<WritingPractice> submitWriting({
    required String practiceId,
    required String content,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    
    final practice = AIMockData.mockWritingPractices.first;
    return practice.copyWith(
      userText: content,
      isCompleted: true,
      overallScore: 75.0 + Random().nextDouble() * 20,
      grammarScore: 70.0 + Random().nextDouble() * 20,
      vocabularyScore: 75.0 + Random().nextDouble() * 20,
      coherenceScore: 72.0 + Random().nextDouble() * 20,
      submittedAt: DateTime.now(),
      feedback: _generateWritingFeedback(content),
    );
  }

  /// Get AI settings
  Future<AISettings> getSettings() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return AIMockData.mockSettings;
  }

  /// Update AI settings
  Future<AISettings> updateSettings(AISettings settings) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return settings;
  }

  /// Create a new session
  Future<AISession> createSession(String mode) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final modeInfo = AIMockData.mockModes.firstWhere(
      (m) => m.id == mode,
      orElse: () => AIMockData.mockModes.first,
    );
    
    return AISession(
      id: 'session-${DateTime.now().millisecondsSinceEpoch}',
      title: 'New ${modeInfo.name} Session',
      mode: mode,
      messages: [
        AIChatMessage(
          id: 'welcome-${DateTime.now().millisecondsSinceEpoch}',
          sessionId: 'session-${DateTime.now().millisecondsSinceEpoch}',
          role: 'assistant',
          content: _getWelcomeMessage(mode),
          translation: _getWelcomeTranslation(mode),
          createdAt: DateTime.now(),
        ),
      ],
      createdAt: DateTime.now(),
      lastMessageAt: DateTime.now(),
    );
  }

  String _getWelcomeMessage(String mode) {
    switch (mode) {
      case 'grammar':
        return 'Hallo! Ich bin dein Grammatik-Tutor. Stelle mir gerne Fragen zur deutschen Grammatik!';
      case 'conversation':
        return 'Hallo! Lass uns auf Deutsch plaudern. Über was möchtest du sprechen?';
      case 'vocabulary':
        return 'Hallo! Ich helfe dir, neue deutsche Wörter und Ausdrücke zu lernen.';
      case 'exam':
        return 'Hallo! Bereiten wir uns auf deine Prüfung vor. Welches Niveau üben wir heute?';
      default:
        return 'Hallo! Ich bin dein AI-Tutor. Wie kann ich dir heute helfen?';
    }
  }

  String _getWelcomeTranslation(String mode) {
    switch (mode) {
      case 'grammar':
        return 'Hello! I am your grammar tutor. Feel free to ask me questions about German grammar!';
      case 'conversation':
        return 'Hello! Let\'s chat in German. What would you like to talk about?';
      case 'vocabulary':
        return 'Hello! I will help you learn new German words and expressions.';
      case 'exam':
        return 'Hello! Let\'s prepare for your exam. What level shall we practice today?';
      default:
        return 'Hello! I am your AI tutor. How can I help you today?';
    }
  }

  String _generateResponse(String content, String mode) {
    final lower = content.toLowerCase();
    
    if (lower.contains('grammatik') || lower.contains('grammar')) {
      return 'Gute Frage zur Grammatik! Lass mich das erklären. Im Deutschen ist die Wortstellung sehr wichtig. Das Verb steht im Nebensatz am Ende.';
    } else if (lower.contains('wie geht') || lower.contains('how are')) {
      return 'Mir geht es gut, danke! Und dir? Hast du heute schon Deutsch geübt?';
    } else if (lower.contains('helfen') || lower.contains('help')) {
      return 'Natürlich helfe ich dir gerne! Was möchtest du lernen? Wir können über Grammatik, Vokabeln oder Konversation sprechen.';
    } else if (lower.contains('danke') || lower.contains('thank')) {
      return 'Bitte schön! Es freut mich, wenn ich helfen kann. Hast du noch weitere Fragen?';
    } else if (lower.contains('verb') || lower.contains('zeit')) {
      return 'Gute Frage! Die deutschen Verben ändern sich je nach Person und Zeitform. Zum Beispiel: "sein" (to be) - ich bin, du bist, er/sie/es ist.';
    } else if (lower.contains('fall') || lower.contains('case')) {
      return 'Im Deutschen gibt es vier Fälle: Nominativ, Akkusativ, Dativ und Genitiv. Sie zeigen die Rolle eines Wortes im Satz an.';
    } else {
      return 'Das ist interessant! Erzähl mir mehr darüber. Was möchtest du auf Deutsch üben? Ich kann dir bei Grammatik, Vokabeln oder Konversation helfen.';
    }
  }

  String _generateTranslation(String content, String mode) {
    final lower = content.toLowerCase();
    
    if (lower.contains('grammatik') || lower.contains('grammar')) {
      return 'Good question about grammar! Let me explain. In German, word order is very important. The verb comes at the end of subordinate clauses.';
    } else if (lower.contains('wie geht') || lower.contains('how are')) {
      return 'I\'m fine, thank you! And you? Have you practiced German today?';
    } else if (lower.contains('helfen') || lower.contains('help')) {
      return 'Of course, I\'m happy to help! What would you like to learn? We can talk about grammar, vocabulary, or conversation.';
    } else {
      return 'That\'s interesting! Tell me more about it. What would you like to practice in German?';
    }
  }

  List<String> _extractVocabulary(String text) {
    final words = text.toLowerCase().split(RegExp(r'\s+'));
    final germanWords = words.where((w) => 
      w.length > 4 && 
      !_commonWords.contains(w) &&
      RegExp(r'^[a-zäöüß]+$').hasMatch(w)
    );
    return germanWords.take(3).toList();
  }

  List<GrammarCorrection> _checkGrammar(String text) {
    final corrections = <GrammarCorrection>[];
    
    // Check for common mistakes
    if (text.contains('Ich bin') && text.contains(' geht ')) {
      corrections.add(const GrammarCorrection(
        id: 'gc-1',
        original: 'Ich bin geht',
        correction: 'Mir geht es',
        explanation: 'Use "Mir geht es" to say "I am doing" in German.',
        startIndex: 0,
        endIndex: 10,
        grammarRule: 'Reflexive expressions with "geht"',
      ));
    }
    
    return corrections;
  }

  List<WritingFeedback> _generateWritingFeedback(String content) {
    final feedback = <WritingFeedback>[];
    final words = content.split(RegExp(r'\s+'));
    
    if (words.length < 50) {
      feedback.add(const WritingFeedback(
        id: 'wf-1',
        type: 'length',
        original: '',
        suggestion: 'Versuchen Sie, längere Sätze zu schreiben (mindestens 100 Wörter).',
        explanation: 'Your text is too short. Try to write more detailed sentences.',
        category: 'content',
      ));
    }
    
    if (!content.contains('.') && !content.contains(',')) {
      feedback.add(const WritingFeedback(
        id: 'wf-2',
        type: 'punctuation',
        original: '',
        suggestion: 'Fügen Sie mehr Satzzeichen hinzu: Kommas und Punkte.',
        explanation: 'Use proper punctuation to structure your text.',
        category: 'format',
      ));
    }
    
    feedback.add(const WritingFeedback(
      id: 'wf-3',
      type: 'general',
      original: '',
      suggestion: 'Gut gemacht! Versuchen Sie, mehr connectors wie "außerdem", "deshalb", "jedoch" zu verwenden.',
      explanation: 'Good attempt! Consider adding more connecting words.',
      category: 'coherence',
    ));
    
    return feedback;
  }

  static const _commonWords = {
    'und', 'der', 'die', 'das', 'ist', 'ein', 'eine', 'ich', 'du', 'wir',
    'sie', 'es', 'haben', 'sein', 'werden', 'können', 'müssen', 'sollen',
    'nicht', 'mit', 'auf', 'für', 'von', 'zu', 'auch', 'wie', 'aber',
  };
}
