import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:deutschtiger/view_models/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import 'package:deutschtiger/widgets/common/gradient_button.dart';
import 'package:deutschtiger/screens/auth/widgets/auth_text_field.dart';
import 'profile_controller.dart';

/// Màn sửa hồ sơ: đổi tên hiển thị và URL avatar (PUT /user/profile).
/// CEFR level không sửa ở đây (backend UpdateProfileInput không nhận).
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _avatarCtrl;

  @override
  void initState() {
    super.initState();
    final user = ref.read(myProfileProvider).value;
    _nameCtrl = TextEditingController(text: user?.displayName ?? '');
    _avatarCtrl = TextEditingController(text: user?.avatarUrl ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _avatarCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final avatar = _avatarCtrl.text.trim();
    final success = await ref
        .read(profileControllerProvider.notifier)
        .updateProfile(
          displayName: _nameCtrl.text.trim(),
          avatarUrl: avatar.isEmpty ? null : avatar,
        );
    if (!mounted) return;
    if (success) {
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).couldNotUpdateProfile),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final saving = ref.watch(profileControllerProvider).isLoading;

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        foregroundColor: AppColors.tigerOrange,
        title: Text(
          l10n.editProfile,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.tigerOrange,
            fontSize: 17,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthTextField(
                  controller: _nameCtrl,
                  label: l10n.displayName,
                  hint: l10n.yourName,
                  textInputAction: TextInputAction.next,
                  validator: (value) => AuthValidators.displayName(value, l10n),
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  controller: _avatarCtrl,
                  label: l10n.avatarUrlOptional,
                  hint: 'https://...',
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 24),
                GradientButton(
                  label: l10n.saveChanges,
                  loading: saving,
                  onPressed: saving ? null : _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
