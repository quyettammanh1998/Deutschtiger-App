import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../core/theme/app_tokens.dart';
import '../../data/decks/deck_models.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/decks/deck_repository.dart';
import '../../shared/widgets/back_button.dart';
import '../../shared/widgets/confirm_dialog.dart';
import '../../view_models/decks/deck_provider.dart';
import '../../widgets/common/async_state_views.dart';
import 'widgets/deck_card_row.dart';
import 'widgets/deck_learn_bottom_bar.dart';
import 'widgets/deck_mastery_bar.dart';

/// Cards of a deck — kept public: reused by [PracticeScreen] (P4, deck-scoped
/// practice runner) and this screen. DO NOT rename/remove this provider.
final deckWordsProvider = FutureProvider.family((ref, String deckId) {
  return ref.watch(deckRepositoryProvider).getDeckWords(deckId);
});

/// `/notes/:deckId` deck detail. Web parity: `flashcard-deck-detail.tsx`
/// (924 lines desktop+mobile; this rebuild covers the mobile-viewport
/// structure: header w/ editable name + mastery bar, search + star filter,
/// action bar, card list, sticky "Học/Chơi" bottom bar).
class DeckDetailScreen extends ConsumerStatefulWidget {
  const DeckDetailScreen({super.key, required this.deckId});
  final String deckId;

  @override
  ConsumerState<DeckDetailScreen> createState() => _DeckDetailScreenState();
}

class _DeckDetailScreenState extends ConsumerState<DeckDetailScreen> {
  final _searchController = TextEditingController();
  String _search = '';
  bool _starredOnly = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final wordsAsync = ref.watch(deckWordsProvider(widget.deckId));
    final summaryAsync = ref.watch(deckSummaryProvider);

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: wordsAsync.when(
          loading: () => const LoadingView(),
          error: (_, _) => ErrorView(
            message: l10n.couldNotLoadDecks,
            onRetry: () => ref.invalidate(deckWordsProvider(widget.deckId)),
          ),
          data: (allCards) {
            final summary = summaryAsync.valueOrNull?[widget.deckId];
            final deckName = ref
                .watch(decksProvider)
                .valueOrNull
                ?.where((d) => d.id == widget.deckId)
                .map((d) => d.name)
                .firstOrNull;
            var cards = allCards;
            if (_starredOnly) {
              cards = cards.where((c) => c.isStarred).toList();
            }
            if (_search.trim().isNotEmpty) {
              final q = _search.trim().toLowerCase();
              cards = cards
                  .where(
                    (c) =>
                        c.word.toLowerCase().contains(q) ||
                        c.translation.toLowerCase().contains(q),
                  )
                  .toList();
            }

            return Stack(
              children: [
                Column(
                  children: [
                    _Header(
                      deckName: deckName,
                      totalCards: allCards.length,
                      summary: summary,
                      searchController: _searchController,
                      starredOnly: _starredOnly,
                      hasStarred: allCards.any((c) => c.isStarred),
                      onSearchChanged: (v) => setState(() => _search = v),
                      onToggleStarredOnly: () => setState(() => _starredOnly = !_starredOnly),
                      onAddCard: () => context.push('/notes/${widget.deckId}/new'),
                      onDeleteDeck: () => _confirmDeleteDeck(context, ref),
                    ),
                    Expanded(
                      child: allCards.isEmpty
                          ? Center(child: Text(l10n.emptyDeckCards))
                          : cards.isEmpty
                          ? Center(child: Text(l10n.deckNoSearchResults))
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
                              itemCount: cards.length,
                              itemBuilder: (context, index) {
                                final card = cards[index];
                                return DeckCardRow(
                                  card: card,
                                  onTap: () => context.push(
                                    '/notes/${widget.deckId}/edit/${card.id}',
                                  ),
                                  onToggleStar: () => _toggleStar(ref, card),
                                );
                              },
                            ),
                    ),
                  ],
                ),
                if (allCards.isNotEmpty)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: DeckLearnBottomBar(
                      onLearn: () => context.push('/notes/${widget.deckId}/lesson'),
                      onPractice: () => context.push('/notes/${widget.deckId}/practice'),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _toggleStar(WidgetRef ref, DeckWord card) async {
    final repo = ref.read(deckRepositoryProvider);
    await repo.toggleStar(card.id);
    ref.invalidate(deckWordsProvider(widget.deckId));
    ref.invalidate(starredCardsProvider);
  }

  Future<void> _confirmDeleteDeck(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final deckName = ref
        .read(decksProvider)
        .valueOrNull
        ?.where((d) => d.id == widget.deckId)
        .map((d) => d.name)
        .firstOrNull;
    final ok = await showConfirmDialog(
      context,
      title: l10n.deleteDeck,
      message: l10n.deleteDeckConfirmation(deckName ?? ''),
      destructive: true,
    );
    if (!ok) return;
    final repo = ref.read(deckRepositoryProvider);
    await repo.deleteDeck(widget.deckId);
    ref.invalidate(decksProvider);
    if (context.mounted) context.pop();
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.deckName,
    required this.totalCards,
    required this.summary,
    required this.searchController,
    required this.starredOnly,
    required this.hasStarred,
    required this.onSearchChanged,
    required this.onToggleStarredOnly,
    required this.onAddCard,
    required this.onDeleteDeck,
  });

  final String? deckName;
  final int totalCards;
  final DeckSummaryRow? summary;
  final TextEditingController searchController;
  final bool starredOnly;
  final bool hasStarred;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onToggleStarredOnly;
  final VoidCallback onAddCard;
  final VoidCallback onDeleteDeck;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.card,
        border: Border(bottom: BorderSide(color: tokens.border)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const AppBackButton(),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    deckName ?? l10n.flashcardDecks,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: tokens.foreground),
                  ),
                ),
                const SizedBox(width: 6),
                Text(l10n.wordsCount(totalCards), style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
                IconButton(
                  onPressed: onDeleteDeck,
                  tooltip: l10n.delete,
                  icon: Icon(PhosphorIconsBold.trash, color: tokens.destructive, size: 18),
                ),
              ],
            ),
            if (summary != null && summary!.total > 0) ...[
              const SizedBox(height: 6),
              DeckMasteryBar(summary: summary!),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: onSearchChanged,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: l10n.deckSearchHint,
                      prefixIcon: Icon(PhosphorIconsBold.magnifyingGlass, size: 16),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                if (hasStarred) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: onToggleStarredOnly,
                    tooltip: l10n.deckStarredFilterTooltip,
                    icon: Icon(
                      starredOnly ? PhosphorIconsFill.star : PhosphorIconsRegular.star,
                      color: starredOnly ? const Color(0xFFF59E0B) : tokens.mutedForeground,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: onAddCard,
                icon: Icon(PhosphorIconsBold.plus, size: 14, color: const Color(0xFF14B8A6)),
                label: Text(l10n.deckAddCard, style: const TextStyle(color: Color(0xFF14B8A6), fontWeight: FontWeight.w600)),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF14B8A6).withValues(alpha: 0.12),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
