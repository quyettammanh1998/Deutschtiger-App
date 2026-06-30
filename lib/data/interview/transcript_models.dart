// Models for transcript functionality

/// Model cho transcript cua video YouTube.
class TranscriptSegment {
  const TranscriptSegment({
    required this.startMs,
    required this.endMs,
    required this.textDe,
    this.textVi,
  });

  final int startMs;
  final int endMs;
  final String textDe;
  final String? textVi;

  factory TranscriptSegment.fromJson(Map<String, dynamic> json) {
    // Parse start_time/end_time (co the la ISO duration hoac seconds)
    int parseTime(dynamic value) {
      if (value is int) return value * 1000; // seconds to ms
      if (value is double) return (value * 1000).round(); // seconds to ms
      if (value is String) {
        // ISO 8601 duration: PT1M30S
        if (value.startsWith('PT')) {
          final regex = RegExp(r'PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?');
          final match = regex.firstMatch(value);
          if (match != null) {
            final hours = int.tryParse(match.group(1) ?? '') ?? 0;
            final minutes = int.tryParse(match.group(2) ?? '') ?? 0;
            final seconds = int.tryParse(match.group(3) ?? '') ?? 0;
            return (hours * 3600 + minutes * 60 + seconds) * 1000;
          }
        }
        // Plain seconds as string
        final seconds = double.tryParse(value);
        if (seconds != null) return (seconds * 1000).round();
      }
      return 0;
    }

    return TranscriptSegment(
      startMs: parseTime(json['start_time']),
      endMs: parseTime(json['end_time']),
      textDe: json['text_de'] as String? ?? '',
      textVi: json['text_vi'] as String?,
    );
  }
}

/// Ket qua transcript day du.
class TranscriptResult {
  const TranscriptResult({
    required this.videoId,
    required this.segments,
    this.title,
  });

  final String videoId;
  final List<TranscriptSegment> segments;
  final String? title;
}

/// Trang thai xu ly transcript.
enum TranscriptStatus {
  idle,
  queued,
  fetching,
  segmenting,
  translating,
  done,
  error,
  temporarilyUnavailable,
}

/// Tien do xu ly transcript.
class TranscriptProgress {
  const TranscriptProgress({
    this.status = TranscriptStatus.idle,
    this.progress = 0,
    this.error,
  });

  final TranscriptStatus status;
  final int progress;
  final String? error;

  factory TranscriptProgress.fromJson(Map<String, dynamic> json) {
    TranscriptStatus parseStatus(String? s) {
      switch (s) {
        case 'queued':
          return TranscriptStatus.queued;
        case 'fetching':
          return TranscriptStatus.fetching;
        case 'segmenting':
          return TranscriptStatus.segmenting;
        case 'translating':
          return TranscriptStatus.translating;
        case 'done':
          return TranscriptStatus.done;
        case 'error':
          return TranscriptStatus.error;
        case 'temporarily_unavailable':
          return TranscriptStatus.temporarilyUnavailable;
        default:
          return TranscriptStatus.idle;
      }
    }

    return TranscriptProgress(
      status: parseStatus(json['status'] as String?),
      progress: (json['progress'] as num?)?.toInt() ?? 0,
      error: json['error'] as String?,
    );
  }
}
