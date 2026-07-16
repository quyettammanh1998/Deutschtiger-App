import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_tokens.dart';
import '../../data/notifications/notification_models.dart';
import '../../l10n/app_localizations.dart';
import '../../services/notifications/notification_service.dart';
import '../../view_models/notifications/notifications_provider.dart';
import '../../view_models/providers.dart';
import '../../widgets/common/async_state_views.dart';
import 'widgets/settings_tiles.dart';

/// `GET`/`PUT /user/notification-preferences` + `POST /user/push/test`.
/// Web parity: `settings-notification-section.tsx` — permission banner,
/// big pill toggle, timezone line, content-mode chips, "Gửi thử" test send.
/// Mobile substitutes the browser push-permission states with the OS
/// notification permission (`NotificationServiceWrapper.hasPermission`) —
/// there is no FCM subscribe/unsubscribe flow here yet (see repository
/// doc-comment), so the toggle only persists the preference row.
class NotificationPreferencesScreen extends ConsumerStatefulWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  ConsumerState<NotificationPreferencesScreen> createState() =>
      _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState
    extends ConsumerState<NotificationPreferencesScreen> {
  static const _contentModes = ['word', 'reminder', 'mix'];

  bool? _osPermissionGranted;
  bool _testing = false;
  String? _testMessage;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    try {
      final granted = await ref.read(notificationServiceProvider).hasPermission();
      if (mounted) setState(() => _osPermissionGranted = granted);
    } catch (_) {
      // Platform channel unavailable (e.g. widget tests) — leave the
      // permission state unknown rather than crashing; the banner only
      // renders when explicitly denied (`== false`).
    }
  }

  String _contentModeLabel(AppLocalizations l10n, String mode) => switch (mode) {
    'word' => l10n.notificationPreferencesContentWord,
    'reminder' => l10n.notificationPreferencesContentReminder,
    _ => l10n.notificationPreferencesContentMix,
  };

  Future<void> _pickTime(NotificationPreferences current) async {
    final parts = current.preferredTime.split(':');
    final initial = TimeOfDay(
      hour: int.tryParse(parts.elementAtOrNull(0) ?? '') ?? 7,
      minute: int.tryParse(parts.elementAtOrNull(1) ?? '') ?? 0,
    );
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked == null) return;
    final time =
        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    await ref
        .read(notificationPreferencesProvider.notifier)
        .save(current.copyWith(preferredTime: time));
  }

  Future<void> _sendTest() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _testing = true;
      _testMessage = l10n.notificationPreferencesTestSending;
    });
    try {
      await ref.read(apiClientProvider).post<dynamic>('/user/push/test');
      if (mounted) setState(() => _testMessage = l10n.notificationPreferencesTestSent);
    } catch (_) {
      if (mounted) setState(() => _testMessage = l10n.notificationPreferencesTestFailed);
    } finally {
      if (mounted) setState(() => _testing = false);
      Future.delayed(const Duration(seconds: 6), () {
        if (mounted) setState(() => _testMessage = null);
      });
    }
  }

  String _timezoneLabel(NotificationPreferences prefs) {
    if (prefs.timezone.isNotEmpty) return prefs.timezone;
    final offset = DateTime.now().timeZoneOffset;
    final sign = offset.isNegative ? '-' : '+';
    return 'UTC$sign${offset.inHours.abs().toString().padLeft(2, '0')}:${(offset.inMinutes.abs() % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(notificationPreferencesProvider);

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: state.isLoading
            ? const LoadingView()
            : state.preferences == null
            ? ErrorView(
                message: l10n.notificationLoadError,
                onRetry: () => ref.invalidate(notificationPreferencesProvider),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: tokens.foreground),
                        onPressed: () => context.pop(),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          l10n.notificationPreferencesTitle,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: tokens.foreground,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_osPermissionGranted == false) _PermissionDeniedBanner(onEnable: () async {
                    await ref.read(notificationServiceProvider).requestPermission();
                    _checkPermission();
                  }),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: tokens.card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: tokens.border.withValues(alpha: 0.5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SettingsToggleRow(
                          label: l10n.notificationPreferencesEnabledTitle,
                          description: l10n.notificationPreferencesEnabledDescription,
                          value: state.preferences!.enabled,
                          onChanged: (value) => ref
                              .read(notificationPreferencesProvider.notifier)
                              .save(state.preferences!.copyWith(enabled: value)),
                        ),
                        if (state.preferences!.enabled) ...[
                          const SizedBox(height: 4),
                          _TimeAndTimezoneRow(
                            preferences: state.preferences!,
                            timezoneLabel: _timezoneLabel(state.preferences!),
                            onTap: () => _pickTime(state.preferences!),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.notificationPreferencesContentMode,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: tokens.foreground,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: [
                              for (final mode in _contentModes)
                                SettingsChoiceChip(
                                  label: _contentModeLabel(l10n, mode),
                                  selected: state.preferences!.contentMode == mode,
                                  onTap: () => ref
                                      .read(notificationPreferencesProvider.notifier)
                                      .save(state.preferences!.copyWith(contentMode: mode)),
                                ),
                            ],
                          ),
                          if (state.error == 'save') ...[
                            const SizedBox(height: 8),
                            Text(
                              l10n.notificationPreferencesSaveError,
                              style: TextStyle(fontSize: 12, color: tokens.destructive),
                            ),
                          ],
                          Container(
                            margin: const EdgeInsets.only(top: 16),
                            padding: EdgeInsets.only(top: 16),
                            decoration: BoxDecoration(
                              border: Border(top: BorderSide(color: tokens.border)),
                            ),
                            child: Row(
                              children: [
                                OutlinedButton(
                                  onPressed: _testing ? null : _sendTest,
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: tokens.foreground,
                                    side: BorderSide(color: tokens.border),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    _testing
                                        ? l10n.notificationPreferencesTestSending
                                        : l10n.notificationPreferencesSendTest,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_testMessage != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              _testMessage!,
                              style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _TimeAndTimezoneRow extends StatelessWidget {
  const _TimeAndTimezoneRow({
    required this.preferences,
    required this.timezoneLabel,
    required this.onTap,
  });

  final NotificationPreferences preferences;
  final String timezoneLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.notificationPreferencesTime,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: tokens.foreground,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${l10n.notificationPreferencesTimezone}: $timezoneLabel',
                  style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
              foregroundColor: tokens.foreground,
              side: BorderSide(color: tokens.border),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(preferences.preferredTime),
          ),
        ],
      ),
    );
  }
}

class _PermissionDeniedBanner extends StatelessWidget {
  const _PermissionDeniedBanner({required this.onEnable});
  final VoidCallback onEnable;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tokens.destructive.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.notifications_off_outlined, color: tokens.destructive, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.notificationPermissionBlockedTitle,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: tokens.destructive,
                  ),
                ),
                Text(
                  l10n.notificationPermissionBlockedBody,
                  style: TextStyle(fontSize: 12, color: tokens.destructive),
                ),
              ],
            ),
          ),
          TextButton(onPressed: onEnable, child: Text(l10n.notificationPermissionEnableAction)),
        ],
      ),
    );
  }
}
