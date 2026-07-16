import 'package:flutter/material.dart';

/// Literal marketing colours for the welcome/landing page — mirrors
/// `thamkhao/deutschtiger-frontend/src/components/landing/welcome/*.tsx`
/// literal hex values (not CSS variables). The web welcome page hardcodes
/// its own light-only palette independent of `:root`/`.dark` tokens, so this
/// screen intentionally does NOT read `context.tokens` (that extension is
/// for theme-following app surfaces — see `app_tokens.dart` doc comment).
class WelPalette {
  const WelPalette._();

  static const ink = Color(0xFF14110D);
  static const inkMuted65 = Color(0xA614110D); // rgba(20,17,13,.65)
  static const inkMuted55 = Color(0x8C14110D); // rgba(20,17,13,.55)
  static const inkMuted60 = Color(0x9914110D);
  static const bgTop = Color(0xFFFFF7EC);
  static const bgBottom = Color(0xFFFFFBF5);
  static const cardBorder = Color(0x0D000000);

  static const orange400 = Color(0xFFFB923C);
  static const orange500 = Color(0xFFF97316);
  static const orange600 = Color(0xFFEA580C);
  static const orange700 = Color(0xFF9A3412);
  static const orangeChip = Color(0xFFFFEDD5);

  static const pink500 = Color(0xFFEC4899);
  static const green700 = Color(0xFF15803D);
  static const green600 = Color(0xFF16A34A);
  static const green500 = Color(0xFF10B981);
  static const amber400 = Color(0xFFFBBF24);
  static const amber500 = Color(0xFFF59E0B);
  static const sky600 = Color(0xFF2563EB);
  static const violet600 = Color(0xFF7C3AED);
  static const rose600 = Color(0xFFDB2777);
  static const cyan600 = Color(0xFF0284C7);
  static const red600 = Color(0xFFDC2626);
  static const purple600 = Color(0xFF9333EA);

  static const Gradient ctaGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [orange400, orange500],
  );

  static const pageGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [bgTop, bgBottom],
  );

  /// Display headline font — "Grandstander" bundled per plan brief.
  static const displayFont = 'Grandstander';

  /// Brand wordmark font — "Fredoka One" bundled per plan brief.
  static const brandFont = 'Fredoka One';
}
