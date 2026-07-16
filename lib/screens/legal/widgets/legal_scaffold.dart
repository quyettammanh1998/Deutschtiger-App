import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../widgets/common/tiger_logo.dart';

/// Shared shell for legal pages (privacy policy / terms of service) —
/// mirrors web `legal/privacy-policy-page.tsx` /
/// `legal/terms-of-service-page.tsx`: sticky brand header linking to
/// `/welcome`, scrollable body, bottom back-to-home divider.
class LegalScaffold extends StatelessWidget {
  const LegalScaffold({
    super.key,
    required this.title,
    required this.dateLabel,
    required this.sections,
  });

  /// H1 shown in the body (NOT the header — the header only shows the
  /// brand wordmark, matching web).
  final String title;

  /// Fixed literal date string, e.g. "Tháng 3, 2026" — never `DateTime.now()`.
  final String dateLabel;

  final List<Widget> sections;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: Column(
          children: [
            _Header(tokens: tokens),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: tokens.foreground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Cập nhật lần cuối: $dateLabel',
                      style: TextStyle(
                        fontSize: 13,
                        color: tokens.mutedForeground,
                      ),
                    ),
                    const SizedBox(height: 32),
                    for (int i = 0; i < sections.length; i++) ...[
                      if (i > 0) const SizedBox(height: 24),
                      sections[i],
                    ],
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.only(top: 24),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: tokens.border),
                        ),
                      ),
                      child: _BackHomeButton(tokens: tokens),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.tokens});

  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: tokens.card.withValues(alpha: 0.9),
        border: Border(bottom: BorderSide(color: tokens.border)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: GestureDetector(
        onTap: () => context.go('/welcome'),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TigerIcon(size: 28),
            const SizedBox(width: 8),
            Text(
              'Deutsch Tiger',
              style: TextStyle(
                fontFamily: 'Grandstander',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: tokens.foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackHomeButton extends StatelessWidget {
  const _BackHomeButton({required this.tokens});

  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () => context.go('/welcome'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: tokens.muted,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chevron_left, size: 18, color: tokens.mutedForeground),
            const SizedBox(width: 4),
            Text(
              'Về trang chủ',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: tokens.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
