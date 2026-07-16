import 'package:flutter/material.dart';
import 'package:deutschtiger/core/icons/app_phosphor_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_tokens.dart';

/// "Mỗi màn 3 câu" — collapsible orienting strip at the top of a page,
/// answering: why the user sees this page · what they do here · where to go
/// when done.
///
/// Web parity: `thamkhao/deutschtiger-frontend/src/components/shared/
/// page-intro.tsx`. Collapse state persists per [pageKey] (device-local, key
/// `pi:{pageKey}`, mirrors web's `localStorage` via `SharedPreferences` here)
/// — default expanded on first visit.
class PageIntro extends StatefulWidget {
  const PageIntro({
    super.key,
    required this.pageKey,
    required this.why,
    required this.todo,
    required this.next,
    this.nextTo,
    this.nextLabel,
    this.onNextTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  });

  /// Stable id for persisting the collapse state, e.g. "learn",
  /// "daily-review".
  final String pageKey;

  /// Why the user is seeing this page (1 short line).
  final String why;

  /// What they can do here (1 short line).
  final String todo;

  /// Where to go / what happens when done (1 short line).
  final String next;

  /// Optional CTA rendered under the three lines. [nextTo] is a route name
  /// pushed via `Navigator.pushNamed`; pass [onNextTap] instead when the
  /// call site needs custom navigation (deep params, replace, etc.).
  final String? nextTo;
  final String? nextLabel;
  final VoidCallback? onNextTap;

  final EdgeInsetsGeometry padding;

  @override
  State<PageIntro> createState() => _PageIntroState();
}

class _PageIntroState extends State<PageIntro> {
  static const _prefsPrefix = 'pi:';

  bool _collapsed = false;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _restoreCollapsedState();
  }

  Future<void> _restoreCollapsedState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getBool('$_prefsPrefix${widget.pageKey}');
      if (!mounted) return;
      setState(() {
        _collapsed = saved ?? false;
        _loaded = true;
      });
    } catch (_) {
      // Persistence là "nice to have"; nếu SharedPreferences lỗi (hiếm, vd
      // platform channel chưa sẵn sàng trong test), giữ mặc định expanded.
      if (mounted) setState(() => _loaded = true);
    }
  }

  Future<void> _toggle() async {
    setState(() => _collapsed = !_collapsed);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('$_prefsPrefix${widget.pageKey}', _collapsed);
    } catch (_) {
      // Bỏ qua lỗi lưu — trạng thái UI hiện tại vẫn đúng trong phiên này.
    }
  }

  void _handleNextTap() {
    if (widget.onNextTap != null) {
      widget.onNextTap!();
    } else if (widget.nextTo != null) {
      Navigator.of(context).pushNamed(widget.nextTo!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    // Chưa load xong prefs: coi như expanded (mặc định web) để tránh nháy UI.
    final collapsed = _loaded && _collapsed;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.muted.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tokens.border),
      ),
      child: Padding(
        padding: widget.padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: _toggle,
              child: Row(
                children: [
                  Icon(AppPhosphorIcons.info, size: 16, color: tokens.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.why,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: tokens.foreground.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: collapsed ? 0 : 0.5,
                    duration: const Duration(milliseconds: 150),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                      color: tokens.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
            if (!collapsed) ...[
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _IntroLine(label: 'Làm gì: ', value: widget.todo, tokens: tokens),
                    const SizedBox(height: 2),
                    _IntroLine(label: 'Xong rồi: ', value: widget.next, tokens: tokens),
                    if (widget.nextLabel != null &&
                        (widget.nextTo != null || widget.onNextTap != null)) ...[
                      const SizedBox(height: 2),
                      InkWell(
                        onTap: _handleNextTap,
                        child: Text(
                          '${widget.nextLabel!} →',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: tokens.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _IntroLine extends StatelessWidget {
  const _IntroLine({required this.label, required this.value, required this.tokens});

  final String label;
  final String value;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
        children: [
          TextSpan(
            text: label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: tokens.foreground.withValues(alpha: 0.7),
            ),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}
