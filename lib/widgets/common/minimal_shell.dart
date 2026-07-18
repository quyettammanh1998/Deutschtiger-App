// ignore_for_file: prefer_initializing_formals
//
// MinimalShell — khung mỏng cho các màn full-screen không có bottom-nav:
//   - exam/practice/:examId
//   - games/runner
//   - social/duel/play
//   - writing sprint
//
// Khác AppShell: KHÔNG có 5 tab dưới, KHÔNG có FAB Tiger AI.
// Chỉ có: back button + title + optional action bên phải.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../core/theme/app_tokens.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Widget tiện ích: bọc nội dung trong minimal frame.
class MinimalShell extends ConsumerWidget {
  const MinimalShell({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.showBack = true,
    this.backgroundColor,
  });

  final String title;
  final Widget child;
  final List<Widget>? actions;
  final bool showBack;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bg = backgroundColor ?? context.tokens.background;
    return Scaffold(
      backgroundColor: bg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(DesignTokens.appBarHeight),
        child: AppBar(
          backgroundColor: bg,
          foregroundColor: context.tokens.foreground,
          elevation: 0,
          scrolledUnderElevation: 0.5,
          leading: showBack
              ? IconButton(
                  icon: const Icon(PhosphorIcons.arrowLeft, size: 20),
                  onPressed: () => Navigator.of(context).maybePop(),
                )
              : null,
          title: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: context.tokens.foreground,
            ),
          ),
          centerTitle: true,
          actions: actions,
        ),
      ),
      body: SafeArea(
        top: false,
        child: child,
      ),
    );
  }
}