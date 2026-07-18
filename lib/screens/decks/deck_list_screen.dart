import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../core/theme/app_tokens.dart';
import '../../data/decks/deck_models.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/decks/deck_repository.dart';
import '../../shared/widgets/back_button.dart';
import '../../shared/widgets/page_intro.dart';
import '../../view_models/decks/deck_provider.dart';
import '../../widgets/common/app_card.dart';
import '../../widgets/common/async_state_views.dart';
import 'widgets/deck_action_sheet.dart';
import 'widgets/deck_folder_section.dart';
import 'widgets/deck_form_dialogs.dart';
import 'widgets/deck_row_tile.dart';

/// `/notes` deck list. Web parity: `flashcard-page.tsx` →
/// `flashcard-deck-list.tsx` (mobile). Structure: header → PageIntro →
/// starred row → folders → deck list (default star + mastery bar + 3-dot
/// menu) → "Luyện tập nhanh" quick-practice CTA → create-action bottom sheet.
class DeckListScreen extends ConsumerWidget {
  const DeckListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final decksAsync = ref.watch(decksProvider);
    final foldersAsync = ref.watch(deckFoldersProvider);
    final starredAsync = ref.watch(starredCardsProvider);
    final defaultDeckIdAsync = ref.watch(defaultDeckIdProvider);
    final summaryAsync = ref.watch(deckSummaryProvider);

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: decksAsync.when(
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(
            message: l10n.couldNotLoadDecks,
            onRetry: () => ref.invalidate(decksProvider),
          ),
          data: (decks) {
            final folders = foldersAsync.valueOrNull ?? const <DeckFolder>[];
            final starred = starredAsync.valueOrNull ?? const <DeckWord>[];
            final defaultDeckId = defaultDeckIdAsync.valueOrNull;
            final summary = summaryAsync.valueOrNull ?? const {};
            final unfoldered = decks.where((d) => d.folderId == null).toList();

            return RefreshIndicator(
              color: tokens.primary,
              onRefresh: () async {
                ref.invalidate(decksProvider);
                ref.invalidate(deckFoldersProvider);
                ref.invalidate(starredCardsProvider);
                ref.invalidate(defaultDeckIdProvider);
                ref.invalidate(deckSummaryProvider);
              },
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppBackButton(),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.myDecks,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: tokens.foreground,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              folders.isEmpty
                                  ? l10n.wordsCount(decks.length)
                                  : l10n.deckListSubtitleWithFolders(
                                      decks.length,
                                      folders.length,
                                    ),
                              style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                            ),
                          ],
                        ),
                      ),
                      _CreateButton(
                        onTap: () => _openCreateSheet(context, ref),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  PageIntro(
                    pageKey: 'notes',
                    why: l10n.deckIntroWhy,
                    todo: l10n.deckIntroTodo,
                    next: l10n.deckIntroNext,
                    onNextTap: () => context.push('/daily-review'),
                    nextLabel: l10n.deckIntroNextLabel,
                  ),
                  const SizedBox(height: 16),
                  DeckStarredRow(
                    count: starred.length,
                    onTap: () => context.push('/notes/starred'),
                  ),
                  DeckFolderSection(
                    folders: folders.where((f) => f.parentId == null).toList(),
                    onTapFolder: (folder) => context.push('/notes/folder/${folder.id}'),
                  ),
                  if (decks.isEmpty)
                    AppCard.card(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Text(
                            l10n.noDecksDescription,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: tokens.mutedForeground),
                          ),
                        ),
                      ),
                    )
                  else ...[
                    if (folders.isNotEmpty && unfoldered.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6, left: 2),
                        child: Text(
                          l10n.deckAllDecksTitle,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: tokens.mutedForeground,
                          ),
                        ),
                      ),
                    for (final deck in unfoldered)
                      DeckRowTile(
                        deck: deck,
                        isDefault: deck.id == defaultDeckId,
                        summary: summary[deck.id],
                        onTap: () => context.push('/notes/${deck.id}'),
                        onSetDefault: () => _setDefault(ref, deck.id),
                        onEdit: () => _editDeck(context, ref, deck),
                        onMoveToFolder: () => _moveToFolder(context, ref, deck, folders),
                      ),
                  ],
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6, left: 2),
                    child: Text(
                      l10n.deckQuickPracticeTitle,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: tokens.mutedForeground,
                      ),
                    ),
                  ),
                  AppCard.interactive(
                    onTap: () => context.push('/games/word-sprint'),
                    child: Row(
                      children: [
                        Icon(PhosphorIconsBold.lightning, color: tokens.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.deckQuickPracticeCta,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: tokens.foreground),
                          ),
                        ),
                        Icon(PhosphorIconsBold.caretRight, size: 16, color: tokens.mutedForeground),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _openCreateSheet(BuildContext context, WidgetRef ref) {
    showDeckCreateActionSheet(
      context,
      onCreateDeck: () => _createDeck(context, ref),
      onCreateFolder: () => _createFolder(context, ref),
      onSpeakToNotes: () => context.push('/notes/speak'),
    );
  }

  void _createDeck(BuildContext context, WidgetRef ref) {
    showDeckFormDialog(
      context,
      onSave: (name, description) async {
        final repo = ref.read(deckRepositoryProvider);
        await repo.createDeck(name: name, description: description);
        ref.invalidate(decksProvider);
      },
    );
  }

  void _editDeck(BuildContext context, WidgetRef ref, Deck deck) {
    showDeckFormDialog(
      context,
      editing: deck,
      onSave: (name, description) async {
        final repo = ref.read(deckRepositoryProvider);
        await repo.updateDeck(deck.id, name: name, description: description);
        ref.invalidate(decksProvider);
      },
    );
  }

  void _createFolder(BuildContext context, WidgetRef ref) {
    showDeckFolderFormDialog(
      context,
      onSave: (name) async {
        final repo = ref.read(deckRepositoryProvider);
        await repo.createFolder(name: name);
        ref.invalidate(deckFoldersProvider);
      },
    );
  }

  void _moveToFolder(
    BuildContext context,
    WidgetRef ref,
    Deck deck,
    List<DeckFolder> folders,
  ) {
    showMoveToFolderSheet(
      context,
      folders: folders,
      currentFolderId: deck.folderId,
      onMove: (folderId) async {
        final repo = ref.read(deckRepositoryProvider);
        await repo.moveDeckToFolder(deck.id, folderId);
        ref.invalidate(decksProvider);
      },
    );
  }

  Future<void> _setDefault(WidgetRef ref, String deckId) async {
    final repo = ref.read(deckRepositoryProvider);
    await repo.setDefaultDeck(deckId);
    ref.invalidate(defaultDeckIdProvider);
  }
}

class _CreateButton extends StatelessWidget {
  const _CreateButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final darkened = Color.lerp(tokens.primary, Colors.black, 0.2)!;
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [tokens.primary, darkened]),
          shape: BoxShape.circle,
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: const SizedBox(
            width: 36,
            height: 36,
            child: Icon(PhosphorIcons.plus, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }
}
