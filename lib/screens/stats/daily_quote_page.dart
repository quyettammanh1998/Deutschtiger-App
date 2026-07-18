import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/core/theme/app_tokens.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/view_models/stats/daily_quote_provider.dart';
import 'package:deutschtiger/widgets/common/async_state_views.dart';
import 'widgets/quote_image_assigner.dart';
import 'widgets/quote_slide.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Full-screen vertical snap photo feed of motivational quotes — mirrors web
/// `quotes/daily-quote-page.tsx`. Source: `GET /api/v1/quotes/random`
/// (`quoteHistoryProvider`, already live).
class DailyQuotePage extends ConsumerStatefulWidget {
  const DailyQuotePage({super.key});

  @override
  ConsumerState<DailyQuotePage> createState() => _DailyQuotePageState();
}

class _DailyQuotePageState extends ConsumerState<DailyQuotePage> {
  late final PageController _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final quotesAsync = ref.watch(quoteHistoryProvider);

    return Scaffold(
      backgroundColor: tokens.background,
      body: Stack(
        children: [
          quotesAsync.when(
            loading: () => const LoadingView(),
            error: (_, _) => ErrorView(
              message: l10n.couldNotLoadData,
              onRetry: () => ref.invalidate(quoteHistoryProvider),
            ),
            data: (quotes) {
              if (quotes.isEmpty) {
                return const SizedBox.shrink();
              }
              final images = assignQuoteImages(quotes.length);
              return PageView.builder(
                controller: _controller,
                scrollDirection: Axis.vertical,
                itemCount: quotes.length,
                itemBuilder: (context, index) => QuoteSlide(
                  quote: quotes[index],
                  imageUrl: images[index],
                  showSwipeHint: index == 0,
                ),
              );
            },
          ),
          Positioned(
            left: 16,
            top: MediaQuery.of(context).padding.top + 16,
            child: _GlassBackButton(onTap: () => Navigator.of(context).pop()),
          ),
        ],
      ),
    );
  }
}

class _GlassBackButton extends StatelessWidget {
  const _GlassBackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.3),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const SizedBox(
          width: 36,
          height: 36,
          child: Icon(PhosphorIcons.arrowLeft, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}
