import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class DuelLobbyPage extends ConsumerStatefulWidget {
  const DuelLobbyPage({super.key});

  @override
  ConsumerState<DuelLobbyPage> createState() => _DuelLobbyPageState();
}

class _DuelLobbyPageState extends ConsumerState<DuelLobbyPage> {
  bool _isSearching = false;
  final List<_Opponent> _availableOpponents = _generateOpponents();

  static List<_Opponent> _generateOpponents() {
    final random = Random();
    final names = ['Maria', 'Hans', 'Anna', 'Peter', 'Sophie', 'Max', 'Lena', 'Paul', 'Emma', 'Felix'];
    return List.generate(
      10,
      (i) => _Opponent(
        id: 'opp-$i',
        name: names[i % names.length],
        level: 5 + random.nextInt(20),
        streak: 5 + random.nextInt(30),
        winRate: 40 + random.nextInt(50),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: const Text(
          'Duel Arena',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.tigerOrange, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          Expanded(
            child: _isSearching ? _buildSearchingView() : _buildOpponentList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.tigerOrange, AppColors.tigerOrangeDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.sports_kabaddi, size: 48, color: Colors.white),
          const SizedBox(height: 12),
          const Text(
            'Live Vocabulary Duel',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Battle in real-time vocabulary challenges!',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatBadge(Icons.star, '+50 XP'),
              const SizedBox(width: 24),
              _buildStatBadge(Icons.timer, '5 min'),
              const SizedBox(width: 24),
              _buildStatBadge(Icons.quiz, '10 Q'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildOpponentList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const Text(
          'Choose Opponent',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ..._availableOpponents.map((opp) => _OpponentCard(opponent: opp, onChallenge: _challengeOpponent)),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _startSearching,
            icon: const Icon(Icons.search),
            label: const Text('Find Random Opponent'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.tigerOrange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSearchingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation(AppColors.tigerOrange),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Finding opponent...',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Please wait while we match you',
            style: TextStyle(color: AppColors.mutedForeground),
          ),
          const SizedBox(height: 32),
          OutlinedButton(
            onPressed: _cancelSearch,
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _startSearching() {
    setState(() => _isSearching = true);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _isSearching) {
        _startDuel(_availableOpponents[DateTime.now().second % _availableOpponents.length]);
      }
    });
  }

  void _cancelSearch() {
    setState(() => _isSearching = false);
  }

  void _challengeOpponent(_Opponent opponent) {
    _startDuel(opponent);
  }

  void _startDuel(_Opponent opponent) {
    setState(() => _isSearching = false);
    context.push('/social/duel/play', extra: opponent);
  }
}

class _Opponent {
  final String id;
  final String name;
  final int level;
  final int streak;
  final int winRate;

  const _Opponent({
    required this.id,
    required this.name,
    required this.level,
    required this.streak,
    required this.winRate,
  });
}

class _OpponentCard extends StatelessWidget {
  final _Opponent opponent;
  final Function(_Opponent) onChallenge;

  const _OpponentCard({required this.opponent, required this.onChallenge});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.muted,
              child: Text(opponent.name[0], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(opponent.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text('Lv.${opponent.level}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.local_fire_department, size: 14, color: Colors.orange[600]),
                      const SizedBox(width: 2),
                      Text('${opponent.streak}d', style: const TextStyle(fontSize: 12)),
                      const SizedBox(width: 12),
                      Icon(Icons.emoji_events, size: 14, color: Colors.amber[600]),
                      const SizedBox(width: 2),
                      Text('${opponent.winRate}%', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => onChallenge(opponent),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tigerOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text('Challenge'),
            ),
          ],
        ),
      ),
    );
  }
}
