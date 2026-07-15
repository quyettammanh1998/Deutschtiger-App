import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import 'package:deutschtiger/widgets/common/gradient_button.dart';

class GoetheB1WritingPage extends ConsumerStatefulWidget {
  const GoetheB1WritingPage({super.key});

  @override
  ConsumerState<GoetheB1WritingPage> createState() =>
      _GoetheB1WritingPageState();
}

class _GoetheB1WritingPageState extends ConsumerState<GoetheB1WritingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: const Text(
          'Writing Practice',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.tigerOrange,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.tigerOrange,
          unselectedLabelColor: AppColors.mutedForeground,
          indicatorColor: AppColors.tigerOrange,
          tabs: const [
            Tab(text: 'Teil 1'),
            Tab(text: 'Teil 2'),
            Tab(text: 'Teil 3'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _WritingPartList(
            part: 1,
            title: 'Format Writing',
            titleVi: 'Viết theo mẫu',
            description:
                'Fill in blanks for announcements, notices, or messages',
            topics: _teil1Topics,
          ),
          _WritingPartList(
            part: 2,
            title: 'Informal Email',
            titleVi: 'Email không trang trọng',
            description: 'Write informal emails to friends or acquaintances',
            topics: _teil2Topics,
          ),
          _WritingPartList(
            part: 3,
            title: 'Formal Letter',
            titleVi: 'Thư trang trọng',
            description: 'Write formal letters to institutions or authorities',
            topics: _teil3Topics,
          ),
        ],
      ),
    );
  }
}

class _WritingPartList extends StatelessWidget {
  final int part;
  final String title;
  final String titleVi;
  final String description;
  final List<_WritingTopicData> topics;

  const _WritingPartList({
    required this.part,
    required this.title,
    required this.titleVi,
    required this.description,
    required this.topics,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.tigerOrange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Teil $part',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.tigerOrange,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    titleVi,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.quiz_outlined,
                        size: 14,
                        color: AppColors.mutedForeground,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${topics.length} prompts',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.timer_outlined,
                        size: 14,
                        color: AppColors.mutedForeground,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '20 min each',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Practice Prompts',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...topics.map((topic) => _WritingTopicCard(topic: topic)),
        ],
      ),
    );
  }
}

class _WritingTopicCard extends StatelessWidget {
  final _WritingTopicData topic;

  const _WritingTopicCard({required this.topic});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _openWritingPractice(context, topic),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.tigerOrange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${topic.number}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.tigerOrange,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      topic.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (topic.attempts > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check,
                            size: 12,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${topic.attempts}x',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                topic.prompt,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.mutedForeground,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.edit, size: 14, color: AppColors.mutedForeground),
                  const SizedBox(width: 4),
                  Text(
                    '${topic.wordLimit} words',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                  if (topic.bestScore > 0) ...[
                    const SizedBox(width: 16),
                    Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      'Best: ${topic.bestScore.toStringAsFixed(0)}%',
                      style: TextStyle(fontSize: 12, color: Colors.amber[700]),
                    ),
                  ],
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () => _openWritingPractice(context, topic),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.tigerOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('Practice'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openWritingPractice(BuildContext context, _WritingTopicData topic) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _WritingPracticeSheet(topic: topic),
    );
  }
}

class _WritingPracticeSheet extends StatefulWidget {
  final _WritingTopicData topic;

  const _WritingPracticeSheet({required this.topic});

  @override
  State<_WritingPracticeSheet> createState() => _WritingPracticeSheetState();
}

class _WritingPracticeSheetState extends State<_WritingPracticeSheet> {
  final TextEditingController _controller = TextEditingController();
  bool _showSample = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.topic.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.muted,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.topic.prompt,
                          style: const TextStyle(fontSize: 14, height: 1.5),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.edit,
                              size: 14,
                              color: AppColors.mutedForeground,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.topic.wordLimit} words required',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.mutedForeground,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.timer,
                              size: 14,
                              color: AppColors.mutedForeground,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '20 minutes',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Response',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _controller,
                      maxLines: 12,
                      decoration: InputDecoration(
                        hintText: 'Start writing your response here...',
                        filled: true,
                        fillColor: AppColors.muted,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.tigerOrange,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Word count: ${_controller.text.split(RegExp(r'\\s+')).where((s) => s.isNotEmpty).length}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                _showSample = !_showSample;
                              });
                            },
                            icon: Icon(
                              _showSample
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            label: Text(
                              _showSample ? 'Hide Sample' : 'Show Sample',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GradientButton(
                            label: 'Submit',
                            onPressed: () => _submitWriting(context),
                          ),
                        ),
                      ],
                    ),
                    if (_showSample) ...[
                      const SizedBox(height: 24),
                      const Text(
                        'Sample Answer',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          widget.topic.sampleAnswer,
                          style: const TextStyle(fontSize: 14, height: 1.6),
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _submitWriting(BuildContext context) {
    final wordCount = _controller.text
        .split(RegExp(r'\s+'))
        .where((s) => s.isNotEmpty)
        .length;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Writing?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Word count: $wordCount'),
            if (wordCount < widget.topic.wordLimit)
              Text(
                'You need at least ${widget.topic.wordLimit} words.',
                style: const TextStyle(color: AppColors.destructive),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue Writing'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Writing submitted for review!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.tigerOrange,
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

class _WritingTopicData {
  final int number;
  final String title;
  final String prompt;
  final int wordLimit;
  final int attempts;
  final int bestScore;
  final String sampleAnswer;

  const _WritingTopicData({
    required this.number,
    required this.title,
    required this.prompt,
    required this.wordLimit,
    required this.sampleAnswer,
  }) : attempts = 0,
       bestScore = 0;
}

final List<_WritingTopicData> _teil1Topics = [
  const _WritingTopicData(
    number: 1,
    title: 'Freundschaft',
    prompt:
        'Sie haben einen neuen Freund/eine neue Freundin im Deutschkurs kennengelernt. Schreiben Sie eine Nachricht (E-Mail, SMS) und berichten Sie über diese Person.',
    wordLimit: 80,
    sampleAnswer:
        'Liebe Maria,\n\nich möchte dir von meiner neuen Freundin Anna erzählen. Sie kommt aus Brasilien und ist sehr freundlich. Wir haben uns im Deutschkurs kennengelernt. Anna arbeitet als Lehrerin und spricht drei Sprachen. Am Wochenende gehen wir oft ins Café und sprechen Deutsch zusammen.\n\nLiebe Grüße\n\nThomas',
  ),
  const _WritingTopicData(
    number: 2,
    title: 'Arbeit und Beruf',
    prompt:
        'Sie haben einen Praktikumsplatz gefunden. Schreiben Sie eine E-Mail an Ihren Chef und bedanken Sie sich für die Möglichkeit.',
    wordLimit: 80,
    sampleAnswer:
        'Sehr geehrter Herr Müller,\n\nich möchte mich herzlich bei Ihnen bedanken, dass ich das Praktikum bei Ihnen machen darf. Ich freue mich sehr auf die neue Aufgabe. Ich werde pünktlich sein und mein Bestes geben.\n\nMit freundlichen Grüßen\n\nThomas Weber',
  ),
  const _WritingTopicData(
    number: 3,
    title: 'Wohnen',
    prompt:
        'Sie suchen eine neue Wohnung. Schreiben Sie eine Nachricht an den Vermieter und fragen Sie nach Details.',
    wordLimit: 80,
    sampleAnswer:
        'Guten Tag,\n\nich interessiere mich für Ihre Wohnung. Ist sie noch frei? Wie groß ist die Wohnung? Ist sie möbliert? Ich möchte gerne wissen, ob ich die Wohnung besichtigen kann.\n\nMit freundlichen Grüßen\n\nAnna Schmidt',
  ),
  const _WritingTopicData(
    number: 4,
    title: 'Gesundheit',
    prompt:
        'Sie sind krank und können nicht zur Arbeit kommen. Schreiben Sie eine kurze Nachricht an Ihren Chef.',
    wordLimit: 80,
    sampleAnswer:
        'Guten Morgen,\n\nich bin leider heute krank und kann nicht zur Arbeit kommen. Ich hoffe, dass ich bald wieder gesund bin. Bitte entschuldigen Sie mich.\n\nMit freundlichen Grüßen\n\nThomas',
  ),
  const _WritingTopicData(
    number: 5,
    title: 'Urlaub',
    prompt:
        'Sie planen einen Urlaub und möchten Informationen von einem Reisebüro. Schreiben Sie eine E-Mail mit Ihren Fragen.',
    wordLimit: 80,
    sampleAnswer:
        'Guten Tag,\n\nich möchte gerne mehr Informationen über Ihre Reisen nach Spanien. Wie lange dauert die Reise? Was kostet die Reise? Ist das Hotel inklusive?\n\nMit freundlichen Grüßen\n\nAnna Schmidt',
  ),
  const _WritingTopicData(
    number: 6,
    title: 'Sport und Fitness',
    prompt:
        'Sie möchten in einem Fitnessstudio trainieren. Schreiben Sie eine E-Mail und fragen Sie nach den Öffnungszeiten und Preisen.',
    wordLimit: 80,
    sampleAnswer:
        'Guten Tag,\n\nich interessiere mich für Ihr Fitnessstudio. Könnten Sie mir die Öffnungszeiten und die Preise mitteilen? Gibt es auch einen Schwimmbad?\n\nMit freundlichen Grüßen\n\nThomas Weber',
  ),
  const _WritingTopicData(
    number: 7,
    title: 'Kultur und Museen',
    prompt:
        'Sie möchten ein Museum besuchen. Schreiben Sie eine E-Mail und fragen Sie nach den Eintrittspreisen und Öffnungszeiten.',
    wordLimit: 80,
    sampleAnswer:
        'Sehr geehrte Damen und Herren,\n\nich möchte gerne Ihr Museum besuchen. Könnten Sie mir die Eintrittspreise und die Öffnungszeiten mitteilen? Gibt es auch eine Führung auf Englisch?\n\nMit freundlichen Grüßen\n\nAnna Schmidt',
  ),
  const _WritingTopicData(
    number: 8,
    title: 'Sprachkurs',
    prompt:
        'Sie möchten einen Deutschkurs besuchen. Schreiben Sie eine E-Mail und fragen Sie nach den Kurszeiten.',
    wordLimit: 80,
    sampleAnswer:
        'Guten Tag,\n\nich möchte einen Deutschkurs bei Ihnen besuchen. Wann finden die Kurse statt? Gibt es auch Kurse am Wochenende?\n\nMit freundlichen Grüßen\n\nThomas Weber',
  ),
  const _WritingTopicData(
    number: 9,
    title: 'Einkaufen',
    prompt:
        'Sie haben ein Problem mit einer Online-Bestellung. Schreiben Sie eine E-Mail und beschreiben Sie das Problem.',
    wordLimit: 80,
    sampleAnswer:
        'Guten Tag,\n\nich habe letzte Woche ein Handy bestellt, aber es ist noch nicht angekommen. Der Status zeigt „versandt", aber ich habe nichts bekommen. Könnten Sie mir bitte helfen?\n\nMit freundlichen Grüßen\n\nAnna Schmidt',
  ),
  const _WritingTopicData(
    number: 10,
    title: 'Restauranter',
    prompt:
        'Sie möchten ein Restaurant für eine Geburtstagsfeier reservieren. Schreiben Sie eine E-Mail und nennen Sie Datum und Personenzahl.',
    wordLimit: 80,
    sampleAnswer:
        'Guten Tag,\n\nich möchte gerne einen Tisch für eine Geburtstagsfeier reservieren. Wir sind 10 Personen. Könnten Sie das Restaurant am 15. Juni um 19 Uhr reservieren?\n\nMit freundlichen Grüßen\n\nThomas Weber',
  ),
];

final List<_WritingTopicData> _teil2Topics = [
  const _WritingTopicData(
    number: 1,
    title: 'Freundschaft',
    prompt:
        'Sie haben einen neuen Freund/eine neue Freundin im Deutschkurs kennengelernt. Schreiben Sie einen Brief an Ihre beste Freundin/Ihren besten Freund und berichten Sie über diese Person.',
    wordLimit: 80,
    sampleAnswer:
        'Liebe Anna,\n\nwie geht es dir? Ich möchte dir von meiner neuen Freundin Maria erzählen. Wir haben uns im Deutschkurs kennengelernt. Sie kommt aus Brasilien und ist sehr nett. Wir sprechen oft Deutsch zusammen und gehen am Wochenende ins Café.\n\nLiebe Grüße\n\nThomas',
  ),
  const _WritingTopicData(
    number: 2,
    title: 'Arbeit und Beruf',
    prompt:
        'Sie haben einen neuen Job gefunden. Schreiben Sie einen Brief an Ihren Freund/Ihre Freundin und berichten Sie davon.',
    wordLimit: 80,
    sampleAnswer:
        'Lieber Thomas,\n\nich habe gute Nachrichten! Ich habe einen neuen Job gefunden. Ich werde ab nächsten Monat bei einer großen Firma in Berlin arbeiten. Die Arbeitszeit ist sehr gut und meine Kollegen sind auch nett.\n\nLiebe Grüße\n\nAnna',
  ),
  const _WritingTopicData(
    number: 3,
    title: 'Wohnen',
    prompt:
        'Sie sind vor Kurzem umgezogen. Schreiben Sie einen Brief an Ihren Freund/Ihre Freundin und beschreiben Sie Ihre neue Wohnung.',
    wordLimit: 80,
    sampleAnswer:
        'Liebe Maria,\n\nwie geht es dir? Ich bin vor zwei Wochen umgezogen. Meine neue Wohnung ist in der Innenstadt. Sie ist zwar klein, aber sehr hell und gemütlich. Ich habe ein Schlafzimmer, eine Küche und ein Wohnzimmer.\n\nLiebe Grüße\n\nAnna',
  ),
  const _WritingTopicData(
    number: 4,
    title: 'Urlaub',
    prompt:
        'Sie sind gerade im Urlaub. Schreiben Sie eine Postkarte an Ihren Freund/Ihre Freundin und beschreiben Sie Ihren Urlaub.',
    wordLimit: 80,
    sampleAnswer:
        'Lieber Thomas,\n\nherzliche Grüße aus Spanien! Das Wetter ist wunderbar und das Essen ist sehr lecker. Gestern war ich am Strand und habe geschwommen. Morgen möchte ich ein Museum besuchen.\n\nBis bald\n\nAnna',
  ),
  const _WritingTopicData(
    number: 5,
    title: 'Gesundheit',
    prompt:
        'Sie sind krank gewesen. Schreiben Sie einen Brief an Ihren Freund/Ihre Freundin und erzählen Sie, wie es Ihnen jetzt geht.',
    wordLimit: 80,
    sampleAnswer:
        'Lieber Thomas,\n\nvielen Dank für deine Karte! Mir geht es jetzt besser. Letzte Woche war ich leider sehr krank und konnte nicht arbeiten. Jetzt bin ich wieder gesund und fühle mich gut.\n\nLiebe Grüße\n\nAnna',
  ),
  const _WritingTopicData(
    number: 6,
    title: 'Sport',
    prompt:
        'Sie haben mit einem neuen Sport angefangen. Schreiben Sie einen Brief an Ihren Freund/Ihre Freundin und berichten Sie davon.',
    wordLimit: 80,
    sampleAnswer:
        'Liebe Maria,\n\nich habe letzte Woche mit Yoga angefangen. Es macht mir viel Spaß! Die Kurse sind jeden Dienstag und Donnerstag. Am Anfang war es etwas schwer, aber jetzt fühle ich mich viel entspannter.\n\nLiebe Grüße\n\nAnna',
  ),
  const _WritingTopicData(
    number: 7,
    title: 'Essen und Kochen',
    prompt:
        'Sie haben ein neues Rezept ausprobiert. Schreiben Sie einen Brief an Ihren Freund/Ihre Freundin und beschreiben Sie das Rezept.',
    wordLimit: 80,
    sampleAnswer:
        'Lieber Thomas,\n\nletzte Woche habe ich einen Kuchen gebacken. Das Rezept war einfach: Mehl, Zucker, Eier und Schokolade. Der Kuchen war sehr lecker! Ich werde dir das Rezept geben.\n\nLiebe Grüße\n\nAnna',
  ),
  const _WritingTopicData(
    number: 8,
    title: 'Familie',
    prompt:
        'Sie haben ein neues Familienmitglied bekommen. Schreiben Sie einen Brief an Ihren Freund/Ihre Freundin und erzählen Sie die Neuigkeiten.',
    wordLimit: 80,
    sampleAnswer:
        'Liebe Maria,\n\nich habe tolle Neuigkeiten! Meine Schwester hat ein Baby bekommen. Es ist ein kleiner Junge und heißt Max. Er ist sehr süß und schläft viel.\n\nLiebe Grüße\n\nAnna',
  ),
  const _WritingTopicData(
    number: 9,
    title: 'Sprachkurs',
    prompt:
        'Sie besuchen einen Deutschkurs und möchten Ihrem Freund/Ihrer Freundin davon erzählen.',
    wordLimit: 80,
    sampleAnswer:
        'Lieber Thomas,\n\nwie geht es dir? Ich besuche seit einem Monat einen Deutschkurs. Es macht viel Spaß! Wir lernen Grammatik, Vokabeln und sprechen viel. Meine Lehrerin ist sehr nett und hilfsbereit.\n\nLiebe Grüße\n\nAnna',
  ),
  const _WritingTopicData(
    number: 10,
    title: 'Feier',
    prompt:
        'Sie haben an einer Feier teilgenommen. Schreiben Sie einen Brief an Ihren Freund/Ihre Freundin und berichten Sie davon.',
    wordLimit: 80,
    sampleAnswer:
        'Liebe Maria,\n\nam Samstag war ich auf einer Geburtstagsfeier. Es war sehr lustig! Es gab gutes Essen und tolle Musik. Ich habe viele interessante Leute kennengelernt. Wir haben bis Mitternacht getanzt.\n\nLiebe Grüße\n\nAnna',
  ),
];

final List<_WritingTopicData> _teil3Topics = [
  const _WritingTopicData(
    number: 1,
    title: 'Bewerbung',
    prompt:
        'Sie haben eine Stellenanzeige gelesen und möchten sich bewerben. Schreiben Sie einen formellen Brief an die Firma.',
    wordLimit: 80,
    sampleAnswer:
        'Sehr geehrte Damen und Herren,\n\nich bewerbe mich um die Stelle als Sachbearbeiter, die Sie in der Zeitung veröffentlicht haben. Ich habe drei Jahre Erfahrung in diesem Bereich und spreche Deutsch, Englisch und Spanisch.\n\nMit freundlichen Grüßen\n\nThomas Weber',
  ),
  const _WritingTopicData(
    number: 2,
    title: 'Beschwerde',
    prompt:
        'Sie haben ein Problem mit einem Produkt. Schreiben Sie einen Beschwerdebrief an das Unternehmen.',
    wordLimit: 80,
    sampleAnswer:
        'Sehr geehrte Damen und Herren,\n\nam 15. Mai habe ich einen Computer bei Ihnen gekauft. Leider funktioniert er nicht richtig. Ich möchte den Computer umtauschen oder mein Geld zurückbekommen.\n\nMit freundlichen Grüßen\n\nAnna Schmidt',
  ),
  const _WritingTopicData(
    number: 3,
    title: 'Wohnungsbewerbung',
    prompt:
        'Sie suchen eine Wohnung und möchten sich bei dem Vermieter bewerben. Schreiben Sie einen formellen Brief.',
    wordLimit: 80,
    sampleAnswer:
        'Sehr geehrter Herr Müller,\n\nich interessiere mich für Ihre Wohnung, die Sie auf Immoweb inseriert haben. Ich bin 28 Jahre alt und arbeite als Ingenieur. Ich habe keine Haustiere und bin Nichtraucher.\n\nMit freundlichen Grüßen\n\nThomas Weber',
  ),
  const _WritingTopicData(
    number: 4,
    title: 'Krankmeldung',
    prompt:
        'Sie sind krank und möchten sich bei Ihrem Arbeitgeber abmelden. Schreiben Sie einen formellen Brief.',
    wordLimit: 80,
    sampleAnswer:
        'Sehr geehrte Damen und Herren,\n\nhiermit möchte ich Ihnen mitteilen, dass ich leider krank bin und heute nicht zur Arbeit kommen kann. Ich hoffe, bald wieder gesund zu sein.\n\nMit freundlichen Grüßen\n\nAnna Schmidt',
  ),
  const _WritingTopicData(
    number: 5,
    title: 'Kündigung',
    prompt:
        'Sie möchten Ihren Arbeitsplatz kündigen. Schreiben Sie einen formellen Kündigungsbrief.',
    wordLimit: 80,
    sampleAnswer:
        'Sehr geehrte Damen und Herren,\n\nhiermit kündige ich meinen Arbeitsvertrag fristgerecht zum Ende des nächsten Monats. Ich bedanke mich für die gute Zusammenarbeit.\n\nMit freundlichen Grüßen\n\nThomas Weber',
  ),
  const _WritingTopicData(
    number: 6,
    title: 'Bewerbung Praktikum',
    prompt:
        'Sie möchten ein Praktikum machen. Schreiben Sie eine Bewerbung an das Unternehmen.',
    wordLimit: 80,
    sampleAnswer:
        'Sehr geehrte Damen und Herren,\n\nich möchte mich für ein Praktikum in Ihrem Unternehmen bewerben. Ich studiere Germanistik und möchte praktische Erfahrungen sammeln.\n\nMit freundlichen Grüßen\n\nAnna Schmidt',
  ),
  const _WritingTopicData(
    number: 7,
    title: 'Anfrage',
    prompt:
        'Sie möchten Informationen über einen Sprachkurs. Schreiben Sie eine formelle Anfrage.',
    wordLimit: 80,
    sampleAnswer:
        'Sehr geehrte Damen und Herren,\n\nich möchte mehr Informationen über Ihre Deutschkurse. Wann beginnt der nächste Kurs? Wie viel kostet der Kurs? Finden die Kurse am Wochenende statt?\n\nMit freundlichen Grüßen\n\nThomas Weber',
  ),
  const _WritingTopicData(
    number: 8,
    title: 'Reklamation',
    prompt:
        'Sie haben eine defekte Ware erhalten. Schreiben Sie einen Reklamationsbrief.',
    wordLimit: 80,
    sampleAnswer:
        'Sehr geehrte Damen und Herren,\n\nam 20. Mai habe ich ein Handy bestellt. Leider ist es defekt angekommen. Der Bildschirm funktioniert nicht. Bitte senden Sie mir ein neues Handy.\n\nMit freundlichen Grüßen\n\nAnna Schmidt',
  ),
  const _WritingTopicData(
    number: 9,
    title: 'Bewerbung Sprachkurs',
    prompt:
        'Sie möchten sich für einen Deutschkurs anmelden. Schreiben Sie eine formelle Bewerbung.',
    wordLimit: 80,
    sampleAnswer:
        'Sehr geehrte Damen und Herren,\n\nich möchte mich für den Deutschkurs B1 anmelden. Ich habe bereits Grundkenntnisse und möchte mein Deutsch verbessern.\n\nMit freundlichen Grüßen\n\nThomas Weber',
  ),
  const _WritingTopicData(
    number: 10,
    title: 'Reservierung',
    prompt:
        'Sie möchten ein Hotelzimmer reservieren. Schreiben Sie eine Reservierungsanfrage.',
    wordLimit: 80,
    sampleAnswer:
        'Sehr geehrte Damen und Herren,\n\nich möchte gerne ein Doppelzimmer vom 15. bis zum 20. Juni reservieren. Ist das Zimmer mit Frühstück? Wie viel kostet die Übernachtung?\n\nMit freundlichen Grüßen\n\nAnna Schmidt',
  ),
];
