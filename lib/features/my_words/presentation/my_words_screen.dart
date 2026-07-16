import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../view_models/providers.dart';
import '../data/my_words_repository.dart';
import '../domain/my_word.dart';
import 'my_words_overview.dart';

final myWordsRepositoryProvider = Provider<MyWordsRepository>((ref) {
  return MyWordsRepository(ref.watch(apiClientProvider));
});

final myWordsProvider = FutureProvider.family<MyWordsPage, MyWordsFilter>((
  ref,
  filter,
) {
  return ref.watch(myWordsRepositoryProvider).fetch(filter: filter);
});

/// Standalone `/my-words` route — kept ONLY because two other in-flight
/// phases (home dashboard shortcuts) still deep-link here; the web has no
/// standalone my-words page (it's the ⭐ tab embedded in `/vocabulary`, see
/// [MyWordsOverview]). This is now a thin Scaffold wrapper around the same
/// embeddable overview — the old Material `SegmentedButton` toggle is gone.
class MyWordsScreen extends StatelessWidget {
  const MyWordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: context.tokens.background,
      appBar: AppBar(title: Text(l10n.myWords)),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: MyWordsOverview(),
      ),
    );
  }
}
