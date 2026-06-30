import '../domain/podcast_models.dart';

class PodcastRepository {
  static final List<PodcastSeries> _mockSeries = [
    const PodcastSeries(
      id: 'easy-german',
      title: 'Easy German Podcast',
      titleVi: 'Podcast Tiếng Đức Dễ',
      description: 'Learn German with real conversations on the streets of Germany',
      descriptionVi: 'Học tiếng Đức qua các cuộc trò chuyện thực tế trên đường phố Đức',
      level: 'A2-B1',
      language: 'German',
      imageUrl: 'https://picsum.photos/seed/easy-german/400/300',
      totalEpisodes: 100,
      episodes: [],
    ),
    const PodcastSeries(
      id: 'sprechen-b1',
      title: 'Sprechen B1',
      titleVi: 'Sprechen B1',
      description: 'German conversations at B1 level',
      descriptionVi: 'Các cuộc trò chuyện tiếng Đức cấp độ B1',
      level: 'B1',
      language: 'German',
      imageUrl: 'https://picsum.photos/seed/sprechen-b1/400/300',
      totalEpisodes: 50,
      episodes: [],
    ),
    const PodcastSeries(
      id: 'sprechen-b2',
      title: 'Sprechen B2',
      titleVi: 'Sprechen B2',
      description: 'Advanced German conversations at B2 level',
      descriptionVi: 'Các cuộc trò chuyện nâng cao tiếng Đức cấp độ B2',
      level: 'B2',
      language: 'German',
      imageUrl: 'https://picsum.photos/seed/sprechen-b2/400/300',
      totalEpisodes: 50,
      episodes: [],
    ),
  ];

  static final List<Audiobook> _mockAudiobooks = [
    const Audiobook(
      id: 'audiobook-1',
      title: 'Die Chefin',
      titleVi: 'The Chief',
      author: 'Hans Beer',
      description: 'A detective story in simple German - Một câu chuyện trinh thám bằng tiếng Đức đơn giản',
      level: 'A2',
      imageUrl: 'https://picsum.photos/seed/audiobook1/400/600',
      totalChapters: 20,
    ),
  ];

  static final List<Dictation> _mockDictations = [
    const Dictation(
      id: 'dict-a1',
      title: 'Dictation A1',
      titleVi: 'Nghe viết A1',
      level: 'A1',
      difficulty: 1,
      totalSentences: 10,
    ),
    const Dictation(
      id: 'dict-a2',
      title: 'Dictation A2',
      titleVi: 'Nghe viết A2',
      level: 'A2',
      difficulty: 2,
      totalSentences: 10,
    ),
    const Dictation(
      id: 'dict-b1',
      title: 'Dictation B1',
      titleVi: 'Nghe viết B1',
      level: 'B1',
      difficulty: 3,
      totalSentences: 10,
    ),
  ];

  Future<List<PodcastSeries>> getPodcastSeries() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockSeries;
  }

  Future<List<PodcastEpisode>> getEpisodes(String seriesId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.generate(
      20,
      (i) => PodcastEpisode(
        id: '$seriesId-ep-${i + 1}',
        seriesId: seriesId,
        episodeNumber: '${i + 1}',
        title: 'Episode ${i + 1}: ${_episodeTitles[i % _episodeTitles.length]}',
        titleVi: 'Tập ${i + 1}: ${_episodeTitlesVi[i % _episodeTitlesVi.length]}',
        durationSeconds: 600 + (i * 30),
        transcript: _sampleTranscript,
      ),
    );
  }

  Future<List<Audiobook>> getAudiobooks() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockAudiobooks;
  }

  Future<List<Dictation>> getDictations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockDictations;
  }

  Future<List<DictationSentence>> getDictationSentences(String dictationId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.generate(
      10,
      (i) => DictationSentence(
        id: '$dictationId-sentence-$i',
        dictationId: dictationId,
        sentence: _dictationSentences[i],
        blanks: [''],
      ),
    );
  }

  static const _episodeTitles = [
    'At the Supermarket',
    'At the Restaurant',
    'At the Train Station',
    'At the Doctor',
    'At the Bank',
    'Job Interview',
    'Making Friends',
    'Weekend Plans',
    'Weather Talk',
    'Birthday Party',
  ];

  static const _episodeTitlesVi = [
    'Ở Siêu thị',
    'Ở Nhà hàng',
    'Ở Nhà ga',
    'Ở Bác sĩ',
    'Ở Ngân hàng',
    'Phỏng vấn xin việc',
    'Kết bạn',
    'Kế hoạch cuối tuần',
    'Nói về thời tiết',
    'Tiệc sinh nhật',
  ];

  static const _sampleTranscript = '''
Guten Tag! Willkommen bei Easy German.

Heute sprechen wir über das Thema: Im Restaurant.

- Guten Abend, ich möchte einen Tisch reservieren.
- Für wie viele Personen?
- Für zwei Personen, bitte.
- Möchten Sie drinnen oder draußen sitzen?
- Draußen wäre schön, wenn möglich.

Die Kellnerin kommt an den Tisch.
- Guten Abend, haben Sie schon gewählt?
- Ja, ich nehme das Schnitzel und eine Salat.
- Und zu trinken?
- Ein Glas Rotwein, bitte.

Das Essen war sehr lecker!
''';

  static const _dictationSentences = [
    'Ich ___ ein Buch.',
    'Das ist ___ Hund.',
    'Er ___ nach Hause.',
    'Sie ___ eine Lehrerin.',
    'Wir ___ in Berlin.',
    'Die Kinder ___ in der Schule.',
    'Ich ___ Kaffee trinken.',
    'Das ___ ein Auto.',
    'Er ___ kein Geld.',
    'Sie ___ gestern angekommen.',
  ];
}
