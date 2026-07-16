/// Level/XP math mirroring web `gamificationService` — SQL formula
/// `level = GREATEST(1, FLOOR(SQRT(total_xp / 100)))`, so level N starts at
/// N² * 100 and level N+1 starts at (N+1)² * 100. Backend computes `level`
/// itself; this file only derives the progress-bar figures from it.
library;

/// XP required to go from [level] to [level] + 1.
int statsXpForLevel(int level) {
  final safe = level < 1 ? 1 : level;
  return ((safe + 1) * (safe + 1) - safe * safe) * 100;
}

/// XP accumulated before entering [level] (= level² * 100).
int statsXpBeforeLevel(int level) {
  final safe = level < 1 ? 1 : level;
  return safe * safe * 100;
}

/// XP earned inside the current level bucket.
int statsXpInCurrentLevel(int level, int totalXp) {
  final safeXp = totalXp < 0 ? 0 : totalXp;
  final diff = safeXp - statsXpBeforeLevel(level);
  return diff < 0 ? 0 : diff;
}
