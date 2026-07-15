import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

/// GĐ2 — Mic recording service.
///
/// Wraps the `record` package with permission handling and lifecycle management.
/// Port of `use-recording.ts` web pattern (start/stop/cancel states).
class RecordingService {
  RecordingService._();
  static final RecordingService instance = RecordingService._();

  final _recorder = AudioRecorder();
  String? _outputPath;

  /// Request mic permission. Returns true if granted.
  Future<bool> requestPermission() async {
    if (kIsWeb) return false;
    final status = await Permission.microphone.request();
    return status == PermissionStatus.granted;
  }

  /// Current permission status without requesting.
  Future<MicPermissionState> checkPermission() async {
    if (kIsWeb) return MicPermissionState.denied;
    final status = await Permission.microphone.status;
    if (status.isGranted) return MicPermissionState.granted;
    if (status.isPermanentlyDenied) return MicPermissionState.permanentlyDenied;
    return MicPermissionState.denied;
  }

  Future<bool> get isRecording => _recorder.isRecording();

  /// Start recording — saves to temp file. Returns path on start.
  Future<String?> startRecording() async {
    final hasPermission = await requestPermission();
    if (!hasPermission) return null;

    final dir = await getTemporaryDirectory();
    _outputPath = '${dir.path}/dt_recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 128000, sampleRate: 44100),
      path: _outputPath!,
    );
    return _outputPath;
  }

  /// Stop recording and return the file path.
  Future<String?> stopRecording() async {
    final path = await _recorder.stop();
    return path ?? _outputPath;
  }

  /// Cancel recording — deletes the temp file.
  Future<void> cancelRecording() async {
    await _recorder.cancel();
    if (_outputPath != null) {
      final file = File(_outputPath!);
      if (await file.exists()) await file.delete();
    }
    _outputPath = null;
  }

  void dispose() {
    _recorder.dispose();
  }
}

enum MicPermissionState { granted, denied, permanentlyDenied }
