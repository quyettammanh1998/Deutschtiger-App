import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:deutschtiger/data/affiliate/affiliate_models.dart';

class ReferralStatsCard extends StatelessWidget {
  final ReferralProgram program;

  const ReferralStatsCard({super.key, required this.program});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    label: 'Total Referrals',
                    value: '${program.totalReferrals}',
                    icon: Icons.people,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: 'Active',
                    value: '${program.activeReferrals}',
                    icon: Icons.check_circle,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    label: 'Total Earnings',
                    value: '\$${program.totalEarnings.toStringAsFixed(2)}',
                    icon: Icons.account_balance_wallet,
                    color: AppColors.primary,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: 'Pending',
                    value: '\$${program.pendingEarnings.toStringAsFixed(2)}',
                    icon: Icons.schedule,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    label: 'Withdrawn',
                    value: '\$${program.withdrawnAmount.toStringAsFixed(2)}',
                    icon: Icons.payments,
                    color: AppColors.success,
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: (color ?? Colors.grey).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color ?? Colors.grey, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(color: Colors.grey[600], fontSize: 11),
            ),
          ],
        ),
      ],
    );
  }
}

class ReferralTiers extends StatelessWidget {
  final List<ReferralTier> tiers;

  const ReferralTiers({super.key, required this.tiers});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reward Tiers',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: tiers.map((tier) => _TierRow(tier: tier)).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _TierRow extends StatelessWidget {
  final ReferralTier tier;

  const _TierRow({required this.tier});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: tier.isUnlocked
                  ? AppColors.success.withValues(alpha: 0.1)
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: tier.isUnlocked
                  ? const Icon(Icons.check, color: AppColors.success)
                  : Text(
                      '${tier.referrals}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${tier.referrals} Referrals',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: tier.isUnlocked ? null : Colors.grey,
                  ),
                ),
                Text(
                  tier.reward,
                  style: TextStyle(
                    fontSize: 12,
                    color: tier.isUnlocked ? AppColors.success : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          if (tier.bonus > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '+\$${tier.bonus.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
