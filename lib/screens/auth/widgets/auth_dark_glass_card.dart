import 'package:flutter/material.dart';

import 'particle_words_canvas.dart';

/// Dark particle-glass shell shared by forgot/reset password — these pages
/// are deliberately DARK REGARDLESS of app theme (mirrors web
/// `forgot-password-page.tsx`/`reset-password-page.tsx`: bg `#050118` +
/// `ParticleWordsCanvas`, glass card `rounded-2xl border-white/10
/// bg-black/15`). Literal web hex values are hardcoded here on purpose —
/// this is NOT a `context.tokens` surface.
class AuthDarkGlassCard extends StatelessWidget {
  const AuthDarkGlassCard({super.key, required this.child});

  final Widget child;

  static const bgColor = Color(0xFF050118);
  static const cardBorder = Color(0x1AFFFFFF); // border-white/10
  static const cardFill = Color(0x26000000); // bg-black/15

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned.fill(child: ParticleWordsCanvas()),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardFill,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: cardBorder),
                      boxShadow: const [
                        BoxShadow(color: Color(0x80000000), blurRadius: 60, spreadRadius: 4),
                      ],
                    ),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
