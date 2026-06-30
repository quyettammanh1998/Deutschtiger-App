import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import 'ai_provider.dart';
import '../domain/ai_models.dart';

class AISettingsPage extends ConsumerStatefulWidget {
  const AISettingsPage({super.key});

  @override
  ConsumerState<AISettingsPage> createState() => _AISettingsPageState();
}

class _AISettingsPageState extends ConsumerState<AISettingsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(aiSettingsNotifierProvider).loadSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(aiSettingsNotifierProvider);
    final settings = notifier.state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionHeader(title: 'Learning Profile'),
          _UserLevelSelector(
            currentLevel: settings.userLevel,
            onChanged: (level) {
              ref.read(aiSettingsNotifierProvider).updateLevel(level);
            },
          ),
          const SizedBox(height: 24),
          _SectionHeader(title: 'Exam Focus'),
          _ExamSelector(
            currentExam: settings.focusExam,
            onChanged: (exam) {
              ref.read(aiSettingsNotifierProvider).setFocusExam(exam);
            },
          ),
          const SizedBox(height: 24),
          _SectionHeader(title: 'Display Preferences'),
          _SettingsToggle(
            title: 'Include Translations',
            subtitle: 'Show English translations under German text',
            value: settings.includeTranslations,
            onChanged: (_) {
              ref.read(aiSettingsNotifierProvider).toggleTranslations();
            },
          ),
          _SettingsToggle(
            title: 'Grammar Hints',
            subtitle: 'Show grammar explanations and corrections',
            value: settings.showGrammarHints,
            onChanged: (_) {
              ref.read(aiSettingsNotifierProvider).toggleGrammarHints();
            },
          ),
          _SettingsToggle(
            title: 'Vocabulary Highlights',
            subtitle: 'Highlight new words and phrases',
            value: settings.showVocabularyHighlights,
            onChanged: (_) {
              ref.read(aiSettingsNotifierProvider).toggleVocabularyHighlights();
            },
          ),
          const SizedBox(height: 24),
          _SectionHeader(title: 'AI Memory'),
          _MemoryInfoCard(settings: settings),
          const SizedBox(height: 24),
          _ClearMemoryButton(),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _UserLevelSelector extends StatelessWidget {
  final String currentLevel;
  final Function(String) onChanged;

  const _UserLevelSelector({
    required this.currentLevel,
    required this.onChanged,
  });

  static const levels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
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
                    color: AppColors.primary.withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.school, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your German Level',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'The AI will adjust explanations to your level',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: levels.map((level) {
                final isSelected = level == currentLevel;
                return GestureDetector(
                  onTap: () => onChanged(level),
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : Colors.grey[300]!,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        level,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 16, color: AppColors.foreground),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _getLevelDescription(currentLevel),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLevelDescription(String level) {
    switch (level) {
      case 'A1':
        return 'Beginner: Can understand and use familiar everyday expressions.';
      case 'A2':
        return 'Elementary: Can communicate in simple and routine tasks.';
      case 'B1':
        return 'Intermediate: Can deal with most situations likely to arise while travelling.';
      case 'B2':
        return 'Upper Intermediate: Can interact with native speakers with sufficient fluency.';
      case 'C1':
        return 'Advanced: Can express ideas fluently and spontaneously.';
      case 'C2':
        return 'Mastery: Can understand with ease virtually everything heard or read.';
      default:
        return 'Select your German proficiency level';
    }
  }
}

class _ExamSelector extends StatelessWidget {
  final String currentExam;
  final Function(String) onChanged;

  const _ExamSelector({
    required this.currentExam,
    required this.onChanged,
  });

  static const exams = [
    ('Goethe A2', 'Goethe-Institut'),
    ('Goethe B1', 'Goethe-Institut'),
    ('Goethe B2', 'Goethe-Institut'),
    ('Goethe C1', 'Goethe-Institut'),
    ('TELC B1', 'TELC'),
    ('TELC B2', 'TELC'),
    ('ÖSD B1', 'ÖSD'),
    ('TestDaF', 'TestDaF'),
    ('DSH', 'DSH'),
    ('No Exam', 'General Practice'),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
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
                    color: Colors.purple.withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.assignment, color: Colors.purple),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Exam Preparation',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Focus practice on specific exam requirements',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: exams.map((exam) {
                final isSelected = exam.$1 == currentExam;
                return GestureDetector(
                  onTap: () => onChanged(exam.$1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.purple : Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? Colors.purple : Colors.grey[300]!,
                      ),
                    ),
                    child: Text(
                      exam.$1,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[700],
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsToggle extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final Function(bool) onChanged;

  const _SettingsToggle({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
      ),
    );
  }
}

class _MemoryInfoCard extends StatelessWidget {
  final AISettings settings;

  const _MemoryInfoCard({required this.settings});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
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
                    color: Colors.teal.withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.psychology, color: Colors.teal),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Memory',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'What the AI remembers about you',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _MemoryItem(
              icon: Icons.school,
              label: 'Level',
              value: settings.userLevel,
              color: AppColors.primary,
            ),
            _MemoryItem(
              icon: Icons.flag,
              label: 'Focus',
              value: settings.focusExam.isEmpty ? 'General' : settings.focusExam,
              color: Colors.purple,
            ),
            _MemoryItem(
              icon: Icons.analytics,
              label: 'Goals',
              value: settings.learningGoals.isEmpty 
                  ? 'Not set' 
                  : settings.learningGoals.join(', '),
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}

class _MemoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _MemoryItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _ClearMemoryButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Clear AI Memory?'),
            content: const Text(
              'This will reset all the AI\'s memory of your preferences and progress. This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('AI memory cleared'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Clear'),
              ),
            ],
          ),
        );
      },
      icon: const Icon(Icons.delete_outline, color: Colors.red),
      label: const Text('Clear AI Memory', style: TextStyle(color: Colors.red)),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.red),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }
}
