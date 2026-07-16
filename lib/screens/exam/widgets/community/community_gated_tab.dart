import 'package:flutter/material.dart';

import '../../../../core/icons/app_phosphor_icons.dart';
import '../../../../core/theme/app_tokens.dart';

/// Coming-soon placeholder for the "Đóng góp" (AI-generate + publish) and
/// "Đề của tôi" (my contributed topics) tabs. Product decision: the
/// community CONTRIBUTE/write path stays gated OFF this phase — GĐ2 P3 owns
/// building it — but web still shows both tabs, so Flutter renders them
/// too, just with a gated state instead of omitting the tab entirely.
class CommunityGatedTab extends StatelessWidget {
  const CommunityGatedTab({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(AppPhosphorIcons.lock, size: 32, color: tokens.mutedForeground),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: tokens.mutedForeground, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
