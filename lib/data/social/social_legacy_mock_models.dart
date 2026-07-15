/// Mock-only models backing gated, non-live social surfaces (study groups,
/// challenges). No backend contract is wired for these in this phase — the
/// web app itself has no live UI for groups either (see
/// `docs/api-changelog.md` gap entry), and challenges are hidden on web too.
/// Kept as plain Dart (no freezed/codegen) since the UI never mutates
/// instances of these.
class StudyGroup {
  const StudyGroup({
    required this.id,
    required this.name,
    this.description = '',
    this.level = '',
    this.memberCount = 0,
    this.maxMembers = 50,
    this.isJoined = false,
  });

  final String id;
  final String name;
  final String description;
  final String level;
  final int memberCount;
  final int maxMembers;
  final bool isJoined;
}

class Challenge {
  const Challenge({
    required this.id,
    required this.title,
    required this.titleVi,
    required this.challengerId,
    required this.challengerName,
    this.challengerAvatar = '',
    required this.challengedId,
    required this.challengedName,
    this.challengedAvatar = '',
    required this.type,
    this.xpReward = 0,
    this.status = 'pending',
    this.createdAt,
    this.acceptedAt,
  });

  final String id;
  final String title;
  final String titleVi;
  final String challengerId;
  final String challengerName;
  final String challengerAvatar;
  final String challengedId;
  final String challengedName;
  final String challengedAvatar;
  final String type;
  final int xpReward;
  final String status;
  final DateTime? createdAt;
  final DateTime? acceptedAt;
}
