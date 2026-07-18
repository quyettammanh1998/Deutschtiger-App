import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import 'package:deutschtiger/data/interview/transcript_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/widgets/common/umlaut_input_bar.dart';
import 'package:deutschtiger/widgets/common/answer_diff_view.dart';
import 'dictation_settings_sheet.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Core "Nghe chép chính tả" loop — web parity `dictation-panel.tsx` (subset:
/// sentence + cloze modes; word-by-word mic mode and auto-replay/auto-pause
/// timing are deferred, see report). Sentence mode: type the whole line,
/// compare with [AnswerDiffView]. Cloze mode: type a single blanked word.
class DictationPanel extends StatefulWidget {
  const DictationPanel({
    super.key,
    required this.segments,
    required this.onSeek,
    required this.onClose,
    required this.onCorrectSentence,
  });

  final List<TranscriptSegment> segments;
  final ValueChanged<int> onSeek;
  final VoidCallback onClose;
  final VoidCallback onCorrectSentence;

  @override
  State<DictationPanel> createState() => _DictationPanelState();
}

class _DictationPanelState extends State<DictationPanel> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  int _index = 0;
  DictationMode _mode = DictationMode.sentence;
  bool _alwaysShowVietnamese = false;
  bool _showingAnswer = false;
  bool _inputFocused = false;
  int _correct = 0;
  int _skipped = 0;
  late int _clozeWordIndex = 0;

  TranscriptSegment get _current => widget.segments[_index];
  List<String> get _words => _current.textDe.split(RegExp(r'\s+'));

  @override
  void initState() {
    super.initState();
    _pickClozeWord();
    widget.onSeek(_current.startMs);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _pickClozeWord() {
    final words = _words;
    if (words.isEmpty) {
      _clozeWordIndex = 0;
      return;
    }
    // Ưu tiên từ dài (>= 4 ký tự) gần giữa câu — tương đương `pickClozeIndex` web.
    final candidates = [
      for (var i = 0; i < words.length; i++)
        if (_stripPunctuation(words[i]).length >= 4) i,
    ];
    _clozeWordIndex = candidates.isNotEmpty
        ? candidates[candidates.length ~/ 2]
        : words.length ~/ 2;
  }

  static String _stripPunctuation(String w) =>
      w.replaceAll(RegExp(r'^[^\p{L}]+|[^\p{L}]+$', unicode: true), '');

  static String _normalize(String w) =>
      _stripPunctuation(w).trim().toLowerCase();

  void _goTo(int index) {
    if (index < 0 || index >= widget.segments.length) return;
    setState(() {
      _index = index;
      _controller.clear();
      _showingAnswer = false;
      _pickClozeWord();
    });
    widget.onSeek(widget.segments[index].startMs);
  }

  void _replay() => widget.onSeek(_current.startMs);

  void _skip() {
    _skipped++;
    if (_index >= widget.segments.length - 1) {
      _showCompletion();
    } else {
      _goTo(_index + 1);
    }
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty || _showingAnswer) return;
    final isCorrect = _mode == DictationMode.sentence
        ? _normalizeSentence(text) == _normalizeSentence(_current.textDe)
        : _normalize(text) ==
              _normalize(_words[_clozeWordIndex.clamp(0, _words.length - 1)]);
    setState(() => _showingAnswer = true);
    if (isCorrect) {
      _correct++;
      widget.onCorrectSentence();
    }
  }

  static String _normalizeSentence(String s) => s
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'\s+'), ' ')
      .replaceAll(RegExp(r'[.,!?;:]'), '');

  void _next() {
    if (_index >= widget.segments.length - 1) {
      _showCompletion();
    } else {
      _goTo(_index + 1);
    }
  }

  void _showCompletion() {
    showDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        return AlertDialog(
          title: Text(l10n.youtubeDictationCompleteTitle),
          content: Text(
            l10n.youtubeDictationCompleteSummary(
              _correct,
              widget.segments.length,
              _skipped,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.close),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _index = 0;
                  _correct = 0;
                  _skipped = 0;
                  _controller.clear();
                  _showingAnswer = false;
                  _pickClozeWord();
                });
                widget.onSeek(_current.startMs);
              },
              child: Text(l10n.youtubeDictationRestartButton),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.youtubeDictationProgress(
                  _index + 1,
                  widget.segments.length,
                  _correct,
                ),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: tokens.mutedForeground,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                PhosphorIcons.gearSix,
                size: 18,
                color: tokens.mutedForeground,
              ),
              onPressed: () => showDictationSettingsSheet(
                context,
                mode: _mode,
                alwaysShowVietnamese: _alwaysShowVietnamese,
                onModeChanged: (m) => setState(() {
                  _mode = m;
                  _controller.clear();
                  _showingAnswer = false;
                  _pickClozeWord();
                }),
                onAlwaysShowVietnameseChanged: (v) =>
                    setState(() => _alwaysShowVietnamese = v),
              ),
            ),
          ],
        ),
        // FittedBox: at German 200% text scale, the "Bỏ qua" TextButton
        // label grows enough that 4 controls in a row can hard-overflow a
        // narrow phone width; scale the whole control row down as a unit
        // instead of reflowing it.
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _index > 0 ? () => _goTo(_index - 1) : null,
                icon: const Icon(PhosphorIcons.skipBack),
              ),
              IconButton(onPressed: _replay, icon: const Icon(PhosphorIcons.arrowCounterClockwise)),
              TextButton(
                onPressed: _skip,
                child: Text(l10n.dictationClozeSkip),
              ),
              IconButton(onPressed: _next, icon: const Icon(PhosphorIcons.skipForward)),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: tokens.muted.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_mode == DictationMode.cloze)
                _ClozeDisplay(
                  words: _words,
                  blankIndex: _clozeWordIndex,
                  tokens: tokens,
                ),
              if (!_showingAnswer &&
                  (_alwaysShowVietnamese) &&
                  _current.textVi != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    _current.textVi!,
                    style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: tokens.mutedForeground,
                    ),
                  ),
                ),
              if (!_showingAnswer) ...[
                const SizedBox(height: 10),
                UmlautInputBar(
                  visible: _inputFocused,
                  onInsert: (c) =>
                      UmlautInputBar.insertAtCursor(_controller, c),
                ),
                TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  maxLines: _mode == DictationMode.sentence ? 3 : 1,
                  onTap: () => setState(() => _inputFocused = true),
                  onEditingComplete: () =>
                      setState(() => _inputFocused = false),
                  onSubmitted: (_) => _submit(),
                  decoration: InputDecoration(
                    hintText: _mode == DictationMode.sentence
                        ? l10n.youtubeDictationSentenceHint
                        : l10n.youtubeDictationClozeHint,
                    filled: true,
                    fillColor: tokens.card,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: _submit,
                  child: Text(l10n.dictationCheckCta),
                ),
              ] else ...[
                Text(
                  l10n.youtubeDictationAnswerLabel,
                  style: TextStyle(fontSize: 12, color: tokens.success),
                ),
                const SizedBox(height: 4),
                Text(
                  _current.textDe,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: tokens.foreground,
                  ),
                ),
                if (_current.textVi != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    _current.textVi!,
                    style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: tokens.mutedForeground,
                    ),
                  ),
                ],
                if (_mode == DictationMode.sentence) ...[
                  const SizedBox(height: 8),
                  AnswerDiffView(
                    userAnswer: _controller.text,
                    correctAnswer: _current.textDe,
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () => setState(() {
                        _controller.clear();
                        _showingAnswer = false;
                      }),
                      child: Text(l10n.youtubeDictationRetryButton),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: _next,
                      child: Text(l10n.youtubeDictationNextButton),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ClozeDisplay extends StatelessWidget {
  const _ClozeDisplay({
    required this.words,
    required this.blankIndex,
    required this.tokens,
  });

  final List<String> words;
  final int blankIndex;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        for (var i = 0; i < words.length; i++)
          if (i == blankIndex)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(color: tokens.primary),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '•••',
                style: TextStyle(
                  color: tokens.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          else
            Text(
              words[i],
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: tokens.foreground,
              ),
            ),
      ],
    );
  }
}
