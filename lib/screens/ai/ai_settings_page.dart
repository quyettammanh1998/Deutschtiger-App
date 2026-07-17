import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_tokens.dart';
import 'package:deutschtiger/data/ai/ai_chat_live_models.dart';
import 'package:deutschtiger/view_models/ai/ai_provider.dart';

/// AI Memory & Profile settings — wired to `GET/DELETE /ai/memory` (facts
/// Tiger AI extracted automatically) and `GET/PUT /ai/profile` (the
/// user-authored "Tiger AI Memory" fields/notes from the web Settings page).
class AISettingsPage extends ConsumerStatefulWidget {
  const AISettingsPage({super.key});

  @override
  ConsumerState<AISettingsPage> createState() => _AISettingsPageState();
}

class _AISettingsPageState extends ConsumerState<AISettingsPage> {
  final _fieldControllers = {for (final k in AiProfile.fieldKeys) k: TextEditingController()};
  final _noteControllers = <TextEditingController>[];
  bool _formSeeded = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(aiMemoryNotifierProvider.notifier).load();
      ref.read(aiProfileNotifierProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    for (final c in _fieldControllers.values) {
      c.dispose();
    }
    for (final c in _noteControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _seedForm(AiProfile profile) {
    if (_formSeeded) return;
    _formSeeded = true;
    for (final k in AiProfile.fieldKeys) {
      _fieldControllers[k]!.text = profile.fields[k] ?? '';
    }
    _noteControllers
      ..clear()
      ..addAll(profile.notes.map((n) => TextEditingController(text: n.raw)));
    if (_noteControllers.isEmpty) _noteControllers.add(TextEditingController());
  }

  void _addNote() => setState(() => _noteControllers.add(TextEditingController()));

  void _removeNote(int index) => setState(() {
    _noteControllers[index].dispose();
    _noteControllers.removeAt(index);
  });

  void _saveProfile() {
    final fields = {for (final k in AiProfile.fieldKeys) k: _fieldControllers[k]!.text.trim()};
    final notes = _noteControllers
        .map((c) => c.text.trim())
        .where((n) => n.isNotEmpty)
        .toList();
    ref.read(aiProfileNotifierProvider.notifier).save(fields: fields, notes: notes);
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(aiProfileNotifierProvider);
    final memoryState = ref.watch(aiMemoryNotifierProvider);

    if (!profileState.isLoading) _seedForm(profileState.profile);

    return Scaffold(
      appBar: AppBar(title: const Text('AI Memory & Settings')),
      body: profileState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const _SectionHeader(title: 'Tiger AI Memory'),
                Text(
                  'Tự giới thiệu để Tiger AI trò chuyện đúng ngữ cảnh hơn.',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                const SizedBox(height: 16),
                _ProfileFieldsCard(controllers: _fieldControllers),
                const SizedBox(height: 16),
                _NotesCard(
                  controllers: _noteControllers,
                  onAdd: _addNote,
                  onRemove: _removeNote,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: profileState.isSaving ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.tokens.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: profileState.isSaving
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : const Text('Save'),
                  ),
                ),
                const SizedBox(height: 32),
                const _SectionHeader(title: 'Remembered facts'),
                Text(
                  'Những gì Tiger AI tự rút ra được từ các cuộc trò chuyện trước.',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                const SizedBox(height: 12),
                _MemoryFactsCard(state: memoryState),
              ],
            ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: context.tokens.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _ProfileFieldsCard extends StatelessWidget {
  final Map<String, TextEditingController> controllers;

  const _ProfileFieldsCard({required this.controllers});

  static const _labels = {
    'name': 'Tên',
    'age': 'Tuổi',
    'gender': 'Giới tính',
    'location': 'Nơi ở',
    'interests': 'Sở thích',
    'job': 'Nghề nghiệp',
    'family': 'Gia đình',
    'goal': 'Mục tiêu học',
    'other': 'Khác',
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            for (final key in AiProfile.fieldKeys)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TextField(
                  controller: controllers[key],
                  decoration: InputDecoration(
                    labelText: _labels[key] ?? key,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    isDense: true,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NotesCard extends StatelessWidget {
  final List<TextEditingController> controllers;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;

  const _NotesCard({required this.controllers, required this.onAdd, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ghi chú tự do', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            for (var i = 0; i < controllers.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controllers[i],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          isDense: true,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () => onRemove(i),
                    ),
                  ],
                ),
              ),
            TextButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Thêm ghi chú'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemoryFactsCard extends ConsumerWidget {
  final AiMemoryState state;

  const _MemoryFactsCard({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (state.facts.isEmpty) {
      return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey[200]!),
        ),
        child: const Padding(
          padding: EdgeInsets.all(20),
          child: Text('Chưa có thông tin nào được ghi nhớ.'),
        ),
      );
    }
    return Column(
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              for (final fact in state.facts)
                ListTile(
                  dense: true,
                  title: Text(fact.factKey, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(fact.factValue),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                    onPressed: () =>
                        ref.read(aiMemoryNotifierProvider.notifier).deleteFact(fact.factKey),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => _confirmClearAll(context, ref),
          icon: const Icon(Icons.delete_sweep_outlined, color: Colors.red),
          label: const Text('Xoá toàn bộ bộ nhớ', style: TextStyle(color: Colors.red)),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.red),
            padding: const EdgeInsets.symmetric(vertical: 12),
            minimumSize: const Size(double.infinity, 0),
          ),
        ),
      ],
    );
  }

  void _confirmClearAll(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xoá toàn bộ bộ nhớ AI?'),
        content: const Text(
          'Tiger AI sẽ quên toàn bộ thông tin đã ghi nhớ về bạn. Hành động này không thể hoàn tác.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Huỷ'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              ref.read(aiMemoryNotifierProvider.notifier).deleteAll();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Xoá'),
          ),
        ],
      ),
    );
  }
}
