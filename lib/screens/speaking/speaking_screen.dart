import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import 'package:deutschtiger/view_models/speaking/speaking_provider.dart';
import 'widgets/shadowing_session_card.dart';
import 'widgets/pronunciation_trainer_card.dart';
import 'widgets/ai_conversation_card.dart';

class SpeakingScreen extends ConsumerWidget {
  const SpeakingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Speaking Practice'),
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Shadowing'),
              Tab(text: 'Pronunciation'),
              Tab(text: 'AI Chat'),
            ],
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: TabBarView(
          children: [
            _ShadowingTab(),
            _PronunciationTab(),
            _AIChatTab(),
          ],
        ),
      ),
    );
  }
}

class _ShadowingTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(shadowingSessionsProvider);

    return sessionsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (sessions) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sessions.length,
        itemBuilder: (context, index) => ShadowingSessionCard(session: sessions[index]),
      ),
    );
  }
}

class _PronunciationTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trainersAsync = ref.watch(pronunciationTrainersProvider);

    return trainersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (trainers) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: trainers.length,
        itemBuilder: (context, index) => PronunciationTrainerCard(trainer: trainers[index]),
      ),
    );
  }
}

class _AIChatTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationsAsync = ref.watch(aiConversationsProvider);

    return conversationsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (conversations) => Column(
        children: [
          _AIChatHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: conversations.length,
              itemBuilder: (context, index) => AIConversationCard(conversation: conversations[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class _AIChatHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.primary.withValues(alpha: 0.1),
      child: Column(
        children: [
          const Icon(Icons.chat_bubble, size: 48, color: AppColors.primary),
          const SizedBox(height: 8),
          const Text(
            'Practice with AI',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Have natural conversations with AI to improve your speaking',
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('New Conversation'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
