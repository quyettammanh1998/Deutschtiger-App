import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

/// User nội bộ của app — resolve từ backend `GET /api/v1/user/profile`
/// (khóa theo `profiles.id` = JWT sub), KHÔNG lấy từ auth SDK.
///
/// Tách identity khỏi auth provider: feature code chỉ phụ thuộc [AppUser],
/// đổi auth provider không ảnh hưởng.
@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    required String id,
    @JsonKey(name: 'display_name') @Default('') String displayName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'cefr_level') String? cefrLevel,
    @JsonKey(name: 'is_premium') @Default(false) bool isPremium,
    @Default(0) int level,
    @JsonKey(name: 'total_xp') @Default(0) int totalXp,
    @JsonKey(name: 'current_streak') @Default(0) int currentStreak,
    @JsonKey(name: 'longest_streak') @Default(0) int longestStreak,
    @JsonKey(name: 'words_learned') @Default(0) int wordsLearned,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}
