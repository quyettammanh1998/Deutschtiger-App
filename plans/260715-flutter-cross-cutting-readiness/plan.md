---
title: 'Flutter Cross-Cutting Readiness — Security, Access, Data, Automation'
description: >-
  Release gates ngang: secrets/privacy, accessibility/i18n,
  live-data/offline/export, fidelity/integration/CI.
status: in-progress
priority: P0
branch: main
tags:
  - flutter
  - security
  - privacy
  - accessibility
  - i18n
  - quality
  - release
blockedBy: []
blocks:
  - 260710-1644-flutter-port-phase-0-to-8
created: '2026-07-14T18:50:27.770Z'
createdBy: 'ck:plan'
source: skill
---

# Flutter Cross-Cutting Readiness — Security, Access, Data, Automation

## Overview

Khắc phục các gap xuyên suốt mà inventory màn hình không thể tự phát hiện. Plan
này bắt đầu song song với contract reconciliation, nhưng các gate của nó chặn
store submission và việc bật GĐ2 features trong master plan.

## Evidence baseline

- `lib/core/translation/translation_service.dart` gọi trực tiếp DeepL với
  `DEEPL_API_KEY` từ `dart-define`; đây là provider secret không được đi vào
  binary mobile.
- Có `lib/l10n/i18n_service.dart`, nhưng chỉ là map nhỏ; không có ARB/generated
  localization, semantic/text-scale test hay phase a11y hoàn chỉnh.
- Test hiện là unit/widget; chưa có `integration_test/`, CI workflow hoặc
  automation fidelity (`Playwright` → Flutter capture → `odiff`).
- Nhiều route-reachable repositories/screens vẫn chứa mock/placeholder. Offline
  mới là banner/retry, chưa có policy durable data/sync. Backend đã có plan
  export dữ liệu nhưng Flutter chưa có flow export.

## Scope boundary

- Không đưa credential private vào mobile. Supabase anon key và RevenueCat SDK
  public key là identifiers client-side được vendor thiết kế để lộ; service keys
  và provider API keys thì không.
- Không hứa full offline writing/review nếu backend chưa có idempotency/conflict
  contract. Phase 3 bắt đầu bằng quyết định strategy.
- Không tự mở tablet/iPad ở GĐ2. Phase 2 ghi quyết định scope và test matrix
  trước bất kỳ thay đổi target device family nào.

## Phases

| Phase | Name | Status |
|-------|------|--------|
| 1 | [Security and Privacy Boundaries](./phase-01-security-and-privacy-boundaries.md) | In Progress |
| 2 | [Accessibility, Localization and Device Scope](./phase-02-accessibility-localization-and-device-scope.md) | In Progress |
| 3 | [Live Data, Offline and Data Portability](./phase-03-live-data-offline-and-data-portability.md) | In Progress |
| 4 | [Fidelity, Integration and Release Automation](./phase-04-fidelity-integration-and-release-automation.md) | In Progress |

## Dependencies

- Blocks [Flutter Port Phase 0–8](../260710-1644-flutter-port-phase-0-to-8/plan.md): Phase 6 store submission cannot complete until all four release gates have evidence.
- Works alongside [Contract Reconciliation](../260715-flutter-contract-reconciliation/plan.md). Account deletion/export and offline writing/exam drafts must reuse its API ownership/idempotency rules.
- Extends [GĐ2 Extended Coverage](../260715-flutter-gd2-extended-coverage/plan.md): media, writing and social release gates consume the capability work here.

## Definition of complete

- [ ] No private provider credential/direct provider authorization exists in the Flutter release binary or source tree.
- [ ] Enabled flows are accessible, localized according to supported locale scope, and tested under large text and screen readers.
- [ ] Every release-visible screen uses live data or an explicit fixture-only/dev-only source; offline/export behavior is documented and testable.
- [ ] CI proves analysis, unit/widget/integration/fidelity gates and produces a signed, reproducible candidate without leaking secrets.
