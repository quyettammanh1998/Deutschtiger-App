import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/data/social/social_legacy_mock_models.dart';
import 'package:deutschtiger/repositories/social/social_legacy_mock_repository.dart';

/// Mock-only provider for the gated challenges surface — see
/// `SocialLegacyMockRepository`. Do not use as a template for new live
/// social features. Kept out of `social_repository_providers.dart` so that
/// file stays free of "mock" references and can be release-live-data-guard
/// whitelisted.
///
/// `studyGroupsProvider` was removed in the P12 wave-B deletion sweep along
/// with `groups_page.dart`/`group_detail_page.dart`.
final socialLegacyMockRepositoryProvider = Provider<SocialLegacyMockRepository>(
  (ref) => SocialLegacyMockRepository(),
);

final challengesProvider = FutureProvider.autoDispose<List<Challenge>>((
  ref,
) async {
  return ref.watch(socialLegacyMockRepositoryProvider).getChallenges();
});
