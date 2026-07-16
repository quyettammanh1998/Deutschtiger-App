import 'sprint_types.dart';

/// SM-2 + Marathon scheduler for Sprint v2 SR cards — web parity
/// `sm2-scheduler.ts`. Pure functions, no IO. Marathon = within-session
/// minute intervals; Daily = standard SM-2 day intervals. `due` is always an
/// absolute [DateTime] (not a countdown) — restart-safe with no background
/// timer (verified 17/07 against web's localStorage persistence).
const _sessionHours = 10;
const _efMin = 1.3;
const _efMax = 3.0;

const Map<SRRating, int> _marathonIntervalMin = {
  SRRating.again: 1,
  SRRating.hard: 10,
  SRRating.good: 30,
  SRRating.easy: 120,
};

/// Initial SR state for a new card.
SRCardState newCard(String slug, [DateTime? now]) {
  final n = now ?? DateTime.now();
  return SRCardState(slug: slug, due: n, ef: 2.5, interval: 0, reps: 0, seenCount: 0);
}

double _clampEf(double ef) => ef.clamp(_efMin, _efMax);

/// Marathon: next due based on minute interval, capped at `sessionStart+10h`.
SRCardState scheduleMarathon(SRCardState card, SRRating rating, DateTime sessionStart, [DateTime? now]) {
  final n = now ?? DateTime.now();
  final minutes = _marathonIntervalMin[rating]!;
  final sessionEnd = sessionStart.add(const Duration(hours: _sessionHours));
  final proposedDue = n.add(Duration(minutes: minutes));
  final due = proposedDue.isAfter(sessionEnd) ? sessionEnd : proposedDue;
  return card.copyWith(
    due: due,
    interval: minutes,
    reps: rating == SRRating.again ? 0 : card.reps + 1,
    lastRating: rating,
    seenCount: card.seenCount + 1,
    lastSeenAt: n,
  );
}

/// Daily SM-2 algorithm. Standard formula with EF clamping.
SRCardState scheduleDaily(SRCardState card, SRRating rating, [DateTime? now]) {
  final n = now ?? DateTime.now();
  // SM-2 quality: again=1, hard=3, good=4, easy=5.
  final q = switch (rating) {
    SRRating.again => 1,
    SRRating.hard => 3,
    SRRating.good => 4,
    SRRating.easy => 5,
  };

  var ef = card.ef;
  var interval = card.interval;
  var reps = card.reps;

  if (q < 3) {
    reps = 0;
    interval = 1;
  } else {
    reps += 1;
    if (reps == 1) {
      interval = 1;
    } else if (reps == 2) {
      interval = q == 5 ? 4 : 3;
    } else {
      interval = (card.interval * ef).round();
    }
    if (rating == SRRating.easy) interval = (interval * 1.3).round();
  }
  // Defensive cap (~10 years) — matches web's math exactly for every
  // realistic study horizon, but Dart's `DateTime` throws on out-of-range
  // values (unlike JS `Date`), so an unbounded run of "easy" ratings could
  // otherwise crash `n.add(Duration(days: interval))`. Not a web deviation
  // in practice: no B1 exam prep spans a decade of daily reviews.
  if (interval > 3650) interval = 3650;

  ef = _clampEf(ef + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02)));

  return card.copyWith(
    ef: ef,
    interval: interval,
    reps: reps,
    due: n.add(Duration(days: interval)),
    lastRating: rating,
    seenCount: card.seenCount + 1,
    lastSeenAt: n,
  );
}

/// Apply a rating using the algorithm matching [mode].
SRCardState applySrRating(
  SRCardState card,
  SRRating rating,
  SRMode mode,
  DateTime sessionStart, [
  DateTime? now,
]) {
  return mode == SRMode.marathon
      ? scheduleMarathon(card, rating, sessionStart, now)
      : scheduleDaily(card, rating, now);
}

/// Human-readable next-interval label for the rating bar UI.
String intervalLabel(SRRating rating, SRMode mode) {
  if (mode == SRMode.marathon) {
    final m = _marathonIntervalMin[rating]!;
    return m < 60 ? '${m}m' : '${(m / 60).round()}h';
  }
  return switch (rating) {
    SRRating.again => 'now',
    SRRating.hard => '~1d',
    SRRating.good => '~2.5d',
    SRRating.easy => '~4d',
  };
}
