import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/core/theme/app_colors.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/view_models/social/announcements_provider.dart';

/// Read-only announcements list (`GET /api/v1/announcements?public_only=true`)
/// — `internal/feature/social/announcement/announcement_handler.go`. Web
/// shows these as a dashboard/exam-page banner; mobile surfaces the same
/// data as a dedicated list reachable from the Social hub app bar so it
/// stays inside this phase's file ownership.
class AnnouncementsPage extends ConsumerWidget {
  const AnnouncementsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final announcementsAsync = ref.watch(announcementsProvider);

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: Text(l10n.socialAnnouncementsTitle),
      ),
      body: announcementsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.socialLoadAnnouncementsError)),
        data: (announcements) {
          if (announcements.isEmpty) {
            return Center(
              child: Text(
                l10n.socialNoAnnouncements,
                style: TextStyle(color: Colors.grey[600]),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(announcementsProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: announcements.length,
              itemBuilder: (context, index) {
                final a = announcements[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(a.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 8),
                        Text(a.content),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
