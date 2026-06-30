import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';

class GroupDetailPage extends ConsumerStatefulWidget {
  final String groupId;

  const GroupDetailPage({super.key, required this.groupId});

  @override
  ConsumerState<GroupDetailPage> createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends ConsumerState<GroupDetailPage> with SingleTickerProviderStateMixin {
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
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.tigerOrange,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                _getGroupName(),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.tigerOrange, AppColors.tigerOrangeDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.group, size: 64, color: Colors.white54),
                ),
              ),
            ),
            actions: [
              IconButton(icon: const Icon(Icons.share), onPressed: () {}),
              IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
            ],
          ),
          SliverToBoxAdapter(
            child: _buildHeader(),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: AppColors.tigerOrange,
                unselectedLabelColor: AppColors.mutedForeground,
                indicatorColor: AppColors.tigerOrange,
                tabs: const [
                  Tab(text: 'Posts'),
                  Tab(text: 'Members'),
                  Tab(text: 'About'),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPostsTab(),
                _buildMembersTab(),
                _buildAboutTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getGroupName() {
    final names = {
      'group-1': 'A2 Learners',
      'group-2': 'Berlin Culture',
      'group-3': 'Goethe B1 Prep',
    };
    return names[widget.groupId] ?? 'Study Group';
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              _StatItem(value: '45', label: 'Members', icon: Icons.people),
              const SizedBox(width: 24),
              _StatItem(value: '128', label: 'Posts', icon: Icons.article),
              const SizedBox(width: 24),
              _StatItem(value: 'A2', label: 'Level', icon: Icons.school),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat),
                  label: const Text('Chat'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.tigerOrange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.exit_to_app),
                label: const Text('Leave'),
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.destructive),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPostsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) => _GroupPostCard(
        post: _mockPosts[index],
      ),
    );
  }

  Widget _buildMembersTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _mockMembers.length,
      itemBuilder: (context, index) => _MemberTile(member: _mockMembers[index]),
    );
  }

  Widget _buildAboutTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Text(
                  'Study group for A2 level learners. We meet daily to practice German vocabulary, grammar, and conversation skills.',
                  style: TextStyle(color: AppColors.mutedForeground),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Rules', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                _RuleItem(text: 'Be respectful to all members'),
                _RuleItem(text: 'Practice at least 30 minutes daily'),
                _RuleItem(text: 'Participate in weekly challenges'),
                _RuleItem(text: 'Help others when you can'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Created', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Text('January 15, 2024', style: TextStyle(color: AppColors.mutedForeground)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static final List<_MockPost> _mockPosts = [
    _MockPost(user: 'Maria', content: 'Just completed my daily practice! 🎉 Feeling more confident with Akkusativ!'),
    _MockPost(user: 'Hans', content: 'Anyone want to do a video call practice session tomorrow?'),
    _MockPost(user: 'Anna', content: 'Great resource for A2 grammar: [link] Check it out!'),
    _MockPost(user: 'Peter', content: 'Week 4 streak! Keep going everyone! 🔥'),
    _MockPost(user: 'Sophie', content: 'Can someone help me with "sich erholen"? I keep mixing it up.'),
  ];

  static final List<_MockMember> _mockMembers = [
    _MockMember(name: 'Maria', level: 15, streak: 30, isAdmin: true),
    _MockMember(name: 'Hans', level: 12, streak: 25, isAdmin: false),
    _MockMember(name: 'Anna', level: 10, streak: 20, isAdmin: false),
    _MockMember(name: 'Peter', level: 8, streak: 15, isAdmin: false),
    _MockMember(name: 'Sophie', level: 6, streak: 10, isAdmin: false),
  ];
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _StatItem({required this.value, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.tigerOrange),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 12, color: AppColors.mutedForeground)),
      ],
    );
  }
}

class _GroupPostCard extends StatelessWidget {
  final _MockPost post;

  const _GroupPostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.muted,
                  child: Text(post.user[0], style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.user, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text('2h ago', style: TextStyle(fontSize: 12, color: AppColors.mutedForeground)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(post.content),
          ],
        ),
      ),
    );
  }
}

class _MemberTile extends StatelessWidget {
  final _MockMember member;

  const _MemberTile({required this.member});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.muted,
              child: Text(member.name[0], style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            if (member.isAdmin)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(color: AppColors.tigerOrange, shape: BoxShape.circle),
                  child: const Icon(Icons.star, size: 12, color: Colors.white),
                ),
              ),
          ],
        ),
        title: Row(
          children: [
            Text(member.name, style: const TextStyle(fontWeight: FontWeight.w600)),
            if (member.isAdmin) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.tigerOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('Admin', style: TextStyle(fontSize: 10, color: AppColors.tigerOrange)),
              ),
            ],
          ],
        ),
        subtitle: Row(
          children: [
            Text('Lv.${member.level}', style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 12),
            Icon(Icons.local_fire_department, size: 12, color: Colors.orange[600]),
            const SizedBox(width: 2),
            Text('${member.streak}d streak', style: const TextStyle(fontSize: 12)),
          ],
        ),
        trailing: IconButton(icon: const Icon(Icons.chat), onPressed: () {}),
      ),
    );
  }
}

class _RuleItem extends StatelessWidget {
  final String text;

  const _RuleItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, size: 16, color: AppColors.success),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _TabBarDelegate(this.tabBar);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Colors.white, child: tabBar);
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}

class _MockPost {
  final String user;
  final String content;

  _MockPost({required this.user, required this.content});
}

class _MockMember {
  final String name;
  final int level;
  final int streak;
  final bool isAdmin;

  _MockMember({required this.name, required this.level, required this.streak, required this.isAdmin});
}
