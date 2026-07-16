import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:deutschtiger/widgets/common/tiger_logo.dart';
import '../../../l10n/app_localizations.dart';
import 'welcome_palette.dart';

/// Auth entry modal — web opens a full login/signup form inline
/// (`welcome-auth-modal.tsx`) over the landing page. The native
/// [LoginScreen]/[SignupScreen] are full-page `Scaffold`s owned by another
/// phase (not reusable as embeddable widgets without refactoring them,
/// which is out of this phase's file ownership); this modal instead offers
/// the same two entry points and routes to those screens, keeping "auth
/// over the landing page" behaviour without duplicating the form logic.
Future<void> showWelcomeAuthModal(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) => const _WelcomeAuthModalContent(),
  );
}

class _WelcomeAuthModalContent extends StatelessWidget {
  const _WelcomeAuthModalContent();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 28, 24, 24 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const TigerLogo(width: 100),
          const SizedBox(height: 16),
          const Text(
            'Chào mừng đến với DeutschTiger',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: WelPalette.ink),
          ),
          const SizedBox(height: 6),
          const Text(
            'Học tiếng Đức như chơi game — miễn phí trọn đời cho A1–B1.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: WelPalette.inkMuted60),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: WelPalette.ctaGradient, borderRadius: BorderRadius.circular(14)),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push('/login');
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(l10n.logIn, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                side: const BorderSide(color: WelPalette.cardBorder),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                context.push('/signup');
              },
              child: Text(l10n.signUp, style: const TextStyle(color: WelPalette.ink, fontWeight: FontWeight.w700, fontSize: 15)),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.push('/onboarding');
            },
            child: const Text(
              'Xem giới thiệu app trước',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: WelPalette.inkMuted60),
            ),
          ),
        ],
      ),
    );
  }
}
