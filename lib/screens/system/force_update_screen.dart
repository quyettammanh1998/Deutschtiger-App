import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/design_tokens.dart';
import '../../core/theme/app_tokens.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Màn chặn buộc cập nhật — Phase 13 §"Force-update path".
///
/// Hiển thị khi `ForceUpdateService.check()` quyết định version hiện tại < 
/// `minAppVersion`. Không có cách nào thoát ra ngoài ngoài nút mở Store.
class ForceUpdateScreen extends StatelessWidget {
  const ForceUpdateScreen({
    super.key,
    required this.storeUrl,
    this.message,
    this.latestVersion,
  });

  final String storeUrl;
  final String? message;
  final String? latestVersion;

  Future<void> _openStore(BuildContext context) async {
    final uri = Uri.tryParse(storeUrl);
    if (uri == null) return;
    final ok = await canLaunchUrl(uri);
    if (!ok) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể mở cửa hàng: $storeUrl')),
        );
      }
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingLg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                PhosphorIcons.downloadSimple,
                size: 96,
                color: DesignTokens.tigerOrange,
              ),
              const SizedBox(height: DesignTokens.spacingLg),
              Text(
                'Cần cập nhật ứng dụng',
                style: DesignTokens.titleLarge.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: DesignTokens.spacingSm),
              Text(
                message ??
                    'Phiên bản hiện tại đã cũ. Vui lòng cập nhật để tiếp tục sử dụng DeutschTiger.',
                style: DesignTokens.bodyMedium.copyWith(
                  color: tokens.mutedForeground,
                ),
                textAlign: TextAlign.center,
              ),
              if (latestVersion != null) ...[
                const SizedBox(height: DesignTokens.spacingSm),
                Text(
                  'Phiên bản mới nhất: $latestVersion',
                  style: DesignTokens.bodySmall.copyWith(
                    color: tokens.mutedForeground,
                  ),
                ),
              ],
              const SizedBox(height: DesignTokens.spacingXl),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: DesignTokens.tigerOrange,
                    padding: const EdgeInsets.symmetric(
                      vertical: DesignTokens.spacingMd,
                    ),
                  ),
                  onPressed: () => _openStore(context),
                  child: const Text(
                    'Cập nhật ngay',
                    style: DesignTokens.buttonText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}