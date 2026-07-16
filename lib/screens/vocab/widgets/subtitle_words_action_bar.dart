import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/common/app_button.dart';
import '../../../widgets/common/sticky_cta_bar.dart';

/// Sticky bottom CTA — web parity: `fixed bottom-16` action bar with a
/// `btn-primary` "Thêm N từ vào ôn tập" pill / emerald success toast.
class SubtitleWordsActionBar extends StatelessWidget {
  const SubtitleWordsActionBar({
    super.key,
    required this.selectedCount,
    required this.saving,
    required this.successMessage,
    required this.onAdd,
  });

  final int selectedCount;
  final bool saving;
  final String? successMessage;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final success = successMessage;

    return StickyCtaBar(
      child: success != null
          ? DecoratedBox(
              decoration: BoxDecoration(
                color: tokens.success,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  success,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            )
          : SizedBox(
              width: double.infinity,
              child: AppButton(
                label: saving
                    ? l10n.subtitleWordsAdding
                    : l10n.subtitleWordsAddSelected(selectedCount),
                onPressed: saving ? null : onAdd,
                loading: saving,
              ),
            ),
    );
  }
}
