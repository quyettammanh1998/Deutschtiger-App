import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';
import 'package:deutschtiger/data/social/social_legacy_mock_models.dart';
import 'package:deutschtiger/view_models/social/social_legacy_provider.dart';

class ChallengesPage extends ConsumerStatefulWidget {
  const ChallengesPage({super.key});

  @override
  ConsumerState<ChallengesPage> createState() => _ChallengesPageState();
}

class _ChallengesPageState extends ConsumerState<ChallengesPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final challengesAsync = ref.watch(challengesProvider);
    final tokens = context.tokens;

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        backgroundColor: tokens.background,
        title: const Text(
          'Challenges',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.tigerOrange, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: tokens.mutedForeground,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: AppColors.tigerOrange,
                borderRadius: BorderRadius.circular(12),
              ),
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'Pending'),
                Tab(text: 'Active'),
                Tab(text: 'Completed'),
              ],
            ),
          ),
          Expanded(
            child: challengesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (challenges) {
                final pending = challenges.where((c) => c.status == 'pending').toList();
                final active = challenges.where((c) => c.status == 'accepted').toList();
                final completed = challenges.where((c) => c.status == 'completed').toList();

                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildChallengeList(pending, 'pending'),
                    _buildChallengeList(active, 'accepted'),
                    _buildChallengeList(completed, 'completed'),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.tigerOrange,
        onPressed: () => _showCreateChallengeSheet(context),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Send Challenge', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildChallengeList(List<Challenge> challenges, String tab) {
    if (challenges.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              tab == 'pending' ? Icons.hourglass_empty : (tab == 'accepted' ? Icons.sports : Icons.emoji_events),
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              tab == 'pending'
                  ? 'No pending challenges'
                  : (tab == 'accepted' ? 'No active challenges' : 'No completed challenges'),
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            const SizedBox(height: 8),
            if (tab == 'pending')
              Text(
                'Challenge a friend!',
                style: TextStyle(color: Colors.grey[500]),
              ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: challenges.length,
      itemBuilder: (context, index) => _ChallengeCard(
        challenge: challenges[index],
        onAccept: tab == 'pending' ? () => _acceptChallenge(challenges[index]) : null,
        onDecline: tab == 'pending' ? () => _declineChallenge(challenges[index]) : null,
      ),
    );
  }

  void _acceptChallenge(Challenge challenge) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Challenge accepted!')),
    );
  }

  void _declineChallenge(Challenge challenge) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Challenge declined')),
    );
  }

  void _showCreateChallengeSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _CreateChallengeSheet(),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  final Challenge challenge;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;

  const _ChallengeCard({
    required this.challenge,
    this.onAccept,
    this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _PlayerInfo(
                    name: challenge.challengerName,
                    avatar: challenge.challengerAvatar,
                    isChallenger: true,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.tigerOrange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(
                        challenge.titleVi,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.tigerOrange,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, size: 16, color: AppColors.tigerOrange),
                          const SizedBox(width: 4),
                          Text(
                            '+${challenge.xpReward} XP',
                            style: const TextStyle(
                              color: AppColors.tigerOrange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _PlayerInfo(
                    name: challenge.challengedName,
                    avatar: challenge.challengedAvatar,
                    isChallenger: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _StatusChip(status: challenge.status),
                const Spacer(),
                if (challenge.createdAt != null)
                  Text(
                    _formatTime(challenge.createdAt!),
                    style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                  ),
              ],
            ),
            if (onAccept != null || onDecline != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  if (onDecline != null)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onDecline,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: tokens.destructive,
                          side: BorderSide(color: tokens.destructive),
                        ),
                        child: const Text('Decline'),
                      ),
                    ),
                  if (onDecline != null && onAccept != null) const SizedBox(width: 12),
                  if (onAccept != null)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onAccept,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.tigerOrange,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Accept'),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _PlayerInfo extends StatelessWidget {
  final String name;
  final String avatar;
  final bool isChallenger;

  const _PlayerInfo({
    required this.name,
    required this.avatar,
    required this.isChallenger,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundImage: avatar.isNotEmpty ? NetworkImage(avatar) : null,
              backgroundColor: tokens.muted,
              child: avatar.isEmpty ? Text(name[0].toUpperCase(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)) : null,
            ),
            if (isChallenger)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.tigerOrange,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_forward, size: 12, color: Colors.white),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          textAlign: TextAlign.center,
        ),
        Text(
          isChallenger ? 'Challenger' : 'Challenged',
          style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case 'pending':
        color = Colors.orange;
        label = 'Pending';
        icon = Icons.hourglass_empty;
        break;
      case 'accepted':
        color = AppColors.tigerOrange;
        label = 'In Progress';
        icon = Icons.play_circle;
        break;
      case 'completed':
        color = context.tokens.success;
        label = 'Completed';
        icon = Icons.check_circle;
        break;
      default:
        color = Colors.grey;
        label = status;
        icon = Icons.circle;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _CreateChallengeSheet extends StatefulWidget {
  const _CreateChallengeSheet();

  @override
  State<_CreateChallengeSheet> createState() => _CreateChallengeSheetState();
}

class _CreateChallengeSheetState extends State<_CreateChallengeSheet> {
  String _selectedType = 'xp';
  String _selectedFriend = 'Maria';

  final _challengeTypes = [
    {'id': 'xp', 'title': 'XP Battle', 'titleVi': 'Trận XP', 'reward': 150},
    {'id': 'streak', 'title': '7-Day Streak', 'titleVi': 'Chuỗi 7 ngày', 'reward': 100},
    {'id': 'vocab', 'title': 'Vocabulary', 'titleVi': 'Từ vựng', 'reward': 200},
  ];

  final _friends = ['Maria', 'Hans', 'Anna', 'Peter'];

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final selectedChallenge = _challengeTypes.firstWhere((t) => t['id'] == _selectedType);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Send Challenge',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Challenge Type', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _challengeTypes.map((type) {
              final isSelected = type['id'] == _selectedType;
              return ChoiceChip(
                label: Text(type['titleVi'] as String),
                selected: isSelected,
                onSelected: (_) => setState(() => _selectedType = type['id'] as String),
                selectedColor: AppColors.tigerOrange.withValues(alpha: 0.2),
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.tigerOrange : tokens.foreground,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text('Challenge Friend', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _friends.map((friend) {
              final isSelected = friend == _selectedFriend;
              return ChoiceChip(
                label: Text(friend),
                selected: isSelected,
                onSelected: (_) => setState(() => _selectedFriend = friend),
                selectedColor: AppColors.tigerOrange.withValues(alpha: 0.2),
                avatar: CircleAvatar(
                  backgroundColor: isSelected ? AppColors.tigerOrange : tokens.muted,
                  child: Text(friend[0], style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : tokens.foreground)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.tigerOrange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.emoji_events, color: AppColors.tigerOrange),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Reward', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text('+${selectedChallenge['reward']} XP for winner', style: TextStyle(color: tokens.mutedForeground, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Challenge sent to $_selectedFriend!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tigerOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Challenge $_selectedFriend', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
