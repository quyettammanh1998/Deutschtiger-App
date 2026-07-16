import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/design_tokens.dart';
import '../../../l10n/app_localizations.dart';

/// Brand mark SVGs — path data copied verbatim from web
/// `community-links.tsx` so the mark renders identically (white glyph on a
/// colored square).
class _CommunityLink {
  const _CommunityLink({
    required this.title,
    required this.description,
    required this.url,
    required this.iconSvg,
    required this.color,
  });

  final String title;
  final String description;
  final String url;
  final String iconSvg;
  final Color color;
}

const _zaloSvg = '''
<svg viewBox="0 0 48 48" fill="white" xmlns="http://www.w3.org/2000/svg">
  <path d="M12.5 7C9.46 7 7 9.46 7 12.5v23C7 38.54 9.46 41 12.5 41h23c3.04 0 5.5-2.46 5.5-5.5v-23C41 9.46 38.54 7 35.5 7h-23Zm2.05 11h18.9c.86 0 1.3 1.04.7 1.64L20.3 33.01c-.14.14-.32.22-.5.22h-.05c-.38-.03-.67-.36-.64-.74l.42-5.12h-5.18a.75.75 0 0 1-.53-1.28L25.07 18H14.55a.5.5 0 0 1 0-1h.01Z"/>
</svg>
''';

const _facebookSvg = '''
<svg viewBox="0 0 24 24" fill="white" xmlns="http://www.w3.org/2000/svg">
  <path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073Z"/>
</svg>
''';

/// "Cộng đồng Deutsch Tiger" — static Zalo + Facebook links, last block of
/// the dashboard. Mirrors web `community-links.tsx`.
class CommunityLinks extends StatelessWidget {
  const CommunityLinks({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final links = [
      _CommunityLink(
        title: 'Zalo',
        description: l10n.communityZaloDescription,
        url: 'https://zalo.me/g/sijofs162',
        iconSvg: _zaloSvg,
        color: const Color(
          0xFF3B82F6,
        ), // blue-500, matches web (not Zalo brand blue)
      ),
      _CommunityLink(
        title: 'Facebook',
        description: l10n.communityFacebookDescription,
        url: 'https://www.facebook.com/deutschtigervn',
        iconSvg: _facebookSvg,
        color: const Color(0xFF1877F2),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DesignTokens.screenHorizontalPadding,
        DesignTokens.spacingSm,
        DesignTokens.screenHorizontalPadding,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.communityLinksTitle.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
              color: DesignTokens.mutedForeground.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          Row(
            children: [
              for (var i = 0; i < links.length; i++) ...[
                if (i > 0) const SizedBox(width: DesignTokens.spacingSm),
                Expanded(child: _CommunityLinkCard(link: links[i])),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _CommunityLinkCard extends StatelessWidget {
  const _CommunityLinkCard({required this.link});

  final _CommunityLink link;

  Future<void> _open(BuildContext context) async {
    final uri = Uri.parse(link.url);
    final l10n = AppLocalizations.of(context);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.couldNotOpenLink)));
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.couldNotOpenLink)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _open(context),
      borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: DesignTokens.card,
          borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
          boxShadow: DesignTokens.shadowSm,
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: link.color,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: SvgPicture.string(link.iconSvg),
            ),
            const SizedBox(width: DesignTokens.spacingSm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    link.title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: DesignTokens.foreground,
                    ),
                  ),
                  Text(
                    link.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      color: DesignTokens.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
