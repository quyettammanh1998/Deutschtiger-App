import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/view_models/providers.dart';

/// Save-state for the settings-root profile-edit card (display name +
/// avatar URL). Web parity: `settings-profile-section.tsx` — `PUT
/// /user/profile`. Deliberately separate from
/// `lib/screens/profile/profile_controller.dart` (owned by the
/// social/profile phase, which folds `EditProfileScreen` into this card as
/// part of the same wave) so this settings slice has no cross-boundary
/// dependency on files outside `lib/view_models/settings/**`.
class ProfileEditState {
  const ProfileEditState({this.saving = false, this.error});

  final bool saving;
  final String? error;

  ProfileEditState copyWith({bool? saving, String? error, bool clearError = false}) =>
      ProfileEditState(
        saving: saving ?? this.saving,
        error: clearError ? null : (error ?? this.error),
      );
}

class ProfileEditNotifier extends AutoDisposeNotifier<ProfileEditState> {
  @override
  ProfileEditState build() => const ProfileEditState();

  /// Returns true on success. Invalidates [myProfileProvider] so every
  /// surface reading the current user's profile (home header, nav rows,
  /// public-profile view of self) picks up the new value.
  Future<bool> save({String? displayName, String? avatarUrl}) async {
    state = state.copyWith(saving: true, clearError: true);
    try {
      await ref
          .read(profileRepositoryProvider)
          .updateProfile(displayName: displayName, avatarUrl: avatarUrl);
      ref.invalidate(myProfileProvider);
      state = state.copyWith(saving: false);
      return true;
    } catch (_) {
      state = state.copyWith(saving: false, error: 'save');
      return false;
    }
  }
}

final profileEditProvider =
    NotifierProvider.autoDispose<ProfileEditNotifier, ProfileEditState>(
      ProfileEditNotifier.new,
    );
