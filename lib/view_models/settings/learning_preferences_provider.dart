import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/repositories/settings/learning_preferences_repository.dart';

class LearningPreferencesState {
  const LearningPreferencesState({
    this.preferences,
    this.isLoading = true,
    this.isSaving = false,
    this.error,
  });

  final LearningPreferences? preferences;
  final bool isLoading;
  final bool isSaving;
  final String? error;

  LearningPreferencesState copyWith({
    LearningPreferences? preferences,
    bool? isLoading,
    bool? isSaving,
    String? error,
    bool clearError = false,
  }) => LearningPreferencesState(
    preferences: preferences ?? this.preferences,
    isLoading: isLoading ?? this.isLoading,
    isSaving: isSaving ?? this.isSaving,
    error: clearError ? null : (error ?? this.error),
  );
}

class LearningPreferencesNotifier
    extends AutoDisposeNotifier<LearningPreferencesState> {
  @override
  LearningPreferencesState build() {
    // `Future.microtask` (not `unawaited(_load())`) defers the first
    // network call to the next microtask so `build()` always returns and
    // installs the initial state BEFORE `_load()` runs. `unawaited` runs
    // the function body synchronously up to its first `await`; if
    // `ref.read(...)` throws synchronously there (e.g. the repository
    // provider itself fails to construct) the `catch` block's `state = `
    // assignment executes before this `build()` call returns, and
    // Riverpod throws "Tried to read the state of an uninitialized
    // provider" instead of surfacing the real error.
    Future.microtask(_load);
    return const LearningPreferencesState();
  }

  Future<void> _load() async {
    try {
      final prefs = await ref.read(learningPreferencesRepositoryProvider).get();
      state = state.copyWith(preferences: prefs, isLoading: false, clearError: true);
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'load');
    }
  }

  Future<void> save(LearningPreferences updated) async {
    state = state.copyWith(preferences: updated, isSaving: true, clearError: true);
    try {
      final saved = await ref
          .read(learningPreferencesRepositoryProvider)
          .save(updated);
      state = state.copyWith(preferences: saved, isSaving: false);
    } catch (_) {
      state = state.copyWith(isSaving: false, error: 'save');
    }
  }
}

final learningPreferencesProvider = NotifierProvider.autoDispose<
  LearningPreferencesNotifier,
  LearningPreferencesState
>(LearningPreferencesNotifier.new);
