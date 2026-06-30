import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import 'package:deutschtiger/widgets/common/auth_card.dart';
import 'package:deutschtiger/widgets/common/gradient_button.dart';
import 'package:deutschtiger/widgets/common/tiger_logo.dart';
import 'auth_controller.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/social_login_button.dart';

/// Màn đăng nhập native — bám sát web (src/pages/auth/login-page.tsx):
/// card trắng bo góc + border cam, logo hổ, gradient button. Email/password.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _socialLoading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    await ref
        .read(authControllerProvider.notifier)
        .login(_email.text, _password.text);
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
    final loading = ref.watch(authControllerProvider).isLoading;

    ref.listen<AsyncValue<void>>(authControllerProvider, (_, next) {
      if (next.hasError && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${next.error}')));
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
                    const TigerLogo(width: 96),
                    const SizedBox(height: 6),
                    const Text(
                      'Đăng nhập để tiếp tục học',
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
                      controller: _email,
                      label: 'Email',
                      hint: 'deutschtiger@gmail.com',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: AuthValidators.email,
                    ),
                    const SizedBox(height: 14),
                    AuthTextField(
                      controller: _password,
                      label: 'Mật khẩu',
                      hint: 'Nhập mật khẩu',
                      obscure: _obscure,
                      textInputAction: TextInputAction.done,
                      validator: AuthValidators.password,
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: loading
                            ? null
                            : () => context.push('/forgot-password'),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Quên mật khẩu?',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.orange500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GradientButton(
                      label: 'Đăng nhập',
                      loading: loading,
                      onPressed: loading ? null : _submit,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Chưa có tài khoản? ',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.mutedForeground,
                          ),
                        ),
                        GestureDetector(
                          onTap: loading ? null : () => context.push('/signup'),
                          child: const Text(
                            'Đăng ký',
                            style: TextStyle(
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

  final VoidCallback onGoogle;
  final VoidCallback onApple;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Google login
        SocialLoginButton(
          provider: 'google',
          label: 'Tiếp tục với Google',
          icon: const GoogleIconSimple(),
          onPressed: loading ? null : onGoogle,
        ),
        const SizedBox(height: 12),
        // Apple login (only show on iOS/macOS, not on web)
        if (!kIsWeb && (Platform.isIOS || Platform.isMacOS))
          SocialLoginButton(
            provider: 'apple',
            label: 'Tiếp tục với Apple',
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'hoặc',
            style: TextStyle(
              color: AppColors.mutedForeground,
              fontSize: 13,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.border)),
      ],
    );
  }
}
