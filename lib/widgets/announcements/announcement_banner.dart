import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/announcements/announcement_repository.dart';
import 'simple_markdown_text.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Amber announcement banner — web parity:
/// `components/announcement/announcement-banner.tsx`. Fetches
/// `GET /announcements?page=&public_only=` and renders each active,
/// not-yet-dismissed announcement as a dismissible amber card. Dismissal is
/// persisted locally (mirrors web's `localStorage` `dismissed_announcements`
/// key) via [SharedPreferences] so it survives app restarts but is not
/// synced across devices — matches web behavior.
///
/// **Placement (done, wave B deletion sweep):** replaces the deleted
/// `announcements_page.dart` route. `AnnouncementBanner(page: 'dashboard')`
/// sits in `lib/screens/home/home_screen.dart` ABOVE
/// `MobileDashboardHeader` (verified against `dashboard-page.tsx` —
/// `DashboardContent` renders the banner before `MobileDashboardLayout`/the
/// header entirely, not after it as originally assumed here).
/// `AnnouncementBanner(page: 'exam')` sits in
/// `lib/screens/exam/exam_screen.dart` right after the back+title header
/// row, before the provider/level cards (matches `exam-landing-page.tsx`).
class AnnouncementBanner extends ConsumerStatefulWidget {
  const AnnouncementBanner({super.key, required this.page, this.publicOnly = false});

  final String page;
  final bool publicOnly;

  @override
  ConsumerState<AnnouncementBanner> createState() => _AnnouncementBannerState();
}

class _AnnouncementBannerState extends ConsumerState<AnnouncementBanner> {
  static const _dismissedKey = 'dismissed_announcements';

  List<String> _dismissed = [];
  List<Announcement>? _announcements;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final dismissed = prefs.getStringList(_dismissedKey) ?? const [];
    try {
      final items = await ref
          .read(announcementRepositoryProvider)
          .getActive(widget.page, publicOnly: widget.publicOnly);
      if (!mounted) return;
      setState(() {
        _dismissed = dismissed;
        _announcements = items;
      });
    } catch (_) {
      // Non-fatal — banner just stays hidden, matching web's silent
      // `catch { return [] }` in `announcement-service.ts`.
      if (mounted) setState(() => _announcements = const []);
    }
  }

  Future<void> _dismiss(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final next = [..._dismissed, id];
    await prefs.setStringList(_dismissedKey, next);
    if (mounted) setState(() => _dismissed = next);
  }

  @override
  Widget build(BuildContext context) {
    final items = _announcements
        ?.where((a) => !_dismissed.contains(a.id))
        .toList(growable: false);
    if (items == null || items.isEmpty) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final a in items)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: tokens.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: tokens.warning.withValues(alpha: 0.4)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(PhosphorIcons.megaphone, size: 18, color: tokens.warning),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        a.title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: tokens.warningForeground,
                        ),
                      ),
                      const SizedBox(height: 2),
                      SimpleMarkdownText(
                        a.content,
                        style: TextStyle(fontSize: 12, color: tokens.warningForeground),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: () => _dismiss(a.id),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Icon(
                      PhosphorIcons.x,
                      size: 16,
                      color: tokens.warning,
                      semanticLabel: l10n.dismissAnnouncement,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
