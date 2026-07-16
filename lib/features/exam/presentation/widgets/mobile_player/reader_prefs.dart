// Reader prefs — font scale / highlight / word-lookup toggles. Web ports:
// `useReaderFontScale`, `hooks/shared/use-word-lookup-pref.ts`,
// `contexts/word-lookup-context`. Session-only (không persist local storage —
// web dùng localStorage nhưng vòng đời 1 phiên luyện đề là đủ; ghi chú deviation
// trong report).
//
// `QuestionCardFrame` (widgets/question_card_frame.dart, sibling dir) đọc
// trực tiếp các provider này qua `ConsumerWidget` thay vì thread param qua 5
// renderer con — giữ interface renderer hiện có không đổi.
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 1.0 = 100%. Web range xấp xỉ 0.85–1.3.
final readerFontScaleProvider = StateProvider.autoDispose<double>((_) => 1.0);

/// Bật/tắt tap-word-lookup trên prompt câu hỏi (web word-lookup-context).
/// Mặc định TẮT — web mặc định cũng đọc theo user-pref lưu trước đó (không
/// auto-on); user bật qua nút "?" (reader guide) hoặc Cài đặt hiển thị.
final wordLookupEnabledProvider = StateProvider.autoDispose<bool>((_) => false);

/// Highlight state — đơn giản hoá so với web (CSS Custom Highlight API theo
/// range ký tự): đây là toggle theo TỪ (word-level), lưu trong bộ nhớ phiên,
/// không đồng bộ server. Xem ghi chú deviation trong report wave B.
class HighlightState {
  const HighlightState({
    this.enabled = false,
    this.activeColorIndex = 0,
    this.marks = const {},
  });

  final bool enabled;
  final int activeColorIndex;

  /// questionId -> set các từ (lowercase) đã highlight.
  final Map<String, Set<String>> marks;

  HighlightState copyWith({
    bool? enabled,
    int? activeColorIndex,
    Map<String, Set<String>>? marks,
  }) => HighlightState(
    enabled: enabled ?? this.enabled,
    activeColorIndex: activeColorIndex ?? this.activeColorIndex,
    marks: marks ?? this.marks,
  );
}

class HighlightNotifier extends StateNotifier<HighlightState> {
  HighlightNotifier() : super(const HighlightState());

  void setEnabled(bool enabled) => state = state.copyWith(enabled: enabled);

  void setActiveColor(int index) =>
      state = state.copyWith(activeColorIndex: index);

  void toggleWord(String questionId, String word) {
    final key = word.toLowerCase();
    final current = Set<String>.from(state.marks[questionId] ?? const {});
    if (!current.remove(key)) current.add(key);
    state = state.copyWith(marks: {...state.marks, questionId: current});
  }

  bool isHighlighted(String questionId, String word) =>
      state.marks[questionId]?.contains(word.toLowerCase()) ?? false;
}

final highlightControllerProvider =
    StateNotifierProvider.autoDispose<HighlightNotifier, HighlightState>(
      (_) => HighlightNotifier(),
    );
