import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../repositories/affiliate/affiliate_leaderboard_repository.dart';
import '../../view_models/providers.dart';

/// `period` query param sent to `GET /user/affiliate/leaderboard`: 'all' | 'monthly' | 'weekly'.
final affiliateLeaderboardProvider =
    FutureProvider.family<AffiliateLeaderboardResult, String>((ref, period) async {
  final repo = AffiliateLeaderboardRepository(ref.watch(apiClientProvider));
  return repo.getLeaderboard(period: period);
});

class AffiliateLeaderboardPage extends ConsumerStatefulWidget {
  const AffiliateLeaderboardPage({super.key});

  @override
  ConsumerState<AffiliateLeaderboardPage> createState() => _AffiliateLeaderboardPageState();
}

class _AffiliateLeaderboardPageState extends ConsumerState<AffiliateLeaderboardPage> {
  String _sortBy = 'earnings';
  String _timeFilter = 'all';

  /// Maps the UI filter to the backend's `period` query param.
  String get _period {
    switch (_timeFilter) {
      case 'month':
        return 'monthly';
      case 'week':
        return 'weekly';
      default:
        return 'all';
    }
  }

  @override
  Widget build(BuildContext context) {
    final leaderboardAsync = ref.watch(affiliateLeaderboardProvider(_period));

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: const Text(
          'Bảng xếp hạng',
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
      body: leaderboardAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text('Error loading leaderboard: $e'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(affiliateLeaderboardProvider(_period)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (result) => _buildLeaderboardContent(result),
      ),
    );
  }

  Widget _buildLeaderboardContent(AffiliateLeaderboardResult result) {
    final entries = result.entries;
    if (entries.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async => ref.invalidate(affiliateLeaderboardProvider(_period)),
        child: ListView(
          children: [
            const SizedBox(height: 120),
            Icon(Icons.leaderboard_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Chưa có dữ liệu bảng xếp hạng',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      );
    }

    final sortedEntries = _sortEntries(entries);

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(affiliateLeaderboardProvider(_period)),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildTopThree(sortedEntries.take(3).toList()),
          ),
          SliverToBoxAdapter(
            child: _buildStatsSummary(sortedEntries),
          ),
          SliverToBoxAdapter(
            child: _buildSortOptions(),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final entry = sortedEntries[index + 3];
                return _LeaderboardItem(
                  entry: entry,
                  previousRank: index + 4,
                );
              },
              childCount: (sortedEntries.length - 3).clamp(0, sortedEntries.length),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  Widget _buildTopThree(List<AffiliateLeaderboardEntry> topThree) {
    if (topThree.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (topThree.length > 1)
            Expanded(child: _TopThreeCard(entry: topThree[1], rank: 2)),
          if (topThree.isNotEmpty)
            Expanded(
              flex: 2,
              child: _TopThreeCard(entry: topThree[0], rank: 1, isFirst: true),
            ),
          if (topThree.length > 2)
            Expanded(child: _TopThreeCard(entry: topThree[2], rank: 3)),
        ],
      ),
    );
  }

  Widget _buildStatsSummary(List<AffiliateLeaderboardEntry> entries) {
    final totalConversions = entries.fold<int>(0, (sum, e) => sum + e.conversions);
    final totalEarned = entries.fold<int>(0, (sum, e) => sum + e.totalEarned);
    final avgConversions = entries.isNotEmpty ? (totalConversions / entries.length).round() : 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: _SummaryItem(
                  icon: Icons.people,
                  value: '$totalConversions',
                  label: 'Tổng giới thiệu',
                  color: AppColors.primary,
                ),
              ),
              Container(height: 40, width: 1, color: Colors.grey[300]),
              Expanded(
                child: _SummaryItem(
                  icon: Icons.attach_money,
                  value: '\$$totalEarned',
                  label: 'Tổng thu nhập',
                  color: Colors.green,
                ),
              ),
              Container(height: 40, width: 1, color: Colors.grey[300]),
              Expanded(
                child: _SummaryItem(
                  icon: Icons.trending_up,
                  value: '$avgConversions',
                  label: 'Trung bình',
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortOptions() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Text(
            'Sắp xếp theo:',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _SortChip(
                    label: 'Giới thiệu',
                    icon: Icons.people,
                    selected: _sortBy == 'referrals',
                    onTap: () => setState(() => _sortBy = 'referrals'),
                  ),
                  const SizedBox(width: 8),
                  _SortChip(
                    label: 'Thu nhập',
                    icon: Icons.attach_money,
                    selected: _sortBy == 'earnings',
                    onTap: () => setState(() => _sortBy = 'earnings'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<AffiliateLeaderboardEntry> _sortEntries(List<AffiliateLeaderboardEntry> entries) {
    final sorted = List<AffiliateLeaderboardEntry>.from(entries);
    switch (_sortBy) {
      case 'referrals':
        sorted.sort((a, b) => b.conversions.compareTo(a.conversions));
        break;
      case 'earnings':
        sorted.sort((a, b) => b.totalEarned.compareTo(a.totalEarned));
        break;
    }
    return sorted.asMap().entries.map((e) {
      return e.value.copyWith(rank: e.key + 1);
    }).toList();
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
              'Bộ lọc',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Thời gian',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _FilterChip(
                  label: 'Tất cả',
                  selected: _timeFilter == 'all',
                  onTap: () {
                    setState(() => _timeFilter = 'all');
                    Navigator.pop(context);
                  },
                ),
                _FilterChip(
                  label: 'Tháng này',
                  selected: _timeFilter == 'month',
                  onTap: () {
                    setState(() => _timeFilter = 'month');
                    Navigator.pop(context);
                  },
                ),
                _FilterChip(
                  label: 'Tuần này',
                  selected: _timeFilter == 'week',
                  onTap: () {
                    setState(() => _timeFilter = 'week');
                    Navigator.pop(context);
                  },
                ),
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

class _TopThreeCard extends StatelessWidget {
  final AffiliateLeaderboardEntry entry;
  final int rank;
  final bool isFirst;

  const _TopThreeCard({
    required this.entry,
    required this.rank,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isFirst ? 8 : 4),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _getRankColors(rank),
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: isFirst
                      ? [
                          BoxShadow(
                            color: _getRankColors(rank)[0].withValues(alpha: 0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  children: [
                    Container(
                      width: isFirst ? 60 : 48,
                      height: isFirst ? 60 : 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(isFirst ? 30 : 24),
                      ),
                      child: Center(
                        child: Text(
                          entry.displayName.isNotEmpty ? entry.displayName[0] : '?',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: isFirst ? 28 : 22,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      entry.displayName,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: isFirst ? 14 : 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${entry.conversions} refs',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: isFirst ? 13 : 11,
                      ),
                    ),
                    Text(
                      '\$${entry.totalEarned}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w600,
                        fontSize: isFirst ? 14 : 12,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getMedalColor(rank),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getMedalIcon(rank),
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '$rank',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Color> _getRankColors(int rank) {
    switch (rank) {
      case 1:
        return [const Color(0xFFFFD700), const Color(0xFFFFA500)];
      case 2:
        return [const Color(0xFFC0C0C0), const Color(0xFFA8A8A8)];
      case 3:
        return [const Color(0xFFCD7F32), const Color(0xFFB87333)];
      default:
        return [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)];
    }
  }

  Color _getMedalColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700);
      case 2:
        return const Color(0xFFC0C0C0);
      case 3:
        return const Color(0xFFCD7F32);
      default:
        return AppColors.primary;
    }
  }

  IconData _getMedalIcon(int rank) {
    switch (rank) {
      case 1:
        return Icons.emoji_events;
      case 2:
        return Icons.workspace_premium;
      case 3:
        return Icons.military_tech;
      default:
        return Icons.star;
    }
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _SummaryItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _SortChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _SortChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected ? Colors.white : Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : Colors.grey[700],
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
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

class _LeaderboardItem extends StatelessWidget {
  final AffiliateLeaderboardEntry entry;
  final int previousRank;

  const _LeaderboardItem({
    required this.entry,
    required this.previousRank,
  });

  @override
  Widget build(BuildContext context) {
    final rankChange = entry.rank - previousRank;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: entry.isCurrentUser
            ? AppColors.primary.withValues(alpha: 0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: entry.isCurrentUser
            ? Border.all(color: AppColors.primary, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _getRankBgColor(entry.rank),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '${entry.rank}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getRankTextColor(entry.rank),
                  ),
                ),
              ),
            ),
            if (rankChange != 0) ...[
              const SizedBox(width: 8),
              Icon(
                rankChange > 0 ? Icons.arrow_upward : Icons.arrow_downward,
                size: 14,
                color: rankChange > 0 ? Colors.green : Colors.red,
              ),
              Text(
                '${rankChange.abs()}',
                style: TextStyle(
                  fontSize: 12,
                  color: rankChange > 0 ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primary.withValues(alpha: 0.2),
              child: Text(
                entry.displayName.isNotEmpty ? entry.displayName[0] : '?',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.displayName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (entry.isCurrentUser) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Bạn',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${entry.conversions}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColors.primary,
              ),
            ),
            Text(
              'refs',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '\$${entry.totalEarned}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRankBgColor(int rank) {
    if (rank <= 10) return AppColors.primary.withValues(alpha: 0.1);
    if (rank <= 20) return Colors.orange.withValues(alpha: 0.1);
    return Colors.grey[100]!;
  }

  Color _getRankTextColor(int rank) {
    if (rank <= 10) return AppColors.primary;
    if (rank <= 20) return Colors.orange;
    return Colors.grey[600]!;
  }
}
