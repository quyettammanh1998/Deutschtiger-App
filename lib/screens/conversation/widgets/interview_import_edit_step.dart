import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../data/speech/conversation_models.dart';
import '../../../l10n/app_localizations.dart';

/// Step 2: review/edit the AI-extracted questions + prepared-answer hints
/// before saving. The edit step is both the quality gate and the security
/// checkpoint on AI-extracted content (web parity comment ported verbatim).
class InterviewImportEditStep extends StatelessWidget {
  const InterviewImportEditStep({
    super.key,
    required this.titleController,
    required this.points,
    required this.onUpdatePoint,
    required this.onRemovePoint,
    required this.onAddPoint,
    required this.busy,
    required this.onSave,
  });

  final TextEditingController titleController;
  final List<RequiredPoint> points;
  final void Function(int index, RequiredPoint updated) onUpdatePoint;
  final void Function(int index) onRemovePoint;
  final VoidCallback onAddPoint;
  final bool busy;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: tokens.card, border: Border.all(color: tokens.border), borderRadius: BorderRadius.circular(14)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.interviewImportTitleLabel, style: TextStyle(fontWeight: FontWeight.w600, color: tokens.foreground)),
              const SizedBox(height: 6),
              TextField(controller: titleController, decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(l10n.interviewImportEditHint, style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
        const SizedBox(height: 12),
        for (var i = 0; i < points.length; i++) _PointCard(index: i, point: points[i], onUpdate: (p) => onUpdatePoint(i, p), onRemove: () => onRemovePoint(i)),
        const SizedBox(height: 6),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(onPressed: onAddPoint, icon: const Icon(Icons.add, size: 18), label: Text(l10n.interviewImportAddQuestion)),
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            style: FilledButton.styleFrom(backgroundColor: tokens.primary, minimumSize: const Size.fromHeight(46)),
            onPressed: busy ? null : onSave,
            child: Text(busy ? l10n.interviewImportSaving : l10n.interviewImportSave),
          ),
        ),
      ],
    );
  }
}

class _PointCard extends StatelessWidget {
  const _PointCard({required this.index, required this.point, required this.onUpdate, required this.onRemove});

  final int index;
  final RequiredPoint point;
  final void Function(RequiredPoint) onUpdate;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: tokens.card, border: Border.all(color: tokens.border), borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(l10n.interviewImportQuestionLabel(index + 1), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: tokens.mutedForeground))),
              IconButton(icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red), onPressed: onRemove),
            ],
          ),
          TextFormField(
            initialValue: point.de,
            maxLines: 2,
            decoration: InputDecoration(hintText: l10n.interviewImportQuestionDeHint, isDense: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
            onChanged: (v) => onUpdate(point.copyWith(de: v)),
          ),
          const SizedBox(height: 6),
          TextFormField(
            initialValue: point.vi,
            decoration: InputDecoration(hintText: l10n.interviewImportQuestionViHint, isDense: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
            onChanged: (v) => onUpdate(point.copyWith(vi: v)),
          ),
          const SizedBox(height: 6),
          TextFormField(
            initialValue: point.hintDe,
            maxLines: 2,
            decoration: InputDecoration(hintText: l10n.interviewImportHintDeHint, isDense: true, filled: true, fillColor: tokens.muted, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
            onChanged: (v) => onUpdate(point.copyWith(hintDe: v)),
          ),
          const SizedBox(height: 6),
          TextFormField(
            initialValue: point.hintVi,
            decoration: InputDecoration(hintText: l10n.interviewImportHintViHint, isDense: true, filled: true, fillColor: tokens.muted, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
            onChanged: (v) => onUpdate(point.copyWith(hintVi: v)),
          ),
        ],
      ),
    );
  }
}
