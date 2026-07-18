import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../widgets/common/app_card.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// One tappable row inside the Goethe B1 hub's single "3 rows" card — web
/// parity `goethe-b1-hub-page.tsx`: 10×10 rounded-xl icon box (`bg-muted
/// text-primary`) + title/desc + trailing chevron, with `divide-y` between
/// rows. Flutter approximates the divider with a top border on every row
/// after the first (see [GoetheB1HubRows]).
class GoetheB1HubRowCard extends StatelessWidget {
  const GoetheB1HubRowCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
    this.showTopBorder = false,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;
  final bool showTopBorder;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: showTopBorder ? Border(top: BorderSide(color: tokens.border)) : null,
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: tokens.muted,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: tokens.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: tokens.foreground,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                    ),
                  ],
                ),
              ),
              Icon(PhosphorIcons.caretRight, size: 18, color: tokens.mutedForeground.withValues(alpha: 0.6)),
            ],
          ),
        ),
      ),
    );
  }
}

/// The single `card divide-y` block holding the 3 official/writing/sprechen
/// rows — extracted so [GoetheB1HubPage] itself stays a thin scaffold.
class GoetheB1HubRows extends StatelessWidget {
  const GoetheB1HubRows({super.key, required this.rows});

  final List<GoetheB1HubRowCard> rows;

  @override
  Widget build(BuildContext context) {
    return AppCard.card(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++)
            GoetheB1HubRowCard(
              icon: rows[i].icon,
              title: rows[i].title,
              description: rows[i].description,
              onTap: rows[i].onTap,
              showTopBorder: i > 0,
            ),
        ],
      ),
    );
  }
}
