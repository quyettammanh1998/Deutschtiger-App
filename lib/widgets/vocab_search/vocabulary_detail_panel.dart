import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Chi tiết từ vựng - sync từ web vocabulary-item-detail.tsx
class VocabularyDetailPanel extends StatelessWidget {
  const VocabularyDetailPanel({
    super.key,
    required this.word,
    required this.translation,
    this.pronunciation,
    this.example,
    this.exampleTranslation,
    this.cefrLevel,
    this.wordType,
    this.gender,
    this.plural,
    this.tags,
    this.onSpeakTap,
    this.onSaveToFlashcard,
    this.isSaving = false,
    this.isSaved = false,
  });

  final String word;
  final String translation;
  final String? pronunciation;
  final String? example;
  final String? exampleTranslation;
  final String? cefrLevel;
  final String? wordType;
  final String? gender;
  final String? plural;
  final List<String>? tags;
  final VoidCallback? onSpeakTap;
  final VoidCallback? onSaveToFlashcard;
  final bool isSaving;
  final bool isSaved;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Word heading
          _WordHeading(
            word: word,
            pronunciation: pronunciation,
            cefrLevel: cefrLevel,
            wordType: wordType,
            onSpeakTap: onSpeakTap,
          ),

          const SizedBox(height: 12),

          // Word type, gender, plural badges
          if (wordType != null || gender != null || plural != null) ...[
            _WordMetaBadges(
              wordType: wordType,
              gender: gender,
              plural: plural,
            ),
            const SizedBox(height: 12),
          ],

          // Vietnamese meaning
          _MeaningSection(translation: translation),

          // Examples
          if (example != null && example!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _ExamplesSection(
              example: example!,
              translation: exampleTranslation,
              onSpeakTap: onSpeakTap,
            ),
          ],

          // Tags
          if (tags != null && tags!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _TagsSection(tags: tags!),
          ],

          const SizedBox(height: 16),

          // Add to flashcard button
          _SaveToFlashcardButton(
            isSaving: isSaving,
            isSaved: isSaved,
            onTap: onSaveToFlashcard ?? () {},
          ),
        ],
      ),
    );
  }
}

class _WordHeading extends StatelessWidget {
  const _WordHeading({
    required this.word,
    this.pronunciation,
    this.cefrLevel,
    this.wordType,
    this.onSpeakTap,
  });

  final String word;
  final String? pronunciation;
  final String? cefrLevel;
  final String? wordType;
  final VoidCallback? onSpeakTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                word,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: context.tokens.foreground,
                ),
              ),
              if (pronunciation != null) ...[
                const SizedBox(height: 4),
                Text(
                  pronunciation!,
                  style: TextStyle(
                    fontSize: 14,
                    color: context.tokens.mutedForeground,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
              if (cefrLevel != null || wordType != null) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    if (cefrLevel != null)
                      _CefrBadge(level: cefrLevel!),
                    if (wordType != null)
                      _TypeBadge(type: wordType!),
                  ],
                ),
              ],
            ],
          ),
        ),
        if (onSpeakTap != null)
          GestureDetector(
            onTap: onSpeakTap,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: context.tokens.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                PhosphorIcons.speakerHigh,
                color: AppColors.tigerOrange,
              ),
            ),
          ),
      ],
    );
  }
}

class _CefrBadge extends StatelessWidget {
  const _CefrBadge({required this.level});

  final String level;

  Color get _color {
    switch (level) {
      case 'A1':
        return Colors.green;
      case 'A2':
        return Colors.lightGreen;
      case 'B1':
        return Colors.orange;
      case 'B2':
        return Colors.deepOrange;
      case 'C1':
        return Colors.red;
      case 'C2':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        level,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: _color,
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: context.tokens.muted,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        type,
        style: TextStyle(
          fontSize: 12,
          color: context.tokens.mutedForeground,
        ),
      ),
    );
  }
}

class _WordMetaBadges extends StatelessWidget {
  const _WordMetaBadges({
    this.wordType,
    this.gender,
    this.plural,
  });

  final String? wordType;
  final String? gender;
  final String? plural;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (gender != null)
          _GenderBadge(gender: gender!),
        if (plural != null)
          Text(
            'Pl. $plural',
            style: TextStyle(
              fontSize: 13,
              color: context.tokens.mutedForeground,
            ),
          ),
      ],
    );
  }
}

class _GenderBadge extends StatelessWidget {
  const _GenderBadge({required this.gender});

  final String gender;

  Color get _color {
    switch (gender) {
      case 'm':
        return Colors.blue;
      case 'f':
        return Colors.pink;
      case 'n':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String get _text {
    switch (gender) {
      case 'm':
        return 'der';
      case 'f':
        return 'die';
      case 'n':
        return 'das';
      default:
        return gender;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _MeaningSection extends StatelessWidget {
  const _MeaningSection({required this.translation});

  final String translation;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.tokens.muted,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.tokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nghĩa',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: context.tokens.mutedForeground,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            translation,
            style: TextStyle(
              fontSize: 15,
              color: context.tokens.foreground,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExamplesSection extends StatelessWidget {
  const _ExamplesSection({
    required this.example,
    this.translation,
    this.onSpeakTap,
  });

  final String example;
  final String? translation;
  final VoidCallback? onSpeakTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.tokens.muted,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.tokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Ví dụ',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: context.tokens.mutedForeground,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              if (onSpeakTap != null)
                GestureDetector(
                  onTap: onSpeakTap,
                  child: Icon(
                    PhosphorIcons.speakerHigh,
                    size: 18,
                    color: context.tokens.mutedForeground,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            example,
            style: TextStyle(
              fontSize: 15,
              color: context.tokens.foreground,
            ),
          ),
          if (translation != null) ...[
            const SizedBox(height: 4),
            Text(
              translation!,
              style: TextStyle(
                fontSize: 13,
                color: context.tokens.mutedForeground,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TagsSection extends StatelessWidget {
  const _TagsSection({required this.tags});

  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: context.tokens.muted,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            tag,
            style: TextStyle(
              fontSize: 12,
              color: context.tokens.mutedForeground,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _SaveToFlashcardButton extends StatelessWidget {
  const _SaveToFlashcardButton({
    required this.isSaving,
    required this.isSaved,
    required this.onTap,
  });

  final bool isSaving;
  final bool isSaved;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isSaving ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSaved ? Colors.green : AppColors.tigerOrange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          isSaving
              ? 'Đang lưu...'
              : isSaved
                  ? '✓ Đã lưu vào Flashcard'
                  : 'Thêm vào Flashcard',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
