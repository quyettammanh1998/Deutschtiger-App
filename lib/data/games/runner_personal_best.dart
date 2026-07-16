import 'package:shared_preferences/shared_preferences.dart';

const _kStorageKey = 'deutsch-runner-personal-best';

/// Deutsch Runner personal-best record — mirrors web
/// `src/lib/game/runner-personal-best.ts` (`localStorage`), stored locally
/// via [SharedPreferences] (no backend endpoint for this — web itself keeps
/// it client-side only).
class RunnerPersonalBest {
  const RunnerPersonalBest({
    required this.score,
    required this.accuracy,
    required this.correct,
    required this.total,
  });

  final int score;
  final int accuracy;
  final int correct;
  final int total;

  factory RunnerPersonalBest.fromPrefs(SharedPreferences prefs) {
    return RunnerPersonalBest(
      score: prefs.getInt('$_kStorageKey:score') ?? 0,
      accuracy: prefs.getInt('$_kStorageKey:accuracy') ?? 0,
      correct: prefs.getInt('$_kStorageKey:correct') ?? 0,
      total: prefs.getInt('$_kStorageKey:total') ?? 0,
    );
  }

  Future<void> _save(SharedPreferences prefs) async {
    await prefs.setInt('$_kStorageKey:score', score);
    await prefs.setInt('$_kStorageKey:accuracy', accuracy);
    await prefs.setInt('$_kStorageKey:correct', correct);
    await prefs.setInt('$_kStorageKey:total', total);
  }
}

/// Reads the current personal best, or null when the user has never played.
Future<RunnerPersonalBest?> loadRunnerPersonalBest() async {
  final prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey('$_kStorageKey:score')) return null;
  return RunnerPersonalBest.fromPrefs(prefs);
}

/// Saves a completed run if it beats the current best (by score). Returns
/// true when this run set a new record — mirrors web
/// `saveRunnerPersonalBest`'s return contract.
Future<bool> saveRunnerPersonalBestIfRecord({
  required int score,
  required int correct,
  required int wrong,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final prevScore = prefs.getInt('$_kStorageKey:score');
  final isNew = prevScore == null || score > prevScore;
  if (isNew) {
    final total = correct + wrong;
    final accuracy = total > 0 ? ((correct / total) * 100).round() : 0;
    await RunnerPersonalBest(
      score: score,
      accuracy: accuracy,
      correct: correct,
      total: total,
    )._save(prefs);
  }
  return isNew;
}
