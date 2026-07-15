import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../data/exam/exam_ecosystem_models.dart';
import '../../features/exam/presentation/widgets/exam_audio_player.dart';
import '../../l10n/app_localizations.dart';
import '../../view_models/exam/exam_ecosystem_providers.dart';
import '../../widgets/common/async_state_views.dart';

/// Luyện nghe chép chính tả (cloze dictation) từ audio đề thi — tái dùng
/// [ExamAudioPlayer] của exam player core, KHÔNG sửa `lib/features/exam/`.
/// Chấm client-side: so khớp text đã gõ với từ gốc (chuẩn hoá lowercase,
/// bỏ dấu câu) — backend không có endpoint chấm riêng cho dictation, chỉ
/// serve transcript thô (`exam_dictation_handler.go`).
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
  static const _maxPreselect = 12;

  final Map<String, TextEditingController> _controllers = {};
  final Map<String, bool?> _results = {}; // null = chưa chấm
  Set<String>? _selectedWords; // clean word keys, null = chưa init

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final target = ExamDictationTarget(
      provider: widget.provider,
      level: widget.level,
      slug: widget.slug,
    );
    final transcript = ref.watch(examWordTranscriptProvider(target));

    return Scaffold(
      backgroundColor: DesignTokens.background,
      appBar: AppBar(title: Text(l10n.examDictationTitle)),
      body: transcript.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          message: l10n.examDictationNotFound,
          onRetry: () => ref.invalidate(examWordTranscriptProvider(target)),
        ),
        data: (data) {
          _selectedWords ??= data.words
              .take(_maxPreselect)
              .map((w) => w.clean)
              .toSet();
          if (data.words.isEmpty || _selectedWords!.isEmpty) {
            return Center(
              child: Text(
                l10n.examDictationNoWords,
                style: const TextStyle(color: DesignTokens.mutedForeground),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(
              DesignTokens.screenHorizontalPadding,
            ),
            children: [
              for (final audio in data.audios)
                if (_hasSelectedWord(audio))
                  _AudioDictationBlock(
                    audio: audio,
                    selectedWords: _selectedWords!,
                    controllerFor: _controllerFor,
                    resultFor: (key) => _results[key],
                    onCheck: (key, expected) => setState(() {
                      final typed = _controllers[key]?.text ?? '';
                      _results[key] = _normalize(typed) == _normalize(expected);
                    }),
                  ),
            ],
          );
        },
      ),
    );
  }

  bool _hasSelectedWord(ExamDictationAudio audio) => audio.sentences.any(
    (s) => s.words.any((w) => _selectedWords!.contains(w.clean)),
  );

  TextEditingController _controllerFor(String key) =>
      _controllers.putIfAbsent(key, TextEditingController.new);

  static String _normalize(String s) =>
      s.trim().toLowerCase().replaceAll(RegExp(r'[.,!?;:]$'), '');
}

class _AudioDictationBlock extends StatelessWidget {
  const _AudioDictationBlock({
    required this.audio,
    required this.selectedWords,
    required this.controllerFor,
    required this.resultFor,
    required this.onCheck,
  });

  final ExamDictationAudio audio;
  final Set<String> selectedWords;
  final TextEditingController Function(String key) controllerFor;
  final bool? Function(String key) resultFor;
  final void Function(String key, String expected) onCheck;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (audio.teil.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: DesignTokens.spacingSm),
              child: Text(
                audio.teil,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          if (audio.audioUrl.isNotEmpty)
            ExamAudioPlayer(
              audioUrl: audio.audioUrl,
              playsUsed: 0,
              maxPlays: 0,
              onPlayConsumed: () {},
            ),
          const SizedBox(height: DesignTokens.spacingSm),
          for (var si = 0; si < audio.sentences.length; si++)
            if (audio.sentences[si].words.any(
              (w) => selectedWords.contains(w.clean),
            ))
              _SentenceCloze(
                sentenceKeyPrefix: '${audio.file}-$si',
                sentence: audio.sentences[si],
                selectedWords: selectedWords,
                controllerFor: controllerFor,
                resultFor: resultFor,
                onCheck: onCheck,
              ),
        ],
      ),
    );
  }
}

class _SentenceCloze extends StatelessWidget {
  const _SentenceCloze({
    required this.sentenceKeyPrefix,
    required this.sentence,
    required this.selectedWords,
    required this.controllerFor,
    required this.resultFor,
    required this.onCheck,
  });

  final String sentenceKeyPrefix;
  final ExamDictationSentence sentence;
  final Set<String> selectedWords;
  final TextEditingController Function(String key) controllerFor;
  final bool? Function(String key) resultFor;
  final void Function(String key, String expected) onCheck;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingSm),
      padding: const EdgeInsets.all(DesignTokens.cardPadding),
      decoration: BoxDecoration(
        color: DesignTokens.card,
        borderRadius: BorderRadius.circular(DesignTokens.radius),
        border: Border.all(color: DesignTokens.border),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 6,
        runSpacing: 8,
        children: [
          for (var wi = 0; wi < sentence.words.length; wi++)
            if (selectedWords.contains(sentence.words[wi].clean))
              _BlankField(
                fieldKey: '$sentenceKeyPrefix-$wi',
                expected: sentence.words[wi].word,
                controller: controllerFor('$sentenceKeyPrefix-$wi'),
                result: resultFor('$sentenceKeyPrefix-$wi'),
                onCheck: () =>
                    onCheck('$sentenceKeyPrefix-$wi', sentence.words[wi].word),
                checkLabel: l10n.examDictationCheck,
              )
            else
              Text(sentence.words[wi].word),
        ],
      ),
    );
  }
}

class _BlankField extends StatelessWidget {
  const _BlankField({
    required this.fieldKey,
    required this.expected,
    required this.controller,
    required this.result,
    required this.onCheck,
    required this.checkLabel,
  });

  final String fieldKey;
  final String expected;
  final TextEditingController controller;
  final bool? result;
  final VoidCallback onCheck;
  final String checkLabel;

  @override
  Widget build(BuildContext context) {
    final borderColor = result == null
        ? DesignTokens.border
        : (result! ? DesignTokens.success : DesignTokens.destructive);
    return SizedBox(
      width: 140,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 90,
            child: TextField(
              key: Key('dictation-field-$fieldKey'),
              controller: controller,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 6,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: borderColor),
                ),
              ),
              onSubmitted: (_) => onCheck(),
            ),
          ),
          IconButton(
            key: Key('dictation-check-$fieldKey'),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            icon: Icon(
              result == true ? Icons.check_circle : Icons.check_circle_outline,
              size: 18,
              color: result == true ? DesignTokens.success : null,
            ),
            onPressed: onCheck,
            tooltip: checkLabel,
          ),
        ],
      ),
    );
  }
}
