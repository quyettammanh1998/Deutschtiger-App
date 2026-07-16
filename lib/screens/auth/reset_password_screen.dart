import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:deutschtiger/widgets/common/tiger_logo.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/auth_dark_glass_card.dart';
import 'widgets/auth_dark_text_field.dart';

enum _PageState { loading, ready, success, error }

/// Đặt lại mật khẩu — dark particle-glass rebuild mirroring
/// `reset-password-page.tsx`: verifies the Supabase `PASSWORD_RECOVERY`
/// auth event (falls back to a timeout → invalid-link error), then shows a
/// success panel (not a snackbar+redirect) once the password is updated.
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordCtl = TextEditingController();
  final _confirmCtl = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _submitting = false;
  String? _error;
  _PageState _state = _PageState.loading;

  StreamSubscription<AuthState>? _authSub;
  Timer? _timeout;

  @override
  void initState() {
    super.initState();
    _authSub = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.passwordRecovery && mounted) {
        setState(() => _state = _PageState.ready);
      }
    });
    _timeout = Timer(const Duration(seconds: 3), () {
      if (mounted && _state == _PageState.loading) {
        setState(() => _state = _PageState.error);
      }
    });
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _timeout?.cancel();
    _passwordCtl.dispose();
    _confirmCtl.dispose();
    super.dispose();
  }

  String? _validatePassword(String? v, AppLocalizations l10n) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return l10n.newPasswordRequired;
    if (value.length < 8) return l10n.newPasswordTooShort;
    return null;
  }

  String? _validateConfirm(String? v, AppLocalizations l10n) {
    if ((v ?? '').trim() != _passwordCtl.text.trim()) {
      return l10n.passwordConfirmationMismatch;
    }
    return null;
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    final l10n = AppLocalizations.of(context);
    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: _passwordCtl.text.trim()),
      );
      if (!mounted) return;
      setState(() => _state = _PageState.success);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = l10n.couldNotResetPassword);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AuthDarkGlassCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TigerLogo(width: 112),
          const SizedBox(height: 16),
          Text(
            l10n.resetPassword,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 20),
          switch (_state) {
            _PageState.loading => _LoadingPanel(l10n: l10n),
            _PageState.error => _ErrorPanel(l10n: l10n),
            _PageState.success => _SuccessPanel(l10n: l10n),
            _PageState.ready => _ResetForm(
                formKey: _formKey,
                passwordCtl: _passwordCtl,
                confirmCtl: _confirmCtl,
                obscurePassword: _obscurePassword,
                obscureConfirm: _obscureConfirm,
                submitting: _submitting,
                error: _error,
                l10n: l10n,
                onTogglePassword: () => setState(() => _obscurePassword = !_obscurePassword),
                onToggleConfirm: () => setState(() => _obscureConfirm = !_obscureConfirm),
                onSubmit: _submit,
                validatePassword: (v) => _validatePassword(v, l10n),
                validateConfirm: (v) => _validateConfirm(v, l10n),
              ),
          },
          const SizedBox(height: 24),
          Center(
            child: TextButton(
              onPressed: () => context.go('/login'),
              child: Text(
                l10n.backToLogin,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFFB923C)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingPanel extends StatelessWidget {
  const _LoadingPanel({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        const SizedBox(
          height: 32,
          width: 32,
          child: CircularProgressIndicator(strokeWidth: 4, color: Color(0xFFF97316)),
        ),
        const SizedBox(height: 12),
        Text(l10n.verifyingResetLink, style: const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF))),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _ErrorPanel extends StatelessWidget {
  const _ErrorPanel({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0x4D7F1D1D),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0x4DEF4444)),
          ),
          child: Text(
            l10n.resetLinkInvalid,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13.5, color: Color(0xFFFCA5A5)),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: TextButton(
            onPressed: () => context.go('/forgot-password'),
            child: Text(
              l10n.resendResetLink,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFFB923C)),
            ),
          ),
        ),
      ],
    );
  }
}

class _SuccessPanel extends StatelessWidget {
  const _SuccessPanel({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0x4D14532D),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0x4D22C55E)),
      ),
      child: Text(
        l10n.passwordResetSuccess,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 13.5, color: Color(0xFF86EFAC)),
      ),
    );
  }
}

class _ResetForm extends StatelessWidget {
  const _ResetForm({
    required this.formKey,
    required this.passwordCtl,
    required this.confirmCtl,
    required this.obscurePassword,
    required this.obscureConfirm,
    required this.submitting,
    required this.error,
    required this.l10n,
    required this.onTogglePassword,
    required this.onToggleConfirm,
    required this.onSubmit,
    required this.validatePassword,
    required this.validateConfirm,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController passwordCtl;
  final TextEditingController confirmCtl;
  final bool obscurePassword;
  final bool obscureConfirm;
  final bool submitting;
  final String? error;
  final AppLocalizations l10n;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirm;
  final VoidCallback onSubmit;
  final String? Function(String?) validatePassword;
  final String? Function(String?) validateConfirm;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (error != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0x4D7F1D1D),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0x4DEF4444)),
              ),
              child: Text(error!, style: const TextStyle(fontSize: 13, color: Color(0xFFFCA5A5))),
            ),
            const SizedBox(height: 16),
          ],
          AuthDarkTextField(
            controller: passwordCtl,
            label: l10n.newPassword,
            hint: l10n.newPasswordHint,
            obscure: obscurePassword,
            enabled: !submitting,
            autofillHints: const [AutofillHints.newPassword],
            validator: validatePassword,
            suffix: IconButton(
              icon: Icon(
                obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: const Color(0xFF9CA3AF),
                size: 18,
              ),
              tooltip: obscurePassword ? l10n.showPasswordTooltip : l10n.hidePasswordTooltip,
              onPressed: onTogglePassword,
            ),
          ),
          const SizedBox(height: 14),
          AuthDarkTextField(
            controller: confirmCtl,
            label: l10n.confirmPassword,
            hint: l10n.confirmPasswordHint,
            obscure: obscureConfirm,
            enabled: !submitting,
            autofillHints: const [AutofillHints.newPassword],
            validator: validateConfirm,
            suffix: IconButton(
              icon: Icon(
                obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: const Color(0xFF9CA3AF),
                size: 18,
              ),
              tooltip: obscureConfirm ? l10n.showPasswordTooltip : l10n.hidePasswordTooltip,
              onPressed: onToggleConfirm,
            ),
          ),
          const SizedBox(height: 20),
          _GradientSubmitButton(
            label: l10n.resetPassword,
            loading: submitting,
            onPressed: submitting ? null : onSubmit,
          ),
        ],
      ),
    );
  }
}

/// Orange→rose gradient submit — mirrors web `from-orange-500 to-rose-600`.
class _GradientSubmitButton extends StatelessWidget {
  const _GradientSubmitButton({required this.label, required this.onPressed, required this.loading});
  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFF97316), Color(0xFFE11D48)]),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onPressed,
            child: Container(
              height: 48,
              alignment: Alignment.center,
              child: loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(label, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      ),
    );
  }
}
