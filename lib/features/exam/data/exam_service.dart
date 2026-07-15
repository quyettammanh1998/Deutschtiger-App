// ignore_for_file: prefer_initializing_formals
//
// Exam service — gọi BE thật (`deutschtiger-backend`) và map JSON → domain
// models trong `exam_models.dart`.
//
// BE endpoints (public, no auth — xem `cmd/server/routes_public.go`):
//   GET /exams/{slug}              → ExamSetMeta (title/level/provider/parts[])
//   GET /exams/{slug}/parts/{id}   → ExamData (1 skill/part: sections[].items[])
//
// Khác biệt cấu trúc quan trọng so với `Exam.fromJson`:
//   - 1 ExamSet gồm nhiều Part (mỗi Part = 1 kỹ năng: Lesen HOẶC Hören), mỗi
//     Part lại có nhiều TEIL con (section) chứa items. `Exam` (Flutter) gộp
//     Lesen + Hören thành 2 `ExamSection` phẳng trong 1 đề — nên phải fetch
//     2 part rồi flatten `sections[].items[]` của mỗi part thành 1 danh sách
//     question phẳng.
//   - BE question `type` (`true_false`, `multiple_choice`, `matching`,
//     `dropdown`, `image`, ...) KHÔNG trùng tên với `QuestionType` Flutter
//     (mc/matching/richtigFalsch/sprachbausteine/anzeigen) — xem mapping chi
//     tiết + các giới hạn đã biết trong `_mapItem`.
//   - "matching"/"image" items có thể kèm 1 ảnh minh họa (`image_url`, 1 ảnh
//     / item — verify qua sample thật) → map vào `ExamQuestion.imageUrl`.
//   - `correct_answer` trong BE luôn là index 0-based vào mảng `options` (đã
//     verify qua sample thật `docs/exam-authoring/goethe-b1/*.sample.json`),
//     KHÔNG phải id dạng chữ cái như sample fixture cũ.

import '../../../services/api_client.dart';
import '../domain/exam_models.dart';

/// Fetch + map exam content từ BE. GĐ1 chỉ hỗ trợ 2 kỹ năng Lesen + Hören —
/// part nào có skill khác (Schreiben/Sprechen) sẽ bị bỏ qua.
class ExamService {
  ExamService(this._api);

  final ApiClient _api;

  Future<List<ExamCatalogItem>> listExamSets({
    String? provider,
    String? level,
  }) async {
    final data = await _api.get<List<dynamic>>(
      '/exams',
      query: {'published': 'true', 'provider': ?provider, 'level': ?level},
    );
    return data
        .whereType<Map>()
        .map(
          (item) => ExamCatalogItem.fromJson(Map<String, dynamic>.from(item)),
        )
        .where((item) => item.hasSupportedPart)
        .toList();
  }

  /// Trả về 1 [Exam] đầy đủ (Lesen + Hören, nếu có) cho 1 exam set [slug].
  ///
  /// Ném [ApiException] nếu set không tồn tại (404 từ BE) hoặc set không có
  /// part Lesen/Hören nào khả dụng.
  Future<Exam> fetchExam(String slug) async {
    final setJson = await _api.get<Map<String, dynamic>>('/exams/$slug');
    final partsRaw = (setJson['parts'] as List?) ?? const [];
    final parts = partsRaw.cast<Map<String, dynamic>>();

    final lesenParts = _findParts(parts, const [
      'lesen',
      'reading',
      'đọc',
      'grammar',
      'sprach',
    ]);
    final hoerenParts = _findParts(parts, const [
      'hör',
      'hor',
      'listening',
      'nghe',
    ]);

    if (lesenParts.isEmpty && hoerenParts.isEmpty) {
      throw ApiException(
        'Đề thi "$slug" chưa có phần Lesen hoặc Hören khả dụng.',
      );
    }

    final sections = <ExamSection>[];
    if (lesenParts.isNotEmpty) {
      final section = await _fetchCombinedSection(
        slug,
        lesenParts,
        ExamSectionKind.lesen,
      );
      if (section.questions.isNotEmpty) sections.add(section);
    }
    if (hoerenParts.isNotEmpty) {
      final section = await _fetchCombinedSection(
        slug,
        hoerenParts,
        ExamSectionKind.hoeren,
      );
      if (section.questions.isNotEmpty) sections.add(section);
    }
    if (sections.isEmpty) {
      throw ApiException('Đề thi "$slug" chưa có câu Lesen/Hören hỗ trợ.');
    }

    return Exam(
      id: slug,
      title: (setJson['title'] as String?) ?? slug,
      level: ((setJson['level'] as String?) ?? '').toLowerCase(),
      provider: ((setJson['provider'] as String?) ?? '').toLowerCase(),
      sections: sections,
    );
  }

  List<Map<String, dynamic>> _findParts(
    List<Map<String, dynamic>> parts,
    List<String> skillKeywords,
  ) {
    final matches = <Map<String, dynamic>>[];
    for (final part in parts) {
      final skill = (part['skill'] as String?)?.toLowerCase() ?? '';
      if (skillKeywords.any((kw) => skill.contains(kw))) matches.add(part);
    }
    return matches;
  }

  Future<ExamSection> _fetchCombinedSection(
    String slug,
    List<Map<String, dynamic>> partRefs,
    ExamSectionKind kind,
  ) async {
    final sections = await Future.wait(
      partRefs.map((part) => _fetchSection(slug, part, kind)),
    );
    return ExamSection(
      kind: kind,
      questions: sections.expand((section) => section.questions).toList(),
      durationMinutes: sections.fold(
        0,
        (sum, section) => sum + section.durationMinutes,
      ),
    );
  }

  Future<ExamSection> _fetchSection(
    String slug,
    Map<String, dynamic> partRef,
    ExamSectionKind kind,
  ) async {
    final partId = partRef['id'] as String;
    final partJson = await _api.get<Map<String, dynamic>>(
      '/exams/$slug/parts/$partId',
    );
    return _mapPartToSection(partJson, kind, partId);
  }

  ExamSection _mapPartToSection(
    Map<String, dynamic> partJson,
    ExamSectionKind kind,
    String partId,
  ) {
    final sectionsRaw = (partJson['sections'] as List?) ?? const [];
    final questions = <ExamQuestion>[];

    for (
      var sectionIndex = 0;
      sectionIndex < sectionsRaw.length;
      sectionIndex++
    ) {
      final secDyn = sectionsRaw[sectionIndex];
      final sec = secDyn as Map<String, dynamic>;
      final itemsRaw = (sec['items'] as List?) ?? const [];
      // Hören: BE lưu URL audio dùng chung cho cả TEIL ở `section.instruction`;
      // mỗi item cũng lặp lại URL này ở `item.audio_url` (đã verify qua sample
      // thật) — ưu tiên đọc trực tiếp từ item để không phụ thuộc field nào
      // thiếu.
      final maxPlays = (sec['max_plays'] as num?)?.toInt() ?? 2;

      for (final itemDyn in itemsRaw) {
        final item = itemDyn as Map<String, dynamic>;
        final question = _mapItem(
          item,
          sectionMaxPlays: maxPlays,
          contentReference: _contentReference(
            partId: partId,
            sectionIndex: sectionIndex,
            entryId: _asInt(item['entry_id']),
          ),
        );
        if (question != null) questions.add(question);
      }
    }

    final durationMinutes = (partJson['duration'] as num?)?.round() ?? 0;
    return ExamSection(
      kind: kind,
      questions: questions,
      durationMinutes: durationMinutes,
    );
  }

  /// Map 1 BE question item → [ExamQuestion]. Trả về null nếu type không thể
  /// hiển thị được với renderer hiện có (GĐ1 chỉ có 5 renderer) — câu hỏi đó
  /// bị bỏ qua thay vì làm crash player.
  ExamQuestion? _mapItem(
    Map<String, dynamic> item, {
    required int sectionMaxPlays,
    required String? contentReference,
  }) {
    final type = (item['type'] as String?) ?? '';
    final entryId = item['entry_id'];
    final id = 'q${entryId ?? item.hashCode}';
    final options = _mapOptions(item['options']);
    final correctIdx = _asInt(item['correct_answer']);
    final correctOptionId =
        (correctIdx != null && correctIdx >= 0 && correctIdx < options.length)
        ? correctIdx.toString()
        : null;
    final explanation = item['explanation_vi'] as String?;
    final audioUrl = item['audio_url'] as String?;
    final prompt = _buildPrompt(item);

    switch (type) {
      case 'true_false':
        // BE quy ước options luôn là ["Richtig","Falsch"] (index 0 = đúng) —
        // verify qua sample thật `goethe-b1/reading.sample.json` +
        // `listening.sample.json`.
        return ExamQuestion(
          id: id,
          contentReference: contentReference,
          type: QuestionType.richtigFalsch,
          prompt: prompt,
          correctBoolean: correctIdx == 0,
          audioUrl: audioUrl,
          audioMaxPlays: sectionMaxPlays,
          explanation: explanation,
        );

      case 'multiple_choice':
        return ExamQuestion(
          id: id,
          contentReference: contentReference,
          type: item['image_url'] == null
              ? QuestionType.mc
              : QuestionType.anzeigen,
          prompt: prompt,
          options: options,
          correctOptionId: correctOptionId,
          audioUrl: audioUrl,
          audioMaxPlays: sectionMaxPlays,
          explanation: explanation,
          imageUrl: item['image_url'] as String?,
        );

      case 'matching':
      case 'image':
        // BE "matching"/"image" thực tế là chọn 1 option đúng từ danh sách
        // (kèm ảnh/anzeige minh họa qua `image_url`/`image_text`) — KHÔNG phải
        // dạng nối cột trái-phải mà `QuestionType.matching` (Flutter) mong
        // đợi. Map sang `anzeigen` vì cùng UI chọn-1-đáp-án (xem
        // `question_anzeigen.dart` — tái dùng MC renderer). `image_text` đã
        // được gộp vào `prompt` (`_buildPrompt`); `image_url` (ảnh minh họa
        // Teil 3, verify per-item 1:1 qua sample thật
        // `goethe-b1/reading.sample.json`) map vào field `imageUrl` để
        // `question_anzeigen.dart` render.
        return ExamQuestion(
          id: id,
          contentReference: contentReference,
          type: QuestionType.anzeigen,
          prompt: prompt,
          options: options,
          correctOptionId: correctOptionId,
          audioUrl: audioUrl,
          audioMaxPlays: sectionMaxPlays,
          explanation: explanation,
          imageUrl: item['image_url'] as String?,
        );

      case 'dropdown':
        if (correctIdx == null) return null;
        return ExamQuestion(
          id: id,
          contentReference: contentReference,
          type: QuestionType.sprachbausteine,
          prompt: prompt,
          options: options,
          gapPositions: [correctIdx],
          audioUrl: audioUrl,
          audioMaxPlays: sectionMaxPlays,
          explanation: explanation,
        );

      case 'form_fill':
      case 'open_text':
      case 'speaking_prompt':
        // Không có renderer free-text/speaking trong GĐ1 (Lesen/Hören only).
        // Nếu có option, fallback MC; nếu không, bỏ qua câu hỏi.
        if (options.isEmpty) return null;
        return ExamQuestion(
          id: id,
          contentReference: contentReference,
          type: QuestionType.mc,
          prompt: prompt,
          options: options,
          correctOptionId: correctOptionId,
          audioUrl: audioUrl,
          audioMaxPlays: sectionMaxPlays,
          explanation: explanation,
        );

      default:
        return null;
    }
  }

  List<ExamOption> _mapOptions(dynamic raw) {
    final list = (raw as List?) ?? const [];
    return [
      for (var i = 0; i < list.length; i++)
        ExamOption(id: i.toString(), text: list[i].toString()),
    ];
  }

  /// Ghép `description` (đoạn văn/transcript ngữ cảnh) + `image_text` (nội
  /// dung anzeigen Teil 3, nếu có) + `title` (câu hỏi thật) thành 1 prompt duy
  /// nhất — `QuestionCardFrame` chỉ render `SelectableText` thuần, không hỗ
  /// trợ HTML nên phải strip tag `<b>`/`<#bold>` trước khi hiển thị.
  String _buildPrompt(Map<String, dynamic> item) {
    final title = ((item['title'] as String?) ?? '').trim();
    final description = item['description'] as String?;
    final imageText = item['image_text'] as String?;

    final buffer = StringBuffer();
    if (description != null && description.trim().isNotEmpty) {
      buffer
        ..writeln(_stripTags(description.trim()))
        ..writeln();
    }
    if (imageText != null && imageText.trim().isNotEmpty) {
      buffer
        ..writeln(imageText.trim())
        ..writeln();
    }
    buffer.write(title);
    return buffer.toString().trim();
  }

  static final _tagRegex = RegExp(r'<[^>]*>');

  String _stripTags(String s) => s.replaceAll(_tagRegex, '');

  int? _asInt(dynamic v) {
    if (v is int) return v;
    if (v is double) return v.round();
    if (v is String) return int.tryParse(v);
    if (v is num) return v.round();
    return null;
  }

  String? _contentReference({
    required String partId,
    required int sectionIndex,
    required int? entryId,
  }) {
    if (entryId == null ||
        !RegExp(r'^[A-Za-z0-9_-]{1,128}$').hasMatch(partId)) {
      return null;
    }
    return '$partId/$sectionIndex/$entryId';
  }
}

class ExamCatalogItem {
  const ExamCatalogItem({
    required this.slug,
    required this.title,
    required this.titleVi,
    required this.provider,
    required this.level,
    required this.parts,
  });

  final String slug;
  final String title;
  final String? titleVi;
  final String provider;
  final String level;
  final List<ExamCatalogPart> parts;

  bool get hasSupportedPart => parts.any((part) => part.isSupported);
  int get totalQuestions => parts
      .where((part) => part.isSupported)
      .fold(0, (sum, part) => sum + part.totalQuestions);
  int get durationMinutes => parts
      .where((part) => part.isSupported)
      .fold(0, (sum, part) => sum + part.durationMinutes);

  factory ExamCatalogItem.fromJson(Map<String, dynamic> json) {
    final rawParts = json['parts'];
    return ExamCatalogItem(
      slug: json['slug'] as String? ?? '',
      title: json['title'] as String? ?? '',
      titleVi: json['title_vi'] as String?,
      provider: (json['provider'] as String? ?? '').toLowerCase(),
      level: (json['level'] as String? ?? '').toUpperCase(),
      parts: rawParts is List
          ? rawParts
                .whereType<Map>()
                .map(
                  (part) =>
                      ExamCatalogPart.fromJson(Map<String, dynamic>.from(part)),
                )
                .toList()
          : const [],
    );
  }
}

class ExamCatalogPart {
  const ExamCatalogPart({
    required this.skill,
    required this.durationMinutes,
    required this.totalQuestions,
  });

  final String skill;
  final int durationMinutes;
  final int totalQuestions;

  bool get isSupported {
    final value = skill.toLowerCase();
    return value.contains('lesen') ||
        value.contains('reading') ||
        value.contains('grammar') ||
        value.contains('sprach') ||
        value.contains('hör') ||
        value.contains('hor') ||
        value.contains('listening');
  }

  factory ExamCatalogPart.fromJson(Map<String, dynamic> json) {
    return ExamCatalogPart(
      skill: json['skill'] as String? ?? '',
      durationMinutes: (json['duration'] as num?)?.toInt() ?? 0,
      totalQuestions: (json['total_questions'] as num?)?.toInt() ?? 0,
    );
  }
}
