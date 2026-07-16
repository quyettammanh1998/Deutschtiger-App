import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_tokens.dart';
import '../../data/vocab/subtitle_word.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/vocab/subtitle_words_repository.dart';
import '../../widgets/common/app_button.dart';
import 'subtitle_words_providers.dart';
import 'widgets/subtitle_words_action_bar.dart';
import 'widgets/subtitle_words_header.dart';
import 'widgets/subtitle_words_list.dart';

/// Màn "Từ đã gặp trong video" — web parity `subtitle-words-page.tsx`. Danh
/// sách từ mined từ phụ đề video, cho phép lọc theo cấp CEFR và chọn để lưu
/// vào hàng đợi ôn tập (`POST /subtitle-words/add`). State (level filter,
/// selection, save flow) lives here; presentation is split across
/// `widgets/subtitle_words_{header,list,action_bar}.dart`.
class SubtitleWordsScreen extends ConsumerStatefulWidget {
  const SubtitleWordsScreen({super.key});

  @override
  ConsumerState<SubtitleWordsScreen> createState() => _SubtitleWordsScreenState();
}

class _SubtitleWordsScreenState extends ConsumerState<SubtitleWordsScreen> {
  final _selectedLevels = <String>{};
  final _selectedIds = <String>{};
  bool _saving = false;
  String? _successMsg;

  String get _levelsKey {
    final sorted = _selectedLevels.toList()
      ..sort((a, b) => subtitleWordsLevelOrder(a).compareTo(subtitleWordsLevelOrder(b)));
    return sorted.join(',');
  }

  void _toggleLevel(String level) {
    setState(() {
      if (_selectedLevels.contains(level)) {
        _selectedLevels.remove(level);
      } else {
        _selectedLevels.add(level);
      }
      _selectedIds.clear();
    });
  }

  void _selectAllLevels() => setState(() {
    _selectedLevels.clear();
    _selectedIds.clear();
  });

  void _toggleWord(String id) => setState(() {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
    } else {
      _selectedIds.add(id);
    }
  });

  void _selectAllWords(List<SubtitleWord> words) => setState(() {
    _selectedIds
      ..clear()
      ..addAll(words.map((w) => w.learningItemId).where((id) => id.isNotEmpty));
  });

  void _clearSelection() => setState(_selectedIds.clear);

  Future<void> _addSelected() async {
    if (_selectedIds.isEmpty || _saving) return;
    final l10n = AppLocalizations.of(context);
    setState(() => _saving = true);
    try {
      final result = await ref
          .read(subtitleWordsRepositoryProvider)
          .addWords(_selectedIds.toList());
      if (!mounted) return;
      setState(() {
        _saving = false;
        _successMsg = l10n.subtitleWordsAddedCount(result.added);
        _selectedIds.clear();
      });
      ref.invalidate(subtitleWordsProvider(_levelsKey));
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) setState(() => _successMsg = null);
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.subtitleWordsAddFailed)),
      );
    }
  }

  void _goBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/vocabulary');
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final wordsAsync = ref.watch(subtitleWordsProvider(_levelsKey));
    final showActionBar = _selectedIds.isNotEmpty || _successMsg != null;

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16, 12, 16, showActionBar ? 96 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SubtitleWordsHeader(
                    onBack: _goBack,
                    selectedLevels: _selectedLevels,
                    onSelectAllLevels: _selectAllLevels,
                    onToggleLevel: _toggleLevel,
                  ),
                  wordsAsync.when(
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 48),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (_, _) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Center(
                        child: AppButton(
                          label: l10n.retry,
                          onPressed: () => ref.invalidate(subtitleWordsProvider(_levelsKey)),
                        ),
                      ),
                    ),
                    data: (words) => SubtitleWordsList(
                      words: words,
                      selectedIds: _selectedIds,
                      onToggleWord: _toggleWord,
                      onSelectAll: () => _selectAllWords(words),
                      onClearSelection: _clearSelection,
                    ),
                  ),
                ],
              ),
            ),
            if (showActionBar)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SubtitleWordsActionBar(
                  selectedCount: _selectedIds.length,
                  saving: _saving,
                  successMessage: _successMsg,
                  onAdd: _addSelected,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
