import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:deutschtiger/services/event_tracking.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('telemetry metadata keeps aggregate values and drops content', () {
    final metadata = EventTracking.sanitizeMetadata({
      'rounds': 3,
      'success': true,
      'ratio': 0.75,
      'draft': 'Ich möchte heute einen langen Text schreiben.',
      'recording_path': '/data/user/0/deutschtiger/audio.m4a',
      'audio_url': 'https://audio.example.test/private.mp3',
      'access_token': 'eyJhbGciOiJIUzI1NiJ9.payload.signature',
      'actions': [
        {'action': 'complete', 'count': 3},
      ],
    });

    expect(metadata, {'rounds': 3, 'success': true, 'ratio': 0.75});
  });

  test('telemetry metadata rejects invalid keys and non-finite numbers', () {
    final metadata = EventTracking.sanitizeMetadata({
      'valid_count': 2,
      'raw text': 1,
      'nested': {'count': 2},
      'not_a_number': double.nan,
    });

    expect(metadata, {'valid_count': 2});
  });

  test('telemetry drops content-like event names and sources', () {
    final tracking = EventTracking(
      apiClient: ApiClient(
        baseUrl: 'https://example.test/api/v1',
        tokenProvider: _NoTokenProvider(),
      ),
    );
    addTearDown(tracking.dispose);

    tracking.track('mission_completed', source: 'mission_action_queue');
    tracking.track(
      'Mein Entwurf enthält private Lerninhalte',
      source: 'mission_action_queue',
    );
    tracking.track('mission_completed', source: '/data/user/0/audio.m4a');

    expect(tracking.pendingCount, 1);
  });
}

class _NoTokenProvider implements TokenProvider {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> refresh() async => null;
}
