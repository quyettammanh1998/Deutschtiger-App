// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReviewItem _$ReviewItemFromJson(Map<String, dynamic> json) => _ReviewItem(
  id: json['id'] as String,
  learningItemId: json['learning_item_id'] as String? ?? '',
  flashcardId: json['flashcard_id'] as String?,
  contentDe: json['content_de'] as String? ?? '',
  contentVi: json['content_vi'] as String? ?? '',
  audioUrl: json['audio_url'] as String?,
  level: json['level'] as String?,
  examples:
      (json['examples'] as List<dynamic>?)
          ?.map((e) => ReviewExample.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ReviewExample>[],
);

Map<String, dynamic> _$ReviewItemToJson(_ReviewItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'learning_item_id': instance.learningItemId,
      'flashcard_id': instance.flashcardId,
      'content_de': instance.contentDe,
      'content_vi': instance.contentVi,
      'audio_url': instance.audioUrl,
      'level': instance.level,
      'examples': instance.examples,
    };

_ReviewExample _$ReviewExampleFromJson(Map<String, dynamic> json) =>
    _ReviewExample(
      de: json['de'] as String? ?? '',
      vi: json['vi'] as String? ?? '',
      audioUrl: json['audio_url'] as String?,
    );

Map<String, dynamic> _$ReviewExampleToJson(_ReviewExample instance) =>
    <String, dynamic>{
      'de': instance.de,
      'vi': instance.vi,
      'audio_url': instance.audioUrl,
    };
