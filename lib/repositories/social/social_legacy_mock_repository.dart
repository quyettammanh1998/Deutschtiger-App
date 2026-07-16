import 'package:deutschtiger/data/social/social_legacy_mock_models.dart';

/// Mock data source for the gated, non-live challenges surface. No wired
/// backend contract in this phase — web hides its challenges route too. Kept
/// isolated from the live [FriendRepository] / [MessageRepository] so it is
/// obvious this path never claims production data.
///
/// Study-groups mock data was removed in the P12 wave-B deletion sweep along
/// with `groups_page.dart`/`group_detail_page.dart` — see
/// `docs/api-changelog.md` gap entry.
class SocialLegacyMockRepository {
  Future<List<Challenge>> getChallenges() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockChallenges;
  }

  static final List<Challenge> _mockChallenges = [
    Challenge(
      id: 'challenge-1',
      title: '7-Day Streak',
      titleVi: 'Chuỗi 7 ngày',
      challengerId: 'user2',
      challengerName: 'Maria',
      challengerAvatar: 'https://i.pravatar.cc/150?u=2',
      challengedId: 'user1',
      challengedName: 'You',
      type: 'streak',
      xpReward: 100,
      status: 'pending',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Challenge(
      id: 'challenge-2',
      title: 'XP Battle',
      titleVi: 'Trận XP',
      challengerId: 'user3',
      challengerName: 'Hans',
      challengerAvatar: 'https://i.pravatar.cc/150?u=3',
      challengedId: 'user1',
      challengedName: 'You',
      type: 'xp',
      xpReward: 150,
      status: 'accepted',
      acceptedAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ];
}
