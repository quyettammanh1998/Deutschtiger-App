import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// GĐ2 — RevenueCat wrapper.
///
/// Gọi [init] một lần ở main() SAU khi Supabase khởi xong.
/// Sử dụng với [premiumProvider] để check entitlement.
class RevenueCatService {
  RevenueCatService._();
  static final RevenueCatService instance = RevenueCatService._();

  // API keys bắt buộc phải có — set từ env trước khi call init().
  static String? _iosKey;
  static String? _androidKey;

  static void configure({required String iosKey, required String androidKey}) {
    _iosKey = iosKey;
    _androidKey = androidKey;
  }

  bool _initialized = false;

  Future<void> init({String? userId}) async {
    if (_initialized) return;
    if (kIsWeb) return; // không hỗ trợ web

    final apiKey = Platform.isIOS || Platform.isMacOS ? _iosKey : _androidKey;
    if (apiKey == null || apiKey.isEmpty) return;

    await Purchases.setLogLevel(LogLevel.info);
    await Purchases.configure(PurchasesConfiguration(apiKey));
    if (userId != null && userId.isNotEmpty) {
      await Purchases.logIn(userId);
    }
    _initialized = true;
  }

  /// Check premium entitlement (gọi sau khi [init] xong).
  Future<bool> isPremium() async {
    if (!_initialized) return false;
    try {
      final info = await Purchases.getCustomerInfo();
      return info.entitlements.active.containsKey('premium');
    } catch (_) {
      return false;
    }
  }

  /// Mua package (monthly / semi_annual / lifetime).
  Future<bool> purchase(Package package) async {
    try {
      final result = await Purchases.purchase(PurchaseParams.package(package));
      return result.customerInfo.entitlements.active.containsKey('premium');
    } on PurchasesErrorCode catch (e) {
      if (e == PurchasesErrorCode.purchaseCancelledError) return false;
      rethrow;
    }
  }

  /// Khôi phục mua hàng (bắt buộc iOS non-consumable).
  Future<bool> restorePurchases() async {
    try {
      final info = await Purchases.restorePurchases();
      return info.entitlements.active.containsKey('premium');
    } catch (_) {
      return false;
    }
  }

  /// Lấy danh sách packages GĐ2 từ offering 'default'.
  Future<List<Package>> getPackages() async {
    if (!_initialized) return [];
    try {
      final offerings = await Purchases.getOfferings();
      return offerings.current?.availablePackages ?? [];
    } catch (_) {
      return [];
    }
  }

  Future<void> logout() async {
    if (!_initialized) return;
    try {
      await Purchases.logOut();
    } catch (_) {}
  }
}
