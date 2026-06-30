import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Grammar category model.
class GrammarCategory {
  final String id;
  final String name;
  final String nameVi;
  final String description;
  final IconData icon;
  final Color color;
  final int topicCount;
  final int completedCount;

  const GrammarCategory({
    required this.id,
    required this.name,
    required this.nameVi,
    required this.description,
    required this.icon,
    required this.color,
    this.topicCount = 0,
    this.completedCount = 0,
  });

  double get progress => topicCount > 0 ? completedCount / topicCount : 0;
}

/// Grammar topic model.
class GrammarTopic {
  final String id;
  final String categoryId;
  final String title;
  final String titleVi;
  final String description;
  final String descriptionVi;
  final List<String> examples;
  final List<String> examplesVi;
  final List<String> rules;
  final bool isCompleted;
  final int order;

  const GrammarTopic({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.titleVi,
    required this.description,
    required this.descriptionVi,
    this.examples = const [],
    this.examplesVi = const [],
    this.rules = const [],
    this.isCompleted = false,
    this.order = 0,
  });
}

/// Mock grammar categories.
final mockGrammarCategories = [
  const GrammarCategory(
    id: 'articles',
    name: 'Articles',
    nameVi: 'Mạo từ',
    description: 'der, die, das',
    icon: Icons.article,
    color: Color(0xFFFF6B35),
    topicCount: 4,
    completedCount: 2,
  ),
  const GrammarCategory(
    id: 'verbs',
    name: 'Verbs',
    nameVi: 'Động từ',
    description: 'Verb conjugation',
    icon: Icons.swap_horiz,
    color: Color(0xFF4ECDC4),
    topicCount: 6,
    completedCount: 4,
  ),
  const GrammarCategory(
    id: 'cases',
    name: 'Cases',
    nameVi: 'Ngữ pháp',
    description: 'Nominativ, Akkusativ, Dativ, Genitiv',
    icon: Icons.schema,
    color: Color(0xFF9B59B6),
    topicCount: 8,
    completedCount: 3,
  ),
];

/// Mock grammar topics.
final mockGrammarTopics = [
  const GrammarTopic(
    id: 'definite-articles',
    categoryId: 'articles',
    title: 'Definite Articles',
    titleVi: 'Mạo từ xác định',
    description: 'der, die, das',
    descriptionVi: 'Mạo từ xác định: der (giống đực), die (giống cái), das (trung tính)',
    examples: ['der Mann', 'die Frau', 'das Kind'],
    examplesVi: ['người đàn ông', 'người phụ nữ', 'đứa trẻ'],
    rules: ['der: Nam (the man)', 'die: Nữ (the woman)', 'das: Trung (the thing)'],
    order: 1,
  ),
  const GrammarTopic(
    id: 'sein',
    categoryId: 'verbs',
    title: 'Verb: sein',
    titleVi: 'Động từ: sein (là, ở)',
    description: 'To be',
    descriptionVi: 'Động từ "sein" có nghĩa là "là, ở"',
    examples: ['Ich bin müde', 'Du bist schön'],
    examplesVi: ['Tôi mệt', 'Bạn đẹp'],
    rules: ['ich bin', 'du bist', 'er/sie/es ist', 'wir sind', 'ihr seid', 'sie/Sie sind'],
    order: 1,
  ),
];

/// Provider for grammar categories.
final grammarCategoriesProvider = FutureProvider<List<GrammarCategory>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 300));
  return mockGrammarCategories;
});

/// Provider for grammar topics by category.
final grammarTopicsProvider = FutureProvider.family<List<GrammarTopic>, String>((ref, categoryId) async {
  await Future.delayed(const Duration(milliseconds: 200));
  return mockGrammarTopics.where((t) => t.categoryId == categoryId).toList();
});

/// Provider for grammar topic by ID.
final grammarTopicByIdProvider = FutureProvider.family<GrammarTopic?, String>((ref, topicId) async {
  await Future.delayed(const Duration(milliseconds: 100));
  try {
    return mockGrammarTopics.firstWhere((t) => t.id == topicId);
  } catch (_) {
    return null;
  }
});
