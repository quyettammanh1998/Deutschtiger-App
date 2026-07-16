import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_tokens.dart';
import '../../data/speech/conversation_models.dart';
import '../../l10n/app_localizations.dart';
import '../../services/api_client.dart';
import '../../view_models/speech/conversation_provider.dart';
import 'widgets/interview_import_edit_step.dart';
import 'widgets/interview_import_input_step.dart';

/// `/conversation/interview/import` — premium "luyện phỏng vấn từ tài liệu":
/// paste a doc → AI extracts a draft (questions + prepared-answer hints) →
/// review/edit → save & practise. Web parity: `interview-import-page.tsx`.
///
/// File upload (web: `.md`/`.txt` picker) is dropped — no file-picker
/// dependency is wired into this app; paste-only covers the same backend
/// contract (`markdown` string) without adding a new package. Flagged for
/// the coordinator/product if file upload is required later.
class InterviewImportPage extends ConsumerStatefulWidget {
  const InterviewImportPage({super.key});

  @override
  ConsumerState<InterviewImportPage> createState() => _InterviewImportPageState();
}

class _InterviewImportPageState extends ConsumerState<InterviewImportPage> {
  final _docController = TextEditingController();
  final _titleController = TextEditingController();
  String _level = 'B1';
  bool _busy = false;
  String? _error;
  bool _editing = false;
  List<RequiredPoint> _points = [];
  String _sourceMarkdown = '';

  @override
  void dispose() {
    _docController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _extract() async {
    final doc = _docController.text.trim();
    if (doc.length < 10) {
      setState(() => _error = 'Hãy dán nội dung tài liệu phỏng vấn (tối thiểu vài dòng).');
      return;
    }
    setState(() { _error = null; _busy = true; });
    try {
      final scenario = await ref.read(interviewRepositoryProvider).extractInterview(markdown: doc, level: _level);
      setState(() {
        _titleController.text = scenario.titleVi.isNotEmpty ? scenario.titleVi : 'Luyện phỏng vấn';
        _points = scenario.requiredPoints;
        _sourceMarkdown = doc;
        _editing = true;
        _busy = false;
      });
    } on ApiException catch (e) {
      setState(() { _busy = false; _error = _friendlyError(e); });
    }
  }

  String _friendlyError(ApiException e) {
    if (e.statusCode == 403) return 'Tính năng này dành cho tài khoản Premium.';
    if (e.statusCode == 502) return 'Không trích xuất được — hãy dán nội dung rõ ràng hơn rồi thử lại.';
    return e.message;
  }

  Future<void> _save() async {
    final cleaned = _points
        .map((p) => p.copyWith(de: p.de.trim(), vi: p.vi.trim()))
        .where((p) => p.de.isNotEmpty)
        .toList();
    if (cleaned.isEmpty) {
      setState(() => _error = 'Cần ít nhất một câu hỏi phỏng vấn.');
      return;
    }
    setState(() { _error = null; _busy = true; });
    try {
      final draft = Scenario(
        id: '',
        titleDe: 'Bewerbungsgespräch',
        titleVi: _titleController.text.trim().isNotEmpty ? _titleController.text.trim() : 'Luyện phỏng vấn',
        level: _level,
        aiRole: '',
        userRole: '',
        contextDe: '',
        contextVi: '',
        requiredPoints: cleaned,
        starterPromptDe: '',
        icon: 'Briefcase',
      );
      final id = await ref.read(interviewRepositoryProvider).saveInterviewScenario(
            title: draft.titleVi,
            level: _level,
            scenario: draft,
            sourceMarkdown: _sourceMarkdown,
          );
      if (mounted) context.go('/conversation/interview/play/$id');
    } on ApiException catch (e) {
      setState(() { _busy = false; _error = _friendlyError(e); });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: () => _editing ? setState(() => _editing = false) : context.go('/conversation'),
                icon: const Icon(Icons.arrow_back, size: 16),
                label: Text(_editing ? l10n.interviewImportBackToEdit : l10n.conversationHubTitle),
              ),
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(gradient: LinearGradient(colors: [tokens.primary, tokens.primary.withValues(alpha: 0.8)]), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.description_outlined, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.interviewImportTitle, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: tokens.foreground)),
                        Text(l10n.interviewImportDesc, style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_error != null)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
                  child: Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13)),
                ),
              if (!_editing)
                InterviewImportInputStep(
                  controller: _docController,
                  level: _level,
                  onLevelChanged: (v) => setState(() => _level = v),
                  busy: _busy,
                  onExtract: _extract,
                )
              else
                InterviewImportEditStep(
                  titleController: _titleController,
                  points: _points,
                  onUpdatePoint: (i, p) => setState(() => _points[i] = p),
                  onRemovePoint: (i) => setState(() => _points.removeAt(i)),
                  onAddPoint: () => setState(() => _points.add(const RequiredPoint(de: '', vi: ''))),
                  busy: _busy,
                  onSave: _save,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
