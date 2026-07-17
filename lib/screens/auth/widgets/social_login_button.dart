import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_tokens.dart';

/// Nút đăng nhập mạng xã hội (Google/Apple) với icon và loading state.
/// Web: `border-orange-100 bg-white text-gray-700` (light) →
/// `dark:border-border dark:bg-card dark:text-foreground`.
class SocialLoginButton extends StatefulWidget {
  const SocialLoginButton({
    super.key,
    required this.provider,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String provider;
  final String label;
  final Widget icon;
  final Future<void> Function()? onPressed;

  @override
  State<SocialLoginButton> createState() => _SocialLoginButtonState();
}

class _SocialLoginButtonState extends State<SocialLoginButton> {
  bool _isLoading = false;

  Future<void> _handlePress() async {
    if (_isLoading || widget.onPressed == null) return;
    setState(() => _isLoading = true);
    try {
      await widget.onPressed!();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tokens = context.tokens;
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: _isLoading ? null : _handlePress,
        style: OutlinedButton.styleFrom(
          backgroundColor: isDark ? tokens.card : Colors.white,
          foregroundColor: tokens.foreground,
          side: BorderSide(color: isDark ? tokens.border : AppColors.orange100),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: isDark ? tokens.primary : AppColors.tigerOrange,
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 24, height: 24, child: widget.icon),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        widget.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

/// Google icon simple representation
class GoogleIconSimple extends StatelessWidget {
  const GoogleIconSimple({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        // Google "G" badge is always white regardless of app theme
        // (matches the real Google logo convention) — fixed, not themed.
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: context.tokens.border),
      ),
      child: const Center(
        child: Text(
          'G',
          style: TextStyle(
            color: Color(0xFF4285F4),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

/// Apple icon
class AppleIcon extends StatelessWidget {
  const AppleIcon({super.key});

  @override
  Widget build(BuildContext context) {
    // Apple logo mark: black on light surfaces, white on dark (Apple HIG
    // convention for sign-in buttons) — button bg now follows the theme.
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Icon(
      Icons.apple,
      size: 24,
      color: isDark ? Colors.white : Colors.black,
    );
  }
}
