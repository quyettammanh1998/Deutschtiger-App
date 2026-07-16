/// Shared `{de, vi, audioUrl}` shape reused across most topic-detail
/// sections — web parity: every leaf sentence object in
/// `GoetheB1WritingTopic` (`types.ts`) carries this trio (+ optional
/// `audioVoice`, dropped here — Flutter's [AudioService] doesn't select a
/// TTS voice per line).
class AudioSentence {
  const AudioSentence({required this.de, required this.vi, this.audioUrl});

  final String de;
  final String vi;
  final String? audioUrl;

  factory AudioSentence.fromJson(Map<String, dynamic> json) => AudioSentence(
        de: json['de']?.toString() ?? '',
        vi: json['vi']?.toString() ?? '',
        audioUrl: json['audioUrl']?.toString(),
      );

  static List<AudioSentence> listFromJson(Object? raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => AudioSentence.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
