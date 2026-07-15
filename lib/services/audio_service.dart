import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';

import 'api_client.dart';

/// Phát âm thanh cho thẻ từ vựng — seam mỏng ở core (KISS).
///
/// Chain: recorded URL → server TTS cache → on-device German TTS.
class AudioService {
  AudioService(this._api, {AudioPlayer? player, FlutterTts? tts})
    : _player = player ?? AudioPlayer(),
      _tts = tts ?? FlutterTts();

  final ApiClient _api;
  final AudioPlayer _player;
  final FlutterTts _tts;

  /// Phát âm: ưu tiên [audioUrl] có sẵn; nếu không có thì xin server tạo
  /// qua tts-cache cho [text], cuối cùng dùng TTS có sẵn trên thiết bị.
  /// Trả `true` khi một tầng playback đã khởi động thành công.
  Future<bool> play({String? audioUrl, required String text}) async {
    await stop();

    final recordedUrl = audioUrl?.trim();
    if (recordedUrl != null && recordedUrl.isNotEmpty) {
      if (await _playUrl(recordedUrl)) return true;
    }

    final normalizedText = text.trim();
    if (normalizedText.isEmpty) return false;

    try {
      final cachedUrl = await _fetchTtsUrl(normalizedText);
      if (cachedUrl != null && cachedUrl.isNotEmpty) {
        if (await _playUrl(cachedUrl)) return true;
      }
    } catch (_) {
      // Server TTS is optional; continue with on-device TTS.
    }

    try {
      await _tts.setLanguage('de-DE');
      await _tts.setSpeechRate(0.45);
      return await _tts.speak(normalizedText) == 1;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _playUrl(String url) async {
    try {
      await _player.setUrl(url);
      await _player.play();
      return true;
    } catch (_) {
      return false;
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

  Future<void> stop() async {
    await _player.stop();
    await _tts.stop();
  }

  Future<void> dispose() async {
    await stop();
    await _player.dispose();
  }
}
