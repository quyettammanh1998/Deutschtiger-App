/// Mock-only models backing the gated, non-live challenges surface. No
/// backend contract is wired for this in this phase — web hides the
/// challenges route too. Kept as plain Dart (no freezed/codegen) since the
/// UI never mutates instances of these.
///
/// Study-groups models were removed in the P12 wave-B deletion sweep along
/// with `groups_page.dart`/`group_detail_page.dart` — web never had a
/// groups feature either (see `docs/api-changelog.md` gap entry).
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
