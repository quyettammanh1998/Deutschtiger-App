import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_tokens.dart';
import '../../data/exam/exam_ecosystem_models.dart';
import '../../l10n/app_localizations.dart';
import '../../view_models/exam/exam_ecosystem_providers.dart';
import '../../widgets/common/async_state_views.dart';
import 'widgets/dictation/cloze_practice_view.dart';
import 'widgets/dictation/dictation_activity_menu.dart';
import 'widgets/dictation/full_practice_view.dart';
import 'widgets/dictation/karaoke_view.dart';
import 'widgets/dictation/word_selection_panel.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

enum _ClozePhase { prep, practice }

/// Luyện từ vựng qua audio đề thi — web parity rebuild of
/// `exam-dictation-page.tsx`: 3-activity menu (điền từ / chép chính tả /
/// nghe & đọc theo), reusing [ExamAudioPlayer]'s sibling `just_audio`
/// dependency directly (word-timed auto-pause needs raw player control the
/// simpler `ExamAudioPlayer` widget doesn't expose).
///
/// GAP: no SRS/FSRS push after a session (web calls
/// `srsService.recordPractice`) — the Flutter app has no equivalent
/// endpoint/service wired yet.
class ExamDictationScreen extends ConsumerStatefulWidget {
  const ExamDictationScreen({
    super.key,
    required this.provider,
    required this.level,
    required this.slug,
  });

  final String provider;
  final String level;
  final String slug;

  @override
  ConsumerState<ExamDictationScreen> createState() =>
      _ExamDictationScreenState();
}

class _ExamDictationScreenState extends ConsumerState<ExamDictationScreen> {
  DictationActivity _activity = DictationActivity.menu;
  _ClozePhase _clozePhase = _ClozePhase.prep;
  final Set<String> _selectedWords = {};

  void _handleBack() {
    if (_activity != DictationActivity.menu) {
      setState(() {
        _activity = DictationActivity.menu;
        _clozePhase = _ClozePhase.prep;
      });
    } else {
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final target = ExamDictationTarget(
      provider: widget.provider,
      level: widget.level,
      slug: widget.slug,
    );
    final transcript = ref.watch(examWordTranscriptProvider(target));

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        title: Text(l10n.examDictationTitle),
        leading: IconButton(
          icon: const Icon(PhosphorIcons.arrowLeft),
          onPressed: _handleBack,
        ),
      ),
      body: transcript.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          message: l10n.examDictationNotFound,
          onRetry: () => ref.invalidate(examWordTranscriptProvider(target)),
        ),
        data: (data) {
          if (data.words.isEmpty) {
            return Center(
              child: Text(
                l10n.examDictationNoWords,
                style: TextStyle(color: tokens.mutedForeground),
              ),
            );
          }
          return _buildActivity(data);
        },
      ),
    );
  }

  Widget _buildActivity(ExamWordTranscript data) {
    switch (_activity) {
      case DictationActivity.menu:
        return DictationActivityMenu(
          onSelect: (a) => setState(() {
            _activity = a;
            _clozePhase = _ClozePhase.prep;
          }),
        );
      case DictationActivity.cloze:
        if (_clozePhase == _ClozePhase.prep) {
          return WordSelectionPanel(
            audios: data.audios,
            words: data.words,
            selected: _selectedWords,
            onStart: () => setState(() => _clozePhase = _ClozePhase.practice),
          );
        }
        return ClozePracticeView(
          audios: data.audios,
          selectedWords: _selectedWords,
          onBack: () => setState(() => _clozePhase = _ClozePhase.prep),
        );
      case DictationActivity.fullDictation:
        return FullPracticeView(
          audios: data.audios,
          onBack: () => setState(() => _activity = DictationActivity.menu),
        );
      case DictationActivity.karaoke:
        return KaraokeView(
          audios: data.audios,
          onBack: () => setState(() => _activity = DictationActivity.menu),
        );
    }
  }
}
