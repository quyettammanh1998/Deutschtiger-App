import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App preferences model.
class AppPreferences {
  final double ttsVolume;
  final bool autoPlayAudio;
  final int reminderHour;
  final int reminderMinute;
  final String appLanguage;

  const AppPreferences({
    this.ttsVolume = 0.8,
    this.autoPlayAudio = true,
    this.reminderHour = 8,
    this.reminderMinute = 0,
    this.appLanguage = 'vi',
  });

  AppPreferences copyWith({
    double? ttsVolume,
    bool? autoPlayAudio,
    int? reminderHour,
    int? reminderMinute,
    String? appLanguage,
  }) {
    return AppPreferences(
      ttsVolume: ttsVolume ?? this.ttsVolume,
      autoPlayAudio: autoPlayAudio ?? this.autoPlayAudio,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
      appLanguage: appLanguage ?? this.appLanguage,
    );
  }
}

/// Preferences notifier.
class PreferencesNotifier extends Notifier<AppPreferences> {
  @override
  AppPreferences build() {
    unawaited(_loadAsync());
    return const AppPreferences();
  }

  static const _ttsVolumeKey = 'tts_volume';
  static const _autoPlayKey = 'auto_play_audio';
  static const _reminderHourKey = 'reminder_hour';
  static const _reminderMinuteKey = 'reminder_minute';
  static const _languageKey = 'app_language';

  bool _hasLocalMutation = false;

  Future<void> _loadAsync() async {
    final prefs = await SharedPreferences.getInstance();
    if (_hasLocalMutation) return;
    state = AppPreferences(
      ttsVolume: prefs.getDouble(_ttsVolumeKey) ?? 0.8,
      autoPlayAudio: prefs.getBool(_autoPlayKey) ?? true,
      reminderHour: prefs.getInt(_reminderHourKey) ?? 8,
      reminderMinute: prefs.getInt(_reminderMinuteKey) ?? 0,
      appLanguage: prefs.getString(_languageKey) ?? 'vi',
    );
  }

  Future<void> setTtsVolume(double volume) async {
    _hasLocalMutation = true;
    state = state.copyWith(ttsVolume: volume);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_ttsVolumeKey, volume);
  }

  Future<void> setAutoPlayAudio(bool enabled) async {
    _hasLocalMutation = true;
    state = state.copyWith(autoPlayAudio: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_autoPlayKey, enabled);
  }

  Future<void> setReminderTime(int hour, int minute) async {
    _hasLocalMutation = true;
    state = state.copyWith(reminderHour: hour, reminderMinute: minute);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_reminderHourKey, hour);
    await prefs.setInt(_reminderMinuteKey, minute);
  }

  Future<void> setLanguage(String languageCode) async {
    _hasLocalMutation = true;
    state = state.copyWith(appLanguage: languageCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }
}

final preferencesProvider =
    NotifierProvider<PreferencesNotifier, AppPreferences>(
      PreferencesNotifier.new,
    );

/// TTS Volume provider.
final ttsVolumeProvider = Provider<double>((ref) {
  return ref.watch(preferencesProvider).ttsVolume;
});

/// Auto-play audio provider.
final autoPlayAudioProvider = Provider<bool>((ref) {
  return ref.watch(preferencesProvider).autoPlayAudio;
});

/// Reminder time provider.
final reminderTimeProvider = Provider<({int hour, int minute})>((ref) {
  final prefs = ref.watch(preferencesProvider);
  return (hour: prefs.reminderHour, minute: prefs.reminderMinute);
});

/// App language provider.
final appLanguageProvider = Provider<String>((ref) {
  return ref.watch(preferencesProvider).appLanguage;
});
