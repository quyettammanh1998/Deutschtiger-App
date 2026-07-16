import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/practice/practice_round_item.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../screens/practice/widgets/practice_cloze_view.dart';
import '../../../../screens/practice/widgets/practice_listening_view.dart';
import '../../../../screens/practice/widgets/practice_matching_view.dart';
import '../../../../screens/practice/widgets/practice_route_scaffold.dart';
import '../../../../screens/practice/widgets/practice_writing_view.dart';
import '../../domain/vocabulary_models.dart';
import '../vocabulary_provider.dart';

/// Practice modes surfaced from the vocabulary-detail sticky bar — the 4
/// shared round-type views (web parity: `vocabulary-detail-page.tsx`'s
/// `handleStartPractice` for `cloze`/`listening`/`matching`/`writing`; the
/// other web modes — flashcards/speaking/word-sprint/runner — are deck- or
/// standalone-scoped elsewhere and out of this screen's scope).
enum VocabularyPracticeMode { cloze, listening, matching, writing }

extension VocabularyPracticeModeLabel on VocabularyPracticeMode {
  String label(AppLocalizations l10n) => switch (this) {
    VocabularyPracticeMode.cloze => l10n.practiceModeCloze,
    VocabularyPracticeMode.listening => l10n.practiceModeListening,
    VocabularyPracticeMode.matching => l10n.practiceModeMatching,
    VocabularyPracticeMode.writing => l10n.practiceModeWriting,
  };
}

/// One resolved fetch target for a vocabulary-detail scope — exactly one of
/// [topic]/[level]/[collectionId] is set. Shared by the item list, mastery
/// bar, and this practice launcher so they all read the same scope.
class VocabularyScope {
  const VocabularyScope({this.topic, this.level, this.collectionId});

  final String? topic;
  final String? level;
  final String? collectionId;
}

/// Fetches up to [limit] items for [scope] and pushes the matching practice
/// view inside the shared [PracticeRouteScaffold] chrome (GameShell header +
/// results + restart) — reuses P4's round-type API, no new game logic.
void pushVocabularyPractice(
  BuildContext context,
  WidgetRef ref, {
  required VocabularyPracticeMode mode,
  required VocabularyScope scope,
  int limit = 30,
}) {
  final l10n = AppLocalizations.of(context);
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => PracticeRouteScaffold(
        title: mode.label(l10n),
        loadItems: () => _loadRoundItems(ref, scope, limit),
        buildView: (items, onComplete) => switch (mode) {
          VocabularyPracticeMode.cloze =>
            PracticeClozeView(items: items, onComplete: onComplete),
          VocabularyPracticeMode.listening =>
            PracticeListeningView(items: items, onComplete: onComplete),
          VocabularyPracticeMode.matching =>
            PracticeMatchingView(items: items, onComplete: onComplete),
          VocabularyPracticeMode.writing =>
            PracticeWritingView(items: items, onComplete: onComplete),
        },
      ),
    ),
  );
}

Future<List<PracticeRoundItem>> _loadRoundItems(
  WidgetRef ref,
  VocabularyScope scope,
  int limit,
) async {
  final repo = ref.read(vocabularyRepositoryProvider);
  final result = scope.topic != null
      ? await repo.fetchItemsByTopicLevel(
          topic: scope.topic!,
          level: scope.level,
          pageSize: limit,
          shuffle: true,
        )
      : scope.level != null
      ? await repo.fetchItemsByLevel(
          level: scope.level!,
          pageSize: limit,
          shuffle: true,
        )
      : await repo.fetchCollectionItems(
          collectionId: scope.collectionId ?? '',
          pageSize: limit,
          shuffle: true,
        );
  return result.items.map(_toRoundItem).toList(growable: false);
}

PracticeRoundItem _toRoundItem(LearningItem item) {
  final example = (item.examples ?? const []).isNotEmpty
      ? item.examples!.first
      : null;
  return PracticeRoundItem(
    id: item.id,
    word: item.contentDe,
    translation: item.contentVi ?? item.meanings?.firstOrNull ?? '',
    example: example?.de,
    exampleTranslation: example?.vi,
  );
}
