import 'package:deutschtiger/services/api_client.dart';

/// Translates learner text through the authenticated DeutschTiger API.
///
/// Provider credentials stay on backend infrastructure. This client must never
/// call a translation vendor directly or carry a vendor authorization header.
class TranslationService {
  TranslationService(this._apiClient);

  static const _path = '/ai/translate-sentences';

  final ApiClient _apiClient;

  Future<TranslationResult> translate({
    required String text,
    required String targetLang,
    String? sourceLang,
  }) async {
    final results = await translateBatch(
      texts: [text],
      targetLang: targetLang,
      sourceLang: sourceLang,
    );
    return results.single;
  }

  Future<List<TranslationResult>> translateBatch({
    required List<String> texts,
    required String targetLang,
    String? sourceLang,
  }) async {
    if (texts.isEmpty) return const [];

    final normalizedSource = _normalizeLanguage(sourceLang ?? 'de');
    final normalizedTarget = _normalizeLanguage(targetLang);
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        _path,
        body: {
          'sentences': texts,
          'sourceLang': normalizedSource.toLowerCase(),
          'targetLang': normalizedTarget.toLowerCase(),
        },
      );
      return _parseBatchResponse(texts, normalizedSource, response);
    } on ApiException catch (error) {
      return texts
          .map(
            (text) => TranslationResult(
              text: text,
              success: false,
              error: _safeErrorMessage(error.statusCode),
            ),
          )
          .toList(growable: false);
    } catch (_) {
      return texts
          .map(
            (text) => TranslationResult(
              text: text,
              success: false,
              error: 'Lỗi kết nối dịch thuật',
            ),
          )
          .toList(growable: false);
    }
  }

  Future<String?> detectLanguage(String text) async {
    final result = await translate(text: text, targetLang: 'en');
    return result.success ? result.detectedSourceLang : null;
  }

  List<TranslationResult> _parseBatchResponse(
    List<String> texts,
    String sourceLang,
    Map<String, dynamic> response,
  ) {
    final translations = response['translations'];
    if (translations is! List || translations.length != texts.length) {
      return _invalidResponse(texts);
    }
    final failedIndexes = (response['errors'] as List? ?? const [])
        .whereType<num>()
        .map((index) => index.toInt())
        .toSet();

    return List<TranslationResult>.generate(texts.length, (index) {
      final translated = translations[index];
      if (failedIndexes.contains(index) ||
          translated is! String ||
          translated.isEmpty) {
        return TranslationResult(
          text: texts[index],
          detectedSourceLang: sourceLang,
          success: false,
          error: 'Không thể dịch nội dung này. Vui lòng thử lại.',
        );
      }
      return TranslationResult(
        text: translated,
        detectedSourceLang: sourceLang,
        success: true,
      );
    }, growable: false);
  }

  List<TranslationResult> _invalidResponse(List<String> texts) => texts
      .map(
        (text) => TranslationResult(
          text: text,
          success: false,
          error: 'Phản hồi dịch thuật không hợp lệ. Vui lòng thử lại.',
        ),
      )
      .toList(growable: false);

  String _normalizeLanguage(String value) => value.trim().toUpperCase();

  String _safeErrorMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Nội dung hoặc ngôn ngữ dịch không hợp lệ.';
      case 401:
        return 'Vui lòng đăng nhập để dùng tính năng dịch.';
      case 429:
        return 'Bạn đã dùng quá nhiều yêu cầu dịch. Vui lòng thử lại sau.';
      case 503:
        return 'Dịch thuật đang tạm thời không khả dụng. Vui lòng thử lại.';
      default:
        return 'Lỗi kết nối dịch thuật';
    }
  }
}

class TranslationResult {
  const TranslationResult({
    required this.text,
    this.detectedSourceLang,
    required this.success,
    this.error,
  });

  final String text;
  final String? detectedSourceLang;
  final bool success;
  final String? error;
}
