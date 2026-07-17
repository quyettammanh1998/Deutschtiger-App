import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Ô nhập cho màn auth — style bám web login (label nhỏ phía trên,
/// input bg orange-50, border orange-100, bo rounded-lg) trong light;
/// dark theo `dark:bg-card dark:border-border dark:focus:border-primary`.
class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.obscure = false,
    this.keyboardType,
    this.validator,
    this.textInputAction,
    this.suffix,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tokens = context.tokens;
    // Web: text-gray-700 dark:text-foreground.
    final labelColor = isDark ? tokens.foreground : const Color(0xFF374151);
    // Web: bg-orange-50/60 border-orange-100 (light) → dark:bg-card
    // dark:border-border dark:focus:border-primary.
    final fillColor = isDark
        ? tokens.card
        : AppColors.orange50.withValues(alpha: 0.6);
    final borderColor = isDark ? tokens.border : AppColors.orange100;
    final focusColor = isDark ? tokens.primary : AppColors.tigerOrange;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4, left: 2),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: labelColor,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          style: TextStyle(fontSize: 14, color: tokens.foreground),
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: fillColor,
            suffixIcon: suffix,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: _border(borderColor),
            enabledBorder: _border(borderColor),
            focusedBorder: _border(focusColor, width: 1.5),
            errorBorder: _border(tokens.destructive),
            focusedErrorBorder: _border(tokens.destructive, width: 1.5),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

/// Validator dùng chung với thông báo lỗi theo locale đang hiển thị.
class AuthValidators {
  const AuthValidators._();

  static String? email(String? v, AppLocalizations l10n) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return l10n.emailRequired;
    final re = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!re.hasMatch(value)) return l10n.invalidEmail;
    return null;
  }

  static String? password(String? v, AppLocalizations l10n) {
    final value = v ?? '';
    if (value.isEmpty) return l10n.passwordRequired;
    if (value.length < 6) return l10n.passwordTooShort;
    return null;
  }

  /// Signup password rule — web enforces an 8-char minimum (login only
  /// checks the shorter 6-char rule above, since existing accounts may
  /// predate this stricter requirement).
  static String? passwordMin8(String? v, AppLocalizations l10n) {
    final value = v ?? '';
    if (value.isEmpty) return l10n.passwordRequired;
    if (value.length < 8) return l10n.passwordTooShortEight;
    return null;
  }

  static String? confirmPassword(
    String? v,
    String password,
    AppLocalizations l10n,
  ) {
    if ((v ?? '') != password) return l10n.passwordConfirmationMismatch;
    return null;
  }

  static String? displayName(String? v, AppLocalizations l10n) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return l10n.displayNameRequired;
    if (value.length < 2) return l10n.displayNameTooShort;
    return null;
  }
}
