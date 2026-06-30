import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class SpeakingHubScreen extends ConsumerWidget {
  const SpeakingHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Speaking Practice',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.tigerOrange,
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSectionTitle('Shadowing Practice', Icons.record_voice_over),
                _buildModuleCard(
                  context,
                  title: 'YouTube Shadowing',
                  subtitle: 'Learn from native speakers with sentence-by-sentence practice',
                  icon: Icons.play_circle_fill,
                  color: Colors.red,
                  onTap: () => context.push('/speaking/shadowing'),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Pronunciation Trainers', Icons.graphic_eq),
                _buildModuleCard(
                  context,
                  title: 'Umlaut Trainer',
                  subtitle: 'ä, ö, ü pronunciation mastery',
                  icon: Icons.text_fields,
                  color: Colors.purple,
                  onTap: () => context.push('/speaking/umlaute'),
                ),
                _buildModuleCard(
                  context,
                  title: 'R-Sound Trainer',
                  subtitle: 'German R pronunciation',
                  icon: Icons.mic,
                  color: Colors.blue,
                  onTap: () => context.push('/speaking/r-sound'),
                ),
                _buildModuleCard(
                  context,
                  title: 'Ich-Ach Trainer',
                  subtitle: 'Distinguish ich and ach sounds',
                  icon: Icons.hearing,
                  color: Colors.orange,
                  onTap: () => context.push('/speaking/ich-ach'),
                ),
                _buildModuleCard(
                  context,
                  title: 'Sp-St Trainer',
                  subtitle: 'sp→ʃp and st→ʃt rules',
                  icon: Icons.school,
                  color: Colors.teal,
                  onTap: () => context.push('/speaking/sp-st'),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('AI Conversation', Icons.chat),
                _buildModuleCard(
                  context,
                  title: 'AI Scenarios',
                  subtitle: 'Practice real-life conversations with AI',
                  icon: Icons.smart_toy,
                  color: AppColors.primary,
                  onTap: () => context.push('/speaking/conversation-hub'),
                ),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.foreground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        shadowColor: color.withOpacity(0.2),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.foreground,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
