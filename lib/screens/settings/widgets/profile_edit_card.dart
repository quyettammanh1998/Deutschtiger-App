import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/identity/app_user.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/premium_crown.dart';
import '../../../view_models/providers.dart';
import '../../../view_models/settings/profile_edit_provider.dart';
import '../../../widgets/common/app_card.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Settings-root profile-edit card — avatar (URL-based, no crop/upload
/// pipeline on mobile) + display name + read-only email + premium badge +
/// save. Web parity: `settings-profile-section.tsx`.
///
/// This card is the merge target for the deleted `EditProfileScreen`
/// (`lib/screens/profile/edit_profile_screen.dart`, owned by the
/// social/profile phase in the same wave) — same `PUT /user/profile`
/// contract (`displayName`/`avatarUrl`), now inline instead of a separate
/// screen.
class ProfileEditCard extends ConsumerStatefulWidget {
  const ProfileEditCard({super.key});

  @override
  ConsumerState<ProfileEditCard> createState() => _ProfileEditCardState();
}

class _ProfileEditCardState extends ConsumerState<ProfileEditCard> {
  late final TextEditingController _nameCtrl;
  bool _seeded = false;
  String? _savedMessage;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _seedFrom(AppUser user) {
    if (_seeded) return;
    _seeded = true;
    _nameCtrl.text = user.displayName;
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    final ok = await ref.read(profileEditProvider.notifier).save(displayName: name);
    if (!mounted) return;
    setState(
      () => _savedMessage = ok ? l10n.settingsSavedMessage : l10n.couldNotUpdateProfile,
    );
    if (ok) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _savedMessage = null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final profileAsync = ref.watch(myProfileProvider);
    final email = ref.watch(authServiceProvider).currentUser?.email;
    final editState = ref.watch(profileEditProvider);

    final user = profileAsync.valueOrNull;
    if (user != null) _seedFrom(user);

    return AppCard.card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              l10n.editProfile,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                color: tokens.mutedForeground,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: tokens.primary.withValues(alpha: 0.15),
                backgroundImage: (user?.avatarUrl?.isNotEmpty ?? false)
                    ? NetworkImage(user!.avatarUrl!)
                    : null,
                child: (user?.avatarUrl?.isNotEmpty ?? false)
                    ? null
                    : Text(
                        (user?.displayName.isNotEmpty ?? false)
                            ? user!.displayName[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: tokens.primary,
                        ),
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        l10n.avatarUrlOptional,
                        style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (user?.isPremium ?? false) ...[
                      const SizedBox(width: 6),
                      const PremiumCrown(compact: true),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.displayName,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: tokens.foreground),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _nameCtrl,
            decoration: InputDecoration(
              filled: true,
              fillColor: tokens.muted,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              hintText: l10n.yourName,
            ),
          ),
          if (email != null && email.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              l10n.email,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: tokens.foreground),
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: tokens.muted.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(PhosphorIcons.envelope, size: 16, color: tokens.mutedForeground),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      email,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13, color: tokens.mutedForeground),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              GestureDetector(
                onTap: editState.saving ? null : _save,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [tokens.primary, tokens.brandDark],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    editState.saving ? l10n.saving : l10n.save,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              if (_savedMessage != null) ...[
                const SizedBox(width: 12),
                Text(
                  _savedMessage!,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: editState.error != null ? tokens.destructive : tokens.success,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
