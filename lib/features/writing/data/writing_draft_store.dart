import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Local writing-area draft — web parity `use-schreiben-draft.ts`
/// `DraftPayload`. Local-only (SharedPreferences), never sent to the
/// server; cleared once a submission succeeds.
class WritingDraft {
  const WritingDraft({required this.text, required this.savedAt, required this.wordCount});

  final String text;
  final DateTime savedAt;
  final int wordCount;

  Map<String, dynamic> toJson() => {
    'text': text,
    'savedAt': savedAt.toIso8601String(),
    'wordCount': wordCount,
  };

  factory WritingDraft.fromJson(Map<String, dynamic> json) => WritingDraft(
    text: json['text']?.toString() ?? '',
    savedAt: DateTime.tryParse(json['savedAt']?.toString() ?? '') ?? DateTime.now(),
    wordCount: json['wordCount'] is num ? (json['wordCount'] as num).toInt() : 0,
  );
}

/// Debounced local draft persistence, scoped by [examId] — web parity
/// `useSchreibenDraft`. Callers own the debounce timer lifecycle (call
/// [dispose] when the owning widget is disposed to flush any pending save,
/// mirroring web's unmount-flush behavior so navigating away never silently
/// drops a draft).
class WritingDraftStore {
  WritingDraftStore(this.examId);

  final String examId;
  static const _prefix = 'schreiben-draft-';
  static const _debounce = Duration(seconds: 3);

  Timer? _timer;
  String? _pendingText;

  String get _key => '$_prefix$examId';

  Future<WritingDraft?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;
    try {
      return WritingDraft.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      await prefs.remove(_key);
      return null;
    }
  }

  /// Schedules a debounced save; flushes immediately (bypassing the
  /// debounce) when [immediate] is true.
  void save(String text, {bool immediate = false}) {
    _timer?.cancel();
    if (text.trim().isEmpty) {
      _pendingText = null;
      return;
    }
    _pendingText = text;
    if (immediate) {
      unawaited(_persist(text));
      return;
    }
    _timer = Timer(_debounce, () {
      final pending = _pendingText;
      _pendingText = null;
      if (pending != null) unawaited(_persist(pending));
    });
  }

  Future<void> _persist(String text) async {
    final prefs = await SharedPreferences.getInstance();
    final draft = WritingDraft(
      text: text,
      savedAt: DateTime.now(),
      wordCount: text.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length,
    );
    await prefs.setString(_key, jsonEncode(draft.toJson()));
  }

  Future<void> clear() async {
    _timer?.cancel();
    _pendingText = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  /// Flushes a pending debounced save synchronously (best-effort) and
  /// cancels the timer — call from the owning widget's `dispose()`.
  void dispose() {
    _timer?.cancel();
    final pending = _pendingText;
    _pendingText = null;
    if (pending != null) unawaited(_persist(pending));
  }
}
