import 'package:deutschtiger/services/crash_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('diagnostic events reject content-bearing messages', () {
    expect(
      CrashService.sanitizeDiagnosticEvent('translation failed: Hallo Welt'),
      'diagnostic_event',
    );
    expect(
      CrashService.sanitizeDiagnosticEvent('api.http_error.post.429/api/v1/ai'),
      'api.http_error.post.429/api/v1/ai',
    );
  });

  test('crash grouping keeps an error type, not the error text', () {
    expect(
      CrashService.diagnosticErrorType(ArgumentError('learner writing draft')),
      'ArgumentError',
    );
  });
}
