import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/repositories/social/friend_repository.dart';
import 'package:deutschtiger/repositories/social/message_repository.dart';
import 'package:deutschtiger/repositories/social/moment_repository.dart';
import 'package:deutschtiger/repositories/social/announcement_repository.dart';
import 'package:deutschtiger/repositories/social/public_profile_repository.dart';
import 'package:deutschtiger/repositories/social/unread_counts_repository.dart';
import 'package:deutschtiger/view_models/providers.dart';

/// DI wiring for the Social domain repositories. Kept in its own file so
/// friends/messages/moments providers below stay focused on their own state.

final friendRepositoryProvider = Provider<FriendRepository>((ref) {
  return FriendRepository(ref.watch(apiClientProvider));
});

final messageRepositoryProvider = Provider<MessageRepository>((ref) {
  return MessageRepository(ref.watch(apiClientProvider));
});

final momentRepositoryProvider = Provider<MomentRepository>((ref) {
  return MomentRepository(ref.watch(apiClientProvider));
});

final announcementRepositoryProvider = Provider<AnnouncementRepository>((ref) {
  return AnnouncementRepository(ref.watch(apiClientProvider));
});

final publicProfileRepositoryProvider = Provider<PublicProfileRepository>((
  ref,
) {
  return PublicProfileRepository(ref.watch(apiClientProvider));
});

final unreadCountsRepositoryProvider = Provider<UnreadCountsRepository>((ref) {
  return UnreadCountsRepository(ref.watch(apiClientProvider));
});
