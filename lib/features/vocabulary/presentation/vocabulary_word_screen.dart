import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../data/practice/practice_round_item.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/common/sticky_cta_bar.dart';
import '../domain/vocabulary_models.dart';
import 'vocab_word_provider.dart';
import 'vocabulary_provider.dart';
import 'widgets/word/word_conjugation_card.dart';
import 'widgets/word/word_examples_card.dart';
import 'widgets/word/word_hero_card.dart';
import 'widgets/word/word_practice_sheet_games.dart';

/// Route-backed C3 screen. It resolves the requested word from the same topic
/// queue as C2, so deep links and in-app navigation share one data path.
class VocabularyWordRouteScreen extends ConsumerWidget {
  const VocabularyWordRouteScreen({
    super.key,
    required this.topicKey,
    required this.itemId,
    this.level,
  });

  final String topicKey;
  final String itemId;
  final String? level;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routeData = ref.watch(
      vocabularyWordRouteProvider((itemId: itemId, topicKey: topicKey, level: level)),
    );
    return routeData.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, _) => Scaffold(
        body: Center(child: Text(AppLocalizations.of(context).couldNotLoadVocabulary)),
      ),
      data: (data) {
        return VocabularyWordScreen(
          item: data.item,
          items: data.queue,
          onOpenDetail: topicKey.isEmpty
              ? null
              : (target) {
                  // Web parity: detail is a topic word-LIST, not a
                  // single-item focus view — itemId no longer targets a
                  // specific row (the old single-word detail screen was
                  // rebuilt into the list at `/vocabulary/topic-{key}`).
                  final location = Uri(
                    path: '/vocabulary/topic-$topicKey',
                    queryParameters: level != null ? {'level': level!} : null,
                  );
                  context.push(location.toString());
                },
        );
      },
    );
  }
}

/// C3 — Vocabulary word screen. Web parity: `vocabulary-word-page.tsx`.
///
/// Order: back row → hero card (badges, gender bar, speak/save, "Đã thuộc",
/// YouGlish) → examples card → conjugation card (if verb) → practice section
/// (SHEET_GAMES 4-icon grid) → sticky prev/next bottom bar (queue nav — the
/// Flutter route always carries a queue since C2 opens this screen from a
/// topic's SRS batch; web has no queue nav here, it's an app-only addition
/// kept from the pre-rebuild screen).
///
/// Deviations from web (documented, not silently dropped): no inline header
/// search (`MobileVocabSearch` — no standalone search endpoint wired in
/// Flutter this pass), no ancestor breadcrumb / sibling phrases (`getAncestors`/
/// `getChildren` have no Flutter repository methods yet), YouGlish renders as
/// an external-browser link (`youglish.com/pronounce/{word}/german`) instead
/// of an embedded iframe widget (no native YouGlish SDK).
class VocabularyWordScreen extends ConsumerStatefulWidget {
  const VocabularyWordScreen({
    super.key,
    required this.item,
    this.items = const [],
    this.onCompleted,
    this.onOpenDetail,
  });

  final LearningItem item;
  final List<LearningItem> items;
  final VoidCallback? onCompleted;
  final ValueChanged<LearningItem>? onOpenDetail;

  @override
  ConsumerState<VocabularyWordScreen> createState() => _VocabularyWordScreenState();
}

class _VocabularyWordScreenState extends ConsumerState<VocabularyWordScreen> {
  late int _index;
  bool _mastered = false;
  bool _masteredPending = false;
  bool _youglishOpen = false;

  @override
  void initState() {
    super.initState();
    final start = widget.items.indexWhere((it) => it.id == widget.item.id);
    _index = start < 0 ? 0 : start;
  }

  bool get _hasQueue => widget.items.isNotEmpty;
  LearningItem get _currentItem => _hasQueue ? widget.items[_index] : widget.item;

  void _next() {
    if (!_hasQueue) {
      Navigator.of(context).pop();
      return;
    }
    if (_index + 1 >= widget.items.length) {
      widget.onCompleted?.call();
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _index += 1;
      _mastered = false;
      _youglishOpen = false;
    });
  }

  void _prev() {
    if (_hasQueue && _index > 0) {
      setState(() {
        _index -= 1;
        _mastered = false;
        _youglishOpen = false;
      });
    }
  }

  Future<void> _markMastered() async {
    setState(() => _masteredPending = true);
    try {
      await markVocabWordMastered(ref, _currentItem.id);
      if (mounted) setState(() => _mastered = true);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không lưu được, thử lại sau.')),
        );
      }
    } finally {
      if (mounted) setState(() => _masteredPending = false);
    }
  }

  Future<void> _openYouglish(LearningItem item) async {
    if (_youglishOpen) {
      setState(() => _youglishOpen = false);
      return;
    }
    setState(() => _youglishOpen = true);
    final uri = Uri.parse('https://youglish.com/pronounce/${Uri.encodeComponent(item.contentDe)}/german');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  List<PracticeRoundItem> _practiceItems(LearningItem item) {
    final queue = _hasQueue ? widget.items : [item];
    final ordered = [item, ...queue.where((it) => it.id != item.id)];
    return ordered
        .take(8)
        .map(
          (it) => PracticeRoundItem(
            id: it.id,
            word: it.contentDe,
            translation: it.contentVi ?? '',
            example: it.examples?.firstOrNull?.de,
            exampleTranslation: it.examples?.firstOrNull?.vi,
            audioUrl: it.audioUrl,
          ),
        )
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final item = _currentItem;
    final total = _hasQueue ? widget.items.length : 1;
    final position = _hasQueue ? _index + 1 : 1;

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 12, 4),
              child: Row(
                children: [
                  IconButton(onPressed: () => Navigator.of(context).maybePop(), icon: const Icon(Icons.arrow_back_rounded)),
                  if (_hasQueue)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$position / $total', style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: LinearProgressIndicator(
                              value: position / total,
                              minHeight: 4,
                              backgroundColor: tokens.muted,
                              valueColor: AlwaysStoppedAnimation(tokens.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (widget.onOpenDetail != null)
                    IconButton(
                      onPressed: () => widget.onOpenDetail!(item),
                      icon: const Icon(Icons.open_in_new_rounded),
                    ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    WordHeroCard(
                      item: item,
                      mastered: _mastered,
                      masteredPending: _masteredPending,
                      onMarkMastered: _markMastered,
                      youglishOpen: _youglishOpen,
                      onToggleYouglish: () => _openYouglish(item),
                    ),
                    if ((item.examples ?? const []).isNotEmpty) ...[
                      const SizedBox(height: 16),
                      WordExamplesCard(examples: item.examples!),
                    ],
                    if (item.conjugation != null) ...[
                      const SizedBox(height: 16),
                      WordConjugationCard(
                        conjugation: item.conjugation!,
                        auxiliary: item.auxiliary,
                        isSeparable: item.isSeparable,
                        separablePrefix: item.separablePrefix,
                      ),
                    ],
                    const SizedBox(height: 16),
                    WordPracticeSheetGames(items: _practiceItems(item)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: StickyCtaBar(
        child: Row(
          children: [
            if (_hasQueue)
              Expanded(
                child: OutlinedButton(
                  onPressed: _index > 0 ? _prev : null,
                  child: const _NavButtonLabel(icon: Icons.arrow_back, label: 'Trước', iconFirst: true),
                ),
              ),
            if (_hasQueue) const SizedBox(width: 12),
            Expanded(
              flex: _hasQueue ? 2 : 1,
              child: FilledButton(
                onPressed: _next,
                style: FilledButton.styleFrom(backgroundColor: tokens.primary),
                child: const _NavButtonLabel(icon: Icons.arrow_forward, label: 'Tiếp theo', iconFirst: false),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Icon+label row that shrinks the label with an ellipsis instead of
/// overflowing — `OutlinedButton.icon`/`FilledButton.icon`'s built-in Row
/// has no `Flexible` around the label and overflows at 200% text scale
/// (German locale requirement).
class _NavButtonLabel extends StatelessWidget {
  const _NavButtonLabel({required this.icon, required this.label, required this.iconFirst});

  final IconData icon;
  final String label;
  final bool iconFirst;

  @override
  Widget build(BuildContext context) {
    final iconWidget = Icon(icon, size: 18);
    final textWidget = Flexible(child: Text(label, overflow: TextOverflow.ellipsis));
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: iconFirst
          ? [iconWidget, const SizedBox(width: 8), textWidget]
          : [textWidget, const SizedBox(width: 8), iconWidget],
    );
  }
}
