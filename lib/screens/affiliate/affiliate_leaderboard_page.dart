import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';

final affiliateLeaderboardProvider = FutureProvider<List<AffiliateLeaderboardEntry>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 300));
  return AffiliateLeaderboardRepository.getLeaderboard();
});

class AffiliateLeaderboardEntry {
  final int rank;
  final String oderId;
  final String userName;
  final String? avatarUrl;
  final int totalReferrals;
  final double totalEarnings;
  final int currentStreak;
  final bool isCurrentUser;

  const AffiliateLeaderboardEntry({
    required this.rank,
    required this.oderId,
    required this.userName,
    this.avatarUrl,
    required this.totalReferrals,
    required this.totalEarnings,
    required this.currentStreak,
    this.isCurrentUser = false,
  });
}

class AffiliateLeaderboardRepository {
  static List<AffiliateLeaderboardEntry> getLeaderboard() {
    return [
      const AffiliateLeaderboardEntry(
        rank: 1,
        oderId: 'user-elite-1',
        userName: 'Sarah M.',
        totalReferrals: 156,
        totalEarnings: 890.50,
        currentStreak: 365,
      ),
      const AffiliateLeaderboardEntry(
        rank: 2,
        oderId: 'user-elite-2',
        userName: 'Max W.',
        totalReferrals: 124,
        totalEarnings: 712.00,
        currentStreak: 289,
      ),
      const AffiliateLeaderboardEntry(
        rank: 3,
        oderId: 'user-elite-3',
        userName: 'Emma K.',
        totalReferrals: 98,
        totalEarnings: 545.25,
        currentStreak: 201,
      ),
      const AffiliateLeaderboardEntry(
        rank: 4,
        oderId: 'user-elite-4',
        userName: 'Lukas B.',
        totalReferrals: 87,
        totalEarnings: 467.75,
        currentStreak: 156,
      ),
      const AffiliateLeaderboardEntry(
        rank: 5,
        oderId: 'user-elite-5',
        userName: 'Anna S.',
        totalReferrals: 72,
        totalEarnings: 398.50,
        currentStreak: 134,
      ),
      const AffiliateLeaderboardEntry(
        rank: 6,
        oderId: 'user-elite-6',
        userName: 'Felix R.',
        totalReferrals: 65,
        totalEarnings: 356.25,
        currentStreak: 98,
      ),
      const AffiliateLeaderboardEntry(
        rank: 7,
        oderId: 'user-elite-7',
        userName: 'Sophie L.',
        totalReferrals: 58,
        totalEarnings: 312.00,
        currentStreak: 87,
      ),
      const AffiliateLeaderboardEntry(
        rank: 8,
        oderId: 'user-elite-8',
        userName: 'Jonas H.',
        totalReferrals: 51,
        totalEarnings: 278.50,
        currentStreak: 76,
      ),
      const AffiliateLeaderboardEntry(
        rank: 9,
        oderId: 'user-elite-9',
        userName: 'Mia T.',
        totalReferrals: 45,
        totalEarnings: 245.75,
        currentStreak: 65,
      ),
      const AffiliateLeaderboardEntry(
        rank: 10,
        oderId: 'user-elite-10',
        userName: 'Leon F.',
        totalReferrals: 42,
        totalEarnings: 228.00,
        currentStreak: 58,
      ),
      const AffiliateLeaderboardEntry(
        rank: 11,
        oderId: 'user-elite-11',
        userName: 'Laura D.',
        totalReferrals: 38,
        totalEarnings: 205.50,
        currentStreak: 45,
      ),
      const AffiliateLeaderboardEntry(
        rank: 12,
        oderId: 'user-elite-12',
        userName: 'Paul G.',
        totalReferrals: 35,
        totalEarnings: 189.25,
        currentStreak: 42,
      ),
      const AffiliateLeaderboardEntry(
        rank: 13,
        oderId: 'user-elite-13',
        userName: 'Emily N.',
        totalReferrals: 32,
        totalEarnings: 172.00,
        currentStreak: 38,
      ),
      const AffiliateLeaderboardEntry(
        rank: 14,
        oderId: 'user-elite-14',
        userName: 'Noah K.',
        totalReferrals: 28,
        totalEarnings: 151.75,
        currentStreak: 32,
      ),
      const AffiliateLeaderboardEntry(
        rank: 15,
        oderId: 'user-elite-15',
        userName: 'Hannah W.',
        totalReferrals: 25,
        totalEarnings: 135.50,
        currentStreak: 28,
      ),
      const AffiliateLeaderboardEntry(
        rank: 16,
        oderId: 'user-elite-16',
        userName: 'Erik M.',
        totalReferrals: 22,
        totalEarnings: 118.25,
        currentStreak: 25,
      ),
      const AffiliateLeaderboardEntry(
        rank: 17,
        oderId: 'user-elite-17',
        userName: 'Julia S.',
        totalReferrals: 19,
        totalEarnings: 102.00,
        currentStreak: 21,
      ),
      const AffiliateLeaderboardEntry(
        rank: 18,
        oderId: 'user-elite-18',
        userName: 'Liam B.',
        totalReferrals: 16,
        totalEarnings: 86.50,
        currentStreak: 18,
      ),
      const AffiliateLeaderboardEntry(
        rank: 19,
        oderId: 'user-elite-19',
        userName: 'Sofia R.',
        totalReferrals: 14,
        totalEarnings: 75.25,
        currentStreak: 15,
      ),
      const AffiliateLeaderboardEntry(
        rank: 20,
        oderId: 'user-elite-20',
        userName: 'Ben H.',
        totalReferrals: 12,
        totalEarnings: 64.00,
        currentStreak: 12,
      ),
    ];
  }
}

class AffiliateLeaderboardPage extends ConsumerStatefulWidget {
  const AffiliateLeaderboardPage({super.key});

  @override
  ConsumerState<AffiliateLeaderboardPage> createState() => _AffiliateLeaderboardPageState();
}

class _AffiliateLeaderboardPageState extends ConsumerState<AffiliateLeaderboardPage> {
  String _sortBy = 'referrals';
  String _timeFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final leaderboardAsync = ref.watch(affiliateLeaderboardProvider);

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
                onPressed: () => ref.invalidate(affiliateLeaderboardProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (entries) => _buildLeaderboardContent(entries),
      ),
    );
  }

  Widget _buildLeaderboardContent(List<AffiliateLeaderboardEntry> entries) {
    final sortedEntries = _sortEntries(entries);

    return CustomScrollView(
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
    final totalReferrals = entries.fold<int>(0, (sum, e) => sum + e.totalReferrals);
    final totalEarnings = entries.fold<double>(0, (sum, e) => sum + e.totalEarnings);
    final avgReferrals = entries.isNotEmpty ? (totalReferrals / entries.length).round() : 0;

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
                  value: '$totalReferrals',
                  label: 'Tổng giới thiệu',
                  color: AppColors.primary,
                ),
              ),
              Container(height: 40, width: 1, color: Colors.grey[300]),
              Expanded(
                child: _SummaryItem(
                  icon: Icons.attach_money,
                  value: '\$${totalEarnings.toStringAsFixed(0)}',
                  label: 'Tổng thu nhập',
                  color: Colors.green,
                ),
              ),
              Container(height: 40, width: 1, color: Colors.grey[300]),
              Expanded(
                child: _SummaryItem(
                  icon: Icons.trending_up,
                  value: '$avgReferrals',
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
                  const SizedBox(width: 8),
                  _SortChip(
                    label: 'Streak',
                    icon: Icons.local_fire_department,
                    selected: _sortBy == 'streak',
                    onTap: () => setState(() => _sortBy = 'streak'),
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
        sorted.sort((a, b) => b.totalReferrals.compareTo(a.totalReferrals));
        break;
      case 'earnings':
        sorted.sort((a, b) => b.totalEarnings.compareTo(a.totalEarnings));
        break;
      case 'streak':
        sorted.sort((a, b) => b.currentStreak.compareTo(a.currentStreak));
        break;
    }
    return sorted.asMap().entries.map((e) {
      final entry = e.value;
      return AffiliateLeaderboardEntry(
        rank: e.key + 1,
        oderId: entry.oderId,
        userName: entry.userName,
        avatarUrl: entry.avatarUrl,
        totalReferrals: entry.totalReferrals,
        totalEarnings: entry.totalEarnings,
        currentStreak: entry.currentStreak,
        isCurrentUser: entry.isCurrentUser,
      );
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
                            color: _getRankColors(rank)[0].withOpacity(0.4),
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
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(isFirst ? 30 : 24),
                      ),
                      child: Center(
                        child: Text(
                          entry.userName.isNotEmpty ? entry.userName[0] : '?',
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
                      entry.userName,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: isFirst ? 14 : 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${entry.totalReferrals} refs',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: isFirst ? 13 : 11,
                      ),
                    ),
                    Text(
                      '\$${entry.totalEarnings.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
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
        return [AppColors.primary, AppColors.primary.withOpacity(0.8)];
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
    final isTop20 = entry.rank <= 20;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: entry.isCurrentUser
            ? AppColors.primary.withOpacity(0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: entry.isCurrentUser
            ? Border.all(color: AppColors.primary, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              backgroundColor: AppColors.primary.withOpacity(0.2),
              child: Text(
                entry.userName.isNotEmpty ? entry.userName[0] : '?',
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
                      Text(
                        entry.userName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.local_fire_department,
                        size: 12,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${entry.currentStreak} days',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
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
              '${entry.totalReferrals}',
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
              '\$${entry.totalEarnings.toStringAsFixed(2)}',
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
    if (rank <= 10) return AppColors.primary.withOpacity(0.1);
    if (rank <= 20) return Colors.orange.withOpacity(0.1);
    return Colors.grey[100]!;
  }

  Color _getRankTextColor(int rank) {
    if (rank <= 10) return AppColors.primary;
    if (rank <= 20) return Colors.orange;
    return Colors.grey[600]!;
  }
}
