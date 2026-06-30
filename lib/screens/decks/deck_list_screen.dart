import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import 'package:deutschtiger/widgets/common/async_state_views.dart';
import '../data/deck_repository.dart';
import '../domain/deck_models.dart';
import 'deck_provider.dart';

/// Màn danh sách decks.
class DeckListScreen extends ConsumerWidget {
  const DeckListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decks = ref.watch(decksProvider);

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: const Text(
          'Bộ từ của tôi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.tigerOrange,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateDeckDialog(context, ref),
            tooltip: 'Tạo bộ từ mới',
          ),
        ],
      ),
      body: decks.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          message: 'Không tải được danh sách bộ từ',
          onRetry: () => ref.invalidate(decksProvider),
        ),
        data: (deckList) {
          if (deckList.isEmpty) {
            return _EmptyDeckView(
              onCreate: () => _showCreateDeckDialog(context, ref),
            );
          }
          return RefreshIndicator(
            color: AppColors.tigerOrange,
            onRefresh: () async => ref.invalidate(decksProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: deckList.length,
              itemBuilder: (context, index) {
                final deck = deckList[index];
                return _DeckCard(
                  deck: deck,
                  onTap: () => context.push('/decks/${deck.id}'),
                  onEdit: () => _showEditDeckDialog(context, ref, deck),
                  onDelete: () => _confirmDeleteDeck(context, ref, deck),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showCreateDeckDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _CreateDeckDialog(
        onSave: (name, description) async {
          final repo = ref.read(deckRepositoryProvider);
          await repo.createDeck(name: name, description: description);
          ref.invalidate(decksProvider);
        },
      ),
    );
  }

  void _showEditDeckDialog(BuildContext context, WidgetRef ref, Deck deck) {
    showDialog(
      context: context,
      builder: (context) => _CreateDeckDialog(
        initialName: deck.name,
        initialDescription: deck.description,
        isEdit: true,
        onSave: (name, description) async {
          final repo = ref.read(deckRepositoryProvider);
          await repo.updateDeck(deck.id, name: name, description: description);
          ref.invalidate(decksProvider);
        },
      ),
    );
  }

  Future<void> _confirmDeleteDeck(
    BuildContext context,
    WidgetRef ref,
    Deck deck,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa bộ từ'),
        content: Text('Bạn có chắc muốn xóa "${deck.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Xóa',
              style: TextStyle(color: AppColors.destructive),
            ),
          ),
        ],
      ),
    );

    if (ok == true) {
      final repo = ref.read(deckRepositoryProvider);
      await repo.deleteDeck(deck.id);
      ref.invalidate(decksProvider);
    }
  }
}

class _DeckCard extends StatelessWidget {
  const _DeckCard({
    required this.deck,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final Deck deck;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final progress = deck.wordCount > 0
        ? deck.learnedCount / deck.wordCount
        : 0.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _parseColor(deck.coverColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.folder_outlined,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          deck.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (deck.description != null)
                          Text(
                            deck.description!,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.mutedForeground,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          onEdit();
                          break;
                        case 'delete':
                          onDelete();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined),
                            SizedBox(width: 8),
                            Text('Sửa'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, color: AppColors.destructive),
                            SizedBox(width: 8),
                            Text('Xóa', style: TextStyle(color: AppColors.destructive)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    '${deck.wordCount} từ',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                  const Spacer(),
                  if (deck.wordCount > 0)
                    Text(
                      '${deck.learnedCount}/${deck.wordCount} đã học',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                ],
              ),
              if (deck.wordCount > 0) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: AppColors.border,
                    valueColor: const AlwaysStoppedAnimation(AppColors.tigerOrange),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _parseColor(String? colorString) {
    if (colorString == null) return AppColors.tigerOrange;
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (_) {
      return AppColors.tigerOrange;
    }
  }
}

class _EmptyDeckView extends StatelessWidget {
  const _EmptyDeckView({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.folder_outlined,
              size: 80,
              color: AppColors.mutedForeground,
            ),
            const SizedBox(height: 16),
            const Text(
              'Chưa có bộ từ nào',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tạo bộ từ riêng để học theo chủ đề bạn thích',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.mutedForeground,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add),
              label: const Text('Tạo bộ từ'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateDeckDialog extends StatefulWidget {
  const _CreateDeckDialog({
    this.initialName,
    this.initialDescription,
    this.isEdit = false,
    required this.onSave,
  });

  final String? initialName;
  final String? initialDescription;
  final bool isEdit;
  final Future<void> Function(String name, String? description) onSave;

  @override
  State<_CreateDeckDialog> createState() => _CreateDeckDialogState();
}

class _CreateDeckDialogState extends State<_CreateDeckDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _descController = TextEditingController(text: widget.initialDescription);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty) return;

    setState(() => _loading = true);
    try {
      await widget.onSave(
        _nameController.text.trim(),
        _descController.text.trim().isEmpty
            ? null
            : _descController.text.trim(),
      );
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEdit ? 'Sửa bộ từ' : 'Tạo bộ từ mới'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Tên bộ từ',
              hintText: 'Ví dụ: Từ vựng du lịch',
            ),
            autofocus: true,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descController,
            decoration: const InputDecoration(
              labelText: 'Mô tả (tùy chọn)',
              hintText: 'Mô tả ngắn về bộ từ',
            ),
            maxLines: 2,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: _loading ? null : _save,
          child: _loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.isEdit ? 'Lưu' : 'Tạo'),
        ),
      ],
    );
  }
}
