import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../shared/widgets/level_badge.dart';
import '../../../../../shared/widgets/save_card_button.dart';
import '../../../../../shared/widgets/speak_button.dart';
import '../../../domain/vocabulary_models.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

Color _genderBarColor(String? gender) {
  switch (gender) {
    case 'm':
      return const Color(0xFF3B82F6);
    case 'f':
      return const Color(0xFFEC4899);
    case 'n':
      return const Color(0xFF22C55E);
    default:
      return const Color(0xFFF97316);
  }
}

String _genderArticle(String gender) => switch (gender) { 'm' => 'der', 'f' => 'die', 'n' => 'das', _ => '' };

/// Hero card at the top of [VocabularyWordScreen] — gender accent bar, badge
/// row (word type / IPA / level / der-die-das), the headword + plural/lemma,
/// VN meaning, meanings box, image, then the "Đã thuộc" + YouGlish action
/// rows. Web parity: hero-card block of `vocabulary-word-page.tsx`.
class WordHeroCard extends ConsumerWidget {
  const WordHeroCard({
    super.key,
    required this.item,
    required this.mastered,
    required this.masteredPending,
    required this.onMarkMastered,
    required this.youglishOpen,
    required this.onToggleYouglish,
  });

  final LearningItem item;
  final bool mastered;
  final bool masteredPending;
  final VoidCallback onMarkMastered;
  final bool youglishOpen;
  final VoidCallback onToggleYouglish;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final gender = item.gender;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: tokens.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(height: 6, color: _genderBarColor(gender)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _BadgeRow(item: item)),
                      Column(
                        children: [
                          SpeakButton(text: item.contentDe, audioUrl: item.audioUrl),
                          const SizedBox(height: 4),
                          SaveCardButton(
                            variant: SaveCardButtonVariant.compact,
                            wordDe: item.contentDe,
                            wordVi: item.contentVi ?? '',
                            exampleSentence: item.examples?.firstOrNull?.de,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.contentDe,
                    style: TextStyle(
                      fontSize: item.contentDe.length > 25 ? 20 : item.contentDe.length > 15 ? 24 : 28,
                      fontWeight: FontWeight.w700,
                      color: tokens.foreground,
                    ),
                  ),
                  if ((item.plural ?? '').isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text('Pl. ${item.plural}', style: TextStyle(fontSize: 13, color: tokens.mutedForeground)),
                    ),
                  if ((item.lemma ?? '').isNotEmpty &&
                      item.lemma!.toLowerCase() != item.contentDe.toLowerCase())
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text('Dạng từ điển: ${item.lemma}', style: TextStyle(fontSize: 11, color: tokens.mutedForeground)),
                    ),
                  const SizedBox(height: 6),
                  Text(
                    '• ${item.contentVi ?? '—'}',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: tokens.primary),
                  ),
                  if ((item.meanings ?? const []).isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: tokens.muted.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(12)),
                      child: Text(
                        item.meanings!.join(' • '),
                        style: TextStyle(fontSize: 13, color: tokens.foreground.withValues(alpha: 0.85)),
                      ),
                    ),
                  ],
                  if ((item.imageUrl ?? '').isNotEmpty) ...[
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        item.imageUrl!,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const SizedBox.shrink(),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  _ActionRow(
                    label: mastered ? 'Đã đánh dấu thuộc ✓' : 'Đã thuộc',
                    icon: mastered ? PhosphorIcons.checkCircle : PhosphorIcons.star,
                    loading: masteredPending,
                    tint: mastered ? const Color(0xFF10B981) : tokens.primary,
                    onTap: mastered || masteredPending ? null : onMarkMastered,
                  ),
                  const SizedBox(height: 8),
                  _ActionRow(
                    label: youglishOpen ? 'Ẩn phát âm người bản xứ' : 'Nghe người bản xứ phát âm (video thật)',
                    icon: PhosphorIcons.globeHemisphereWest,
                    tint: const Color(0xFF10B981),
                    filled: youglishOpen,
                    onTap: onToggleYouglish,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BadgeRow extends StatelessWidget {
  const _BadgeRow({required this.item});
  final LearningItem item;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final gender = item.gender;
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        if ((item.wordType ?? '').isNotEmpty)
          _Pill(text: item.wordType!, background: tokens.primary.withValues(alpha: 0.1), foreground: tokens.primary),
        if ((item.ipa ?? '').isNotEmpty)
          _Pill(text: '/${item.ipa}/', background: Colors.transparent, foreground: tokens.mutedForeground, bordered: true),
        if (item.level != null) LevelBadge.fromString(item.level!.name, compact: true),
        if (gender == 'm' || gender == 'f' || gender == 'n')
          _Pill(text: _genderArticle(gender!), background: _genderBarColor(gender), foreground: Colors.white, bold: true),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text, required this.background, required this.foreground, this.bordered = false, this.bold = false});
  final String text;
  final Color background;
  final Color foreground;
  final bool bordered;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: bordered ? Border.all(color: context.tokens.border) : null,
      ),
      child: Text(text, style: TextStyle(fontSize: 11, fontWeight: bold ? FontWeight.w800 : FontWeight.w600, color: foreground)),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.label,
    required this.icon,
    required this.tint,
    this.loading = false,
    this.filled = false,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final Color tint;
  final bool loading;
  final bool filled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? tint : tint.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (loading)
                SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: tint))
              else
                Icon(icon, size: 16, color: filled ? Colors.white : tint),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: filled ? Colors.white : tint),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
