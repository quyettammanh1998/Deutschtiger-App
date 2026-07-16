import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:deutschtiger/widgets/common/tiger_logo.dart';
import '../../l10n/app_localizations.dart';
import 'auth_controller.dart';
import 'widgets/auth_dark_glass_card.dart';
import 'widgets/auth_dark_text_field.dart';
import 'widgets/auth_text_field.dart' show AuthValidators;

/// Quên mật khẩu — dark particle-glass rebuild mirroring
/// `forgot-password-page.tsx`: bg #050118 + particle canvas, bottom-anchored
/// glass card, success panel replaces the form (not a snackbar+redirect).
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _isSent = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final ok = await ref
        .read(authControllerProvider.notifier)
        .resetPassword(_email.text);
    if (ok && mounted) {
      setState(() => _isSent = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authControllerProvider);
    final loading = authState.isLoading;
    final error = authState.hasError ? l10n.couldNotCompleteAuth : null;

    return AuthDarkGlassCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TigerLogo(width: 112),
          const SizedBox(height: 16),
          Text(
            l10n.passwordRecovery,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.passwordRecoveryDescription,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
          ),
          const SizedBox(height: 24),
          if (_isSent)
            _SuccessPanel(email: _email.text, l10n: l10n)
          else
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (error != null) ...[
                    _ErrorBanner(message: error),
                    const SizedBox(height: 16),
                  ],
                  AuthDarkTextField(
                    controller: _email,
                    label: l10n.email,
                    hint: 'deutschtiger@gmail.com',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    enabled: !loading,
                    autofillHints: const [AutofillHints.email],
                    validator: (value) => AuthValidators.email(value, l10n),
                  ),
                  const SizedBox(height: 20),
                  _GradientSubmitButton(
                    label: l10n.sendRecoveryEmail,
                    loading: loading,
                    onPressed: loading ? null : _submit,
                  ),
                ],
              ),
            ),
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

class _SuccessPanel extends StatelessWidget {
  const _SuccessPanel({required this.email, required this.l10n});
  final String email;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0x4D14532D), // green-900/30
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0x4D22C55E)),
      ),
      child: Text(
        l10n.checkEmailForResetLink(email),
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 13.5, color: Color(0xFF86EFAC)),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0x4D7F1D1D), // red-900/30
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0x4DEF4444)),
      ),
      child: Text(message, style: const TextStyle(fontSize: 13, color: Color(0xFFFCA5A5))),
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
