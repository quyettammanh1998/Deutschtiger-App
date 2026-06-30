import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../data/vocab_notes_repository.dart';
import '../domain/vocab_models.dart';
import 'vocab_search_provider.dart';

/// Màn tìm kiếm từ vựng.
class VocabSearchScreen extends ConsumerStatefulWidget {
  const VocabSearchScreen({super.key});

  @override
  ConsumerState<VocabSearchScreen> createState() => _VocabSearchScreenState();
}

class _VocabSearchScreenState extends ConsumerState<VocabSearchScreen>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _searchController;
  late final TabController _tabController;
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    ref.read(vocabSearchQueryProvider.notifier).setQuery(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: const Text(
          'Tìm từ vựng',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.tigerOrange,
            fontSize: 18,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Tìm từ tiếng Đức...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _onSearch('');
                            },
                          )
                        : IconButton(
                            icon: Icon(
                              _showFilters
                                  ? Icons.filter_list_off
                                  : Icons.filter_list,
                            ),
                            onPressed: () {
                              setState(() => _showFilters = !_showFilters);
                            },
                          ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onChanged: _onSearch,
                ),
              ),
              if (_showFilters) _FilterChips(),
              const SizedBox(height: 8),
              TabBar(
                controller: _tabController,
                labelColor: AppColors.tigerOrange,
                unselectedLabelColor: AppColors.mutedForeground,
                indicatorColor: AppColors.tigerOrange,
                tabs: const [
                  Tab(text: 'Kết quả'),
                  Tab(text: 'Đã lưu'),
                  Tab(text: 'Ghi chú'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _SearchResultsTab(),
          _LearnedWordsTab(),
          _NotesTab(),
        ],
      ),
    );
  }
}

class _FilterChips extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCefr = ref.watch(vocabCefrFilterProvider);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Wrap(
        spacing: 8,
        children: [
          FilterChip(
            label: const Text('Tất cả'),
            selected: selectedCefr == null,
            onSelected: (_) {
              ref.read(vocabCefrFilterProvider.notifier).setFilter(null);
            },
          ),
          ...cefrLevels.map(
            (level) => FilterChip(
              label: Text(level),
              selected: selectedCefr == level,
              onSelected: (_) {
                ref.read(vocabCefrFilterProvider.notifier).setFilter(
                    selectedCefr == level ? null : level);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchResultsTab extends ConsumerWidget {
  const _SearchResultsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResults = ref.watch(vocabSearchResultsProvider);
    final query = ref.watch(vocabSearchQueryProvider);

    if (query.trim().isEmpty) {
      return const _EmptySearchView();
    }

    return searchResults.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.tigerOrange),
      ),
      error: (e, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.destructive),
            const SizedBox(height: 16),
            Text('Lỗi: $e'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(vocabSearchResultsProvider),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
      data: (result) {
        if (result.words.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.search_off, size: 64, color: AppColors.muted),
                const SizedBox(height: 16),
                Text(
                  'Không tìm thấy từ nào',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.mutedForeground,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: result.words.length,
          itemBuilder: (context, index) {
            final word = result.words[index];
            return _VocabWordCard(word: word);
          },
        );
      },
    );
  }
}

class _LearnedWordsTab extends ConsumerWidget {
  const _LearnedWordsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final learnedWords = ref.watch(learnedWordsProvider);

    return learnedWords.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.tigerOrange),
      ),
      error: (e, _) => Center(child: Text('Lỗi: $e')),
      data: (words) {
        if (words.isEmpty) {
          return const _EmptyLearnedView();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: words.length,
          itemBuilder: (context, index) {
            final word = words[index];
            return _VocabWordCard(word: word);
          },
        );
      },
    );
  }
}

class _VocabWordCard extends StatelessWidget {
  const _VocabWordCard({required this.word});

  final VocabWord word;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _showWordDetail(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          word.word,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (word.pronunciation != null)
                          Text(
                            word.pronunciation!,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.mutedForeground,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (word.cefrLevel.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.tigerOrange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        word.cefrLevel,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.tigerOrange,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                word.translation,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showWordDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _WordDetailSheet(word: word),
    );
  }
}

class _WordDetailSheet extends ConsumerStatefulWidget {
  const _WordDetailSheet({required this.word, this.initialNote});

  final VocabWord word;
  final String? initialNote;

  @override
  ConsumerState<_WordDetailSheet> createState() => _WordDetailSheetState();
}

class _WordDetailSheetState extends ConsumerState<_WordDetailSheet> {
  late final TextEditingController _noteController;
  bool _isSaving = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.initialNote ?? '');
    _noteController.addListener(_onNoteChanged);
  }

  void _onNoteChanged() {
    final hasChanges = _noteController.text != (widget.initialNote ?? '');
    if (hasChanges != _hasChanges) {
      setState(() => _hasChanges = hasChanges);
    }
  }

  @override
  void dispose() {
    _noteController.removeListener(_onNoteChanged);
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    if (!_hasChanges || _isSaving) return;

    setState(() => _isSaving = true);

    try {
      final saveService = ref.read(vocabNoteSaveServiceProvider);
      await saveService.saveNote(widget.word.id, _noteController.text);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã lưu ghi chú')),
        );
        setState(() {
          _hasChanges = false;
          _isSaving = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.muted,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.word.word,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (widget.word.pronunciation != null)
                        Text(
                          widget.word.pronunciation!,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.mutedForeground,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                ),
                if (widget.word.cefrLevel.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.tigerOrange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.word.cefrLevel,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.word.translation,
              style: const TextStyle(fontSize: 18),
            ),
            if (widget.word.example != null && widget.word.example!.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Ví dụ:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(widget.word.example!, style: const TextStyle(fontStyle: FontStyle.italic)),
            ],

            // Notes section
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.note_alt, size: 20, color: AppColors.tigerOrange),
                const SizedBox(width: 8),
                const Text(
                  'Ghi chú',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Thêm ghi chú cho từ này...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: AppColors.authBackground,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _hasChanges && !_isSaving ? _saveNote : null,
                icon: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(_isSaving ? 'Đang lưu...' : 'Lưu ghi chú'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tigerOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  disabledBackgroundColor: AppColors.muted,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                label: const Text('Đóng'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptySearchView extends StatelessWidget {
  const _EmptySearchView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search, size: 64, color: AppColors.muted),
          const SizedBox(height: 16),
          Text(
            'Tìm kiếm từ vựng',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.mutedForeground,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Nhập từ tiếng Đức để tìm kiếm',
            style: TextStyle(color: AppColors.mutedForeground),
          ),
        ],
      ),
    );
  }
}

class _EmptyLearnedView extends StatelessWidget {
  const _EmptyLearnedView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bookmark_border, size: 64, color: AppColors.muted),
          const SizedBox(height: 16),
          Text(
            'Chưa có từ nào được lưu',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.mutedForeground,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tìm và lưu từ vựng để học sau',
            style: TextStyle(color: AppColors.mutedForeground),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Notes Tab
// ============================================================================

class _NotesTab extends ConsumerWidget {
  const _NotesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(allVocabNotesProvider);

    return notesAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.tigerOrange),
      ),
      error: (e, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.destructive),
            const SizedBox(height: 16),
            Text('Lỗi: $e'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(allVocabNotesProvider),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
      data: (notes) {
        if (notes.isEmpty) {
          return const _EmptyNotesView();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final noteItem = notes[index];
            return _NoteCard(noteItem: noteItem);
          },
        );
      },
    );
  }
}

class _NoteCard extends ConsumerWidget {
  const _NoteCard({required this.noteItem});

  final VocabWordWithNote noteItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _editNote(context, ref),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      noteItem.word?.word ?? noteItem.wordId,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: () => _editNote(context, ref),
                    color: AppColors.tigerOrange,
                  ),
                ],
              ),
              if (noteItem.word?.translation != null) ...[
                const SizedBox(height: 4),
                Text(
                  noteItem.word!.translation,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.mutedForeground,
                  ),
                ),
              ],
              if (noteItem.note != null && noteItem.note!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.tigerOrange.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    noteItem.note!,
                    style: const TextStyle(fontSize: 14),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _editNote(BuildContext context, WidgetRef ref) {
    final word = noteItem.word ?? VocabWord(id: noteItem.wordId, word: noteItem.wordId, translation: '');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _WordDetailSheet(word: word, initialNote: noteItem.note),
    );
  }
}

class _EmptyNotesView extends StatelessWidget {
  const _EmptyNotesView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.note_alt_outlined, size: 64, color: AppColors.muted),
          const SizedBox(height: 16),
          Text(
            'Chưa có ghi chú nào',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.mutedForeground,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Thêm ghi chú vào từ vựng để ôn tập',
            style: TextStyle(color: AppColors.mutedForeground),
          ),
        ],
      ),
    );
  }
}
