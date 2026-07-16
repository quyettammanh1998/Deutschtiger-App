import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../features/writing/data/community_writing_write_repository.dart';
import '../../../features/writing/domain/writing_exam_id_parser.dart';
import '../../../features/writing/domain/writing_offering.dart';
import '../../../features/writing/presentation/writing_practice_panel.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/common/gradient_button.dart';

/// `writing-custom` (`/luyen-viet/tu-nhap`) — bring-your-own prompt writing
/// practice: chip selectors (provider/level/Teil), 2 textareas, ✨ AI-polish,
/// 2-phase flow (setup → practice). Web parity `WritingCustomPage`.
///
/// [prefillTaskPrompt]/[prefillProvider]/[prefillLevel]/[prefillTeil] mirror
/// web's router-state prefill (used by "Luyện lại" on a custom session and
/// by "➕ Đóng góp đề" from the level-topics screen) — passed as query
/// params by the route builder since GoRouter has no router-state channel.
class WritingCustomPage extends ConsumerStatefulWidget {
  const WritingCustomPage({
    super.key,
    this.prefillTaskPrompt,
    this.prefillProvider,
    this.prefillLevel,
    this.prefillTeil,
  });

  final String? prefillTaskPrompt;
  final String? prefillProvider;
  final String? prefillLevel;
  final int? prefillTeil;

  @override
  ConsumerState<WritingCustomPage> createState() => _WritingCustomPageState();
}

class _WritingCustomPageState extends ConsumerState<WritingCustomPage> {
  late String _provider;
  late String _level;
  late int _teil;
  final _taskController = TextEditingController();
  final _pointsController = TextEditingController();
  bool _aiPolish = true;
  bool _started = false;
  bool _busy = false;
  String? _prepareError;
  String? _slug;

  @override
  void initState() {
    super.initState();
    _provider = widget.prefillProvider ?? 'goethe';
    _level = widget.prefillLevel ?? 'b2';
    _teil = widget.prefillTeil ?? 0;
    _taskController.text = widget.prefillTaskPrompt ?? '';
  }

  @override
  void dispose() {
    _taskController.dispose();
    _pointsController.dispose();
    super.dispose();
  }

  List<String> get _levelsForProvider =>
      kWritingCatalog.where((o) => o.provider == _provider).map((o) => o.level).toList();

  List<String> get _points => _pointsController.text
      .split('\n')
      .map((l) => l.trim())
      .where((l) => l.isNotEmpty)
      .toList();

  Future<void> _handleStart() async {
    final task = _taskController.text.trim();
    if (task.isEmpty || _busy) return;
    setState(() {
      _busy = true;
      _prepareError = null;
    });
    if (!_aiPolish) {
      setState(() {
        _started = true;
        _slug = generateCustomWritingSlug();
        _busy = false;
      });
      return;
    }
    try {
      final repo = ref.read(communityWritingWriteRepositoryProvider);
      final input = [task, ..._points].join('\n');
      final res = await repo.generate(provider: _provider, level: _level, teil: _teil, input: input);
      final polishedTask = res.generatedData['task'] is Map
          ? (res.generatedData['task'] as Map)['de']?.toString() ?? task
          : task;
      final analysis = res.generatedData['taskAnalysis'];
      final polishedPoints = <String>[];
      if (analysis is Map && analysis['points'] is List) {
        for (final p in (analysis['points'] as List)) {
          if (p is Map && p['de'] is String && (p['de'] as String).isNotEmpty) {
            polishedPoints.add(p['de'] as String);
          }
        }
      }
      setState(() {
        _taskController.text = polishedTask;
        if (polishedPoints.isNotEmpty) _pointsController.text = polishedPoints.join('\n');
        _started = true;
        _slug = generateCustomWritingSlug();
      });
    } catch (e) {
      setState(() => _prepareError = AppLocalizations.of(context).writingAiPolishError);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _handleContribute() async {
    final l10n = AppLocalizations.of(context);
    final repo = ref.read(communityWritingWriteRepositoryProvider);
    final task = _taskController.text.trim();
    final title = task.split('\n').map((l) => l.trim()).firstWhere((l) => l.isNotEmpty, orElse: () => l10n.writingCommunityTopicFallbackTitle);
    try {
      final res = await repo.create(
        provider: _provider,
        level: _level,
        teil: _teil,
        titleDe: title.length > 120 ? title.substring(0, 120) : title,
        inputText: task,
        generatedData: {
          'task': {'de': task},
          'taskAnalysis': {'points': _points.map((p) => {'de': p}).toList()},
        },
      );
      if (mounted) {
        context.push('/exam/$_provider-$_level/writing/community/$_teil/${res.slug}');
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.writingCommunityVoteError)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);

    if (_started && _slug != null) {
      final task = _taskController.text.trim();
      final points = _points;
      return Scaffold(
        backgroundColor: tokens.background,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  TextButton(
                    onPressed: () => setState(() => _started = false),
                    child: Text(l10n.writingCustomEditPrompt),
                  ),
                  Expanded(
                    child: Text(
                      l10n.writingCustomStartedTitle,
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: tokens.foreground),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: tokens.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: tokens.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.communitySectionTask,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: tokens.mutedForeground),
                    ),
                    const SizedBox(height: 4),
                    Text(task, style: TextStyle(fontSize: 13, color: tokens.foreground, height: 1.4)),
                    if (points.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        l10n.writingCommunityPointsTitle,
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: tokens.mutedForeground),
                      ),
                      const SizedBox(height: 4),
                      for (final p in points)
                        Text('• $p', style: TextStyle(fontSize: 12, color: tokens.foreground)),
                    ],
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: _handleContribute,
                      child: Text(l10n.writingCustomContribute),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              WritingPracticePanel(
                examId: buildCustomWritingExamId(
                  provider: _provider,
                  level: _level,
                  teil: _teil == 0 ? null : _teil,
                  slug: _slug!,
                ),
                taskPromptDe: task,
                writingPoints: points,
                level: _level.toUpperCase(),
                provider: _provider == 'telc' ? 'telc' : 'goethe',
                teilNum: [1, 2, 3].contains(_teil) ? _teil : null,
              ),
            ],
          ),
        ),
      );
    }

    final providers = kWritingCatalog.map((o) => o.provider).toSet().toList();

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
                Expanded(
                  child: Text(
                    l10n.writingCustomTitle,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: tokens.foreground),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(l10n.writingCustomIntro, style: TextStyle(fontSize: 13, color: tokens.mutedForeground)),
            const SizedBox(height: 20),
            _Label(l10n.writingCustomExamLabel),
            _ChipRow(
              options: providers,
              labelOf: (p) => p == 'goethe' ? 'Goethe' : (p == 'telc' ? 'telc' : 'ÖSD'),
              active: _provider,
              onSelect: (p) => setState(() {
                _provider = p;
                if (!_levelsForProvider.contains(_level)) _level = _levelsForProvider.first;
              }),
            ),
            const SizedBox(height: 16),
            _Label(l10n.writingCustomLevelLabel),
            _ChipRow(
              options: _levelsForProvider,
              labelOf: (l) => l.toUpperCase(),
              active: _level,
              onSelect: (l) => setState(() => _level = l),
            ),
            const SizedBox(height: 16),
            _Label(l10n.writingCustomTeilLabel),
            _ChipRow(
              options: const ['0', '1', '2', '3'],
              labelOf: (t) => t == '0' ? l10n.writingCustomTeilNone : 'Teil $t',
              active: _teil.toString(),
              onSelect: (t) => setState(() => _teil = int.parse(t)),
            ),
            const SizedBox(height: 16),
            _Label(l10n.writingCustomTaskLabel),
            TextField(
              controller: _taskController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: _aiPolish ? l10n.writingCustomTaskHintPolish : l10n.writingCustomTaskHintPlain,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            _Label(_aiPolish ? l10n.writingCustomPointsLabelPolish : l10n.writingCustomPointsLabelPlain),
            TextField(
              controller: _pointsController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: l10n.writingCustomPointsHint,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            CheckboxListTile(
              value: _aiPolish,
              onChanged: (v) => setState(() => _aiPolish = v ?? true),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(l10n.writingAiPolishTitle, style: const TextStyle(fontSize: 13)),
              subtitle: Text(l10n.writingAiPolishDesc, style: const TextStyle(fontSize: 11)),
            ),
            if (_prepareError != null) ...[
              const SizedBox(height: 4),
              Text(_prepareError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
            ],
            const SizedBox(height: 12),
            GradientButton(
              label: _busy
                  ? l10n.writingAiPolishing
                  : (_aiPolish ? l10n.writingCustomStartPolish : l10n.writingCustomStartPlain),
              onPressed: _busy ? null : _handleStart,
              loading: _busy,
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
          color: tokens.mutedForeground,
        ),
      ),
    );
  }
}

class _ChipRow extends StatelessWidget {
  const _ChipRow({
    required this.options,
    required this.labelOf,
    required this.active,
    required this.onSelect,
  });

  final List<String> options;
  final String Function(String) labelOf;
  final String active;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final o in options)
          InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: () => onSelect(o),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: active == o ? tokens.primary : tokens.muted,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                labelOf(o),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: active == o ? Colors.white : tokens.mutedForeground,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
