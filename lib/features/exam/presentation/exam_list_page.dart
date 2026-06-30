import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class ExamListPage extends ConsumerWidget {
  const ExamListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: const Text(
          'Goethe B1 Exams',
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
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _examSets.length,
        itemBuilder: (context, index) {
          return _ExamSetCard(exam: _examSets[index]);
        },
      ),
    );
  }
}

class _ExamSetCard extends StatelessWidget {
  final _ExamSet exam;

  const _ExamSetCard({required this.exam});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showExamOptions(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.tigerOrange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      exam.setNumber,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.tigerOrange,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      exam.difficulty,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _getDifficultyColor(),
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (exam.isCompleted)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, size: 12, color: AppColors.success),
                          SizedBox(width: 4),
                          Text(
                            'Done',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                exam.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                exam.description,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.mutedForeground,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _InfoChip(
                    icon: Icons.quiz_outlined,
                    label: '${exam.questionCount} questions',
                  ),
                  const SizedBox(width: 12),
                  _InfoChip(
                    icon: Icons.timer_outlined,
                    label: '${exam.durationMinutes} min',
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () => context.push('/exam/practice/${exam.id}'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.tigerOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    child: const Text('Start'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDifficultyColor() {
    switch (exam.difficulty) {
      case 'Easy':
        return AppColors.success;
      case 'Medium':
        return AppColors.warning;
      case 'Hard':
        return AppColors.destructive;
      default:
        return AppColors.mutedForeground;
    }
  }

  void _showExamOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exam.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              exam.description,
              style: TextStyle(color: AppColors.mutedForeground),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.play_arrow, color: AppColors.tigerOrange),
              title: const Text('Full Exam'),
              subtitle: Text('${exam.durationMinutes} minutes'),
              onTap: () {
                Navigator.pop(context);
                context.push('/exam/practice/${exam.id}');
              },
            ),
            ListTile(
              leading: const Icon(Icons.view_module, color: Colors.blue),
              title: const Text('Practice by Section'),
              subtitle: const Text('Lesen, Hören, Schreiben, Sprechen'),
              onTap: () {
                Navigator.pop(context);
                context.push('/exam/practice/${exam.id}/sections');
              },
            ),
            ListTile(
              leading: const Icon(Icons.timer, color: Colors.orange),
              title: const Text('Timed Practice'),
              subtitle: const Text('Simulate real exam conditions'),
              onTap: () {
                Navigator.pop(context);
                context.push('/exam/practice/${exam.id}?timed=true');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.mutedForeground),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.mutedForeground,
          ),
        ),
      ],
    );
  }
}

class _ExamSet {
  final String id;
  final String setNumber;
  final String title;
  final String description;
  final String difficulty;
  final int questionCount;
  final int durationMinutes;
  final bool isCompleted;

  const _ExamSet({
    required this.id,
    required this.setNumber,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.questionCount,
    required this.durationMinutes,
    this.isCompleted = false,
  });
}

final List<_ExamSet> _examSets = [
  const _ExamSet(
    id: 'goethe-b1-2024-01',
    setNumber: 'Set 01/30',
    title: 'Goethe B1 Prüfung 2024 - Januar',
    description: 'Official Goethe-Institut B1 exam from January 2024',
    difficulty: 'Medium',
    questionCount: 68,
    durationMinutes: 105,
  ),
  const _ExamSet(
    id: 'goethe-b1-2024-02',
    setNumber: 'Set 02/30',
    title: 'Goethe B1 Prüfung 2024 - Februar',
    description: 'Official Goethe-Institut B1 exam from February 2024',
    difficulty: 'Medium',
    questionCount: 68,
    durationMinutes: 105,
  ),
  const _ExamSet(
    id: 'goethe-b1-2024-03',
    setNumber: 'Set 03/30',
    title: 'Goethe B1 Prüfung 2024 - März',
    description: 'Official Goethe-Institut B1 exam from March 2024',
    difficulty: 'Easy',
    questionCount: 68,
    durationMinutes: 105,
  ),
  const _ExamSet(
    id: 'goethe-b1-2024-04',
    setNumber: 'Set 04/30',
    title: 'Goethe B1 Prüfung 2024 - April',
    description: 'Official Goethe-Institut B1 exam from April 2024',
    difficulty: 'Medium',
    questionCount: 68,
    durationMinutes: 105,
  ),
  const _ExamSet(
    id: 'goethe-b1-2024-05',
    setNumber: 'Set 05/30',
    title: 'Goethe B1 Prüfung 2024 - Mai',
    description: 'Official Goethe-Institut B1 exam from May 2024',
    difficulty: 'Hard',
    questionCount: 68,
    durationMinutes: 105,
  ),
  const _ExamSet(
    id: 'goethe-b1-2024-06',
    setNumber: 'Set 06/30',
    title: 'Goethe B1 Prüfung 2024 - Juni',
    description: 'Official Goethe-Institut B1 exam from June 2024',
    difficulty: 'Medium',
    questionCount: 68,
    durationMinutes: 105,
  ),
  const _ExamSet(
    id: 'goethe-b1-2024-07',
    setNumber: 'Set 07/30',
    title: 'Goethe B1 Prüfung 2024 - Juli',
    description: 'Official Goethe-Institut B1 exam from July 2024',
    difficulty: 'Easy',
    questionCount: 68,
    durationMinutes: 105,
  ),
  const _ExamSet(
    id: 'goethe-b1-2024-08',
    setNumber: 'Set 08/30',
    title: 'Goethe B1 Prüfung 2024 - August',
    description: 'Official Goethe-Institut B1 exam from August 2024',
    difficulty: 'Medium',
    questionCount: 68,
    durationMinutes: 105,
  ),
  const _ExamSet(
    id: 'goethe-b1-2024-09',
    setNumber: 'Set 09/30',
    title: 'Goethe B1 Prüfung 2024 - September',
    description: 'Official Goethe-Institut B1 exam from September 2024',
    difficulty: 'Hard',
    questionCount: 68,
    durationMinutes: 105,
  ),
  const _ExamSet(
    id: 'goethe-b1-2024-10',
    setNumber: 'Set 10/30',
    title: 'Goethe B1 Prüfung 2024 - Oktober',
    description: 'Official Goethe-Institut B1 exam from October 2024',
    difficulty: 'Medium',
    questionCount: 68,
    durationMinutes: 105,
  ),
  const _ExamSet(
    id: 'goethe-b1-2023-11',
    setNumber: 'Set 11/30',
    title: 'Goethe B1 Prüfung 2023 - November',
    description: 'Official Goethe-Institut B1 exam from November 2023',
    difficulty: 'Medium',
    questionCount: 68,
    durationMinutes: 105,
  ),
  const _ExamSet(
    id: 'goethe-b1-2023-12',
    setNumber: 'Set 12/30',
    title: 'Goethe B1 Prüfung 2023 - Dezember',
    description: 'Official Goethe-Institut B1 exam from December 2023',
    difficulty: 'Easy',
    questionCount: 68,
    durationMinutes: 105,
  ),
  const _ExamSet(
    id: 'goethe-b1-2023-01',
    setNumber: 'Set 13/30',
    title: 'Goethe B1 Prüfung 2023 - Januar',
    description: 'Official Goethe-Institut B1 exam from January 2023',
    difficulty: 'Medium',
    questionCount: 68,
    durationMinutes: 105,
  ),
  const _ExamSet(
    id: 'goethe-b1-2023-02',
    setNumber: 'Set 14/30',
    title: 'Goethe B1 Prüfung 2023 - Februar',
    description: 'Official Goethe-Institut B1 exam from February 2023',
    difficulty: 'Hard',
    questionCount: 68,
    durationMinutes: 105,
  ),
  const _ExamSet(
    id: 'goethe-b1-2023-03',
    setNumber: 'Set 15/30',
    title: 'Goethe B1 Prüfung 2023 - März',
    description: 'Official Goethe-Institut B1 exam from March 2023',
    difficulty: 'Medium',
    questionCount: 68,
    durationMinutes: 105,
  ),
  const _ExamSet(
    id: 'goethe-b1-2023-04',
    setNumber: 'Set 16/30',
    title: 'Goethe B1 Prüfung 2023 - April',
    description: 'Official Goethe-Institut B1 exam from April 2023',
    difficulty: 'Easy',
    questionCount: 68,
    durationMinutes: 105,
  ),
  const _ExamSet(
    id: 'goethe-b1-2023-05',
    setNumber: 'Set 17/30',
    title: 'Goethe B1 Prüfung 2023 - Mai',
    description: 'Official Goethe-Institut B1 exam from May 2023',
    difficulty: 'Medium',
    questionCount: 68,
    durationMinutes: 105,
  ),
  const _ExamSet(
    id: 'goethe-b1-2023-06',
    setNumber: 'Set 18/30',
    title: 'Goethe B1 Prüfung 2023 - Juni',
    description: 'Official Goethe-Institut B1 exam from June 2023',
    difficulty: 'Hard',
    questionCount: 68,
    durationMinutes: 105,
  ),
  const _ExamSet(
    id: 'goethe-b1-2023-07',
    setNumber: 'Set 19/30',
    title: 'Goethe B1 Prüfung 2023 - Juli',
    description: 'Official Goethe-Institut B1 exam from July 2023',
    difficulty: 'Medium',
    questionCount: 68,
    durationMinutes: 105,
  ),
  const _ExamSet(
    id: 'goethe-b1-2023-08',
    setNumber: 'Set 20/30',
    title: 'Goethe B1 Prüfung 2023 - August',
    description: 'Official Goethe-Institut B1 exam from August 2023',
    difficulty: 'Easy',
    questionCount: 68,
    durationMinutes: 105,
  ),
  const _ExamSet(
    id: 'goethe-b1-2023-09',
    setNumber: 'Set 21/30',
    title: 'Goethe B1 Prüfung 2023 - September',
    description: 'Official Goethe-Institut B1 exam from September 2023',
    difficulty: 'Medium',
    questionCount: 68,
    durationMinutes: 105,
  ),
  const _ExamSet(
    id: 'goethe-b1-2023-10',
    setNumber: 'Set 22/30',
    title: 'Goethe B1 Prüfung 2023 - Oktober',
    description: 'Official Goethe-Institut B1 exam from October 2023',
    difficulty: 'Hard',
    questionCount: 68,
    durationMinutes: 105,
  ),
  const _ExamSet(
    id: 'goethe-b1-2022-11',
    setNumber: 'Set 23/30',
    title: 'Goethe B1 Prüfung 2022 - November',
    description: 'Official Goethe-Institut B1 exam from November 2022',
    difficulty: 'Medium',
    questionCount: 68,
    durationMinutes: 105,
  ),
  const _ExamSet(
    id: 'goethe-b1-2022-12',
    setNumber: 'Set 24/30',
    title: 'Goethe B1 Prüfung 2022 - Dezember',
    description: 'Official Goethe-Institut B1 exam from December 2022',
    difficulty: 'Easy',
    questionCount: 68,
    durationMinutes: 105,
  ),
  const _ExamSet(
    id: 'goethe-b1-2022-01',
    setNumber: 'Set 25/30',
    title: 'Goethe B1 Prüfung 2022 - Januar',
    description: 'Official Goethe-Institut B1 exam from January 2022',
    difficulty: 'Medium',
    questionCount: 68,
    durationMinutes: 105,
  ),
  const _ExamSet(
    id: 'goethe-b1-2022-02',
    setNumber: 'Set 26/30',
    title: 'Goethe B1 Prüfung 2022 - Februar',
    description: 'Official Goethe-Institut B1 exam from February 2022',
    difficulty: 'Hard',
    questionCount: 68,
    durationMinutes: 105,
  ),
  const _ExamSet(
    id: 'goethe-b1-2022-03',
    setNumber: 'Set 27/30',
    title: 'Goethe B1 Prüfung 2022 - März',
    description: 'Official Goethe-Institut B1 exam from March 2022',
    difficulty: 'Medium',
    questionCount: 68,
    durationMinutes: 105,
  ),
  const _ExamSet(
    id: 'goethe-b1-2022-04',
    setNumber: 'Set 28/30',
    title: 'Goethe B1 Prüfung 2022 - April',
    description: 'Official Goethe-Institut B1 exam from April 2022',
    difficulty: 'Easy',
    questionCount: 68,
    durationMinutes: 105,
  ),
  const _ExamSet(
    id: 'goethe-b1-2022-05',
    setNumber: 'Set 29/30',
    title: 'Goethe B1 Prüfung 2022 - Mai',
    description: 'Official Goethe-Institut B1 exam from May 2022',
    difficulty: 'Medium',
    questionCount: 68,
    durationMinutes: 105,
  ),
  const _ExamSet(
    id: 'goethe-b1-2022-06',
    setNumber: 'Set 30/30',
    title: 'Goethe B1 Prüfung 2022 - Juni',
    description: 'Official Goethe-Institut B1 exam from June 2022',
    difficulty: 'Hard',
    questionCount: 68,
    durationMinutes: 105,
  ),
];
