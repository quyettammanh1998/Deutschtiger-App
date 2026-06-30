import '../domain/journey_models.dart';

class JourneyRepository {
  Future<List<JourneyChapter>> getChapters() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockChapters;
  }

  Future<JourneyChapter> getChapter(String chapterId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockChapters.firstWhere(
      (c) => c.id == chapterId,
      orElse: () => _mockChapters.first,
    );
  }

  Future<List<LearningItem>> getLearningItems(String chapterId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _generateLearningItems(chapterId);
  }

  Future<List<LearningItem>> getAllLearningItems() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _generateAllLearningItems();
  }

  Future<JourneyProgress> getProgress() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const JourneyProgress(
      odlId: 'user1',
      currentLevel: 'A2',
      totalXp: 12500,
      streakDays: 15,
      totalLessonsCompleted: 45,
      totalTimeSpentMinutes: 1800,
    );
  }

  static final List<JourneyChapter> _mockChapters = [
    JourneyChapter(
      id: 'a1',
      level: 'A1',
      title: 'Beginner A1',
      titleVi: 'Người mới bắt đầu A1',
      description: 'Basic German for absolute beginners',
      descriptionVi: 'Tiếng Đức cơ bản cho người mới bắt đầu',
      order: 1,
      totalLessons: 50,
      completedLessons: 50,
      progressPercent: 100.0,
      isCompleted: true,
      lessons: _generateLessons('a1', 50),
    ),
    JourneyChapter(
      id: 'a2',
      level: 'A2',
      title: 'Elementary A2',
      titleVi: 'Sơ cấp A2',
      description: 'Elementary German for everyday situations',
      descriptionVi: 'Tiếng Đức sơ cấp cho các tình huống hàng ngày',
      order: 2,
      totalLessons: 60,
      completedLessons: 25,
      progressPercent: 41.67,
      lessons: _generateLessons('a2', 60),
    ),
    JourneyChapter(
      id: 'b1',
      level: 'B1',
      title: 'Intermediate B1',
      titleVi: 'Trung cấp B1',
      description: 'Intermediate German for work and travel',
      descriptionVi: 'Tiếng Đức trung cấp cho công việc và du lịch',
      order: 3,
      totalLessons: 70,
      completedLessons: 0,
      progressPercent: 0.0,
      isLocked: false,
      lessons: _generateLessons('b1', 70),
    ),
    JourneyChapter(
      id: 'b2',
      level: 'B2',
      title: 'Upper Intermediate B2',
      titleVi: 'Trung cấp cao B2',
      description: 'Upper intermediate German',
      descriptionVi: 'Tiếng Đức trung cấp cao',
      order: 4,
      totalLessons: 80,
      completedLessons: 0,
      progressPercent: 0.0,
      isLocked: true,
      lessons: _generateLessons('b2', 80),
    ),
    JourneyChapter(
      id: 'c1',
      level: 'C1',
      title: 'Advanced C1',
      titleVi: 'Nâng cao C1',
      description: 'Advanced German for professional use',
      descriptionVi: 'Tiếng Đức nâng cao cho sử dụng chuyên nghiệp',
      order: 5,
      totalLessons: 90,
      completedLessons: 0,
      progressPercent: 0.0,
      isLocked: true,
      lessons: _generateLessons('c1', 90),
    ),
    JourneyChapter(
      id: 'c2',
      level: 'C2',
      title: 'Mastery C2',
      titleVi: 'Thành thạo C2',
      description: 'Mastery level German',
      descriptionVi: 'Tiếng Đức mức thành thạo',
      order: 6,
      totalLessons: 100,
      completedLessons: 0,
      progressPercent: 0.0,
      isLocked: true,
      lessons: _generateLessons('c2', 100),
    ),
  ];

  static List<JourneyLesson> _generateLessons(String chapterId, int count) {
    final lessonTypes = ['vocabulary', 'grammar', 'dialogue', 'exercise', 'review'];
    final topics = [
      'Greetings',
      'Numbers',
      'Colors',
      'Family',
      'Food',
      'Travel',
      'Work',
      'Shopping',
      'Health',
      'Culture',
    ];

    return List.generate(count, (i) => JourneyLesson(
      id: '$chapterId-lesson-$i',
      chapterId: chapterId,
      title: topics[i % topics.length],
      titleVi: _topicsVi[i % _topicsVi.length],
      type: lessonTypes[i % lessonTypes.length],
      order: i + 1,
      durationMinutes: 10 + (i % 5) * 5,
      xpReward: 10 + (i % 5) * 5,
      isCompleted: chapterId == 'a1' || (chapterId == 'a2' && i < 25),
      isLocked: chapterId != 'a1' && (chapterId == 'a2' ? i >= 25 : true),
    ));
  }

  static List<LearningItem> _generateLearningItems(String chapterId) {
    return List.generate(20, (i) => LearningItem(
      id: '$chapterId-item-$i',
      word: _sampleWords[i % _sampleWords.length],
      translation: _sampleTranslations[i % _sampleTranslations.length],
      pronunciation: _samplePronunciations[i % _samplePronunciations.length],
      level: chapterId.toUpperCase(),
      category: _categories[i % _categories.length],
      example: 'Das ist ein ${_sampleWords[i % _sampleWords.length]}.',
      exampleTranslation: 'This is a ${_sampleTranslations[i % _sampleTranslations.length]}.',
      isLearned: i < 5,
      reviewCount: i * 2,
      correctCount: (i * 2) - (i ~/ 2),
    ));
  }

  static List<LearningItem> _generateAllLearningItems() {
    final levels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
    final allItems = <LearningItem>[];
    int itemIndex = 0;
    
    for (final level in levels) {
      for (int i = 0; i < 15; i++) {
        allItems.add(LearningItem(
          id: '$level-item-$i',
          word: _sampleWords[itemIndex % _sampleWords.length],
          translation: _sampleTranslations[itemIndex % _sampleTranslations.length],
          pronunciation: _samplePronunciations[itemIndex % _samplePronunciations.length],
          level: level,
          category: _categories[i % _categories.length],
          example: 'Das ist ein ${_sampleWords[itemIndex % _sampleWords.length]}.',
          exampleTranslation: 'This is a ${_sampleTranslations[itemIndex % _sampleTranslations.length]}.',
          isLearned: itemIndex < 20,
          reviewCount: itemIndex * 2,
          correctCount: (itemIndex * 2) - (itemIndex ~/ 2),
        ));
        itemIndex++;
      }
    }
    return allItems;
  }

  static const _topicsVi = [
    'Chào hỏi',
    'Số đếm',
    'Màu sắc',
    'Gia đình',
    'Thực phẩm',
    'Du lịch',
    'Công việc',
    'Mua sắm',
    'Sức khỏe',
    'Văn hóa',
  ];

  static const _sampleWords = [
    'Haus', 'Auto', 'Buch', 'Mann', 'Frau',
    'Kind', 'Wasser', 'Brot', 'Milch', 'Apfel',
    'Katze', 'Hund', 'Tisch', 'Stuhl', 'Fenster',
    'Tür', 'Straße', 'Stadt', 'Land', 'Schule',
  ];

  static const _sampleTranslations = [
    'nhà', 'ô tô', 'sách', 'đàn ông', 'phụ nữ',
    'trẻ em', 'nước', 'bánh mì', 'sữa', 'táo',
    'mèo', 'chó', 'bàn', 'ghế', 'cửa sổ',
    'cửa', 'đường phố', 'thành phố', 'đất nước', 'trường học',
  ];

  static const _samplePronunciations = [
    'hous', 'auto', 'bookh', 'man', 'frow',
    'kint', 'vaser', 'broht', 'milk', 'apfel',
    'katze', 'hunt', 'tish', 'shtool', 'fenster',
    'tür', 'shtrahse', 'shtat', 'lant', 'shule',
  ];

  static const _categories = [
    'Nouns', 'Verbs', 'Adjectives', 'Prepositions', 'Conjunctions',
  ];
}
