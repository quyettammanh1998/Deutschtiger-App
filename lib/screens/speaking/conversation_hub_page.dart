import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design_tokens.dart';
import 'package:deutschtiger/data/speaking/speaking_models.dart';
import 'package:deutschtiger/repositories/speaking/speaking_repository.dart';
import 'package:deutschtiger/shared/widgets/premium_gate_card.dart';

/// Phase 05 - J1 Conversation Hub.
///
/// Màn hub liệt kê các scenario hội thoại AI voice. Theo plan 260706-0232
/// phase-05: voice scenarios thuộc GĐ2, GĐ1 hiển thị gate trung tính
/// (xem `PremiumGateCard`) KHÔNG kèm giá/link web (compliance Apple 3.1.1).
///
/// Để dễ mở khóa cho tester / build nội bộ, env flag bật qua
/// `--dart-define=ENABLE_VOICE_CONVERSATIONS=true`.
class ConversationHubPage extends ConsumerStatefulWidget {
  const ConversationHubPage({super.key});

  @override
  ConsumerState<ConversationHubPage> createState() =>
      _ConversationHubPageState();
}

class _ConversationHubPageState extends ConsumerState<ConversationHubPage> {
  /// Phase 05 gate: đặt `false` ở GĐ1. Build nội bộ có thể bật qua
  /// `--dart-define=ENABLE_VOICE_CONVERSATIONS=true`.
  static const bool _kVoiceScenariosEnabled = bool.fromEnvironment(
    'ENABLE_VOICE_CONVERSATIONS',
    defaultValue: false,
  );

  final List<AIConversation> _conversations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    if (!_kVoiceScenariosEnabled) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }
    final repo = SpeakingRepository();
    final conversations = await repo.getAIConversations();
    if (mounted) {
      setState(() {
        _conversations.addAll(conversations);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.background,
      appBar: AppBar(
        title: const Text('AI Conversation'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: DesignTokens.foreground,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : !_kVoiceScenariosEnabled
              ? const _GatedView()
              : CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(child: _HeaderCard()),
                    SliverPadding(
                      padding: const EdgeInsets.all(DesignTokens.spacingMd),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                              _ScenarioCard(conversation: _conversations[index]),
                          childCount: _conversations.length,
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}

class _GatedView extends StatelessWidget {
  const _GatedView();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      child: Column(
        children: [
          const _HeaderCard(),
          const SizedBox(height: DesignTokens.spacingMd),
          const PremiumGateCard(
            title: 'AI Conversation',
            description:
                'Tính năng luyện hội thoại với AI bằng giọng nói đang được '
                'phát triển. Sẽ sớm có mặt trong bản cập nhật tiếp theo.',
            icon: Icons.record_voice_over_outlined,
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          OutlinedButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Quay lại'),
          ),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.all(DesignTokens.spacingMd),
      padding: const EdgeInsets.all(DesignTokens.spacingLg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [DesignTokens.primary, DesignTokens.tigerOrange],
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(DesignTokens.spacingSm + 4),
                decoration: BoxDecoration(
                  color: DesignTokens.card.withValues(alpha: 0.2),
                  borderRadius:
                      BorderRadius.circular(DesignTokens.radiusSm + 4),
                ),
                child: const Icon(
                  Icons.smart_toy,
                  color: DesignTokens.card,
                  size: 28,
                ),
              ),
              const SizedBox(width: DesignTokens.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Practice with AI',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: DesignTokens.card,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Have natural German conversations',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: DesignTokens.card.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          Container(
            padding: const EdgeInsets.all(DesignTokens.spacingSm + 4),
            decoration: BoxDecoration(
              color: DesignTokens.card.withValues(alpha: 0.15),
              borderRadius:
                  BorderRadius.circular(DesignTokens.radiusSm + 4),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.tips_and_updates,
                  color: DesignTokens.card,
                  size: 20,
                ),
                const SizedBox(width: DesignTokens.spacingSm + 4),
                Expanded(
                  child: Text(
                    'Choose a scenario and practice speaking naturally '
                    'with AI feedback.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: DesignTokens.card.withValues(alpha: 0.85),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScenarioCard extends StatelessWidget {
  const _ScenarioCard({required this.conversation});
  final AIConversation conversation;

  Color _levelColor(String level) {
    if (level.contains('A1')) return Colors.green;
    if (level.contains('A2')) return Colors.teal;
    if (level.contains('B1')) return Colors.blue;
    if (level.contains('B2')) return Colors.purple;
    if (level.contains('C1')) return Colors.orange;
    if (level.contains('C2')) return Colors.red;
    return DesignTokens.primary;
  }

  IconData _scenarioIcon(String title) {
    final lower = title.toLowerCase();
    if (lower.contains('café') || lower.contains('cafe')) {
      return Icons.coffee;
    }
    if (lower.contains('restaurant')) return Icons.restaurant;
    if (lower.contains('hotel')) return Icons.hotel;
    if (lower.contains('doctor') || lower.contains('arzt')) {
      return Icons.local_hospital;
    }
    if (lower.contains('travel') || lower.contains('bahnhof')) {
      return Icons.train;
    }
    if (lower.contains('shop') || lower.contains('einkauf')) {
      return Icons.shopping_bag;
    }
    if (lower.contains('interview') || lower.contains('arbeit')) {
      return Icons.work;
    }
    if (lower.contains('school') || lower.contains('universit')) {
      return Icons.school;
    }
    return Icons.chat;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final levelColor = _levelColor(conversation.level);
    return Container(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingMd),
      child: Material(
        color: DesignTokens.card,
        borderRadius: BorderRadius.circular(DesignTokens.radius),
        elevation: 2,
        shadowColor: DesignTokens.primary.withValues(alpha: 0.1),
        child: InkWell(
          onTap: () =>
              context.push('/speaking/conversation/${conversation.id}'),
          borderRadius: BorderRadius.circular(DesignTokens.radius),
          child: Padding(
            padding: const EdgeInsets.all(DesignTokens.spacingMd),
            child: Row(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: levelColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusSm + 4),
                  ),
                  child: conversation.imageUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(
                              DesignTokens.radiusSm + 4),
                          child: Image.network(
                            conversation.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Icon(
                              _scenarioIcon(conversation.title),
                              color: levelColor,
                              size: 32,
                            ),
                          ),
                        )
                      : Icon(
                          _scenarioIcon(conversation.title),
                          color: levelColor,
                          size: 32,
                        ),
                ),
                const SizedBox(width: DesignTokens.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: DesignTokens.spacingSm,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: levelColor.withValues(alpha: 0.1),
                              borderRadius:
                                  BorderRadius.circular(DesignTokens.radiusSm),
                            ),
                            child: Text(
                              conversation.level,
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: levelColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: DesignTokens.spacingSm),
                          Icon(Icons.access_time,
                              size: 14, color: DesignTokens.mutedForeground),
                          const SizedBox(width: 4),
                          Text(
                            '~${conversation.estimatedMinutes} min',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: DesignTokens.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: DesignTokens.spacingSm),
                      Text(
                        conversation.titleVi,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: DesignTokens.foreground,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        conversation.scenarioVi,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: DesignTokens.mutedForeground,
                        ),
                      ),
                      if (conversation.averageScore > 0) ...[
                        const SizedBox(height: DesignTokens.spacingSm),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                size: 16, color: DesignTokens.warning),
                            const SizedBox(width: 4),
                            Text(
                              conversation.averageScore.toStringAsFixed(1),
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              ' avg score',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: DesignTokens.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: DesignTokens.spacingSm),
                Container(
                  padding: const EdgeInsets.all(DesignTokens.spacingSm),
                  decoration: BoxDecoration(
                    color: DesignTokens.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: DesignTokens.primary,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}