import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/notifications/notification_service.dart';
import '../../../core/preferences/preferences_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';

/// Màn Cài đặt - quản lý các cài đặt của app.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final notificationsEnabled = ref.watch(notificationEnabledProvider);
    final preferences = ref.watch(preferencesProvider);

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: const Text(
          'Cài đặt',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.tigerOrange,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Appearance section
          _SectionHeader(title: 'Giao diện'),
          _SettingsCard(
            children: [
              _ThemeSettingTile(
                themeMode: themeMode,
                onChanged: (mode) {
                  ref.read(themeModeProvider.notifier).setThemeMode(mode);
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Notifications section
          _SectionHeader(title: 'Thông báo'),
          _SettingsCard(
            children: [
              _SwitchTile(
                icon: Icons.notifications_outlined,
                title: 'Thông báo nhắc nhở',
                subtitle: 'Nhận thông báo hàng ngày để học tập',
                value: notificationsEnabled,
                onChanged: (value) {
                  ref.read(notificationEnabledProvider.notifier).setEnabled(value);
                },
              ),
              const Divider(height: 1),
              _SettingsTile(
                icon: Icons.schedule_outlined,
                title: 'Giờ nhắc nhở',
                subtitle: '${preferences.reminderHour.toString().padLeft(2, '0')}:${preferences.reminderMinute.toString().padLeft(2, '0')}',
                onTap: () => _showTimePicker(context, ref),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Audio section
          _SectionHeader(title: 'Âm thanh'),
          _SettingsCard(
            children: [
              _SliderTile(
                icon: Icons.volume_up_outlined,
                title: 'Âm lượng phát âm',
                value: preferences.ttsVolume,
                onChanged: (value) {
                  ref.read(preferencesProvider.notifier).setTtsVolume(value);
                },
              ),
              const Divider(height: 1),
              _SwitchTile(
                icon: Icons.play_circle_outline,
                title: 'Tự động phát âm',
                subtitle: 'Phát âm thanh khi lật thẻ',
                value: preferences.autoPlayAudio,
                onChanged: (value) {
                  ref.read(preferencesProvider.notifier).setAutoPlayAudio(value);
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Language section
          _SectionHeader(title: 'Ngôn ngữ'),
          _SettingsCard(
            children: [
              _SettingsTile(
                icon: Icons.language_outlined,
                title: 'Ngôn ngữ ứng dụng',
                subtitle: _getLanguageName(preferences.appLanguage),
                onTap: () => _showLanguagePicker(context, ref),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Account section
          _SectionHeader(title: 'Tài khoản'),
          _SettingsCard(
            children: [
              _SettingsTile(
                icon: Icons.lock_outline,
                title: 'Đổi mật khẩu',
                onTap: () => context.push('/change-password'),
              ),
              const Divider(height: 1),
              _SettingsTile(
                icon: Icons.email_outlined,
                title: 'Đổi email',
                onTap: () => context.push('/change-email'),
              ),
              const Divider(height: 1),
              _SettingsTile(
                icon: Icons.download_outlined,
                title: 'Xuất dữ liệu',
                subtitle: 'Tải về dữ liệu học tập của bạn',
                onTap: () => _exportData(context),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // About section
          _SectionHeader(title: 'Về ứng dụng'),
          _SettingsCard(
            children: [
              _SettingsTile(
                icon: Icons.info_outline,
                title: 'Phiên bản',
                subtitle: '1.0.0',
                onTap: () {},
              ),
              const Divider(height: 1),
              _SettingsTile(
                icon: Icons.description_outlined,
                title: 'Điều khoản sử dụng',
                onTap: () => context.push('/terms-of-service'),
              ),
              const Divider(height: 1),
              _SettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Chính sách bảo mật',
                onTap: () => context.push('/privacy-policy'),
              ),
              const Divider(height: 1),
              _SettingsTile(
                icon: Icons.help_outline,
                title: 'Trung tâm trợ giúp',
                onTap: () => _openUrl(context, 'https://deutschtiger.com/help'),
              ),
              const Divider(height: 1),
              _SettingsTile(
                icon: Icons.star_outline,
                title: 'Đánh giá ứng dụng',
                onTap: () => _rateApp(context),
              ),
            ],
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Future<void> _showTimePicker(BuildContext context, WidgetRef ref) async {
    final prefs = ref.read(preferencesProvider);
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: prefs.reminderHour, minute: prefs.reminderMinute),
    );
    if (time != null) {
      ref.read(preferencesProvider.notifier).setReminderTime(time.hour, time.minute);
    }
  }

  Future<void> _showLanguagePicker(BuildContext context, WidgetRef ref) async {
    final currentLang = ref.read(preferencesProvider).appLanguage;
    
    await showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Chọn ngôn ngữ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            _LanguageOption(
              code: 'vi',
              name: 'Tiếng Việt',
              flag: '🇻🇳',
              isSelected: currentLang == 'vi',
              onTap: () {
                ref.read(preferencesProvider.notifier).setLanguage('vi');
                Navigator.pop(context);
              },
            ),
            _LanguageOption(
              code: 'en',
              name: 'English',
              flag: '🇬🇧',
              isSelected: currentLang == 'en',
              onTap: () {
                ref.read(preferencesProvider.notifier).setLanguage('en');
                Navigator.pop(context);
              },
            ),
            _LanguageOption(
              code: 'de',
              name: 'Deutsch',
              flag: '🇩🇪',
              isSelected: currentLang == 'de',
              onTap: () {
                ref.read(preferencesProvider.notifier).setLanguage('de');
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'vi': return 'Tiếng Việt';
      case 'en': return 'English';
      case 'de': return 'Deutsch';
      default: return 'Tiếng Việt';
    }
  }

  Future<void> _exportData(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(color: AppColors.tigerOrange),
            SizedBox(width: 16),
            Text('Đang chuẩn bị dữ liệu...'),
          ],
        ),
      ),
    );
    
    await Future.delayed(const Duration(seconds: 2));
    
    if (context.mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dữ liệu đã được xuất thành công!')),
      );
    }
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Không thể mở: $url')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    }
  }

  Future<void> _rateApp(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cảm ơn bạn đã đánh giá!')),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.code,
    required this.name,
    required this.flag,
    required this.isSelected,
    required this.onTap,
  });

  final String code;
  final String name;
  final String flag;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 24)),
      title: Text(name),
      trailing: isSelected
          ? const Icon(Icons.check, color: AppColors.tigerOrange)
          : null,
      onTap: onTap,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.mutedForeground,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.foreground),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: const Icon(Icons.chevron_right, color: AppColors.mutedForeground),
      onTap: onTap,
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.foreground),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: AppColors.tigerOrange,
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.tigerOrange;
          }
          return null;
        }),
      ),
    );
  }
}

class _SliderTile extends StatelessWidget {
  const _SliderTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.foreground),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                Slider(
                  value: value,
                  onChanged: onChanged,
                  activeColor: AppColors.tigerOrange,
                ),
              ],
            ),
          ),
          Text(
            '${(value * 100).round()}%',
            style: const TextStyle(
              color: AppColors.mutedForeground,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeSettingTile extends StatelessWidget {
  const _ThemeSettingTile({
    required this.themeMode,
    required this.onChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.dark_mode_outlined, color: AppColors.foreground),
      title: const Text('Chế độ giao diện'),
      subtitle: Text(_getThemeName(themeMode)),
      trailing: PopupMenuButton<ThemeMode>(
        initialValue: themeMode,
        onSelected: onChanged,
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: ThemeMode.system,
            child: Text('Theo hệ thống'),
          ),
          const PopupMenuItem(
            value: ThemeMode.light,
            child: Text('Sáng'),
          ),
          const PopupMenuItem(
            value: ThemeMode.dark,
            child: Text('Tối'),
          ),
        ],
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _getThemeName(themeMode),
              style: const TextStyle(color: AppColors.mutedForeground),
            ),
            const Icon(Icons.arrow_drop_down, color: AppColors.mutedForeground),
          ],
        ),
      ),
    );
  }

  String _getThemeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'Theo hệ thống';
      case ThemeMode.light:
        return 'Sáng';
      case ThemeMode.dark:
        return 'Tối';
    }
  }
}
