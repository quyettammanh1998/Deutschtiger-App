import 'package:flutter/material.dart';

import '../../../../../core/release/release_feature_flags.dart';
import '../../../../../core/theme/app_tokens.dart';
import '../../../../../data/practice/practice_result.dart';
import '../../../../../data/practice/practice_round_item.dart';
import '../../../../../screens/practice/widgets/practice_listening_view.dart';
import '../../../../../screens/practice/widgets/practice_writing_view.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

enum WordSheetGame { writing, listening, speaking, flashcard }

const _sheetGames = [
  (type: WordSheetGame.writing, label: 'Viết từ', icon: PhosphorIcons.note, color: Color(0xFF3B82F6)),
  (type: WordSheetGame.listening, label: 'Nghe & chọn', icon: PhosphorIcons.headphones, color: Color(0xFFF59E0B)),
  (type: WordSheetGame.speaking, label: 'Phát âm', icon: PhosphorIcons.microphone, color: Color(0xFF10B981)),
  (type: WordSheetGame.flashcard, label: 'Lật thẻ', icon: PhosphorIcons.cards, color: Color(0xFF8B5CF6)),
];

/// "Luyện tập thêm" 4-icon grid — each tile opens a bottom sheet running a
/// mini-game seeded from the current word (+ any queue neighbors passed in
/// [items], topic-related material). Web parity: `SHEET_GAMES` grid in
/// `vocabulary-word-page.tsx`.
///
/// Deviation: web has 4 DISTINCT mini-game components (writing/listening/
/// speaking/flashcard); Flutter only has the 2 reused practice-round views
/// ([PracticeWritingView], [PracticeListeningView]) — "Nghe & chọn" and
/// "Lật thẻ" both open [PracticeListeningView] (flip-card), and "Phát âm"
/// is gated behind [ReleaseFeatureFlags.speaking] (no mic UI ported this
/// pass — full pronunciation-assessment panel doesn't exist in Flutter yet).
class WordPracticeSheetGames extends StatelessWidget {
  const WordPracticeSheetGames({super.key, required this.items});

  final List<PracticeRoundItem> items;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('LUYỆN TẬP THÊM', style: TextStyle(fontSize: 11, letterSpacing: 1, color: tokens.mutedForeground.withValues(alpha: 0.7))),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.85,
          children: [for (final game in _sheetGames) _GameTile(game: game, onTap: () => _open(context, game.type))],
        ),
      ],
    );
  }

  void _open(BuildContext context, WordSheetGame type) {
    if (type == WordSheetGame.speaking && !ReleaseFeatureFlags.speaking) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Luyện phát âm sẽ sớm ra mắt.')),
      );
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, _) => _GameSheetBody(type: type, items: items),
      ),
    );
  }
}

class _GameTile extends StatelessWidget {
  const _GameTile({required this.game, required this.onTap});
  final ({WordSheetGame type, String label, IconData icon, Color color}) game;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Material(
      color: tokens.card,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: tokens.border)),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(game.icon, color: game.color, size: 20),
              const SizedBox(height: 6),
              Flexible(
                child: Text(game.label, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: tokens.foreground)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GameSheetBody extends StatelessWidget {
  const _GameSheetBody({required this.type, required this.items});
  final WordSheetGame type;
  final List<PracticeRoundItem> items;

  @override
  Widget build(BuildContext context) {
    void onComplete(List<PracticeResultEntry> _) => Navigator.of(context).maybePop();
    return switch (type) {
      WordSheetGame.writing => PracticeWritingView(items: items, onComplete: onComplete),
      WordSheetGame.listening ||
      WordSheetGame.flashcard => PracticeListeningView(items: items, onComplete: onComplete),
      WordSheetGame.speaking => const SizedBox.shrink(),
    };
  }
}
