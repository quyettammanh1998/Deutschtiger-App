import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import 'package:deutschtiger/widgets/common/auth_card.dart';
import 'package:deutschtiger/widgets/common/gradient_button.dart';
import 'package:deutschtiger/widgets/common/tiger_logo.dart';
import 'auth_controller.dart';
import 'widgets/auth_text_field.dart';

/// Màn quên mật khẩu — gửi email reset qua Supabase. Bám web style.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).passwordRecoverySent),
        ),
      );
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final loading = ref.watch(authControllerProvider).isLoading;

    ref.listen<AsyncValue<void>>(authControllerProvider, (_, next) {
      if (next.hasError && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.couldNotCompleteAuth)));
      }
    });

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: AuthCard(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const TigerLogo(width: 80),
                    const SizedBox(height: 6),
                    Text(
                      l10n.passwordRecovery,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.orange500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.passwordRecoveryDescription,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                    const SizedBox(height: 20),
                    AuthTextField(
                      controller: _email,
                      label: l10n.email,
                      hint: 'deutschtiger@gmail.com',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      validator: (value) => AuthValidators.email(value, l10n),
                    ),
                    const SizedBox(height: 20),
                    GradientButton(
                      label: l10n.sendRecoveryEmail,
                      loading: loading,
                      onPressed: loading ? null : _submit,
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: TextButton(
                        onPressed: loading ? null : () => context.go('/login'),
                        style: TextButton.styleFrom(
                          minimumSize: const Size(48, 48),
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                        ),
                        child: Text(
                          l10n.backToLogin,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.orange500,
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
    );
  }
}
