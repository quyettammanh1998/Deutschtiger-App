import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../features/writing/domain/community_writing_topic.dart';

/// Version chip row — web parity `CommunityVersionSelector`. One chip per
/// contributed version of a canonical topic; verified/consensus version
/// gets a ✓ badge.
class CommunityVersionSelector extends StatelessWidget {
  const CommunityVersionSelector({
    super.key,
    required this.versions,
    required this.selectedIndex,
    required this.onChange,
  });

  final List<CommunityWritingTopic> versions;
  final int selectedIndex;
  final ValueChanged<int> onChange;

  @override
  Widget build(BuildContext context) {
    if (versions.length <= 1) return const SizedBox.shrink();
    final tokens = context.tokens;
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: versions.length,
        separatorBuilder: (_, _) => const SizedBox(width: 6),
        itemBuilder: (context, i) {
          final active = i == selectedIndex;
          final v = versions[i];
          return InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: () => onChange(i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: active ? tokens.primary : tokens.muted,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '${v.isVerified == true ? '✓ ' : ''}#${i + 1} ${v.contributorName ?? ''}'.trim(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: active ? Colors.white : tokens.mutedForeground,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
