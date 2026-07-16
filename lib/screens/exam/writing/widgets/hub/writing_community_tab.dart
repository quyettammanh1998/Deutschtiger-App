import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../view_models/exam/exam_ecosystem_providers.dart';
import '../../../../../widgets/common/async_state_views.dart';
import '../../../widgets/community/community_topic_card.dart';

/// "Cộng đồng" tab — web parity `WritingCommunityTab`: 3 Teil sections
/// (Goethe B1 writing community topics, grouped), footer link to the full
/// community list. Reuses P8's `communityExamListProvider`/
/// `CommunityTopicCard` — no new backend surface.
class WritingCommunityTab extends ConsumerWidget {
  const WritingCommunityTab({super.key});

  static const _teile = [1, 2, 3];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final teilLabels = {
      1: l10n.writingHubCommunityTeil1,
      2: l10n.writingHubCommunityTeil2,
      3: l10n.writingHubCommunityTeil3,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.writingHubCommunityIntro,
          style: TextStyle(fontSize: 13, color: tokens.mutedForeground),
        ),
        const SizedBox(height: 16),
        for (final teil in _teile) ...[
          Text(
            teilLabels[teil]!,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
              color: tokens.mutedForeground,
            ),
          ),
          const SizedBox(height: 6),
          _TeilSection(teil: teil),
          const SizedBox(height: 16),
        ],
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.push('/exam/community'),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: tokens.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: tokens.border),
            ),
            child: Text(
              l10n.writingHubCommunityViewAll,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: tokens.foreground),
            ),
          ),
        ),
      ],
    );
  }
}

class _TeilSection extends ConsumerWidget {
  const _TeilSection({required this.teil});
  final int teil;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = CommunityExamFilter(provider: 'goethe', skill: 'writing', teil: teil);
    final topicsAsync = ref.watch(communityExamListProvider(filter));

    return topicsAsync.when(
      loading: () => const SizedBox(height: 56, child: LoadingView()),
      error: (_, _) => const SizedBox.shrink(),
      data: (topics) {
        if (topics.isEmpty) return const SizedBox.shrink();
        final shown = topics.take(3).toList();
        return Column(
          children: [
            for (final t in shown)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: CommunityTopicCard(topic: t),
              ),
          ],
        );
      },
    );
  }
}
