import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../auth/presentation/widgets/auth_text_field.dart';
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
        const SnackBar(content: Text('Cập nhật thất bại, thử lại sau.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final saving = ref.watch(profileControllerProvider).isLoading;

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        foregroundColor: AppColors.tigerOrange,
        title: const Text(
          'Sửa hồ sơ',
          style: TextStyle(
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
                  label: 'Tên hiển thị',
                  hint: 'Nhập tên của bạn',
                  textInputAction: TextInputAction.next,
                  validator: AuthValidators.displayName,
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  controller: _avatarCtrl,
                  label: 'URL ảnh đại diện (tùy chọn)',
                  hint: 'https://...',
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 24),
                GradientButton(
                  label: 'Lưu thay đổi',
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
