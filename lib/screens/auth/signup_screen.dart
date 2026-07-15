import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
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
import 'widgets/social_login_button.dart';

/// Màn đăng ký native — bám web. Sau khi đăng ký (Supabase có thể yêu cầu xác
/// nhận email) → thông báo và quay lại login.
class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _socialLoading = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final ok = await ref
        .read(authControllerProvider.notifier)
        .signUp(_email.text, _password.text, _name.text);
    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).signUpSuccess)),
      );
      context.go('/login');
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() => _socialLoading = true);
    await ref.read(authControllerProvider.notifier).loginWithGoogle();
    if (mounted) {
      setState(() => _socialLoading = false);
    }
  }

  Future<void> _loginWithApple() async {
    setState(() => _socialLoading = true);
    await ref.read(authControllerProvider.notifier).loginWithApple();
    if (mounted) {
      setState(() => _socialLoading = false);
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
                      l10n.createNewAccount,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.orange500,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Social login buttons
                    _SocialLoginSection(
                      onGoogle: _loginWithGoogle,
                      onApple: _loginWithApple,
                      loading: _socialLoading || loading,
                    ),

                    const SizedBox(height: 16),
                    const _DividerWithText(),

                    const SizedBox(height: 16),
                    AuthTextField(
                      controller: _name,
                      label: l10n.displayName,
                      hint: l10n.yourName,
                      textInputAction: TextInputAction.next,
                      validator: (value) =>
                          AuthValidators.displayName(value, l10n),
                    ),
                    const SizedBox(height: 14),
                    AuthTextField(
                      controller: _email,
                      label: l10n.email,
                      hint: 'deutschtiger@gmail.com',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) => AuthValidators.email(value, l10n),
                    ),
                    const SizedBox(height: 14),
                    AuthTextField(
                      controller: _password,
                      label: l10n.password,
                      hint: l10n.atLeastSixCharacters,
                      obscure: _obscure,
                      textInputAction: TextInputAction.done,
                      validator: (value) =>
                          AuthValidators.password(value, l10n),
                      suffix: IconButton(
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 18,
                          color: AppColors.mutedForeground,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GradientButton(
                      label: l10n.createAccount,
                      loading: loading,
                      onPressed: loading ? null : _submit,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          l10n.alreadyHaveAccount,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.mutedForeground,
                          ),
                        ),
                        TextButton(
                          onPressed: loading
                              ? null
                              : () => context.go('/login'),
                          style: TextButton.styleFrom(
                            minimumSize: const Size(48, 48),
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                          ),
                          child: Text(
                            l10n.logIn,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.orange500,
                            ),
                          ),
                        ),
                      ],
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

class _SocialLoginSection extends StatelessWidget {
  const _SocialLoginSection({
    required this.onGoogle,
    required this.onApple,
    required this.loading,
  });

  final Future<void> Function() onGoogle;
  final Future<void> Function() onApple;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Google login
        SocialLoginButton(
          provider: 'google',
          label: AppLocalizations.of(context).signUpWithGoogle,
          icon: const GoogleIconSimple(),
          onPressed: loading ? null : onGoogle,
        ),
        const SizedBox(height: 12),
        // Apple login (only show on iOS/macOS, not on web)
        if (!kIsWeb && (Platform.isIOS || Platform.isMacOS))
          SocialLoginButton(
            provider: 'apple',
            label: AppLocalizations.of(context).signUpWithApple,
            icon: const AppleIcon(),
            onPressed: loading ? null : onApple,
          ),
      ],
    );
  }
}

class _DividerWithText extends StatelessWidget {
  const _DividerWithText();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            AppLocalizations.of(context).or,
            style: TextStyle(color: AppColors.mutedForeground, fontSize: 13),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.border)),
      ],
    );
  }
}
