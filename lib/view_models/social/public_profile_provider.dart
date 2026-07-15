import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/data/social/public_profile_model.dart';
import 'package:deutschtiger/data/social/friend_models.dart';
import 'social_repository_providers.dart';

/// Public profile aggregate for `/social/profile/:userId` (web `/u/:id`).
final publicProfileProvider = FutureProvider.autoDispose
    .family<SocialPublicProfile, String>((ref, userId) async {
      return ref.watch(publicProfileRepositoryProvider).getProfile(userId);
    });

/// Friendship relationship with the viewed profile, used to render the
/// correct add/accept/blocked affordance and to gate the block action.
final friendshipWithUserProvider = FutureProvider.autoDispose
    .family<FriendshipStatus, String>((ref, userId) async {
      return ref.watch(friendRepositoryProvider).getStatus(userId);
    });
