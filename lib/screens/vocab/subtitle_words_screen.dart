import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/vocab/subtitle_words_repository.dart';

final subtitleWordsProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(subtitleWordsRepositoryProvider).getWords();
});

/// Màn "Từ trong phụ đề" — danh sách từ mined từ phụ đề video, cho phép chọn
/// và lưu vào hàng đợi ôn tập + bộ thẻ mặc định (`POST /subtitle-words/add`).
/// Truy cập từ hub từ vựng (`VocabularyScreen`).
class SubtitleWordsScreen extends ConsumerStatefulWidget {
  const SubtitleWordsScreen({super.key});

  @override
  ConsumerState<SubtitleWordsScreen> createState() => _SubtitleWordsScreenState();
}

class _SubtitleWordsScreenState extends ConsumerState<SubtitleWordsScreen> {
  final _selected = <String>{};
  bool _saving = false;

  Future<void> _saveSelected() async {
    if (_selected.isEmpty || _saving) return;
    final l10n = AppLocalizations.of(context);
    setState(() => _saving = true);
    try {
      final result = await ref
          .read(subtitleWordsRepositoryProvider)
          .addWords(_selected.toList());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.subtitleWordsAddedCount(result.added))),
      );
      setState(() => _selected.clear());
      ref.invalidate(subtitleWordsProvider);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.subtitleWordsAddFailed)),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final wordsAsync = ref.watch(subtitleWordsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.subtitleWordsTitle)),
      floatingActionButton: _selected.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: _saving ? null : _saveSelected,
              icon: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.bookmark_add),
              label: Text(l10n.subtitleWordsAddSelected(_selected.length)),
            ),
      body: wordsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(
          child: FilledButton(
            onPressed: () => ref.invalidate(subtitleWordsProvider),
            child: Text(l10n.retry),
          ),
        ),
        data: (words) {
          if (words.isEmpty) {
            return Center(child: Text(l10n.subtitleWordsEmpty));
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: words.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final word = words[index];
              final isSelected = _selected.contains(word.learningItemId);
              return CheckboxListTile(
                key: Key('subtitle_word_${word.learningItemId}'),
                value: isSelected,
                onChanged: word.learningItemId.isEmpty
                    ? null
                    : (checked) => setState(() {
                        if (checked ?? false) {
                          _selected.add(word.learningItemId);
                        } else {
                          _selected.remove(word.learningItemId);
                        }
                      }),
                title: Text(word.contentDe),
                subtitle: Text(word.contentVi),
                secondary: Text(
                  l10n.subtitleWordsSeenCount(word.seenCount),
                  style: const TextStyle(fontSize: 12, color: AppColors.mutedForeground),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
