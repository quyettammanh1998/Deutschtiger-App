import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/practice/practice_result.dart';
import '../../../l10n/app_localizations.dart';

/// Danh sách 4 chế độ luyện tập theo deck — tương ứng
/// `FlashcardModeSelector` trên web (`practice-page.tsx`).
class PracticeModeSelector extends StatelessWidget {
  const PracticeModeSelector({super.key, required this.onSelect});

  final void Function(PracticeMode mode) onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = <(PracticeMode, IconData, String, Color)>[
      (PracticeMode.cloze, Icons.edit_note, l10n.practiceModeCloze, Colors.teal),
      (PracticeMode.listening, Icons.headphones, l10n.practiceModeListening, Colors.purple),
      (PracticeMode.matching, Icons.compare_arrows, l10n.practiceModeMatching, Colors.pink),
      (PracticeMode.writing, Icons.create, l10n.practiceModeWriting, AppColors.tigerOrange),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          l10n.practiceChooseMode,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ModeCard(
              icon: item.$2,
              label: item.$3,
              color: item.$4,
              onTap: () => onSelect(item.$1),
            ),
          ),
      ],
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.mutedForeground),
            ],
          ),
        ),
      ),
    );
  }
}
