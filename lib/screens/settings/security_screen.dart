import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../../services/api_client.dart';
import '../../repositories/settings/device_session_repository.dart';
import 'package:deutschtiger/view_models/settings/device_session_provider.dart';
import 'widgets/security_form_cards.dart';
import 'widgets/settings_tiles.dart';

/// Bảo mật — web parity: `settings-security-page.tsx`. Password-change card
/// (Supabase `auth.updateUser`, matching `useAuth().updatePassword` on web)
/// + signed-in devices list (`GET`/`DELETE /user/devices`) + delete-account
/// link. Web has NO delete-account UI — kept per Quyết định #3 keeper (a),
/// app-store policy requirement.
class SecurityScreen extends ConsumerStatefulWidget {
  const SecurityScreen({super.key});

  @override
  ConsumerState<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends ConsumerState<SecurityScreen> {
  final _newPasswordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  bool _changingPassword = false;
  String? _passwordMessage;
  bool _passwordError = false;
  bool _loading = false;

  @override
  void dispose() {
    _newPasswordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    final l10n = AppLocalizations.of(context);
    final newPassword = _newPasswordCtrl.text;
    if (newPassword.length < 8) {
      setState(() {
        _passwordMessage = l10n.passwordMinLength;
        _passwordError = true;
      });
      return;
    }
    if (newPassword != _confirmPasswordCtrl.text) {
      setState(() {
        _passwordMessage = l10n.passwordConfirmationMismatch;
        _passwordError = true;
      });
      return;
    }
    setState(() {
      _changingPassword = true;
      _passwordMessage = null;
    });
    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      if (!mounted) return;
      _newPasswordCtrl.clear();
      _confirmPasswordCtrl.clear();
      setState(() {
        _passwordMessage = l10n.settingsSavedMessage;
        _passwordError = false;
      });
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _passwordMessage = null);
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _passwordMessage = l10n.couldNotChangePassword;
        _passwordError = true;
      });
    } finally {
      if (mounted) setState(() => _changingPassword = false);
    }
  }

  Future<void> _signOutOtherDevices() async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.signOutOtherDevicesTitle),
        content: Text(l10n.signOutOtherDevicesBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.signOut),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    setState(() => _loading = true);
    try {
      await ref.read(deviceSessionListProvider.notifier).revokeOtherDevices();
      if (!mounted) return;
      _snack(l10n.signedOutOtherDevices);
    } on ApiException {
      if (mounted) _snack(l10n.couldNotSignOut);
    } catch (_) {
      if (mounted) _snack(l10n.couldNotSignOut);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _revokeDevice(DeviceSession device) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.signOutDeviceTitle),
        content: Text(l10n.signOutDeviceBody(deviceLabel(device, l10n))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.signOut),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      await ref.read(deviceSessionListProvider.notifier).revoke(device.sessionId);
      if (mounted) _snack(l10n.signedOutDevice);
    } on ApiException {
      if (mounted) _snack(l10n.couldNotSignOut);
    } catch (_) {
      if (mounted) _snack(l10n.couldNotSignOut);
    }
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final devicesAsync = ref.watch(deviceSessionListProvider);

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(deviceSessionListProvider.notifier).refresh(),
          child: ListView(
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
                      l10n.security,
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
              PasswordChangeCard(
                newPasswordCtrl: _newPasswordCtrl,
                confirmPasswordCtrl: _confirmPasswordCtrl,
                saving: _changingPassword,
                message: _passwordMessage,
                isError: _passwordError,
                onSubmit: _changePassword,
              ),
              const SizedBox(height: 16),
              SettingsCardLabel(l10n.signedInDevices),
              _buildDeviceSection(devicesAsync),
              const SizedBox(height: 12),
              SizedBox(
                height: 44,
                child: OutlinedButton(
                  onPressed: _loading ? null : _signOutOtherDevices,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: tokens.foreground,
                    side: BorderSide(color: tokens.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _loading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.signOutOtherDevices),
                ),
              ),
              const SizedBox(height: 16),
              SettingsCardLabel(l10n.account),
              SettingsNavRowCard(
                children: [
                  SettingsNavRow(
                    icon: Icons.delete_outline,
                    label: l10n.deleteAccount,
                    destructive: true,
                    onTap: () => context.push('/settings/delete-account'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceSection(AsyncValue<List<DeviceSession>> devicesAsync) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    return devicesAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: tokens.destructive),
            const SizedBox(width: 8),
            Expanded(child: Text(l10n.couldNotLoadDevices)),
            TextButton(
              onPressed: () => ref.read(deviceSessionListProvider.notifier).refresh(),
              child: Text(l10n.retry),
            ),
          ],
        ),
      ),
      data: (devices) {
        if (devices.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Text(l10n.noSignedInDevices),
          );
        }
        return Column(
          children: [
            for (final d in devices)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: DeviceTile(
                  device: d,
                  onRevoke: d.isCurrent ? null : () => _revokeDevice(d),
                ),
              ),
          ],
        );
      },
    );
  }
}
