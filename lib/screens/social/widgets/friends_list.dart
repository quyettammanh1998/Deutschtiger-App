import 'package:flutter/material.dart';
import 'package:deutschtiger/core/theme/app_colors.dart';
import 'package:deutschtiger/data/$1/$2.dart';

class FriendsList extends StatelessWidget {
  final List<Friend> friends;

  const FriendsList({super.key, required this.friends});

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
            leading: Stack(
              children: [
                CircleAvatar(
                  backgroundImage: friend.avatar.isNotEmpty
                      ? NetworkImage(friend.avatar)
                      : null,
                  child: friend.avatar.isEmpty
                      ? Text(friend.username[0])
                      : null,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: friend.status == 'online' ? AppColors.success : Colors.grey,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            title: Text(friend.username),
            subtitle: Row(
              children: [
                const Icon(Icons.star, size: 14, color: Colors.amber),
                const SizedBox(width: 4),
                Text('Level ${friend.level}'),
                const SizedBox(width: 12),
                Icon(Icons.local_fire_department, size: 14, color: Colors.orange[600]),
                const SizedBox(width: 4),
                Text('${friend.streakDays} days'),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.chat),
              onPressed: () {},
            ),
          ),
        );
      },
    );
  }
}
