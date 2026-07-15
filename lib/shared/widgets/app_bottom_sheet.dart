import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';

/// Standardised bottom-sheet wrapper used by the app.
///
/// Wraps [showModalBottomSheet] with:
///   * rounded top corners (24px)
///   * a 4-px drag handle pill
///   * consistent horizontal padding and bottom safe-area spacing
///   * rounded clip so the body content matches the radius
///
/// Use [showAppBottomSheet] for a one-shot helper or [AppBottomSheet] as a
/// builder when more control is needed.
class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.padding = const EdgeInsets.fromLTRB(
      DesignTokens.screenHorizontalPadding,
      12,
      DesignTokens.screenHorizontalPadding,
      DesignTokens.spacingLg,
    ),
    this.showDragHandle = true,
  });

  final Widget child;
  final String? title;
  final EdgeInsetsGeometry padding;
  final bool showDragHandle;

  /// Push the sheet onto the navigator and return when it closes.
  static Future<T?> show<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    bool isScrollControlled = true,
    Color? backgroundColor,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AppBottomSheet(child: builder(ctx)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor(context) ?? DesignTokens.card,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(DesignTokens.radiusLg),
          ),
        ),
        child: SingleChildScrollView(
          padding: padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showDragHandle)
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(
                      bottom: DesignTokens.spacingMd,
                    ),
                    decoration: BoxDecoration(
                      color: DesignTokens.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              if (title != null) ...[
                Text(
                  title!,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: DesignTokens.spacingSm + 4),
              ],
              child,
            ],
          ),
        ),
      ),
    );
  }

  Color? backgroundColor(BuildContext context) => null;
}

/// Convenience helper for one-liner sheet usage:
///
/// ```dart
/// final ok = await showAppBottomSheet<bool>(
///   context,
///   builder: (_) => const _ConfirmBody(),
/// );
/// ```
Future<T?> showAppBottomSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  bool isScrollControlled = true,
}) {
  return AppBottomSheet.show<T>(
    context,
    builder: builder,
    isScrollControlled: isScrollControlled,
  );
}
