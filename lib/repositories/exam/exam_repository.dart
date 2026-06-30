import '../domain/exam_models.dart';

class ExamRepository {
  Future<List<ExamHub>> getExamHubs() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockHubs;
  }

  Future<ExamHub> getExamHub(String hubId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockHubs.firstWhere(
      (h) => h.id == hubId,
      orElse: () => _mockHubs.first,
    );
  }

  Future<List<WritingTopic>> getWritingTopics(String hubId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockWritingTopics;
  }

  Future<List<SpeakingTopic>> getSpeakingTopics(String hubId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockSpeakingTopics;
  }

  Future<ExamReadiness> getReadiness(String hubId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const ExamReadiness(
      hubId: 'goethe-b1',
      overallScore: 68.5,
      readingScore: 75.0,
      writingScore: 60.0,
      listeningScore: 70.0,
      speakingScore: 65.0,
      strengths: ['Reading comprehension', 'Vocabulary knowledge'],
      weaknesses: ['Essay structure', 'Speaking fluency'],
      recommendations: [
        'Practice writing essays 2-3 times per week',
        'Focus on complex sentence structures',
        'Do daily speaking practice with shadowing',
      ],
    );
  }

  Future<void> submitWriting(String topicId, String content) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<String> getWritingFeedback(String topicId) async {
    await Future.delayed(const Duration(seconds: 2));
    return '''
## Feedback

**Overall Score: 72/100**

### Strengths
- Good use of vocabulary
- Clear paragraph structure
- Appropriate formal tone

### Areas for Improvement
- Some grammar errors in subordinate clauses
- Need more transition words
- Conclusion could be stronger

### Detailed Comments
1. Line 3: "Ich habe gearbeitet" → "Ich habe bei der Firma gearbeitet" (add context)
2. Line 7: Missing comma before "weil"
3. Line 12: Consider using "außerdem" instead of "und auch"

### Suggestions
- Practice subordinate clause word order (verb at the end)
- Learn 10 more connecting words
- Read sample essays for structure ideas
''';
  }

  static final List<ExamHub> _mockHubs = [
    ExamHub(
      id: 'goethe-b1',
      name: 'Goethe B1',
      nameVi: 'Goethe B1',
      type: 'goethe',
      description: 'Official Goethe-Institut B1 certification preparation',
      descriptionVi: 'Luyện thi chứng chỉ Goethe-Institut B1 chính thức',
      level: 'B1',
      imageUrl: 'https://picsum.photos/seed/goethe/400/300',
      readinessScore: 68.5,
      completedExams: 3,
      totalExams: 5,
      sections: [
        const ExamSection(id: 'sec-1', hubId: 'goethe-b1', title: 'Lesen', titleVi: 'Đọc', type: 'reading', score: 75.0, totalQuestions: 30, correctAnswers: 22, isCompleted: true),
        const ExamSection(id: 'sec-2', hubId: 'goethe-b1', title: 'Hören', titleVi: 'Nghe', type: 'listening', score: 70.0, totalQuestions: 25, correctAnswers: 17, isCompleted: true),
        const ExamSection(id: 'sec-3', hubId: 'goethe-b1', title: 'Schreiben', titleVi: 'Viết', type: 'writing', score: 60.0, totalQuestions: 2, correctAnswers: 0, isCompleted: false),
        const ExamSection(id: 'sec-4', hubId: 'goethe-b1', title: 'Sprechen', titleVi: 'Nói', type: 'speaking', score: 65.0, totalQuestions: 3, correctAnswers: 0, isCompleted: false),
      ],
    ),
    const ExamHub(
      id: 'telc-b1',
      name: 'Telc B1',
      nameVi: 'Telc B1',
      type: 'telc',
      description: 'Telc B1 certification preparation',
      descriptionVi: 'Luyện thi chứng chỉ Telc B1',
      level: 'B1',
      imageUrl: 'https://picsum.photos/seed/telc/400/300',
      readinessScore: 55.0,
      completedExams: 1,
      totalExams: 5,
    ),
    const ExamHub(
      id: 'goethe-b2',
      name: 'Goethe B2',
      nameVi: 'Goethe B2',
      type: 'goethe',
      description: 'Goethe B2 certification preparation',
      descriptionVi: 'Luyện thi chứng chỉ Goethe B2',
      level: 'B2',
      imageUrl: 'https://picsum.photos/seed/goethe-b2/400/300',
      readinessScore: 0.0,
      completedExams: 0,
      totalExams: 5,
    ),
  ];

  static final List<WritingTopic> _mockWritingTopics = [
    const WritingTopic(
      id: 'write-1',
      hubId: 'goethe-b1',
      title: 'Freundschaft',
      titleVi: 'Tình bạn',
      prompt: 'Sie haben einen neuen Freund/eine neue Freundin im Deutschkurs kennengelernt. Schreiben Sie einen Brief an Ihre beste Freundin/Ihren besten Freund und berichten Sie über diese Person.',
      promptVi: 'Bạn đã gặp một người bạn mới trong khóa học tiếng Đức. Viết một bức thư cho người bạn thân và kể về người này.',
      wordLimit: 80,
      estimatedMinutes: 30,
      attempts: 0,
      sampleAnswers: [
        'Liebe Anna,\n\nich möchte dir von meiner neuen Freundin Maria erzählen...',
      ],
    ),
    const WritingTopic(
      id: 'write-2',
      hubId: 'goethe-b1',
      title: 'Arbeit und Beruf',
      titleVi: 'Công việc và nghề nghiệp',
      prompt: 'Sie haben einen Praktikumsplatz gefunden. Schreiben Sie eine E-Mail an Ihren Chef und bedanken Sie sich für die Möglichkeit.',
      promptVi: 'Bạn đã tìm được vị trí thực tập. Viết email cho sếp và cảm ơn về cơ hội này.',
      wordLimit: 80,
      estimatedMinutes: 30,
      attempts: 2,
      bestScore: 75.0,
    ),
    const WritingTopic(
      id: 'write-3',
      hubId: 'goethe-b1',
      title: 'Medien',
      titleVi: 'Phương tiện truyền thông',
      prompt: 'Sie haben einen Artikel über die Vor- und Nachteile von Social Media gelesen. Schreiben Sie eine Leserbrief an die Zeitung und geben Sie Ihre Meinung dazu.',
      promptVi: 'Bạn đã đọc một bài báo về ưu và nhược điểm của mạng xã hội. Viết thư phản hồi cho tờ báo và đưa ra ý kiến của bạn.',
      wordLimit: 80,
      estimatedMinutes: 30,
      attempts: 0,
    ),
  ];

  static final List<SpeakingTopic> _mockSpeakingTopics = [
    const SpeakingTopic(
      id: 'speak-1',
      hubId: 'goethe-b1',
      title: 'Vorstellen',
      titleVi: 'Giới thiệu bản thân',
      prompt: 'Stellen Sie sich vor. Sprechen Sie über Ihre Familie, Ihren Beruf und Ihre Hobbys.',
      promptVi: 'Tự giới thiệu. Nói về gia đình, công việc và sở thích của bạn.',
      estimatedMinutes: 3,
      attempts: 1,
      bestScore: 80.0,
    ),
    const SpeakingTopic(
      id: 'speak-2',
      hubId: 'goethe-b1',
      title: 'Freizeit',
      titleVi: 'Thời gian rảnh',
      prompt: 'Beschreiben Sie Ihre typical Freizeitaktivitäten. Was machen Sie am Wochenende?',
      promptVi: 'Mô tả các hoạt động thời gian rảnh của bạn. Bạn làm gì vào cuối tuần?',
      estimatedMinutes: 3,
      attempts: 0,
    ),
    const SpeakingTopic(
      id: 'speak-3',
      hubId: 'goethe-b1',
      title: 'Pläne',
      titleVi: 'Kế hoạch',
      prompt: 'Was sind Ihre Pläne für die nächste Woche / den nächsten Monat? Erzählen Sie.',
      promptVi: 'Kế hoạch của bạn cho tuần tới / tháng tới là gì? Kể về điều đó.',
      estimatedMinutes: 3,
      attempts: 0,
    ),
  ];
}
