import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../repositories/games/grammar_drill_repository.dart';
import '../../../../view_models/games/cases_provider.dart';

enum _AiState { idle, loading, done, error }

/// Per-question explanation for a wrong grammar-drill answer — web parity:
/// `GrammarExplainPanel`. Always shows [staticReason] (already authored VN
/// text bundled with the question) and an on-demand "🤖 Giải thích sâu"
/// button that calls the live `POST /ai/explain-grammar` endpoint. A
/// `ok:false` AI response is a normal degrade path (server never 5xx's on
/// LLM failure) — it falls back to [staticReason] silently, never an error
/// toast.
class GrammarExplainPanel extends ConsumerStatefulWidget {
  const GrammarExplainPanel({
    super.key,
    required this.request,
    required this.staticReason,
  });

  final GrammarExplainRequest request;
  final String staticReason;

  @override
  ConsumerState<GrammarExplainPanel> createState() =>
      _GrammarExplainPanelState();
}

class _GrammarExplainPanelState extends ConsumerState<GrammarExplainPanel> {
  _AiState _state = _AiState.idle;
  String _text = '';

  Future<void> _explain() async {
    if (_state == _AiState.loading || _state == _AiState.done) return;
    setState(() => _state = _AiState.loading);
    try {
      final res = await ref
          .read(grammarDrillRepositoryProvider)
          .explainGrammar(widget.request);
      if (!mounted) return;
      if (res.ok && res.explanation.trim().isNotEmpty) {
        setState(() {
          _text = res.explanation.trim();
          _state = _AiState.done;
        });
      } else {
        setState(() => _state = _AiState.error);
      }
    } catch (_) {
      if (mounted) setState(() => _state = _AiState.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tokens.muted.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.staticReason.isNotEmpty)
            Text(
              widget.staticReason,
              style: TextStyle(fontSize: 13, color: tokens.foreground),
            ),
          if (_state == _AiState.done) ...[
            const SizedBox(height: 8),
            Divider(height: 1, color: tokens.border),
            const SizedBox(height: 8),
            Text(
              _text,
              style: TextStyle(fontSize: 13, color: tokens.foreground),
            ),
          ],
          if (_state == _AiState.error) ...[
            const SizedBox(height: 8),
            Text(
              widget.staticReason.isNotEmpty
                  ? 'Không tải được giải thích AI — bạn xem giải thích ở trên nhé.'
                  : 'Không tải được giải thích, vui lòng thử lại sau.',
              style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
            ),
          ],
          if (_state != _AiState.done) ...[
            const SizedBox(height: 8),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: _state == _AiState.loading ? null : _explain,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFF4F46E5)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_state == _AiState.loading)
                        const SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      else
                        const Text('🤖', style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 6),
                      Text(
                        _state == _AiState.loading
                            ? 'Đang giải thích…'
                            : 'Giải thích sâu',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
