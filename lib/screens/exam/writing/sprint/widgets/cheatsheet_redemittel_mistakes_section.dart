import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../features/writing/domain/sprint/common_mistakes.dart';
import '../../../../../features/writing/domain/sprint/redemittel_aggregator.dart';
import '../../../../../features/writing/domain/sprint/sprint_types.dart';
import '../../../../../l10n/app_localizations.dart';

/// Cheatsheet redemittel page — top-N phrases grouped by function. Web
/// parity `page-redemittel.tsx`.
class CheatsheetRedemittelSection extends StatelessWidget {
  const CheatsheetRedemittelSection({super.key, required this.grouped});

  final Map<String, List<RedemittelItem>> grouped;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.writingSprintCheatsheetRedemittelTitle, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: tokens.foreground)),
        const SizedBox(height: 10),
        for (final fn in kRedemittelFunctionOrder)
          if ((grouped[fn] ?? const []).isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(kRedemittelFunctionLabels[fn] ?? fn, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: tokens.foreground)),
                  const SizedBox(height: 6),
                  for (var i = 0; i < grouped[fn]!.length; i++)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
                      color: i.isOdd ? tokens.muted.withValues(alpha: 0.4) : null,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(grouped[fn]![i].de, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: tokens.foreground)),
                          ),
                          Expanded(
                            child: Text(grouped[fn]![i].vi, style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
      ],
    );
  }
}

/// Cheatsheet common-mistakes page — B1 typical errors quick reference. Web
/// parity `page-mistakes.tsx`.
class CheatsheetMistakesSection extends StatelessWidget {
  const CheatsheetMistakesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final grouped = <String, List<CommonMistake>>{};
    for (final m in kCommonMistakes) {
      (grouped[m.category] ??= []).add(m);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.writingSprintCheatsheetMistakesTitle, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: tokens.foreground)),
        const SizedBox(height: 10),
        for (final entry in grouped.entries)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.key, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: tokens.foreground)),
                for (final m in entry.value)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(border: Border(left: BorderSide(color: tokens.destructive, width: 2))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(text: TextSpan(style: TextStyle(fontSize: 11, color: tokens.foreground), children: [
                          TextSpan(text: m.wrong, style: TextStyle(color: tokens.destructive, decoration: TextDecoration.lineThrough)),
                          const TextSpan(text: ' → '),
                          TextSpan(text: m.correct, style: TextStyle(fontWeight: FontWeight.w600, color: tokens.success)),
                        ])),
                        Text(m.rule, style: TextStyle(fontSize: 11, color: tokens.mutedForeground)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        const SizedBox(height: 8),
        Text(l10n.writingSprintCheatsheetVerbKasusTitle, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: tokens.foreground)),
        const SizedBox(height: 6),
        for (var i = 0; i < kVerbKasusReference.length; i++)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
            color: i.isOdd ? tokens.muted.withValues(alpha: 0.4) : null,
            child: Row(
              children: [
                Expanded(child: Text(kVerbKasusReference[i].$1, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: tokens.foreground))),
                Expanded(child: Text(kVerbKasusReference[i].$2, style: TextStyle(fontSize: 11, color: tokens.mutedForeground))),
                Expanded(flex: 2, child: Text(kVerbKasusReference[i].$3, style: TextStyle(fontSize: 11, color: tokens.foreground))),
              ],
            ),
          ),
      ],
    );
  }
}
