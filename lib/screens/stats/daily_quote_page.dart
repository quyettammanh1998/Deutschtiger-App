import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import 'package:deutschtiger/data/stats/quote_model.dart';
import 'package:deutschtiger/widgets/common/async_state_views.dart';
import 'package:deutschtiger/view_models/stats/daily_quote_provider.dart';

/// Câu nói tạo động lực trong ngày (Đức + dịch Việt).
/// Nguồn: `GET /api/v1/quotes/daily` (câu chính) + `/quotes/random` (khám phá).
class DailyQuotePage extends ConsumerStatefulWidget {
  const DailyQuotePage({super.key});

  @override
  ConsumerState<DailyQuotePage> createState() => _DailyQuotePageState();
}

class _DailyQuotePageState extends ConsumerState<DailyQuotePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _reload() {
    _animationController.reset();
    ref.invalidate(dailyQuoteProvider);
    _animationController.forward();
  }

  void _shareQuote(Quote quote) {
    final l10n = AppLocalizations.of(context);
    final text = '"${quote.contentDe ?? quote.contentVi}"\n\n${quote.contentVi}';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.dailyQuoteCopySuccess),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final quoteAsync = ref.watch(dailyQuoteProvider);
    final historyAsync = ref.watch(quoteHistoryProvider);

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            backgroundColor: AppColors.authBackground,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                l10n.dailyQuoteTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.tigerOrange,
                  fontSize: 18,
                ),
              ),
              centerTitle: true,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withValues(alpha: 0.1),
                      AppColors.tigerOrange.withValues(alpha: 0.1),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _reload,
                tooltip: l10n.dailyQuoteRetryTooltip,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: quoteAsync.when(
              loading: () => const SizedBox(height: 300, child: LoadingView()),
              error: (e, _) => SizedBox(
                height: 300,
                child: ErrorView(
                  message: l10n.couldNotLoadData,
                  onRetry: _reload,
                ),
              ),
              data: (quote) => FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _QuoteCard(
                    quote: quote,
                    onShare: () => _shareQuote(quote),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
              child: Row(
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    color: AppColors.tigerOrange,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.dailyQuoteExploreMore,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: historyAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
              data: (quotes) => _QuotesGrid(quotes: quotes.take(6).toList()),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  const _QuoteCard({required this.quote, required this.onShare});

  final Quote quote;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.8),
            AppColors.tigerOrange.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (quote.category.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      quote.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: onShare,
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (quote.contentDe != null && quote.contentDe!.isNotEmpty)
              Text(
                '"${quote.contentDe}"',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                  fontStyle: FontStyle.italic,
                ),
              ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                quote.contentVi,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuotesGrid extends StatelessWidget {
  const _QuotesGrid({required this.quotes});

  final List<Quote> quotes;

  @override
  Widget build(BuildContext context) {
    if (quotes.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: quotes
            .map(
              (quote) => SizedBox(
                width:
                    (MediaQuery.of(context).size.width - 16 * 2 - 12) / 2,
                child: _MiniQuoteCard(quote: quote),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _MiniQuoteCard extends StatelessWidget {
  const _MiniQuoteCard({required this.quote});

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            quote.contentDe?.isNotEmpty == true
                ? quote.contentDe!
                : quote.contentVi,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            quote.contentVi,
            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
