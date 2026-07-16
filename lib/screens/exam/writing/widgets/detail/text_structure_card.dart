import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../features/writing/domain/writing_topic/task_section.dart';
import '../../../../../features/writing/presentation/widgets/writing_audio_play_button.dart';
import '../../../../../l10n/app_localizations.dart';

/// `TextStructureCard` — horizontal-scroll table, "Tip" column dropped on
/// mobile per spec (`hidden sm:table-cell`).
class WritingTextStructureCard extends StatelessWidget {
  const WritingTextStructureCard({super.key, required this.rows});

  final List<TextStructureRow> rows;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowHeight: 32,
        dataRowMinHeight: 36,
        dataRowMaxHeight: 64,
        columns: [
          DataColumn(label: Text(l10n.writingColPart, style: const TextStyle(fontSize: 11))),
          DataColumn(label: Text(l10n.writingColDe, style: const TextStyle(fontSize: 11))),
          DataColumn(label: Text(l10n.writingColVi, style: const TextStyle(fontSize: 11))),
        ],
        rows: [
          for (final r in rows)
            DataRow(cells: [
              DataCell(Text(r.part, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: tokens.foreground))),
              DataCell(Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 220),
                    child: Text(r.de, style: TextStyle(fontSize: 12, color: tokens.foreground), softWrap: true),
                  ),
                  WritingAudioPlayButton(text: r.de, audioUrl: r.audioUrl, size: 14),
                ],
              )),
              DataCell(ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 160),
                child: Text(r.vi, style: TextStyle(fontSize: 11, color: tokens.mutedForeground), softWrap: true),
              )),
            ]),
        ],
      ),
    );
  }
}
