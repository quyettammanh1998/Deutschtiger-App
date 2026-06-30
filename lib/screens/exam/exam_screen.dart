import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import 'package:deutschtiger/view_models/exam/exam_provider.dart';
import 'widgets/exam_hub_card.dart';
import 'widgets/writing_topics_list.dart';
import 'widgets/exam_readiness_card.dart';

class ExamScreen extends ConsumerWidget {
  const ExamScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Preparation'),
      ),
      body: _ExamContent(),
    );
  }
}

class _ExamContent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hubsAsync = ref.watch(examHubsProvider);

    return hubsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (hubs) => CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Readiness',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _ReadinessOverview(),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                'Available Exams',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => ExamHubCard(hub: hubs[index]),
                childCount: hubs.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadinessOverview extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readinessAsync = ref.watch(examReadinessProvider('goethe-b1'));

    return readinessAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (readiness) => ExamReadinessCard(readiness: readiness),
    );
  }
}
