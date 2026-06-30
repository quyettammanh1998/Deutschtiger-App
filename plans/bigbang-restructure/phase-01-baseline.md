---
phase: 1
title: "Baseline & Preparation"
status: pending
priority: P1
effort: 1h
dependencies: []
---

# Phase 1: Baseline & Preparation

## Overview
Establish baseline metrics and create TDD tests for directory structure verification.

## Requirements
- Functional: Record current flutter analyze and test output
- Non-functional: Must establish failure threshold before restructure

## Architecture
```
test/structure/
├── directory_structure_test.dart    # TDD: Verify target dirs exist
└── import_verification_test.dart    # TDD: Verify imports resolve
```

## Related Code Files
- Create: `test/structure/directory_structure_test.dart`
- Create: `test/structure/import_verification_test.dart`
- Create: `baseline_analysis.txt` (output)
- Create: `baseline_test_results.txt` (output)

## Implementation Steps

### 1.1: Establish Baseline
1. Run `flutter analyze > baseline_analysis.txt 2>&1`
2. Run `flutter test > baseline_test_results.txt 2>&1`
3. Commit: `git add -A && git commit -m "chore: capture pre-restructure baseline"`

### 1.2: Create Directory Structure Tests (TDD)
1. Create `test/structure/` directory
2. Write `directory_structure_test.dart` with tests for all target directories
3. Write `import_verification_test.dart` to detect broken imports
4. Create empty directories (tests will fail)
5. Run tests to verify they fail

## Success Criteria
- [ ] `baseline_analysis.txt` captures current warnings/errors
- [ ] `baseline_test_results.txt` captures test status
- [ ] Structure tests fail (directories don't exist)
- [ ] Tests are meaningful

## Risk Assessment
- **Risk:** Low - Read-only operations
- **Mitigation:** None needed
