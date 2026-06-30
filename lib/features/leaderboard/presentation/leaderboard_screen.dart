import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';

/// Leaderboard entry model.
class LeaderboardEntry {
  final int rank;
  final String id;
  final String displayName;
  final String? avatarUrl;
  final int xp;
  final int streak;
  final bool isCurrentUser;

  const LeaderboardEntry({
    required this.rank,
    required this.id,
    required this.displayName,
    this.avatarUrl,
    required this.xp,
    required this.streak,
    this.isCurrentUser = false,
  });
}

/// Leaderboard type enum.
enum LeaderboardType { weekly, monthly, allTime }

class LeaderboardTypeNotifier extends Notifier<LeaderboardType> {
  @override
  LeaderboardType build() => LeaderboardType.weekly;
  
  void setType(LeaderboardType type) => state = type;
}

final leaderboardTypeProvider = NotifierProvider<LeaderboardTypeNotifier, LeaderboardType>(
  LeaderboardTypeNotifier.new,
);

/// Mock leaderboard provider.
final leaderboardProvider = FutureProvider<List<LeaderboardEntry>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 300));
  return const [
    LeaderboardEntry(rank: 1, id: '1', displayName: 'Nguyễn Văn A', xp: 15420, streak: 45),
    LeaderboardEntry(rank: 2, id: '2', displayName: 'Trần Thị B', xp: 12850, streak: 38),
    LeaderboardEntry(rank: 3, id: '3', displayName: 'Lê Minh C', xp: 11200, streak: 42),
    LeaderboardEntry(rank: 4, id: '4', displayName: 'Phạm Hoàng D', xp: 9850, streak: 30),
    LeaderboardEntry(rank: 5, id: '5', displayName: 'Hoàng Thu E', xp: 8720, streak: 25),
    LeaderboardEntry(rank: 6, id: '6', displayName: 'Bùi Đức F', xp: 7540, streak: 20),
    LeaderboardEntry(rank: 7, id: '7', displayName: 'Đặng Lan G', xp: 6200, streak: 18),
    LeaderboardEntry(rank: 8, id: '8', displayName: 'Vũ Thanh H', xp: 5400, streak: 15),
    LeaderboardEntry(rank: 9, id: '9', displayName: 'Trương Mai I', xp: 4800, streak: 12),
    LeaderboardEntry(rank: 10, id: '10', displayName: 'Ngô Hùng J', xp: 4200, streak: 10),
    LeaderboardEntry(rank: 11, id: 'me', displayName: 'Bạn', xp: 3650, streak: 7, isCurrentUser: true),
  ];
});

/// Màn leaderboard.
class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = ref.watch(leaderboardTypeProvider);
    final leaderboard = ref.watch(leaderboardProvider);

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: const Text(
          'Bảng xếp hạng',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.tigerOrange, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: _TypeSelector(
              selected: type,
              onChanged: (t) => ref.read(leaderboardTypeProvider.notifier).setType(t),
            ),
          ),
          Expanded(
            child: leaderboard.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Lỗi: $e')),
              data: (entries) => ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return _LeaderboardTile(entry: entry);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeSelector extends StatelessWidget {
  const _TypeSelector({required this.selected, required this.onChanged});

  final LeaderboardType selected;
  final ValueChanged<LeaderboardType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.muted,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: LeaderboardType.values.map((type) {
          final isSelected = type == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(type),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getLabel(type),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppColors.tigerOrange : AppColors.mutedForeground,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getLabel(LeaderboardType type) {
    switch (type) {
      case LeaderboardType.weekly:
        return 'Tuần';
      case LeaderboardType.monthly:
        return 'Tháng';
      case LeaderboardType.allTime:
        return 'Mọi thời đại';
    }
  }
}

class _LeaderboardTile extends StatelessWidget {
  const _LeaderboardTile({required this.entry});

  final LeaderboardEntry entry;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: entry.isCurrentUser ? AppColors.tigerOrange.withValues(alpha: 0.1) : null,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            SizedBox(width: 40, child: _RankBadge(rank: entry.rank)),
            const SizedBox(width: 12),
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.muted,
              child: Text(entry.displayName.isNotEmpty ? entry.displayName[0].toUpperCase() : '?', style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(entry.displayName, style: TextStyle(fontWeight: FontWeight.w600, color: entry.isCurrentUser ? AppColors.tigerOrange : null)),
                      if (entry.isCurrentUser) ...[const SizedBox(width: 4), const Text('👤', style: TextStyle(fontSize: 12))],
                    ],
                  ),
                  Text('${entry.streak} ngày streak', style: TextStyle(fontSize: 12, color: AppColors.mutedForeground)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${entry.xp}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('XP', style: TextStyle(fontSize: 12, color: AppColors.mutedForeground)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RankBadge extends StatelessWidget {
  const _RankBadge({required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    if (rank <= 3) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(color: _getMedalColor(rank), shape: BoxShape.circle),
        child: Center(child: Text('$rank', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
      );
    }
    return Text('#$rank', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.mutedForeground));
  }

  Color _getMedalColor(int rank) {
    switch (rank) {
      case 1: return Colors.amber;
      case 2: return Colors.grey.shade400;
      case 3: return Colors.brown.shade400;
      default: return AppColors.mutedForeground;
    }
  }
}
