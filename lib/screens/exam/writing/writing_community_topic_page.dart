import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../features/writing/data/community_writing_write_repository.dart';
import '../../../features/writing/domain/writing_offering.dart';
import '../../../features/writing/presentation/widgets/writing_comment_section.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/common/async_state_views.dart';
import 'widgets/community_topic/community_add_version_sheet.dart';
import 'widgets/community_topic/community_version_card.dart';
import 'widgets/community_topic/community_version_selector.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// `writing-community-topic`
/// (`/exam/:providerLevel/writing/community/:teil/:slug`) — canonical
/// community writing topic + version selector + comments. Web parity
/// `WritingCommunityTopicPage`.
class WritingCommunityTopicPage extends ConsumerStatefulWidget {
  const WritingCommunityTopicPage({
    super.key,
    required this.providerLevel,
    required this.teil,
    required this.slug,
  });

  final String providerLevel;
  final int teil;
  final String slug;

  @override
  ConsumerState<WritingCommunityTopicPage> createState() =>
      _WritingCommunityTopicPageState();
}

class _WritingCommunityTopicPageState
    extends ConsumerState<WritingCommunityTopicPage> {
  int? _selectedIndex;
  bool _voting = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final offering = findWritingOffering(widget.providerLevel);

    if (offering == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go('/luyen-viet');
      });
      return const Scaffold(body: SizedBox.shrink());
    }

    final scope = (
      provider: offering.provider,
      level: offering.level,
      teil: widget.teil,
      slug: widget.slug,
    );
    final async = ref.watch(communityWritingTopicProvider(scope));

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: async.when(
          loading: () => const LoadingView(),
          error: (_, _) =>
              _NotFoundView(l10n: l10n, onBack: () => context.pop()),
          data: (canonical) {
            final versions = canonical.versions ?? [canonical];
            final defaultIndex = () {
              final idx = versions.indexWhere(
                (v) =>
                    v.isVerified == true || v.id == canonical.defaultVersionId,
              );
              return idx >= 0 ? idx : 0;
            }();
            final effectiveIndex =
                (_selectedIndex != null && _selectedIndex! < versions.length)
                ? _selectedIndex!
                : defaultIndex;
            final selected = versions.isEmpty ? null : versions[effectiveIndex];

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(PhosphorIcons.arrowLeft),
                      onPressed: () => context.pop(),
                    ),
                    Expanded(
                      child: Text(
                        canonical.titleDe.isNotEmpty
                            ? canonical.titleDe
                            : l10n.writingCommunityTopicFallbackTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: tokens.foreground,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                CommunityVersionSelector(
                  versions: versions,
                  selectedIndex: effectiveIndex,
                  onChange: (i) => setState(() => _selectedIndex = i),
                ),
                if (versions.length > 1) const SizedBox(height: 10),
                if (selected != null)
                  CommunityVersionCard(
                    version: selected,
                    isVoting: _voting,
                    onVote: () async {
                      setState(() => _voting = true);
                      final repo = ref.read(
                        communityWritingWriteRepositoryProvider,
                      );
                      try {
                        if (selected.isVoted == true) {
                          await repo.unvote(selected.id);
                        } else {
                          await repo.vote(selected.id);
                        }
                        ref.invalidate(communityWritingTopicProvider(scope));
                      } catch (_) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.writingCommunityVoteError),
                            ),
                          );
                        }
                      } finally {
                        if (mounted) setState(() => _voting = false);
                      }
                    },
                    onAddVersion: () async {
                      final saved = await showModalBottomSheet<bool>(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => CommunityAddVersionSheet(
                          provider: offering.provider,
                          level: offering.level,
                          teil: widget.teil,
                          canonicalId: canonical.id,
                        ),
                      );
                      if (saved == true) {
                        ref.invalidate(communityWritingTopicProvider(scope));
                      }
                    },
                    onReport: () async {
                      final repo = ref.read(
                        communityWritingWriteRepositoryProvider,
                      );
                      try {
                        await repo.report(
                          selected.id,
                          l10n.writingCommunityReportReason,
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.writingCommunityReportSent),
                            ),
                          );
                        }
                      } catch (_) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.writingCommunityVoteError),
                            ),
                          );
                        }
                      }
                    },
                  ),
                const SizedBox(height: 16),
                WritingCommentSection(targetId: canonical.id),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _NotFoundView extends StatelessWidget {
  const _NotFoundView({required this.l10n, required this.onBack});
  final AppLocalizations l10n;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🔍', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 10),
            Text(
              l10n.writingCommunityNotFoundTitle,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: tokens.foreground,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.writingCommunityNotFoundDesc,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onBack,
              child: Text(l10n.writingCommunityBackToList),
            ),
          ],
        ),
      ),
    );
  }
}
