import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/design_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/common/gradient_button.dart';
import 'widgets/auth_text_field.dart';

/// Màn đặt lại mật khẩu — được mở qua deep link reset-password từ email.
/// Supabase tự xử lý token trong URL, app chỉ cần gọi updateUser với mật khẩu mới.
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordCtl = TextEditingController();
  final _confirmCtl = TextEditingController();
  bool _loading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
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
    setState(() => _loading = true);
    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: _passwordCtl.text.trim()),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).passwordResetSuccess),
          backgroundColor: DesignTokens.success,
        ),
      );
      context.go('/home');
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).couldNotResetPassword),
          backgroundColor: DesignTokens.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: DesignTokens.authBackground,
      appBar: AppBar(
        backgroundColor: DesignTokens.authBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _loading ? null : () => context.go('/login'),
        ),
        title: Text(
          l10n.resetPassword,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: DesignTokens.tigerOrange,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DesignTokens.screenHorizontalPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: DesignTokens.spacingXl),
                const Icon(
                  Icons.lock_reset_rounded,
                  size: 56,
                  color: DesignTokens.tigerOrange,
                ),
                const SizedBox(height: DesignTokens.spacingLg),
                Text(
                  l10n.enterNewPassword,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: DesignTokens.foreground,
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingSm),
                Text(
                  l10n.newPasswordDescription,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: DesignTokens.mutedForeground,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingXl),
                AuthTextField(
                  controller: _passwordCtl,
                  label: l10n.newPassword,
                  hint: '••••••••',
                  obscure: _obscurePassword,
                  validator: (value) => _validatePassword(value, l10n),
                  suffix: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingMd),
                AuthTextField(
                  controller: _confirmCtl,
                  label: l10n.confirmPassword,
                  hint: '••••••••',
                  obscure: _obscureConfirm,
                  validator: (value) => _validateConfirm(value, l10n),
                  suffix: IconButton(
                    icon: Icon(
                      _obscureConfirm
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingXl),
                GradientButton(
                  label: l10n.resetPassword,
                  loading: _loading,
                  onPressed: _loading ? null : _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
