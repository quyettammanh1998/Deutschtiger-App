import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Grammar roadmap widget với filter và search.
class GrammarRoadmap extends StatefulWidget {
  const GrammarRoadmap({super.key});

  @override
  State<GrammarRoadmap> createState() => _GrammarRoadmapState();
}

class _GrammarRoadmapState extends State<GrammarRoadmap> {
  String _selectedLevel = 'ALL';
  String? _selectedTopic;
  String _searchQuery = '';
  final _searchController = TextEditingController();

  static const _levelFilters = ['ALL', 'A1', 'A2', 'B1', 'B2', 'C1'];
  static const _topics = ['Mạo từ', 'Động từ', 'Ngữ pháp', 'Giới từ', 'Câu'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search bar
        _SearchBar(
          controller: _searchController,
          onChanged: (value) => setState(() => _searchQuery = value),
          onClear: () {
            _searchController.clear();
            setState(() => _searchQuery = '');
          },
        ),

        const SizedBox(height: 16),

        // Level filter chips
        _LevelFilterChips(
          selectedLevel: _selectedLevel,
          onLevelSelected: (level) => setState(() => _selectedLevel = level),
        ),

        const SizedBox(height: 12),

        // Topic filter chips
        _TopicFilterChips(
          selectedTopic: _selectedTopic,
          onTopicSelected: (topic) => setState(() => _selectedTopic = topic),
        ),

        const SizedBox(height: 16),

        // Content
        Expanded(
          child: _searchQuery.isNotEmpty
              ? _buildSearchResults()
              : _buildTopicList(),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    // Mock search results
    final results = _getMockLessons()
        .where((l) => l['title']!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              'Không tìm thấy kết quả',
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final lesson = results[index];
        return _LessonTile(
          title: lesson['title']!,
          level: lesson['level']!,
          isCompleted: lesson['isCompleted'] == true,
          onTap: () {},
        );
      },
    );
  }

  Widget _buildTopicList() {
    final groups = _getMockTopicGroups();

    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        return _TopicGroupCard(
          topic: group['topic']!,
          level: group['level']!,
          lessons: group['lessons'] as List<Map<String, dynamic>>,
          isExpanded: _selectedTopic == group['topic'],
          onTap: () {
            setState(() {
              if (_selectedTopic == group['topic']) {
                _selectedTopic = null;
              } else {
                _selectedTopic = group['topic'];
              }
            });
          },
        );
      },
    );
  }

  List<Map<String, dynamic>> _getMockLessons() {
    return [
      {'title': 'Mạo từ xác định: der, die, das', 'level': 'A1', 'isCompleted': true},
      {'title': 'Động từ sein & haben', 'level': 'A1', 'isCompleted': true},
      {'title': 'Câu trần thuật', 'level': 'A1', 'isCompleted': false},
      {'title': 'Giới từ chỉ nơi chốn', 'level': 'A2', 'isCompleted': false},
      {'title': 'Thì quá khứ', 'level': 'B1', 'isCompleted': false},
      {'title': 'Câu bị động', 'level': 'B2', 'isCompleted': false},
    ];
  }

  List<Map<String, dynamic>> _getMockTopicGroups() {
    return [
      {
        'topic': 'Mạo từ',
        'level': 'A1',
        'lessons': [
          {'title': 'Mạo từ xác định', 'isCompleted': true},
          {'title': 'Mạo từ không xác định', 'isCompleted': true},
          {'title': 'Mạo từ sở hữu', 'isCompleted': false},
        ],
      },
      {
        'topic': 'Động từ',
        'level': 'A1',
        'lessons': [
          {'title': 'Động từ sein & haben', 'isCompleted': true},
          {'title': 'Động từ thường', 'isCompleted': false},
          {'title': 'Động từ bất quy tắc', 'isCompleted': false},
        ],
      },
    ];
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Tìm kiếm ngữ pháp...',
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.close, color: Colors.grey.shade400),
                  onPressed: onClear,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

class _LevelFilterChips extends StatelessWidget {
  const _LevelFilterChips({
    required this.selectedLevel,
    required this.onLevelSelected,
  });

  final String selectedLevel;
  final ValueChanged<String> onLevelSelected;

  static const _levels = ['ALL', 'A1', 'A2', 'B1', 'B2', 'C1'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _levels.map((level) {
          final isSelected = selectedLevel == level;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onLevelSelected(level),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.tigerOrange : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.tigerOrange : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  level == 'ALL' ? 'Tất cả' : level,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.foreground,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TopicFilterChips extends StatelessWidget {
  const _TopicFilterChips({
    required this.selectedTopic,
    required this.onTopicSelected,
  });

  final String? selectedTopic;
  final ValueChanged<String?> onTopicSelected;

  static const _topics = ['Mạo từ', 'Động từ', 'Ngữ pháp', 'Giới từ', 'Câu'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _topics.map((topic) {
          final isSelected = selectedTopic == topic;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onTopicSelected(isSelected ? null : topic),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.purple.withValues(alpha: 0.1) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? Colors.purple : Colors.transparent,
                  ),
                ),
                child: Text(
                  topic,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.purple : Colors.grey.shade600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TopicGroupCard extends StatelessWidget {
  const _TopicGroupCard({
    required this.topic,
    required this.level,
    required this.lessons,
    required this.isExpanded,
    required this.onTap,
  });

  final String topic;
  final String level;
  final List<Map<String, dynamic>> lessons;
  final bool isExpanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final completedCount = lessons.where((l) => l['isCompleted'] == true).length;
    final progress = lessons.isNotEmpty ? completedCount / lessons.length : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.purple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getTopicIcon(topic),
                      color: Colors.purple,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              topic,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.foreground,
                              ),
                            ),
                            const SizedBox(width: 8),
                            _LevelBadge(level: level),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${completedCount}/${lessons.length} bài đã hoàn thành',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Arrow
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ),
          ),
          // Expanded content
          if (isExpanded)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: lessons.map((lesson) {
                  return _LessonTile(
                    title: lesson['title'],
                    level: level,
                    isCompleted: lesson['isCompleted'] == true,
                    onTap: () {},
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  IconData _getTopicIcon(String topic) {
    switch (topic) {
      case 'Mạo từ':
        return Icons.article;
      case 'Động từ':
        return Icons.swap_horiz;
      case 'Ngữ pháp':
        return Icons.schema;
      case 'Giới từ':
        return Icons.arrow_forward;
      default:
        return Icons.book;
    }
  }
}

class _LessonTile extends StatelessWidget {
  const _LessonTile({
    required this.title,
    required this.level,
    required this.isCompleted,
    required this.onTap,
  });

  final String title;
  final String level;
  final bool isCompleted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? Colors.green : Colors.white,
                border: Border.all(
                  color: isCompleted ? Colors.green : Colors.grey.shade300,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isCompleted ? Colors.grey.shade500 : AppColors.foreground,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey.shade400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelBadge extends StatelessWidget {
  const _LevelBadge({required this.level});

  final String level;

  Color get _color {
    switch (level) {
      case 'A1':
        return Colors.green;
      case 'A2':
        return Colors.lightGreen;
      case 'B1':
        return Colors.orange;
      case 'B2':
        return Colors.deepOrange;
      case 'C1':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        level,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: _color,
        ),
      ),
    );
  }
}
