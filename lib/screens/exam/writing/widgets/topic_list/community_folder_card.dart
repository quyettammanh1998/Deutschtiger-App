import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../view_models/exam/exam_ecosystem_providers.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Entry-point card to the community-contributed writing topics for this
/// Teil — web parity `community-topic-folder-card.tsx`. Count is best-effort
/// from the already-typed list provider (no dedicated `/count` endpoint
/// wired in Flutter's `CommunityExamRepository` yet — documented deviation).
class WritingCommunityFolderCard extends ConsumerWidget {
  const WritingCommunityFolderCard({super.key, required this.teil, required this.onTap});

  final int teil;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final filter = CommunityExamFilter(provider: 'goethe', skill: 'writing', teil: teil);
    final count = ref.watch(communityExamListProvider(filter)).valueOrNull?.length ?? 0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFF97316), Color(0xFFEA580C)]),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(PhosphorIcons.folder, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.writingCommunityFolderTitle,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    count > 0
                        ? l10n.writingCommunityFolderCount(count)
                        : l10n.writingCommunityFolderEmpty,
                    style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.8)),
                  ),
                ],
              ),
            ),
            Icon(PhosphorIcons.caretRight, color: Colors.white.withValues(alpha: 0.7), size: 18),
          ],
        ),
      ),
    );
  }
}
