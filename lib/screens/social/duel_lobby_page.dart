import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:deutschtiger/core/theme/app_tokens.dart';
import 'package:deutschtiger/view_models/providers.dart';

import 'widgets/social_avatar.dart';

/// Duel room lobby — UI shell only (web parity: `duel-lobby-page.tsx` +
/// `duel-lobby.tsx`, room-code card, host/guest player cards, invite CTA).
/// Flag-gated (`ReleaseFeatureFlags.socialDuels`, default off): the live
/// room contract (`useDuelRoom`/`useDuelMutations` on web) and the realtime
/// match loop belong to GĐ2 P3 — this screen intentionally has NO backend
/// call and NO fake opponent/score simulation (the previous `Random()`
/// matchmaking + bot logic was removed, not replaced). It shows the host
/// (current user) waiting for a real guest slot to be wired later.
class DuelLobbyPage extends ConsumerWidget {
  const DuelLobbyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final me = ref.watch(myProfileProvider).valueOrNull;

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.pop(),
                  ),
                  Text(
                    'Trận đấu trực tiếp',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: tokens.foreground,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: tokens.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: tokens.border),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Mã phòng',
                              style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '— — — —',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                                fontFamily: 'monospace',
                                color: tokens.foreground,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _PlayerSlot(
                            name: me?.displayName ?? '...',
                            avatarUrl: me?.avatarUrl,
                            label: 'Chủ phòng',
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                            child: Text(
                              'VS',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: tokens.mutedForeground,
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: tokens.border,
                                    width: 2,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Icon(Icons.add, color: tokens.mutedForeground),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Chờ đối thủ...',
                                style: TextStyle(fontSize: 13, color: tokens.mutedForeground),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Đang chờ người chơi tham gia...',
                        style: TextStyle(fontSize: 13, color: tokens.mutedForeground),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => context.push('/social/friends'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: tokens.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Mời bạn bè'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => context.pop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Hủy phòng'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayerSlot extends StatelessWidget {
  const _PlayerSlot({required this.name, required this.avatarUrl, required this.label});

  final String name;
  final String? avatarUrl;
  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      children: [
        SocialAvatar(displayName: name, avatarUrl: avatarUrl, size: 64),
        const SizedBox(height: 8),
        SizedBox(
          width: 100,
          child: Text(
            name,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: tokens.foreground),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 2),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(color: tokens.muted, borderRadius: BorderRadius.circular(999)),
          child: Text(label, style: TextStyle(fontSize: 11, color: tokens.mutedForeground)),
        ),
      ],
    );
  }
}
