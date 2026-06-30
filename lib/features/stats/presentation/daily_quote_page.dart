import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';

final dailyQuoteProvider = FutureProvider<Quote>((ref) async {
  await Future.delayed(const Duration(milliseconds: 300));
  return QuoteRepository.getDailyQuote();
});

final quoteHistoryProvider = FutureProvider<List<Quote>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 300));
  return QuoteRepository.getAllQuotes();
});

class Quote {
  final String id;
  final String text;
  final String translation;
  final String author;
  final String? authorInfo;
  final String category;
  final DateTime date;

  const Quote({
    required this.id,
    required this.text,
    required this.translation,
    required this.author,
    this.authorInfo,
    required this.category,
    required this.date,
  });
}

class QuoteRepository {
  static final List<Quote> _quotes = [
    Quote(
      id: 'q1',
      text: 'Übung macht den Meister.',
      translation: 'Practice makes perfect.',
      author: 'German Proverb',
      category: 'Motivation',
      date: DateTime.now(),
    ),
    Quote(
      id: 'q2',
      text: 'Wer rastet, der rostet.',
      translation: 'Who rests, rusts. (Idle hands are the devil\'s workshop)',
      author: 'German Proverb',
      category: 'Motivation',
      date: DateTime.now(),
    ),
    Quote(
      id: 'q3',
      text: 'Der Weg ist das Ziel.',
      translation: 'The way is the goal.',
      author: 'Confucius (German translation)',
      category: 'Philosophy',
      date: DateTime.now(),
    ),
    Quote(
      id: 'q4',
      text: 'Man lernt nie aus.',
      translation: 'You never stop learning.',
      author: 'German Proverb',
      category: 'Learning',
      date: DateTime.now(),
    ),
    Quote(
      id: 'q5',
      text: 'Geduld ist eine Tugend.',
      translation: 'Patience is a virtue.',
      author: 'German Proverb',
      category: 'Character',
      date: DateTime.now(),
    ),
    Quote(
      id: 'q6',
      text: 'Alle Wege führen nach Rom.',
      translation: 'All roads lead to Rome.',
      author: 'German Proverb',
      category: 'Philosophy',
      date: DateTime.now(),
    ),
    Quote(
      id: 'q7',
      text: 'Was du heute kannst besorgen, das verschiebe nicht auf morgen.',
      translation: 'Never put off till tomorrow what you can do today.',
      author: 'Benjamin Franklin (German version)',
      category: 'Motivation',
      date: DateTime.now(),
    ),
    Quote(
      id: 'q8',
      text: 'Das Leben ist wie ein Fahrrad. Um das Gleichgewicht zu halten, musst du dich weiterbewegen.',
      translation: 'Life is like riding a bicycle. To keep your balance, you must keep moving.',
      author: 'Albert Einstein',
      authorInfo: 'German-born theoretical physicist',
      category: 'Life',
      date: DateTime.now(),
    ),
    Quote(
      id: 'q9',
      text: 'Sprache ist die Kleidung der Gedanken.',
      translation: 'Language is the clothing of thoughts.',
      author: 'Samuel Butler (German equivalent)',
      category: 'Language',
      date: DateTime.now(),
    ),
    Quote(
      id: 'q10',
      text: 'Ein Mensch, der keine Fremdsprache kennt, weiß nichts von seiner eigenen.',
      translation: 'A person who knows no foreign language knows nothing of their own.',
      author: 'Johann Wolfgang von Goethe',
      authorInfo: 'German writer and statesman',
      category: 'Language',
      date: DateTime.now(),
    ),
    Quote(
      id: 'q11',
      text: 'Reden ist Silber, Schweigen ist Gold.',
      translation: 'Talking is silver, silence is gold.',
      author: 'German Proverb',
      category: 'Wisdom',
      date: DateTime.now(),
    ),
    Quote(
      id: 'q12',
      text: 'Kleider machen Leute.',
      translation: 'Clothes make the person.',
      author: 'Gottfried Keller',
      authorInfo: 'Swiss German author',
      category: 'Society',
      date: DateTime.now(),
    ),
    Quote(
      id: 'q13',
      text: 'Viele kleine Leute, die an vielen kleinen Orten viele kleine Dinge tun, können das Gesicht der Welt verändern.',
      translation: 'Many small people, who in many small places, do many small things, can alter the face of the world.',
      author: 'African Proverb (German popular)',
      category: 'Community',
      date: DateTime.now(),
    ),
    Quote(
      id: 'q14',
      text: 'Der Klügere gibt nach.',
      translation: 'The wiser one gives in.',
      author: 'German Proverb',
      category: 'Wisdom',
      date: DateTime.now(),
    ),
    Quote(
      id: 'q15',
      text: 'Ohne Fleiß kein Preis.',
      translation: 'No pain, no gain.',
      author: 'German Proverb',
      category: 'Motivation',
      date: DateTime.now(),
    ),
    Quote(
      id: 'q16',
      text: 'Die Hoffnung stirbt zuletzt.',
      translation: 'Hope dies last.',
      author: 'German Proverb',
      category: 'Hope',
      date: DateTime.now(),
    ),
    Quote(
      id: 'q17',
      text: 'Frisch gewagt ist halb gewonnen.',
      translation: 'Daring is half the battle.',
      author: 'German Proverb',
      category: 'Motivation',
      date: DateTime.now(),
    ),
    Quote(
      id: 'q18',
      text: 'Zeit ist Geld.',
      translation: 'Time is money.',
      author: 'Benjamin Franklin (German version)',
      category: 'Wisdom',
      date: DateTime.now(),
    ),
    Quote(
      id: 'q19',
      text: 'Andere Länder, andere Sitten.',
      translation: 'Other countries, other customs.',
      author: 'German Proverb',
      category: 'Culture',
      date: DateTime.now(),
    ),
    Quote(
      id: 'q20',
      text: 'Zu viel des Guten ist ungesund.',
      translation: 'Too much of a good thing is unhealthy.',
      author: 'German Proverb',
      category: 'Balance',
      date: DateTime.now(),
    ),
    Quote(
      id: 'q21',
      text: 'Lachen ist die beste Medizin.',
      translation: 'Laughter is the best medicine.',
      author: 'German Proverb',
      category: 'Health',
      date: DateTime.now(),
    ),
    Quote(
      id: 'q22',
      text: 'Nach dem Regen scheint die Sonne.',
      translation: 'After the rain, the sun shines.',
      author: 'German Proverb',
      category: 'Hope',
      date: DateTime.now(),
    ),
    Quote(
      id: 'q23',
      text: 'Jeder ist seines Glückes Schmied.',
      translation: 'Every man is the architect of his own fortune.',
      author: 'German Proverb',
      category: 'Responsibility',
      date: DateTime.now(),
    ),
    Quote(
      id: 'q24',
      text: 'Was mich nicht umbringt, macht mich stärker.',
      translation: 'What doesn\'t kill me makes me stronger.',
      author: 'Friedrich Nietzsche',
      authorInfo: 'German philosopher',
      category: 'Resilience',
      date: DateTime.now(),
    ),
    Quote(
      id: 'q25',
      text: 'Es ist nicht genug, zu wissen, man muss auch anwenden.',
      translation: 'It is not enough to know, one must also apply.',
      author: 'Johann Wolfgang von Goethe',
      authorInfo: 'German writer and statesman',
      category: 'Action',
      date: DateTime.now(),
    ),
    Quote(
      id: 'q26',
      text: 'Handle so, dass die Maxime deines Willens jederzeit zugleich als Prinzip einer allgemeinen Gesetzgebung dienen könnte.',
      translation: 'Act only according to that maxim whereby you can at the same time will that it should become a universal law.',
      author: 'Immanuel Kant',
      authorInfo: 'German philosopher',
      category: 'Ethics',
      date: DateTime.now(),
    ),
    Quote(
      id: 'q27',
      text: 'Zwei Seelen wohnen, ach, in meiner Brust.',
      translation: 'Two souls dwell, alas, in my breast.',
      author: 'Johann Wolfgang von Goethe',
      authorInfo: 'Faust',
      category: 'Literature',
      date: DateTime.now(),
    ),
    Quote(
      id: 'q28',
      text: 'Eritis sicut Deus, scientes bonum et malum.',
      translation: 'You shall be like God, knowing good and evil.',
      author: 'Genesis 3:5 (Latin, used in German context)',
      category: 'Philosophy',
      date: DateTime.now(),
    ),
    Quote(
      id: 'q29',
      text: 'Vertrauen ist gut, Kontrolle ist besser.',
      translation: 'Trust is good, control is better.',
      author: 'Vladimir Lenin (popular in German)',
      category: 'Wisdom',
      date: DateTime.now(),
    ),
    Quote(
      id: 'q30',
      text: 'In vino veritas.',
      translation: 'In wine there is truth.',
      author: 'Latin phrase (used in German)',
      category: 'Truth',
      date: DateTime.now(),
    ),
    Quote(
      id: 'q31',
      text: 'Morgenstund hat Gold im Mund.',
      translation: 'The morning hour has gold in its mouth.',
      author: 'German Proverb',
      category: 'Motivation',
      date: DateTime.now(),
    ),
  ];

  static final _random = Random();

  static Quote getDailyQuote() {
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    final index = dayOfYear % _quotes.length;
    return _quotes[index];
  }

  static List<Quote> getAllQuotes() => List.from(_quotes)..shuffle(_random);
}

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
  bool _showTranslation = false;

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
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _refreshQuote() {
    _animationController.reset();
    ref.invalidate(dailyQuoteProvider);
    _animationController.forward();
    setState(() => _showTranslation = false);
  }

  void _shareQuote(Quote quote) {
    final text = '''
🇩🇪 "${quote.text}"

🇬🇧 ${quote.translation}

— ${quote.author}

Learn German with DeutschTiger! 🐯
''';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Quote copied to clipboard!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              title: const Text(
                'Câu nói hôm nay',
                style: TextStyle(
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
                      AppColors.primary.withOpacity(0.1),
                      AppColors.tigerOrange.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _refreshQuote,
                tooltip: 'New quote',
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: quoteAsync.when(
              loading: () => const SizedBox(
                height: 300,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => SizedBox(
                height: 300,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text('Error loading quote: $e'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.invalidate(dailyQuoteProvider),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
              data: (quote) => FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _QuoteCard(
                    quote: quote,
                    showTranslation: _showTranslation,
                    onToggleTranslation: () =>
                        setState(() => _showTranslation = !_showTranslation),
                    onShare: () => _shareQuote(quote),
                    onSave: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Quote saved to favorites!'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
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
                  const Icon(Icons.auto_awesome, color: AppColors.tigerOrange, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Khám phá thêm',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => _showAllQuotes(context, historyAsync),
                    child: const Text('Xem tất cả'),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: historyAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (quotes) => _QuotesGrid(quotes: quotes.take(6).toList()),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  void _showAllQuotes(BuildContext context, AsyncValue<List<Quote>> historyAsync) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Tất cả câu nói',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: historyAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const Center(child: Text('Error loading quotes')),
                  data: (quotes) => ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: quotes.length,
                    itemBuilder: (context, index) => _CompactQuoteCard(
                      quote: quotes[index],
                      onShare: () => _shareQuote(quotes[index]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  final Quote quote;
  final bool showTranslation;
  final VoidCallback onToggleTranslation;
  final VoidCallback onShare;
  final VoidCallback onSave;

  const _QuoteCard({
    required this.quote,
    required this.showTranslation,
    required this.onToggleTranslation,
    required this.onShare,
    required this.onSave,
  });

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
            AppColors.primary.withOpacity(0.8),
            AppColors.tigerOrange.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🇩🇪', style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 4),
                      Text(
                        quote.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.white),
                  onPressed: onSave,
                ),
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: onShare,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              '"${quote.text}"',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1.4,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: onToggleTranslation,
              child: AnimatedCrossFade(
                firstChild: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Text('🇬🇧', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 12),
                      Text(
                        'Tap to reveal translation',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.visibility,
                        color: Colors.white.withOpacity(0.8),
                        size: 20,
                      ),
                    ],
                  ),
                ),
                secondChild: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('🇬🇧', style: TextStyle(fontSize: 18)),
                          const SizedBox(width: 12),
                          const Text(
                            'Translation',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.visibility_off, color: Colors.white70, size: 18),
                            onPressed: onToggleTranslation,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        quote.translation,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                crossFadeState: showTranslation
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '— ${quote.author}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      if (quote.authorInfo != null)
                        Text(
                          quote.authorInfo!,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuotesGrid extends StatelessWidget {
  final List<Quote> quotes;

  const _QuotesGrid({required this.quotes});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              for (int i = 0; i < 2 && i < quotes.length; i++)
                Expanded(
                  child: _MiniQuoteCard(
                    quote: quotes[i],
                    margin: EdgeInsets.only(right: i == 0 ? 8 : 0, left: i == 1 ? 8 : 0),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (int i = 2; i < 4 && i < quotes.length; i++)
                Expanded(
                  child: _MiniQuoteCard(
                    quote: quotes[i],
                    margin: EdgeInsets.only(right: i == 2 ? 8 : 0, left: i == 3 ? 8 : 0),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (int i = 4; i < 6 && i < quotes.length; i++)
                Expanded(
                  child: _MiniQuoteCard(
                    quote: quotes[i],
                    margin: EdgeInsets.only(right: i == 4 ? 8 : 0, left: i == 5 ? 8 : 0),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniQuoteCard extends StatelessWidget {
  final Quote quote;
  final EdgeInsets margin;

  const _MiniQuoteCard({required this.quote, required this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            quote.text,
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
            quote.author,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactQuoteCard extends StatelessWidget {
  final Quote quote;
  final VoidCallback onShare;

  const _CompactQuoteCard({required this.quote, required this.onShare});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    quote.category,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.share, size: 18),
                  onPressed: onShare,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              quote.text,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              quote.translation,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '— ${quote.author}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
