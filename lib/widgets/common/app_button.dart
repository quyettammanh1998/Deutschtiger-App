import 'package:flutter/material.dart';

import '../../core/theme/app_tokens.dart';

/// Web parity: `src/components/ui/button.tsx` `<Button>` — h-10 (40px),
/// `rounded-lg` (radius 8), `px-4`, `font-medium`. Variants: default (solid
/// primary), ghost (transparent, accent on hover), outline (bordered,
/// transparent bg).
///
/// NOT the same shape as [AppGradientButton] (`.btn-primary`/`.btn-secondary`
/// CSS utilities — 16px radius, gradient/muted fill). Use this widget for
/// web call sites using `<Button>`; use [AppGradientButton] for call sites
/// using the `.btn-*` CSS classes.
enum AppButtonVariant { primary, ghost, outline }

enum AppButtonSize {
  /// `size=default` — h-10 (40px), px-4.
  regular,

  /// `size=sm` — h-9 (36px), px-3.
  small,

  /// `size=icon` — 40x40, no label (pass an icon-only [child] via
  /// [AppButton.icon]).
  icon,
}

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.regular,
    this.leading,
    this.loading = false,
  });

  /// Icon-only 40x40 button (web `size="icon"`).
  const AppButton.icon({
    super.key,
    required Widget icon,
    required this.onPressed,
    this.variant = AppButtonVariant.ghost,
  }) : label = '',
       leading = icon,
       size = AppButtonSize.icon,
       loading = false;

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final Widget? leading;
  final bool loading;

  double get _height => size == AppButtonSize.small ? 36 : 40;

  EdgeInsetsGeometry get _padding => switch (size) {
    AppButtonSize.icon => EdgeInsets.zero,
    AppButtonSize.small => const EdgeInsets.symmetric(horizontal: 12),
    AppButtonSize.regular => const EdgeInsets.symmetric(horizontal: 16),
  };

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final enabled = onPressed != null && !loading;
    final radius = BorderRadius.circular(8);

    final Color background;
    final Color foreground;
    final Border? border;
    switch (variant) {
      case AppButtonVariant.primary:
        background = tokens.primary;
        foreground = tokens.primaryForeground;
        border = null;
      case AppButtonVariant.ghost:
        background = Colors.transparent;
        foreground = tokens.foreground;
        border = null;
      case AppButtonVariant.outline:
        background = tokens.background;
        foreground = tokens.foreground;
        border = Border.all(color: tokens.input);
    }

    final width = size == AppButtonSize.icon ? _height : null;

    final content = loading
        ? SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: foreground,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leading != null) ...[
                IconTheme(
                  data: IconThemeData(color: foreground, size: 18),
                  child: leading!,
                ),
                if (label.isNotEmpty) const SizedBox(width: 8),
              ],
              if (label.isNotEmpty)
                Text(
                  label,
                  style: TextStyle(
                    color: foreground,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
            ],
          );

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Material(
        color: background,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: border?.top ?? BorderSide.none,
        ),
        child: InkWell(
          borderRadius: radius,
          onTap: enabled ? onPressed : null,
          child: Container(
            height: _height,
            width: width,
            padding: _padding,
            alignment: Alignment.center,
            child: content,
          ),
        ),
      ),
    );
  }
}

/// Web parity: `.btn-primary` / `.btn-secondary` CSS utilities in
/// `index.css` — gradient/muted fill, radius `var(--radius)` (16), used for
/// prominent full-width CTAs (distinct from the 40px [AppButton] shape).
///
/// Supersedes ad-hoc gradient buttons for NEW call sites. Does NOT replace
/// `lib/widgets/common/gradient_button.dart` (auth screens keep using that
/// one — separate phase owns auth).
enum AppGradientButtonVariant {
  /// `.btn-primary` — gradient `primary -> color-mix(primary 75%, black)`,
  /// white/`--primary-foreground` text, font-weight 600.
  primary,

  /// `.btn-secondary` — solid `--muted` background, `--foreground` text,
  /// font-weight 500.
  secondary,
}

class AppGradientButton extends StatelessWidget {
  const AppGradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppGradientButtonVariant.primary,
    this.loading = false,
    this.height = 48,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppGradientButtonVariant variant;
  final bool loading;
  final double height;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final enabled = onPressed != null && !loading;
    final radius = BorderRadius.circular(tokens.radius);

    final Decoration decoration;
    final Color foreground;
    switch (variant) {
      case AppGradientButtonVariant.primary:
        // `color-mix(in srgb, primary 75%, #000)` approximated with
        // Color.lerp(primary, black, 0.25).
        final darkened = Color.lerp(tokens.primary, Colors.black, 0.25)!;
        decoration = BoxDecoration(
          gradient: LinearGradient(
            colors: [tokens.primary, darkened],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: radius,
        );
        foreground = tokens.primaryForeground;
      case AppGradientButtonVariant.secondary:
        decoration = BoxDecoration(color: tokens.muted, borderRadius: radius);
        foreground = tokens.foreground;
    }

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: DecoratedBox(
        decoration: decoration,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: radius,
            onTap: enabled ? onPressed : null,
            child: Container(
              height: height,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: loading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: foreground,
                      ),
                    )
                  : Text(
                      label,
                      style: TextStyle(
                        color: foreground,
                        fontSize: 15,
                        fontWeight: variant == AppGradientButtonVariant.primary
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
