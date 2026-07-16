import 'package:flutter/material.dart';
import 'package:deutschtiger/core/theme/app_tokens.dart';

import 'video_collection_card.dart';
import 'video_collection_layout_chrome.dart';
import 'video_collection_models.dart';
import 'video_pagination_bar.dart';
import 'video_progress_card.dart';
import 'video_status_filter_bar.dart';

/// Layout dùng chung cho các trang "bộ sưu tập video" (Easy German level,
/// Sprechen B1/B2): breadcrumb → header card → progress card → search →
/// tabs → status filter → danh sách 1 cột → pagination → sidebar (leaderboard)
/// stack dưới list trên mobile. Web parity:
/// `components/listening/video-collection-layout.tsx`. Chrome con (header,
/// search, tab bar, empty/error) tách ra `video_collection_layout_chrome.dart`.
class VideoCollectionLayout extends StatefulWidget {
  const VideoCollectionLayout({
    super.key,
    required this.breadcrumbLabel,
    required this.headerIcon,
    required this.headerTitle,
    required this.headerSubtitle,
    required this.headerAccentColor,
    required this.onVideoTap,
    this.videos = const [],
    this.tabs,
    this.progress,
    this.searchHint,
    this.statusOf,
    this.sidebar,
    this.loading = false,
    this.errorText,
    this.pageSize = 12,
  }) : assert(videos.length == 0 || tabs == null,
            'Chỉ truyền videos HOẶC tabs, không cả hai.');

  final String breadcrumbLabel;
  final IconData headerIcon;
  final String headerTitle;
  final String headerSubtitle;
  final Color headerAccentColor;
  final void Function(VideoCollectionItem item) onVideoTap;

  final List<VideoCollectionItem> videos;
  final List<VideoCollectionTab>? tabs;
  final ({int completedCount, int totalVideos, int pendingCount, int totalRewatch})? progress;
  final String? searchHint;
  final VideoWatchStatus Function(String videoId)? statusOf;
  final Widget? sidebar;
  final bool loading;
  final String? errorText;
  final int pageSize;

  @override
  State<VideoCollectionLayout> createState() => _VideoCollectionLayoutState();
}

class _VideoCollectionLayoutState extends State<VideoCollectionLayout> {
  int _page = 1;
  String _query = '';
  late String _activeTabKey = widget.tabs?.isNotEmpty == true ? widget.tabs!.first.key : '';
  VideoStatusFilterOption _statusValue = VideoStatusFilterOption.all;

  List<VideoCollectionItem> get _sourceVideos {
    if (widget.tabs == null) return widget.videos;
    return widget.tabs!
        .firstWhere((t) => t.key == _activeTabKey, orElse: () => widget.tabs!.first)
        .videos;
  }

  VideoWatchStatus _statusFor(String videoId) =>
      widget.statusOf?.call(videoId) ?? VideoWatchStatus.newVideo;

  static VideoStatusFilterOption _filterFor(VideoWatchStatus s) => switch (s) {
        VideoWatchStatus.newVideo => VideoStatusFilterOption.newVideo,
        VideoWatchStatus.pending => VideoStatusFilterOption.pending,
        VideoWatchStatus.completed => VideoStatusFilterOption.completed,
      };

  List<VideoCollectionItem> get _filtered {
    var list = _sourceVideos;
    if (widget.statusOf != null && _statusValue != VideoStatusFilterOption.all) {
      list = list.where((v) => _filterFor(_statusFor(v.videoId)) == _statusValue).toList();
    }
    final q = _query.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list
          .where((v) => v.title.toLowerCase().contains(q) || v.videoId.toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  Map<VideoStatusFilterOption, int> get _statusCounts {
    final scope = _sourceVideos;
    final counts = {for (final o in VideoStatusFilterOption.values) o: 0};
    counts[VideoStatusFilterOption.all] = scope.length;
    for (final v in scope) {
      final key = _filterFor(_statusFor(v.videoId));
      counts[key] = (counts[key] ?? 0) + 1;
    }
    return counts;
  }

  void _resetPage() => setState(() => _page = 1);

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final filtered = _filtered;
    final totalPages = (filtered.length / widget.pageSize).ceil().clamp(1, 1 << 30);
    final page = _page.clamp(1, totalPages);
    final paginated = filtered.skip((page - 1) * widget.pageSize).take(widget.pageSize).toList();

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            VideoCollectionBreadcrumb(label: widget.breadcrumbLabel, tokens: tokens),
            const SizedBox(height: 10),
            VideoCollectionHeaderCard(
              icon: widget.headerIcon,
              title: widget.headerTitle,
              subtitle: widget.headerSubtitle,
              accentColor: widget.headerAccentColor,
              tokens: tokens,
            ),
            const SizedBox(height: 12),
            if (widget.loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (widget.errorText != null)
              VideoCollectionErrorBox(text: widget.errorText!, tokens: tokens)
            else ...[
              if (widget.progress != null) ...[
                VideoProgressCard(
                  completedCount: widget.progress!.completedCount,
                  totalVideos: widget.progress!.totalVideos,
                  pendingCount: widget.progress!.pendingCount,
                  totalRewatch: widget.progress!.totalRewatch,
                ),
                const SizedBox(height: 12),
              ],
              if (widget.searchHint != null) ...[
                VideoCollectionSearchField(
                  hint: widget.searchHint!,
                  tokens: tokens,
                  onChanged: (v) {
                    setState(() => _query = v);
                    _resetPage();
                  },
                ),
                const SizedBox(height: 12),
              ],
              if (widget.tabs != null && widget.tabs!.length > 1) ...[
                VideoCollectionTabBar(
                  tabs: widget.tabs!,
                  activeKey: _activeTabKey,
                  onChanged: (key) {
                    setState(() => _activeTabKey = key);
                    _resetPage();
                  },
                  tokens: tokens,
                ),
                const SizedBox(height: 12),
              ],
              if (widget.statusOf != null) ...[
                VideoStatusFilterBar(
                  value: _statusValue,
                  counts: _statusCounts,
                  onChanged: (v) {
                    setState(() => _statusValue = v);
                    _resetPage();
                  },
                ),
                const SizedBox(height: 12),
              ],
              if (filtered.isEmpty)
                VideoCollectionEmptyBox(tokens: tokens)
              else ...[
                for (final item in paginated) ...[
                  VideoCollectionCard(
                    item: item,
                    status: _statusFor(item.videoId),
                    onTap: () => widget.onVideoTap(item),
                  ),
                  const SizedBox(height: 10),
                ],
                VideoPaginationBar(
                  page: page,
                  totalPages: totalPages,
                  onChanged: (p) => setState(() => _page = p),
                ),
              ],
              if (widget.sidebar != null) ...[
                const SizedBox(height: 16),
                widget.sidebar!,
              ],
            ],
          ],
        ),
      ),
    );
  }
}
