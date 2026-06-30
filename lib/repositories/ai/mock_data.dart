import '../../data/ai/ai_models.dart';

/// Mock data for AI features
class AIMockData {
  static const List<AISession> mockSessions = [
    AISession(
      id: 'session-1',
      title: 'Grammar Practice - Nebensatz',
      mode: 'grammar',
      messageCount: 12,
      tokensUsed: 1850,
      createdAt: null,
      lastMessageAt: null,
      messages: [
        const AIChatMessage(
          id: 'msg-1-1',
          sessionId: 'session-1',
          role: 'assistant',
          content: 'Hallo! Willkommen zu deiner Grammatik-Übung. Heute üben wir Nebensätze mit "dass".',
          translation: 'Hello! Welcome to your grammar practice. Today we practice subordinate clauses with "dass".',
          vocabularyHighlight: ['Nebensatz', 'dass', 'Übung'],
        ),
        const AIChatMessage(
          id: 'msg-1-2',
          sessionId: 'session-1',
          role: 'user',
          content: 'Ich weiß, dass du Deutsch lernst.',
          translation: 'I know that you are learning German.',
        ),
        const AIChatMessage(
          id: 'msg-1-3',
          sessionId: 'session-1',
          role: 'assistant',
          content: 'Sehr gut! Dein Satz ist perfekt. Das Verb "lernst" steht am Ende des Nebensatzes, wie es sein sollte.',
          translation: 'Very good! Your sentence is perfect. The verb "lernst" is at the end of the subordinate clause, as it should be.',
          vocabularyHighlight: ['Verb', 'Ende', 'Nebensatz'],
          grammarCorrections: [],
        ),
      ],
    ),
    AISession(
      id: 'session-2',
      title: 'Conversation - Alltag',
      mode: 'conversation',
      messageCount: 8,
      tokensUsed: 1200,
      createdAt: null,
      lastMessageAt: null,
    ),
    AISession(
      id: 'session-3',
      title: 'Vocabulary - Berufe',
      mode: 'vocabulary',
      messageCount: 15,
      tokensUsed: 2100,
      createdAt: null,
      lastMessageAt: null,
    ),
    AISession(
      id: 'session-4',
      title: 'Exam Prep - B2',
      mode: 'exam',
      messageCount: 25,
      tokensUsed: 3500,
      createdAt: null,
      lastMessageAt: null,
    ),
  ];

  static const List<ChatHistoryItem> mockHistory = [
    ChatHistoryItem(
      id: 'session-1',
      title: 'Grammar Practice - Nebensatz',
      mode: 'grammar',
      messageCount: 12,
      lastMessageAt: null,
    ),
    ChatHistoryItem(
      id: 'session-2',
      title: 'Conversation - Alltag',
      mode: 'conversation',
      messageCount: 8,
      lastMessageAt: null,
    ),
    ChatHistoryItem(
      id: 'session-3',
      title: 'Vocabulary - Berufe',
      mode: 'vocabulary',
      messageCount: 15,
      lastMessageAt: null,
    ),
  ];

  static const List<AIMode> mockModes = [
    AIMode(
      id: 'grammar',
      name: 'Grammar Teacher',
      nameVi: 'Giáo viên Ngữ pháp',
      description: 'A patient teacher who explains grammar rules clearly with examples',
      descriptionVi: 'Một giáo viên kiên nhẫn giải thích ngữ pháp rõ ràng với ví dụ',
      avatar: 'teacher',
      tone: 'formal',
      focus: 'grammar',
    ),
    AIMode(
      id: 'conversation',
      name: 'Conversation Partner',
      nameVi: 'Bạn đối thoại',
      description: 'Practice German conversations naturally and fluently',
      descriptionVi: 'Thực hành đối thoại tiếng Đức một cách tự nhiên',
      avatar: 'chat',
      tone: 'casual',
      focus: 'conversation',
    ),
    AIMode(
      id: 'vocabulary',
      name: 'Vocabulary Builder',
      nameVi: 'Xây dựng Từ vựng',
      description: 'Learn new words and phrases in context',
      descriptionVi: 'Học từ mới và cụm từ trong ngữ cảnh',
      avatar: 'books',
      tone: 'encouraging',
      focus: 'vocabulary',
    ),
    AIMode(
      id: 'exam',
      name: 'Exam Preparation',
      nameVi: 'Luyện thi',
      description: 'Prepare for Goethe, TELC, or ÖSD exams',
      descriptionVi: 'Chuẩn bị cho các kỳ thi Goethe, TELC hoặc ÖSD',
      avatar: 'exam',
      tone: 'formal',
      focus: 'exam',
      isExamContext: true,
    ),
  ];

  static const List<WritingPractice> mockWritingPractices = [
    WritingPractice(
      id: 'practice-1',
      title: 'Mein Alltag',
      titleVi: 'My Daily Routine',
      prompt: 'Beschreiben Sie Ihren typischen Arbeitstag. Was machen Sie morgens, nachmittags und abends?',
      promptVi: 'Describe your typical work day. What do you do in the morning, afternoon, and evening?',
      wordLimit: 100,
      isCompleted: true,
      overallScore: 78.0,
      grammarScore: 75.0,
      vocabularyScore: 80.0,
      coherenceScore: 79.0,
      createdAt: null,
    ),
    WritingPractice(
      id: 'practice-2',
      title: 'Urlaub',
      titleVi: 'Vacation',
      prompt: 'Schreiben Sie über Ihren letzten Urlaub. Wo sind Sie hingefahren? Was haben Sie gemacht?',
      promptVi: 'Write about your last vacation. Where did you go? What did you do?',
      wordLimit: 120,
      isCompleted: false,
      createdAt: null,
    ),
    WritingPractice(
      id: 'practice-3',
      title: 'Meine Familie',
      titleVi: 'My Family',
      prompt: 'Beschreiben Sie Ihre Familie. Wer sind die Mitglieder? Was machen sie?',
      promptVi: 'Describe your family. Who are the members? What do they do?',
      wordLimit: 100,
      isCompleted: false,
      createdAt: null,
    ),
    WritingPractice(
      id: 'practice-4',
      title: 'Gesund leben',
      titleVi: 'Living Healthy',
      prompt: 'Was bedeutet "gesund leben" für Sie? Welche Gewohnheiten haben Sie?',
      promptVi: 'What does "living healthy" mean to you? What habits do you have?',
      wordLimit: 150,
      isCompleted: false,
      createdAt: null,
    ),
  ];

  static const AISettings mockSettings = AISettings(
    userLevel: 'B1',
    learningGoals: ['Grammar', 'Conversation', 'Exam Prep'],
    includeTranslations: true,
    showGrammarHints: true,
    showVocabularyHighlights: true,
    focusExam: 'Goethe B1',
    maxTokensPerResponse: 500,
  );
}
