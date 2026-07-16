import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/icons/app_phosphor_icons.dart';
import '../../../core/release/release_feature_flags.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/practice/practice_result.dart';
import '../../../data/practice/practice_round_item.dart';
import '../../../l10n/app_localizations.dart';
import '../../../view_models/providers.dart';
import '../../../widgets/common/answer_diff_view.dart';
import '../../../widgets/common/umlaut_input_bar.dart';
import 'practice_progress_header.dart';

/// "Luyện viết" (`/games/writing`, web `practice-writing-page.tsx` →
/// `PracticeWritingUnified`) — cho nghĩa tiếng Việt (+ "Nghe" phát âm), người
/// dùng gõ lại từ/câu tiếng Đức. Round type = [PracticeRoundItem].
///
/// Mic input: web gates recording behind a premium module; đây gate behind
/// [ReleaseFeatureFlags.speaking] (không có flag "voice" riêng — file khai
/// báo flag thuộc `lib/core/**`, ngoài phạm vi sở hữu phase này). UI mic đầy
/// đủ, chỉ hành động ghi âm là no-op khi flag tắt.
class PracticeWritingView extends ConsumerStatefulWidget {
  const PracticeWritingView({super.key, required this.items, required this.onComplete});

  final List<PracticeRoundItem> items;
  final void Function(List<PracticeResultEntry>) onComplete;

  @override
  ConsumerState<PracticeWritingView> createState() => _PracticeWritingViewState();
}

class _PracticeWritingViewState extends ConsumerState<PracticeWritingView> {
  int _index = 0;
  int _xp = 0;
  bool? _isCorrect;
  bool _reinforcing = false;
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _results = <PracticeResultEntry>[];

  PracticeRoundItem get _current => widget.items[_index];

  Future<void> _play() => ref.read(audioServiceProvider).play(audioUrl: _current.audioUrl, text: _current.word);

  void _insert(String char) => UmlautInputBar.insertAtCursor(_controller, char);

  void _submit() {
    if (_isCorrect == true) return;
    final answer = _controller.text.trim();
    final correct = answer.toLowerCase() == _current.word.trim().toLowerCase();
    setState(() => _isCorrect = correct);

    if (correct) {
      setState(() => _xp += _reinforcing ? 5 : 10);
      Future.delayed(const Duration(milliseconds: 700), _advance);
    } else if (!_reinforcing) {
      setState(() => _reinforcing = true);
    } else {
      Future.delayed(const Duration(milliseconds: 1200), _advance);
    }
  }

  void _advance() {
    if (!mounted) return;
    _results.add(
      PracticeResultEntry(
        cardId: _current.id,
        correct: _isCorrect ?? false,
        userAnswer: _controller.text.trim(),
        correctAnswer: _current.word,
      ),
    );
    if (_index < widget.items.length - 1) {
      setState(() {
        _index++;
        _isCorrect = null;
        _reinforcing = false;
        _controller.clear();
      });
    } else {
      widget.onComplete(_results);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;

    return Column(
      children: [
        PracticeProgressHeader(current: _index + 1, total: widget.items.length, xp: _xp),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                _current.translation,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Center(
                child: InkWell(
                  key: const Key('practice_writing_listen'),
                  borderRadius: BorderRadius.circular(999),
                  onTap: _play,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFA855F7).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(AppPhosphorIcons.speakerHigh, size: 14, color: const Color(0xFFA855F7)),
                        const SizedBox(width: 4),
                        Text(
                          l10n.practiceListenPill,
                          style: const TextStyle(color: Color(0xFFA855F7), fontWeight: FontWeight.w700, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (_reinforcing && _isCorrect == false)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AnswerDiffView(userAnswer: _controller.text, correctAnswer: _current.word),
                ),
              TextField(
                key: const Key('practice_writing_input'),
                controller: _controller,
                focusNode: _focusNode,
                enabled: _isCorrect != true,
                autocorrect: false,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: l10n.practiceWritingHint,
                  filled: true,
                  fillColor: _isCorrect == null
                      ? tokens.card
                      : (_isCorrect! ? tokens.success.withValues(alpha: 0.1) : tokens.destructive.withValues(alpha: 0.08)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 12),
              UmlautInputBar(visible: _isCorrect != true, onInsert: _insert),
              if (ReleaseFeatureFlags.speaking) ...[
                const SizedBox(height: 8),
                Center(
                  child: IconButton(
                    key: const Key('practice_writing_mic'),
                    icon: Icon(AppPhosphorIcons.microphone, color: tokens.primary),
                    tooltip: l10n.practiceMicTooltip,
                    onPressed: () {
                      // Recording pipeline wiring is MASTER P8's responsibility
                      // (voice/STT). UI only — no local audio capture wired here.
                    },
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Center(
                child: FilledButton(
                  onPressed: _isCorrect == true ? null : _submit,
                  child: Text(_isCorrect == false ? l10n.practiceRetryAnswer : l10n.practiceCheckAnswer),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
