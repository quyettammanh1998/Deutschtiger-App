# Plan Validation Report: Big Bang Directory Restructure

**Plan:** `plans/bigbang-restructure/plan.md`
**Validated:** 2026-06-30
**Status:** ⚠️ APPROVED WITH CONDITIONS

---

## Executive Summary

The plan is well-structured with proper TDD methodology, rollback procedures, and clear phase dependencies. However, **6 critical gaps** and **12 open questions** must be resolved before implementation to avoid cascading failures during Phase 9 (Import Fixes).

---

## 1. Confirmed Strengths ✓

| Area | Assessment |
|------|------------|
| **TDD Approach** | Tests written before each phase - follows best practices |
| **Rollback Procedures** | Every phase has `git checkout` rollback documented |
| **Dependency Chain** | Linear phases prevent circular dependency issues |
| **Reference Repo Verified** | Target structure matches `/home/qtm/Desktop/flutter-accelerator-ai/` |
| **File Count Accurate** | 250 Dart files confirmed via Glob |
| **Git History Preservation** | Uses `git mv` throughout - maintains blame/l_history |

---

## 2. Critical Gaps to Address

### Gap 1: `lib/core/identity/` Not Addressed

**Location:** `lib/core/identity/` contains 4 files
- `app_user.dart`
- `app_user.freezed.dart`
- `app_user.g.dart`
- `profile_repository.dart`

**Problem:** Plan does not mention these files. `profile_repository.dart` is listed in Phase 4 (Repositories) but the directory itself is not documented.

**Recommended Fix:**
```bash
# Phase 2 or 4
git mv lib/core/identity/profile_repository.dart lib/repositories/
# Delete empty lib/core/identity/ directory
```

---

### Gap 2: Missing Feature Widget Subdirectories

**Location:** Phase 5b does not enumerate all widget directories

**Plan Lists:**
- `ai`, `auth`, `dashboard`, `exam`, `flashcard`, `grammar`, `home`, `interview`, `journey`, `listening`, `profile`, `quiz`, `social`, `speaking`, `stats`

**Confirmed Existing (via Glob):**
- `lib/features/ai/widgets/` (chat_history_sidebar.dart)
- `lib/features/speaking/widgets/` (pronunciation_practice_widget.dart)
- `lib/features/flashcard/presentation/widgets/` (rating_bar.dart)

**Missing from Plan:**
- `lib/features/flashcard/presentation/widgets/` → `lib/widgets/flashcard/`
- `lib/features/ai_tutor/presentation/widgets/` → `lib/widgets/ai_tutor/`

---

### Gap 3: `home/domain/` Not Documented

**Location:** `lib/features/home/domain/`

**Files:**
- `dashboard_data.dart`
- `dashboard_data.freezed.dart`
- `dashboard_data.g.dart`

**Problem:** Plan only mentions `features/home/data/` (Phase 4) but not `features/home/domain/`.

**Recommended Fix:** Add to Phase 3 (Data Layer):
```bash
git mv lib/features/home/domain/* lib/data/home/
```

---

### Gap 4: `vocabulary_search` Features Split Across Phases

**Location:** `lib/features/vocabulary_search/`

**Files:**
- `data/vocabulary_repository.dart` → Phase 4 (Repositories)
- `data/vocab_notes_repository.dart` → Phase 4 (Repositories)
- `domain/vocab_models.dart` → Phase 3 (Data)

**Problem:** Plan does not document this feature's `data/` and `domain/` directories separately.

**Recommended Fix:** Document explicitly in Phases 3 and 4.

---

### Gap 5: `interview` Data Directory Split

**Location:** `lib/features/interview/data/`

**Files (confirmed via Glob):**
- `interview_repository.dart` ✓
- `video_notes_repository.dart` ✓
- `transcript_service.dart` ← NOT in plan

**Problem:** `transcript_service.dart` is not listed in any phase.

**Recommended Fix:** Add to Phase 4 (Repositories):
```bash
git mv lib/features/interview/data/transcript_service.dart lib/repositories/interview/
```

---

### Gap 6: `webview` Feature Missing

**Location:** `lib/features/webview/`

**Files:**
- `presentation/webview_lesson_screen.dart`

**Problem:** Not listed in Phase 5 (Screens).

**Recommended Fix:** Add to Phase 5 screen list:
```bash
mkdir -p lib/screens/webview
git mv lib/features/webview/presentation/* lib/screens/webview/
```

---

## 3. Missing Files/Directories in Plan

The following files/directories exist in the codebase but are **not mentioned** in any phase:

| File/Directory | Phase Where It Should Appear |
|----------------|------------------------------|
| `lib/core/identity/` directory | Phase 2 or delete empty |
| `lib/core/audio/audio_service.dart` | Phase 2 (listed, but verify) |
| `lib/features/home/domain/` | Phase 3 (Data) |
| `lib/features/vocabulary_search/data/vocab_notes_repository.dart` | Phase 4 (Repositories) |
| `lib/features/interview/data/transcript_service.dart` | Phase 4 (Repositories) |
| `lib/features/webview/presentation/` | Phase 5 (Screens) |
| `lib/features/flashcard/presentation/widgets/` | Phase 5b (Widgets) |
| `lib/features/ai_tutor/presentation/widgets/` | Phase 5b (Widgets) |
| `lib/features/stats/presentation/` (partial) | Phase 5 (Screens) |

---

## 4. Dependencies Analysis

### Verified Dependency Chain ✓

```
Phase 1 → Phase 2 → Phase 3 → Phase 4 → Phase 5 → Phase 6 → Phase 7 → Phase 8 → Phase 9 → Phase 10
```

**Dependency Rationale:**
- Phase 1: Establishes baseline (no deps)
- Phase 2: Creates `lib/services/` (needed for Phase 9 imports)
- Phase 3: Creates `lib/data/` (needed for Phase 9 imports)
- Phase 4: Creates `lib/repositories/` (needed for Phase 9 imports)
- Phase 5: Creates `lib/screens/` and `lib/widgets/` (needed for Phase 9 imports)
- Phase 6: Creates `lib/view_models/` (needed for Phase 9 imports)
- Phase 7: Creates `lib/l10n/` (needed for Phase 9 imports)
- Phase 8: Creates `lib/navigation/` (needed for Phase 9 imports)
- Phase 9: **BLOCKER** - Updates all imports (requires all moves complete)
- Phase 10: Verifies (requires Phase 9 complete)

**Critical Path:** 10 phases, 22h estimated

---

## 5. Test Coverage Matrix

| Phase | Structure Tests | Integration Tests | Manual Verification |
|-------|-----------------|-------------------|---------------------|
| 1 | ✓ `directory_structure_test.dart` | ✗ None | ✓ Baseline capture |
| 2 | ✓ `core_to_services_migration_test.dart` | ✗ None | ✓ `flutter analyze` |
| 3 | ✓ `data_layer_migration_test.dart` | ✗ None | ✓ `flutter analyze` |
| 4 | ✓ `repositories_layer_test.dart` | ✗ None | ✓ `flutter analyze` |
| 5 | ✓ `screens_layer_test.dart`, `widgets_layer_test.dart` | ✗ None | ✓ `flutter analyze` |
| 6 | ✓ `view_models_layer_test.dart` | ✗ None | ✓ `flutter analyze` |
| 7 | ✓ `l10n_layer_test.dart` | ✗ None | ✓ `flutter analyze` |
| 8 | ✓ `navigation_layer_test.dart` | ✗ None | ✓ `flutter analyze` |
| 9 | ✗ None | ✗ None | ✓ `flutter analyze` |
| 10 | ✗ None | ✓ Full test suite | ✓ Smoke test |

### Test Gap: No Import Chain Tests

**Problem:** Phase 1's `import_verification_test.dart` is defined but only checks for broken relative imports. It does **not** verify that package imports (`package:deutschtiger/...`) resolve correctly.

**Recommendation:** Add to Phase 9:
```dart
test('All package imports resolve', () {
  // For each .dart file, parse imports and verify files exist
});
```

---

## 6. Rollback Procedures - Verification

| Phase | Rollback Command | Verified |
|-------|------------------|----------|
| 1 | `git checkout HEAD -- lib/` | ✓ |
| 2 | `git checkout HEAD -- lib/core/ lib/services/` | ✓ |
| 3 | `git checkout HEAD -- lib/features/ lib/data/` | ⚠️ Incomplete - does not restore deleted `domain/` dirs |
| 4 | `git checkout HEAD -- lib/features/ lib/repositories/ lib/core/identity/` | ⚠️ Incomplete |
| 5 | `git checkout HEAD -- lib/features/ lib/screens/ lib/widgets/ lib/shared/` | ⚠️ Incomplete |
| 6 | (not documented) | ✗ Missing |
| 7 | (not documented) | ✗ Missing |
| 8 | (not documented) | ✗ Missing |
| 9 | `git checkout HEAD -- lib/` | ✓ |
| 10 | `git checkout HEAD -- lib/` | ✓ |

**Issue:** Phases 3-8 rollback commands are incomplete because they don't account for files that were **deleted** (empty directories removed). Git cannot restore deleted directories - only files that were moved.

**Recommendation:** For Phases 3-8, add:
```bash
# Restore from previous commit
git checkout HEAD~1 -- lib/features/
```

---

## 7. Risk Assessment

| Phase | Risk | Likelihood | Impact | Mitigation |
|-------|------|------------|--------|------------|
| 1 | Low | - | - | Read-only |
| 2 | Medium | High | High | `lib/core/providers.dart` import chain broken |
| 3 | Medium | Medium | Medium | 15+ domain dirs to move |
| 4 | Medium | Medium | Medium | 17 repositories to move |
| 5 | High | High | High | 86 presentation files + widgets |
| 6 | Medium | Medium | Medium | 16 provider files + providers.dart |
| 7 | Low | Low | Low | Single directory move |
| 8 | Low | Low | Low | Single file move |
| 9 | High | Very High | Critical | ~250 files need import updates |
| 10 | Low | Low | Low | Verification only |

### Highest Risk: Phase 9 (Import Fixes)

**Problem:** The migration script in Phase 9 uses **string replacement** on exact import paths. This will fail for:
1. Imports using relative paths
2. Imports with trailing slashes or variations
3. Conditional imports
4. Missing mappings (files not enumerated)

**Recommended Improvement:**
```dart
// Use regex patterns instead of exact strings
final mappings = [
  (RegExp(r"import\s+'package:deutschtiger/core/auth/(\w+)\.dart'"),
   (m) => "import 'package:deutschtiger/services/${m.group(1)}.dart'"),
  // ...
];
```

---

## 8. Open Questions Requiring Resolution

### Q1: Generated Files (.freezed.dart, .g.dart)

**Current:** Plan says "move" but doesn't specify destination.

**Options:**
1. Move with source files to maintain relative imports
2. Keep generated files in original location, update imports to reference new paths
3. Regenerate after move (requires `build_runner`)

**Recommendation:** Option 2 - Keep generated files in original location, update imports in Phase 9.

---

### Q2: `lib/features/` Directory - Delete or Keep Empty?

**Current:** Not specified.

**Options:**
1. Delete entirely (cleaner, but breaks git history for those paths)
2. Keep as empty reference (easier rollback)

**Recommendation:** Keep empty directories for rollback ease, delete after Phase 10.

---

### Q3: Barrel Exports - Maintain or Remove?

**Current:** Plan creates barrel exports (`data.dart`, `repositories.dart`, etc.)

**Options:**
1. Maintain barrel exports (easier imports, but extra maintenance)
2. Remove (simpler, but requires updating all imports)

**Recommendation:** Maintain barrel exports. They match reference repo pattern and reduce Phase 9 import changes.

---

### Q4: Feature Subdirectories in `lib/screens/`

**Current:** Plan keeps subdirectories (`lib/screens/ai/`, `lib/screens/exam/`, etc.)

**Options:**
1. Keep subdirectories (organized, matches reference)
2. Flatten entirely (simpler, but loses feature grouping)

**Recommendation:** Keep subdirectories - they match reference repo.

---

### Q5: `lib/core/` Cleanup After All Moves

**Current:** Plan keeps some files in `lib/core/` (design_tokens, theme, i18n)

**Question:** Should `lib/core/` be renamed to `lib/shared/` or kept as-is?

**Recommendation:** Keep as `lib/core/` - matches reference repo pattern.

---

### Q6: Widget Categorization

**Current:** Plan uses `lib/widgets/common/` for shared widgets.

**Question:** Should feature-specific widgets use their feature name (`lib/widgets/ai/`) or a flat structure?

**Recommendation:** Use feature subdirectories (`lib/widgets/ai/`, `lib/widgets/exam/`) - matches plan's architecture.

---

### Q7: `lib/shared/` Directory

**Current:** Plan moves `lib/shared/widgets/` to `lib/widgets/common/`

**Question:** What happens to other files in `lib/shared/` (if any)?

**Recommendation:** Verify if other `lib/shared/` subdirectories exist. If only widgets, delete empty parent.

---

### Q8: Provider Imports in `lib/core/providers.dart`

**Current:** Uses relative imports after Phase 2 services move.

**Example (line 4-10):**
```dart
import 'audio/audio_service.dart';
import 'auth/auth_service.dart';
import 'auth/token_provider.dart';
```

**After Phase 2:** These imports will be:
```dart
import 'services/audio_service.dart';
import 'services/auth_service.dart';
import 'services/auth_provider.dart';
```

**Recommendation:** Update Phase 2 to include `lib/core/providers.dart` in the import fix step, OR update providers.dart imports in Phase 2.

---

## 9. Recommendations

### Priority 1 (Must Fix Before Implementation)

1. **Add Phase 6-8 rollback commands** to the plan
2. **Document all missing files** (Gap 1-6 above)
3. **Clarify generated file handling** (Q1)
4. **Update Phase 2 to include `lib/core/providers.dart` import fixes**

### Priority 2 (Should Fix)

5. Add import chain tests to Phase 9
6. Improve Phase 9 migration script with regex patterns
7. Document Phase 10 rollback properly

### Priority 3 (Nice to Have)

8. Add integration tests for each phase
9. Create automated rollback verification tests
10. Document git tag strategy for each phase completion

---

## 10. Verification Checklist

Before starting implementation, confirm:

- [x] Reference repo structure verified (`/home/qtm/Desktop/flutter-accelerator-ai/`)
- [x] Current file count verified (250 Dart files)
- [x] All existing directories enumerated
- [x] Generated files (.freezed.dart, .g.dart) strategy decided
- [x] Barrel export strategy confirmed
- [x] Rollback commands verified for completeness
- [ ] Missing files (Gap 1-6) documented in plan
- [ ] Open questions (Q1-Q8) resolved

---

## Conclusion

**Status:** APPROVED WITH CONDITIONS

The plan is well-structured and follows best practices (TDD, rollback procedures, linear dependencies). However, implementation should not begin until:

1. All 6 critical gaps are addressed
2. Open questions Q1-Q8 are resolved
3. Missing files are enumerated in the plan

**Estimated Fix Time:** 1-2 hours to update plan documentation
**Risk After Fixes:** Medium (acceptable for this scope)
