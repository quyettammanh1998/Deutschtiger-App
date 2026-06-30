import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deutschtiger/core/theme/app_colors.dart';
import 'package:deutschtiger/screens/$1/$2.dart';
import 'package:deutschtiger/screens/$1/$2.dart';
import 'package:deutschtiger/screens/$1/$2.dart';
import 'package:deutschtiger/screens/$1/$2.dart';

class SocialScreen extends ConsumerWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(selectedTabProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _TabBar(selectedTab: selectedTab, onTabChanged: (index) {
            ref.read(socialNotifierProvider.notifier).setSelectedTab(index);
          }),
          Expanded(
            child: IndexedStack(
              index: selectedTab,
              children: const [
                _MomentsTab(),
                _GroupsTab(),
                _ChallengesTab(),
                _FriendsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: selectedTab == 0
          ? FloatingActionButton(
              onPressed: () => _showCreateMomentSheet(context, ref),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  void _showCreateMomentSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _CreateMomentSheet(),
    );
  }
}

class _TabBar extends StatelessWidget {
  final int selectedTab;
  final Function(int) onTabChanged;

  const _TabBar({required this.selectedTab, required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _TabButton(
              icon: Icons.dynamic_feed,
              label: 'Moments',
              isSelected: selectedTab == 0,
              onTap: () => onTabChanged(0),
            ),
            const SizedBox(width: 8),
            _TabButton(
              icon: Icons.group,
              label: 'Groups',
              isSelected: selectedTab == 1,
              onTap: () => onTabChanged(1),
            ),
            const SizedBox(width: 8),
            _TabButton(
              icon: Icons.emoji_events,
              label: 'Challenges',
              isSelected: selectedTab == 2,
              onTap: () => onTabChanged(2),
            ),
            const SizedBox(width: 8),
            _TabButton(
              icon: Icons.people,
              label: 'Friends',
              isSelected: selectedTab == 3,
              onTap: () => onTabChanged(3),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MomentsTab extends ConsumerWidget {
  const _MomentsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final momentsAsync = ref.watch(momentsProvider(1));

    return momentsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (moments) => MomentsFeed(moments: moments),
    );
  }
}

class _GroupsTab extends ConsumerWidget {
  const _GroupsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(studyGroupsProvider);

    return groupsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (groups) => StudyGroupsList(groups: groups),
    );
  }
}

class _ChallengesTab extends ConsumerWidget {
  const _ChallengesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challengesAsync = ref.watch(challengesProvider);

    return challengesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (challenges) => ChallengesList(challenges: challenges),
    );
  }
}

class _FriendsTab extends ConsumerWidget {
  const _FriendsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsAsync = ref.watch(friendsProvider);

    return friendsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (friends) => FriendsList(friends: friends),
    );
  }
}

class _CreateMomentSheet extends ConsumerStatefulWidget {
  const _CreateMomentSheet();

  @override
  ConsumerState<_CreateMomentSheet> createState() => _CreateMomentSheetState();
}

class _CreateMomentSheetState extends ConsumerState<_CreateMomentSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                'Share your progress',
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
          TextField(
            controller: _controller,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'What did you learn today?',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.image),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.emoji_emotions),
                onPressed: () {},
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  ref.read(socialNotifierProvider.notifier).createMoment(_controller.text);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Post'),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
