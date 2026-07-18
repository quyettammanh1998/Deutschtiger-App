import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../features/writing/data/official_writing_topic_repository.dart';
import '../../../features/writing/domain/writing_offering.dart';
import '../../../l10n/app_localizations.dart';
import '../../../view_models/exam/exam_ecosystem_providers.dart';
import '../../../widgets/common/async_state_views.dart';
import '../widgets/community/community_topic_card.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// `writing-level-topics` (`/exam/:providerLevel/writing`) — generic official
/// topic list + community section for a provider/level offering not covered
/// by the Goethe B1 dedicated feature. Web parity `WritingLevelTopicsPage`.
class WritingLevelTopicsPage extends ConsumerWidget {
  const WritingLevelTopicsPage({super.key, required this.providerLevel});

  final String providerLevel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final offering = findWritingOffering(providerLevel);

    if (offering == null) {
      return Scaffold(
        backgroundColor: tokens.background,
        body: SafeArea(child: _NotFound(l10n: l10n)),
      );
    }
    if (offering.providerLevel == 'goethe-b1') {
      // Goethe B1 has its own dedicated writing feature.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go('/exam/goethe-b1/writing');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final topicsAsync = ref.watch(
      officialWritingTopicsProvider((provider: offering.provider, level: offering.level)),
    );
    final communityFilter = CommunityExamFilter(
      provider: offering.provider,
      level: offering.level,
      skill: 'writing',
    );
    final communityAsync = ref.watch(communityExamListProvider(communityFilter));

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                IconButton(icon: const Icon(PhosphorIcons.arrowLeft), onPressed: () => context.pop()),
                Expanded(
                  child: Text(
                    l10n.writingLevelTitle(offering.label),
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: tokens.foreground),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            topicsAsync.when(
              loading: () => const LoadingView(),
              error: (_, _) => const SizedBox.shrink(),
              data: (topics) {
                if (topics.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Column(
                      children: [
                        const Text('✍️', style: TextStyle(fontSize: 40)),
                        const SizedBox(height: 10),
                        Text(
                          l10n.writingLevelEmptyTitle,
                          style: TextStyle(fontWeight: FontWeight.w700, color: tokens.foreground),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.writingLevelEmptyDesc(offering.label),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                        ),
                      ],
                    ),
                  );
                }
                return Column(
                  children: [
                    for (final t in topics)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => context.push('/exam/$providerLevel/writing/${t.slug}/practice'),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: tokens.card,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: tokens.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    if (t.teil > 0)
                                      Padding(
                                        padding: const EdgeInsets.only(right: 6),
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: tokens.primary.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(999),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            child: Text(
                                              l10n.writingTeilLabel(t.teil),
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: tokens.primary,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    Expanded(
                                      child: Text(
                                        t.titleDe,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: tokens.foreground,
                                        ),
                                      ),
                                    ),
                                    if (t.isPremium) const Text('🔒', style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                                if ((t.titleVi ?? '').isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    t.titleVi!,
                                    style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.writingLevelCommunitySectionTitle,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: tokens.foreground),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: () => context.push(
                    '/luyen-viet/tu-nhap',
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFF97316), Color(0xFFEA580C)]),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      l10n.writingLevelContributeButton,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            communityAsync.when(
              loading: () => const LoadingView(),
              error: (_, _) => const SizedBox.shrink(),
              data: (topics) => topics.isEmpty
                  ? Text(
                      l10n.writingLevelCommunityEmpty,
                      style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                    )
                  : Column(
                      children: [
                        for (final t in topics)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: CommunityTopicCard(topic: t),
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotFound extends StatelessWidget {
  const _NotFound({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(icon: const Icon(PhosphorIcons.arrowLeft), onPressed: () => context.pop()),
            ],
          ),
          Text(l10n.writingLevelNotFound),
        ],
      ),
    );
  }
}
