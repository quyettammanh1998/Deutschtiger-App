import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../widgets/common/sticky_cta_bar.dart';
import 'vocabulary_practice_launcher.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Sticky bottom bar — web parity: `VocabLearnBottomBar` (pager row + 4
/// practice-mode icon buttons + "Học từ mới" gradient CTA when a lesson
/// session is available for this scope).
class VocabularyDetailStickyBar extends ConsumerWidget {
  const VocabularyDetailStickyBar({
    super.key,
    required this.scope,
    this.page,
    this.totalPages,
    this.onPrevPage,
    this.onNextPage,
    this.onStartLesson,
  });

  final VocabularyScope scope;
  final int? page;
  final int? totalPages;
  final VoidCallback? onPrevPage;
  final VoidCallback? onNextPage;
  final VoidCallback? onStartLesson;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return StickyCtaBar(
      clearBottomNav: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (page != null && totalPages != null && totalPages! > 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: page! > 1 ? onPrevPage : null,
                    icon: const Icon(PhosphorIcons.caretLeft),
                  ),
                  Text('$page / $totalPages', style: const TextStyle(fontSize: 12)),
                  IconButton(
                    onPressed: page! < totalPages! ? onNextPage : null,
                    icon: const Icon(PhosphorIcons.caretRight),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              for (final mode in VocabularyPracticeMode.values)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        side: BorderSide(color: tokens.border),
                      ),
                      onPressed: () => pushVocabularyPractice(
                        context,
                        ref,
                        mode: mode,
                        scope: scope,
                      ),
                      child: Text(
                        mode.label(l10n),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (onStartLesson != null) ...[
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [tokens.primary, tokens.primary.withValues(alpha: 0.8)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: onStartLesson,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        l10n.vocabularyStartLesson,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
