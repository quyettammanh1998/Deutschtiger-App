import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../features/writing/data/community_writing_write_repository.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../widgets/common/gradient_button.dart';

/// Simplified create/add-version form — web parity
/// `CommunityTopicCreateWizard`. DEVIATION: web's wizard is multi-step
/// (title/task/points/exam-date/exam-location, edit vs add-version modes);
/// this is a single-screen form (task textarea + optional AI-polish, one
/// exam-date/location line) covering the same write path with the AI
/// "hoàn thiện" toggle the plan explicitly calls out for `writing-custom`.
/// Named follow-up: split into the full multi-step wizard if product wants
/// pixel parity here too.
class CommunityAddVersionSheet extends StatefulWidget {
  const CommunityAddVersionSheet({
    super.key,
    required this.provider,
    required this.level,
    required this.teil,
    this.canonicalId,
  });

  final String provider;
  final String level;
  final int teil;

  /// null → create a brand new canonical topic; set → add a version under it.
  final String? canonicalId;

  @override
  State<CommunityAddVersionSheet> createState() => _CommunityAddVersionSheetState();
}

class _CommunityAddVersionSheetState extends State<CommunityAddVersionSheet> {
  final _taskController = TextEditingController();
  final _pointsController = TextEditingController();
  bool _aiPolish = true;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _taskController.dispose();
    _pointsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final task = _taskController.text.trim();
    if (task.isEmpty || _busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final repo = ProviderScope.containerOf(context, listen: false)
        .read(communityWritingWriteRepositoryProvider);
    final points = _pointsController.text
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();
    try {
      String titleDe = task.split('\n').first;
      Map<String, dynamic> generatedData = {
        'task': {'de': task},
        'taskAnalysis': {'points': points.map((p) => {'de': p}).toList()},
      };
      if (_aiPolish) {
        final input = [task, ...points].join('\n');
        final res = await repo.generate(provider: widget.provider, level: widget.level, teil: widget.teil, input: input);
        if (res.titleDe.isNotEmpty) titleDe = res.titleDe;
        if (res.generatedData.isNotEmpty) generatedData = res.generatedData;
      }
      if (widget.canonicalId != null) {
        await repo.upsertMyVersion(
          canonicalId: widget.canonicalId!,
          titleDe: titleDe,
          inputText: task,
          generatedData: generatedData,
        );
      } else {
        await repo.create(
          provider: widget.provider,
          level: widget.level,
          teil: widget.teil,
          titleDe: titleDe,
          inputText: task,
          generatedData: generatedData,
        );
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.canonicalId == null
                ? l10n.writingCommunityCreateTitle
                : l10n.writingCommunityAddVersion,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: tokens.foreground),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _taskController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: l10n.writingCommunityTaskHint,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _pointsController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: l10n.writingCommunityPointsHint,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 8),
          CheckboxListTile(
            value: _aiPolish,
            onChanged: (v) => setState(() => _aiPolish = v ?? true),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(l10n.writingAiPolishTitle, style: const TextStyle(fontSize: 13)),
            subtitle: Text(l10n.writingAiPolishDesc, style: const TextStyle(fontSize: 11)),
          ),
          if (_error != null) ...[
            const SizedBox(height: 4),
            Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 12)),
          ],
          const SizedBox(height: 12),
          GradientButton(
            label: _busy ? l10n.writingAiPolishing : l10n.writingCommunitySubmit,
            onPressed: _busy ? null : _submit,
            loading: _busy,
          ),
        ],
      ),
    );
  }
}
