import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/app_colors.dart';

/// Reminder settings.
class ReminderSettings {
  final bool enabled;
  final int hour;
  final int minute;
  final List<int> days;

  const ReminderSettings({
    this.enabled = true,
    this.hour = 8,
    this.minute = 0,
    this.days = const [1, 2, 3, 4, 5, 6, 7],
  });

  ReminderSettings copyWith({
    bool? enabled,
    int? hour,
    int? minute,
    List<int>? days,
  }) {
    return ReminderSettings(
      enabled: enabled ?? this.enabled,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      days: days ?? this.days,
    );
  }

  Map<String, dynamic> toJson() => {
    'enabled': enabled,
    'hour': hour,
    'minute': minute,
    'days': days,
  };

  factory ReminderSettings.fromJson(Map<String, dynamic> json) {
    return ReminderSettings(
      enabled: json['enabled'] ?? true,
      hour: json['hour'] ?? 8,
      minute: json['minute'] ?? 0,
      days: (json['days'] as List?)?.cast<int>() ?? [1, 2, 3, 4, 5, 6, 7],
    );
  }
}

/// Reminder notifier.
class ReminderNotifier extends Notifier<ReminderSettings> {
  @override
  ReminderSettings build() => const ReminderSettings();

  static const _key = 'reminder_settings';

  @override
  ReminderSettings get state {
    _loadAsync();
    return super.state;
  }

  Future<void> _loadAsync() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_key);
    if (json != null) {
      try {
        final map = _parseSimpleJson(json);
        state = ReminderSettings.fromJson(map);
      } catch (_) {
        // Keep default
      }
    }
  }

  Map<String, dynamic> _parseSimpleJson(String json) {
    final result = <String, dynamic>{};
    final enabledMatch = RegExp(r'"enabled":\s*(true|false)').firstMatch(json);
    if (enabledMatch != null) {
      result['enabled'] = enabledMatch.group(1) == 'true';
    }
    final hourMatch = RegExp(r'"hour":\s*(\d+)').firstMatch(json);
    if (hourMatch != null) {
      result['hour'] = int.parse(hourMatch.group(1)!);
    }
    final minuteMatch = RegExp(r'"minute":\s*(\d+)').firstMatch(json);
    if (minuteMatch != null) {
      result['minute'] = int.parse(minuteMatch.group(1)!);
    }
    return result;
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = '{"enabled": ${state.enabled}, "hour": ${state.hour}, "minute": ${state.minute}, "days": ${state.days}}';
    await prefs.setString(_key, jsonStr);
  }

  void setEnabled(bool enabled) {
    state = state.copyWith(enabled: enabled);
    _save();
  }

  void setTime(int hour, int minute) {
    state = state.copyWith(hour: hour, minute: minute);
    _save();
  }

  void toggleDay(int day) {
    final days = List<int>.from(state.days);
    if (days.contains(day)) {
      if (days.length > 1) {
        days.remove(day);
      }
    } else {
      days.add(day);
      days.sort();
    }
    state = state.copyWith(days: days);
    _save();
  }
}

final reminderProvider =
    NotifierProvider<ReminderNotifier, ReminderSettings>(ReminderNotifier.new);

/// Màn reminder settings.
class ReminderSettingsScreen extends ConsumerWidget {
  const ReminderSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(reminderProvider);

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: const Text(
          'Nhắc nhở học tập',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.tigerOrange,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: SwitchListTile(
              title: const Text('Bật nhắc nhở'),
              subtitle: const Text('Nhận thông báo hàng ngày'),
              value: settings.enabled,
              onChanged: (value) {
                ref.read(reminderProvider.notifier).setEnabled(value);
              },
              activeTrackColor: AppColors.tigerOrange,
              thumbColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.tigerOrange;
                }
                return null;
              }),
            ),
          ),
          if (settings.enabled) ...[
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text('Giờ nhắc nhở'),
                subtitle: Text(
                  '${settings.hour.toString().padLeft(2, '0')}:${settings.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(
                      hour: settings.hour,
                      minute: settings.minute,
                    ),
                  );
                  if (time != null) {
                    ref
                        .read(reminderProvider.notifier)
                        .setTime(time.hour, time.minute);
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Ngày trong tuần',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Wrap(
                      spacing: 8,
                      children: [
                        _DayChip(
                          label: 'T2',
                          day: 1,
                          isSelected: settings.days.contains(1),
                          onTap: () => ref
                              .read(reminderProvider.notifier)
                              .toggleDay(1),
                        ),
                        _DayChip(
                          label: 'T3',
                          day: 2,
                          isSelected: settings.days.contains(2),
                          onTap: () => ref
                              .read(reminderProvider.notifier)
                              .toggleDay(2),
                        ),
                        _DayChip(
                          label: 'T4',
                          day: 3,
                          isSelected: settings.days.contains(3),
                          onTap: () => ref
                              .read(reminderProvider.notifier)
                              .toggleDay(3),
                        ),
                        _DayChip(
                          label: 'T5',
                          day: 4,
                          isSelected: settings.days.contains(4),
                          onTap: () => ref
                              .read(reminderProvider.notifier)
                              .toggleDay(4),
                        ),
                        _DayChip(
                          label: 'T6',
                          day: 5,
                          isSelected: settings.days.contains(5),
                          onTap: () => ref
                              .read(reminderProvider.notifier)
                              .toggleDay(5),
                        ),
                        _DayChip(
                          label: 'T7',
                          day: 6,
                          isSelected: settings.days.contains(6),
                          onTap: () => ref
                              .read(reminderProvider.notifier)
                              .toggleDay(6),
                        ),
                        _DayChip(
                          label: 'CN',
                          day: 7,
                          isSelected: settings.days.contains(7),
                          onTap: () => ref
                              .read(reminderProvider.notifier)
                              .toggleDay(7),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.label,
    required this.day,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final int day;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.tigerOrange : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.tigerOrange : AppColors.border,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.foreground,
            ),
          ),
        ),
      ),
    );
  }
}
