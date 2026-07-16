import 'package:flutter/material.dart';

import '../../../data/decks/deck_models.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_bottom_sheet.dart';

/// Create/edit-deck dialog (name + optional description).
Future<void> showDeckFormDialog(
  BuildContext context, {
  Deck? editing,
  required Future<void> Function(String name, String? description) onSave,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) => _DeckFormDialog(editing: editing, onSave: onSave),
  );
}

class _DeckFormDialog extends StatefulWidget {
  const _DeckFormDialog({this.editing, required this.onSave});

  final Deck? editing;
  final Future<void> Function(String name, String? description) onSave;

  @override
  State<_DeckFormDialog> createState() => _DeckFormDialogState();
}

class _DeckFormDialogState extends State<_DeckFormDialog> {
  late final TextEditingController _name =
      TextEditingController(text: widget.editing?.name);
  late final TextEditingController _desc =
      TextEditingController(text: widget.editing?.description);
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _desc.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) return;
    setState(() => _loading = true);
    try {
      await widget.onSave(
        _name.text.trim(),
        _desc.text.trim().isEmpty ? null : _desc.text.trim(),
      );
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isEdit = widget.editing != null;
    return AlertDialog(
      title: Text(isEdit ? l10n.editDeck : l10n.createNewDeck),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _name,
            autofocus: true,
            decoration: InputDecoration(
              labelText: l10n.deckName,
              hintText: l10n.deckNameHint,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _desc,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: l10n.deckDescriptionOptional,
              hintText: l10n.deckDescriptionHint,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _loading ? null : _save,
          child: _loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(isEdit ? l10n.save : l10n.createDeck),
        ),
      ],
    );
  }
}

/// Create-folder dialog (name only — color/parent auto-assigned server-side
/// like web's inline form).
Future<void> showDeckFolderFormDialog(
  BuildContext context, {
  required Future<void> Function(String name) onSave,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) => _DeckFolderFormDialog(onSave: onSave),
  );
}

class _DeckFolderFormDialog extends StatefulWidget {
  const _DeckFolderFormDialog({required this.onSave});
  final Future<void> Function(String name) onSave;

  @override
  State<_DeckFolderFormDialog> createState() => _DeckFolderFormDialogState();
}

class _DeckFolderFormDialogState extends State<_DeckFolderFormDialog> {
  final _controller = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    setState(() => _loading = true);
    await widget.onSave(name);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.deckFolderName),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(hintText: l10n.deckFolderNameHint),
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _loading ? null : _save,
          child: Text(l10n.createDeck),
        ),
      ],
    );
  }
}

/// "Chuyển vào thư mục" sheet — pick a target folder (or "no folder").
Future<void> showMoveToFolderSheet(
  BuildContext context, {
  required List<DeckFolder> folders,
  required String? currentFolderId,
  required Future<void> Function(String? folderId) onMove,
}) {
  final l10n = AppLocalizations.of(context);
  return showAppBottomSheet<void>(
    context,
    builder: (ctx) => ListView(
      shrinkWrap: true,
      children: [
        Text(l10n.deckMoveToFolder, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.close),
          title: Text(l10n.deckNoFolder),
          selected: currentFolderId == null,
          onTap: () async {
            Navigator.pop(ctx);
            await onMove(null);
          },
        ),
        for (final folder in folders)
          ListTile(
            leading: const Icon(Icons.folder_outlined),
            title: Text(folder.name),
            selected: currentFolderId == folder.id,
            onTap: () async {
              Navigator.pop(ctx);
              await onMove(folder.id);
            },
          ),
      ],
    ),
  );
}
