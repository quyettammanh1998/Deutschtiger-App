import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/review_item.dart';

/// Hàng 4 nút đánh giá sau khi lật thẻ: Quên / Khó / Tốt / Dễ.
/// Màu đi từ đỏ → cam → xanh lá theo độ nhớ (giống web).
class RatingBar extends StatelessWidget {
  const RatingBar({
    super.key,
    required this.onRate,
    this.enabled = true,
  });

  final void Function(ReviewRating rating) onRate;
  final bool enabled;

  static const _colors = {
    ReviewRating.forgot: AppColors.destructive,
    ReviewRating.hard: AppColors.warning,
    ReviewRating.medium: AppColors.success,
    ReviewRating.easy: AppColors.tigerOrange,
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final rating in ReviewRating.values) ...[
          Expanded(
            child: _RatingButton(
              label: rating.labelVi,
              color: _colors[rating]!,
              onTap: enabled ? () => onRate(rating) : null,
            ),
          ),
          if (rating != ReviewRating.values.last) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _RatingButton extends StatelessWidget {
  const _RatingButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onTap == null ? 0.5 : 1,
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            height: 48,
            alignment: Alignment.center,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
