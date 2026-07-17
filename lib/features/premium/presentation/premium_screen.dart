import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../core/design_tokens.dart';
import '../../../core/theme/app_tokens.dart';
import '../domain/premium_providers.dart';
import '../data/revenuecat_service.dart';

/// GĐ2 — Premium purchase screen.
///
/// Compliance (Apple 3.1.1): hiển thị compliance text trước nút mua.
/// KHÔNG auto-renew — gói one-time có thời hạn.
class PremiumScreen extends ConsumerStatefulWidget {
  const PremiumScreen({super.key});

  @override
  ConsumerState<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends ConsumerState<PremiumScreen> {
  bool _purchasing = false;
  bool _restoring = false;

  Future<void> _buy(Package package) async {
    setState(() => _purchasing = true);
    try {
      final success = await RevenueCatService.instance.purchase(package);
      if (!mounted) return;
      if (success) {
        ref.invalidate(premiumProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kích hoạt premium thành công!')),
        );
        context.pop();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mua thất bại: $e')),
      );
    } finally {
      if (mounted) setState(() => _purchasing = false);
    }
  }

  Future<void> _restore() async {
    setState(() => _restoring = true);
    try {
      final success = await RevenueCatService.instance.restorePurchases();
      if (!mounted) return;
      ref.invalidate(premiumProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? 'Đã khôi phục premium!'
              : 'Không tìm thấy mua hàng nào để khôi phục.'),
        ),
      );
      if (success) context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Khôi phục thất bại: $e')),
      );
    } finally {
      if (mounted) setState(() => _restoring = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final packagesAsync = ref.watch(premiumPackagesProvider);

    return Scaffold(
      backgroundColor: context.tokens.background,
      appBar: AppBar(
        backgroundColor: context.tokens.background,
        elevation: 0,
        title: const Text(
          'Nâng cấp Premium',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: DesignTokens.tigerOrange,
          ),
        ),
      ),
      body: SafeArea(
        child: packagesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Không tải được gói: $e')),
          data: (packages) => _Body(
            packages: packages,
            purchasing: _purchasing,
            restoring: _restoring,
            onBuy: _buy,
            onRestore: _restore,
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.packages,
    required this.purchasing,
    required this.restoring,
    required this.onBuy,
    required this.onRestore,
  });

  final List<Package> packages;
  final bool purchasing;
  final bool restoring;
  final void Function(Package) onBuy;
  final VoidCallback onRestore;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(DesignTokens.screenHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: DesignTokens.spacingLg),
          const Icon(Icons.workspace_premium, size: 64, color: DesignTokens.tigerOrange),
          const SizedBox(height: DesignTokens.spacingMd),
          Text(
            'Học không giới hạn',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: context.tokens.foreground),
          ),
          const SizedBox(height: DesignTokens.spacingXl),
          if (packages.isEmpty)
            const Center(child: Text('Không có gói nào. Thử lại sau.'))
          else
            ...packages.map((p) => _PlanCard(
                  package: p,
                  onTap: purchasing ? null : () => onBuy(p),
                )),
          const SizedBox(height: DesignTokens.spacingLg),
          // Compliance text bắt buộc hiện trước nút mua
          Container(
            padding: const EdgeInsets.all(DesignTokens.spacingMd),
            decoration: BoxDecoration(
              color: context.tokens.muted,
              borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
            ),
            child: Text(
              'Các gói không tự gia hạn. Mua thêm để tiếp tục sau khi hết hạn. '
              'Huỷ: không áp dụng (không auto-renew).',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: context.tokens.mutedForeground, height: 1.5),
            ),
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          TextButton(
            onPressed: restoring ? null : onRestore,
            child: Text(restoring ? 'Đang khôi phục...' : 'Khôi phục mua hàng'),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.package, this.onTap});

  final Package package;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final storeProduct = package.storeProduct;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: DesignTokens.spacingMd),
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        decoration: BoxDecoration(
          color: context.tokens.card,
          borderRadius: BorderRadius.circular(DesignTokens.radius),
          border: Border.all(color: context.tokens.border),
          boxShadow: DesignTokens.shadowCard,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    storeProduct.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: context.tokens.foreground,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    storeProduct.description,
                    style: TextStyle(fontSize: 13, color: context.tokens.mutedForeground),
                  ),
                ],
              ),
            ),
            const SizedBox(width: DesignTokens.spacingMd),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  storeProduct.priceString,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: DesignTokens.tigerOrange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
