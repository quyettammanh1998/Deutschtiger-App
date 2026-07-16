import 'package:flutter/material.dart';

import '../../core/theme/app_tokens.dart';

/// German special-character keyboard bar — web parity `special-char-bar.tsx`
/// (`SpecialCharBar`). Hoisted here (P1 gap) so every text-input practice
/// view (cloze, writing, and P9 exam writing) shares one implementation.
///
/// Unlike the web version this does NOT need a manual "don't steal focus"
/// hack: plain [GestureDetector] buttons never request keyboard focus in
/// Flutter, so tapping a char keeps the caller's [TextField] focused and the
/// soft keyboard open.
class UmlautInputBar extends StatelessWidget {
  const UmlautInputBar({
    super.key,
    required this.onInsert,
    this.visible = true,
    this.chars = defaultChars,
  });

  /// `GERMAN_ALL` on web: lower umlauts + ß + upper umlauts.
  static const defaultChars = ['ä', 'ö', 'ü', 'ß', 'Ä', 'Ö', 'Ü'];

  final ValueChanged<String> onInsert;
  final bool visible;
  final List<String> chars;

  /// Inserts [char] at the current selection of [controller] (or appends at
  /// the end when there is no active selection) and restores the caret right
  /// after the inserted character. Shared helper so cloze/writing views
  /// don't duplicate cursor-math.
  static void insertAtCursor(TextEditingController controller, String char) {
    final text = controller.text;
    final selection = controller.selection;
    final start = selection.start >= 0 ? selection.start : text.length;
    final end = selection.end >= 0 ? selection.end : text.length;
    final newText = text.replaceRange(start, end, char);
    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: start + char.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: !visible
          ? const SizedBox(width: double.infinity)
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final char in chars)
                    _UmlautKey(
                      char: char,
                      tokens: tokens,
                      onTap: () => onInsert(char),
                    ),
                ],
              ),
            ),
    );
  }
}

class _UmlautKey extends StatelessWidget {
  const _UmlautKey({required this.char, required this.tokens, required this.onTap});

  final String char;
  final AppTokens tokens;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: tokens.muted,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: tokens.border),
        ),
        child: Text(
          char,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: tokens.foreground,
          ),
        ),
      ),
    );
  }
}
