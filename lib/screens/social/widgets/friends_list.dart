import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:deutschtiger/core/theme/app_colors.dart';
import 'package:deutschtiger/data/social/friend_models.dart';

/// Compact friends list used by the Social hub's Friends tab. Tapping a row
/// opens the public profile (`/social/profile/:id`).
class FriendsList extends StatelessWidget {
  const FriendsList({super.key, required this.friends});

  final List<FriendProfile> friends;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final friend = friends[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            onTap: () => context.push('/social/profile/${friend.id}'),
            leading: Stack(
              children: [
                CircleAvatar(
                  backgroundImage: friend.avatarUrl.isNotEmpty
                      ? NetworkImage(friend.avatarUrl)
                      : null,
                  child: friend.avatarUrl.isEmpty
                      ? Text(friend.displayName.isNotEmpty ? friend.displayName[0] : '?')
                      : null,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: (friend.isOnline ?? false)
                          ? AppColors.success
                          : Colors.grey,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            title: Text(friend.displayName),
            subtitle: Row(
              children: [
                const Icon(Icons.local_fire_department, size: 14, color: Colors.orange),
                const SizedBox(width: 4),
                Text('${friend.currentStreak}'),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.chat),
              onPressed: () => context.push('/social/chat/${friend.id}'),
            ),
          ),
        );
      },
    );
  }
}
