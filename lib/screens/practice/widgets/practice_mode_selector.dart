import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../data/practice/practice_result.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/common/app_card.dart';
import 'practice_mode_cards.dart';

/// 2-col grid of gradient mode cards — web parity: `FlashcardModeSelector`
/// (`practice-page.tsx`). Card set/colors: [buildPracticeModeCards].
class PracticeModeSelector extends StatelessWidget {
  const PracticeModeSelector({
    super.key,
    required this.onSelect,
    this.cardCount,
    this.includeGraduated,
    this.onIncludeGraduatedChanged,
  });

  final void Function(PracticeMode mode) onSelect;

  /// Số thẻ sẵn sàng. Null = ẩn dòng đếm — trang guided lesson của web
  /// (`/notes/:id/lesson`) không có dòng này, chỉ `practice-page.tsx` có.
  final int? cardCount;

  /// Toggle "gồm cả thẻ đã thuộc". Null = ẩn toggle, cũng theo guided lesson.
  final bool? includeGraduated;
  final ValueChanged<bool>? onIncludeGraduatedChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final cards = buildPracticeModeCards(l10n);

    final graduated = includeGraduated;
    final onGraduatedChanged = onIncludeGraduatedChanged;
    final showGraduatedToggle = graduated != null && onGraduatedChanged != null;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (showGraduatedToggle) ...[
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => onGraduatedChanged(!graduated),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: tokens.muted.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    Checkbox(
                      value: graduated,
                      onChanged: (v) => onGraduatedChanged(v ?? false),
                      activeColor: tokens.primary,
                    ),
                    Expanded(
                      child: Text(
                        l10n.practiceIncludeGraduated,
                        style: TextStyle(fontSize: 14, color: tokens.mutedForeground),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        AppCard.card(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                l10n.practiceChooseMode,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: tokens.foreground,
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cards.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.92,
                ),
                itemBuilder: (context, index) {
                  final card = cards[index];
                  return _ModeCard(
                    config: card,
                    onTap: card.enabled ? () => onSelect(card.mode!) : null,
                    comingSoonLabel: l10n.practiceModeComingSoon,
                  );
                },
              ),
              if (cardCount != null) ...[
                const SizedBox(height: 16),
                Text(
                  l10n.practiceCardsReady(cardCount!),
                  style: TextStyle(fontSize: 13, color: tokens.mutedForeground),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({required this.config, required this.onTap, required this.comingSoonLabel});

  final PracticeModeCardConfig config;
  final VoidCallback? onTap;
  final String comingSoonLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final radius = BorderRadius.circular(16);
    return Opacity(
      opacity: config.enabled ? 1 : 0.55,
      child: Material(
        color: tokens.card,
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(color: tokens.border),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: config.gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(config.icon, color: Colors.white, size: 22),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: Text(
                    config.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: tokens.foreground,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Flexible(
                  child: Text(
                    config.enabled ? config.description : comingSoonLabel,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
