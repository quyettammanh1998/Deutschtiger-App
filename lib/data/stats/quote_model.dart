import 'package:freezed_annotation/freezed_annotation.dart';

part 'quote_model.freezed.dart';
part 'quote_model.g.dart';

/// Câu nói tạo động lực (Đức + dịch Việt). `GET /api/v1/quotes*`.
@freezed
abstract class Quote with _$Quote {
  const factory Quote({
    required String id,
    @JsonKey(name: 'content_de') String? contentDe,
    @JsonKey(name: 'content_vi') @Default('') String contentVi,
    @Default('') String category,
  }) = _Quote;

  factory Quote.fromJson(Map<String, dynamic> json) => _$QuoteFromJson(json);
}
