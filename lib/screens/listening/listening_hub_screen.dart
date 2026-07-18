import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:deutschtiger/core/icons/app_phosphor_icons.dart';
import 'package:deutschtiger/core/theme/app_tokens.dart';
import 'package:deutschtiger/data/listening/sprechen_videos.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/shared/widgets/page_intro.dart';
import 'package:deutschtiger/view_models/listening/easy_german_provider.dart';
import 'package:deutschtiger/view_models/listening/podcast_provider.dart';
import 'package:deutschtiger/view_models/youtube/youtube_provider.dart';
import 'widgets/listening_source_card.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

const _easyGermanLevels = [
  (level: 'a1', title: 'Easy German A1', desc: 'For Absolute Beginners', videoId: 'sTbqHypqM2M'),
  (level: 'a2', title: 'Easy German A2', desc: 'For Advanced Beginners', videoId: 'v-Wf1UoV-wU'),
  (level: 'b1', title: 'Easy German B1', desc: 'For Intermediate Learners', videoId: 'huwi-cjPPXU'),
  (level: 'b2', title: 'Easy German B2', desc: 'For Upper Intermediate Learners', videoId: '-TflT1ZrTIg'),
  (level: 'c1', title: 'Easy German C1', desc: 'For Advanced Learners', videoId: 'sTbqHypqM2M'),
];

String _ytThumb(String videoId) => 'https://img.youtube.com/vi/$videoId/mqdefault.jpg';

/// `/listening` — hub luyện nghe: Easy German (5 level) + nguồn khác
/// (Sprechen B1/B2, YouTube, Podcast, Audiobook). Web parity:
/// `listening-hub-page.tsx`.
class ListeningHubScreen extends ConsumerWidget {
  const ListeningHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final pending = ref.watch(pendingVideosProvider).valueOrNull ?? const [];
    final completed = ref.watch(completedVideosProvider).valueOrNull ?? const [];
    final podcastCount = ref.watch(podcastIndexProvider).valueOrNull?.length;

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () => context.pop(),
                  child: Icon(PhosphorIcons.arrowLeft, color: tokens.foreground),
                ),
                const SizedBox(width: 12),
                Text(l10n.listeningPageTitle, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: tokens.foreground)),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              l10n.listeningPageSubtitle,
              style: TextStyle(fontSize: 13, color: tokens.mutedForeground),
            ),
            const SizedBox(height: 16),
            PageIntro(
              pageKey: 'listening',
              why: l10n.listeningIntroWhy,
              todo: l10n.listeningIntroTodo,
              next: l10n.listeningIntroNext,
              nextTo: '/vocabulary',
              nextLabel: l10n.myWords,
            ),
            const SizedBox(height: 20),
            Text('Easy German', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: tokens.foreground)),
            const SizedBox(height: 10),
            for (final lvl in _easyGermanLevels) ...[
              Consumer(
                builder: (context, ref, _) {
                  final count = ref.watch(easyGermanIndexProvider(lvl.level)).valueOrNull?.length;
                  return ListeningSourceCard(
                    title: lvl.title,
                    description: lvl.desc,
                    icon: AppPhosphorIcons.play,
                    thumbnailUrl: _ytThumb(lvl.videoId),
                    count: count,
                    active: true,
                    onTap: () => context.push('/listening/easy-german/${lvl.level}'),
                  );
                },
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 8),
            Text(l10n.listeningOtherSourcesSection, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: tokens.foreground)),
            const SizedBox(height: 10),
            ListeningSourceCard(
              title: 'Sprechen B1',
              description: l10n.listeningSourceSprechenB1Desc,
              icon: AppPhosphorIcons.chatCircle,
              thumbnailUrl: _ytThumb('Mnq5y2r-26M'),
              count: sprechenB1Teil1.length + sprechenB1Teil2.length,
              active: true,
              onTap: () => context.push('/listening/sprechen-b1'),
            ),
            const SizedBox(height: 10),
            ListeningSourceCard(
              title: 'Sprechen B2',
              description: l10n.listeningSourceSprechenB2Desc,
              icon: AppPhosphorIcons.chatCircle,
              thumbnailUrl: _ytThumb('CsHn_QDjDhw'),
              count: sprechenB2Videos.length,
              active: true,
              onTap: () => context.push('/listening/sprechen-b2'),
            ),
            const SizedBox(height: 10),
            ListeningSourceCard(
              title: 'YouTube',
              description: l10n.listeningSourceYoutubeDesc,
              icon: AppPhosphorIcons.videoCamera,
              count: pending.length + completed.length,
              active: true,
              onTap: () => context.push('/listening/youtube'),
            ),
            const SizedBox(height: 10),
            ListeningSourceCard(
              title: 'Podcast',
              description: l10n.listeningSourcePodcastDesc,
              icon: AppPhosphorIcons.microphone,
              count: podcastCount,
              active: true,
              onTap: () => context.push('/listening/podcast/easy_german'),
            ),
            const SizedBox(height: 10),
            ListeningSourceCard(
              title: 'Audiobook',
              description: l10n.listeningSourceAudiobookDesc,
              icon: AppPhosphorIcons.bookOpen,
              active: false,
            ),
          ],
        ),
      ),
    );
  }
}
