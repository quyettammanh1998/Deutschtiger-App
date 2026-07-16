import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../features/writing/data/writing_repository.dart';
import '../../../../../features/writing/domain/writing_exam_id_parser.dart';
import '../../../../../features/writing/domain/writing_submission.dart';
import '../../../../../features/writing/domain/writing_submission_meta.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../widgets/common/gradient_button.dart';
import 'submissions/writing_criteria_trend.dart';
import 'submissions/writing_submission_list_item.dart';
import 'submissions/writing_submissions_filter_bar.dart';

/// `GET /user/writing-submissions` with no `exam_id` → latest 50 across all
/// providers (backend `ListWritingSubmissions`/`GetWritingSubmissions`).
final allWritingSubmissionsProvider = FutureProvider.autoDispose<List<WritingSubmission>>((ref) {
  return ref.watch(writingRepositoryProvider).listSubmissions('');
});

typedef _Parsed = ({
  WritingSubmission submission,
  ParsedWritingExamId parsed,
  WritingSubmissionMeta meta,
});

/// "Bài của tôi" tab — web parity `WritingSubmissionsTab`: criteria trend,
/// filter bar, submission list, pagination.
class WritingSubmissionsTab extends ConsumerStatefulWidget {
  const WritingSubmissionsTab({super.key, required this.onStartPractice});

  final VoidCallback onStartPractice;

  @override
  ConsumerState<WritingSubmissionsTab> createState() => _WritingSubmissionsTabState();
}

class _WritingSubmissionsTabState extends ConsumerState<WritingSubmissionsTab> {
  WritingSubmissionsFilterState _filter = const WritingSubmissionsFilterState();
  static const _pageSize = 20;
  int _page = 1;

  List<_Parsed> _parseAll(List<WritingSubmission> submissions) {
    final out = <_Parsed>[];
    for (final s in submissions) {
      final parsed = parseWritingExamId(s.examId);
      if (parsed == null) continue;
      out.add((
        submission: s,
        parsed: parsed,
        meta: getWritingSubmissionMeta(parsed: parsed, taskPrompt: s.taskPrompt),
      ));
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final async = ref.watch(allWritingSubmissionsProvider);

    return async.when(
      loading: () => Column(
        children: List.generate(
          3,
          (_) => Container(
            height: 96,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(color: tokens.muted, borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ),
      error: (_, _) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text(l10n.couldNotLoadData, style: TextStyle(color: tokens.mutedForeground)),
        ),
      ),
      data: (submissions) => _buildBody(context, tokens, l10n, submissions),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppTokens tokens,
    AppLocalizations l10n,
    List<WritingSubmission> submissions,
  ) {
    final parsed = _parseAll(submissions);

    final providers = parsed.map((x) => x.meta.provider).toSet().toList()..sort();
    final levels = parsed.map((x) => x.meta.level).toSet().toList()..sort();
    final teils = parsed.map((x) => x.meta.teil).whereType<int>().toSet().toList()..sort();

    final query = _filter.search.trim().toLowerCase();
    var filtered = parsed.where((x) {
      if (_filter.provider != null && x.meta.provider != _filter.provider) return false;
      if (_filter.level != null && x.meta.level != _filter.level) return false;
      if (_filter.teil != null && x.meta.teil != _filter.teil) return false;
      if (query.isNotEmpty) {
        final haystack =
            '${x.meta.title} ${x.submission.taskPrompt} ${x.submission.studentAnswer}'.toLowerCase();
        if (!haystack.contains(query)) return false;
      }
      return true;
    }).toList();

    if (_filter.sortBy == WritingSubmissionSort.score) {
      filtered.sort((a, b) => (b.submission.aiScore ?? -1).compareTo(a.submission.aiScore ?? -1));
    } else {
      filtered.sort((a, b) => b.submission.submittedAt.compareTo(a.submission.submittedAt));
    }

    final paginated = filtered.take(_page * _pageSize).toList();
    final hasMore = paginated.length < filtered.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WritingCriteriaTrend(submissions: submissions),
        if (parsed.isNotEmpty) ...[
          WritingSubmissionsFilterBar(
            providers: providers,
            levels: levels,
            teils: teils,
            state: _filter,
            onChange: (next) => setState(() {
              _filter = next;
              _page = 1;
            }),
          ),
          const SizedBox(height: 16),
        ],
        if (parsed.isEmpty)
          _EmptyState(l10n: l10n, tokens: tokens, onStartPractice: widget.onStartPractice)
        else if (filtered.isEmpty)
          _NoMatchState(
            l10n: l10n,
            tokens: tokens,
            onClear: () => setState(() {
              _filter = const WritingSubmissionsFilterState();
              _page = 1;
            }),
          )
        else ...[
          for (final item in paginated)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: WritingSubmissionListItem(submission: item.submission, meta: item.meta),
            ),
          if (hasMore)
            OutlinedButton(
              onPressed: () => setState(() => _page++),
              child: Text(l10n.writingShowMore),
            ),
        ],
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.l10n, required this.tokens, required this.onStartPractice});
  final AppLocalizations l10n;
  final AppTokens tokens;
  final VoidCallback onStartPractice;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          const Text('✍️', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 12),
          Text(
            l10n.writingSubmissionsEmptyTitle,
            style: TextStyle(fontWeight: FontWeight.w700, color: tokens.foreground),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.writingSubmissionsEmptyDesc,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: tokens.mutedForeground),
          ),
          const SizedBox(height: 16),
          GradientButton(label: l10n.writingChooseNow, onPressed: onStartPractice),
        ],
      ),
    );
  }
}

class _NoMatchState extends StatelessWidget {
  const _NoMatchState({required this.l10n, required this.tokens, required this.onClear});
  final AppLocalizations l10n;
  final AppTokens tokens;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          const Text('🔍', style: TextStyle(fontSize: 32)),
          const SizedBox(height: 8),
          Text(
            l10n.writingSubmissionsNoMatch,
            style: TextStyle(fontSize: 13, color: tokens.mutedForeground),
          ),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: onClear, child: Text(l10n.writingClearFilters)),
        ],
      ),
    );
  }
}
