import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:deutschtiger/services/config/app_config.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Màn học qua WebView - hiển thị nội dung bài học từ website.
class WebViewLessonScreen extends ConsumerStatefulWidget {
  const WebViewLessonScreen({
    super.key,
    required this.lessonId,
    this.title,
  });

  final String lessonId;
  final String? title;

  @override
  ConsumerState<WebViewLessonScreen> createState() => _WebViewLessonScreenState();
}

class _WebViewLessonScreenState extends ConsumerState<WebViewLessonScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  double _loadingProgress = 0;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initWebViewController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Nền native WebView phải set sau khi có context (initState chưa có
    // theme) và set lại mỗi lần đổi sáng/tối.
    _controller.setBackgroundColor(context.tokens.background);
  }

  void _initWebViewController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _loadingProgress = progress / 100;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _hasError = false;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _hasError = true;
              _isLoading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url;
            if (url.startsWith('https://deutschtiger.com') ||
                url.startsWith('https://www.deutschtiger.com') ||
                url.startsWith('https://api.deutschtiger.com')) {
              return NavigationDecision.navigate;
            }
            _openInBrowser(request.url);
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse(_lessonUrl));
  }

  String get _lessonUrl {
    return '${AppConfig.webviewBaseUrl}/lessons/${widget.lessonId}';
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        backgroundColor: tokens.background,
        title: Text(
          widget.title ?? 'Bài học',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.tigerOrange,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(PhosphorIcons.arrowLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(PhosphorIcons.arrowClockwise),
            onPressed: () => _controller.reload(),
            tooltip: 'Tải lại',
          ),
          IconButton(
            icon: const Icon(PhosphorIcons.arrowSquareOut),
            onPressed: () => _openInBrowser(_lessonUrl),
            tooltip: 'Mở trong trình duyệt',
          ),
        ],
      ),
      body: _hasError ? _buildErrorView(context) : _buildWebView(context),
    );
  }

  Widget _buildWebView(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading)
          LinearProgressIndicator(
            value: _loadingProgress,
            backgroundColor: context.tokens.border,
            valueColor: const AlwaysStoppedAnimation(AppColors.tigerOrange),
            minHeight: 3,
          ),
      ],
    );
  }

  Widget _buildErrorView(BuildContext context) {
    final tokens = context.tokens;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              PhosphorIcons.warning,
              size: 64,
              color: tokens.destructive,
            ),
            const SizedBox(height: 16),
            const Text(
              'Không thể tải bài học',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Vui lòng kiểm tra kết nối internet và thử lại.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: tokens.mutedForeground,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _hasError = false;
                  _isLoading = true;
                });
                _controller.reload();
              },
              icon: const Icon(PhosphorIcons.arrowClockwise),
              label: const Text('Thử lại'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => _openInBrowser(_lessonUrl),
              child: const Text('Mở trong trình duyệt'),
            ),
          ],
        ),
      ),
    );
  }

  void _openInBrowser(String url) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mở: $url')),
    );
  }
}
