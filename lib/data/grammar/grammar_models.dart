/// Grammar topic.
class GrammarTopic {
  final String id;
  final String title;
  final String titleVi;
  final String description;
  final List<String> examples;
  final List<String> examplesVi;
  final List<String> rules;
  final bool isCompleted;
  final int order;

  const GrammarTopic({
    required this.id,
    required this.title,
    required this.titleVi,
    required this.description,
    this.examples = const [],
    this.examplesVi = const [],
    this.rules = const [],
    this.isCompleted = false,
    this.order = 0,
  });

  factory GrammarTopic.fromJson(Map<String, dynamic> json) {
    return GrammarTopic(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      titleVi: json['title_vi'] as String? ?? '',
      description: json['description'] as String? ?? '',
      examples: (json['examples'] as List?)?.cast<String>() ?? [],
      examplesVi: (json['examples_vi'] as List?)?.cast<String>() ?? [],
      rules: (json['rules'] as List?)?.cast<String>() ?? [],
      isCompleted: json['is_completed'] as bool? ?? false,
      order: json['order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'title_vi': titleVi,
    'description': description,
    'examples': examples,
    'examples_vi': examplesVi,
    'rules': rules,
    'is_completed': isCompleted,
    'order': order,
  };
}

/// Grammar category.
class GrammarCategory {
  final String id;
  final String name;
  final String nameVi;
  final String? description;
  final List<GrammarTopic> topics;
  final int completedCount;
  final int totalCount;

  const GrammarCategory({
    required this.id,
    required this.name,
    required this.nameVi,
    this.description,
    this.topics = const [],
    this.completedCount = 0,
    this.totalCount = 0,
  });

  factory GrammarCategory.fromJson(Map<String, dynamic> json) {
    return GrammarCategory(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      nameVi: json['name_vi'] as String? ?? '',
      description: json['description'] as String?,
      topics: (json['topics'] as List?)
              ?.map((e) => GrammarTopic.fromJson(e as Map<String, dynamic>))
              .toList() ?? [],
      completedCount: json['completed_count'] as int? ?? 0,
      totalCount: json['total_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'name_vi': nameVi,
    'description': description,
    'topics': topics.map((t) => t.toJson()).toList(),
    'completed_count': completedCount,
    'total_count': totalCount,
  };
}
