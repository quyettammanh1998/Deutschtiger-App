import 'package:just_audio/just_audio.dart';

import '../network/api_client.dart';

/// Phát âm thanh cho thẻ từ vựng — seam mỏng ở core (KISS).
///
/// Mirror 2 lớp đầu của web (audio_url → tts-cache); bỏ lớp browser-TTS
/// vì Flutter không cần (server đã có Edge TTS). Lớp 3 (on-device TTS)
/// để V2 nếu cần.
class AudioService {
  AudioService(this._api);

  final ApiClient _api;
  final AudioPlayer _player = AudioPlayer();

  /// Phát âm: ưu tiên [audioUrl] có sẵn; nếu không có thì xin server tạo
  /// qua tts-cache cho [text]. Lỗi được nuốt (best-effort, không chặn UI).
  Future<void> play({String? audioUrl, required String text}) async {
    try {
      final url = audioUrl ?? await _fetchTtsUrl(text);
      if (url == null || url.isEmpty) return;
      await _player.setUrl(url);
      await _player.play();
    } catch (_) {
      // best-effort: không làm gián đoạn việc học nếu audio lỗi
    }
  }

  /// Xin URL mp3 từ server cho [text] (Edge TTS cache).
  /// Response bọc trong `data`: { "data": { "url": "...", "cached": bool } }.
  Future<String?> _fetchTtsUrl(String text) async {
    if (text.trim().isEmpty) return null;
    final res = await _api.post<Map<String, dynamic>>(
      '/user/tts/vocab-cache',
      body: {'text': text},
    );
    final data = res['data'];
    if (data is Map<String, dynamic>) return data['url'] as String?;
    return res['url'] as String?; // fallback nếu backend đổi format
  }

  Future<void> stop() => _player.stop();

  void dispose() => _player.dispose();
}
