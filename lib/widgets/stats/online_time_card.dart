import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'package:deutschtiger/data/stats/stats_models.dart';

class OnlineTimeCard extends StatelessWidget {
  final TimeStats timeStats;
  final VoidCallback? onTap;

  const OnlineTimeCard({
    super.key,
    required this.timeStats,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.schedule,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Thời gian học online',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (onTap != null)
                    const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _TimeStatItem(
                      label: 'Hôm nay',
                      value: _formatMinutes(timeStats.todayMinutes),
                      icon: Icons.today,
                      color: AppColors.tigerOrange,
                    ),
                  ),
                  Expanded(
                    child: _TimeStatItem(
                      label: 'Tuần này',
                      value: _formatMinutes(timeStats.weekMinutes),
                      icon: Icons.date_range,
                      color: AppColors.primary,
                    ),
                  ),
                  Expanded(
                    child: _TimeStatItem(
                      label: 'Tháng này',
                      value: _formatMinutes(timeStats.monthMinutes),
                      icon: Icons.calendar_month,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
              if (timeStats.minutesByDay.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
                const Text(
                  'Biểu đồ tuần',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                _WeeklyChart(minutesByDay: timeStats.minutesByDay),
              ],
              if (timeStats.minutesByFeature.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
                const Text(
                  'Theo tính năng',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                _FeatureBreakdown(minutesByFeature: timeStats.minutesByFeature),
              ],
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.insights, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      'Trung bình ${timeStats.averageMinutesPerDay.toStringAsFixed(0)} phút/ngày',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatMinutes(int minutes) {
    if (minutes < 60) {
      return '${minutes}m';
    }
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return mins > 0 ? '${hours}h ${mins}m' : '${hours}h';
  }
}

class _TimeStatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _TimeStatItem({
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
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
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
        ),
      ],
    );
  }
}

class _WeeklyChart extends StatelessWidget {
  final Map<String, int> minutesByDay;

  const _WeeklyChart({required this.minutesByDay});

  @override
  Widget build(BuildContext context) {
    final entries = minutesByDay.entries.toList();
    if (entries.isEmpty) return const SizedBox.shrink();

    final maxMinutes = entries.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: entries.map((entry) {
          final heightRatio = maxMinutes > 0 ? entry.value / maxMinutes : 0.0;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    _formatMinutes(entry.value),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 60 * heightRatio,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppColors.primary.withOpacity(0.8),
                          AppColors.tigerOrange.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getDayLabel(entry.key),
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _formatMinutes(int minutes) {
    if (minutes < 60) return '${minutes}m';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return mins > 0 ? '${hours}h${mins}m' : '${hours}h';
  }

  String _getDayLabel(String key) {
    const dayMap = {
      'mon': 'T2',
      'tue': 'T3',
      'wed': 'T4',
      'thu': 'T5',
      'fri': 'T6',
      'sat': 'T7',
      'sun': 'CN',
      '1': 'T2',
      '2': 'T3',
      '3': 'T4',
      '4': 'T5',
      '5': 'T6',
      '6': 'T7',
      '7': 'CN',
    };
    return dayMap[key] ?? key;
  }
}

class _FeatureBreakdown extends StatelessWidget {
  final Map<String, int> minutesByFeature;

  const _FeatureBreakdown({required this.minutesByFeature});

  @override
  Widget build(BuildContext context) {
    final entries = minutesByFeature.entries.toList();
    if (entries.isEmpty) return const SizedBox.shrink();

    final total = entries.fold<int>(0, (sum, e) => sum + e.value);

    return Column(
      children: entries.map((entry) {
        final percentage = total > 0 ? entry.value / total : 0.0;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Icon(
                _getFeatureIcon(entry.key),
                size: 16,
                color: _getFeatureColor(entry.key),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _getFeatureLabel(entry.key),
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          '${entry.value} phút',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: percentage,
                        minHeight: 4,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation(_getFeatureColor(entry.key)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  IconData _getFeatureIcon(String feature) {
    const iconMap = {
      'vocabulary': Icons.book,
      'grammar': Icons.school,
      'speaking': Icons.mic,
      'listening': Icons.headphones,
      'games': Icons.games,
      'reading': Icons.article,
      'writing': Icons.edit,
      'flashcards': Icons.style,
    };
    return iconMap[feature.toLowerCase()] ?? Icons.category;
  }

  Color _getFeatureColor(String feature) {
    const colorMap = {
      'vocabulary': Colors.blue,
      'grammar': Colors.purple,
      'speaking': Colors.orange,
      'listening': Colors.green,
      'games': Colors.red,
      'reading': Colors.teal,
      'writing': Colors.indigo,
      'flashcards': Colors.pink,
    };
    return colorMap[feature.toLowerCase()] ?? AppColors.primary;
  }

  String _getFeatureLabel(String feature) {
    const labelMap = {
      'vocabulary': 'Từ vựng',
      'grammar': 'Ngữ pháp',
      'speaking': 'Nói',
      'listening': 'Nghe',
      'games': 'Trò chơi',
      'reading': 'Đọc',
      'writing': 'Viết',
      'flashcards': 'Flashcard',
    };
    return labelMap[feature.toLowerCase()] ?? feature;
  }
}

class OnlineTimeCardCompact extends StatelessWidget {
  final TimeStats timeStats;

  const OnlineTimeCardCompact({
    super.key,
    required this.timeStats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.schedule,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Thời gian học hôm nay',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatMinutes(timeStats.todayMinutes),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Tuần',
                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              ),
              Text(
                _formatMinutes(timeStats.weekMinutes),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatMinutes(int minutes) {
    if (minutes < 60) return '${minutes} phút';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return mins > 0 ? '${hours}h ${mins}m' : '${hours} giờ';
  }
}
