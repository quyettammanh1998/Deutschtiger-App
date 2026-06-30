import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import 'package:deutschtiger/data/games/game_models.dart';

/// Game Hub - Main games listing screen với thiết kế UI tốt hơn.
class GameHubScreen extends StatefulWidget {
  const GameHubScreen({super.key});

  @override
  State<GameHubScreen> createState() => _GameHubScreenState();
}

class _GameHubScreenState extends State<GameHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  GameDifficulty? _selectedDifficulty;

  // Mock user stats
  final _userStats = {
    'totalGames': 42,
    'totalScore': 2850,
    'streak': 5,
    'level': 'A1',
  };

  // Game categories
  static const _categories = [
    {'id': 'all', 'name': 'Tất cả', 'icon': Icons.apps},
    {'id': 'vocabulary', 'name': 'Từ vựng', 'icon': Icons.book},
    {'id': 'grammar', 'name': 'Ngữ pháp', 'icon': Icons.school},
    {'id': 'listening', 'name': 'Nghe', 'icon': Icons.headphones},
    {'id': 'speaking', 'name': 'Nói', 'icon': Icons.mic},
    {'id': 'writing', 'name': 'Viết', 'icon': Icons.edit},
  ];

  static const _categoryGameTypes = {
    'vocabulary': [
      GameType.article,
      GameType.matching,
      GameType.wordSprint,
      GameType.flashcard,
    ],
    'grammar': [
      GameType.fillBlank,
      GameType.wordOrder,
      GameType.cases,
      GameType.conjugation,
    ],
    'listening': [
      GameType.listening,
    ],
    'speaking': [
      GameType.speaking,
      GameType.pronunciation,
    ],
    'writing': [
      GameType.writingWord,
      GameType.writingSentence,
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<GameMode> get _filteredGames {
    var games = GameMode.allModes.toList();

    // Filter by category
    final categoryId = _categories[_tabController.index]['id'] as String;
    if (categoryId != 'all') {
      final categoryTypes = _categoryGameTypes[categoryId] ?? [];
      games = games.where((g) => categoryTypes.contains(g.type)).toList();
    }

    // Filter by search
    if (_searchQuery.isNotEmpty) {
      games = games
          .where((g) =>
              g.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              g.description.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Filter by difficulty
    if (_selectedDifficulty != null) {
      games = games.where((g) => g.difficulty == _selectedDifficulty).toList();
    }

    return games;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // User stats
            _buildUserStats(),

            // Search bar
            _buildSearchBar(),

            // Category tabs
            _buildCategoryTabs(),

            // Filter chips
            _buildFilterChips(),

            // Game grid
            Expanded(
              child: _buildGameGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          // Back button
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.foreground),
              onPressed: () => context.pop(),
            ),
          ),
          const SizedBox(width: 16),
          // Title
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trò chơi học tiếng Đức',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.foreground,
                  ),
                ),
                Text(
                  '17 games để luyện tập',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
          // Random game button
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.tigerOrange],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.shuffle, color: Colors.white),
              onPressed: () {
                final randomGame = GameMode.allModes[
                    DateTime.now().millisecondsSinceEpoch %
                        GameMode.allModes.length];
                _navigateToGame(context, randomGame.type);
              },
              tooltip: 'Chơi ngẫu nhiên',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserStats() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.tigerOrange.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatBadge(
            icon: Icons.emoji_events,
            value: '${_userStats['totalScore']}',
            label: 'Điểm',
            color: Colors.amber,
          ),
          _StatBadge(
            icon: Icons.games,
            value: '${_userStats['totalGames']}',
            label: 'Đã chơi',
            color: Colors.blue,
          ),
          _StatBadge(
            icon: Icons.local_fire_department,
            value: '${_userStats['streak']}',
            label: 'Streak',
            color: Colors.orange,
          ),
          _StatBadge(
            icon: Icons.school,
            value: '${_userStats['level']}',
            label: 'Cấp độ',
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          onChanged: (value) => setState(() => _searchQuery = value),
          decoration: InputDecoration(
            hintText: 'Tìm kiếm game...',
            hintStyle: TextStyle(color: Colors.grey.shade400),
            prefixIcon: const Icon(Icons.search, color: AppColors.mutedForeground),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => setState(() => _searchQuery = ''),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      height: 50,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.mutedForeground,
        indicatorColor: AppColors.primary,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
        tabAlignment: TabAlignment.start,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        tabs: _categories.map((cat) {
          return Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  cat['icon'] as IconData,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(cat['name'] as String),
              ],
            ),
          );
        }).toList(),
        onTap: (_) => setState(() {}),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        children: [
          const Text(
            'Độ khó:',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.mutedForeground,
            ),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Dễ',
            color: Colors.green,
            isSelected: _selectedDifficulty == GameDifficulty.easy,
            onTap: () => setState(() {
              _selectedDifficulty = _selectedDifficulty == GameDifficulty.easy
                  ? null
                  : GameDifficulty.easy;
            }),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Trung bình',
            color: Colors.orange,
            isSelected: _selectedDifficulty == GameDifficulty.medium,
            onTap: () => setState(() {
              _selectedDifficulty = _selectedDifficulty == GameDifficulty.medium
                  ? null
                  : GameDifficulty.medium;
            }),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Khó',
            color: Colors.red,
            isSelected: _selectedDifficulty == GameDifficulty.hard,
            onTap: () => setState(() {
              _selectedDifficulty = _selectedDifficulty == GameDifficulty.hard
                  ? null
                  : GameDifficulty.hard;
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildGameGrid() {
    final games = _filteredGames;

    if (games.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'Không tìm thấy game',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => setState(() {
                _searchQuery = '';
                _selectedDifficulty = null;
              }),
              child: const Text('Xóa bộ lọc'),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.95,
      ),
      itemCount: games.length,
      itemBuilder: (context, index) {
        final game = games[index];
        return _GameCard(
          game: game,
          onTap: () => _navigateToGame(context, game.type),
        );
      },
    );
  }

  void _navigateToGame(BuildContext context, GameType type) {
    switch (type) {
      case GameType.article:
        context.push('/games/article');
        break;
      case GameType.wordSprint:
        context.push('/games/word-sprint');
        break;
      case GameType.matching:
        context.push('/games/matching');
        break;
      case GameType.fillBlank:
        context.push('/games/fill-blank');
        break;
      case GameType.listening:
        context.push('/games/listening');
        break;
      case GameType.flashcard:
        context.push('/games/flashcard');
        break;
      case GameType.runner:
        context.push('/games/runner');
        break;
      case GameType.typingSprint:
        context.push('/games/typing-sprint');
        break;
      case GameType.writingWord:
        context.push('/games/writing');
        break;
      case GameType.wordOrder:
        context.push('/games/word-order');
        break;
      case GameType.writingSentence:
        context.push('/games/writing-sentence');
        break;
      case GameType.speaking:
        context.push('/games/speaking');
        break;
      case GameType.cases:
        context.push('/games/cases');
        break;
      case GameType.conjugation:
        context.push('/games/konjugation');
        break;
      case GameType.pronunciation:
        context.push('/games/pronunciation');
        break;
      case GameType.conversation:
        context.push('/games/conversation');
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Game đang được phát triển!')),
        );
    }
  }
}

class _StatBadge extends StatelessWidget {
  const _StatBadge({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.mutedForeground,
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : color,
          ),
        ),
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  const _GameCard({
    required this.game,
    required this.onTap,
  });

  final GameMode game;
  final VoidCallback onTap;

  IconData get _icon {
    switch (game.iconName) {
      case 'book':
        return Icons.book;
      case 'flash_on':
        return Icons.flash_on;
      case 'link':
        return Icons.link;
      case 'edit_note':
        return Icons.edit_note;
      case 'headphones':
        return Icons.headphones;
      case 'style':
        return Icons.style;
      case 'directions_run':
        return Icons.directions_run;
      case 'keyboard':
        return Icons.keyboard;
      case 'edit':
        return Icons.edit;
      case 'swap_vert':
        return Icons.swap_vert;
      case 'mic':
        return Icons.mic;
      case 'school':
        return Icons.school;
      case 'record_voice_over':
        return Icons.record_voice_over;
      case 'chat':
        return Icons.chat;
      default:
        return Icons.games;
    }
  }

  Color get _difficultyColor {
    switch (game.difficulty) {
      case GameDifficulty.easy:
        return Colors.green;
      case GameDifficulty.medium:
        return Colors.orange;
      case GameDifficulty.hard:
        return Colors.red;
    }
  }

  String get _difficultyLabel {
    switch (game.difficulty) {
      case GameDifficulty.easy:
        return 'Dễ';
      case GameDifficulty.medium:
        return 'TB';
      case GameDifficulty.hard:
        return 'Khó';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon header
            Container(
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(game.color).withValues(alpha: 0.15),
                    Color(game.color).withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  // Icon
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(game.color).withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _icon,
                        color: Color(game.color),
                        size: 32,
                      ),
                    ),
                  ),
                  // Difficulty badge
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _difficultyColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _difficultyLabel,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // Timer badge
                  if (game.timeLimit != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.timer,
                              size: 12,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${game.timeLimit}s',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.foreground,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        game.description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.mutedForeground,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Play button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Color(game.color).withValues(alpha: 0.1),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.play_circle_fill,
                    color: Color(game.color),
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Chơi ngay',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(game.color),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
