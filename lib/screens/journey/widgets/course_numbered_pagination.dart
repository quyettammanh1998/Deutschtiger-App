import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';

/// Numbered page buttons — web parity: "← Trước [1][2][3] Sau →" +
/// "Trang x/y · Hiển thị a–b" in `course-detail-page.tsx`.
class CourseNumberedPagination extends StatelessWidget {
  const CourseNumberedPagination({
    super.key,
    required this.page,
    required this.totalPages,
    required this.pageSize,
    required this.totalItems,
    required this.onChanged,
  });

  final int page;
  final int totalPages;
  final int pageSize;
  final int totalItems;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final start = (page - 1) * pageSize + 1;
    final end = (page * pageSize).clamp(0, totalItems);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: page > 1 ? () => onChanged(page - 1) : null,
              child: Text(l10n.coursesPaginationPrev),
            ),
            const SizedBox(width: 4),
            for (var p = 1; p <= totalPages; p++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: InkWell(
                  onTap: () => onChanged(p),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: p == page ? tokens.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$p',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: p == page ? tokens.primaryForeground : tokens.mutedForeground,
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(width: 4),
            TextButton(
              onPressed: page < totalPages ? () => onChanged(page + 1) : null,
              child: Text(l10n.coursesPaginationNext),
            ),
          ],
        ),
        Text(
          l10n.coursesPaginationInfo(page, totalPages, start, end),
          style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
        ),
      ],
    );
  }
}
