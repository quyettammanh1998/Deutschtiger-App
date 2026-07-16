import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/exam/de_thi_repository.dart';
import '../../view_models/exam/exam_ecosystem_providers.dart';
import '../../widgets/common/async_state_views.dart';
import 'widgets/de_thi/de_thi_practice_body.dart';

/// Làm đề thi public theo mã đề (`/de-thi/:code`) — public route, không cần
/// đăng nhập, phục vụ deep-link SEO.
///
/// Web parity: `de-thi-practice-page.tsx` — one passage visible at a time
/// (paginated via footer Prev/Next, not full scroll), submit-all reveal
/// model, answers persisted locally (mirrors web's `localStorage`).
class DeThiPracticeScreen extends ConsumerStatefulWidget {
  const DeThiPracticeScreen({super.key, required this.code});
  final String code;

  @override
  ConsumerState<DeThiPracticeScreen> createState() =>
      _DeThiPracticeScreenState();
}

class _DeThiPracticeScreenState extends ConsumerState<DeThiPracticeScreen> {
  final Map<int, String> _answers = {};
  bool _submitted = false;
  int _passageIndex = 0;
  bool _restored = false;

  String get _prefsKey => 'de_thi_${widget.code}';

  @override
  void initState() {
    super.initState();
    _restore();
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null) {
      setState(() => _restored = true);
      return;
    }
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final answers = (decoded['answers'] as Map<String, dynamic>? ?? {});
      setState(() {
        _answers
          ..clear()
          ..addEntries(
            answers.entries.map(
              (e) => MapEntry(int.parse(e.key), e.value as String),
            ),
          );
        _submitted = decoded['submitted'] as bool? ?? false;
        _restored = true;
      });
    } catch (_) {
      await prefs.remove(_prefsKey);
      setState(() => _restored = true);
    }
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefsKey,
      jsonEncode({
        'answers': _answers.map((k, v) => MapEntry('$k', v)),
        'submitted': _submitted,
      }),
    );
  }

  void _select(int questionNo, String option) {
    if (_submitted) return;
    setState(() => _answers[questionNo] = option);
    _persist();
  }

  void _goPrev() =>
      setState(() => _passageIndex = (_passageIndex - 1).clamp(0, 1 << 30));

  void _goNext(int totalPassages) {
    if (_passageIndex == totalPassages - 1) {
      _submit();
      return;
    }
    setState(() => _passageIndex += 1);
  }

  void _submit() {
    setState(() {
      _submitted = true;
      _passageIndex = 0;
    });
    _persist();
  }

  void _retry() {
    setState(() {
      _answers.clear();
      _submitted = false;
      _passageIndex = 0;
    });
    SharedPreferences.getInstance().then((p) => p.remove(_prefsKey));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final entry = ref.read(deThiRepositoryProvider).findEntry(widget.code);

    if (entry == null) {
      return Scaffold(
        backgroundColor: tokens.background,
        appBar: AppBar(title: Text(l10n.deThiListTitle)),
        body: Center(
          child: Text(
            l10n.deThiNotFound,
            style: TextStyle(color: tokens.mutedForeground),
          ),
        ),
      );
    }

    final examAsync = ref.watch(deThiExamProvider(entry.dataPath));

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: !_restored
            ? const LoadingView()
            : examAsync.when(
                loading: () => const LoadingView(),
                error: (error, _) => ErrorView(
                  message: l10n.couldNotLoadData,
                  onRetry: () =>
                      ref.invalidate(deThiExamProvider(entry.dataPath)),
                ),
                data: (exam) => DeThiPracticeBody(
                  entry: entry,
                  exam: exam,
                  answers: _answers,
                  submitted: _submitted,
                  passageIndex: _passageIndex.clamp(
                    0,
                    exam.passages.isEmpty ? 0 : exam.passages.length - 1,
                  ),
                  onSelect: _select,
                  onPrev: _goPrev,
                  onNext: () => _goNext(exam.passages.length),
                  onSubmit: _submit,
                  onRetry: _retry,
                  onJumpTo: (i) => setState(() => _passageIndex = i),
                ),
              ),
      ),
    );
  }
}
