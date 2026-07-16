import 'writing_topic/grammar_wortschatz_mistakes.dart';
import 'writing_topic/phrases_samples_models.dart';
import 'writing_topic/task_section.dart';
import 'writing_topic/uebungen_exercise.dart';
import 'writing_topic/writing_source.dart';

/// Full topic-detail payload — web parity `GoetheB1WritingTopic`
/// (`src/lib/goethe-b1-writing/types.ts`). Backend:
/// `GET /goethe-b1-writing/topic/{n}/{slug}` (public, no auth).
///
/// This is intentionally one flat class (not split per-section) since every
/// field maps 1:1 to a JSON key from a single response and the detail page
/// reads them as one unit; the *sub*-objects (task analysis points, useful
/// phrases, …) are the ones split into `writing_topic/*.dart`.
class GoetheB1WritingTopic {
  const GoetheB1WritingTopic({
    required this.slug,
    required this.teil,
    required this.titleDe,
    required this.titleVi,
    required this.bodyMarkdown,
    this.isIntro = false,
    this.isStub = false,
    this.difficulty,
    this.frequencyStars = 0,
    this.topicKeywords = const [],
    this.durationMin,
    this.textType,
    this.examDates = const [],
    this.taskWordCount,
    this.sources = const [],
    this.lastReviewed,
    this.task,
    this.taskVariant,
    this.taskAnalysis,
    this.textStructure = const [],
    this.usefulPhrases = const [],
    this.sampleSentences = const [],
    this.modelAnswers = const [],
    this.grammarFocus = const [],
    this.wortschatzBox,
    this.commonMistakes = const [],
    this.uebungenRaw,
    this.uebungen = const [],
    this.isOfficialLocked = false,
  });

  final String slug;
  final int teil;
  final bool isIntro;
  final bool isStub;
  final String titleDe;
  final String titleVi;
  final String? difficulty;
  final int frequencyStars;
  final List<String> topicKeywords;
  final int? durationMin;
  final String? textType;
  final List<String> examDates;
  final TaskWordCount? taskWordCount;
  final List<WritingSource> sources;
  final String? lastReviewed;
  final WritingTask? task;
  final String? taskVariant;
  final TaskAnalysis? taskAnalysis;
  final List<TextStructureRow> textStructure;
  final List<UsefulPhraseCategory> usefulPhrases;
  final List<SampleSentenceGroup> sampleSentences;
  final List<ModelAnswer> modelAnswers;
  final List<GrammarFocusItem> grammarFocus;
  final WortschatzBox? wortschatzBox;
  final List<CommonMistake> commonMistakes;
  final String? uebungenRaw;
  final List<Exercise> uebungen;
  final String bodyMarkdown;

  /// True when the official-premium topic is locked server-side (this app
  /// has no official-DB merge yet — see phase report deviation #1; kept as
  /// a field for forward-compat, always false from the legacy endpoint).
  final bool isOfficialLocked;

  factory GoetheB1WritingTopic.fromJson(Map<String, dynamic> json) {
    return GoetheB1WritingTopic(
      slug: json['slug']?.toString() ?? '',
      teil: (json['teil'] as num?)?.toInt() ?? 0,
      isIntro: json['isIntro'] == true,
      isStub: json['isStub'] == true,
      titleDe: json['titleDe']?.toString() ?? '',
      titleVi: json['titleVi']?.toString() ?? '',
      difficulty: json['difficulty']?.toString(),
      frequencyStars: (json['frequencyStars'] as num?)?.toInt() ?? 0,
      topicKeywords: (json['topicKeywords'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      durationMin: (json['durationMin'] as num?)?.toInt(),
      textType: json['textType']?.toString(),
      examDates:
          (json['examDates'] as List?)?.map((e) => e.toString()).toList() ??
              const [],
      taskWordCount: json['taskWordCount'] is Map
          ? TaskWordCount.fromJson(
              Map<String, dynamic>.from(json['taskWordCount'] as Map))
          : null,
      sources: WritingSource.listFromJson(json['sources']),
      lastReviewed: json['lastReviewed']?.toString(),
      task: json['task'] is Map
          ? WritingTask.fromJson(Map<String, dynamic>.from(json['task'] as Map))
          : null,
      taskVariant: json['taskVariant']?.toString(),
      taskAnalysis: json['taskAnalysis'] is Map
          ? TaskAnalysis.fromJson(
              Map<String, dynamic>.from(json['taskAnalysis'] as Map))
          : null,
      textStructure: TextStructureRow.listFromJson(json['textStructure']),
      usefulPhrases: UsefulPhraseCategory.listFromJson(json['usefulPhrases']),
      sampleSentences:
          SampleSentenceGroup.listFromJson(json['sampleSentences']),
      modelAnswers: ModelAnswer.listFromJson(json['modelAnswers']),
      grammarFocus: GrammarFocusItem.listFromJson(json['grammarFocus']),
      wortschatzBox: json['wortschatzBox'] is Map
          ? WortschatzBox.fromJson(
              Map<String, dynamic>.from(json['wortschatzBox'] as Map))
          : null,
      commonMistakes: CommonMistake.listFromJson(json['commonMistakes']),
      uebungenRaw: json['uebungenRaw']?.toString(),
      uebungen: Exercise.listFromJson(json['uebungen']),
      bodyMarkdown: json['bodyMarkdown']?.toString() ?? '',
    );
  }
}
