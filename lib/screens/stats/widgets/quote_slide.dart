import 'package:flutter/material.dart';

import 'package:deutschtiger/core/theme/app_tokens.dart';
import 'package:deutschtiger/data/stats/quote_model.dart';

/// Accent sage green — web `#a8c686` (dots, quote-mark icon, category tag).
const Color quoteSage = Color(0xFFA8C686);

/// One full-bleed photo slide in the vertical snap feed — mirrors web
/// `QuoteSlide`: background photo with a large rounded bottom-left corner,
/// then a card overlapping the bottom edge with the DE/VI quote text.
class QuoteSlide extends StatelessWidget {
  const QuoteSlide({
    super.key,
    required this.quote,
    required this.imageUrl,
    required this.showSwipeHint,
  });

  final Quote quote;
  final String imageUrl;
  final bool showSwipeHint;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      color: tokens.card,
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(80),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(imageUrl, fit: BoxFit.cover),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.2),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.1),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _QuoteCard(
            quote: quote,
            showSwipeHint: showSwipeHint,
            tokens: tokens,
          ),
        ],
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  const _QuoteCard({
    required this.quote,
    required this.showSwipeHint,
    required this.tokens,
  });

  final Quote quote;
  final bool showSwipeHint;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              3,
              (_) => Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: quoteSage,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Icon(Icons.format_quote, color: quoteSage, size: 24),
          const SizedBox(height: 4),
          if (quote.contentDe != null && quote.contentDe!.isNotEmpty)
            Text(
              quote.contentDe!,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 1.3,
                color: tokens.foreground,
              ),
            ),
          const SizedBox(height: 8),
          Text(
            quote.contentVi,
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              height: 1.3,
              color: tokens.mutedForeground,
            ),
          ),
          if (quote.category.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              '🌿 ${quote.category}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF7A9A5A),
              ),
            ),
          ],
          if (showSwipeHint) ...[
            const SizedBox(height: 12),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.keyboard_arrow_up,
                    size: 16,
                    color: tokens.mutedForeground.withValues(alpha: 0.5),
                  ),
                  Text(
                    'Vuốt lên để xem tiếp',
                    style: TextStyle(
                      fontSize: 12,
                      color: tokens.mutedForeground.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
