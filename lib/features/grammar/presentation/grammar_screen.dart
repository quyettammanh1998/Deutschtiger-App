import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/async_state_views.dart';

/// Provider cho grammar categories (mock data for now).
final grammarCategoriesProvider = FutureProvider<List<GrammarCategoryMock>>((ref) async {
  // TODO: Replace with actual API call
  await Future.delayed(const Duration(milliseconds: 500));
  return _mockCategories;
});

class GrammarCategoryMock {
  final String id;
  final String name;
  final String nameVi;
  final String description;
  final IconData icon;
  final int completedCount;
  final int totalCount;

  const GrammarCategoryMock({
    required this.id,
    required this.name,
    required this.nameVi,
    required this.description,
    required this.icon,
    this.completedCount = 0,
    this.totalCount = 0,
  });
}

const _mockCategories = [
  GrammarCategoryMock(
    id: 'article',
    name: 'Articles',
    nameVi: 'Mạo từ',
    description: 'der, die, das - các mạo từ xác định và bất định',
    icon: Icons.article_outlined,
    completedCount: 3,
    totalCount: 5,
  ),
  GrammarCategoryMock(
    id: 'noun',
    name: 'Nouns & Cases',
    nameVi: 'Danh từ & Ngữ pháp',
    description: 'Giống, số nhiều, và 4 trường hợp',
    icon: Icons.text_fields,
    completedCount: 2,
    totalCount: 8,
  ),
  GrammarCategoryMock(
    id: 'verb',
    name: 'Verbs',
    nameVi: 'Động từ',
    description: 'Động từ thường, bất quy tắc, và chia động từ',
    icon: Icons.swap_horiz,
    completedCount: 5,
    totalCount: 10,
  ),
  GrammarCategoryMock(
    id: 'adj',
    name: 'Adjectives',
    nameVi: 'Tính từ',
    description: 'Tính từ và so sánh',
    icon: Icons.format_quote,
    completedCount: 1,
    totalCount: 6,
  ),
  GrammarCategoryMock(
    id: 'pronoun',
    name: 'Pronouns',
    nameVi: 'Đại từ',
    description: 'Đại từ xưng hô, sở hữu, và chỉ định',
    icon: Icons.person_outline,
    completedCount: 0,
    totalCount: 5,
  ),
  GrammarCategoryMock(
    id: 'sentence',
    name: 'Sentence Structure',
    nameVi: 'Cấu trúc câu',
    description: 'Thứ tự từ, câu chính và câu phụ',
    icon: Icons.format_list_bulleted,
    completedCount: 2,
    totalCount: 7,
  ),
];

/// Màn grammar lessons.
class GrammarScreen extends ConsumerWidget {
  const GrammarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(grammarCategoriesProvider);

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: const Text(
          'Ngữ pháp',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.tigerOrange,
            fontSize: 18,
          ),
        ),
      ),
      body: categories.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          message: 'Không tải được ngữ pháp',
          onRetry: () => ref.invalidate(grammarCategoriesProvider),
        ),
        data: (list) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final cat = list[index];
            return _GrammarCategoryCard(category: cat);
          },
        ),
      ),
    );
  }
}

class _GrammarCategoryCard extends StatelessWidget {
  const _GrammarCategoryCard({required this.category});

  final GrammarCategoryMock category;

  @override
  Widget build(BuildContext context) {
    final progress = category.totalCount > 0
        ? category.completedCount / category.totalCount
        : 0.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.push('/grammar/${category.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.tigerOrange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      category.icon,
                      color: AppColors.tigerOrange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.nameVi,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          category.name,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.mutedForeground),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                category.description,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.mutedForeground,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    '${category.completedCount}/${category.totalCount} bài',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${(progress * 100).round()}%',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.tigerOrange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: AppColors.border,
                  valueColor: const AlwaysStoppedAnimation(AppColors.tigerOrange),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
