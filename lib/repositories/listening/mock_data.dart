import '../../data/listening/podcast_models.dart';

/// Mock data for podcast series
final mockPodcastSeries = [
  PodcastSeries(
    id: 'easy-german',
    title: 'Easy German Podcast',
    titleVi: 'Podcast Tiếng Đức Dễ',
    description: 'Learn German through real conversations on the streets of Germany',
    descriptionVi: 'Học tiếng Đức qua các cuộc trò chuyện thực tế trên đường phố Đức',
    imageUrl: 'https://picsum.photos/seed/easygerman/400/300',
    level: 'A2-B1',
    language: 'German',
    totalEpisodes: 150,
    completedEpisodes: 23,
    episodes: _generateEasyGermanEpisodes(),
  ),
  PodcastSeries(
    id: 'sprechen-b1',
    title: 'Sprechen Deutsch B1',
    titleVi: 'Giao Tiếp Tiếng Đức B1',
    description: 'Advanced conversation practice for B1 level learners',
    descriptionVi: 'Luyện giao tiếp nâng cao cho người học cấp độ B1',
    imageUrl: 'https://picsum.photos/seed/sprechenb1/400/300',
    level: 'B1',
    language: 'German',
    totalEpisodes: 80,
    completedEpisodes: 12,
    episodes: _generateSprechenEpisodes('sprechen-b1', 'B1'),
  ),
  PodcastSeries(
    id: 'sprechen-b2',
    title: 'Sprechen Deutsch B2',
    titleVi: 'Giao Tiếp Tiếng Đức B2',
    description: 'Professional German conversation for B2 level',
    descriptionVi: 'Tiếng Đức chuyên nghiệp cho người học cấp độ B2',
    imageUrl: 'https://picsum.photos/seed/sprechenb2/400/300',
    level: 'B2',
    language: 'German',
    totalEpisodes: 60,
    completedEpisodes: 5,
    episodes: _generateSprechenEpisodes('sprechen-b2', 'B2'),
  ),
];

List<PodcastEpisode> _generateEasyGermanEpisodes() {
  return List.generate(150, (i) {
    final episodeNum = i + 1;
    return PodcastEpisode(
      id: 'eg-ep-$episodeNum',
      seriesId: 'easy-german',
      episodeNumber: episodeNum.toString(),
      title: 'Episode $episodeNum: Street Interview',
      titleVi: 'Tập $episodeNum: Phỏng vấn đường phố',
      description: 'Real Germans share their thoughts on everyday topics',
      descriptionVi: 'Người Đức thực sự chia sẻ suy nghĩ về các chủ đề hàng ngày',
      audioUrl: 'https://example.com/audio/eg-$episodeNum.mp3',
      durationSeconds: 900 + (episodeNum * 30) % 600,
      transcript: _sampleTranscript,
      transcriptUrl: 'https://example.com/transcript/eg-$episodeNum.txt',
      isCompleted: episodeNum <= 23,
      listenCount: episodeNum <= 23 ? (150 - episodeNum) * 2 : 0,
      progressPercent: episodeNum <= 23 ? 1.0 : 0.0,
    );
  });
}

List<PodcastEpisode> _generateSprechenEpisodes(String seriesId, String level) {
  final totalEpisodes = level == 'B1' ? 80 : 60;
  final completed = level == 'B1' ? 12 : 5;
  
  return List.generate(totalEpisodes, (i) {
    final episodeNum = i + 1;
    return PodcastEpisode(
      id: '$seriesId-ep-$episodeNum',
      seriesId: seriesId,
      episodeNumber: episodeNum.toString(),
      title: 'Lesson $episodeNum',
      titleVi: 'Bài $episodeNum',
      description: 'German conversation practice at $level level',
      descriptionVi: 'Luyện giao tiếp tiếng Đức cấp độ $level',
      audioUrl: 'https://example.com/audio/$seriesId-$episodeNum.mp3',
      durationSeconds: 1200 + (episodeNum * 45) % 900,
      transcript: _sampleTranscript,
      transcriptUrl: 'https://example.com/transcript/$seriesId-$episodeNum.txt',
      isCompleted: episodeNum <= completed,
      listenCount: episodeNum <= completed ? (100 - episodeNum) : 0,
      progressPercent: episodeNum <= completed ? 1.0 : 0.0,
    );
  });
}

const _sampleTranscript = '''
Hallo und willkommen bei Easy German!

In today's episode, we're talking about people's favorite German foods.

Ich esse gerneDeutsches Essen. - I like to eat German food.

Mein Lieblingsessen ist Schnitzel. - My favorite food is schnitzel.

Die Deutschen essen gerne Brot. - Germans like to eat bread.

Das Frühstück ist sehr wichtig in Deutschland. - Breakfast is very important in Germany.

Wir trinken gerne Kaffee am Morgen. - We like to drink coffee in the morning.

''';

/// Mock data for audiobooks
final mockAudiobooks = [
  Audiobook(
    id: 'ab-1',
    title: 'Die kleine Raupe Nimmersatt',
    titleVi: 'The Very Hungry Caterpillar',
    author: 'Eric Carle',
    description: 'Classic German children\'s story',
    imageUrl: 'https://picsum.photos/seed/audiobook1/400/300',
    level: 'A1',
    totalChapters: 10,
    completedChapters: 3,
    chapters: _generateAudiobookChapters('ab-1', 10),
  ),
  Audiobook(
    id: 'ab-2',
    title: 'Momo',
    titleVi: 'Momo',
    author: 'Michael Ende',
    description: 'German classic literature',
    imageUrl: 'https://picsum.photos/seed/audiobook2/400/300',
    level: 'B1',
    totalChapters: 25,
    completedChapters: 0,
    chapters: _generateAudiobookChapters('ab-2', 25),
  ),
];

List<AudiobookChapter> _generateAudiobookChapters(String audiobookId, int total) {
  return List.generate(total, (i) {
    final chapterNum = i + 1;
    return AudiobookChapter(
      id: '$audiobookId-ch-$chapterNum',
      audiobookId: audiobookId,
      chapterNumber: chapterNum.toString(),
      title: 'Kapitel $chapterNum',
      titleVi: 'Chapter $chapterNum',
      audioUrl: 'https://example.com/audio/$audiobookId-ch$chapterNum.mp3',
      durationSeconds: 1800 + (chapterNum * 120) % 600,
      isCompleted: chapterNum <= (audiobookId == 'ab-1' ? 3 : 0),
    );
  });
}

/// Mock data for dictation exercises
final mockDictations = [
  Dictation(
    id: 'dict-a1-1',
    title: 'A1 Dictation: Numbers & Colors',
    titleVi: 'A1 Nghe viết: Số và Màu sắc',
    level: 'A1',
    difficulty: 1,
    totalSentences: 10,
    correctAnswers: 8,
    isCompleted: false,
  ),
  Dictation(
    id: 'dict-a1-2',
    title: 'A1 Dictation: Family & Home',
    titleVi: 'A1 Nghe viết: Gia đình và Nhà cửa',
    level: 'A1',
    difficulty: 1,
    totalSentences: 10,
    correctAnswers: 7,
    isCompleted: false,
  ),
  Dictation(
    id: 'dict-a2-1',
    title: 'A2 Dictation: Daily Routine',
    titleVi: 'A2 Nghe viết: Cuộc sống hàng ngày',
    level: 'A2',
    difficulty: 2,
    totalSentences: 15,
    correctAnswers: 12,
    isCompleted: true,
  ),
  Dictation(
    id: 'dict-b1-1',
    title: 'B1 Dictation: Travel & Vacation',
    titleVi: 'B1 Nghe viết: Du lịch và Kỳ nghỉ',
    level: 'B1',
    difficulty: 3,
    totalSentences: 15,
    correctAnswers: 0,
    isCompleted: false,
  ),
];
