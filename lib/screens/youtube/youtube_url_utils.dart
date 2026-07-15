/// Trích `video_id` từ các dạng URL YouTube phổ biến (watch?v=, youtu.be/,
/// shorts/, embed/) hoặc chấp nhận thẳng một videoId 11 ký tự.
final _videoIdPattern = RegExp(r'^[a-zA-Z0-9_-]{11}$');

String? extractYouTubeVideoId(String input) {
  final trimmed = input.trim();
  if (trimmed.isEmpty) return null;
  if (_videoIdPattern.hasMatch(trimmed)) return trimmed;

  final uri = Uri.tryParse(trimmed);
  if (uri == null) return null;

  final host = uri.host.replaceFirst('www.', '');
  if (host == 'youtu.be') {
    final id = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
    return id != null && _videoIdPattern.hasMatch(id) ? id : null;
  }
  if (host == 'youtube.com' || host == 'm.youtube.com') {
    final vParam = uri.queryParameters['v'];
    if (vParam != null && _videoIdPattern.hasMatch(vParam)) return vParam;
    for (final prefix in ['shorts', 'embed', 'live']) {
      final idx = uri.pathSegments.indexOf(prefix);
      if (idx != -1 && idx + 1 < uri.pathSegments.length) {
        final id = uri.pathSegments[idx + 1];
        if (_videoIdPattern.hasMatch(id)) return id;
      }
    }
  }
  return null;
}
