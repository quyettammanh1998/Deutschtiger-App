import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import 'package:deutschtiger/data/affiliate/affiliate_models.dart';
import 'package:deutschtiger/view_models/affiliate/affiliate_provider.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

class AffiliatePage extends ConsumerStatefulWidget {
  const AffiliatePage({super.key});

  @override
  ConsumerState<AffiliatePage> createState() => _AffiliatePageState();
}

class _AffiliatePageState extends ConsumerState<AffiliatePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(affiliateNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: const Text(
          'Chương trình giới thiệu',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.tigerOrange,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(PhosphorIcons.chartBar),
            onPressed: () => context.push('/affiliate/leaderboard'),
            tooltip: 'Leaderboard',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Tổng quan'),
            Tab(text: 'Lịch sử'),
            Tab(text: 'Thưởng'),
          ],
        ),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                ref.read(affiliateNotifierProvider.notifier).loadProgram();
              },
              child: TabBarView(
                controller: _tabController,
                children: [
                  _OverviewTab(state: state),
                  _HistoryTab(state: state),
                  _RewardsTab(state: state),
                ],
              ),
            ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  final AffiliateState state;

  const _OverviewTab({required this.state});

  @override
  Widget build(BuildContext context) {
    final program = state.program;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ReferralCodeCard(program: program),
          const SizedBox(height: 16),
          _CommissionStatsCard(program: program),
          const SizedBox(height: 16),
          _ReferralsListCard(referrals: state.referrals),
          const SizedBox(height: 16),
          _HowItWorksCard(),
        ],
      ),
    );
  }
}

class _ReferralCodeCard extends StatelessWidget {
  final ReferralProgram? program;

  const _ReferralCodeCard({required this.program});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(PhosphorIcons.gift, size: 48, color: Colors.white),
          const SizedBox(height: 12),
          const Text(
            'Mã giới thiệu của bạn',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  program?.referralCode ?? 'DEUTSCH15',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(PhosphorIcons.copy, color: AppColors.primary),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: program?.referralCode ?? 'DEUTSCH15'));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Mã đã được sao chép!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              final code = program?.referralCode ?? 'DEUTSCH15';
              final shareText = '''
🎉 Mời bạn cùng học tiếng Đức với DeutschTiger!

Dùng mã giới thiệu: $code
Để nhận ưu đãi đặc biệt khi đăng ký!

Tải app: https://deutschtiger.app/download
''';
              Clipboard.setData(ClipboardData(text: shareText));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Nội dung chia sẻ đã được sao chép!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(PhosphorIcons.shareNetwork),
            label: const Text('Chia sẻ mã'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommissionStatsCard extends StatelessWidget {
  final ReferralProgram? program;

  const _CommissionStatsCard({required this.program});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(PhosphorIcons.chartLineUp, color: AppColors.success),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Thống kê hoa hồng',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    label: 'Tổng giới thiệu',
                    value: '${program?.totalReferrals ?? 0}',
                    icon: PhosphorIcons.users,
                    color: AppColors.primary,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: 'Đang hoạt động',
                    value: '${program?.activeReferrals ?? 0}',
                    icon: PhosphorIcons.checkCircle,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    label: 'Tổng thu nhập',
                    value: '\$${(program?.totalEarnings ?? 0).toStringAsFixed(2)}',
                    icon: PhosphorIcons.wallet,
                    color: Colors.green,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: 'Chờ thanh toán',
                    value: '\$${(program?.pendingEarnings ?? 0).toStringAsFixed(2)}',
                    icon: PhosphorIcons.hourglass,
                    color: Colors.orange,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: 'Đã rút',
                    value: '\$${(program?.withdrawnAmount ?? 0).toStringAsFixed(2)}',
                    icon: PhosphorIcons.creditCard,
                    color: AppColors.primary,
                  ),
                ),
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
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ReferralsListCard extends StatelessWidget {
  final List<Referral> referrals;

  const _ReferralsListCard({required this.referrals});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(PhosphorIcons.users, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Người được giới thiệu',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (referrals.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${referrals.length}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (referrals.isEmpty)
              Center(
                child: Column(
                  children: [
                    Icon(PhosphorIcons.userPlus, size: 48, color: Colors.grey[300]),
                    const SizedBox(height: 8),
                    Text(
                      'Chưa có người được giới thiệu nào',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Chia sẻ mã của bạn để bắt đầu!',
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ],
                ),
              )
            else
              ...referrals.take(5).map((ref) => _ReferralItem(referral: ref)),
          ],
        ),
      ),
    );
  }
}

class _ReferralItem extends StatelessWidget {
  final Referral referral;

  const _ReferralItem({required this.referral});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary.withValues(alpha: 0.2),
            child: Text(
              referral.refereeName.isNotEmpty ? referral.refereeName[0] : '?',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  referral.refereeName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Row(
                  children: [
                    Icon(
                      _getStatusIcon(referral.status),
                      size: 12,
                      color: _getStatusColor(referral.status),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _getStatusLabel(referral.status),
                      style: TextStyle(
                        fontSize: 12,
                        color: _getStatusColor(referral.status),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${referral.referredUserDaysActive} ngày hoạt động',
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '+\$${referral.reward.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.success,
                ),
              ),
              if (referral.bonus > 0)
                Text(
                  '+\$${referral.bonus.toStringAsFixed(2)} bonus',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.orange,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'completed':
        return PhosphorIcons.checkCircle;
      case 'pending':
        return PhosphorIcons.hourglass;
      case 'expired':
        return PhosphorIcons.xCircle;
      default:
        return PhosphorIcons.question;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return AppColors.success;
      case 'pending':
        return Colors.orange;
      case 'expired':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'completed':
        return 'Hoàn thành';
      case 'pending':
        return 'Đang chờ';
      case 'expired':
        return 'Hết hạn';
      default:
        return status;
    }
  }
}

class _HowItWorksCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.tigerOrange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(PhosphorIcons.question, color: AppColors.tigerOrange),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Cách thức hoạt động',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _HowItWorksStep(
              number: '1',
              title: 'Chia sẻ mã của bạn',
              description: 'Gửi mã giới thiệu cho bạn bè qua tin nhắn, mạng xã hội hoặc email',
              icon: PhosphorIcons.shareNetwork,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            _HowItWorksStep(
              number: '2',
              title: 'Bạn bè đăng ký',
              description: 'Khi người được giới thiệu tạo tài khoản với mã của bạn',
              icon: PhosphorIcons.userPlus,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            _HowItWorksStep(
              number: '3',
              title: 'Nhận hoa hồng',
              description: 'Kiếm \$5 cho mỗi người hoàn thành 30 ngày học tập',
              icon: PhosphorIcons.currencyDollar,
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            _HowItWorksStep(
              number: '4',
              title: 'Nhận thưởng đặc biệt',
              description: 'Mở khóa các cấp độ thưởng với nhiều phần thưởng hơn',
              icon: PhosphorIcons.gift,
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }
}

class _HowItWorksStep extends StatelessWidget {
  final String number;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const _HowItWorksStep({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                description,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HistoryTab extends StatelessWidget {
  final AffiliateState state;

  const _HistoryTab({required this.state});

  @override
  Widget build(BuildContext context) {
    final activities = state.activities;

    if (activities.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(PhosphorIcons.clockCounterClockwise, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Chưa có hoạt động nào',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Các hoạt động hoa hồng sẽ hiển thị ở đây',
              style: TextStyle(fontSize: 12, color: Colors.grey[400]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return _ActivityItem(activity: activity);
      },
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final ReferralActivity activity;

  const _ActivityItem({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _getTypeColor(activity.type).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getTypeIcon(activity.type),
                color: _getTypeColor(activity.type),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.description,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(activity.createdAt),
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '+\$${activity.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.success,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'referral_completed':
        return PhosphorIcons.users;
      case 'tier_bonus':
        return PhosphorIcons.star;
      case 'milestone_partial':
        return PhosphorIcons.flag;
      case 'payout':
        return PhosphorIcons.creditCard;
      default:
        return PhosphorIcons.currencyDollar;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'referral_completed':
        return Colors.green;
      case 'tier_bonus':
        return Colors.purple;
      case 'milestone_partial':
        return Colors.orange;
      case 'payout':
        return Colors.blue;
      default:
        return AppColors.primary;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays} ngày trước';
    if (diff.inHours > 0) return '${diff.inHours} giờ trước';
    if (diff.inMinutes > 0) return '${diff.inMinutes} phút trước';
    return 'Vừa xong';
  }
}

class _RewardsTab extends StatelessWidget {
  final AffiliateState state;

  const _RewardsTab({required this.state});

  @override
  Widget build(BuildContext context) {
    final program = state.program;
    final tiers = program?.tiers ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PayoutInfoCard(program: program),
          const SizedBox(height: 16),
          _CommissionHistoryCard(),
          const SizedBox(height: 16),
          _TiersCard(tiers: tiers),
        ],
      ),
    );
  }
}

class _PayoutInfoCard extends StatefulWidget {
  final ReferralProgram? program;

  const _PayoutInfoCard({required this.program});

  @override
  State<_PayoutInfoCard> createState() => _PayoutInfoCardState();
}

class _PayoutInfoCardState extends State<_PayoutInfoCard> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _accountController = TextEditingController();
  String _selectedMethod = 'bank_transfer';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _accountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pendingAmount = widget.program?.pendingEarnings ?? 0;
    final minPayout = 10.0;
    final canClaim = pendingAmount >= minPayout;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(PhosphorIcons.bank, color: Colors.green),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Thông tin thanh toán',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Số dư khả dụng:'),
                      Text(
                        '\$${pendingAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Yêu cầu tối thiểu: \$${minPayout.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Phương thức thanh toán',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  _PaymentMethodSelector(
                    selected: _selectedMethod,
                    onChanged: (value) => setState(() => _selectedMethod = value),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Tên tài khoản',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(PhosphorIcons.user),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Vui lòng nhập tên';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(PhosphorIcons.envelope),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Vui lòng nhập email';
                      if (!value!.contains('@')) return 'Email không hợp lệ';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _accountController,
                    decoration: InputDecoration(
                      labelText: _selectedMethod == 'bank_transfer'
                          ? 'Số tài khoản'
                          : 'Ví điện tử',
                      border: const OutlineInputBorder(),
                      prefixIcon: Icon(
                        _selectedMethod == 'bank_transfer'
                            ? PhosphorIcons.bank
                            : PhosphorIcons.wallet,
                      ),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Vui lòng nhập số tài khoản';
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canClaim
                    ? () {
                        if (_formKey.currentState?.validate() ?? false) {
                          _showClaimConfirmation(context);
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  canClaim
                      ? 'Yêu cầu thanh toán \$${pendingAmount.toStringAsFixed(2)}'
                      : 'Số dư không đủ để rút',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClaimConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận yêu cầu'),
        content: const Text(
          'Bạn có chắc muốn yêu cầu thanh toán? Vui lòng đảm bảo thông tin tài khoản chính xác.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Yêu cầu thanh toán đã được gửi!'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodSelector extends StatelessWidget {
  final String selected;
  final Function(String) onChanged;

  const _PaymentMethodSelector({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MethodOption(
            label: 'Chuyển khoản',
            icon: PhosphorIcons.bank,
            value: 'bank_transfer',
            selected: selected,
            onTap: () => onChanged('bank_transfer'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MethodOption(
            label: 'Ví điện tử',
            icon: PhosphorIcons.wallet,
            value: 'e_wallet',
            selected: selected,
            onTap: () => onChanged('e_wallet'),
          ),
        ),
      ],
    );
  }
}

class _MethodOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final String selected;
  final VoidCallback onTap;

  const _MethodOption({
    required this.label,
    required this.icon,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selected;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.primary : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommissionHistoryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(PhosphorIcons.receipt, color: Colors.blue),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Lịch sử hoa hồng',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _CommissionHistoryItem(
              date: '2024-01-15',
              description: 'Thanh toán tháng 12',
              amount: 25.00,
              status: 'completed',
            ),
            _CommissionHistoryItem(
              date: '2024-01-01',
              description: 'Thanh toán tháng 11',
              amount: 25.00,
              status: 'completed',
            ),
          ],
        ),
      ),
    );
  }
}

class _CommissionHistoryItem extends StatelessWidget {
  final String date;
  final String description;
  final double amount;
  final String status;

  const _CommissionHistoryItem({
    required this.date,
    required this.description,
    required this.amount,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: status == 'completed' ? Colors.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              status == 'completed' ? PhosphorIcons.checkCircle : PhosphorIcons.hourglass,
              color: status == 'completed' ? Colors.green : Colors.orange,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  date,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}

class _TiersCard extends StatelessWidget {
  final List<ReferralTier> tiers;

  const _TiersCard({required this.tiers});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(PhosphorIcons.star, color: Colors.purple),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Cấp độ thưởng',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (tiers.isEmpty)
              Center(
                child: Text(
                  'Không có cấp độ nào',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              )
            else
              ...tiers.map((tier) => _TierItem(tier: tier)),
          ],
        ),
      ),
    );
  }
}

class _TierItem extends StatelessWidget {
  final ReferralTier tier;

  const _TierItem({required this.tier});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tier.isUnlocked
            ? Colors.green.withValues(alpha: 0.05)
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: tier.isUnlocked ? Colors.green.withValues(alpha: 0.3) : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: tier.isUnlocked ? Colors.green.withValues(alpha: 0.2) : Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: tier.isUnlocked
                  ? const Icon(PhosphorIcons.check, color: Colors.green)
                  : Text(
                      '${tier.referrals}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${tier.referrals} referrals',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: tier.isUnlocked ? Colors.green[700] : Colors.grey[700],
                      ),
                    ),
                    if (tier.isUnlocked) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Đã mở',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  tier.reward,
                  style: TextStyle(
                    fontSize: 12,
                    color: tier.isUnlocked ? Colors.green[600] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (tier.bonus > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: tier.isUnlocked ? Colors.green.withValues(alpha: 0.1) : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '+\$${tier.bonus.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: tier.isUnlocked ? Colors.green : Colors.grey,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
