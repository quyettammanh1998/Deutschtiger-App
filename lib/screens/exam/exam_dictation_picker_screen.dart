import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/design_tokens.dart';
import '../../features/exam/data/exam_service.dart';
import '../../features/exam/presentation/exam_player_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/common/async_state_views.dart';

/// Chọn đề Hören (TELC B1 / Goethe) để luyện nghe chép chính tả — chỉ những
/// đề có audio Hören mới có word-transcript; chọn sai đề → 404 xử lý ở màn
/// luyện (ErrorView).
class ExamDictationPickerScreen extends ConsumerWidget {
  const ExamDictationPickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final catalog = ref.watch(examCatalogProvider);

    return Scaffold(
      backgroundColor: DesignTokens.background,
      appBar: AppBar(title: Text(l10n.examDictationPickerTitle)),
      body: catalog.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          message: l10n.couldNotLoadExams,
          onRetry: () => ref.invalidate(examCatalogProvider),
        ),
        data: (items) {
          final eligible = items
              .where(
                (item) =>
                    (item.provider == 'telc' && item.level == 'b1') ||
                    item.provider == 'goethe',
              )
              .toList();
          if (eligible.isEmpty) {
            return Center(
              child: Text(
                l10n.noSupportedExams,
                style: const TextStyle(color: DesignTokens.mutedForeground),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(
              DesignTokens.screenHorizontalPadding,
            ),
            itemCount: eligible.length,
            separatorBuilder: (_, _) =>
                const SizedBox(height: DesignTokens.spacingSm),
            itemBuilder: (context, index) {
              final item = eligible[index];
              return _PickerCard(item: item);
            },
          );
        },
      ),
    );
  }
}

class _PickerCard extends StatelessWidget {
  const _PickerCard({required this.item});
  final ExamCatalogItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(
        '/exam/dictation/${item.provider}/${item.level}/${item.slug}',
      ),
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
            Text(
              item.titleVi?.isNotEmpty == true ? item.titleVi! : item.title,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              '${item.provider.toUpperCase()} ${item.level.toUpperCase()}',
              style: const TextStyle(color: DesignTokens.mutedForeground),
            ),
          ],
        ),
      ),
    );
  }
}
