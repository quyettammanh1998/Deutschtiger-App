import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../features/writing/data/sprint/sprint_repository.dart';
import '../../../../features/writing/data/sprint/sr_queue_store.dart';
import '../../../../features/writing/domain/sprint/sr_card_queue.dart';
import '../../../../features/writing/domain/sprint/sprint_types.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../widgets/common/async_state_views.dart';
import 'widgets/sr_mode_picker.dart';

/// Sprint v2 entry page — mode picker (Marathon/Daily) + Start/Resume CTAs.
/// Web parity `exam-writing-sprint-page.tsx`.
class ExamWritingSprintPage extends ConsumerStatefulWidget {
  const ExamWritingSprintPage({super.key});

  @override
  ConsumerState<ExamWritingSprintPage> createState() => _ExamWritingSprintPageState();
}

class _ExamWritingSprintPageState extends ConsumerState<ExamWritingSprintPage> {
  final _store = SrQueueStore();
  SRMode _selectedMode = SRMode.marathon;
  bool _hasResume = false;
  bool _resumeChecked = false;

  @override
  void initState() {
    super.initState();
    _checkResume();
  }

  Future<void> _checkResume() async {
    final queue = await _store.load();
    if (!mounted) return;
    setState(() {
      _hasResume = queue != null && queue.cards.isNotEmpty;
      if (queue != null) _selectedMode = queue.mode;
      _resumeChecked = true;
    });
  }

  /// Builds a fresh queue and persists it — same `buildQueue` domain helper
  /// the session page's own "start fresh" affordance uses, so both paths
  /// stay identical.
  Future<void> _start({bool fresh = false}) async {
    final topics = await ref.read(sprintTopicsProvider.future);
    if (fresh) await _store.clear();
    if (fresh || !_hasResume) {
      await _store.save(buildQueue(topics, _selectedMode));
    }
    if (!mounted) return;
    context.push('/exam/goethe-b1/writing/sprint/session');
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final topicsAsync = ref.watch(sprintTopicsProvider);

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            Row(
              children: [
                IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
                Expanded(
                  child: Text(l10n.writingSprintTitle, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: tokens.foreground)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(l10n.writingSprintSubtitle, style: TextStyle(fontSize: 13, color: tokens.mutedForeground)),
            ),
            const SizedBox(height: 20),
            topicsAsync.when(
              loading: () => const Padding(padding: EdgeInsets.symmetric(vertical: 32), child: LoadingView()),
              error: (_, _) => ErrorView(message: l10n.couldNotLoadData, onRetry: () => ref.invalidate(sprintTopicsProvider)),
              data: (topics) {
                if (!_resumeChecked) return const Padding(padding: EdgeInsets.symmetric(vertical: 32), child: LoadingView());
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.writingSprintModePickerLabel, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: tokens.foreground)),
                    const SizedBox(height: 8),
                    SrModePicker(value: _selectedMode, onChanged: (m) => setState(() => _selectedMode = m)),
                    const SizedBox(height: 20),
                    if (_hasResume) ...[
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => context.push('/exam/goethe-b1/writing/sprint/session'),
                          style: ElevatedButton.styleFrom(backgroundColor: tokens.primary, foregroundColor: tokens.primaryForeground, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                          child: Text(l10n.writingSprintResumeButton),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => _start(fresh: true),
                          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                          child: Text(l10n.writingSprintStartFreshButton),
                        ),
                      ),
                    ] else
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: topics.isEmpty ? null : () => _start(),
                          style: ElevatedButton.styleFrom(backgroundColor: tokens.primary, foregroundColor: tokens.primaryForeground, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                          child: Text(l10n.writingSprintStartButton(topics.length)),
                        ),
                      ),
                    const SizedBox(height: 20),
                    Divider(color: tokens.border),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => context.push('/exam/goethe-b1/writing/sprint/thi-thu'),
                        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        child: Text(l10n.writingSprintMockCta),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: TextButton(
                        onPressed: () => context.push('/exam/goethe-b1/writing/sprint/cheatsheet'),
                        child: Text(l10n.writingSprintCheatsheetCta, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: tokens.primary)),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
