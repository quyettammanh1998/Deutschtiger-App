import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import 'package:deutschtiger/view_models/affiliate/affiliate_provider.dart';
import 'widgets/referral_stats_card.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

class AffiliateScreen extends ConsumerWidget {
  const AffiliateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(affiliateNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Referral Program'),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                ref.read(affiliateNotifierProvider.notifier).loadProgram();
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ShareCodeCard(
                      code: state.program?.referralCode ?? 'DEUTSCH15',
                      onShare: () async {
                        final code = await ref.read(affiliateNotifierProvider.notifier).shareCode();
                        Clipboard.setData(ClipboardData(text: code));
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Code copied to clipboard!')),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    if (state.program != null) ReferralStatsCard(program: state.program!),
                    const SizedBox(height: 16),
                    if (state.program != null) ReferralTiers(tiers: state.program!.tiers),
                    const SizedBox(height: 16),
                    _ReferralsSection(referrals: state.referrals),
                    const SizedBox(height: 16),
                    _ActivitiesSection(activities: state.activities),
                  ],
                ),
              ),
            ),
    );
  }
}

class _ShareCodeCard extends StatelessWidget {
  final String code;
  final VoidCallback onShare;

  const _ShareCodeCard({required this.code, required this.onShare});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(PhosphorIcons.gift, size: 48, color: Colors.white),
          const SizedBox(height: 12),
          const Text(
            'Share & Earn',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Invite friends and earn rewards!',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  code,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(PhosphorIcons.copy, color: AppColors.primary),
                  onPressed: onShare,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onShare,
            icon: const Icon(PhosphorIcons.shareNetwork),
            label: const Text('Share Code'),
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

class _ReferralsSection extends StatelessWidget {
  final List referrals;

  const _ReferralsSection({required this.referrals});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Referrals',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (referrals.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: [
                    Icon(PhosphorIcons.users, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 8),
                    Text(
                      'No referrals yet',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ...referrals.take(3).map((ref) => Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(ref.refereeName[0]),
              ),
              title: Text(ref.refereeName),
              subtitle: Text(ref.status),
              trailing: Text(
                '+${ref.reward.toStringAsFixed(2)}\$',
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success),
              ),
            ),
          )),
      ],
    );
  }
}

class _ActivitiesSection extends StatelessWidget {
  final List activities;

  const _ActivitiesSection({required this.activities});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Activity',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (activities.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'No activity yet',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
          )
        else
          ...activities.take(5).map((act) => Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(PhosphorIcons.currencyDollar, color: AppColors.success),
              ),
              title: Text(act.description),
              subtitle: Text(_formatDate(act.createdAt)),
              trailing: Text(
                '+${act.amount.toStringAsFixed(2)}\$',
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success),
              ),
            ),
          )),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return '${diff.inMinutes}m ago';
  }
}
