import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Pronunciation Practice Screen
class PronunciationScreen extends StatelessWidget {
  const PronunciationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phát âm'),
        backgroundColor: AppColors.tigerOrange,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _PracticeCard(
            title: 'Âm R /ʁ/',
            subtitle: 'Luyện phát âm âm R trong tiếng Đức',
            icon: '🇩🇪',
            color: Colors.blue,
            onTap: () {},
          ),
          _PracticeCard(
            title: 'Âm ch /x/',
            subtitle: 'Âm ich-laut và ach-laut',
            icon: '🎯',
            color: Colors.purple,
            onTap: () {},
          ),
          _PracticeCard(
            title: 'Âm sp /ʃp/',
            subtitle: 'Phân biệt sp và sch',
            icon: '✏️',
            color: Colors.green,
            onTap: () {},
          ),
          _PracticeCard(
            title: 'Umlaute',
            subtitle: 'Ä, Ö, Ü và cách phát âm',
            icon: '🔤',
            color: Colors.orange,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _PracticeCard extends StatelessWidget {
  const _PracticeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withAlpha(26),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(icon, style: const TextStyle(fontSize: 24)),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
