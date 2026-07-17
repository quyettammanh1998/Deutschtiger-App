import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';

/// Card bao form auth — bám web (`login-page.tsx`/`signup-page.tsx`):
/// light = nền trắng + border cam nhạt (orange-100, fixed brand accent),
/// dark = `dark:bg-card dark:border-border` (theme tokens). Bo góc 2xl
/// (16px), shadow nhẹ, max-width ~360.
class AuthCard extends StatelessWidget {
  const AuthCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tokens = context.tokens;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? tokens.card : Colors.white,
          borderRadius: BorderRadius.circular(16),
          // Light keeps the web's warm orange-100 border (brand accent,
          // fixed); dark follows the theme border token.
          border: Border.all(
            color: isDark ? tokens.border : AppColors.orange100,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
