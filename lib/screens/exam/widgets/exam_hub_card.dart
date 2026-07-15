import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:deutschtiger/data/exam/exam_models.dart';

class ExamHubCard extends StatelessWidget {
  final ExamHub hub;

  const ExamHubCard({super.key, required this.hub});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/exam/${hub.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              width: double.infinity,
              color: AppColors.primary.withValues(alpha: 0.1),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      _getHubIcon(hub.type),
                      size: 60,
                      color: AppColors.primary.withValues(alpha: 0.5),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        hub.level,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hub.nameVi,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hub.descriptionVi,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _InfoChip(
                        icon: Icons.assignment,
                        label: '${hub.completedExams}/${hub.totalExams} exams',
                      ),
                      const SizedBox(width: 12),
                      if (hub.readinessScore > 0)
                        _InfoChip(
                          icon: Icons.trending_up,
                          label: '${hub.readinessScore.toStringAsFixed(0)}% ready',
                          color: _getReadinessColor(hub.readinessScore),
                        ),
                    ],
                  ),
                  if (hub.sections.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: hub.sections.map((section) {
                        return _SectionProgress(section: section);
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getHubIcon(String type) {
    switch (type) {
      case 'goethe':
        return Icons.school;
      case 'telc':
        return Icons.verified;
      default:
        return Icons.assignment;
    }
  }

  Color _getReadinessColor(double score) {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return Colors.orange;
    return AppColors.error;
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _InfoChip({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (color ?? Colors.grey).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color ?? Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: color ?? Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

class _SectionProgress extends StatelessWidget {
  final ExamSection section;

  const _SectionProgress({required this.section});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 40,
          height: 40,
          child: Stack(
            children: [
              CircularProgressIndicator(
                value: section.score / 100,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation(_getSectionColor(section.type)),
                strokeWidth: 4,
              ),
              Center(
                child: Icon(
                  _getSectionIcon(section.type),
                  size: 20,
                  color: _getSectionColor(section.type),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          section.titleVi,
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }

  IconData _getSectionIcon(String type) {
    switch (type) {
      case 'reading':
        return Icons.menu_book;
      case 'listening':
        return Icons.headphones;
      case 'writing':
        return Icons.edit;
      case 'speaking':
        return Icons.mic;
      default:
        return Icons.assignment;
    }
  }

  Color _getSectionColor(String type) {
    switch (type) {
      case 'reading':
        return Colors.blue;
      case 'listening':
        return Colors.purple;
      case 'writing':
        return Colors.orange;
      case 'speaking':
        return Colors.teal;
      default:
        return AppColors.primary;
    }
  }
}
