import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/vocabulary_models.dart';
import 'vocabulary_provider.dart';
import 'widgets/word_widgets.dart';

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
      vocabularyWordRouteProvider((
        itemId: itemId,
        topicKey: topicKey,
        level: level,
      )),
    );
    return routeData.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, _) => Scaffold(
        body: Center(
          child: Text(AppLocalizations.of(context).couldNotLoadVocabulary),
        ),
      ),
      data: (data) {
        return VocabularyWordScreen(
          item: data.item,
          items: data.queue,
          onOpenDetail: topicKey.isEmpty
              ? null
              : (target) {
                  final queryParameters = <String, String>{'itemId': target.id};
                  if (level != null) queryParameters['level'] = level!;
                  final location = Uri(
                    path: '/vocabulary/detail/$topicKey',
                    queryParameters: queryParameters,
                  );
                  context.push(location.toString());
                },
        );
      },
    );
  }
}

/// C3 — Vocabulary word screen.
///
/// Shows details for a single [LearningItem]: phonetic, meanings, examples,
/// SpeakButton (audio) and a "Tiếp tục" CTA that advances to the next item
/// in the supplied [items] queue (or pops when none remain).
class VocabularyWordScreen extends StatefulWidget {
  const VocabularyWordScreen({
    super.key,
    required this.item,
    this.items = const [],
    this.onCompleted,
    this.onOpenDetail,
  });

  final LearningItem item;

  /// Optional queue to advance through when the user taps "Tiếp tục".
  final List<LearningItem> items;

  /// Optional callback fired when the queue is exhausted.
  final VoidCallback? onCompleted;
  final ValueChanged<LearningItem>? onOpenDetail;

  @override
  State<VocabularyWordScreen> createState() => _VocabularyWordScreenState();
}

class _VocabularyWordScreenState extends State<VocabularyWordScreen> {
  late int _index;

  @override
  void initState() {
    super.initState();
    final start = widget.items.indexWhere((it) => it.id == widget.item.id);
    _index = start < 0 ? 0 : start;
  }

  bool get _hasQueue => widget.items.isNotEmpty;

  LearningItem get _currentItem =>
      _hasQueue ? widget.items[_index] : widget.item;

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
    setState(() => _index += 1);
  }

  void _prev() {
    if (_hasQueue && _index > 0) setState(() => _index -= 1);
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (velocity < -250 && (!_hasQueue || _index + 1 < widget.items.length)) {
      _next();
    } else if (velocity > 250 && _hasQueue && _index > 0) {
      _prev();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final item = _currentItem;
    final total = _hasQueue ? widget.items.length : 1;
    final position = _hasQueue ? _index + 1 : 1;

    return Scaffold(
      backgroundColor: DesignTokens.background,
      appBar: AppBar(
        backgroundColor: DesignTokens.background,
        elevation: 0,
        title: Text(
          '${item.contentDe} · ${item.level?.name.toUpperCase() ?? ''}',
        ),
        actions: [
          if (widget.onOpenDetail != null)
            IconButton(
              onPressed: () => widget.onOpenDetail!(item),
              tooltip: l10n.viewVocabularyDetails,
              icon: const Icon(Icons.open_in_new_rounded),
            ),
        ],
      ),
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalDragEnd: _onHorizontalDragEnd,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              DesignTokens.screenHorizontalPadding,
              DesignTokens.spacingSm,
              DesignTokens.screenHorizontalPadding,
              DesignTokens.spacingMd,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_hasQueue)
                  WordQueueProgress(position: position, total: total),
                const SizedBox(height: DesignTokens.spacingSm),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        WordHeaderCard(item: item),
                        const SizedBox(height: DesignTokens.spacingLg),
                        if ((item.meanings ?? const <String>[]).isNotEmpty)
                          WordMeanings(meanings: item.meanings!),
                        if ((item.examples ?? const <Example>[])
                            .isNotEmpty) ...[
                          const SizedBox(height: DesignTokens.spacingMd),
                          WordExamples(examples: item.examples!),
                        ],
                        const SizedBox(height: DesignTokens.spacingMd),
                      ],
                    ),
                  ),
                ),
                WordNavigationBar(
                  hasQueue: _hasQueue,
                  canPrev: _hasQueue && _index > 0,
                  onPrev: _prev,
                  onNext: _next,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
