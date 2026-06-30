import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Modal để claim streak hàng ngày.
class StreakClaimModal extends StatefulWidget {
  const StreakClaimModal({
    super.key,
    required this.open,
    required this.onClose,
    this.alreadyClaimed = false,
    this.heartbeatStreak = 0,
    this.onClaimed,
  });

  final bool open;
  final VoidCallback onClose;
  final bool alreadyClaimed;
  final int heartbeatStreak;
  final VoidCallback? onClaimed;

  @override
  State<StreakClaimModal> createState() => _StreakClaimModalState();
}

class _StreakClaimModalState extends State<StreakClaimModal> {
  late bool _claimed;
  bool _claiming = false;
  bool _notEnoughTime = false;
  int? _newStreak;

  @override
  void initState() {
    super.initState();
    _claimed = widget.alreadyClaimed;
  }

  @override
  void didUpdateWidget(StreakClaimModal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.alreadyClaimed && !oldWidget.alreadyClaimed) {
      setState(() => _claimed = true);
    }
  }

  int get _displayStreak {
    if (_newStreak != null) return _newStreak!;
    if (widget.heartbeatStreak > 0) return widget.heartbeatStreak;
    return 0;
  }

  /// Get week days (Mon-Sun).
  List<_WeekDay> _getWeekDays() {
    const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final now = DateTime.now();
    final dayOfWeek = now.weekday; // 1=Mon, 7=Sun
    final mondayOffset = dayOfWeek == 7 ? -6 : 1 - dayOfWeek;
    final monday = DateTime(now.year, now.month, now.day + mondayOffset);

    return List.generate(7, (i) {
      final d = monday.add(Duration(days: i));
      return _WeekDay(
        label: labels[i],
        date: d.day,
        fullDate: d,
        isToday: _isSameDay(d, now),
      );
    });
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> _handleClaim() async {
    if (_claimed || _claiming) return;

    setState(() => _claiming = true);

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        _claiming = false;
        _claimed = true;
        _notEnoughTime = false;
        _newStreak = (_newStreak ?? widget.heartbeatStreak) + 1;
      });
      widget.onClaimed?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.open) return const SizedBox.shrink();

    final weekDays = _getWeekDays();

    return GestureDetector(
      onTap: _claimed ? widget.onClose : null,
      child: Container(
        color: Colors.black.withValues(alpha: 0.4),
        child: BackdropFilter(
          filter: ColorFilter.mode(Colors.black.withValues(alpha: 0.1), BlendMode.darken),
          child: Center(
            child: GestureDetector(
              onTap: () {}, // Prevent tap propagation
              child: Container(
                margin: const EdgeInsets.all(16),
                constraints: const BoxConstraints(maxWidth: 340),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Close button
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: widget.onClose,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, size: 18, color: Colors.white),
                          ),
                        ),
                      ),

                      // Streak count
                      Text(
                        '$_displayStreak Streak',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _displayStreak > 0
                            ? 'Tuyệt vời! Bạn đã học liên tục $_displayStreak ngày!'
                            : 'Bắt đầu chuỗi streak hôm nay!',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.foreground.withValues(alpha: 0.8),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Week calendar
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: weekDays.map((day) {
                            final isActive = day.isToday
                                ? _claimed
                                : day.fullDate.isBefore(DateTime.now()) && _claimed;
                            return _DayItem(day: day, isActive: isActive);
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Reward section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _notEnoughTime
                                ? Colors.amber.shade300
                                : Colors.green.shade200,
                            width: 2,
                          ),
                          color: _notEnoughTime
                              ? Colors.amber.shade50
                              : Colors.green.shade50,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _claimed
                                  ? 'Đã nhận phần thưởng!'
                                  : _notEnoughTime
                                      ? 'Chưa đủ thời gian!'
                                      : 'Nhận phần thưởng!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: _claimed
                                    ? AppColors.foreground
                                    : _notEnoughTime
                                        ? Colors.amber.shade700
                                        : AppColors.foreground,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _claimed
                                  ? 'Bạn đã giữ được streak hôm nay. Hẹn gặp lại ngày mai!'
                                  : 'Bạn đã giữ được streak hôm nay. Nhận ngay nhé.',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.foreground.withValues(alpha: 0.7),
                              ),
                            ),
                            if (!_claimed) ...[
                              const SizedBox(height: 8),
                              const Text(
                                '+1 💎',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Claim button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _claimed ? widget.onClose : _handleClaim,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _claimed ? Colors.grey.shade400 : AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: _claimed ? 0 : 4,
                          ),
                          child: Text(
                            _claiming
                                ? 'Đang nhận...'
                                : _claimed
                                    ? 'Đóng'
                                    : 'Nhận ngay',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WeekDay {
  final String label;
  final int date;
  final DateTime fullDate;
  final bool isToday;

  const _WeekDay({
    required this.label,
    required this.date,
    required this.fullDate,
    required this.isToday,
  });
}

class _DayItem extends StatelessWidget {
  const _DayItem({required this.day, required this.isActive});

  final _WeekDay day;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: day.isToday
                  ? AppColors.primary
                  : isActive
                      ? Colors.green.shade400
                      : Colors.grey.shade300,
              width: 2,
            ),
            color: isActive
                ? Colors.green.shade100
                : (day.isToday ? Colors.green.shade50 : null),
          ),
          child: Center(
            child: isActive
                ? Icon(
                    Icons.local_fire_department,
                    size: 18,
                    color: day.isToday ? AppColors.primary : Colors.green.shade400,
                  )
                : null,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          day.label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: day.isToday ? FontWeight.bold : FontWeight.w500,
            color: day.isToday
                ? AppColors.primary
                : Colors.grey.shade500,
          ),
        ),
        Text(
          '${day.date}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: day.isToday ? AppColors.primary : Colors.grey.shade400,
          ),
        ),
      ],
    );
  }
}
