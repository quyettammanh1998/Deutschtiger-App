import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/journey_models.dart';
import '../data/journey_repository.dart';
import '../presentation/journey_provider.dart';

/// Browse vocabulary items with filtering by category/level/type.
/// AI word lookup (placeholder), inline add/delete, mini-game links.
class LearningBrowserScreen extends ConsumerStatefulWidget {
  const LearningBrowserScreen({super.key});

  @override
  ConsumerState<LearningBrowserScreen> createState() => _LearningBrowserScreenState();
}

class _LearningBrowserScreenState extends ConsumerState<LearningBrowserScreen> {
  String _selectedLevel = 'ALL';
  String _selectedCategory = 'ALL';
  String _selectedType = 'ALL';
  String _searchQuery = '';
  bool _showLearned = true;
  bool _showNotLearned = true;

  final _searchController = TextEditingController();
  final _aiLookupController = TextEditingController();

  static const _levelFilters = ['ALL', 'A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
  static const _categoryFilters = ['ALL', 'Nouns', 'Verbs', 'Adjectives', 'Prepositions', 'Conjunctions'];
  static const _typeFilters = ['ALL', 'vocabulary', 'grammar', 'dialogue', 'exercise', 'review'];

  @override
  void dispose() {
    _searchController.dispose();
    _aiLookupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(allLearningItemsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Vocabulary Browser'),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.grid_view_rounded),
            onPressed: () {},
            tooltip: 'Grid View',
          ),
          IconButton(
            icon: const Icon(Icons.list_rounded),
            onPressed: () {},
            tooltip: 'List View',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: _SearchBar(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              onClear: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
            ),
          ),
          // Filters
          _FilterSection(
            selectedLevel: _selectedLevel,
            selectedCategory: _selectedCategory,
            selectedType: _selectedType,
            showLearned: _showLearned,
            showNotLearned: _showNotLearned,
            onLevelChanged: (level) => setState(() => _selectedLevel = level),
            onCategoryChanged: (cat) => setState(() => _selectedCategory = cat),
            onTypeChanged: (type) => setState(() => _selectedType = type),
            onLearnedToggled: () => setState(() => _showLearned = !_showLearned),
            onNotLearnedToggled: () => setState(() => _showNotLearned = !_showNotLearned),
          ),
          // AI Lookup button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _AILookupBar(
              controller: _aiLookupController,
              onLookup: _showAILookupDialog,
            ),
          ),
          const SizedBox(height: 8),
          // Items list
          Expanded(
            child: itemsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (items) => _FilteredItemsList(
                items: _filterItems(items),
                onDelete: (item) => _deleteItem(item),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
        backgroundColor: AppColors.tigerOrange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  List<LearningItem> _filterItems(List<LearningItem> items) {
    return items.where((item) {
      // Level filter
      if (_selectedLevel != 'ALL' && item.level != _selectedLevel) return false;
      // Category filter
      if (_selectedCategory != 'ALL' && item.category != _selectedCategory) return false;
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!item.word.toLowerCase().contains(query) &&
            !item.translation.toLowerCase().contains(query)) {
          return false;
        }
      }
      // Learned filter
      if (item.isLearned && !_showLearned) return false;
      if (!item.isLearned && !_showNotLearned) return false;
      return true;
    }).toList();
  }

  void _deleteItem(LearningItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Delete "${item.word}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              // In real app, call delete method
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${item.word} deleted')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.destructive)),
          ),
        ],
      ),
    );
  }

  void _showAddItemDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddItemSheet(
        onAdd: (word, translation, level, category) {
          Navigator.pop(ctx);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Added: $word')),
          );
        },
      ),
    );
  }

  void _showAILookupDialog() {
    final query = _aiLookupController.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a word to look up')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AILookupSheet(
        word: query,
        onClose: () => Navigator.pop(ctx),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

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
          hintText: 'Search vocabulary...',
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

class _FilterSection extends StatelessWidget {
  final String selectedLevel;
  final String selectedCategory;
  final String selectedType;
  final bool showLearned;
  final bool showNotLearned;
  final ValueChanged<String> onLevelChanged;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<String> onTypeChanged;
  final VoidCallback onLearnedToggled;
  final VoidCallback onNotLearnedToggled;

  static const _levelFilters = ['ALL', 'A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
  static const _categoryFilters = ['ALL', 'Nouns', 'Verbs', 'Adjectives', 'Prepositions', 'Conjunctions'];

  const _FilterSection({
    required this.selectedLevel,
    required this.selectedCategory,
    required this.selectedType,
    required this.showLearned,
    required this.showNotLearned,
    required this.onLevelChanged,
    required this.onCategoryChanged,
    required this.onTypeChanged,
    required this.onLearnedToggled,
    required this.onNotLearnedToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Level chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _levelFilters.map((level) {
                final isSelected = selectedLevel == level;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => onLevelChanged(level),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.tigerOrange : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? AppColors.tigerOrange : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        level,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : AppColors.foreground,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          // Category + Type filters
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categoryFilters.map((cat) {
                      final isSelected = selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: GestureDetector(
                          onTap: () => onCategoryChanged(cat),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.purple.withValues(alpha: 0.1) : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? Colors.purple : Colors.transparent,
                              ),
                            ),
                            child: Text(
                              cat,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: isSelected ? Colors.purple : Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              // Learned filter toggles
              Row(
                children: [
                  _FilterChip(
                    label: 'Learned',
                    isSelected: showLearned,
                    color: AppColors.success,
                    onTap: onLearnedToggled,
                  ),
                  const SizedBox(width: 6),
                  _FilterChip(
                    label: 'New',
                    isSelected: showNotLearned,
                    color: AppColors.tigerOrange,
                    onTap: onNotLearnedToggled,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.15) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              size: 12,
              color: isSelected ? color : Colors.grey,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isSelected ? color : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AILookupBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onLookup;

  const _AILookupBar({
    required this.controller,
    required this.onLookup,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onLookup,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.tigerOrange.withValues(alpha: 0.1),
              Colors.purple.withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.tigerOrange.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.tigerOrange.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: AppColors.tigerOrange,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Word Lookup',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.foreground,
                    ),
                  ),
                  Text(
                    'Tap to look up any word with AI',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.mutedForeground,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _FilteredItemsList extends StatelessWidget {
  final List<LearningItem> items;
  final Function(LearningItem) onDelete;

  const _FilteredItemsList({
    required this.items,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'No items found',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _VocabCard(
          item: item,
          onDelete: () => onDelete(item),
          onTap: () => context.push('/games/runner?word=${item.word}'),
        );
      },
    );
  }
}

class _VocabCard extends StatelessWidget {
  final LearningItem item;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const _VocabCard({
    required this.item,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.destructive,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      confirmDismiss: (_) async {
        onDelete();
        return false;
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Level badge
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getLevelColor(item.level).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    item.level,
                    style: TextStyle(
                      color: _getLevelColor(item.level),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Word info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.word,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.foreground,
                            ),
                          ),
                        ),
                        if (item.isLearned)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check, size: 10, color: AppColors.success),
                                SizedBox(width: 2),
                                Text(
                                  'Learned',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.success,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.translation,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.purple.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.category,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.purple,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (item.pronunciation.isNotEmpty)
                          Text(
                            item.pronunciation,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Actions
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.play_circle_outline, color: AppColors.tigerOrange),
                    onPressed: onTap,
                    tooltip: 'Practice with DeutschRunner',
                  ),
                  IconButton(
                    icon: Icon(Icons.info_outline, color: Colors.grey.shade400),
                    onPressed: () {},
                    tooltip: 'Details',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getLevelColor(String level) {
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
      case 'C2':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}

class _AddItemSheet extends StatefulWidget {
  final Function(String word, String translation, String level, String category) onAdd;

  const _AddItemSheet({required this.onAdd});

  @override
  State<_AddItemSheet> createState() => _AddItemSheetState();
}

class _AddItemSheetState extends State<_AddItemSheet> {
  final _wordController = TextEditingController();
  final _translationController = TextEditingController();
  final _pronunciationController = TextEditingController();
  String _selectedLevel = 'A1';
  String _selectedCategory = 'Nouns';

  static const _levelFilters = ['ALL', 'A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
  static const _categoryFilters = ['ALL', 'Nouns', 'Verbs', 'Adjectives', 'Prepositions', 'Conjunctions'];

  @override
  void dispose() {
    _wordController.dispose();
    _translationController.dispose();
    _pronunciationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.tigerOrange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.add_circle, color: AppColors.tigerOrange),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Add New Vocabulary',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _wordController,
              decoration: const InputDecoration(
                labelText: 'German Word',
                hintText: 'e.g., der Apfel',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _translationController,
              decoration: const InputDecoration(
                labelText: 'Translation',
                hintText: 'e.g., quả táo',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _pronunciationController,
              decoration: const InputDecoration(
                labelText: 'Pronunciation (optional)',
                hintText: 'e.g., /ˈap͡fəl/',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedLevel,
                    decoration: const InputDecoration(labelText: 'Level'),
                    items: _levelFilters.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                    onChanged: (v) => setState(() => _selectedLevel = v!),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: _categoryFilters.where((c) => c != 'ALL').map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (v) => setState(() => _selectedCategory = v!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_wordController.text.isNotEmpty && _translationController.text.isNotEmpty) {
                    widget.onAdd(
                      _wordController.text,
                      _translationController.text,
                      _selectedLevel,
                      _selectedCategory,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tigerOrange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Add Vocabulary'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AILookupSheet extends StatelessWidget {
  final String word;
  final VoidCallback onClose;

  const _AILookupSheet({required this.word, required this.onClose});

  @override
  Widget build(BuildContext context) {
    // Placeholder AI lookup - in real app would call AI service
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.tigerOrange.withValues(alpha: 0.2),
                  Colors.purple.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.tigerOrange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.auto_awesome, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AI Word Analysis',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Looking up: $word',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                ),
              ],
            ),
          ),
          // Content (placeholder)
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Loading state placeholder
                const Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Analyzing word...'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Example content
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Word Details (Placeholder)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      _AIField(label: 'Word', value: word),
                      _AIField(label: 'Translation', value: 'Translation will appear here'),
                      _AIField(label: 'Grammar', value: 'Noun (der)'),
                      _AIField(label: 'Example', value: 'Example sentence'),
                      _AIField(label: 'Usage tips', value: 'Tips from AI'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AIField extends StatelessWidget {
  final String label;
  final String value;

  const _AIField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
