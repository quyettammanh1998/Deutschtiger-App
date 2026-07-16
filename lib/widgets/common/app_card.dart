import 'package:flutter/material.dart';

import '../../core/theme/app_tokens.dart';

/// Web parity: `.card` / `.card-sm` / `.card-interactive` CSS utilities in
/// `thamkhao/deutschtiger-frontend/src/index.css`.
///
/// Reads colors exclusively from `context.tokens` (never the deprecated
/// `DesignTokens`/`AppColors` statics) so it renders correctly in both
/// light and dark themes.
enum AppCardVariant {
  /// `.card` — radius 16, LIGHT = transparent border + soft double shadow;
  /// DARK = visible `--border` outline + single shadow (shadows read poorly
  /// on dark surfaces so the web CSS swaps to a border instead).
  card,

  /// `.card-sm` — radius 12, ALWAYS has a visible border (light + dark),
  /// lighter single shadow.
  cardSm,

  /// `.card-interactive` — radius 16, same base shadow as [card] but meant
  /// for tappable rows/tiles; on dark it also gets the visible border like
  /// [card] (`.dark .card-interactive` in the web CSS). Provide [onTap] to
  /// get the press/hover-style lift affordance (web: `:hover`/`:active`
  /// translateY + shadow swap — approximated here with `InkWell` ripple +
  /// an animated elevation shadow).
  interactive,
}

class AppCard extends StatefulWidget {
  const AppCard({
    super.key,
    required this.child,
    this.variant = AppCardVariant.card,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.margin,
  });

  /// `.card` shape — see [AppCardVariant.card].
  const AppCard.card({
    Key? key,
    required Widget child,
    VoidCallback? onTap,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
    EdgeInsetsGeometry? margin,
  }) : this(
         key: key,
         variant: AppCardVariant.card,
         onTap: onTap,
         padding: padding,
         margin: margin,
         child: child,
       );

  /// `.card-sm` shape — see [AppCardVariant.cardSm].
  const AppCard.small({
    Key? key,
    required Widget child,
    VoidCallback? onTap,
    EdgeInsetsGeometry padding = const EdgeInsets.all(12),
    EdgeInsetsGeometry? margin,
  }) : this(
         key: key,
         variant: AppCardVariant.cardSm,
         onTap: onTap,
         padding: padding,
         margin: margin,
         child: child,
       );

  /// `.card-interactive` shape — see [AppCardVariant.interactive].
  const AppCard.interactive({
    Key? key,
    required Widget child,
    required VoidCallback onTap,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
    EdgeInsetsGeometry? margin,
  }) : this(
         key: key,
         variant: AppCardVariant.interactive,
         onTap: onTap,
         padding: padding,
         margin: margin,
         child: child,
       );

  final Widget child;
  final AppCardVariant variant;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _pressed = false;

  double get _radius => switch (widget.variant) {
    AppCardVariant.cardSm => 12,
    AppCardVariant.card || AppCardVariant.interactive => 16,
  };

  List<BoxShadow> _shadow(bool isDark) {
    switch (widget.variant) {
      case AppCardVariant.cardSm:
        return [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ];
      case AppCardVariant.card:
        return isDark
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ];
      case AppCardVariant.interactive:
        // Base shadow `0 1px 3px .06`; pressed = the `:active` state
        // (`0 1px 2px .04`, no lift) since Flutter has no hover.
        final alpha = _pressed ? 0.04 : 0.06;
        final blur = _pressed ? 2.0 : 3.0;
        return [
          BoxShadow(
            color: Colors.black.withValues(alpha: alpha),
            blurRadius: blur,
            offset: const Offset(0, 1),
          ),
        ];
    }
  }

  Color _borderColor(AppTokens tokens, bool isDark) {
    switch (widget.variant) {
      case AppCardVariant.cardSm:
        return tokens.border;
      case AppCardVariant.card:
      case AppCardVariant.interactive:
        return isDark ? tokens.border : Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = BorderRadius.circular(_radius);

    final decorated = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      margin: widget.margin,
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: radius,
        border: Border.all(color: _borderColor(tokens, isDark)),
        boxShadow: _shadow(isDark),
      ),
      child: Padding(padding: widget.padding, child: widget.child),
    );

    if (widget.onTap == null) return decorated;

    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: widget.onTap,
        onHighlightChanged: (v) => setState(() => _pressed = v),
        child: decorated,
      ),
    );
  }
}
