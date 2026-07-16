import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_tokens.dart';
import '../../data/decks/deck_models.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/decks/deck_repository.dart';
import '../../shared/widgets/back_button.dart';
import '../../view_models/decks/deck_provider.dart';
import '../../widgets/common/async_state_views.dart';
import 'widgets/deck_folder_section.dart';
import 'widgets/deck_row_tile.dart';

/// `/notes/folder/:id`. Web parity: `flashcard-folder-detail.tsx` — decks
/// inside this folder + any subfolders.
class FolderDetailScreen extends ConsumerWidget {
  const FolderDetailScreen({super.key, required this.folderId});
  final String folderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final decksAsync = ref.watch(decksProvider);
    final foldersAsync = ref.watch(deckFoldersProvider);
    final defaultDeckIdAsync = ref.watch(defaultDeckIdProvider);
    final summaryAsync = ref.watch(deckSummaryProvider);

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: decksAsync.when(
          loading: () => const LoadingView(),
          error: (_, _) => ErrorView(
            message: l10n.couldNotLoadDecks,
            onRetry: () => ref.invalidate(decksProvider),
          ),
          data: (decks) {
            final folders = foldersAsync.valueOrNull ?? const <DeckFolder>[];
            final folder = folders.where((f) => f.id == folderId).firstOrNull;
            final subfolders = folders.where((f) => f.parentId == folderId).toList();
            final folderDecks = decks.where((d) => d.folderId == folderId).toList();
            final defaultDeckId = defaultDeckIdAsync.valueOrNull;
            final summary = summaryAsync.valueOrNull ?? const {};

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                Row(
                  children: [
                    const AppBackButton(),
                    const SizedBox(width: 12),
                    Text(
                      folder?.name ?? l10n.deckFoldersTitle,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: tokens.foreground),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DeckFolderSection(
                  folders: subfolders,
                  onTapFolder: (f) => context.push('/notes/folder/${f.id}'),
                ),
                if (folderDecks.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(l10n.deckFolderEmpty, style: TextStyle(color: tokens.mutedForeground)),
                    ),
                  )
                else
                  for (final deck in folderDecks)
                    DeckRowTile(
                      deck: deck,
                      isDefault: deck.id == defaultDeckId,
                      summary: summary[deck.id],
                      onTap: () => context.push('/notes/${deck.id}'),
                      onSetDefault: () async {
                        await ref.read(deckRepositoryProvider).setDefaultDeck(deck.id);
                        ref.invalidate(defaultDeckIdProvider);
                      },
                      onEdit: () {},
                      onMoveToFolder: () async {
                        await ref.read(deckRepositoryProvider).moveDeckToFolder(deck.id, null);
                        ref.invalidate(decksProvider);
                      },
                    ),
              ],
            );
          },
        ),
      ),
    );
  }
}
