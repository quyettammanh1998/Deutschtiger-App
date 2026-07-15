import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:deutschtiger/services/dictionary_service.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/shared/widgets/word_lookup_sheet.dart';
import 'package:deutschtiger/view_models/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('saving an example sentence posts the learning-item payload', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final client = _RecordingApiClient();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [apiClientProvider.overrideWithValue(client)],
        child: MaterialApp(
          locale: const Locale('de'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          builder: (context, child) => MediaQuery(
            data: const MediaQueryData(
              size: Size(360, 800),
              textScaler: TextScaler.linear(2),
            ),
            child: child!,
          ),
          home: const Scaffold(
            body: WordLookupSheet(
              entry: WordEntry(
                id: 'haus-1',
                word: 'Haus',
                meanings: ['nhà'],
                examples: [
                  WordExample(de: 'Das ist mein Haus.', vi: 'Đây là nhà tôi.'),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.widgetWithText(TextButton, 'Satz speichern'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 200));

    expect(client.path, '/user/learning-items');
    expect(client.body, {
      'type': 'sentence',
      'content_de': 'Das ist mein Haus.',
      'content_vi': 'Đây là nhà tôi.',
      'category': 'dictionary',
    });
    expect(find.text('Satz gespeichert'), findsOneWidget);
    expect(find.text('Bedeutung'), findsOneWidget);
    expect(find.text('Beispiel'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class _NoTokenProvider implements TokenProvider {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> refresh() async => null;
}

class _RecordingApiClient extends ApiClient {
  _RecordingApiClient()
    : super(
        baseUrl: 'https://example.test/api/v1',
        tokenProvider: _NoTokenProvider(),
      );

  String? path;
  Object? body;

  @override
  Future<T> post<T>(String path, {Object? body}) async {
    this.path = path;
    this.body = body;
    return <String, dynamic>{} as T;
  }

  @override
  Future<T> get<T>(String path, {Map<String, dynamic>? query}) {
    throw UnimplementedError();
  }

  @override
  Future<T> put<T>(String path, {Object? body}) {
    throw UnimplementedError();
  }

  @override
  Future<T> delete<T>(String path, {Object? body}) {
    throw UnimplementedError();
  }
}
