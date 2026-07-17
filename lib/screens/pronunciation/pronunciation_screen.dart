import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/pronunciation_trainer_header.dart';

/// Pronunciation hub — web parity:
/// `thamkhao/deutschtiger-frontend/src/pages/pronunciation/pronunciation-hub-page.tsx`.
/// Back → `/games` (matches web's `ROUTE_PATHS.games`); blue info banner;
/// 4-module grid (1-col mobile) linking to the umlaute/ich-ach/r-sound/sp-st
/// trainers. Minimal-pairs is intentionally NOT linked here — same as web.
class PronunciationScreen extends StatelessWidget {
  const PronunciationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PronunciationTrainerHeader(
                title: l10n.pronunciationHubTitle,
                onBack: () => context.go('/games'),
              ),
              const SizedBox(height: 24),
              Builder(
                builder: (context) {
                  final isDark =
                      Theme.of(context).brightness == Brightness.dark;
                  // Info banner: keep the pale-blue tint in light mode; in dark
                  // mode use a translucent blue surface with light blue text so
                  // it reads against the dark background.
                  final bannerBackground = isDark
                      ? const Color(0x333B82F6)
                      : const Color(0xFFEFF6FF);
                  final bannerTextColor = isDark
                      ? const Color(0xFF93C5FD)
                      : const Color(0xFF1E3A8A);
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: bannerBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      l10n.pronunciationHubInfoBanner,
                      style: TextStyle(
                        color: bannerTextColor,
                        fontSize: 13.5,
                        height: 1.5,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              _ModuleCard(
                title: l10n.pronunciationHubUmlauteTitle,
                description: l10n.pronunciationHubUmlauteDesc,
                emoji: '🔤',
                gradient: const [Color(0xFF8B5CF6), Color(0xFF9333EA)],
                onTap: () => context.go('/pronunciation/umlaute'),
              ),
              const SizedBox(height: 12),
              _ModuleCard(
                title: l10n.pronunciationHubIchAchTitle,
                description: l10n.pronunciationHubIchAchDesc,
                emoji: '🗣️',
                gradient: const [Color(0xFF3B82F6), Color(0xFF0891B2)],
                onTap: () => context.go('/pronunciation/ich-ach-laut'),
              ),
              const SizedBox(height: 12),
              _ModuleCard(
                title: l10n.pronunciationHubRSoundTitle,
                description: l10n.pronunciationHubRSoundDesc,
                emoji: '🌀',
                gradient: const [Color(0xFF10B981), Color(0xFF0D9488)],
                onTap: () => context.go('/pronunciation/r-sound'),
              ),
              const SizedBox(height: 12),
              _ModuleCard(
                title: l10n.pronunciationHubSpStTitle,
                description: l10n.pronunciationHubSpStDesc,
                emoji: '💬',
                gradient: const [Color(0xFFF59E0B), Color(0xFFEA580C)],
                onTap: () => context.go('/pronunciation/sp-st'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.title,
    required this.description,
    required this.emoji,
    required this.gradient,
    required this.onTap,
  });

  final String title;
  final String description;
  final String emoji;
  final List<Color> gradient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Material(
      color: tokens.card,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: tokens.border),
          ),
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradient),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 26)),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: tokens.foreground,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: tokens.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
