import 'package:flutter/material.dart';

import 'package:deutschtiger/core/icons/app_phosphor_icons.dart';

import '../../../data/practice/practice_result.dart';
import '../../../l10n/app_localizations.dart';

/// Visual config for one mode card in the 2-col gradient grid — web parity:
/// `FlashcardModeSelector` `MODE_CONFIGS` (`practice-page.tsx`).
///
/// [mode] is non-null only for the 4 round types this app has actually built
/// (cloze/listening/matching/writing — the P4 practice-view contract); the
/// other 7 web modes (sentence/runner/fade/dictation/chaining/gist/speaking)
/// render as disabled "Sắp ra mắt" tiles instead of new game engines (YAGNI —
/// see phase-04d report for the scoping note). Web's `listening` (MCQ) and
/// `flashcards` (flip-card) are both surfaced by this app's single
/// `PracticeMode.listening` flip-card view (established by the earlier P4
/// pass, which already titles it "Luyện nghe" everywhere) — shown once here
/// instead of as two near-duplicate cards.
class PracticeModeCardConfig {
  const PracticeModeCardConfig({
    required this.mode,
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
  });

  final PracticeMode? mode;
  final IconData icon;
  final String title;
  final String description;
  final List<Color> gradient;

  bool get enabled => mode != null;
}

List<PracticeModeCardConfig> buildPracticeModeCards(AppLocalizations l10n) => [
  PracticeModeCardConfig(
    mode: PracticeMode.writing,
    icon: AppPhosphorIcons.pencilLine,
    title: l10n.practiceModeWriting,
    description: l10n.practiceModeWritingDesc,
    gradient: const [Color(0xFFA855F7), Color(0xFF7C3AED)],
  ),
  PracticeModeCardConfig(
    mode: null,
    icon: AppPhosphorIcons.textAlignLeft,
    title: l10n.practiceModeSentence,
    description: l10n.practiceModeSentenceDesc,
    gradient: const [Color(0xFF3B82F6), Color(0xFF4F46E5)],
  ),
  PracticeModeCardConfig(
    mode: PracticeMode.cloze,
    icon: AppPhosphorIcons.puzzlePiece,
    title: l10n.practiceModeCloze,
    description: l10n.practiceModeClozeDesc,
    gradient: const [Color(0xFF14B8A6), Color(0xFF0891B2)],
  ),
  PracticeModeCardConfig(
    mode: PracticeMode.listening,
    icon: AppPhosphorIcons.cards,
    title: l10n.practiceModeListening,
    description: l10n.practiceModeListeningDesc,
    gradient: const [Color(0xFFF97316), Color(0xFFD97706)],
  ),
  PracticeModeCardConfig(
    mode: PracticeMode.matching,
    icon: AppPhosphorIcons.link,
    title: l10n.practiceModeMatching,
    description: l10n.practiceModeMatchingDesc,
    gradient: const [Color(0xFFEC4899), Color(0xFFE11D48)],
  ),
  PracticeModeCardConfig(
    mode: null,
    icon: AppPhosphorIcons.gameController,
    title: l10n.practiceModeRunner,
    description: l10n.practiceModeRunnerDesc,
    gradient: const [Color(0xFF22C55E), Color(0xFF059669)],
  ),
  PracticeModeCardConfig(
    mode: null,
    icon: AppPhosphorIcons.eyeSlash,
    title: l10n.practiceModeFade,
    description: l10n.practiceModeFadeDesc,
    gradient: const [Color(0xFFF59E0B), Color(0xFFCA8A04)],
  ),
  PracticeModeCardConfig(
    mode: null,
    icon: AppPhosphorIcons.keyboard,
    title: l10n.practiceModeDictation,
    description: l10n.practiceModeDictationDesc,
    gradient: const [Color(0xFF0EA5E9), Color(0xFF0891B2)],
  ),
  PracticeModeCardConfig(
    mode: null,
    icon: AppPhosphorIcons.listBullets,
    title: l10n.practiceModeChaining,
    description: l10n.practiceModeChainingDesc,
    gradient: const [Color(0xFFD946EF), Color(0xFFDB2777)],
  ),
  PracticeModeCardConfig(
    mode: null,
    icon: AppPhosphorIcons.lightbulb,
    title: l10n.practiceModeGist,
    description: l10n.practiceModeGistDesc,
    gradient: const [Color(0xFF6366F1), Color(0xFF7C3AED)],
  ),
  PracticeModeCardConfig(
    mode: null,
    icon: AppPhosphorIcons.microphoneStage,
    title: l10n.practiceModeSpeaking,
    description: l10n.practiceModeSpeakingDesc,
    gradient: const [Color(0xFFF43F5E), Color(0xFFDC2626)],
  ),
];
