import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_tokens.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../view_models/providers.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Feedback sheet — Phase 05 N6.
///
/// Đồng bộ với web `/feedback` route: cho user chọn category (Lỗi / Góp ý /
/// Khác) + nhập mô tả, gửi về endpoint feedback của BE (chưa wire — submit
/// hiện chỉ show snackbar).
class FeedbackSheet extends ConsumerStatefulWidget {
  const FeedbackSheet({super.key});

  @override
  ConsumerState<FeedbackSheet> createState() => _FeedbackSheetState();
}

class _FeedbackSheetState extends ConsumerState<FeedbackSheet> {
  static const _categories = <_FeedbackCategory>[
    _FeedbackCategory('Lỗi'),
    _FeedbackCategory('Góp ý'),
    _FeedbackCategory('Khác'),
  ];

  _FeedbackCategory _category = _categories.first;
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _loading = false;

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.feedbackMessageRequired)));
      return;
    }
    setState(() => _loading = true);
    try {
      await ref
          .read(apiClientProvider)
          .post<void>(
            '/feedback',
            body: {'category': _category.apiValue, 'message': text},
          );
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.feedbackSent)));
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.feedbackCouldNotSend)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets),
      child: Container(
        decoration: BoxDecoration(
          color: tokens.card,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(DesignTokens.radiusLg),
          ),
        ),
        padding: const EdgeInsets.all(DesignTokens.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                width: 40,
                height: 4,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: tokens.border),
                ),
              ),
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            Text(
              l10n.feedbackTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: DesignTokens.spacingSm),
            Wrap(
              spacing: DesignTokens.spacingSm,
              children: [
                for (final c in _categories)
                  ChoiceChip(
                    label: Text(c.label(l10n)),
                    selected: _category == c,
                    onSelected: (_) => setState(() => _category = c),
                  ),
              ],
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            TextField(
              controller: _controller,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: l10n.feedbackDescriptionHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _loading ? null : _submit,
                icon: const Icon(PhosphorIcons.paperPlaneTilt, size: 18),
                label: Text(l10n.sendAction),
                style: FilledButton.styleFrom(
                  backgroundColor: DesignTokens.orange500,
                  // Fixed brand-orange CTA (matches other orange500 buttons
                  // app-wide) — foreground stays literal white rather than
                  // `card`, which would go dark-navy in dark mode.
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedbackCategory {
  const _FeedbackCategory(this.apiValue);

  final String apiValue;

  String label(AppLocalizations l10n) => switch (apiValue) {
    'Lỗi' => l10n.feedbackCategoryBug,
    'Góp ý' => l10n.feedbackCategorySuggestion,
    _ => l10n.feedbackCategoryOther,
  };
}

/// Convenience helper to show the feedback sheet from any call site.
Future<void> showFeedbackSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const FeedbackSheet(),
  );
}
