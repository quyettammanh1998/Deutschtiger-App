---
phase: 10
title: "Phase 7: GĐ2 — IAP RevenueCat + Entitlement Unification"
status: pending
priority: P0
effort: "2-3w"
dependencies: [9]
---

# Phase 10: Phase 7 — IAP RevenueCat

## Overview

Mở đầu GĐ2. Submit riêng thành 1 bản update (đừng gộp payment với feature lớn). Mô hình: one-time có thời hạn (không auto-renew). RevenueCat SDK làm lớp wrapper.

## Requirements

- Giá phương án A gross-up: 99k/349k/449k (chốt R6)
- Apple: Non-renewing subscription (monthly/semi-annual) + Non-consumable (lifetime)
- Google: In-app product (consumable với BE quản hạn) + managed non-consumed (lifetime)
- BE: thêm cột `source: sepay|apple|google` vào `payments`/`user_purchases`
- BE: webhook RevenueCat → gọi `upgradePremiumTx` sẵn có
- App + web đọc cùng `profiles.is_premium/premium_expires_at`
- Restore Purchases button (bắt buộc iOS non-consumable)

## Architecture

```
lib/features/premium/
├── data/
│   ├── revenuecat_service.dart    # RevenueCat SDK wrapper
│   └── premium_model.dart
├── domain/
│   └── premium_providers.dart     # entitlement state
└── presentation/
    ├── premium_screen.dart        # plan selector + buy
    ├── premium_gate_widget.dart   # gate real (replace O3 trung tính)
    └── widgets/
        ├── plan_card.dart         # monthly/semi-annual/lifetime card
        └── restore_purchases_button.dart
```

## Implementation Steps

### 1. Pre-setup (trước khi code)
- Apple Small Business Program enroll (15% fee)
- Bank account + tax forms: Apple W-8BEN + Google payments profile
- RevenueCat project + configure entitlements (premium_monthly, premium_semi, premium_lifetime)
- Tạo products Apple Connect + Google Play Console theo bảng:
  | Gói | Apple | Google | Giá VND |
  |-----|-------|--------|---------|
  | monthly | Non-renewing sub | Consumable in-app | 99,000 |
  | semi_annual | Non-renewing sub | Consumable in-app | 349,000 |
  | lifetime | Non-consumable | Managed (non-consumed) | 449,000 |

### 2. BE: entitlement unification (cần trước app UI)
```sql
-- Migration: thêm cột source
ALTER TABLE payments ADD COLUMN source TEXT DEFAULT 'sepay';
ALTER TABLE user_purchases ADD COLUMN source TEXT DEFAULT 'sepay';
-- Backfill existing records
UPDATE payments SET source = 'sepay' WHERE source IS NULL;
```
```go
// RevenueCat webhook handler:
// POST /webhooks/revenuecat
// Verify RevenueCat signature
// Extract: event_type, product_id, app_user_id, expiry
// → call upgradePremiumTx(userID, planType, expiry, source='apple'|'google')
// KHÔNG tin client báo "đã mua" — chỉ trust webhook
```

### 3. RevenueCat SDK integration
```dart
// pubspec.yaml: purchases_flutter: ^7.x
// Init: await Purchases.configure(PurchasesConfiguration(apiKey));
// apiKey từ env (KHÔNG hardcode)
// Login: Purchases.logIn(supabase.auth.currentUser!.id)
```

### 4. Premium Screen UI
```dart
// Port layout plan selector từ web
// Plan cards: monthly/semi/lifetime với price + duration
// Nút mua → Purchases.purchasePackage() → native IAP sheet
// Post-purchase: optimistic UI → verify qua webhook (không trust client)
// Error handling: user cancelled / payment failed / already owned
```

### 5. Restore Purchases (bắt buộc iOS)
```dart
// Nút "Khôi phục mua hàng" trong Settings
// Purchases.restorePurchases() → update entitlement
// Show success/failure snackbar
```

### 6. Gate flip GĐ1 → GĐ2
- Replace `PremiumGateWidget` trung tính → gate real + upsell
- Free-limit overlay (X bài/ngày hết → upgrade sheet)
- Premium banner trong dashboard (nếu không premium)
- Hiển thị thời hạn còn lại trong Settings

### 7. Compliance display
Trước nút mua phải hiển thị:
```
Gói monthly: 99.000đ / 30 ngày. Không tự gia hạn. Mua thêm để tiếp tục.
Gói lifetime: 449.000đ vĩnh viễn.
Huỷ: không áp dụng (không auto-renew).
```

## Success Criteria

- [ ] Mua monthly trên app → BE ghi premium + source='apple'/'google' → web thấy premium
- [ ] User mua SePay trước → mở app → thấy premium (đọc cùng is_premium field)
- [ ] Restore purchases: mua lại sau reinstall → premium khôi phục
- [ ] Compliance text hiện trước nút mua
- [ ] Webhook RevenueCat → `upgradePremiumTx` → premium_expires_at đúng ngày
- [ ] Sandbox test: mua/restore cả iOS + Android

## Risk Assessment

- Review vòng payment kỹ → review notes giải thích rõ one-time model (không auto-renew)
- Lifetime non-consumable iOS: nếu restore bị Apple reject → fallback consumable (ít lý tưởng hơn)
- Entitlement hợp nhất phức tạp → test case: SePay user → mua iOS → không mất ngày cộng dồn
