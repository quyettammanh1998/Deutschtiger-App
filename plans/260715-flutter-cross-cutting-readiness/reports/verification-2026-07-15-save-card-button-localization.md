# Save card button localization verification

The shared Vocabulary save action now localizes quick-save/deck-picker chrome,
safe recovery copy and snackbar action labels. Deck names remain user data.

| Test | Expected | Actual | Status |
|---|---|---|---|
| Pre-fix German 200% deck-picker flow | Picker content fits and selected deck is tappable | `RenderFlex` overflowed by 63px; selected deck was off-screen | ✅ reproduced |
| `flutter test test/shared/widgets/save_card_button_test.dart` | German 200% picker scrolls, persists the selected deck and opens its route; quick-save variants retain no-deck behavior | 2 tests passed | ✅ |
| `flutter test test/shared/widgets/word_lookup_sheet_test.dart` | Existing Vietnamese Word Lookup host supplies localization delegates for its embedded save control | 1 test passed | ✅ |
| `flutter analyze` | No static-analysis regression | No issues found | ✅ |
| `flutter test` | Full suite stays green | 228 tests passed | ✅ |
| `flutter build apk --debug` | Debug APK compiles from this source | Built successfully; 206,822,245-byte APK | ✅ |
| `jq empty` on all ARB catalogs and `git diff --check` | Valid catalogs and no whitespace errors | Passed | ✅ |
