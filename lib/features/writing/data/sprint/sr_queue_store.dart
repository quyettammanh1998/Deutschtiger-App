import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/sprint/sprint_types.dart';

/// Local SR queue persistence — web parity `card-queue.ts`
/// `loadQueue`/`saveQueue`/`clearQueue` (localStorage key
/// `sprint:goethe-b1-writing:v2`). `SRCardState.due` is an absolute ISO
/// timestamp, so simply reloading this from disk on each screen's `initState`
/// is restart-safe with no background timer — verified 17/07 against web's
/// `sm2-scheduler.ts`.
class SrQueueStore {
  static const _key = 'sprint_goethe_b1_writing_sr_queue_v2';

  Future<SRQueue?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;
    try {
      return SRQueue.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      await prefs.remove(_key);
      return null;
    }
  }

  Future<void> save(SRQueue queue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(queue.toJson()));
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
