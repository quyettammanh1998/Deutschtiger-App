import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';
import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../listening/listening_hub_screen.dart';
import '../news/news_list_screen.dart';
import 'reading_feed_screen.dart';

/// "Đọc & Nghe" hub — bọc 3 màn đã có sẵn (reading feed / listening hub /
/// news) sau 1 tab bar dùng chung, mirror `read-listen-hub-page.tsx`. Route
/// web `/doc-nghe`; mỗi tab mount NGUYÊN màn hiện có (không tách logic
/// riêng) — giống cách web mount lại `ReadingFeedPage`/`ListeningHubPage`/
/// `NewsPage` không đổi.
enum ReadListenTab { doc, nghe, tin }

class ReadListenHubScreen extends StatefulWidget {
  const ReadListenHubScreen({super.key});

  @override
  State<ReadListenHubScreen> createState() => _ReadListenHubScreenState();
}

class _ReadListenHubScreenState extends State<ReadListenHubScreen> {
  ReadListenTab _tab = ReadListenTab.doc;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingMd),
              decoration: BoxDecoration(
                color: tokens.background,
                border: Border(bottom: BorderSide(color: tokens.border)),
              ),
              child: Row(
                children: [
                  for (final tab in ReadListenTab.values)
                    Flexible(
                      child: _HubTabButton(
                        label: switch (tab) {
                          ReadListenTab.doc => l10n.readListenTabRead,
                          ReadListenTab.nghe => l10n.listeningPageTitle,
                          ReadListenTab.tin => l10n.newsTabLabel,
                        },
                        active: _tab == tab,
                        onTap: () => setState(() => _tab = tab),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: switch (_tab) {
                ReadListenTab.doc => const ReadingFeedScreen(),
                ReadListenTab.nghe => const ListeningHubScreen(),
                ReadListenTab.tin => const NewsListScreen(),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HubTabButton extends StatelessWidget {
  const _HubTabButton({required this.label, required this.active, required this.onTap});
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingMd, vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: active ? tokens.primary : Colors.transparent, width: 2),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: active ? tokens.primary : tokens.mutedForeground,
          ),
        ),
      ),
    );
  }
}
