import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';

/// "Trước / Trang x/y / Tiếp" pagination — web parity `video-pagination.tsx`.
class VideoPaginationBar extends StatelessWidget {
  const VideoPaginationBar({
    super.key,
    required this.page,
    required this.totalPages,
    required this.onChanged,
  });

  final int page;
  final int totalPages;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: page > 1 ? () => onChanged(page - 1) : null,
            child: Text(l10n.examSetPagePrev),
          ),
          const SizedBox(width: 8),
          Text(
            l10n.videoCollectionPageInfo(page, totalPages),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: tokens.mutedForeground,
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: page < totalPages ? () => onChanged(page + 1) : null,
            child: Text(l10n.examSetPageNext),
          ),
        ],
      ),
    );
  }
}
