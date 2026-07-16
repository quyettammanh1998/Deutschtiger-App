// ignore_for_file: depend_on_referenced_packages
//
// `webview_flutter_platform_interface` is a transitive dependency (pulled in
// via `webview_flutter`, a direct dependency) that is not re-exported by
// `package:webview_flutter/webview_flutter.dart` — the base
// `PlatformWebViewController`/`PlatformWebViewWidget`/
// `PlatformNavigationDelegate` classes needed to implement a fake platform
// are only available from the platform-interface package directly. Adding
// it as a direct `pubspec.yaml` dependency is out of scope for this test
// helper (pubspec.yaml is append-only/owner-controlled elsewhere).
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

/// Minimal no-op [WebViewPlatform] fake so widget tests can pump screens that
/// embed `youtube_player_iframe`'s `YoutubePlayer` (backed by `webview_flutter`
/// on non-web platforms) without a real platform channel. `flutter test` runs
/// on the Dart VM, where no `webview_flutter_android`/`_wkwebview` platform
/// implementation auto-registers itself (that only happens on-device), so
/// `WebViewPlatform.instance` is null and any real webview construction
/// throws — this fake satisfies just enough of the platform-interface
/// contract (controller + widget construction) for the player widget to
/// build without exercising real JS/navigation behavior.
class FakeWebViewPlatform extends WebViewPlatform {
  @override
  PlatformWebViewController createPlatformWebViewController(
    PlatformWebViewControllerCreationParams params,
  ) => _FakeWebViewController(params);

  @override
  PlatformWebViewWidget createPlatformWebViewWidget(
    PlatformWebViewWidgetCreationParams params,
  ) => _FakeWebViewWidget(params);

  @override
  PlatformNavigationDelegate createPlatformNavigationDelegate(
    PlatformNavigationDelegateCreationParams params,
  ) => _FakeNavigationDelegate(params);
}

class _FakeWebViewController extends PlatformWebViewController {
  _FakeWebViewController(super.params) : super.implementation();

  @override
  Future<void> loadHtmlString(String html, {String? baseUrl}) async {}

  @override
  Future<void> loadRequest(LoadRequestParams params) async {}

  @override
  Future<void> setJavaScriptMode(JavaScriptMode javaScriptMode) async {}

  @override
  Future<void> setBackgroundColor(Color color) async {}

  @override
  Future<void> setPlatformNavigationDelegate(
    PlatformNavigationDelegate handler,
  ) async {}

  // `youtube_player_iframe`'s `YoutubePlayerController` registers a JS
  // channel named after its `playerId` and blocks every subsequent player
  // call (`JsBridge._waitReady`, 30s timeout) until a `{"playerId": ...,
  // "Ready": {}}` message arrives on it — normally sent by the embedded
  // YouTube iframe's JS once loaded. Since this fake never runs real JS,
  // immediately echo that "ready" message back so the controller does not
  // block on (or time out) a handshake that can never happen here.
  @override
  Future<void> addJavaScriptChannel(
    JavaScriptChannelParams javaScriptChannelParams,
  ) async {
    javaScriptChannelParams.onMessageReceived(
      JavaScriptMessage(
        message: jsonEncode({
          'playerId': javaScriptChannelParams.name,
          'Ready': <String, dynamic>{},
        }),
      ),
    );
  }

  @override
  Future<void> removeJavaScriptChannel(String javaScriptChannelName) async {}

  @override
  Future<Object> runJavaScriptReturningResult(String javaScript) async => '';

  @override
  Future<void> runJavaScript(String javaScript) async {}

  @override
  Future<String?> currentUrl() async => null;

  @override
  Future<void> enableZoom(bool enabled) async {}

  @override
  Future<void> setUserAgent(String? userAgent) async {}
}

class _FakeWebViewWidget extends PlatformWebViewWidget {
  _FakeWebViewWidget(super.params) : super.implementation();

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class _FakeNavigationDelegate extends PlatformNavigationDelegate {
  _FakeNavigationDelegate(super.params) : super.implementation();

  @override
  Future<void> setOnNavigationRequest(
    NavigationRequestCallback onNavigationRequest,
  ) async {}

  @override
  Future<void> setOnPageStarted(PageEventCallback onPageStarted) async {}

  @override
  Future<void> setOnPageFinished(PageEventCallback onPageFinished) async {}

  @override
  Future<void> setOnHttpError(HttpResponseErrorCallback onHttpError) async {}

  @override
  Future<void> setOnProgress(ProgressCallback onProgress) async {}

  @override
  Future<void> setOnWebResourceError(
    WebResourceErrorCallback onWebResourceError,
  ) async {}

  @override
  Future<void> setOnUrlChange(UrlChangeCallback onUrlChange) async {}
}
