import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/design_tokens.dart';
import '../../data/exam/exam_ecosystem_models.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/exam/de_thi_repository.dart';

/// Danh sách đề thi public (registry tĩnh) — route `/de-thi` không cần auth,
/// deep-link vào `/de-thi/:code` để làm đề.
class DeThiListScreen extends ConsumerWidget {
  const DeThiListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final entries = ref.watch(deThiRepositoryProvider).listRegistry();

    return Scaffold(
      backgroundColor: DesignTokens.background,
      appBar: AppBar(title: Text(l10n.deThiListTitle)),
      body: entries.isEmpty
          ? Center(
              child: Text(
                l10n.deThiListEmpty,
                style: const TextStyle(color: DesignTokens.mutedForeground),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(
                DesignTokens.screenHorizontalPadding,
              ),
              itemCount: entries.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: DesignTokens.spacingSm),
              itemBuilder: (context, index) =>
                  _DeThiCard(entry: entries[index]),
            ),
    );
  }
}

class _DeThiCard extends StatelessWidget {
  const _DeThiCard({required this.entry});
  final DeThiRegistryEntry entry;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/de-thi/${entry.code}'),
      borderRadius: BorderRadius.circular(DesignTokens.radius),
      child: Container(
        padding: const EdgeInsets.all(DesignTokens.cardPadding),
        decoration: BoxDecoration(
          color: DesignTokens.card,
          borderRadius: BorderRadius.circular(DesignTokens.radius),
          border: Border.all(color: DesignTokens.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(entry.title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(
              '${entry.level} · ${entry.skill}',
              style: const TextStyle(color: DesignTokens.mutedForeground),
            ),
          ],
        ),
      ),
    );
  }
}
