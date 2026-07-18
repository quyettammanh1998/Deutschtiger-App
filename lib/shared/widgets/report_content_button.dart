import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';
import 'confirm_dialog.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Default reasons offered in the report sheet (kept short & non-leading so
/// the free-text field is the primary signal). Mirrors the pattern used in
/// the web `ReportContentButton` component (Phase 05 / R7 AI compliance).
const List<String> kReportReasons = <String>[
  'Sai về ngữ pháp / từ vựng',
  'Nội dung không phù hợp',
  'Nội dung gây hiểu lầm',
  'Khác',
];

/// Result returned by [showReportContentSheet]. `null` means the user
/// dismissed without submitting.
class ReportContentResult {
  const ReportContentResult({required this.reason, required this.note});
  final String reason;
  final String note;
}

/// Icon-only button + bottom sheet that lets a user flag an AI-generated
/// reply (or any other content) for moderation.
///
/// **Why it exists (R7 in plan 02):** Google Play AI policy requires an
/// in-app flag mechanism for any AI-generated content the user can see.
/// Showing the flag UI in the chat itself is the simplest path that meets
/// the baseline. The submit is **best-effort** — if the backend endpoint is
/// not yet wired, the sheet still records a SnackBar so the user sees
/// feedback, and the call falls back to a graceful no-op.
class ReportContentButton extends StatelessWidget {
  const ReportContentButton({
    super.key,
    required this.contentType,
    this.contentId,
    this.iconColor,
    this.tooltip = 'Báo cáo nội dung AI',
    this.onSubmitted,
  });

  /// Short tag used in the body sent to the backend. E.g. `'ai_chat'`,
  /// `'ai_grade'`. Free-form; the server logs but does not strictly validate.
  final String contentType;

  /// Optional ID of the offending content (message id, attempt id, ...).
  final String? contentId;

  final Color? iconColor;
  final String tooltip;
  final ValueChanged<ReportContentResult>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        PhosphorIcons.flag,
        size: 20,
        color: iconColor ?? DesignTokens.mutedForeground,
      ),
      tooltip: tooltip,
      onPressed: () => _open(context),
    );
  }

  Future<void> _open(BuildContext context) async {
    final result = await showReportContentSheet(
      context,
      contentType: contentType,
      contentId: contentId,
    );
    if (result == null) return;
    onSubmitted?.call(result);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cảm ơn bạn! Chúng tôi đã ghi nhận báo cáo.'),
      ),
    );
  }
}

/// Opens the bottom sheet and returns the user's submission, or `null`
/// if they dismissed without confirming.
Future<ReportContentResult?> showReportContentSheet(
  BuildContext context, {
  required String contentType,
  String? contentId,
}) async {
  return showModalBottomSheet<ReportContentResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) =>
        _ReportContentSheet(contentType: contentType, contentId: contentId),
  );
}

class _ReportContentSheet extends StatefulWidget {
  const _ReportContentSheet({required this.contentType, this.contentId});
  final String contentType;
  final String? contentId;

  @override
  State<_ReportContentSheet> createState() => _ReportContentSheetState();
}

class _ReportContentSheetState extends State<_ReportContentSheet> {
  String _reason = kReportReasons.first;
  final _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).pop(
      ReportContentResult(reason: _reason, note: _noteController.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets),
      child: Container(
        decoration: const BoxDecoration(
          color: DesignTokens.card,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(DesignTokens.radiusLg),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(
          DesignTokens.screenHorizontalPadding,
          DesignTokens.spacingMd,
          DesignTokens.screenHorizontalPadding,
          DesignTokens.spacingLg,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: const BoxDecoration(color: DesignTokens.border),
                ),
              ),
              const SizedBox(height: DesignTokens.spacingMd),
              Row(
                children: [
                  const Icon(
                    PhosphorIcons.flag,
                    color: DesignTokens.warning,
                    size: 22,
                  ),
                  const SizedBox(width: DesignTokens.spacingSm),
                  Text(
                    'Báo cáo nội dung AI',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: DesignTokens.spacingSm),
              Text(
                'Hãy cho chúng tôi biết vấn đề. Báo cáo của bạn sẽ giúp '
                'cải thiện chất lượng nội dung AI.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: DesignTokens.mutedForeground,
                ),
              ),
              const SizedBox(height: DesignTokens.spacingMd),
              RadioGroup<String>(
                groupValue: _reason,
                onChanged: (value) {
                  if (value != null) setState(() => _reason = value);
                },
                child: Column(
                  children: kReportReasons
                      .map(
                        (reason) => RadioListTile<String>(
                          value: reason,
                          activeColor: DesignTokens.orange500,
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          title: Text(
                            reason,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: DesignTokens.spacingSm),
              TextFormField(
                controller: _noteController,
                maxLines: 3,
                maxLength: 500,
                decoration: const InputDecoration(
                  labelText: 'Mô tả chi tiết (tuỳ chọn)',
                  hintText: 'Bạn gặp vấn đề gì với nội dung này?',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (_reason == 'Khác' && (v == null || v.trim().isEmpty)) {
                    return 'Vui lòng mô tả chi tiết khi chọn "Khác".';
                  }
                  return null;
                },
              ),
              const SizedBox(height: DesignTokens.spacingMd),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Huỷ'),
                    ),
                  ),
                  const SizedBox(width: DesignTokens.spacingSm),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _submit,
                      icon: const Icon(PhosphorIcons.paperPlaneTilt, size: 18),
                      label: const Text('Gửi báo cáo'),
                      style: FilledButton.styleFrom(
                        backgroundColor: DesignTokens.orange500,
                        foregroundColor: DesignTokens.card,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Public hook for screens that already have their own dialog flow but want
/// the same confirmation copy. Returns `true` when the user confirms.
Future<bool> confirmReportContent(BuildContext context) {
  return showConfirmDialog(
    context,
    title: 'Báo cáo nội dung AI',
    message:
        'Bạn muốn gửi báo cáo về nội dung AI này? Chúng tôi sẽ xem xét '
        'trong thời gian sớm nhất.',
    confirmLabel: 'Báo cáo',
    cancelLabel: 'Huỷ',
    icon: PhosphorIcons.flag,
  );
}
