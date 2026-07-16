import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/repositories/social/friend_repository.dart';
import 'package:deutschtiger/repositories/social/message_repository.dart';
import 'package:deutschtiger/repositories/social/public_profile_repository.dart';
import 'package:deutschtiger/repositories/social/unread_counts_repository.dart';
import 'package:deutschtiger/view_models/providers.dart';

/// DI wiring for the Social domain repositories. Kept in its own file so
/// friends/messages providers below stay focused on their own state.
///
/// `momentRepositoryProvider`/`announcementRepositoryProvider` (old
/// `repositories/social/announcement_repository.dart`) were removed in the
/// P12 wave-B deletion sweep along with `moments_page.dart`/
/// `announcements_page.dart` — the announcement banner now uses the new
/// `lib/repositories/announcements/announcement_repository.dart` provider.

final friendRepositoryProvider = Provider<FriendRepository>((ref) {
  return FriendRepository(ref.watch(apiClientProvider));
});

final messageRepositoryProvider = Provider<MessageRepository>((ref) {
  return MessageRepository(ref.watch(apiClientProvider));
});

final publicProfileRepositoryProvider = Provider<PublicProfileRepository>((
  ref,
) {
  return PublicProfileRepository(ref.watch(apiClientProvider));
});

final unreadCountsRepositoryProvider = Provider<UnreadCountsRepository>((ref) {
  return UnreadCountsRepository(ref.watch(apiClientProvider));
});
