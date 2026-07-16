import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../data/exam/exam_ecosystem_models.dart';
import '../../../../widgets/common/app_card.dart';
import 'real_exam_badge.dart';

/// Browse-tab topic row. Web parity: `TopicCard` in
/// `community-exams-page.tsx` — title de/vi, "{Provider} {Skill} T{teil}"
/// chip, "👤 contributor • date" meta line + [RealExamBadge].
class CommunityTopicCard extends StatelessWidget {
  const CommunityTopicCard({super.key, required this.topic});

  final CommunityExamTopic topic;

  static const _providerLabels = {'goethe': 'Goethe', 'telc': 'Telc'};
  static const _skillLabels = {'writing': 'Viết', 'speaking': 'Nói'};

  String get _typeLabel {
    final provider =
        _providerLabels[topic.provider] ?? topic.provider.toUpperCase();
    final skill = _skillLabels[topic.skill] ?? topic.skill;
    return '$provider $skill T${topic.teil}';
  }

  String get _createdLabel {
    final parsed = DateTime.tryParse(topic.createdAt);
    if (parsed == null) return '';
    return DateFormat('dd/MM/yyyy').format(parsed.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return AppCard.interactive(
      onTap: () => context.push('/exam/community/${topic.id}'),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.titleDe,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: tokens.foreground,
                      ),
                    ),
                    if (topic.titleVi != null && topic.titleVi!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          topic.titleVi!,
                          style: TextStyle(
                            fontSize: 12,
                            color: tokens.mutedForeground,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: tokens.muted,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  child: Text(
                    _typeLabel,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: tokens.foreground,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Text(
                '👤 ${topic.contributorName.isNotEmpty ? topic.contributorName : 'Ẩn danh'}',
                style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
              ),
              if (_createdLabel.isNotEmpty)
                Text(
                  _createdLabel,
                  style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
                ),
              RealExamBadge(
                examDate: topic.examDate,
                examLocation: topic.examLocation,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
