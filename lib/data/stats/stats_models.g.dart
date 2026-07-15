// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReviewStats _$ReviewStatsFromJson(Map<String, dynamic> json) => _ReviewStats(
  totalReviews: (json['total_reviews'] as num?)?.toInt() ?? 0,
  wordsLearned: (json['words_learned'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ReviewStatsToJson(_ReviewStats instance) =>
    <String, dynamic>{
      'total_reviews': instance.totalReviews,
      'words_learned': instance.wordsLearned,
    };

_XpDailyLogEntry _$XpDailyLogEntryFromJson(Map<String, dynamic> json) =>
    _XpDailyLogEntry(
      logDate: DateTime.parse(json['log_date'] as String),
      xpEarned: (json['xp_earned'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$XpDailyLogEntryToJson(_XpDailyLogEntry instance) =>
    <String, dynamic>{
      'log_date': instance.logDate.toIso8601String(),
      'xp_earned': instance.xpEarned,
    };

_MasterySummary _$MasterySummaryFromJson(Map<String, dynamic> json) =>
    _MasterySummary(
      newCount: (json['new'] as num?)?.toInt() ?? 0,
      learning: (json['learning'] as num?)?.toInt() ?? 0,
      young: (json['young'] as num?)?.toInt() ?? 0,
      mature: (json['mature'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$MasterySummaryToJson(_MasterySummary instance) =>
    <String, dynamic>{
      'new': instance.newCount,
      'learning': instance.learning,
      'young': instance.young,
      'mature': instance.mature,
      'total': instance.total,
    };

_SrsDailyStat _$SrsDailyStatFromJson(Map<String, dynamic> json) =>
    _SrsDailyStat(
      date: json['date'] as String,
      reviewsCount: (json['reviews_count'] as num?)?.toInt() ?? 0,
      retentionRate: (json['retention_rate'] as num?)?.toDouble(),
      lapses: (json['lapses'] as num?)?.toInt() ?? 0,
      newCardsAdded: (json['new_cards_added'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$SrsDailyStatToJson(_SrsDailyStat instance) =>
    <String, dynamic>{
      'date': instance.date,
      'reviews_count': instance.reviewsCount,
      'retention_rate': instance.retentionRate,
      'lapses': instance.lapses,
      'new_cards_added': instance.newCardsAdded,
    };

_ErrorPatternSummary _$ErrorPatternSummaryFromJson(Map<String, dynamic> json) =>
    _ErrorPatternSummary(
      errorType: json['error_type'] as String,
      totalCount: (json['total_count'] as num?)?.toInt() ?? 0,
      lastSeen: json['last_seen'] == null
          ? null
          : DateTime.parse(json['last_seen'] as String),
      exampleOriginal: json['example_original'] as String?,
      exampleCorrected: json['example_corrected'] as String?,
      sources:
          (json['sources'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$ErrorPatternSummaryToJson(
  _ErrorPatternSummary instance,
) => <String, dynamic>{
  'error_type': instance.errorType,
  'total_count': instance.totalCount,
  'last_seen': instance.lastSeen?.toIso8601String(),
  'example_original': instance.exampleOriginal,
  'example_corrected': instance.exampleCorrected,
  'sources': instance.sources,
};
