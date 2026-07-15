import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class ExamResultPage extends StatefulWidget {
  final String examId;

  const ExamResultPage({
    super.key,
    required this.examId,
  });

  @override
  State<ExamResultPage> createState() => _ExamResultPageState();
}

class _ExamResultPageState extends State<ExamResultPage> {
  final _ExamResult _result = _ExamResult(
    examId: 'goethe-b1-2024-01',
    examTitle: 'Goethe B1 Prüfung 2024',
    completedAt: DateTime.now().subtract(const Duration(hours: 1)),
    overallScore: 72.5,
    passed: true,
    sections: [
      _SectionResult(
        name: 'Lesen (Reading)',
        nameVi: 'Đọc hiểu',
        maxScore: 100,
        score: 78.0,
        correctAnswers: 22,
        totalQuestions: 30,
        timeSpent: const Duration(minutes: 23),
        color: Colors.blue,
      ),
      _SectionResult(
        name: 'Hören (Listening)',
        nameVi: 'Nghe hiểu',
        maxScore: 100,
        score: 68.0,
        correctAnswers: 17,
        totalQuestions: 25,
        timeSpent: const Duration(minutes: 38),
        color: Colors.purple,
      ),
      _SectionResult(
        name: 'Schreiben (Writing)',
        nameVi: 'Viết',
        maxScore: 100,
        score: 70.0,
        correctAnswers: 0,
        totalQuestions: 2,
        timeSpent: const Duration(minutes: 18),
        color: Colors.orange,
      ),
      _SectionResult(
        name: 'Sprechen (Speaking)',
        nameVi: 'Nói',
        maxScore: 100,
        score: 74.0,
        correctAnswers: 0,
        totalQuestions: 3,
        timeSpent: const Duration(minutes: 15),
        color: Colors.teal,
      ),
    ],
    strengths: [
      'Good vocabulary knowledge',
      'Strong reading comprehension',
      'Clear essay structure',
    ],
    weaknesses: [
      'Listening for details',
      'Grammar in complex sentences',
      'Speaking fluency',
    ],
    recommendations: [
      'Practice dictation exercises',
      'Read German newspapers daily',
      'Speak with native speakers more often',
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: const Text(
          'Exam Results',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.tigerOrange,
            fontSize: 18,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () => context.go('/exam'),
            child: const Text('Done'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _OverallScoreCard(result: _result),
            const SizedBox(height: 20),
            const Text(
              'Section Breakdown',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ..._result.sections.map((section) => _SectionCard(section: section)),
            const SizedBox(height: 24),
            _FeedbackSection(result: _result),
            const SizedBox(height: 24),
            _ActionsSection(examId: widget.examId),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _OverallScoreCard extends StatelessWidget {
  final _ExamResult result;

  const _OverallScoreCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.examTitle,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Completed ${_formatDate(result.completedAt)}',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: result.passed
                        ? AppColors.success.withValues(alpha: 0.1)
                        : AppColors.destructive.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    result.passed ? 'PASSED' : 'NOT PASSED',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: result.passed
                          ? AppColors.success
                          : AppColors.destructive,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: Stack(
                    children: [
                      CircularProgressIndicator(
                        value: result.overallScore / 100,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation(_getScoreColor()),
                        strokeWidth: 10,
                      ),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${result.overallScore.toStringAsFixed(0)}%',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: _getScoreColor(),
                              ),
                            ),
                            Text(
                              'Overall',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    children: [
                      _StatRow(
                        icon: Icons.check_circle,
                        iconColor: AppColors.success,
                        label: 'Passed Sections',
                        value: '${result.passedSections}/${result.totalSections}',
                      ),
                      const SizedBox(height: 12),
                      _StatRow(
                        icon: Icons.timer,
                        iconColor: Colors.blue,
                        label: 'Total Time',
                        value: _formatDuration(result.totalTime),
                      ),
                      const SizedBox(height: 12),
                      _StatRow(
                        icon: Icons.quiz,
                        iconColor: Colors.orange,
                        label: 'Questions',
                        value: '${result.totalCorrect}/${result.totalQuestions}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor() {
    if (result.overallScore >= 80) return AppColors.success;
    if (result.overallScore >= 60) return Colors.orange;
    return AppColors.destructive;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _StatRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.mutedForeground,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final _SectionResult section;

  const _SectionCard({required this.section});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: section.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getSectionIcon(),
                    color: section.color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        section.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        section.nameVi,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${section.score.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _getScoreColor(),
                      ),
                    ),
                    Text(
                      section.passed ? 'Passed' : 'Not Passed',
                      style: TextStyle(
                        fontSize: 11,
                        color: section.passed
                            ? AppColors.success
                            : AppColors.destructive,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _MiniStat(
                  icon: Icons.check,
                  label: 'Correct',
                  value: '${section.correctAnswers}/${section.totalQuestions}',
                  color: AppColors.success,
                ),
                const SizedBox(width: 16),
                _MiniStat(
                  icon: Icons.timer,
                  label: 'Time',
                  value: '${section.timeSpent.inMinutes}m',
                  color: Colors.blue,
                ),
                const SizedBox(width: 16),
                _MiniStat(
                  icon: Icons.trending_up,
                  label: 'Target',
                  value: '60%',
                  color: Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: section.score / 100,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation(section.color),
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getSectionIcon() {
    if (section.name.startsWith('Lesen')) return Icons.menu_book;
    if (section.name.startsWith('Hören')) return Icons.headphones;
    if (section.name.startsWith('Schreiben')) return Icons.edit_note;
    return Icons.record_voice_over;
  }

  Color _getScoreColor() {
    if (section.score >= 80) return AppColors.success;
    if (section.score >= 60) return Colors.orange;
    return AppColors.destructive;
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _MiniStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: AppColors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedbackSection extends StatelessWidget {
  final _ExamResult result;

  const _FeedbackSection({required this.result});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Feedback',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.thumb_up,
                        color: AppColors.success,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Strengths',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...result.strengths.map((s) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          s,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.foreground,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
                const Divider(height: 24),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.trending_up,
                        color: AppColors.warning,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Areas to Improve',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...result.weaknesses.map((w) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.arrow_forward,
                        size: 16,
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          w,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.foreground,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
                const Divider(height: 24),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.lightbulb,
                        color: Colors.blue,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Recommendations',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...result.recommendations.map((r) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.tips_and_updates,
                        size: 16,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          r,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.foreground,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionsSection extends StatelessWidget {
  final String examId;

  const _ActionsSection({required this.examId});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.replay, color: AppColors.tigerOrange),
                title: const Text('Retry This Exam'),
                subtitle: const Text('Practice to improve your score'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  context.push('/exam/practice/$examId');
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.list_alt, color: Colors.blue),
                title: const Text('View All Exams'),
                subtitle: const Text('Try other exam sets'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  context.push('/exam/goethe-b1/exams');
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.edit_note, color: Colors.orange),
                title: const Text('Writing Practice'),
                subtitle: const Text('Work on Teil 1, 2, 3'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  context.push('/exam/goethe-b1/writing-topics');
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.share, color: Colors.green),
                title: const Text('Chia sẻ kết quả'),
                subtitle: const Text('Chia sẻ thành tích của bạn'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tính năng chia sẻ chưa có trong phiên bản này.'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ExamResult {
  final String examId;
  final String examTitle;
  final DateTime completedAt;
  final double overallScore;
  final bool passed;
  final List<_SectionResult> sections;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> recommendations;

  _ExamResult({
    required this.examId,
    required this.examTitle,
    required this.completedAt,
    required this.overallScore,
    required this.passed,
    required this.sections,
    required this.strengths,
    required this.weaknesses,
    required this.recommendations,
  });

  int get passedSections => sections.where((s) => s.passed).length;
  int get totalSections => sections.length;
  int get totalCorrect => sections.fold(0, (sum, s) => sum + s.correctAnswers);
  int get totalQuestions => sections.fold(0, (sum, s) => sum + s.totalQuestions);
  Duration get totalTime => sections.fold(
    Duration.zero,
    (sum, s) => sum + s.timeSpent,
  );
}

class _SectionResult {
  final String name;
  final String nameVi;
  final double maxScore;
  final double score;
  final int correctAnswers;
  final int totalQuestions;
  final Duration timeSpent;
  final Color color;

  _SectionResult({
    required this.name,
    required this.nameVi,
    required this.maxScore,
    required this.score,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.timeSpent,
    required this.color,
  });

  bool get passed => score >= 60;
}
