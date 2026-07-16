import 'goethe_b1_writing_topic_summary.dart';

/// Free-tier gating — web parity `lib/goethe-b1-writing/access.ts`. This app
/// has no "purchased module" concept (web's `hasModule('exam')`) yet, so
/// [hasFullAccess] here is simply the premium flag — documented deviation,
/// see phase report.
const int kFreeWritingTopicLimitPerTeil = 5;

/// Regular (non-intro) topics sorted by frequency stars desc, then slug —
/// matches web's `getSortedRegularTopics`.
List<GoetheB1WritingTopicSummary> sortedRegularWritingTopics(
  List<GoetheB1WritingTopicSummary> topics,
) {
  final regular = topics.where((t) => !t.isIntro).toList()
    ..sort((a, b) {
      final starDiff = b.frequencyStars - a.frequencyStars;
      if (starDiff != 0) return starDiff;
      return a.slug.compareTo(b.slug);
    });
  return regular;
}

/// The first N (by frequency) regular topic slugs that stay unlocked for a
/// free (non-premium) account.
Set<String> freeUnlockedWritingTopicSlugs(
  List<GoetheB1WritingTopicSummary> topics, {
  int limit = kFreeWritingTopicLimitPerTeil,
}) {
  return sortedRegularWritingTopics(topics)
      .take(limit)
      .map((t) => t.slug)
      .toSet();
}

bool isWritingTopicLocked(
  GoetheB1WritingTopicSummary topic,
  List<GoetheB1WritingTopicSummary> allTopics, {
  required bool hasFullAccess,
}) {
  if (hasFullAccess || topic.isIntro) return false;
  return !freeUnlockedWritingTopicSlugs(allTopics).contains(topic.slug);
}
