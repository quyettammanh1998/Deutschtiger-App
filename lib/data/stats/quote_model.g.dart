// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Quote _$QuoteFromJson(Map<String, dynamic> json) => _Quote(
  id: json['id'] as String,
  contentDe: json['content_de'] as String?,
  contentVi: json['content_vi'] as String? ?? '',
  category: json['category'] as String? ?? '',
);

Map<String, dynamic> _$QuoteToJson(_Quote instance) => <String, dynamic>{
  'id': instance.id,
  'content_de': instance.contentDe,
  'content_vi': instance.contentVi,
  'category': instance.category,
};
