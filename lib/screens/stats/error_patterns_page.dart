import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../data/stats_repository.dart';
import '../domain/stats_models.dart';

final errorPatternsDetailProvider = FutureProvider<List<ErrorPattern>>((ref) async {
  final repo = StatsRepository();
  return repo.getErrorPatterns();
});

final errorPatternsByCategoryProvider = FutureProvider<Map<String, List<ErrorPattern>>>((ref) async {
  final patterns = await ref.watch(errorPatternsDetailProvider.future);
  final grouped = <String, List<ErrorPattern>>{};
  for (final pattern in patterns) {
    grouped.putIfAbsent(pattern.grammarCategoryVi, () => []).add(pattern);
  }
  return grouped;
});

class ErrorPatternsPage extends ConsumerWidget {
  const ErrorPatternsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patternsAsync = ref.watch(errorPatternsDetailProvider);

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: const Text(
          'Phân tích lỗi sai',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.tigerOrange,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ],
      ),
      body: patternsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text('Lỗi tải dữ liệu: $e'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(errorPatternsDetailProvider),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
        data: (patterns) => _ErrorPatternsContent(patterns: patterns),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lọc theo loại lỗi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _FilterChip(label: 'Tất cả', selected: true, onTap: () {}),
                _FilterChip(label: 'Tân ngữ', selected: false, onTap: () {}),
                _FilterChip(label: 'Biến đổi động từ', selected: false, onTap: () {}),
                _FilterChip(label: 'Thứ tự từ', selected: false, onTap: () {}),
                _FilterChip(label: 'Giới từ', selected: false, onTap: () {}),
                _FilterChip(label: 'Đuôi tính từ', selected: false, onTap: () {}),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Áp dụng'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.grey[700],
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _ErrorPatternsContent extends StatefulWidget {
  final List<ErrorPattern> patterns;

  const _ErrorPatternsContent({required this.patterns});

  @override
  State<_ErrorPatternsContent> createState() => _ErrorPatternsContentState();
}

class _ErrorPatternsContentState extends State<_ErrorPatternsContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _sortBy = 'errorRate';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<ErrorPattern> get _sortedPatterns {
    final patterns = List<ErrorPattern>.from(widget.patterns);
    switch (_sortBy) {
      case 'errorRate':
        patterns.sort((a, b) => b.errorRate.compareTo(a.errorRate));
        break;
      case 'errorCount':
        patterns.sort((a, b) => b.errorCount.compareTo(a.errorCount));
        break;
      case 'recent':
        patterns.sort((a, b) {
          final aTime = a.lastOccurredAt ?? DateTime(2000);
          final bTime = b.lastOccurredAt ?? DateTime(2000);
          return bTime.compareTo(aTime);
        });
        break;
    }
    return patterns;
  }

  Map<String, List<ErrorPattern>> get _groupedPatterns {
    final grouped = <String, List<ErrorPattern>>{};
    for (final pattern in _sortedPatterns) {
      grouped.putIfAbsent(pattern.grammarCategoryVi, () => []).add(pattern);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSummaryHeader(),
        _buildSortOptions(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildListView(),
              _buildCategoryView(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryHeader() {
    final totalErrors = widget.patterns.fold<int>(0, (sum, p) => sum + p.errorCount);
    final totalAttempts = widget.patterns.fold<int>(0, (sum, p) => sum + p.totalAttempts);
    final avgErrorRate = totalAttempts > 0 ? (totalErrors / totalAttempts * 100) : 0.0;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SummaryItem(
              icon: Icons.error_outline,
              label: 'Tổng lỗi',
              value: '$totalErrors',
            ),
          ),
          Container(height: 40, width: 1, color: Colors.white24),
          Expanded(
            child: _SummaryItem(
              icon: Icons.percent,
              label: 'Tỷ lệ lỗi TB',
              value: '${avgErrorRate.toStringAsFixed(1)}%',
            ),
          ),
          Container(height: 40, width: 1, color: Colors.white24),
          Expanded(
            child: _SummaryItem(
              icon: Icons.category,
              label: 'Loại lỗi',
              value: '${widget.patterns.length}',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.primary,
              tabs: const [
                Tab(text: 'Danh sách'),
                Tab(text: 'Theo nhóm'),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) => setState(() => _sortBy = value),
            itemBuilder: (context) => [
              PopupMenuItem(value: 'errorRate', child: Text('Tỷ lệ lỗi ${_sortBy == 'errorRate' ? '✓' : ''}')),
              PopupMenuItem(value: 'errorCount', child: Text('Số lỗi ${_sortBy == 'errorCount' ? '✓' : ''}')),
              PopupMenuItem(value: 'recent', child: Text('Gần đây ${_sortBy == 'recent' ? '✓' : ''}')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    final patterns = _sortedPatterns;
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: patterns.length,
      itemBuilder: (context, index) {
        return _ErrorPatternDetailCard(
          pattern: patterns[index],
          onDrillTap: () => _navigateToDrill(context, patterns[index]),
        );
      },
    );
  }

  Widget _buildCategoryView() {
    final grouped = _groupedPatterns;
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final category = grouped.keys.elementAt(index);
        final categoryPatterns = grouped[category]!;
        return _CategorySection(
          category: category,
          patterns: categoryPatterns,
          onDrillTap: (pattern) => _navigateToDrill(context, pattern),
        );
      },
    );
  }

  void _navigateToDrill(BuildContext context, ErrorPattern pattern) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đang mở bài tập cho: ${pattern.grammarCategoryVi}'),
        action: SnackBarAction(
          label: 'Đóng',
          onPressed: () {},
        ),
      ),
    );
    // TODO: Navigate to specific drill based on grammar category
    // context.push('/drill/${pattern.grammarCategory}');
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _ErrorPatternDetailCard extends StatelessWidget {
  final ErrorPattern pattern;
  final VoidCallback onDrillTap;

  const _ErrorPatternDetailCard({
    required this.pattern,
    required this.onDrillTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getSeverityColor(pattern.errorRate).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _getSeverityColor(pattern.errorRate).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    pattern.grammarCategoryVi,
                    style: TextStyle(
                      color: _getSeverityColor(pattern.errorRate),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getSeverityColor(pattern.errorRate),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${pattern.errorRate.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatRow(
                    icon: Icons.close,
                    label: 'Số lỗi',
                    value: '${pattern.errorCount}',
                    color: AppColors.error,
                  ),
                ),
                Expanded(
                  child: _StatRow(
                    icon: Icons.check,
                    label: 'Đúng',
                    value: '${pattern.totalAttempts - pattern.errorCount}',
                    color: AppColors.success,
                  ),
                ),
                Expanded(
                  child: _StatRow(
                    icon: Icons.repeat,
                    label: 'Tổng',
                    value: '${pattern.totalAttempts}',
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: pattern.errorRate / 100,
                minHeight: 8,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation(_getSeverityColor(pattern.errorRate)),
              ),
            ),
            if (pattern.exampleErrors.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'Ví dụ lỗi:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 8),
              ...pattern.exampleErrors.take(2).map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.arrow_right, color: AppColors.error, size: 20),
                    Expanded(
                      child: Text(
                        e,
                        style: TextStyle(color: Colors.grey[700], fontSize: 13),
                      ),
                    ),
                  ],
                ),
              )),
            ],
            if (pattern.suggestions.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                'Gợi ý cải thiện:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: pattern.suggestions.take(2).map((s) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.success.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lightbulb, size: 16, color: AppColors.success),
                      const SizedBox(width: 6),
                      Text(
                        s,
                        style: const TextStyle(fontSize: 12, color: AppColors.success),
                      ),
                    ],
                  ),
                )).toList(),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onDrillTap,
                    icon: const Icon(Icons.school),
                    label: const Text('Làm bài tập'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onDrillTap,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Ôn luyện'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.tigerOrange,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getSeverityColor(double rate) {
    if (rate < 15) return AppColors.success;
    if (rate < 25) return Colors.orange;
    return AppColors.error;
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }
}

class _CategorySection extends StatelessWidget {
  final String category;
  final List<ErrorPattern> patterns;
  final Function(ErrorPattern) onDrillTap;

  const _CategorySection({
    required this.category,
    required this.patterns,
    required this.onDrillTap,
  });

  @override
  Widget build(BuildContext context) {
    final totalErrors = patterns.fold<int>(0, (sum, p) => sum + p.errorCount);
    final totalAttempts = patterns.fold<int>(0, (sum, p) => sum + p.totalAttempts);
    final avgRate = totalAttempts > 0 ? (totalErrors / totalAttempts * 100) : 0.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${patterns.length}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                category,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getAvgRateColor(avgRate).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${avgRate.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _getAvgRateColor(avgRate),
                ),
              ),
            ),
          ],
        ),
        subtitle: Text(
          '$totalErrors lỗi / $totalAttempts lần thử',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        children: patterns.map((p) => _ErrorPatternDetailCard(
          pattern: p,
          onDrillTap: () => onDrillTap(p),
        )).toList(),
      ),
    );
  }

  Color _getAvgRateColor(double rate) {
    if (rate < 15) return AppColors.success;
    if (rate < 25) return Colors.orange;
    return AppColors.error;
  }
}
