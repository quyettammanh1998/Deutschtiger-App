import '../domain/speaking_models.dart';

class SpeakingRepository {
  Future<List<SpeakingSession>> getShadowingSessions() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockShadowingSessions;
  }

  Future<List<PronunciationTrainer>> getPronunciationTrainers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockTrainers;
  }

  Future<List<AIConversation>> getAIConversations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockAIConversations;
  }

  Future<AIConversationHistory> startAIConversation(String conversationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final conversation = _mockAIConversations.firstWhere(
      (c) => c.id == conversationId,
      orElse: () => _mockAIConversations.first,
    );

    return AIConversationHistory(
      id: 'history-${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      messages: conversation.messages,
      startedAt: DateTime.now(),
    );
  }

  Future<SpeakingAttempt> submitRecording({
    required String sessionId,
    required String audioPath,
    required String expectedText,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Simulate speech recognition and scoring
    final accuracy = 0.7 + (DateTime.now().millisecond % 30) / 100;
    
    return SpeakingAttempt(
      id: 'attempt-${DateTime.now().millisecondsSinceEpoch}',
      sessionId: sessionId,
      expectedText: expectedText,
      spokenText: expectedText,
      audioUrl: audioPath,
      accuracyScore: accuracy,
      wordResults: _generateWordResults(expectedText, accuracy),
      durationSeconds: 10 + (DateTime.now().second % 30),
      recordedAt: DateTime.now(),
    );
  }

  List<WordResult> _generateWordResults(String text, double accuracy) {
    final words = text.split(' ');
    return words.map((w) => WordResult(
      word: w,
      isCorrect: accuracy > 0.5,
      expected: w,
      spoken: w,
      confidence: accuracy,
    )).toList();
  }

  static final List<SpeakingSession> _mockShadowingSessions = [
    SpeakingSession(
      id: 'shadow-1',
      odlId: 'user1',
      type: 'shadowing',
      title: 'Greetings & Introductions',
      titleVi: 'Chào hỏi & Giới thiệu',
      description: 'Practice common greetings and self-introductions',
      transcript: 'Hallo, mein Name ist Anna. Ich komme aus Berlin. Freut mich!',
      translation: 'Hello, my name is Anna. I come from Berlin. Nice to meet you!',
      durationSeconds: 30,
      accuracyScore: 20,
    ),
    SpeakingSession(
      id: 'shadow-2',
      odlId: 'user1',
      type: 'shadowing',
      title: 'At the Restaurant',
      titleVi: 'Ở Nhà hàng',
      description: 'Practice ordering food and drinks',
      transcript: 'Guten Abend, ich möchte einen Tisch für zwei Personen, bitte.',
      translation: 'Good evening, I would like a table for two, please.',
      durationSeconds: 45,
      accuracyScore: 25,
    ),
    SpeakingSession(
      id: 'shadow-3',
      odlId: 'user1',
      type: 'shadowing',
      title: 'Asking for Directions',
      titleVi: 'Hỏi đường',
      description: 'Learn how to ask and give directions',
      transcript: 'Entschuldigung, wo ist der Bahnhof? Gehen Sie geradeaus.',
      translation: 'Excuse me, where is the train station? Go straight ahead.',
      durationSeconds: 40,
      accuracyScore: 25,
    ),
  ];

  static final List<PronunciationTrainer> _mockTrainers = [
    PronunciationTrainer(
      id: 'trainer-umlaut',
      type: 'umlaut',
      name: 'Umlaut Trainer',
      nameVi: 'Bài tập Umlaut',
      targetSound: 'ä/ö/ü',
      description: 'Master the German umlaut sounds: ä, ö, ü',
      exercises: [
        TrainerExercise(id: 'ex-umlaut-1', trainerId: 'trainer-umlaut', word: 'Mädchen', translation: 'girl', phonetic: '/ˈmɛːtçən/', order: 1),
        TrainerExercise(id: 'ex-umlaut-2', trainerId: 'trainer-umlaut', word: 'schön', translation: 'beautiful', phonetic: '/ʃøːn/', order: 2),
        TrainerExercise(id: 'ex-umlaut-3', trainerId: 'trainer-umlaut', word: 'grün', translation: 'green', phonetic: '/ɡʁyːn/', order: 3),
        TrainerExercise(id: 'ex-umlaut-4', trainerId: 'trainer-umlaut', word: 'Hände', translation: 'hands', phonetic: '/ˈhɛndə/', order: 4),
        TrainerExercise(id: 'ex-umlaut-5', trainerId: 'trainer-umlaut', word: 'Köln', translation: 'Cologne', phonetic: '/kœln/', order: 5),
      ],
    ),
    PronunciationTrainer(
      id: 'trainer-r',
      type: 'r-sound',
      name: 'R-Sound Trainer',
      nameVi: 'Bài tập âm R',
      targetSound: 'r',
      description: 'Practice the German R sound',
      exercises: [
        TrainerExercise(id: 'ex-r-1', trainerId: 'trainer-r', word: 'rot', translation: 'red', phonetic: '/ʁoːt/', order: 1),
        TrainerExercise(id: 'ex-r-2', trainerId: 'trainer-r', word: 'Radio', translation: 'radio', phonetic: '/ˈʁaːdi̯o/', order: 2),
        TrainerExercise(id: 'ex-r-3', trainerId: 'trainer-r', word: 'Arbeit', translation: 'work', phonetic: '/ˈaʁbaɪ̯t/', order: 3),
        TrainerExercise(id: 'ex-r-4', trainerId: 'trainer-r', word: 'Frau', translation: 'woman', phonetic: '/fʁaʊ̯/', order: 4),
        TrainerExercise(id: 'ex-r-5', trainerId: 'trainer-r', word: 'bringen', translation: 'to bring', phonetic: '/ˈbʁɪŋən/', order: 5),
      ],
    ),
    PronunciationTrainer(
      id: 'trainer-ich-ach',
      type: 'ich-ach',
      name: 'Ich-Ach Trainer',
      nameVi: 'Bài tập Ich-Ach',
      targetSound: 'ich/ach',
      description: 'Learn to distinguish between ich and ach sounds',
      exercises: [
        TrainerExercise(id: 'ex-ia-1', trainerId: 'trainer-ich-ach', word: 'ich', translation: 'I', phonetic: '/ɪç/', order: 1),
        TrainerExercise(id: 'ex-ia-2', trainerId: 'trainer-ich-ach', word: 'acht', translation: 'eight', phonetic: '/axt/', order: 2),
        TrainerExercise(id: 'ex-ia-3', trainerId: 'trainer-ich-ach', word: 'mich', translation: 'me', phonetic: '/mɪç/', order: 3),
        TrainerExercise(id: 'ex-ia-4', trainerId: 'trainer-ich-ach', word: 'Buch', translation: 'book', phonetic: '/buːx/', order: 4),
        TrainerExercise(id: 'ex-ia-5', trainerId: 'trainer-ich-ach', word: 'dich', translation: 'you', phonetic: '/dɪç/', order: 5),
      ],
    ),
    PronunciationTrainer(
      id: 'trainer-sp-st',
      type: 'sp-st',
      name: 'Sp-St Trainer',
      nameVi: 'Bài tập Sp-St',
      targetSound: 'sp/st → shp/sht',
      description: 'Master the German sp→shp and st→sht rule',
      exercises: [
        TrainerExercise(id: 'ex-spst-1', trainerId: 'trainer-sp-st', word: 'sprechen', translation: 'to speak', phonetic: '/ˈʃpʁɛçən/', order: 1),
        TrainerExercise(id: 'ex-spst-2', trainerId: 'trainer-sp-st', word: 'Straße', translation: 'street', phonetic: '/ˈʃtʁaːsə/', order: 2),
        TrainerExercise(id: 'ex-spst-3', trainerId: 'trainer-sp-st', word: 'spielen', translation: 'to play', phonetic: '/ˈʃpiːlən/', order: 3),
        TrainerExercise(id: 'ex-spst-4', trainerId: 'trainer-sp-st', word: 'Student', translation: 'student', phonetic: '/ʃtuˈdɛnt/', order: 4),
        TrainerExercise(id: 'ex-spst-5', trainerId: 'trainer-sp-st', word: 'Spaß', translation: 'fun', phonetic: '/ʃpaːs/', order: 5),
      ],
    ),
  ];

  static final List<AIConversation> _mockAIConversations = [
    const AIConversation(
      id: 'ai-convo-1',
      title: 'At the Café',
      titleVi: 'Ở Quán Café',
      scenario: 'You are ordering coffee and pastries at a traditional German café. Practice your order and small talk.',
      scenarioVi: 'Bạn đang order cà phê và bánh ngọt tại một quán café truyền thống Đức. Thực hành order và trò chuyện nhỏ.',
      level: 'A1-A2',
      imageUrl: 'https://picsum.photos/seed/cafe/400/300',
      estimatedMinutes: 10,
      averageScore: 4.2,
      messages: [
        AIMessage(id: 'msg-1', role: 'assistant', content: 'Guten Tag! Willkommen im Café. Was darf es sein?', translation: 'Hello! Welcome to the café. What can I get you?', score: 5.0),
        AIMessage(id: 'msg-2', role: 'user', content: 'Ich hätte gerne einen Kaffee, bitte.', translation: 'I would like a coffee, please.', score: 4.5),
        AIMessage(id: 'msg-3', role: 'assistant', content: 'Möchten Sie Milch oder Zucker?', translation: 'Would you like milk or sugar?', score: 5.0),
      ],
    ),
    const AIConversation(
      id: 'ai-convo-2',
      title: 'Job Interview',
      titleVi: 'Phỏng vấn xin việc',
      scenario: 'You are being interviewed for a German company. Practice answering common interview questions.',
      scenarioVi: 'Bạn đang được phỏng vấn cho một công ty Đức. Thực hành trả lời các câu hỏi phỏng vấn thông thường.',
      level: 'B1-B2',
      imageUrl: 'https://picsum.photos/seed/interview/400/300',
      estimatedMinutes: 15,
      averageScore: 3.8,
      messages: [
        AIMessage(id: 'msg-1', role: 'assistant', content: 'Guten Tag, kommen Sie bitte herein. Setzen Sie sich doch.', translation: 'Good day, please come in. Please sit down.', score: 5.0),
        AIMessage(id: 'msg-2', role: 'user', content: 'Danke schön. Ich bin sehr nervös.', translation: 'Thank you very much. I am very nervous.', score: 4.0),
        AIMessage(id: 'msg-3', role: 'assistant', content: 'Kein Problem. Erzählen Sie mir etwas über sich.', translation: 'No problem. Tell me something about yourself.', score: 5.0),
      ],
    ),
    const AIConversation(
      id: 'ai-convo-3',
      title: 'Traveling',
      titleVi: 'Du lịch',
      scenario: 'You are at a train station asking for directions to your hotel.',
      scenarioVi: 'Bạn đang ở nhà ga hỏi đường đến khách sạn.',
      level: 'A1',
      imageUrl: 'https://picsum.photos/seed/travel/400/300',
      estimatedMinutes: 5,
      averageScore: 4.5,
      messages: [
        AIMessage(id: 'msg-1', role: 'assistant', content: 'Entschuldigung, kann ich Ihnen helfen?', translation: 'Excuse me, can I help you?', score: 5.0),
        AIMessage(id: 'msg-2', role: 'user', content: 'Ja, ich suche das Hotel Zentrum.', translation: 'Yes, I am looking for the Hotel Zentrum.', score: 4.5),
      ],
    ),
  ];
}
