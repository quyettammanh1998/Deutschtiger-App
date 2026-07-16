import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../features/journey/domain/course_models.dart';
import '../../../l10n/app_localizations.dart';

/// Self-hosted (mp4) or YouTube-embedded lesson video — web parity: the
/// `<video>`/YouTube-iframe branch in `course-lesson-page.tsx`.
///
/// DEVIATION (documented, no `video_player` package in this repo — see
/// report): mp4 playback uses [WebViewController] loading a minimal HTML5
/// `<video controls>` page (native browser chrome, no custom
/// completion-button-under-player skin); a JS bridge posts `time:cur:dur`
/// and `ended` messages so [onProgress]/[onEnded] can drive the 80%-watch
/// completion gate. YouTube fallback uses the same WebView with an
/// `<iframe>` embed (official player, no download/cache — same compliance
/// posture as `youtube_player_iframe`) but does NOT wire watch-progress
/// (rare path — DW course videos are effectively always self-hosted mp4);
/// its completion button is available immediately.
class CourseVideoPlayer extends StatefulWidget {
  const CourseVideoPlayer({
    super.key,
    required this.video,
    required this.resumeSeconds,
    required this.onProgress,
    required this.onEnded,
    required this.onTimeUpdate,
  });

  final DwLessonVideo video;
  final int resumeSeconds;
  final ValueChanged<double> onProgress;
  final VoidCallback onEnded;
  final ValueChanged<int> onTimeUpdate;

  @override
  State<CourseVideoPlayer> createState() => CourseVideoPlayerState();
}

class CourseVideoPlayerState extends State<CourseVideoPlayer> {
  // Nullable + lazily created: a lesson can have a [DwLessonVideo] with
  // neither `mp4` nor `youtubeId` populated (no playable source yet) — in
  // that case we must not touch `WebViewController` at all, since
  // constructing one asserts on `WebViewPlatform.instance` being registered
  // (only true on-device; plain `flutter test` has no platform channel).
  WebViewController? _controller;

  /// Seeks the self-hosted `<video>` to [seconds] and resumes playback —
  /// called by the transcript panel's tap-to-seek. No-op for the YouTube
  /// iframe fallback (postMessage protocol not wired, see class doc).
  void seekTo(double seconds) {
    if (!widget.video.isSelfHosted) return;
    _controller?.runJavaScript(
      'var v=document.getElementById("v"); if(v){v.currentTime=$seconds; v.play().catch(function(){});}',
    );
  }

  @override
  void initState() {
    super.initState();
    if (!widget.video.isSelfHosted && !widget.video.isYoutube) return;
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..addJavaScriptChannel('CourseBridge', onMessageReceived: _onMessage)
      ..loadHtmlString(_buildHtml());
  }

  void _onMessage(JavaScriptMessage message) {
    final parts = message.message.split(':');
    if (parts.isEmpty) return;
    switch (parts.first) {
      case 'time':
        if (parts.length < 3) return;
        final current = double.tryParse(parts[1]) ?? 0;
        final duration = double.tryParse(parts[2]) ?? 0;
        widget.onTimeUpdate(current.round());
        if (duration > 0) widget.onProgress((current / duration).clamp(0, 1));
      case 'ended':
        widget.onEnded();
    }
  }

  String _buildHtml() {
    if (widget.video.isSelfHosted) {
      final src = jsonEncode(widget.video.mp4);
      final poster = widget.video.poster != null ? jsonEncode(widget.video.poster) : 'null';
      final resume = widget.resumeSeconds;
      return '''
<!DOCTYPE html><html><head><meta name="viewport" content="width=device-width,initial-scale=1">
<style>html,body{margin:0;padding:0;background:#000;} video{width:100%;height:100%;display:block;}</style>
</head><body>
<video id="v" controls playsinline preload="metadata" poster=$poster src=$src></video>
<script>
var v = document.getElementById('v');
var lastSent = 0;
v.addEventListener('loadedmetadata', function () { if ($resume > 0) { v.currentTime = $resume; } });
v.addEventListener('timeupdate', function () {
  var now = Date.now();
  if (now - lastSent > 1500 && v.duration && isFinite(v.duration)) {
    lastSent = now;
    CourseBridge.postMessage('time:' + v.currentTime + ':' + v.duration);
  }
});
v.addEventListener('ended', function () { CourseBridge.postMessage('ended'); });
</script>
</body></html>''';
    }
    final youtubeId = widget.video.youtubeId ?? '';
    return '''
<!DOCTYPE html><html><head><meta name="viewport" content="width=device-width,initial-scale=1">
<style>html,body{margin:0;padding:0;background:#000;overflow:hidden;}
.wrap{position:relative;width:100%;padding-top:56.25%;}
iframe{position:absolute;top:0;left:0;width:100%;height:100%;border:0;}</style>
</head><body>
<div class="wrap"><iframe src="https://www.youtube.com/embed/$youtubeId" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
</body></html>''';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    if (!widget.video.isSelfHosted && !widget.video.isYoutube) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: tokens.muted,
          alignment: Alignment.center,
          child: Text(l10n.coursesLessonNoVideo, style: TextStyle(color: tokens.mutedForeground)),
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: WebViewWidget(controller: _controller!),
      ),
    );
  }
}
