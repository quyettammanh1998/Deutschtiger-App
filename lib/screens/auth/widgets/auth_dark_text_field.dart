import 'package:flutter/material.dart';

/// Dark glass input — mirrors web's `bg-white/10 border-white/10
/// text-white` fields on the forgot/reset password pages. See
/// [AuthDarkGlassCard] for why this hardcodes literal colors.
class AuthDarkTextField extends StatelessWidget {
  const AuthDarkTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.obscure = false,
    this.keyboardType,
    this.validator,
    this.textInputAction,
    this.suffix,
    this.enabled = true,
    this.autofillHints,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final Widget? suffix;
  final bool enabled;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4, left: 2),
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          enabled: enabled,
          keyboardType: keyboardType,
          validator: validator,
          textInputAction: textInputAction,
          autofillHints: autofillHints,
          style: const TextStyle(fontSize: 14, color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF)), // gray-400
            filled: true,
            fillColor: const Color(0x1AFFFFFF), // bg-white/10
            suffixIcon: suffix,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            border: _border(),
            enabledBorder: _border(),
            focusedBorder: _border(color: const Color(0xFFF97316), width: 1.5),
            errorBorder: _border(color: const Color(0xFFEF4444)),
            focusedErrorBorder: _border(color: const Color(0xFFEF4444), width: 1.5),
            errorStyle: const TextStyle(color: Color(0xFFFCA5A5)),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border({Color color = const Color(0x1AFFFFFF), double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
