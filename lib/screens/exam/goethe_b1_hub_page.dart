import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/exam_models.dart';
import 'exam_provider.dart';
import 'widgets/exam_readiness_card.dart';

class GoetheB1HubPage extends ConsumerWidget {
  const GoetheB1HubPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hubAsync = ref.watch(examHubProvider('goethe-b1'));

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: const Text(
          'Goethe B1',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.tigerOrange,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: hubAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (hub) => _HubContent(hub: hub),
      ),
    );
  }
}

class _HubContent extends StatelessWidget {
  final ExamHub hub;

  const _HubContent({required this.hub});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _ReadinessSection(),
          const SizedBox(height: 24),
          const Text(
            'Exam Sections',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: 'Lesen',
            titleVi: 'Reading',
            icon: Icons.menu_book,
            color: Colors.blue,
            onTap: () => context.push('/exam/goethe-b1/reading'),
          ),
          _SectionCard(
            title: 'Hören',
            titleVi: 'Listening',
            icon: Icons.headphones,
            color: Colors.purple,
            onTap: () => context.push('/exam/goethe-b1/listening'),
          ),
          _SectionCard(
            title: 'Schreiben',
            titleVi: 'Writing',
            icon: Icons.edit_note,
            color: Colors.orange,
            onTap: () => context.push('/exam/goethe-b1/writing'),
          ),
          _SectionCard(
            title: 'Sprechen',
            titleVi: 'Speaking',
            icon: Icons.record_voice_over,
            color: Colors.teal,
            onTap: () => context.push('/exam/goethe-b1/speaking'),
          ),
          const SizedBox(height: 24),
          const Text(
            'Practice Materials',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _PracticeCard(
            title: 'Writing Topics',
            titleVi: 'Chủ đề viết',
            description: '30 practice prompts for Teil 1, 2, 3',
            icon: Icons.edit_document,
            onTap: () => context.push('/exam/goethe-b1/writing-topics'),
          ),
          _PracticeCard(
            title: 'Speaking Topics',
            titleVi: 'Chủ đề nói',
            description: 'Practice for Teil A, B, C',
            icon: Icons.mic,
            onTap: () => context.push('/exam/goethe-b1/speaking-topics'),
          ),
          _PracticeCard(
            title: 'Past Exams',
            titleVi: 'Đề thi cũ',
            description: '30+ official exam sets',
            icon: Icons.assignment,
            onTap: () => context.push('/exam/goethe-b1/exams'),
          ),
        ],
      ),
    );
  }
}

class _ReadinessSection extends ConsumerWidget {
  const _ReadinessSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readinessAsync = ref.watch(examReadinessProvider('goethe-b1'));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Readiness',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        readinessAsync.when(
          loading: () => const Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          error: (e, _) => Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Error: $e'),
            ),
          ),
          data: (readiness) => ExamReadinessCard(readiness: readiness),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String titleVi;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SectionCard({
    required this.title,
    required this.titleVi,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      titleVi,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.mutedForeground,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PracticeCard extends StatelessWidget {
  final String title;
  final String titleVi;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const _PracticeCard({
    required this.title,
    required this.titleVi,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.tigerOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.tigerOrange),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      titleVi,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.mutedForeground,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
