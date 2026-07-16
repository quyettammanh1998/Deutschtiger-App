import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/decks/deck_repository.dart';
import '../../shared/widgets/back_button.dart';
import '../../view_models/decks/deck_provider.dart';
import '../../widgets/common/async_state_views.dart';
import 'widgets/deck_card_row.dart';

/// `/notes/starred`. Web parity: `flashcard-starred-view.tsx` — flat list of
/// starred cards across all decks.
class StarredViewScreen extends ConsumerWidget {
  const StarredViewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final starredAsync = ref.watch(starredCardsProvider);

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: starredAsync.when(
          loading: () => const LoadingView(),
          error: (_, _) => ErrorView(
            message: l10n.couldNotLoadDecks,
            onRetry: () => ref.invalidate(starredCardsProvider),
          ),
          data: (cards) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Row(
                  children: [
                    const AppBackButton(),
                    const SizedBox(width: 12),
                    Text(
                      l10n.deckStarredTitle,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: tokens.foreground),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: cards.isEmpty
                    ? Center(child: Text(l10n.deckStarredEmpty, style: TextStyle(color: tokens.mutedForeground)))
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        itemCount: cards.length,
                        itemBuilder: (context, index) {
                          final card = cards[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (card.deckName != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4, left: 4),
                                  child: Text(
                                    card.deckName!,
                                    style: TextStyle(fontSize: 10, color: tokens.mutedForeground),
                                  ),
                                ),
                              DeckCardRow(
                                card: card,
                                onTap: () => context.push('/notes/${card.deckId}/edit/${card.id}'),
                                onToggleStar: () async {
                                  await ref.read(deckRepositoryProvider).toggleStar(card.id);
                                  ref.invalidate(starredCardsProvider);
                                },
                              ),
                            ],
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
