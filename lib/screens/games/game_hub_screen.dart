import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/release/release_feature_flags.dart';
import '../../core/theme/app_tokens.dart';
import '../../shared/widgets/page_intro.dart';
import '../../view_models/settings/learning_preferences_provider.dart';
import '../../view_models/stats/daily_quote_provider.dart';
import '../../widgets/common/game_shell.dart';
import 'widgets/game_hub_group_grid.dart';
import 'widgets/game_hub_level_tip.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Games hub — web parity: `src/pages/game/game-hub-page.tsx`. Grouped by
/// skill/grammar topic (IA only, no new games/routes — see `GAME_GROUPS`).
class GameHubScreen extends ConsumerWidget {
  const GameHubScreen({super.key});

  static List<GameHubGroup> _groups(WidgetRef ref) {
    final aiSpeaking = ReleaseFeatureFlags.speaking;
    final aiSentenceBuilder = ReleaseFeatureFlags.sentenceBuilder;

    return [
      const GameHubGroup(title: 'Từ vựng', games: [
        GameHubCard(
          title: 'Deutsch Runner',
          description: 'Trả lời quiz & tiếp tục chạy',
          to: '/games/runner',
          gradient: [Color(0xFF3B82F6), Color(0xFF4F46E5)],
          icon: PhosphorIcons.rocketLaunch,
        ),
        GameHubCard(
          title: 'Nối từ',
          description: 'Ghép cặp từ Đức - Việt',
          to: '/games/matching',
          gradient: [Color(0xFFEC4899), Color(0xFFE11D48)],
          icon: PhosphorIcons.link,
        ),
        GameHubCard(
          title: 'Word Sprint',
          description: 'Chạy đua từ vựng 60 giây',
          to: '/games/word-sprint',
          gradient: [Color(0xFFF59E0B), Color(0xFFEA580C)],
          icon: PhosphorIcons.lightning,
        ),
        GameHubCard(
          title: 'Kiểm tra trình độ gõ tiếng Đức',
          description: 'Gõ câu B1 trong 60 giây',
          to: '/games/typing-sprint',
          gradient: [Color(0xFF0EA5E9), Color(0xFFE11D48)],
          icon: PhosphorIcons.keyboard,
        ),
        GameHubCard(
          title: 'Viết từ',
          description: 'Viết từ tiếng Đức từ nghĩa Việt',
          to: '/games/writing?type=word',
          gradient: [Color(0xFF22C55E), Color(0xFF059669)],
          icon: PhosphorIcons.pencilSimple,
        ),
        GameHubCard(
          title: 'Điền từ',
          description: 'Điền từ còn thiếu trong câu',
          to: '/games/cloze',
          gradient: [Color(0xFF06B6D4), Color(0xFFE11D48)],
          icon: PhosphorIcons.listBullets,
        ),
        GameHubCard(
          title: 'Luyện Flashcards',
          description: 'Nghe và lật thẻ đoán nghĩa',
          to: '/games/flashcards',
          gradient: [Color(0xFFA855F7), Color(0xFF7C3AED)],
          icon: PhosphorIcons.speakerHigh,
        ),
      ]),
      GameHubGroup(title: 'Ngữ pháp: Mạo từ & Cách (Kasus)', games: const [
        GameHubCard(
          title: 'Der/Die/Das',
          description: 'Đoán mạo từ đúng cho danh từ',
          to: '/games/artikel',
          gradient: [Color(0xFF14B8A6), Color(0xFF0891B2)],
          icon: PhosphorIcons.bookOpen,
        ),
        GameHubCard(
          title: 'Cases Mastery',
          description: 'Akk/Dat/Gen + Adjektivendungen',
          to: '/games/cases-mastery',
          gradient: [Color(0xFF3B82F6), Color(0xFF0891B2)],
          icon: PhosphorIcons.bookOpen,
        ),
      ]),
      const GameHubGroup(title: 'Ngữ pháp: Động từ', games: [
        GameHubCard(
          title: 'Konjugationstrainer',
          description: 'Chia động từ qua mọi thì',
          to: '/games/konjugation',
          gradient: [Color(0xFF10B981), Color(0xFF0D9488)],
          icon: PhosphorIcons.note,
        ),
      ]),
      GameHubGroup(title: 'Câu & Trật tự từ', games: [
        const GameHubCard(
          title: 'Wortstellung',
          description: 'Xếp từ đúng thứ tự trong câu',
          to: '/games/wortstellung',
          gradient: [Color(0xFFEAB308), Color(0xFFD97706)],
          icon: PhosphorIcons.textAlignLeft,
        ),
        const GameHubCard(
          title: 'Viết câu',
          description: 'Viết câu tiếng Đức hoàn chỉnh',
          to: '/games/writing?type=sentence',
          gradient: [Color(0xFF6366F1), Color(0xFF7C3AED)],
          icon: PhosphorIcons.fileText,
        ),
        if (aiSentenceBuilder)
          const GameHubCard(
            title: 'Viết câu AI',
            description: 'Viết câu tự do, AI chấm điểm',
            to: '/games/sentence-builder',
            gradient: [Color(0xFFF97316), Color(0xFFDC2626)],
            icon: PhosphorIcons.note,
          ),
      ]),
      const GameHubGroup(title: 'Nghe (Hören)', games: [
        GameHubCard(
          title: 'Luyện nghe',
          description: 'Nghe từ và chọn đáp án đúng',
          to: '/games/listening',
          gradient: [Color(0xFF8B5CF6), Color(0xFF9333EA)],
          icon: PhosphorIcons.speakerHigh,
        ),
      ]),
      GameHubGroup(title: 'Nói & Phát âm (Sprechen)', games: [
        if (aiSpeaking)
          const GameHubCard(
            title: 'Luyện Nói',
            description: 'Luyện phát âm tiếng Đức với AI',
            to: '/games/speaking',
            gradient: [Color(0xFFF43F5E), Color(0xFFDC2626)],
            icon: PhosphorIcons.microphone,
          ),
        const GameHubCard(
          title: 'Luyện phát âm',
          description: 'Umlaute, Ich-laut, R-Sound',
          to: '/games/pronunciation',
          gradient: [Color(0xFFD946EF), Color(0xFFDB2777)],
          icon: PhosphorIcons.speakerHigh,
        ),
        const GameHubCard(
          title: 'Hội thoại đời thường',
          description: 'Restaurant, Wegbeschreibung & more',
          to: '/games/conversation',
          gradient: [Color(0xFFF43F5E), Color(0xFFDC2626)],
          icon: PhosphorIcons.microphone,
        ),
      ]),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final userLevel =
        ref.watch(learningPreferencesProvider).preferences?.cefrLevel ?? 'A1';
    final groups = _groups(ref).where((g) => g.games.isNotEmpty).toList();

    return GameShell(
      title: 'Trò chơi',
      exitGuard: false,
      trailing: IconButton(
        tooltip: 'Chơi ngẫu nhiên',
        icon: const Icon(PhosphorIcons.shuffle),
        onPressed: () => _playRandom(context, groups),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GameHubLevelTip(userLevel: userLevel),
          const SizedBox(height: 16),
          const PageIntro(
            pageKey: 'games',
            why: 'Chơi để luyện phản xạ ngữ pháp & từ vựng.',
            todo: 'Chọn một trò theo kỹ năng muốn luyện.',
            next: 'Điểm XP tính vào bảng xếp hạng tuần.',
            nextTo: '/leaderboard',
            nextLabel: 'Xem bảng xếp hạng',
          ),
          const SizedBox(height: 16),
          _QuoteCard(),
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => _playRandom(context, groups),
                  child: Container(
                    width: 96,
                    height: 96,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: tokens.muted,
                      border: Border.all(
                        color: tokens.primary.withValues(alpha: 0.2),
                        width: 4,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/anh1.webp',
                        fit: BoxFit.contain,
                        errorBuilder: (_, _, _) =>
                            Icon(PhosphorIcons.gameController, size: 40, color: tokens.primary),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'BẮT ĐẦU NHANH',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: tokens.foreground,
                  ),
                ),
                Text(
                  'Chơi ngẫu nhiên một trò chơi',
                  style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                ),
              ],
            ),
          ),
          if (ReleaseFeatureFlags.speaking) ...[
            const SizedBox(height: 16),
            _ShadowingBanner(onTap: () => context.push('/games/speaking?daily=1')),
          ],
          const SizedBox(height: 20),
          Text(
            'Chọn trò chơi',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: tokens.foreground,
            ),
          ),
          const SizedBox(height: 14),
          for (final group in groups) ...[
            GameHubGroupSection(group: group),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  void _playRandom(BuildContext context, List<GameHubGroup> groups) {
    final all = groups.expand((g) => g.games).toList();
    if (all.isEmpty) return;
    final pick = all[Random().nextInt(all.length)];
    context.push(pick.to);
  }
}

class _QuoteCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final quoteAsync = ref.watch(quoteHistoryProvider);
    return quoteAsync.maybeWhen(
      data: (quotes) {
        if (quotes.isEmpty) return const SizedBox.shrink();
        final quote = quotes[Random().nextInt(quotes.length)];
        final hasDe = (quote.contentDe ?? '').isNotEmpty;
        return Column(
          children: [
            if (hasDe)
              Text(
                '„${quote.contentDe}"',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  color: tokens.foreground,
                ),
              ),
            Text(
              hasDe ? quote.contentVi : '„${quote.contentVi}"',
              textAlign: TextAlign.center,
              style: hasDe
                  ? TextStyle(fontSize: 12, color: tokens.mutedForeground)
                  : TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                      color: tokens.foreground,
                    ),
            ),
          ],
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _ShadowingBanner extends StatelessWidget {
  const _ShadowingBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? Colors.blue.shade900.withValues(alpha: 0.3) : Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.blue.shade900 : Colors.blue.shade200,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF43F5E), Color(0xFFDC2626)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(PhosphorIcons.microphone, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Shadowing 1 câu hôm nay',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: tokens.foreground,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Nghe mẫu, đọc lại một câu, nhận góp ý nhẹ. Không chấm phạt.',
                    style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
