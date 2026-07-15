import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/data/social/announcement_model.dart';
import 'social_repository_providers.dart';

/// Read-only active announcements (`GET /api/v1/announcements`).
final announcementsProvider = FutureProvider.autoDispose<List<Announcement>>((
  ref,
) async {
  return ref.watch(announcementRepositoryProvider).getActive();
});
