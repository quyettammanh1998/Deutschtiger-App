import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/vocabulary_models.dart';
import '../presentation/vocabulary_provider.dart';
import 'vocabulary_lesson_screen.dart';
import 'vocabulary_word_screen.dart';

/// Vocabulary Screen - mimics web vocabulary-page.tsx
class VocabularyScreen extends ConsumerWidget {
  const VocabularyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageDataAsync = ref.watch(vocabularyPageDataProvider);
    final viewMode = ref.watch(vocabularyViewModeProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.vocabulary),
        elevation: 0,
        actions: [
          IconButton(
            tooltip: l10n.subtitleWordsTitle,
            icon: const Icon(Icons.subtitles),
            onPressed: () => context.push('/subtitle-words'),
          ),
        ],
      ),
      body: pageDataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const _ErrorView(),
        data: (data) => _VocabularyContent(data: data, viewMode: viewMode),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(l10n.couldNotLoadVocabulary, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _VocabularyContent extends ConsumerWidget {
  const _VocabularyContent({required this.data, required this.viewMode});
  final VocabularyPageData data;
  final VocabularyViewMode viewMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Stats header
        _StatsHeader(data: data),

        // View mode tabs
        _ViewModeTabs(viewMode: viewMode),

        // Content based on view mode
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _buildContent(context, ref),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref) {
    switch (viewMode) {
      case VocabularyViewMode.goal:
        return _GoalView(topicLevelCounts: data.topicLevelCounts);
      case VocabularyViewMode.level:
        return _LevelView(levelCounts: data.levelCounts);
      case VocabularyViewMode.topic:
        return _TopicView(topics: data.topics);
    }
  }
}

class _StatsHeader extends StatelessWidget {
  const _StatsHeader({required this.data});

  final VocabularyPageData data;

  int get _totalWords {
    return data.levelCounts.fold(0, (sum, lc) => sum + lc.count);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).primaryColor.withAlpha(26),
      child: Row(
        children: [
          const Icon(Icons.book, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.wordsCount(_totalWords),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  l10n.cefrLevelsCount(data.levelCounts.length),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewModeTabs extends ConsumerWidget {
  const _ViewModeTabs({required this.viewMode});
  final VocabularyViewMode viewMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _TabButton(
            label: '🎯 ${l10n.vocabularyByGoal}',
            isSelected: viewMode == VocabularyViewMode.goal,
            onTap: () => ref.read(vocabularyViewModeProvider.notifier).state =
                VocabularyViewMode.goal,
          ),
          _TabButton(
            label: '🧭 ${l10n.vocabularyByLevel}',
            isSelected: viewMode == VocabularyViewMode.level,
            onTap: () => ref.read(vocabularyViewModeProvider.notifier).state =
                VocabularyViewMode.level,
          ),
          _TabButton(
            label: '📚 ${l10n.vocabularyByTopic}',
            isSelected: viewMode == VocabularyViewMode.topic,
            onTap: () => ref.read(vocabularyViewModeProvider.notifier).state =
                VocabularyViewMode.topic,
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Semantics(
        button: true,
        selected: isSelected,
        label: label,
        child: Material(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                label,
                maxLines: 2,
                softWrap: true,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Goal-based vocabulary view
class _GoalView extends StatelessWidget {
  const _GoalView({required this.topicLevelCounts});
  final List<TopicLevelCount> topicLevelCounts;

  static const _goals = [
    {
      'id': 'daily-life',
      'icon': '🏙️',
      'keys':
          'alltag,time,numbers,people,feelings-and-emotions,familie,family-members,einkaufen,restaurant',
    },
    {
      'id': 'settlement-home',
      'icon': '🏠',
      'keys':
          'wohnen,house,furniture,bathroom,buildings-and-places,countries,traffic',
    },
    {
      'id': 'travel',
      'icon': '🧳',
      'keys':
          'reisen,travel,traffic,vehicles-and-transportation,car-driving-vocabulary,car-parts,hotel-vocabulary,camping,countries',
    },
    {
      'id': 'food-service',
      'icon': '🍽️',
      'keys':
          'restaurant,food,drinks,kitchen,chef-vocabulary,restaurant-and-hotel-vocabulary,hotel-vocabulary',
    },
    {
      'id': 'work',
      'icon': '💼',
      'keys':
          'arbeit,jobs,business,sales-vocabulary,computer-science-vocabulary,construction-vocabulary,mechanical-vocabulary',
    },
    {
      'id': 'medical',
      'icon': '🩺',
      'keys':
          'gesundheit,body-parts,health-fitness,nursing-vocabulary,dental-assistant-vocabulary',
    },
    {
      'id': 'study-exam',
      'icon': '🎓',
      'keys':
          'schule,school-education,premium-gifts,verbs-with-prepositions,adjectives-with-prepositions,conjunction,adverb-zeit,adverb-ort',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.learnByGoal,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.learnByGoalDescription,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 16),
        ...(_goals.map(
          (goal) => _GoalCard(
            id: goal['id']!,
            icon: goal['icon']!,
            title: _goalTitle(l10n, goal['id']!),
            topicKeys: goal['keys']!.split(',').toSet(),
            topicLevelCounts: topicLevelCounts,
          ),
        )),
      ],
    );
  }

  String _goalTitle(AppLocalizations l10n, String id) => switch (id) {
    'daily-life' => l10n.goalDailyLife,
    'settlement-home' => l10n.goalSettlementHome,
    'travel' => l10n.goalTravel,
    'food-service' => l10n.goalFoodService,
    'work' => l10n.goalWork,
    'medical' => l10n.goalMedical,
    'study-exam' => l10n.goalStudyExam,
    _ => id,
  };
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.id,
    required this.icon,
    required this.title,
    required this.topicKeys,
    required this.topicLevelCounts,
  });

  final String id;
  final String icon;
  final String title;
  final Set<String> topicKeys;
  final List<TopicLevelCount> topicLevelCounts;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => _GoalDetailScreen(
                goalId: id,
                title: title,
                topicKeys: topicKeys,
                topicLevelCounts: topicLevelCounts,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(icon, style: const TextStyle(fontSize: 24)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoalDetailScreen extends StatelessWidget {
  const _GoalDetailScreen({
    required this.goalId,
    required this.title,
    required this.topicKeys,
    required this.topicLevelCounts,
  });
  final String goalId;
  final String title;
  final Set<String> topicKeys;
  final List<TopicLevelCount> topicLevelCounts;

  @override
  Widget build(BuildContext context) {
    final topics = <String, TopicLevelCount>{};
    for (final count in topicLevelCounts) {
      if (topicKeys.contains(count.topicKey)) topics[count.topicKey] = count;
    }
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final topic = topics.values.elementAt(index);
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: const Icon(Icons.menu_book_outlined),
              title: Text(topic.labelVi),
              subtitle: Text(
                AppLocalizations.of(context).vocabularyTopicStats(
                  topic.label,
                  topic.totalCount ?? topic.count,
                ),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      VocabularyLessonScreen(topicKey: topic.topicKey),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Level-based vocabulary view
class _LevelView extends StatelessWidget {
  const _LevelView({required this.levelCounts});
  final List<LevelCount> levelCounts;

  static const _levels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
  static const _levelIcons = ['🌱', '🌿', '🌳', '🎆', '🌴', '👑'];
  static const _levelColors = [
    Colors.purple,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.amber,
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.cefrLevelsCount(_levels.length),
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: _levels.length,
          itemBuilder: (context, index) {
            final level = _levels[index];
            final count = levelCounts
                .where((lc) => lc.level == level)
                .fold(0, (sum, lc) => sum + lc.count);

            return _LevelCard(
              level: level,
              icon: _levelIcons[index],
              name: _levelName(l10n, index),
              count: count,
              color: _levelColors[index],
            );
          },
        ),
      ],
    );
  }

  String _levelName(AppLocalizations l10n, int index) => switch (index) {
    0 => l10n.cefrBeginner,
    1 => l10n.cefrPreIntermediate,
    2 => l10n.cefrIntermediate,
    3 => l10n.cefrUpperIntermediate,
    4 => l10n.cefrAdvanced,
    5 => l10n.cefrProficient,
    _ => '',
  };
}

class _LevelCard extends StatelessWidget {
  const _LevelCard({
    required this.level,
    required this.icon,
    required this.name,
    required this.count,
    required this.color,
  });

  final String level;
  final String icon;
  final String name;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => _LevelDetailScreen(level: level)),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border(left: BorderSide(color: color, width: 4)),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(icon, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(
                    l10n.cefrLevel(level),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    l10n.wordsCount(count),
                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LevelDetailScreen extends ConsumerWidget {
  const _LevelDetailScreen({required this.level});
  final String level;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final itemsAsync = ref.watch(
      itemsByLevelProvider(ItemsByLevelParams(level: level, pageSize: 100)),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.cefrLevel(level))),
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.couldNotLoadVocabulary)),
        data: (result) {
          final items = result.items;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(item.contentDe),
                  subtitle: Text(
                    item.contentVi ?? item.meanings?.firstOrNull ?? '',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          VocabularyWordScreen(item: item, items: items),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// Topic-based vocabulary view
class _TopicView extends StatelessWidget {
  const _TopicView({required this.topics});
  final List<VocabularyTopic> topics;

  List<VocabularyTopic> get _mainTopics =>
      topics.where((t) => t.parentId == null).toList();

  @override
  Widget build(BuildContext context) {
    final mainTopics = _mainTopics;

    if (mainTopics.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context).noVocabularyTopics),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: mainTopics.length,
      itemBuilder: (context, index) {
        final mainTopic = mainTopics[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Text(mainTopic.icon, style: const TextStyle(fontSize: 24)),
            title: Text(mainTopic.labelVi),
            subtitle: Text(mainTopic.label),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VocabularyLessonScreen(topicKey: mainTopic.key),
              ),
            ),
          ),
        );
      },
    );
  }
}
