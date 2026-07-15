import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Exam Hub Screen - Goethe & Practice Tests
class ExamHubScreen extends StatelessWidget {
  const ExamHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Luyện thi'),
        backgroundColor: AppColors.tigerOrange,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Goethe B1 Section
          _buildSectionHeader(
            'Goethe-Zertifikat B1',
            'Chứng chỉ tiếng Đức trung cấp',
            Colors.blue,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ExamCard(
                  title: '📝 Luyện viết',
                  subtitle: 'Bài viết Goethe B1',
                  icon: Icons.edit,
                  color: Colors.blue,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ExamCard(
                  title: '🗣️ Luyện nói',
                  subtitle: 'Thi nói Goethe B1',
                  icon: Icons.mic,
                  color: Colors.green,
                  onTap: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Practice Tests
          _buildSectionHeader(
            'Bài luyện tập',
            'Kiểm tra kiến thức',
            Colors.purple,
          ),
          const SizedBox(height: 12),
          _PracticeTestCard(
            title: 'Ngữ pháp A1-A2',
            questions: 20,
            time: '15 phút',
            color: Colors.purple,
            onTap: () {},
          ),
          _PracticeTestCard(
            title: 'Ngữ pháp B1-B2',
            questions: 25,
            time: '20 phút',
            color: Colors.orange,
            onTap: () {},
          ),
          _PracticeTestCard(
            title: 'Từ vựng chủ đề',
            questions: 30,
            time: '10 phút',
            color: Colors.teal,
            onTap: () {},
          ),
          _PracticeTestCard(
            title: 'Đọc hiểu',
            questions: 15,
            time: '20 phút',
            color: Colors.indigo,
            onTap: () {},
          ),
          const SizedBox(height: 24),

          // Reading Practice
          _buildSectionHeader(
            'Luyện đọc',
            'Đọc hiểu văn bản tiếng Đức',
            Colors.brown,
          ),
          const SizedBox(height: 12),
          _ReadingCard(
            title: 'Thư tín',
            level: 'A2',
            color: Colors.brown,
            onTap: () {},
          ),
          _ReadingCard(
            title: 'Bài báo',
            level: 'B1',
            color: Colors.red,
            onTap: () {},
          ),
          _ReadingCard(
            title: 'Văn bản học thuật',
            level: 'B2',
            color: Colors.blue,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle, Color color) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ExamCard extends StatelessWidget {
  const _ExamCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withAlpha(26),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PracticeTestCard extends StatelessWidget {
  const _PracticeTestCard({
    required this.title,
    required this.questions,
    required this.time,
    required this.color,
    required this.onTap,
  });

  final String title;
  final int questions;
  final String time;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withAlpha(26),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.quiz, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: [
            Icon(Icons.help_outline, size: 14, color: Colors.grey.shade600),
            const SizedBox(width: 4),
            Text('$questions câu', style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(width: 12),
            Icon(Icons.timer_outlined, size: 14, color: Colors.grey.shade600),
            const SizedBox(width: 4),
            Text(time, style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Làm bài',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

class _ReadingCard extends StatelessWidget {
  const _ReadingCard({
    required this.title,
    required this.level,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String level;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withAlpha(26),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            level,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
