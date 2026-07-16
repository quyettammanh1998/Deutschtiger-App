import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../data/speech/conversation_display.dart';
import '../../../l10n/app_localizations.dart';

const interviewImportMaxChars = 60000;

/// Step 1: paste/upload the interview-prep document + pick CEFR level.
class InterviewImportInputStep extends StatelessWidget {
  const InterviewImportInputStep({
    super.key,
    required this.controller,
    required this.level,
    required this.onLevelChanged,
    required this.busy,
    required this.onExtract,
  });

  final TextEditingController controller;
  final String level;
  final ValueChanged<String> onLevelChanged;
  final bool busy;
  final VoidCallback onExtract;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: tokens.card, border: Border.all(color: tokens.border), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.interviewImportDocLabel, style: TextStyle(fontWeight: FontWeight.w600, color: tokens.foreground)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            maxLines: 12,
            maxLength: interviewImportMaxChars,
            decoration: InputDecoration(
              hintText: l10n.interviewImportDocHint,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 8),
          Text(l10n.interviewImportLevelLabel, style: TextStyle(fontWeight: FontWeight.w600, color: tokens.foreground)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: conversationLevels
                .map(
                  (lv) => ChoiceChip(
                    label: Text(lv),
                    selected: level == lv,
                    onSelected: (_) => onLevelChanged(lv),
                    selectedColor: tokens.primary,
                    labelStyle: TextStyle(color: level == lv ? Colors.white : tokens.foreground),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: tokens.primary, minimumSize: const Size.fromHeight(46)),
              onPressed: busy ? null : onExtract,
              icon: busy
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.auto_awesome, size: 18),
              label: Text(busy ? l10n.interviewImportExtracting : l10n.interviewImportExtract),
            ),
          ),
        ],
      ),
    );
  }
}
