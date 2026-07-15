import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/vocabulary/presentation/vocabulary_provider.dart';

/// Vocabulary Search Screen - mimics web vocabulary-detail-page.tsx
class VocabSearchScreen extends ConsumerStatefulWidget {
  const VocabSearchScreen({super.key});

  @override
  ConsumerState<VocabSearchScreen> createState() => _VocabSearchScreenState();
}

class _VocabSearchScreenState extends ConsumerState<VocabSearchScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tra từ'),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Nhập từ cần tra...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          Expanded(
            child: _query.isEmpty ? _buildSuggestions() : _buildResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Truy cập nhanh',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _QuickChip(
                icon: 'A1',
                color: Colors.purple,
                onTap: () => _showLevel('A1'),
              ),
              _QuickChip(
                icon: 'A2',
                color: Colors.blue,
                onTap: () => _showLevel('A2'),
              ),
              _QuickChip(
                icon: 'B1',
                color: Colors.green,
                onTap: () => _showLevel('B1'),
              ),
              _QuickChip(
                icon: 'B2',
                color: Colors.orange,
                onTap: () => _showLevel('B2'),
              ),
              _QuickChip(
                icon: 'C1',
                color: Colors.red,
                onTap: () => _showLevel('C1'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Chủ đề phổ biến',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ..._popularTopics.map(
            (topic) => _TopicTile(
              icon: topic['icon']!,
              title: topic['title']!,
              subtitle: topic['subtitle']!,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    final collectionsAsync = ref.watch(wordCollectionsProvider);

    return collectionsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Lỗi: $e')),
      data: (collections) {
        final filtered = collections
            .where(
              (c) =>
                  c.name.toLowerCase().contains(_query.toLowerCase()) ||
                  (c.description?.toLowerCase().contains(
                        _query.toLowerCase(),
                      ) ??
                      false),
            )
            .toList();

        if (filtered.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search_off, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'Không tìm thấy "$_query"',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Thử từ khóa khác',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final col = filtered[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      col.icon ?? '📚',
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                title: Text(
                  col.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(col.description ?? ''),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            );
          },
        );
      },
    );
  }

  void _showLevel(String level) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => _LevelWordsScreen(level: level)),
    );
  }

  static const _popularTopics = [
    {
      'icon': '👨‍👩‍👧',
      'title': 'Gia đình',
      'subtitle': 'Familie, family members',
    },
    {'icon': '🍽️', 'title': 'Ăn uống', 'subtitle': 'Restaurant, food, drinks'},
    {'icon': '🏠', 'title': 'Nhà ở', 'subtitle': 'Wohnen, house, furniture'},
    {'icon': '💼', 'title': 'Công việc', 'subtitle': 'Arbeit, jobs, business'},
    {'icon': '🏥', 'title': 'Y tế', 'subtitle': 'Gesundheit, health'},
    {'icon': '🧳', 'title': 'Du lịch', 'subtitle': 'Reisen, travel'},
  ];
}

class _QuickChip extends StatelessWidget {
  const _QuickChip({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: color.withAlpha(26),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withAlpha(77)),
        ),
        child: Text(
          icon,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _TopicTile extends StatelessWidget {
  const _TopicTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Text(icon, style: const TextStyle(fontSize: 28)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _LevelWordsScreen extends ConsumerWidget {
  const _LevelWordsScreen({required this.level});
  final String level;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionsAsync = ref.watch(wordCollectionsProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Từ vựng $level')),
      body: collectionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Lỗi: $e')),
        data: (collections) {
          final filtered = collections
              .where((c) => c.level?.name.toUpperCase() == level.toUpperCase())
              .toList();

          if (filtered.isEmpty) {
            return Center(child: Text('Không có từ vựng cấp độ $level'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final col = filtered[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Text(
                    col.icon ?? '📚',
                    style: const TextStyle(fontSize: 28),
                  ),
                  title: Text(
                    col.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(col.description ?? ''),
                  trailing: const Icon(Icons.play_arrow, color: Colors.orange),
                  onTap: () {},
                ),
              );
            },
          );
        },
      ),
    );
  }
}
