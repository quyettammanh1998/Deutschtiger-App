import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_tokens.dart';
import '../../../core/release/release_feature_flags.dart';
import '../../../l10n/app_localizations.dart';

/// Dashboard premium upsell strip — mirrors web `PremiumBanner`. Gated on
/// [ReleaseFeatureFlags.premium] (release-deferred, currently off) and hidden
/// for premium users, matching web's `if (profile?.is_premium) return null`.
///
/// Renders the same full-width `premium-banner.webp` artwork the web app uses
/// (rounded corners + soft shadow), so when the flag is enabled the surface
/// matches web 1:1.
class PremiumBanner extends StatelessWidget {
  const PremiumBanner({super.key, this.isPremiumUser = false});

  final bool isPremiumUser;

  @override
  Widget build(BuildContext context) {
    if (!ReleaseFeatureFlags.premium || isPremiumUser) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.screenHorizontalPadding,
      ),
      child: GestureDetector(
        onTap: () => context.push('/settings/premium'),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(DesignTokens.radius),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(DesignTokens.radius),
              boxShadow: DesignTokens.shadowMd,
            ),
            child: Image.asset(
              'assets/images/premium-banner.webp',
              width: double.infinity,
              fit: BoxFit.fitWidth,
              semanticLabel: l10n.premiumBannerCta,
            ),
          ),
        ),
      ),
    );
  }
}
