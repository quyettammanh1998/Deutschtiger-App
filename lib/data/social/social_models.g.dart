// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SocialMoment _$SocialMomentFromJson(Map<String, dynamic> json) =>
    _SocialMoment(
      id: json['id'] as String,
      odlId: json['odlId'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      userAvatar: json['userAvatar'] as String? ?? '',
      content: json['content'] as String,
      imageUrl: json['imageUrl'] as String? ?? '',
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      comments: (json['comments'] as num?)?.toInt() ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
      likedByUsers:
          (json['likedByUsers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$SocialMomentToJson(_SocialMoment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'odlId': instance.odlId,
      'userId': instance.userId,
      'username': instance.username,
      'userAvatar': instance.userAvatar,
      'content': instance.content,
      'imageUrl': instance.imageUrl,
      'likes': instance.likes,
      'comments': instance.comments,
      'isLiked': instance.isLiked,
      'likedByUsers': instance.likedByUsers,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_MomentComment _$MomentCommentFromJson(Map<String, dynamic> json) =>
    _MomentComment(
      id: json['id'] as String,
      momentId: json['momentId'] as String,
      odlId: json['odlId'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      userAvatar: json['userAvatar'] as String? ?? '',
      content: json['content'] as String,
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$MomentCommentToJson(_MomentComment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'momentId': instance.momentId,
      'odlId': instance.odlId,
      'userId': instance.userId,
      'username': instance.username,
      'userAvatar': instance.userAvatar,
      'content': instance.content,
      'likes': instance.likes,
      'isLiked': instance.isLiked,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_StudyGroup _$StudyGroupFromJson(Map<String, dynamic> json) => _StudyGroup(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String? ?? '',
  imageUrl: json['imageUrl'] as String? ?? '',
  level: json['level'] as String? ?? '',
  memberCount: (json['memberCount'] as num?)?.toInt() ?? 0,
  maxMembers: (json['maxMembers'] as num?)?.toInt() ?? 50,
  memberIds:
      (json['memberIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  posts:
      (json['posts'] as List<dynamic>?)
          ?.map((e) => StudyGroupPost.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <StudyGroupPost>[],
  isJoined: json['isJoined'] as bool? ?? false,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$StudyGroupToJson(_StudyGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'level': instance.level,
      'memberCount': instance.memberCount,
      'maxMembers': instance.maxMembers,
      'memberIds': instance.memberIds,
      'posts': instance.posts,
      'isJoined': instance.isJoined,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_StudyGroupPost _$StudyGroupPostFromJson(Map<String, dynamic> json) =>
    _StudyGroupPost(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      odlId: json['odlId'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      content: json['content'] as String,
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      comments: (json['comments'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$StudyGroupPostToJson(_StudyGroupPost instance) =>
    <String, dynamic>{
      'id': instance.id,
      'groupId': instance.groupId,
      'odlId': instance.odlId,
      'userId': instance.userId,
      'username': instance.username,
      'content': instance.content,
      'likes': instance.likes,
      'comments': instance.comments,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_Challenge _$ChallengeFromJson(Map<String, dynamic> json) => _Challenge(
  id: json['id'] as String,
  title: json['title'] as String,
  titleVi: json['titleVi'] as String,
  challengerId: json['challengerId'] as String,
  challengerName: json['challengerName'] as String,
  challengerAvatar: json['challengerAvatar'] as String,
  challengedId: json['challengedId'] as String,
  challengedName: json['challengedName'] as String,
  challengedAvatar: json['challengedAvatar'] as String,
  type: json['type'] as String,
  xpReward: (json['xpReward'] as num?)?.toInt() ?? 0,
  status: json['status'] as String? ?? 'pending',
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  acceptedAt: json['acceptedAt'] == null
      ? null
      : DateTime.parse(json['acceptedAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
);

Map<String, dynamic> _$ChallengeToJson(_Challenge instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'titleVi': instance.titleVi,
      'challengerId': instance.challengerId,
      'challengerName': instance.challengerName,
      'challengerAvatar': instance.challengerAvatar,
      'challengedId': instance.challengedId,
      'challengedName': instance.challengedName,
      'challengedAvatar': instance.challengedAvatar,
      'type': instance.type,
      'xpReward': instance.xpReward,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
      'acceptedAt': instance.acceptedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
    };

_Duel _$DuelFromJson(Map<String, dynamic> json) => _Duel(
  id: json['id'] as String,
  player1Id: json['player1Id'] as String,
  player1Name: json['player1Name'] as String,
  player1Avatar: json['player1Avatar'] as String,
  player2Id: json['player2Id'] as String,
  player2Name: json['player2Name'] as String,
  player2Avatar: json['player2Avatar'] as String,
  player1Score: (json['player1Score'] as num?)?.toInt() ?? 0,
  player2Score: (json['player2Score'] as num?)?.toInt() ?? 0,
  player1Correct: (json['player1Correct'] as num?)?.toInt() ?? 0,
  player2Correct: (json['player2Correct'] as num?)?.toInt() ?? 0,
  status: json['status'] as String? ?? 'waiting',
  currentQuestion: (json['currentQuestion'] as num?)?.toInt() ?? 0,
  startedAt: json['startedAt'] == null
      ? null
      : DateTime.parse(json['startedAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
);

Map<String, dynamic> _$DuelToJson(_Duel instance) => <String, dynamic>{
  'id': instance.id,
  'player1Id': instance.player1Id,
  'player1Name': instance.player1Name,
  'player1Avatar': instance.player1Avatar,
  'player2Id': instance.player2Id,
  'player2Name': instance.player2Name,
  'player2Avatar': instance.player2Avatar,
  'player1Score': instance.player1Score,
  'player2Score': instance.player2Score,
  'player1Correct': instance.player1Correct,
  'player2Correct': instance.player2Correct,
  'status': instance.status,
  'currentQuestion': instance.currentQuestion,
  'startedAt': instance.startedAt?.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
};

_Friend _$FriendFromJson(Map<String, dynamic> json) => _Friend(
  id: json['id'] as String,
  odlId: json['odlId'] as String,
  userId: json['userId'] as String,
  username: json['username'] as String,
  avatar: json['avatar'] as String? ?? '',
  level: (json['level'] as num?)?.toInt() ?? 0,
  totalXp: (json['totalXp'] as num?)?.toInt() ?? 0,
  streakDays: (json['streakDays'] as num?)?.toInt() ?? 0,
  status: json['status'] as String? ?? 'offline',
  lastActiveAt: json['lastActiveAt'] == null
      ? null
      : DateTime.parse(json['lastActiveAt'] as String),
);

Map<String, dynamic> _$FriendToJson(_Friend instance) => <String, dynamic>{
  'id': instance.id,
  'odlId': instance.odlId,
  'userId': instance.userId,
  'username': instance.username,
  'avatar': instance.avatar,
  'level': instance.level,
  'totalXp': instance.totalXp,
  'streakDays': instance.streakDays,
  'status': instance.status,
  'lastActiveAt': instance.lastActiveAt?.toIso8601String(),
};

_ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => _ChatMessage(
  id: json['id'] as String,
  conversationId: json['conversationId'] as String,
  senderId: json['senderId'] as String,
  receiverId: json['receiverId'] as String,
  content: json['content'] as String,
  isRead: json['isRead'] as bool? ?? false,
  sentAt: json['sentAt'] == null
      ? null
      : DateTime.parse(json['sentAt'] as String),
  readAt: json['readAt'] == null
      ? null
      : DateTime.parse(json['readAt'] as String),
);

Map<String, dynamic> _$ChatMessageToJson(_ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversationId': instance.conversationId,
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'content': instance.content,
      'isRead': instance.isRead,
      'sentAt': instance.sentAt?.toIso8601String(),
      'readAt': instance.readAt?.toIso8601String(),
    };

_ChatConversation _$ChatConversationFromJson(Map<String, dynamic> json) =>
    _ChatConversation(
      id: json['id'] as String,
      participantId: json['participantId'] as String,
      participantName: json['participantName'] as String,
      participantAvatar: json['participantAvatar'] as String? ?? '',
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      messages:
          (json['messages'] as List<dynamic>?)
              ?.map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ChatMessage>[],
      lastMessageAt: json['lastMessageAt'] == null
          ? null
          : DateTime.parse(json['lastMessageAt'] as String),
    );

Map<String, dynamic> _$ChatConversationToJson(_ChatConversation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'participantId': instance.participantId,
      'participantName': instance.participantName,
      'participantAvatar': instance.participantAvatar,
      'unreadCount': instance.unreadCount,
      'messages': instance.messages,
      'lastMessageAt': instance.lastMessageAt?.toIso8601String(),
    };
