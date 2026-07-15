import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../data/revenuecat_service.dart';

/// Entitlement state — true = user có premium active.
final premiumProvider = FutureProvider<bool>((ref) async {
  return RevenueCatService.instance.isPremium();
});

/// Danh sách packages để mua (monthly / semi_annual / lifetime).
final premiumPackagesProvider = FutureProvider<List<Package>>((ref) async {
  return RevenueCatService.instance.getPackages();
});
