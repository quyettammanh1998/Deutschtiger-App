import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/auth_card.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/tiger_logo.dart';
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
        const SnackBar(
          content: Text('Đăng ký thành công! Kiểm tra email để xác nhận.'),
        ),
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
                    const TigerLogo(width: 80),
                    const SizedBox(height: 6),
                    const Text(
                      'Tạo tài khoản mới',
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
                      label: 'Tên hiển thị',
                      hint: 'Tên của bạn',
                      textInputAction: TextInputAction.next,
                      validator: AuthValidators.displayName,
                    ),
                    const SizedBox(height: 14),
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
                      hint: 'Ít nhất 6 ký tự',
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
                    const SizedBox(height: 20),
                    GradientButton(
                      label: 'Tạo tài khoản',
                      loading: loading,
                      onPressed: loading ? null : _submit,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Đã có tài khoản? ',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.mutedForeground,
                          ),
                        ),
                        GestureDetector(
                          onTap: loading ? null : () => context.go('/login'),
                          child: const Text(
                            'Đăng nhập',
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
          label: 'Đăng ký với Google',
          icon: const GoogleIconSimple(),
          onPressed: loading ? null : onGoogle,
        ),
        const SizedBox(height: 12),
        // Apple login (only show on iOS/macOS, not on web)
        if (!kIsWeb && (Platform.isIOS || Platform.isMacOS))
          SocialLoginButton(
            provider: 'apple',
            label: 'Đăng ký với Apple',
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
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
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
