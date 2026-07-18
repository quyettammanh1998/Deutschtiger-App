import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../view_models/exam/exam_ecosystem_providers.dart';
import '../../../widgets/common/async_state_views.dart';
import '../widgets/community/community_topic_card.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// `goethe-b1-community-writing-list` — web parity
/// `goethe-b1-community-writing-list-page.tsx`: header + community topics
/// scoped to `provider=goethe level=b1 skill=writing teil={teil}`.
///
/// Fully reuses the generic community-exam read stack built for P8
/// (`communityExamListProvider`/`CommunityTopicCard`/`CommunityExamDetailScreen`)
/// — no new backend surface. Web's `CommunityWritingList` component adds
/// contributor/vote sort tabs and an in-place topic detail preview; this
/// screen instead reuses the existing generic detail screen navigation
/// (`CommunityTopicCard` already pushes `/exam/community/{id}`) —
/// documented deviation, sort-tab UI is a smaller follow-up, not a missing
/// data path.
class GoetheB1CommunityWritingListPage extends ConsumerWidget {
  const GoetheB1CommunityWritingListPage({super.key, required this.teil});

  final int teil;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final filter = CommunityExamFilter(provider: 'goethe', skill: 'writing', teil: teil);
    final topicsAsync = ref.watch(communityExamListProvider(filter));

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                IconButton(icon: const Icon(PhosphorIcons.arrowLeft), onPressed: () => context.pop()),
                const SizedBox(width: 4),
                Text(
                  l10n.writingCommunityListTitle(teil),
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: tokens.foreground),
                ),
              ],
            ),
            const SizedBox(height: 16),
            topicsAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: LoadingView(),
              ),
              error: (_, _) => ErrorView(
                message: l10n.couldNotLoadData,
                onRetry: () => ref.invalidate(communityExamListProvider(filter)),
              ),
              data: (topics) {
                if (topics.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text(
                        l10n.communityExamsEmpty,
                        style: TextStyle(color: tokens.mutedForeground),
                      ),
                    ),
                  );
                }
                return Column(
                  children: [
                    for (final topic in topics) ...[
                      CommunityTopicCard(topic: topic),
                      const SizedBox(height: 8),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
