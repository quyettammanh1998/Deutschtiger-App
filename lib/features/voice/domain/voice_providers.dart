import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/recording_service.dart';

/// Recording session state.
class RecordingState {
  const RecordingState({
    this.isRecording = false,
    this.filePath,
    this.permissionState = MicPermissionState.denied,
    this.error,
  });

  final bool isRecording;
  final String? filePath;
  final MicPermissionState permissionState;
  final String? error;

  bool get hasFile => filePath != null;
  bool get canRecord => permissionState == MicPermissionState.granted;
}

class RecordingNotifier extends AutoDisposeNotifier<RecordingState> {
  @override
  RecordingState build() {
    ref.onDispose(() => RecordingService.instance.dispose());
    _checkPermission();
    return const RecordingState();
  }

  Future<void> _checkPermission() async {
    final status = await RecordingService.instance.checkPermission();
    state = RecordingState(permissionState: status);
  }

  Future<void> requestPermission() async {
    final granted = await RecordingService.instance.requestPermission();
    final status = await RecordingService.instance.checkPermission();
    state = RecordingState(permissionState: status, error: granted ? null : 'Không có quyền mic.');
  }

  Future<void> start() async {
    if (state.isRecording) return;
    final path = await RecordingService.instance.startRecording();
    if (path == null) {
      state = RecordingState(
        permissionState: state.permissionState,
        error: 'Không thể bắt đầu ghi âm.',
      );
      return;
    }
    state = RecordingState(isRecording: true, permissionState: state.permissionState);
  }

  Future<void> stop() async {
    if (!state.isRecording) return;
    final path = await RecordingService.instance.stopRecording();
    state = RecordingState(
      permissionState: state.permissionState,
      filePath: path,
    );
  }

  Future<void> cancel() async {
    await RecordingService.instance.cancelRecording();
    state = RecordingState(permissionState: state.permissionState);
  }
}

final recordingProvider =
    NotifierProvider.autoDispose<RecordingNotifier, RecordingState>(
  RecordingNotifier.new,
);
