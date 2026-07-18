import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_tokens.dart';
import 'package:deutschtiger/widgets/common/async_state_views.dart';
import 'package:deutschtiger/data/youtube/youtube_video.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/view_models/youtube/youtube_provider.dart';
import 'widgets/media_header_card.dart';
import 'widgets/video_status_filter_bar.dart';
import 'widgets/video_pagination_bar.dart';
import 'widgets/video_collection_card.dart';
import 'widgets/youtube_tracker_widgets.dart';
import 'youtube_url_utils.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

const _pageSize = 20;

/// Tracker YouTube cá nhân — web parity `YouTubeTrackerPage`
/// (`VideoCollectionLayout` + continue-watching + popular + add-form + thumbnail
/// grid + status filter + pagination). Web tracker page has no stats row — the
/// Flutter-only `_StatsRow` was removed per plan §Xóa.
class YouTubeTrackerScreen extends ConsumerStatefulWidget {
  const YouTubeTrackerScreen({super.key});

  @override
  ConsumerState<YouTubeTrackerScreen> createState() => _YouTubeTrackerScreenState();
}

class _YouTubeTrackerScreenState extends ConsumerState<YouTubeTrackerScreen> {
  final _urlController = TextEditingController();
  MediaVideoStatus _filter = MediaVideoStatus.all;
  int _page = 1;
  bool _adding = false;
  String? _addError;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _addVideo() async {
    final l10n = AppLocalizations.of(context);
    final input = _urlController.text.trim();
    final videoId = extractYouTubeVideoId(input);
    if (videoId == null) {
      setState(() => _addError = l10n.youtubeInvalidUrl);
      return;
    }
    setState(() {
      _adding = true;
      _addError = null;
    });
    try {
      await ref
          .read(youtubeRepositoryProvider)
          .addVideo(youtubeUrl: 'https://www.youtube.com/watch?v=$videoId', videoId: videoId);
      _urlController.clear();
      ref.invalidate(pendingVideosProvider);
      ref.invalidate(completedVideosProvider);
    } catch (_) {
      setState(() => _addError = l10n.youtubeAddVideoError);
    } finally {
      if (mounted) setState(() => _adding = false);
    }
  }

  Future<void> _deleteVideo(YouTubeVideo video) async {
    if (!video.isPersisted) return;
    try {
      await ref.read(youtubeRepositoryProvider).deleteVideo(video.id);
      ref.invalidate(pendingVideosProvider);
      ref.invalidate(completedVideosProvider);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).youtubeDeleteVideoError)),
        );
      }
    }
  }

  void _openVideo(YouTubeVideo video) {
    context.push('/listening/youtube/watch', extra: (videoId: video.videoId, title: video.title));
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final pendingAsync = ref.watch(pendingVideosProvider);
    final completedAsync = ref.watch(completedVideosProvider);
    final popularAsync = ref.watch(popularVideosProvider);

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(pendingVideosProvider);
            ref.invalidate(completedVideosProvider);
            ref.invalidate(popularVideosProvider);
          },
          child: pendingAsync.when(
            loading: () => const LoadingView(),
            error: (e, _) => ErrorView(
              message: l10n.youtubeLoadListError,
              onRetry: () => ref.invalidate(pendingVideosProvider),
            ),
            data: (pending) {
              final completed = completedAsync.value ?? const [];
              final all = [...pending, ...completed];
              final filtered = switch (_filter) {
                MediaVideoStatus.all => all,
                MediaVideoStatus.pending => pending,
                MediaVideoStatus.completed => completed,
              };
              final totalPages = (filtered.length / _pageSize).ceil().clamp(1, 999999);
              final page = _page.clamp(1, totalPages);
              final paged = filtered.skip((page - 1) * _pageSize).take(_pageSize).toList();

              // "Đang xem tiếp" — video đang học gần nhất theo thời gian xem
              // gần đây nhất (proxy hợp lý cho ContinueWatching, tái dùng dữ
              // liệu sẵn có, không dựng dữ liệu giả mới).
              final continueWatching = [
                ...completed,
              ]..sort((a, b) => (b.watchedAt ?? DateTime(0)).compareTo(a.watchedAt ?? DateTime(0)));

              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                children: [
                  MediaBreadcrumb(items: [(l10n.listeningPageTitle, '/listening'), ('YouTube', null)]),
                  const SizedBox(height: 10),
                  MediaHeaderCard(
                    icon: PhosphorIcons.monitorPlay,
                    title: 'YouTube',
                    subtitle: l10n.listeningSourceVideoCount(all.length),
                    accentColor: const Color(0xFFEF4444),
                    onBack: () => context.pop(),
                  ),
                  const SizedBox(height: 16),
                  if (continueWatching.isNotEmpty)
                    ContinueWatchingStrip(
                      videos: continueWatching.take(5).toList(),
                      onTap: _openVideo,
                    ),
                  popularAsync.whenOrNull(
                        data: (popular) => popular.isEmpty
                            ? const SizedBox.shrink()
                            : PopularVideosSection(
                                videos: popular,
                                onTap: (v) => context.push(
                                  '/listening/youtube/watch',
                                  extra: (videoId: v.videoId, title: v.title),
                                ),
                              ),
                      ) ??
                      const SizedBox.shrink(),
                  const SizedBox(height: 12),
                  AddVideoForm(
                    controller: _urlController,
                    adding: _adding,
                    error: _addError,
                    onSubmit: _addVideo,
                  ),
                  const SizedBox(height: 16),
                  if (all.isNotEmpty)
                    VideoStatusFilterBar(
                      value: _filter,
                      onChanged: (v) => setState(() {
                        _filter = v;
                        _page = 1;
                      }),
                      counts: {
                        MediaVideoStatus.all: all.length,
                        MediaVideoStatus.pending: pending.length,
                        MediaVideoStatus.completed: completed.length,
                      },
                    ),
                  const SizedBox(height: 12),
                  if (filtered.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Center(
                        child: Text(l10n.youtubeEmptyState, textAlign: TextAlign.center),
                      ),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: paged.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.82,
                      ),
                      itemBuilder: (context, i) {
                        final v = paged[i];
                        return VideoCollectionCard(
                          thumbnailUrl:
                              v.thumbnailUrl ??
                              'https://img.youtube.com/vi/${v.videoId}/mqdefault.jpg',
                          title: v.title ?? l10n.youtubeUntitledVideo,
                          status: v.isCompleted
                              ? MediaVideoStatus.completed
                              : MediaVideoStatus.pending,
                          subtitle: v.isCompleted && v.watchCount > 0
                              ? l10n.youtubeWatchCount(v.watchCount)
                              : null,
                          onTap: () => _openVideo(v),
                          onDelete: () => _deleteVideo(v),
                        );
                      },
                    ),
                  VideoPaginationBar(
                    page: page,
                    totalPages: totalPages,
                    onChanged: (p) => setState(() => _page = p),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
