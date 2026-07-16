import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../core/theme/app_tokens.dart';
import '../../data/speech/conversation_display.dart';
import '../../data/speech/conversation_models.dart';
import '../../l10n/app_localizations.dart';
import '../../view_models/speech/conversation_provider.dart';
import 'widgets/conversation/conversation_filter_pills.dart';
import 'widgets/conversation/conversation_hero.dart';
import 'widgets/conversation/conversation_history_tab.dart';
import 'widgets/conversation/conversation_scenario_grid.dart';

/// `/conversation` — Hội thoại (AI) hub, bottom-nav tab 4 (web parity).
/// Tabs: Kịch bản (search-first hero + library filters + scenario grid) /
/// Lịch sử luyện tập (saved sessions). Web parity: `conversation-hub-page.tsx`.
class ConversationHubPage extends ConsumerStatefulWidget {
  const ConversationHubPage({super.key});

  @override
  ConsumerState<ConversationHubPage> createState() => _ConversationHubPageState();
}

class _ConversationHubPageState extends ConsumerState<ConversationHubPage> {
  final _topicController = TextEditingController();
  String _level = 'B1';
  String _categoryFilter = 'all';
  String _levelFilter = 'all';
  bool _scenariosTab = true;

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  void _startCustom(String topic) {
    final clean = topic.trim();
    if (clean.length < 3) return;
    final slug = buildCustomConversationSlug(clean, _level);
    context.push(
      '/conversation/custom/$slug',
      extra: {'topic': clean, 'level': _level},
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final scenariosAsync = ref.watch(conversationScenariosProvider);
    final quotaAsync = ref.watch(conversationDailyQuotaProvider);

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: tokens.card,
                      border: Border.all(color: tokens.border),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(PhosphorIcons.caretLeft, size: 20),
                      onPressed: () => context.canPop() ? context.pop() : context.go('/home'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.conversationHubTitle, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: tokens.foreground)),
                      Text(l10n.conversationHubSubtitle, style: TextStyle(fontSize: 13, color: tokens.mutedForeground)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: tokens.card,
                  border: Border.all(color: tokens.border),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _HubTabButton(
                        label: l10n.conversationTabScenarios,
                        icon: PhosphorIcons.chatsCircleFill,
                        active: _scenariosTab,
                        onTap: () => setState(() => _scenariosTab = true),
                      ),
                    ),
                    Expanded(
                      child: _HubTabButton(
                        label: l10n.conversationTabHistory,
                        icon: PhosphorIcons.clockCounterClockwise,
                        active: !_scenariosTab,
                        onTap: () => setState(() => _scenariosTab = false),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              if (!_scenariosTab) const ConversationHistoryTab(),
              if (_scenariosTab)
                scenariosAsync.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (err, st) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48),
                    child: Column(
                      children: [
                        Text(l10n.conversationHubLoadError, style: TextStyle(color: tokens.mutedForeground)),
                        const SizedBox(height: 8),
                        FilledButton(
                          onPressed: () => ref.invalidate(conversationScenariosProvider),
                          child: Text(l10n.retry),
                        ),
                      ],
                    ),
                  ),
                  data: (scenarios) => _ScenariosTab(
                    scenarios: scenarios,
                    topicController: _topicController,
                    level: _level,
                    onLevelChanged: (v) => setState(() => _level = v),
                    onSubmit: _startCustom,
                    quota: quotaAsync.valueOrNull,
                    categoryFilter: _categoryFilter,
                    onCategoryChanged: (v) => setState(() => _categoryFilter = v),
                    levelFilter: _levelFilter,
                    onLevelFilterChanged: (v) => setState(() => _levelFilter = v),
                    // Rebuild-only trigger: the grid reads
                    // `topicController.text` directly on every keystroke.
                    onQueryChanged: (_) => setState(() {}),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HubTabButton extends StatelessWidget {
  const _HubTabButton({required this.label, required this.icon, required this.active, required this.onTap});

  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: active ? tokens.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: active ? Colors.white : tokens.mutedForeground),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: active ? Colors.white : tokens.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScenariosTab extends StatelessWidget {
  const _ScenariosTab({
    required this.scenarios,
    required this.topicController,
    required this.level,
    required this.onLevelChanged,
    required this.onSubmit,
    required this.quota,
    required this.categoryFilter,
    required this.onCategoryChanged,
    required this.levelFilter,
    required this.onLevelFilterChanged,
    required this.onQueryChanged,
  });

  final List<ScenarioMeta> scenarios;
  final TextEditingController topicController;
  final String level;
  final ValueChanged<String> onLevelChanged;
  final ValueChanged<String> onSubmit;
  final dynamic quota;
  final String categoryFilter;
  final ValueChanged<String> onCategoryChanged;
  final String levelFilter;
  final ValueChanged<String> onLevelFilterChanged;
  final ValueChanged<String> onQueryChanged;

  @override
  Widget build(BuildContext context) {
    final query = topicController.text.trim().toLowerCase();
    final results = scenarios.where((s) {
      final cat = getScenarioDisplay(s.id).category;
      final matchesCat = categoryFilter == 'all' || cat == categoryFilter;
      final matchesLevel = levelFilter == 'all' || s.level == levelFilter;
      final matchesQuery = query.isEmpty ||
          '${s.titleDe} ${s.titleVi}'.toLowerCase().contains(query);
      return matchesCat && matchesLevel && matchesQuery;
    }).toList();

    final categoryCounts = <String, int>{};
    for (final s in scenarios) {
      final cat = getScenarioDisplay(s.id).category;
      categoryCounts[cat] = (categoryCounts[cat] ?? 0) + 1;
    }
    final presentLevels = conversationLevels
        .where((l) => scenarios.any((s) => s.level == l))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConversationHero(
          controller: topicController,
          level: level,
          onLevelChanged: onLevelChanged,
          onSubmit: onSubmit,
          quota: quota,
          onUpgrade: () => context.push('/premium'),
          onChanged: onQueryChanged,
        ),
        const SizedBox(height: 16),
        ConversationFilterPills(
          categoryFilter: categoryFilter,
          onCategoryChanged: onCategoryChanged,
          levelFilter: levelFilter,
          onLevelChanged: onLevelFilterChanged,
          categoryCounts: categoryCounts,
          presentLevels: presentLevels,
          totalCount: scenarios.length,
          resultCount: results.length,
        ),
        const SizedBox(height: 16),
        ConversationScenarioGrid(
          scenarios: results,
          onTap: (s) => context.push('/conversation/${s.id}'),
          canCreateCustom: query.length >= 3,
          customQuery: topicController.text,
          onCreateCustom: () => onSubmit(topicController.text),
        ),
      ],
    );
  }
}
