import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../widgets/common/tiger_logo.dart';

/// Web parity: `de-thi-site-header.tsx` — sticky branding header for the
/// public `/de-thi` subdomain shell (logo left, "Đăng nhập" CTA right).
class DeThiSiteHeader extends StatelessWidget {
  const DeThiSiteHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: tokens.card.withValues(alpha: 0.9),
        border: Border(bottom: BorderSide(color: tokens.border)),
      ),
      child: Row(
        children: [
          const TigerIcon(size: 32),
          const SizedBox(width: 8),
          Text.rich(
            TextSpan(
              text: 'Deutsch',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: tokens.foreground,
              ),
              children: [
                TextSpan(
                  text: 'Tiger',
                  style: TextStyle(color: tokens.primary),
                ),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => context.push('/login'),
            child: Text(
              'Đăng nhập',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: tokens.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
