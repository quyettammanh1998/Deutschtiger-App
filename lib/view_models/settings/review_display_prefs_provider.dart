import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// On-device (not synced) daily-review display toggles. Web parity:
/// `lib/preferences/review-display-prefs.ts` (`localStorage`) — mirrored
/// here via [SharedPreferences] under the same three concerns:
///  - `reviewDisplay.autoAdvance` — auto-jump to next card after answering.
///  - `reviewDisplay.show4Button` — show the 4-level Quên/Khó/Tốt/Dễ sheet.
///  - `reviewDisplay.showContext` — show an example sentence per word.
///
/// This provider only owns the settings-UI read/write surface; the actual
/// daily-review screen that consumes these three keys is out of this
/// phase's file ownership (`lib/screens/journey/**` /
/// `lib/features/daily_path/**`) — whichever phase builds that screen
/// should read the same [SharedPreferences] keys documented below rather
/// than re-inventing storage.
class ReviewDisplayPrefs {
  const ReviewDisplayPrefs({
    this.autoAdvance = false,
    this.show4Button = true,
    this.showContext = true,
  });

  static const keyAutoAdvance = 'reviewDisplay.autoAdvance';
  static const keyShow4Button = 'reviewDisplay.show4Button';
  static const keyShowContext = 'reviewDisplay.showContext';

  final bool autoAdvance;
  final bool show4Button;
  final bool showContext;

  ReviewDisplayPrefs copyWith({
    bool? autoAdvance,
    bool? show4Button,
    bool? showContext,
  }) => ReviewDisplayPrefs(
    autoAdvance: autoAdvance ?? this.autoAdvance,
    show4Button: show4Button ?? this.show4Button,
    showContext: showContext ?? this.showContext,
  );
}

class ReviewDisplayPrefsNotifier extends AutoDisposeNotifier<ReviewDisplayPrefs> {
  @override
  ReviewDisplayPrefs build() {
    Future.microtask(_load);
    return const ReviewDisplayPrefs();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = ReviewDisplayPrefs(
      autoAdvance: prefs.getBool(ReviewDisplayPrefs.keyAutoAdvance) ?? false,
      show4Button: prefs.getBool(ReviewDisplayPrefs.keyShow4Button) ?? true,
      showContext: prefs.getBool(ReviewDisplayPrefs.keyShowContext) ?? true,
    );
  }

  Future<void> setAutoAdvance(bool value) async {
    state = state.copyWith(autoAdvance: value);
    (await SharedPreferences.getInstance())
        .setBool(ReviewDisplayPrefs.keyAutoAdvance, value);
  }

  Future<void> setShow4Button(bool value) async {
    state = state.copyWith(show4Button: value);
    (await SharedPreferences.getInstance())
        .setBool(ReviewDisplayPrefs.keyShow4Button, value);
  }

  Future<void> setShowContext(bool value) async {
    state = state.copyWith(showContext: value);
    (await SharedPreferences.getInstance())
        .setBool(ReviewDisplayPrefs.keyShowContext, value);
  }
}

final reviewDisplayPrefsProvider =
    NotifierProvider.autoDispose<ReviewDisplayPrefsNotifier, ReviewDisplayPrefs>(
      ReviewDisplayPrefsNotifier.new,
    );
