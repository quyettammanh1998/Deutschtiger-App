import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../features/premium/domain/premium_providers.dart';
import '../../../features/writing/domain/goethe_b1_writing_access.dart';
import '../../../features/writing/domain/goethe_b1_writing_manifest.dart';
import '../../../features/writing/domain/goethe_b1_writing_topic_summary.dart';
import '../../../features/writing/data/goethe_b1_writing_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/common/async_state_views.dart';
import 'widgets/topic_list/community_folder_card.dart';
import 'widgets/topic_list/leaderboard_card.dart';
import 'widgets/topic_list/topic_row.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Goethe B1 writing topic list — web parity
/// `goethe-b1-writing-topic-list-page.tsx` (`/exams/goethe-b1/writing/:teilNum`):
/// search bar, community folder card, topic rows (star/difficulty/HOT/
/// Premium), sidebar leaderboard, free-limit banner.
///
/// DEVIATION: web additionally merges in "official DB" topics
/// (`useOfficialWritingTopics` + `officialTopicService`) — that's a separate,
/// not-yet-ported backend surface in this app (no Flutter
/// `official-topic-service` equivalent exists anywhere in the codebase; see
/// phase report). This screen reads only the legacy `teil/{n}` manifest
/// endpoint, matching what W1 already established as "Live". "Nhóm theo chủ
/// đề" (grouped-by-cluster toggle) is also omitted — frequency-sort only —
/// documented follow-up.
class GoetheB1WritingTopicListPage extends ConsumerStatefulWidget {
  const GoetheB1WritingTopicListPage({super.key, required this.teil});

  final int teil;

  @override
  ConsumerState<GoetheB1WritingTopicListPage> createState() =>
      _GoetheB1WritingTopicListPageState();
}

class _GoetheB1WritingTopicListPageState
    extends ConsumerState<GoetheB1WritingTopicListPage> {
  final _searchController = TextEditingController();
  String _search = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final teilAsync = ref.watch(goetheB1WritingTeilProvider(widget.teil));
    final resultsAsync = ref.watch(goetheB1WritingTeilResultsProvider(widget.teil));
    final isPremium = ref.watch(premiumProvider).valueOrNull ?? false;

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: teilAsync.when(
          loading: () => const LoadingView(),
          error: (_, _) => ErrorView(
            message: l10n.couldNotLoadData,
            onRetry: () => ref.invalidate(goetheB1WritingTeilProvider(widget.teil)),
          ),
          data: (teilData) => _buildBody(
            context,
            tokens,
            l10n,
            teilData,
            resultsAsync.valueOrNull ?? const [],
            isPremium,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppTokens tokens,
    AppLocalizations l10n,
    GoetheB1WritingTeilData teilData,
    List<GoetheB1WritingResult> completedResults,
    bool hasFullAccess,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final completedSlugs = completedResults.map((r) => r.slug).toSet();
    final introTopic = teilData.topics.where((t) => t.isIntro).isEmpty
        ? null
        : teilData.topics.firstWhere((t) => t.isIntro);
    final regularTopics = sortedRegularWritingTopics(teilData.topics);
    final hasLockedTopics =
        !hasFullAccess && regularTopics.length > kFreeWritingTopicLimitPerTeil;

    final query = _search.trim().toLowerCase();
    final filtered = query.isEmpty
        ? regularTopics
        : regularTopics
            .where((t) =>
                t.titleDe.toLowerCase().contains(query) ||
                t.titleVi.toLowerCase().contains(query) ||
                t.slug.replaceAll('-', ' ').contains(query))
            .toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: l10n.writingTeilLabel(widget.teil),
                          style: const TextStyle(color: Color(0xFFF97316), fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ' — ${teilData.titleVi}'),
                      ],
                    ),
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: tokens.foreground),
                  ),
                  Text(
                    query.isNotEmpty
                        ? l10n.writingTopicCountFiltered(filtered.length, regularTopics.length)
                        : l10n.writingTopicCount(regularTopics.length),
                    style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _SearchBar(
          controller: _searchController,
          onChanged: (v) => setState(() => _search = v),
        ),
        const SizedBox(height: 10),
        _SprintPill(l10n: l10n),
        const SizedBox(height: 10),
        WritingCommunityFolderCard(
          teil: widget.teil,
          onTap: () => context.push('/exam/goethe-b1/writing/community/${widget.teil}'),
        ),
        const SizedBox(height: 12),
        DecoratedBox(
          decoration: BoxDecoration(
            color: tokens.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: tokens.border),
          ),
          child: Column(
            children: [
              if (introTopic != null && query.isEmpty)
                InkWell(
                  onTap: () => context.push('/exam/goethe-b1/writing/${widget.teil}/intro'),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: Row(
                      children: [
                        const Text('👋', style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(introTopic.titleDe,
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: tokens.foreground)),
                        ),
                      ],
                    ),
                  ),
                ),
              if (query.isNotEmpty && filtered.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Column(
                    children: [
                      Text(l10n.writingNoResultsTitle,
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: tokens.foreground)),
                      const SizedBox(height: 4),
                      Text(l10n.writingNoResultsHint,
                          style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
                    ],
                  ),
                )
              else
                for (var i = 0; i < filtered.length; i++)
                  Column(
                    children: [
                      if (i > 0 || introTopic != null) Divider(height: 1, color: tokens.border),
                      TopicRow(
                        topic: filtered[i],
                        position: regularTopics.indexOf(filtered[i]) + 1,
                        isCompleted: completedSlugs.contains(filtered[i].slug),
                        isLocked: isWritingTopicLocked(
                          filtered[i],
                          teilData.topics,
                          hasFullAccess: hasFullAccess,
                        ),
                        onTap: () => context.push(
                          '/exam/goethe-b1/writing/${widget.teil}/${filtered[i].slug}',
                        ),
                        onUpgrade: () => context.push('/premium?highlight=lifetime'),
                      ),
                    ],
                  ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        WritingLeaderboardCard(teil: widget.teil, totalTopics: regularTopics.length),
        if (hasLockedTopics) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0x33F59E0B) : const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.writingFreeLimitTitle(widget.teil),
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isDark ? const Color(0xFFFCD34D) : const Color(0xFF78350F)),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.writingFreeLimitDesc,
                  style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFFFCD34D) : const Color(0xFF92400E), height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.onChanged});
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tokens.border),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(PhosphorIcons.magnifyingGlass, size: 18, color: tokens.mutedForeground),
          hintText: l10n.writingSearchHint,
          hintStyle: TextStyle(fontSize: 13, color: tokens.mutedForeground),
        ),
      ),
    );
  }
}

/// "Sprint 10h" entry pill — navigates to the Sprint SR mode picker
/// (`plan W4` scope, not built yet). Shown per spec but inert with a
/// "coming soon" snackbar until W4 lands — documented deviation, matches
/// W1's precedent of shipping a visible-but-unwired link rather than hiding
/// the UI element (`goetheB1WritingTeilPickPage` "Bài của tôi →").
class _SprintPill extends StatelessWidget {
  const _SprintPill({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.writingSprintComingSoon)),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFF97316), Color(0xFFEA580C)]),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('⚡', style: TextStyle(fontSize: 12)),
            const SizedBox(width: 6),
            Text(l10n.writingSprintPill,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
