---
phase: 9
title: "Phase 6: Store Submission GĐ1 — TestFlight + Closed Testing + Launch"
status: pending
priority: P0
effort: "1w + 2-3w wait"
dependencies: [8]
---

# Phase 9: Phase 6 — Store Submission GĐ1

## Overview

Submit app lên 2 store. ⚠️ **Closed testing Google bắt đầu NGAY khi có build alpha cuối Phase 3** — không chờ xong mọi thứ. 14 ngày + 12 tester là critical path.

## Requirements

- 2 developer accounts active (Apple $99 + Google $25) — **đăng ký TUẦN 1**
- Crash-free ≥99.5% trên closed testing trước khi promote
- Data Safety form khai URL xoá tài khoản (Phase 2 đã tạo và đã verify cùng contract backend)
- Report AI disclosure trong listing (R7)
- KHÔNG có mention premium/giá trong GĐ1 listing

## Implementation Steps

### 1. Developer Accounts (NGAY TUẦN 1)
- Apple Developer Program: $99/năm — cá nhân nhanh hơn organization (D-U-N-S)
- Google Play Console: $25 one-time
- **Apple Small Business Program** (15% thay 30%): đăng ký ngay sau có account + doanh thu <$1M/năm

### 2. Tuyển tester Google (20 người, cần 12 opt-in)
- Banner web cho user Android active + bài fanpage
- Mời top leaderboard actives
- Incentive: 1 tháng premium (admin grant)
- Quản lý qua Google Group
- **Target: 12 opt-in xác nhận TRƯỚC khi upload build alpha**

### 3. Chất lượng build trước submit
- Crashlytics active từ build đầu, alert khi crash-free < 99.5%
- Checklist: mọi link sống, không màn trắng, không chữ "beta/test/coming soon"
- Portrait-only lock khai đúng trong manifest/Info.plist
- Offline banner hoạt động (không crash khi mất mạng)
- Deep links không vỡ
- Sign in with Apple smoke test trên thiết bị thật iOS
- Test thiết bị thật: 1 Android giá rẻ + 1 iPhone cũ (iOS 15-16) + 1 iPhone mới

### 4. Store Listing
- Tên: "DeutschTiger – Học tiếng Đức"
- Mô tả VI: 500 ký tự short + 4000 long
- Screenshots: 6.5" iOS (1284×2778) + 5.5" (1242×2208) + Android phone (1080×1920)
- Feature graphic: 1024×500
- Icon: 1024×1024 (đã có `flutter_launcher_icons`)
- Privacy policy URL: `deutschtiger.com/privacy` (đã có)
- Support email

### 5. Data Safety + Privacy Labels
- Account data: email, name (linked to user)
- Learning progress: xp, streak, reviews (linked to user)
- Analytics: session events (linked to user)
- Mic: **KHÔNG** ở GĐ1
- AI disclosure: app có AI text responses, nút report có
- Data Safety URL xoá tài khoản: `deutschtiger.com/delete-account`

### 6. App Review Notes
```
Demo account: reviewer@deutschtiger.app / password: [secure]
App không có in-app purchase. Tính năng chính: học từ vựng tiếng Đức với FSRS, luyện thi TELC/Goethe, AI tutor.
Flow chính: Login → Dashboard → Học từ vựng → Daily review.
```

### 7. Launch-day config
- BE: set `DEVICE_SESSION_LIMIT=3` (chốt R3, chỉ đổi env + restart)
- Staged rollout Android: 20% → 50% → 100% theo vitals

### 8. Submit + theo dõi review
- iOS: TestFlight internal → external beta (review nhẹ) → App Store submit
- Android: Closed → Production staged
- Trả lời reviewer trong 24h (Resolution Center)
- Nếu reject: sửa ngay + resubmit (không appeal trừ khi chắc sai)

## Success Criteria

- [ ] 2 developer accounts active trước Phase 2 bắt đầu
- [ ] 12+ tester opt-in Google trước khi upload alpha
- [ ] Crash-free ≥99.5% trên closed testing (7 ngày liên tiếp)
- [ ] Pre-launch report Android: 0 crash, 0 ANR critical
- [ ] iOS: App Store approved (hoặc resubmit sau 1 lần reject)
- [ ] Android: Production 100% rollout
- [ ] App live cả 2 store

## Risk Assessment

- Google 14 ngày critical path → START NGAY từ build alpha cuối Phase 3
- Apple reject vòng 1 xác suất 30-40% → đã trừ hao trong timeline
- Thiếu demo account → reviewer reject ngay → chuẩn bị sẵn account từ Phase 0
