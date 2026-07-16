import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../features/premium/domain/premium_providers.dart';
import '../../../features/writing/data/goethe_b1_writing_repository.dart';
import '../../../features/writing/domain/goethe_b1_writing_access.dart';
import '../../../features/writing/domain/goethe_b1_writing_topic.dart';
import '../../../l10n/app_localizations.dart';
import '../../../view_models/providers.dart';
import '../../../widgets/common/app_markdown_view.dart';
import '../../../widgets/common/async_state_views.dart';
import 'widgets/detail/collapsible_section.dart';
import 'widgets/detail/common_mistakes_card.dart';
import 'widgets/detail/complete_and_lock_views.dart';
import 'widgets/detail/detail_header.dart';
import 'widgets/detail/floating_toc.dart';
import 'widgets/detail/grammar_focus_card.dart';
import 'widgets/detail/model_answers_card.dart';
import 'widgets/detail/provenance_card.dart';
import 'widgets/detail/sample_sentences_card.dart';
import 'widgets/detail/task_analysis_card.dart';
import 'widgets/detail/task_card.dart';
import 'widgets/detail/text_structure_card.dart';
import 'widgets/detail/typing_practice_start_card.dart';
import 'widgets/detail/uebungen_section.dart';
import 'widgets/detail/useful_phrases_card.dart';
import 'widgets/detail/wortschatz_card.dart';
import 'widgets/typing_practice/collect_practice_sentences.dart';

/// Goethe B1 writing reader — web parity `goethe-b1-writing-detail-page.tsx`.
/// Full 30+ component spec:
/// `plans/reports/scout-260717-0014-goethe-b1-writing-detail-components-spec-report.md`.
///
/// Deviations from that spec (all documented, not silent drops — see phase
/// report for the complete list):
/// - Autoplay is a single "Phát toàn bộ" pill (sequential exclusive
///   playback via [WritingAudioPlayButton]'s shared player), not the full
///   prev/pause/next fixed transport bar with karaoke sub-sentence
///   highlighting and auto-scroll.
/// - TOC follows DOM order (grammatik → fehler → wortschatz) instead of the
///   web's inconsistent TOC-vs-DOM order — the spec's own unresolved
///   question #1 recommends this for pixel-parity purposes.
/// - `taskVariant` ("🔀 Biến thể đề thi") is not rendered.
/// - No official-DB topic merge (`isOfficialLocked` is always `false` from
///   this endpoint) — see topic-list page's matching deviation note.
/// - Typing-practice suite and error-correction/mini-write AI grading are
///   simplified — see their respective widget doc comments.
class GoetheB1WritingDetailPage extends ConsumerStatefulWidget {
  const GoetheB1WritingDetailPage({super.key, required this.teil, required this.slug});

  final int teil;
  final String slug;

  @override
  ConsumerState<GoetheB1WritingDetailPage> createState() => _GoetheB1WritingDetailPageState();
}

class _GoetheB1WritingDetailPageState extends ConsumerState<GoetheB1WritingDetailPage> {
  final Map<String, bool> _openMap = {};
  double _fontScale = 1.0;
  bool _saving = false;

  bool _isOpen(String id, bool defaultOpen) => _openMap[id] ?? defaultOpen;

  void _toggle(String id, bool defaultOpen) =>
      setState(() => _openMap[id] = !_isOpen(id, defaultOpen));

  Future<void> _playAll(List<String> sentences) async {
    setState(() => _openMap.updateAll((k, v) => true));
    final audio = ref.read(audioServiceProvider);
    for (final s in sentences.take(30)) {
      await audio.play(text: s);
      await Future<void>.delayed(const Duration(milliseconds: 400));
    }
  }

  Future<void> _markComplete(int teil, String slug) async {
    setState(() => _saving = true);
    try {
      await ref.read(goetheB1WritingRepositoryProvider).upsertResult(teil: teil, slug: slug);
      ref.invalidate(goetheB1WritingTeilResultsProvider(teil));
      ref.invalidate(goetheB1WritingAllResultsProvider);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).couldNotLoadData)));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final topicAsync =
        ref.watch(goetheB1WritingTopicProvider((teil: widget.teil, slug: widget.slug)));

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: topicAsync.when(
          loading: () => const LoadingView(),
          error: (_, _) => ErrorView(
            message: l10n.couldNotLoadData,
            onRetry: () => ref.invalidate(
              goetheB1WritingTopicProvider((teil: widget.teil, slug: widget.slug)),
            ),
          ),
          data: (topic) => _buildBody(context, tokens, l10n, topic),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AppTokens tokens, AppLocalizations l10n, GoetheB1WritingTopic topic) {
    if (topic.isIntro) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
              Expanded(
                child: Text(topic.titleDe, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: tokens.foreground)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppMarkdownView(topic.bodyMarkdown),
        ],
      );
    }

    final teilAsync = ref.watch(goetheB1WritingTeilProvider(widget.teil));
    final hasFullAccess = ref.watch(premiumProvider).valueOrNull ?? false;
    final allTopics = teilAsync.valueOrNull?.topics ?? const [];
    final isLocked = topic.isOfficialLocked ||
        (allTopics.isNotEmpty &&
            !hasFullAccess &&
            !freeUnlockedWritingTopicSlugs(allTopics).contains(topic.slug));

    if (isLocked) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
              Expanded(
                child: Text(topic.titleDe, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: tokens.foreground)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          WritingLockCard(isOfficial: topic.isOfficialLocked),
        ],
      );
    }

    final resultsAsync = ref.watch(goetheB1WritingTeilResultsProvider(widget.teil));
    final isCompleted =
        resultsAsync.valueOrNull?.any((r) => r.slug == topic.slug) ?? false;
    final sentences = collectWritingPracticeSentences(topic);

    final sections = _buildSections(context, topic);

    return Stack(
      children: [
        MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(_fontScale)),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
            children: [
              WritingDetailHeader(
                topic: topic,
                fontScale: _fontScale,
                onFontScaleChange: (v) => setState(() => _fontScale = v),
                onPlayAll: () => _playAll(sentences),
                canPlayAll: sentences.isNotEmpty,
              ),
              const SizedBox(height: 12),
              if (WritingProvenanceCard.hasContent(topic)) WritingProvenanceCard(topic: topic),
              WritingTaskCard(topic: topic, sectionKey: const ValueKey('sec-aufgabe')),
              const SizedBox(height: 10),
              for (final s in sections) ...[s.widget, const SizedBox(height: 10)],
              WritingTypingPracticeStartCard(sentences: sentences),
              const SizedBox(height: 10),
              if (topic.task != null)
                InkWell(
                  onTap: () => context.push('/exam/goethe-b1/writing/${widget.teil}/${widget.slug}/practice'),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFF97316), Color(0xFFEA580C)]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(l10n.writingStartPracticeCta,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              const SizedBox(height: 20),
              WritingCompleteCta(
                isCompleted: isCompleted,
                isSaving: _saving,
                onTap: () => _markComplete(widget.teil, widget.slug),
              ),
            ],
          ),
        ),
        Builder(builder: (_) {
          final tocSections = sections.where((s) => s.inToc).toList();
          return FloatingTocPill(
            entries: tocSections.map((s) => TocEntry(s.id, s.emoji, s.label)).toList(),
            activeId: tocSections.isEmpty ? null : tocSections.first.id,
            onSelect: (id) {
              final section = sections.firstWhere((s) => s.id == id, orElse: () => sections.first);
              setState(() => _openMap[id] = true);
              final ctx = section.key.currentContext;
              if (ctx != null) {
                Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 300));
              }
            },
          );
        }),
      ],
    );
  }

  List<_ReaderSection> _buildSections(BuildContext context, GoetheB1WritingTopic topic) {
    final l10n = AppLocalizations.of(context);
    final sections = <_ReaderSection>[];

    if (topic.taskAnalysis != null && topic.taskAnalysis!.points.isNotEmpty) {
      sections.add(_section('sec-task-analysis', '🎯', l10n.writingSectionTaskAnalysis, true,
          WritingTaskAnalysisCard(analysis: topic.taskAnalysis!)));
    }
    if (topic.textStructure.isNotEmpty) {
      sections.add(_section('sec-text-structure', '🏗️', l10n.writingSectionTextStructure, true,
          WritingTextStructureCard(rows: topic.textStructure), inToc: false));
    }
    if (topic.usefulPhrases.isNotEmpty) {
      sections.add(_section('sec-redemittel', '💬', l10n.writingSectionPhrases, true,
          WritingUsefulPhrasesCard(categories: topic.usefulPhrases)));
    }
    if (topic.sampleSentences.isNotEmpty) {
      sections.add(_section('sec-beispiele', '✏️', l10n.writingSectionSamples, true,
          WritingSampleSentencesCard(groups: topic.sampleSentences)));
    }
    if (topic.modelAnswers.isNotEmpty) {
      sections.add(_section('sec-muster', '📝', l10n.writingSectionModels, true,
          WritingModelAnswersCard(models: topic.modelAnswers)));
    }
    if (topic.grammarFocus.isNotEmpty) {
      sections.add(_section('sec-grammatik', '📐', l10n.writingSectionGrammar, false,
          WritingGrammarFocusCard(items: topic.grammarFocus)));
    }
    if (topic.wortschatzBox != null && !topic.wortschatzBox!.isEmpty) {
      sections.add(_section('sec-wortschatz', '📚', l10n.writingSectionVocab, false,
          WritingWortschatzCard(box: topic.wortschatzBox!)));
    }
    if (topic.commonMistakes.isNotEmpty) {
      sections.add(_section('sec-fehler', '⚠️', l10n.writingSectionMistakes, false,
          WritingCommonMistakesCard(items: topic.commonMistakes)));
    }
    if (topic.uebungen.isNotEmpty || (topic.uebungenRaw?.isNotEmpty ?? false)) {
      sections.add(_section('sec-uebungen', '🎯', l10n.writingSectionExercises, true,
          WritingUebungenSection(topic: topic)));
    }
    return sections;
  }

  _ReaderSection _section(String id, String emoji, String label, bool defaultOpen, Widget content, {bool inToc = true}) {
    final key = GlobalKey();
    return _ReaderSection(
      id: id,
      emoji: emoji,
      label: label,
      key: key,
      inToc: inToc,
      widget: CollapsibleSection(
        key: ValueKey(id),
        sectionKey: key,
        title: '$emoji $label',
        isOpen: _isOpen(id, defaultOpen),
        onToggle: () => _toggle(id, defaultOpen),
        child: content,
      ),
    );
  }
}

class _ReaderSection {
  const _ReaderSection({
    required this.id,
    required this.emoji,
    required this.label,
    required this.key,
    required this.widget,
    this.inToc = true,
  });

  final String id;
  final String emoji;
  final String label;
  final GlobalKey key;
  final Widget widget;
  final bool inToc;
}
