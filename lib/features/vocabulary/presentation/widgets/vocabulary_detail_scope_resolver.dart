import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../vocabulary_provider.dart';

/// Resolves a `/vocabulary/:slug` route param into a concrete fetch scope —
/// web parity: `buildTopicSlugIndex` + the `isLevelSlug`/`isTopicPrefixedSlug`
/// branching in `vocabulary-detail-page.tsx`. Slug forms: `topic-{key}`,
/// `level-{level}`, or a bare collection slug (medical/sprechen/goethe) —
/// resolved CLIENT-SIDE from the already-fetched topics/collections lists
/// (no new backend endpoint, matches the verified route contract).
class ResolvedVocabularyScope {
  const ResolvedVocabularyScope({
    required this.title,
    this.subtitle,
    this.topicKey,
    this.level,
    this.collectionId,
    this.lessonTopicKey,
  });

  final String title;
  final String? subtitle;
  final String? topicKey;
  final String? level;
  final String? collectionId;

  /// Non-null only when a lesson session is backed by an existing route
  /// (topic scope) — level/collection-only scopes have no lesson-batch
  /// wiring yet on the Flutter side.
  final String? lessonTopicKey;
}

final vocabularyDetailScopeProvider =
    FutureProvider.family<ResolvedVocabularyScope?, ({String slug, String? overlayLevel})>((
      ref,
      args,
    ) async {
      final slug = args.slug;
      if (slug.startsWith('level-')) {
        final level = slug.substring('level-'.length).toUpperCase();
        return ResolvedVocabularyScope(
          title: 'Cấp độ $level',
          level: level,
        );
      }

      final rawKey = slug.startsWith('topic-')
          ? slug.substring('topic-'.length)
          : slug;
      final topics = await ref.watch(vocabularyTopicsProvider.future);
      for (final topic in topics) {
        if (topic.key == rawKey) {
          return ResolvedVocabularyScope(
            title: topic.labelVi,
            subtitle: topic.label,
            topicKey: topic.key,
            level: args.overlayLevel,
            lessonTopicKey: topic.key,
          );
        }
      }

      final collections = await ref.watch(wordCollectionsProvider.future);
      for (final collection in collections) {
        if (collection.slug == slug) {
          return ResolvedVocabularyScope(
            title: collection.name,
            subtitle: collection.description,
            collectionId: collection.id,
          );
        }
      }

      return null;
    });
