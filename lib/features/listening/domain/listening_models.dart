/// Listening models - simplified without Freezed
class Podcast {
  const Podcast({
    required this.id,
    required this.title,
    required this.titleVi,
    this.description,
    this.descriptionVi,
    this.imageUrl,
    required this.source,
    this.feedUrl,
    this.episodes = const [],
  });

  final String id;
  final String title;
  final String titleVi;
  final String? description;
  final String? descriptionVi;
  final String? imageUrl;
  final String source;
  final String? feedUrl;
  final List<PodcastEpisode> episodes;
}

class PodcastEpisode {
  const PodcastEpisode({
    required this.id,
    required this.podcastId,
    required this.title,
    this.titleVi,
    this.description,
    this.audioUrl,
    this.durationSeconds,
    this.publishedAt,
    this.isCompleted = false,
    this.currentPosition,
  });

  final String id;
  final String podcastId;
  final String title;
  final String? titleVi;
  final String? description;
  final String? audioUrl;
  final int? durationSeconds;
  final String? publishedAt;
  final bool isCompleted;
  final int? currentPosition;
}

class ListeningSource {
  const ListeningSource({
    required this.id,
    required this.name,
    this.nameVi,
    this.description,
    this.icon,
    required this.type,
    this.url,
    this.thumbnailUrl,
    this.categories = const [],
  });

  final String id;
  final String name;
  final String? nameVi;
  final String? description;
  final String? icon;
  final String type;
  final String? url;
  final String? thumbnailUrl;
  final List<ListeningCategory> categories;
}

class ListeningCategory {
  const ListeningCategory({
    required this.id,
    required this.name,
    this.nameVi,
    this.level,
    this.items = const [],
  });

  final String id;
  final String name;
  final String? nameVi;
  final String? level;
  final List<ListeningItem> items;
}

class ListeningItem {
  const ListeningItem({
    required this.id,
    required this.title,
    this.titleVi,
    this.description,
    this.videoUrl,
    this.audioUrl,
    this.thumbnailUrl,
    this.duration,
    this.level,
    this.isCompleted = false,
    this.progress,
  });

  final String id;
  final String title;
  final String? titleVi;
  final String? description;
  final String? videoUrl;
  final String? audioUrl;
  final String? thumbnailUrl;
  final String? duration;
  final String? level;
  final bool isCompleted;
  final int? progress;
}

/// Easy German podcast data
class EasyGermanData {
  static const podcasts = [
    Podcast(
      id: 'easy-german',
      title: 'Easy German',
      titleVi: 'Tiếng Đức Dễ Dàng',
      description: 'Learn German with street interviews and cultural topics',
      source: 'youtube',
    ),
    Podcast(
      id: 'sprechen-b1',
      title: 'Sprechen Deutsch B1',
      titleVi: 'Nói Tiếng Đức B1',
      description: 'Practice your German speaking and listening at B1 level',
      source: 'custom',
    ),
  ];
}
