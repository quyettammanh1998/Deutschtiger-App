import '../domain/social_models.dart';

class SocialRepository {
  Future<List<SocialMoment>> getMoments({int page = 1, int limit = 20}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _generateMoments(page, limit);
  }

  Future<List<StudyGroup>> getStudyGroups() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockGroups;
  }

  Future<List<Challenge>> getChallenges() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockChallenges;
  }

  Future<List<Friend>> getFriends() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockFriends;
  }

  Future<List<ChatConversation>> getConversations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockConversations;
  }

  Future<void> sendMessage(String conversationId, String content) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  Future<SocialMoment> createMoment(String content, {String? imageUrl}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return SocialMoment(
      id: 'moment-${DateTime.now().millisecondsSinceEpoch}',
      odlId: 'user1',
      userId: 'user1',
      username: 'currentUser',
      content: content,
      imageUrl: imageUrl ?? '',
      createdAt: DateTime.now(),
    );
  }

  Future<void> likeMoment(String momentId) async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  Future<void> joinGroup(String groupId) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  Future<void> createChallenge(String challengedId, String type) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> acceptChallenge(String challengeId) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  Future<void> addFriend(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  Future<Duel?> findDuelOpponent() async {
    await Future.delayed(const Duration(seconds: 1));
    return null; // Returns null if no opponent found
  }

  Future<Duel> createDuel(String opponentId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Duel(
      id: 'duel-${DateTime.now().millisecondsSinceEpoch}',
      player1Id: 'user1',
      player1Name: 'You',
      player1Avatar: '',
      player2Id: opponentId,
      player2Name: 'Opponent',
      player2Avatar: '',
      status: 'waiting',
      startedAt: DateTime.now(),
    );
  }

  static List<SocialMoment> _generateMoments(int page, int limit) {
    final startIndex = (page - 1) * limit;
    return List.generate(limit, (i) {
      final index = startIndex + i;
      return SocialMoment(
        id: 'moment-$index',
        odlId: 'user$index',
        userId: 'user$index',
        username: _usernames[index % _usernames.length],
        userAvatar: 'https://i.pravatar.cc/150?u=$index',
        content: _momentContents[index % _momentContents.length],
        imageUrl: index % 3 == 0 ? 'https://picsum.photos/seed/moment$index/400/300' : '',
        likes: 5 + (index * 3) % 50,
        comments: (index * 2) % 20,
        isLiked: index % 5 == 0,
        createdAt: DateTime.now().subtract(Duration(hours: index * 2)),
      );
    });
  }

  static const List<String> _usernames = [
    'Maria', 'Hans', 'Anna', 'Peter', 'Sophie',
    'Max', 'Lena', 'Paul', 'Emma', 'Felix',
  ];

  static const List<String> _momentContents = [
    'Just completed 50 days of German learning! Streak maintained! 🔥',
    'Finally understood the German cases! Nominativ, Akkusativ, Dativ, Genitiv - I got this!',
    'Watched my first German movie without subtitles! 🎉',
    'Had a conversation with a native German speaker today. It went well!',
    'Grammatik ist nicht so schwer wie ich dachte! 📚',
    'Achieved my weekly goal of 500 XP! On to next week!',
    'Just passed the A2 mock test with 85%! So happy!',
    'Starting to dream in German... is that normal? 🤔',
    'Made flashcards for all 100 most common German words.',
    'Just found an amazing German podcast for learning!',
  ];

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
      challengedAvatar: '',
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
      challengedAvatar: '',
      type: 'xp',
      xpReward: 150,
      status: 'accepted',
      acceptedAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ];

  static final List<Friend> _mockFriends = [
    const Friend(
      id: 'friend-1',
      odlId: 'user1',
      userId: 'user2',
      username: 'Maria',
      avatar: 'https://i.pravatar.cc/150?u=2',
      level: 12,
      totalXp: 5400,
      streakDays: 30,
      status: 'online',
      lastActiveAt: null,
    ),
    const Friend(
      id: 'friend-2',
      odlId: 'user1',
      userId: 'user3',
      username: 'Hans',
      avatar: 'https://i.pravatar.cc/150?u=3',
      level: 8,
      totalXp: 3200,
      streakDays: 15,
      status: 'offline',
      lastActiveAt: null,
    ),
  ];

  static final List<ChatConversation> _mockConversations = [
    ChatConversation(
      id: 'convo-1',
      participantId: 'user2',
      participantName: 'Maria',
      participantAvatar: 'https://i.pravatar.cc/150?u=2',
      unreadCount: 2,
      lastMessageAt: DateTime.now().subtract(const Duration(minutes: 30)),
      messages: [
        ChatMessage(
          id: 'msg-1',
          conversationId: 'convo-1',
          senderId: 'user2',
          receiverId: 'user1',
          content: 'Hallo! Wie geht es dir?',
          sentAt: DateTime.now().subtract(const Duration(hours: 1)),
          readAt: DateTime.now().subtract(const Duration(minutes: 45)),
        ),
        ChatMessage(
          id: 'msg-2',
          conversationId: 'convo-1',
          senderId: 'user2',
          receiverId: 'user1',
          content: 'Möchtest du morgen zusammen lernen?',
          sentAt: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
      ],
    ),
  ];
}
