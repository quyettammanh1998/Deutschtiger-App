import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../features/writing/domain/sprint/sprint_types.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../widgets/common/app_pill.dart';

/// SR card front face — prompt + Punkte + 3 outline textareas + Kiểm tra /
/// Bỏ qua buttons. Web parity `sr-card-front.tsx`. Caller owns [controllers]'
/// lifecycle (created/disposed by the orchestrating `SrCard` widget so text
/// survives the front→back→front phase transitions within one card).
class SrCardFront extends StatefulWidget {
  const SrCardFront({
    super.key,
    required this.topic,
    required this.cardNum,
    required this.total,
    required this.controllers,
    required this.onCheck,
    required this.onSkip,
  });

  final SprintTopicData topic;
  final int cardNum;
  final int total;
  final List<TextEditingController> controllers;
  final VoidCallback onCheck;
  final VoidCallback onSkip;

  @override
  State<SrCardFront> createState() => _SrCardFrontState();
}

class _SrCardFrontState extends State<SrCardFront> {
  @override
  void initState() {
    super.initState();
    for (final c in widget.controllers) {
      c.addListener(_onTextChanged);
    }
  }

  @override
  void dispose() {
    for (final c in widget.controllers) {
      c.removeListener(_onTextChanged);
    }
    super.dispose();
  }

  void _onTextChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final topic = widget.topic;
    final cardNum = widget.cardNum;
    final total = widget.total;
    final controllers = widget.controllers;
    final onCheck = widget.onCheck;
    final onSkip = widget.onSkip;
    final canCheck = controllers.every((c) => c.text.trim().isNotEmpty);
    final points = topic.taskAnalysisPoints;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: tokens.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: tokens.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.writingSprintCardCounter(topic.teil, cardNum, total),
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: tokens.mutedForeground),
              ),
              if ((topic.topicCluster ?? '').isNotEmpty) AppPill(label: topic.topicCluster!),
            ],
          ),
          const SizedBox(height: 12),
          Text(topic.taskDe, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.4, color: tokens.foreground)),
          if (topic.taskVi.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(topic.taskVi, style: TextStyle(fontSize: 12, height: 1.4, color: tokens.mutedForeground)),
          ],
          if (points.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: tokens.muted, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.writingSprintRequirementsLabel,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.4, color: tokens.mutedForeground),
                  ),
                  const SizedBox(height: 6),
                  for (var i = 0; i < points.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${i + 1}.', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: tokens.mutedForeground)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(points[i].de, style: TextStyle(fontSize: 12, color: tokens.foreground)),
                                if (points[i].vi.isNotEmpty)
                                  Text(points[i].vi, style: TextStyle(fontSize: 11, color: tokens.mutedForeground)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 14),
          for (var i = 0; i < 3; i++) ...[
            Text(
              l10n.writingSprintOutlineLabel(i + 1),
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: tokens.mutedForeground),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: controllers[i],
              maxLines: 2,
              style: TextStyle(fontSize: 13, color: tokens.foreground),
              decoration: InputDecoration(
                isDense: true,
                hintText: l10n.writingSprintOutlineHint(i + 1),
                filled: true,
                fillColor: tokens.card,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: tokens.border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: tokens.border)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: tokens.primary, width: 2)),
              ),
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onSkip,
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: Text(l10n.writingSprintSkipButton),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: canCheck ? onCheck : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tokens.primary,
                    foregroundColor: tokens.primaryForeground,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(l10n.writingSprintCheckButton),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
