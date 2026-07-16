import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../data/vocab_lesson_models.dart';
import '../data/vocab_lesson_utils.dart';
import 'vocab_lesson_provider.dart';
import 'vocab_lesson_session_controller.dart';
import 'vocabulary_provider.dart';
import 'widgets/lesson/lesson_cloze_card.dart';
import 'widgets/lesson/lesson_compose_card.dart';
import 'widgets/lesson/lesson_end_states.dart';
import 'widgets/lesson/lesson_flip_listen_cards.dart';
import 'widgets/lesson/lesson_mode_select_view.dart';
import 'widgets/lesson/lesson_rating_grid.dart';
import 'widgets/lesson/lesson_session_header.dart';
import 'widgets/lesson/lesson_writing_choice_cards.dart';

/// C2 — Vocabulary lesson screen. Topic-scoped SRS session: mode select
/// (Nhanh/Đầy đủ/Chuyên sâu) → 7 card-mode renderers → FSRS rating grid.
/// Web parity: `vocabulary-lesson-page.tsx`.
///
/// Route contract unchanged (`topicKey` + optional `level` overlay) — the
/// current Flutter route table (`lib/navigation/routes/vocabulary_routes.dart`,
/// out of scope this pass) only wires topic-mode; the legacy
/// collection-slug and pure level-mode paths from web are supported by
/// [VocabLessonRepository] but unreachable until a route change adds them.
class VocabularyLessonScreen extends ConsumerStatefulWidget {
  const VocabularyLessonScreen({super.key, required this.topicKey, this.level});

  final String topicKey;
  final String? level;

  @override
  ConsumerState<VocabularyLessonScreen> createState() => _VocabularyLessonScreenState();
}

class _VocabularyLessonScreenState extends ConsumerState<VocabularyLessonScreen> {
  VocabLessonMode? _mode;
  VocabLessonSessionController? _controller;
  String? _controllerForCards;

  void _pickMode(VocabLessonMode mode) => setState(() => _mode = mode);

  VocabLessonBatchParams? get _currentParams {
    final mode = _mode;
    if (mode == null) return null;
    return VocabLessonBatchParams(topicKey: widget.topicKey, level: widget.level, mode: mode);
  }

  /// "Học batch mới" — invalidate the cached batch so the family re-fetches
  /// (already-rated cards drop out of the due/new pool server-side).
  void _restart() {
    final params = _currentParams;
    setState(() {
      _controller?.dispose();
      _controller = null;
      _controllerForCards = null;
    });
    if (params != null) ref.invalidate(vocabLessonBatchProvider(params));
  }

  void _changeMode() {
    _restart();
    setState(() => _mode = null);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  VocabLessonSessionController _buildController(List<LessonCard> cards, VocabLessonModeConfig config) {
    final cardModes = distributeVocabCardModes(cards, config.pool, batchHasChoice: cards.length >= 4);
    final choiceOptions = buildChoiceOptions(cards);
    return VocabLessonSessionController(
      cards: cards,
      cardModes: cardModes,
      choiceOptions: choiceOptions,
      lessonRepository: ref.read(vocabLessonRepositoryProvider),
      wordWritingRepository: ref.read(vocabWordWritingRepositoryProvider),
      learnRepository: ref.read(vocabLearnRepositoryProvider),
      levelHint: widget.level ?? '',
    );
  }

  String _collectionName(AppLocalizations l10n) {
    final topics = ref.watch(vocabularyTopicsProvider).valueOrNull ?? const [];
    final match = topics.where((t) => t.key == widget.topicKey);
    final label = match.isNotEmpty ? match.first.labelVi : '';
    final base = label.isNotEmpty ? label : l10n.vocabularyTopicTitle(widget.topicKey);
    final overlay = widget.level;
    return overlay == null || overlay.isEmpty ? base : '$base · ${overlay.toUpperCase()}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final mode = _mode;
    final collectionName = _collectionName(l10n);

    if (mode == null) {
      return Scaffold(
        backgroundColor: tokens.background,
        body: SafeArea(
          child: LessonModeSelectView(collectionName: collectionName, onSelect: _pickMode),
        ),
      );
    }

    final config = vocabLessonModeConfig[mode]!;
    final batchAsync = ref.watch(
      vocabLessonBatchProvider(
        VocabLessonBatchParams(topicKey: widget.topicKey, level: widget.level, mode: mode),
      ),
    );

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: batchAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => LessonMessageView(
            emoji: '⚠️',
            title: l10n.couldNotLoadVocabulary,
            secondaryLabel: 'Quay lại',
            onSecondary: () => Navigator.of(context).maybePop(),
          ),
          data: (batch) {
            if (batch.degenerate || batch.cards.isEmpty) {
              final celebration = batch.reason == 'all_graduated';
              return LessonMessageView(
                emoji: celebration ? '🎉' : '📭',
                title: celebration ? 'Bạn đã master bộ này!' : 'Chưa có từ để học',
                subtitle: celebration
                    ? 'Tất cả từ trong bộ này đã được học vững. Thử bộ tiếp theo nhé.'
                    : 'Bộ từ vựng này chưa có dữ liệu.',
                primaryLabel: 'Quay lại bộ từ vựng',
                onPrimary: () => Navigator.of(context).maybePop(),
              );
            }

            if (_controllerForCards != batch.cards.map((c) => c.id).join(',')) {
              _controller?.dispose();
              _controller = _buildController(batch.cards, config);
              _controllerForCards = batch.cards.map((c) => c.id).join(',');
            }
            final controller = _controller!;

            return ListenableBuilder(
              listenable: controller,
              builder: (context, _) {
                if (controller.isDone) {
                  return LessonMessageView(
                    emoji: '✅',
                    title: 'Hoàn thành buổi học!',
                    subtitle: 'Đã học ${controller.completedCount} / ${controller.cards.length} từ · ${config.emoji} ${config.label}',
                    secondaryLabel: 'Học batch mới',
                    onSecondary: _restart,
                    primaryLabel: 'Xong',
                    onPrimary: () => Navigator.of(context).maybePop(),
                    tertiaryLabel: 'Đổi chế độ học',
                    onTertiary: _changeMode,
                  );
                }
                return _StudyingBody(controller: controller, collectionName: collectionName);
              },
            );
          },
        ),
      ),
    );
  }
}

class _StudyingBody extends StatelessWidget {
  const _StudyingBody({required this.controller, required this.collectionName});

  final VocabLessonSessionController controller;
  final String collectionName;

  @override
  Widget build(BuildContext context) {
    final card = controller.currentCard!;
    return Column(
      children: [
        LessonSessionHeader(
          collectionName: collectionName,
          cardIndex: controller.cardIndex,
          total: controller.cards.length,
          mode: controller.currentMode,
          canMarkKnown: !controller.submitting,
          onBack: () => Navigator.of(context).maybePop(),
          onMarkKnown: controller.markAlreadyKnown,
        ),
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _CardRenderer(controller: controller, card: card),
            ),
          ),
        ),
        if (controller.hasAnswer)
          LessonRatingGrid(
            enabled: !controller.submitting,
            suggested: _suggestedRating(controller),
            onRate: controller.rate,
          ),
      ],
    );
  }

  int? _suggestedRating(VocabLessonSessionController c) {
    if (c.writingCorrect == true) return 3;
    if (c.writingCorrect == false) return 2;
    if (c.choiceResult?.correct == true) return 3;
    if (c.choiceResult != null && c.choiceResult!.correct == false) return 2;
    return null;
  }
}

class _CardRenderer extends StatelessWidget {
  const _CardRenderer({required this.controller, required this.card});

  final VocabLessonSessionController controller;
  final LessonCard card;

  @override
  Widget build(BuildContext context) {
    final wordDe = card.displayDe;
    final wordVi = card.displayVi;
    final audioUrl = card.displayAudioUrl;

    switch (controller.currentMode) {
      case VocabCardMode.flip:
      case VocabCardMode.reverse:
        return LessonFlipCard(
          key: ValueKey(card.id),
          wordDe: wordDe,
          wordVi: wordVi,
          audioUrl: audioUrl,
          showBack: controller.showBack,
          onToggleBack: controller.toggleBack,
          isReverse: controller.currentMode == VocabCardMode.reverse,
        );
      case VocabCardMode.writing:
        return LessonWritingCard(
          key: ValueKey(card.id),
          wordDe: wordDe,
          wordVi: wordVi,
          audioUrl: audioUrl,
          correct: controller.writingCorrect,
          feedback: controller.writingFeedback,
          checking: controller.writingChecking,
          onInputChange: controller.setWritingInput,
          onSubmit: controller.submitWriting,
        );
      case VocabCardMode.listen:
        return LessonListenCard(
          key: ValueKey(card.id),
          wordDe: wordDe,
          wordVi: wordVi,
          audioUrl: audioUrl,
          showBack: controller.showBack,
          onToggleBack: controller.toggleBack,
        );
      case VocabCardMode.choice:
        return LessonChoiceCard(
          key: ValueKey(card.id),
          wordDe: wordDe,
          wordVi: wordVi,
          audioUrl: audioUrl,
          options: controller.choiceOptions[card.id] ?? const [],
          result: controller.choiceResult,
          onSelect: controller.selectChoice,
        );
      case VocabCardMode.cloze:
        final cloze = deriveCloze(card);
        if (cloze == null) return const SizedBox.shrink();
        return LessonClozeCard(
          key: ValueKey(card.id),
          prompt: cloze.prompt,
          target: cloze.answer,
          vi: cloze.vi,
          audioUrl: audioUrl,
          correct: controller.clozeCorrect,
          onInputChange: controller.setClozeInput,
          onSubmit: controller.submitCloze,
        );
      case VocabCardMode.compose:
        final ref = pickComposeReference(card);
        return LessonComposeCard(
          key: ValueKey(card.id),
          wordDe: wordDe,
          wordVi: wordVi,
          referenceDe: ref?.de ?? '',
          referenceVi: ref?.vi ?? '',
          audioUrl: audioUrl,
          correct: controller.composeCorrect,
          feedback: controller.composeFeedback,
          checking: controller.composeChecking,
          onInputChange: controller.setComposeInput,
          onSubmit: controller.submitCompose,
        );
    }
  }
}
