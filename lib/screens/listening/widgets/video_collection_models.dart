import 'package:flutter/foundation.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';

/// Trạng thái xem 1 video trong bộ sưu tập (Easy German level, Sprechen
/// B1/B2). Web parity: `components/listening/video-status-filter.tsx`.
enum VideoWatchStatus { newVideo, pending, completed }

/// 1 item hiển thị trong `VideoCollectionLayout` — model chung thay cho
/// generic `<V>` của web (đơn giản hoá phía Flutter, đủ cho mọi bộ sưu tập
/// trong scope wave này: id + tiêu đề + badge góc dưới phải + phụ đề).
@immutable
class VideoCollectionItem {
  const VideoCollectionItem({
    required this.videoId,
    required this.title,
    this.badge = '',
    this.subtitle = '',
  });

  final String videoId;
  final String title;
  final String badge;
  final String subtitle;
}

/// 1 tab trong `VideoCollectionLayout` (vd. Sprechen B1 "Teil 1"/"Teil 2").
@immutable
class VideoCollectionTab {
  const VideoCollectionTab({
    required this.key,
    required this.label,
    required this.videos,
    this.subtitle,
  });

  final String key;
  final String label;
  final String? subtitle;
  final List<VideoCollectionItem> videos;
}

/// Bộ lọc trạng thái mặc định — web `DEFAULT_STATUS_FILTERS`.
enum VideoStatusFilterOption { all, newVideo, pending, completed }

extension VideoStatusFilterOptionX on VideoStatusFilterOption {
  /// Nhãn hiển thị cho chip lọc trạng thái — đi qua ARB (vi/en/de).
  String label(AppLocalizations l10n) => switch (this) {
        VideoStatusFilterOption.all => l10n.allFilters,
        VideoStatusFilterOption.newVideo => l10n.videoCollectionStatusNew,
        VideoStatusFilterOption.pending => l10n.statsMasteryLearning,
        VideoStatusFilterOption.completed => l10n.videoCollectionWatched,
      };
}
