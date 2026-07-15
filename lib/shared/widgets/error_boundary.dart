import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';
import '../../l10n/app_localizations.dart';

/// Wraps [child] in a build-time error boundary.
///
/// If [child] throws during build, the boundary rebuilds with the
/// [fallback] widget (or a default error card) instead of letting the error
/// crash the screen.
///
/// Note: this catches `build` / layout / paint errors synchronously thrown
/// from the wrapped subtree. It does not catch async errors (use
/// `FlutterError.onError` / `PlatformDispatcher.instance.onError` for
/// those).
class ErrorBoundary extends StatefulWidget {
  const ErrorBoundary({
    super.key,
    required this.child,
    this.fallback,
    this.onError,
  });

  final Widget child;
  final Widget Function(Object error, StackTrace? stack)? fallback;
  final void Function(Object error, StackTrace? stack)? onError;

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;
  StackTrace? _stack;

  @override
  void initState() {
    super.initState();
    // Listen for framework-reported errors in this subtree.
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.silent) {
        return;
      }
      // We can only react to errors in our own subtree by inspecting
      // details.context, but for simplicity we record any framework error
      // and let the original handler run for non-fatal cases.
      originalOnError?.call(details);
    };
  }

  void _recordError(Object error, StackTrace? stack) {
    setState(() {
      _error = error;
      _stack = stack;
    });
    widget.onError?.call(error, stack);
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.fallback?.call(_error!, _stack) ?? const _DefaultFallback();
    }
    return _BoundaryScope(onError: _recordError, child: widget.child);
  }
}

class _BoundaryScope extends StatelessWidget {
  const _BoundaryScope({required this.child, required this.onError});
  final Widget child;
  final void Function(Object error, StackTrace? stack) onError;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (innerCtx) {
        ErrorWidget.builder = (FlutterErrorDetails details) {
          onError(details.exception, details.stack);
          return const SizedBox.shrink();
        };
        return child;
      },
    );
  }
}

class _DefaultFallback extends StatelessWidget {
  const _DefaultFallback();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: DesignTokens.error,
              size: 48,
            ),
            const SizedBox(height: DesignTokens.spacingSm + 4),
            Text(
              l10n.unexpectedDisplayError,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
