import 'package:deutschtiger/data/social/social_legacy_mock_models.dart';

/// Mock data source for gated, non-live social surfaces (study groups,
/// challenges). Neither has a wired backend contract in this phase and the
/// web app has no live UI for groups either — see
/// `docs/api-changelog.md`. Kept isolated from the live [FriendRepository] /
/// [MessageRepository] / [MomentRepository] so it is obvious this path never
/// claims production data.
class SocialLegacyMockRepository {
  Future<List<StudyGroup>> getStudyGroups() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockGroups;
  }

  Future<List<Challenge>> getChallenges() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockChallenges;
  }

  static final List<StudyGroup> _mockGroups = [
    const StudyGroup(
      id: 'group-1',
      name: 'A2 Learners',
      description: 'Study group for A2 level learners',
      level: 'A2',
      memberCount: 45,
      maxMembers: 100,
      isJoined: true,
    ),
    const StudyGroup(
      id: 'group-2',
      name: 'Berlin Culture',
      description: 'Learn about German culture through Berlin',
      level: 'B1',
      memberCount: 32,
      maxMembers: 50,
      isJoined: false,
    ),
    const StudyGroup(
      id: 'group-3',
      name: 'Goethe B1 Prep',
      description: 'Prepare for Goethe B1 exam together',
      level: 'B1',
      memberCount: 78,
      maxMembers: 100,
      isJoined: false,
    ),
  ];

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
