import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import 'package:deutschtiger/view_models/ai_tutor/ai_tutor_provider.dart';
import 'widgets/ai_chat_screen.dart';
import 'widgets/ai_mode_selector.dart';
import 'widgets/ai_writing_practice_list.dart';

class AITutorScreen extends ConsumerWidget {
  const AITutorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Tutor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {},
            tooltip: 'Chat History',
          ),
        ],
      ),
      body: Column(
        children: [
          const AIModeSelector(),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text(
                  'Writing Practice',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const Text('See All'),
                ),
              ],
            ),
          ),
          _WritingPracticeSection(),
          const SizedBox(height: 16),
          Expanded(
            child: _StartChatCard(),
          ),
        ],
      ),
    );
  }
}

class _WritingPracticeSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final practicesAsync = ref.watch(aiWritingPracticesProvider);

    return practicesAsync.when(
      loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
      error: (e, _) => SizedBox(height: 100, child: Center(child: Text('Error: $e'))),
      data: (practices) => AIWritingPracticeList(practices: practices),
    );
  }
}

class _StartChatCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.chat, size: 48, color: Colors.white),
          const SizedBox(height: 16),
          const Text(
            'Chat with AI Tutor',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Practice German conversations, get grammar help, and improve your vocabulary',
            style: TextStyle(color: Colors.white.withOpacity(0.9)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AIChatScreen()),
              );
            },
            icon: const Icon(Icons.message),
            label: const Text('Start Chatting'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
