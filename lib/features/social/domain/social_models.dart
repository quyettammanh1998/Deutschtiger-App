import 'package:freezed_annotation/freezed_annotation.dart';

part 'social_models.freezed.dart';
part 'social_models.g.dart';

/// Social moment (feed post)
@freezed
abstract class SocialMoment with _$SocialMoment {
  const factory SocialMoment({
    required String id,
    required String odlId,
    required String userId,
    required String username,
    @Default('') String userAvatar,
    required String content,
    @Default('') String imageUrl,
    @Default(0) int likes,
    @Default(0) int comments,
    @Default(false) bool isLiked,
    @Default(<String>[]) List<String> likedByUsers,
    DateTime? createdAt,
  }) = _SocialMoment;

  factory SocialMoment.fromJson(Map<String, dynamic> json) =>
      _$SocialMomentFromJson(json);
}

/// Comment on a moment
@freezed
abstract class MomentComment with _$MomentComment {
  const factory MomentComment({
    required String id,
    required String momentId,
    required String odlId,
    required String userId,
    required String username,
    @Default('') String userAvatar,
    required String content,
    @Default(0) int likes,
    @Default(false) bool isLiked,
    DateTime? createdAt,
  }) = _MomentComment;

  factory MomentComment.fromJson(Map<String, dynamic> json) =>
      _$MomentCommentFromJson(json);
}

/// Study group
@freezed
abstract class StudyGroup with _$StudyGroup {
  const factory StudyGroup({
    required String id,
    required String name,
    @Default('') String description,
    @Default('') String imageUrl,
    @Default('') String level,
    @Default(0) int memberCount,
    @Default(50) int maxMembers,
    @Default(<String>[]) List<String> memberIds,
    @Default(<StudyGroupPost>[]) List<StudyGroupPost> posts,
    @Default(false) bool isJoined,
    DateTime? createdAt,
  }) = _StudyGroup;

  factory StudyGroup.fromJson(Map<String, dynamic> json) =>
      _$StudyGroupFromJson(json);
}

/// Study group post
@freezed
abstract class StudyGroupPost with _$StudyGroupPost {
  const factory StudyGroupPost({
    required String id,
    required String groupId,
    required String odlId,
    required String userId,
    required String username,
    required String content,
    @Default(0) int likes,
    @Default(0) int comments,
    DateTime? createdAt,
  }) = _StudyGroupPost;

  factory StudyGroupPost.fromJson(Map<String, dynamic> json) =>
      _$StudyGroupPostFromJson(json);
}

/// Challenge between users
@freezed
abstract class Challenge with _$Challenge {
  const factory Challenge({
    required String id,
    required String title,
    required String titleVi,
    required String challengerId,
    required String challengerName,
    required String challengerAvatar,
    required String challengedId,
    required String challengedName,
    required String challengedAvatar,
    required String type,
    @Default(0) int xpReward,
    @Default('pending') String status,
    DateTime? createdAt,
    DateTime? acceptedAt,
    DateTime? completedAt,
  }) = _Challenge;

  factory Challenge.fromJson(Map<String, dynamic> json) =>
      _$ChallengeFromJson(json);
}

/// Duel (PvP vocabulary)
@freezed
abstract class Duel with _$Duel {
  const factory Duel({
    required String id,
    required String player1Id,
    required String player1Name,
    required String player1Avatar,
    required String player2Id,
    required String player2Name,
    required String player2Avatar,
    @Default(0) int player1Score,
    @Default(0) int player2Score,
    @Default(0) int player1Correct,
    @Default(0) int player2Correct,
    @Default('waiting') String status,
    @Default(0) int currentQuestion,
    DateTime? startedAt,
    DateTime? completedAt,
  }) = _Duel;

  factory Duel.fromJson(Map<String, dynamic> json) => _$DuelFromJson(json);
}

/// Friend relationship
@freezed
abstract class Friend with _$Friend {
  const factory Friend({
    required String id,
    required String odlId,
    required String userId,
    required String username,
    @Default('') String avatar,
    @Default(0) int level,
    @Default(0) int totalXp,
    @Default(0) int streakDays,
    @Default('offline') String status,
    DateTime? lastActiveAt,
  }) = _Friend;

  factory Friend.fromJson(Map<String, dynamic> json) => _$FriendFromJson(json);
}

/// Chat message
@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String conversationId,
    required String senderId,
    required String receiverId,
    required String content,
    @Default(false) bool isRead,
    DateTime? sentAt,
    DateTime? readAt,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}

/// Chat conversation
@freezed
abstract class ChatConversation with _$ChatConversation {
  const factory ChatConversation({
    required String id,
    required String participantId,
    required String participantName,
    @Default('') String participantAvatar,
    @Default(0) int unreadCount,
    @Default(<ChatMessage>[]) List<ChatMessage> messages,
    DateTime? lastMessageAt,
  }) = _ChatConversation;

  factory ChatConversation.fromJson(Map<String, dynamic> json) =>
      _$ChatConversationFromJson(json);
}
