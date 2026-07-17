import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_tokens.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../data/recording_service.dart';
import '../../domain/voice_providers.dart';

/// GĐ2 — Hold-to-record / tap-toggle record button.
///
/// Shows mic permission soft-explain before first use.
/// Gracefully degrades when permission denied — hides record capability.
class RecordButton extends ConsumerWidget {
  const RecordButton({
    super.key,
    required this.onRecordingComplete,
    this.size = 72,
  });

  /// Called with the local file path when recording is stopped.
  final void Function(String filePath) onRecordingComplete;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recordingProvider);
    final notifier = ref.read(recordingProvider.notifier);

    if (state.permissionState == MicPermissionState.permanentlyDenied) {
      return _PermissionDeniedButton(size: size);
    }

    if (state.permissionState == MicPermissionState.denied) {
      return _RequestPermissionButton(size: size, onTap: notifier.requestPermission);
    }

    final isRecording = state.isRecording;

    // Listen for file ready
    ref.listen<RecordingState>(recordingProvider, (prev, next) {
      if (prev?.filePath == null && next.filePath != null) {
        onRecordingComplete(next.filePath!);
      }
    });

    return GestureDetector(
      onTap: () async {
        if (isRecording) {
          await notifier.stop();
        } else {
          await notifier.start();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isRecording ? DesignTokens.error : DesignTokens.tigerOrange,
          boxShadow: isRecording ? DesignTokens.shadowMd : DesignTokens.shadowSm,
        ),
        child: Icon(
          isRecording ? Icons.stop_rounded : Icons.mic_rounded,
          color: Colors.white,
          size: size * 0.45,
        ),
      ),
    );
  }
}

class _RequestPermissionButton extends StatelessWidget {
  const _RequestPermissionButton({required this.size, required this.onTap});
  final double size;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.tokens.muted,
            ),
            child: Icon(Icons.mic_off_rounded, color: context.tokens.mutedForeground),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Cho phép mic để ghi âm',
          style: TextStyle(fontSize: 12, color: context.tokens.mutedForeground),
        ),
      ],
    );
  }
}

class _PermissionDeniedButton extends StatelessWidget {
  const _PermissionDeniedButton({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(shape: BoxShape.circle, color: context.tokens.muted),
          child: Icon(Icons.mic_off_rounded, color: context.tokens.mutedForeground),
        ),
        const SizedBox(height: 8),
        Text(
          'Cần cấp quyền mic trong Cài đặt',
          style: TextStyle(fontSize: 12, color: context.tokens.mutedForeground),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
