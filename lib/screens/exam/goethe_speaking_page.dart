import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class GoetheSpeakingPage extends ConsumerStatefulWidget {
  const GoetheSpeakingPage({super.key});

  @override
  ConsumerState<GoetheSpeakingPage> createState() => _GoetheSpeakingPageState();
}

class _GoetheSpeakingPageState extends ConsumerState<GoetheSpeakingPage>
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
          'Speaking Practice',
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
            Tab(text: 'Teil A'),
            Tab(text: 'Teil B'),
            Tab(text: 'Teil C'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _SpeakingPartList(
            part: 'A',
            title: 'Reading Statement',
            titleVi: 'Đọc phát biểu',
            description: 'Read a statement aloud after preparation time',
            topics: _teilATopics,
          ),
          _SpeakingPartList(
            part: 'B',
            title: 'Discussion',
            titleVi: 'Thảo luận',
            description: 'Discuss a topic with your partner',
            topics: _teilBTopics,
          ),
          _SpeakingPartList(
            part: 'C',
            title: 'Phone Message',
            titleVi: 'Tin nhắn điện thoại',
            description: 'Leave a phone message with information',
            topics: _teilCTopics,
          ),
        ],
      ),
    );
  }
}

class _SpeakingPartList extends StatelessWidget {
  final String part;
  final String title;
  final String titleVi;
  final String description;
  final List<_SpeakingTopicData> topics;

  const _SpeakingPartList({
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
                        '3-4 min each',
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
            'Practice Topics',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...topics.map((topic) => _SpeakingTopicCard(topic: topic)),
        ],
      ),
    );
  }
}

class _SpeakingTopicCard extends StatelessWidget {
  final _SpeakingTopicData topic;

  const _SpeakingTopicCard({required this.topic});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _openSpeakingPractice(context, topic),
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
                  Icon(
                    Icons.record_voice_over,
                    size: 14,
                    color: AppColors.mutedForeground,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${topic.durationMinutes} min',
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
                    onPressed: () => _openSpeakingPractice(context, topic),
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

  void _openSpeakingPractice(BuildContext context, _SpeakingTopicData topic) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _SpeakingPracticeSheet(topic: topic),
    );
  }
}

class _SpeakingPracticeSheet extends StatefulWidget {
  final _SpeakingTopicData topic;

  const _SpeakingPracticeSheet({required this.topic});

  @override
  State<_SpeakingPracticeSheet> createState() => _SpeakingPracticeSheetState();
}

class _SpeakingPracticeSheetState extends State<_SpeakingPracticeSheet> {
  bool _isRecording = false;
  bool _showHints = false;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
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
                              Icons.timer,
                              size: 14,
                              color: AppColors.mutedForeground,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.topic.durationMinutes} minutes',
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
                      'Preparation Tips',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _TipCard(
                      icon: Icons.lightbulb,
                      title: 'Key Vocabulary',
                      content: widget.topic.keyVocab,
                      color: Colors.amber,
                    ),
                    const SizedBox(height: 8),
                    _TipCard(
                      icon: Icons.format_list_numbered,
                      title: 'Structure',
                      content: widget.topic.structure,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 8),
                    _TipCard(
                      icon: Icons.warning_amber,
                      title: 'Common Mistakes',
                      content: widget.topic.commonMistakes,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isRecording = !_isRecording;
                              });
                              if (_isRecording) {
                                _startRecording();
                              } else {
                                _stopRecording();
                              }
                            },
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: _isRecording
                                    ? AppColors.destructive
                                    : AppColors.tigerOrange,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        (_isRecording
                                                ? AppColors.destructive
                                                : AppColors.tigerOrange)
                                            .withValues(alpha: 0.3),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                _isRecording ? Icons.stop : Icons.mic,
                                color: Colors.white,
                                size: 36,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _isRecording ? 'Recording...' : 'Tap to Record',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.mutedForeground,
                            ),
                          ),
                          if (_isRecording) ...[
                            const SizedBox(height: 4),
                            Text(
                              '0:${(_elapsedSeconds ~/ 60).toString().padLeft(2, '0')}:${(_elapsedSeconds % 60).toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _showHints = !_showHints;
                        });
                      },
                      icon: Icon(
                        _showHints ? Icons.visibility_off : Icons.visibility,
                      ),
                      label: Text(
                        _showHints
                            ? 'Hide Sample Answer'
                            : 'Show Sample Answer',
                      ),
                    ),
                    if (_showHints) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Sample Answer',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.topic.sampleAnswer,
                              style: const TextStyle(fontSize: 14, height: 1.6),
                            ),
                          ],
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

  int _elapsedSeconds = 0;

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _elapsedSeconds = 0;
    });
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted && _isRecording) {
        setState(() {
          _elapsedSeconds++;
        });
        return true;
      }
      return false;
    });
  }

  void _stopRecording() {
    setState(() {
      _isRecording = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Recording saved! Tap Submit when ready.'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final Color color;

  const _TipCard({
    required this.icon,
    required this.title,
    required this.content,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(fontSize: 12, color: AppColors.foreground),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SpeakingTopicData {
  final int number;
  final String title;
  final String prompt;
  final int durationMinutes;
  final int attempts;
  final int bestScore;
  final String sampleAnswer;
  final String keyVocab;
  final String structure;
  final String commonMistakes;

  const _SpeakingTopicData({
    required this.number,
    required this.title,
    required this.prompt,
    required this.durationMinutes,
    required this.sampleAnswer,
    required this.keyVocab,
    required this.structure,
    required this.commonMistakes,
  }) : attempts = 0,
       bestScore = 0;
}

final List<_SpeakingTopicData> _teilATopics = [
  const _SpeakingTopicData(
    number: 1,
    title: 'Vorstellen',
    prompt:
        'Lesen Sie die following Aussage vor:\n\n„In der modernen Arbeitswelt ist es wichtig, flexible Arbeitszeiten zu haben. Viele Unternehmen bieten Homeoffice an, um die Work-Life-Balance zu verbessern."',
    durationMinutes: 3,
    sampleAnswer:
        'In der modernen Arbeitswelt ist es wichtig, flexible Arbeitszeiten zu haben. Viele Unternehmen bieten Homeoffice an, um die Work-Life-Balance zu verbessern.',
    keyVocab:
        'Arbeitswelt, flexible Arbeitszeiten, Homeoffice, Work-Life-Balance, verbessern',
    structure: 'Lesen Sie klar und deutlich. Achten Sie auf die Betonung.',
    commonMistakes: 'Nicht zu schnell lesen. Pause machen zwischen den Sätzen.',
  ),
  const _SpeakingTopicData(
    number: 2,
    title: 'Umwelt',
    prompt:
        'Lesen Sie die folgende Aussage vor:\n\n„Umweltbewusstsein ist heute wichtiger denn je. Wir müssen unseren CO2-Ausstoß reduzieren und mehr recyceln, um die Umwelt zu schützen."',
    durationMinutes: 3,
    sampleAnswer:
        'Umweltbewusstsein ist heute wichtiger denn je. Wir müssen unseren CO2-Ausstoß reduzieren und mehr recyceln, um die Umwelt zu schützen.',
    keyVocab: 'Umweltbewusstsein, CO2-Ausstoß, recyceln, Umwelt schützen',
    structure: 'Lesen Sie flüssig und mit natürlicher Betonung.',
    commonMistakes: 'Fremdwörter richtig aussprechen (CO2, recyceln).',
  ),
  const _SpeakingTopicData(
    number: 3,
    title: 'Gesundheit',
    prompt:
        'Lesen Sie die folgende Aussage vor:\n\n„Eine ausgewogene Ernährung und regelmäßige Bewegung sind die Grundlage für ein gesundes Leben. Sport hilft nicht nur körperlich, sondern auch mental."',
    durationMinutes: 3,
    sampleAnswer:
        'Eine ausgewogene Ernährung und regelmäßige Bewegung sind die Grundlage für ein gesundes Leben. Sport hilft nicht nur körperlich, sondern auch mental.',
    keyVocab:
        'ausgewogene Ernährung, regelmäßige Bewegung, gesundes Leben, mental',
    structure:
        'Betonen Sie die wichtigen Wörter: Ernährung, Bewegung, gesund, Sport.',
    commonMistakes: '„Ausgewogene" langsam und deutlich aussprechen.',
  ),
  const _SpeakingTopicData(
    number: 4,
    title: 'Bildung',
    prompt:
        'Lesen Sie die folgende Aussage vor:\n\n„Bildung ist der Schlüssel zum Erfolg. In der heutigen Zeit ist lebenslanges Lernen besonders wichtig, um mit der schnellen Entwicklung Schritt zu halten."',
    durationMinutes: 3,
    sampleAnswer:
        'Bildung ist der Schlüssel zum Erfolg. In der heutigen Zeit ist lebenslanges Lernen besonders wichtig, um mit der schnellen Entwicklung Schritt zu halten.',
    keyVocab: 'Bildung, Schlüssel zum Erfolg, lebenslanges Lernen, Entwicklung',
    structure: 'Lesen Sie den Text mit Pausen zwischen den Ideen.',
    commonMistakes: '„Lebenslanges" als ein Wort richtig aussprechen.',
  ),
  const _SpeakingTopicData(
    number: 5,
    title: 'Technologie',
    prompt:
        'Lesen Sie die folgende Aussage vor:\n\n„Digitale Technologien verändern unseren Alltag grundlegend. Smartphones und das Internet sind aus unserem Leben nicht mehr wegzudenken."',
    durationMinutes: 3,
    sampleAnswer:
        'Digitale Technologien verändern unseren Alltag grundlegend. Smartphones und das Internet sind aus unserem Leben nicht mehr wegzudenken.',
    keyVocab: 'digitale Technologien, Alltag, Smartphones, Internet',
    structure: 'Lesen Sie den Text mit enthusiasm and clear pronunciation.',
    commonMistakes: '„wegzudenken" richtig betonen.',
  ),
  const _SpeakingTopicData(
    number: 6,
    title: 'Reisen',
    prompt:
        'Lesen Sie die folgende Aussage vor:\n\n„Reisen erweitert den Horizont und hilft uns, andere Kulturen besser zu verstehen. Urlaub ist wichtig für unsere Erholung und Kreativität."',
    durationMinutes: 3,
    sampleAnswer:
        'Reisen erweitert den Horizont und hilft uns, andere Kulturen besser zu verstehen. Urlaub ist wichtig für unsere Erholung und Kreativität.',
    keyVocab: 'Horizont, Kulturen, Erholung, Kreativität',
    structure: 'Lesen Sie mit einem ruhigen, nachdenklichen Ton.',
    commonMistakes: '„erweitert" mit kurzem „e" aussprechen.',
  ),
  const _SpeakingTopicData(
    number: 7,
    title: 'Freizeit',
    prompt:
        'Lesen Sie die folgende Aussage vor:\n\n„Freizeitaktivitäten sind wichtig für unser Wohlbefinden. Ob Sport, Lesen oder Musik – jeder sollte Zeit für seine Hobbys haben."',
    durationMinutes: 3,
    sampleAnswer:
        'Freizeitaktivitäten sind wichtig für unser Wohlbefinden. Ob Sport, Lesen oder Musik – jeder sollte Zeit für seine Hobbys haben.',
    keyVocab: 'Freizeitaktivitäten, Wohlbefinden, Hobbys',
    structure: 'Lesen Sie den Text mit enthusiasm.',
    commonMistakes: '„Wohlbefinden" in zwei Teilen aussprechen.',
  ),
  const _SpeakingTopicData(
    number: 8,
    title: 'Familie',
    prompt:
        'Lesen Sie die folgende Aussage vor:\n\n„Die Familie ist der wichtigste Rückhalt im Leben. In schwierigen Zeiten können wir uns immer auf unsere Familie verlassen."',
    durationMinutes: 3,
    sampleAnswer:
        'Die Familie ist der wichtigste Rückhalt im Leben. In schwierigen Zeiten können wir uns immer auf unsere Familie verlassen.',
    keyVocab: 'Rückhalt, schwierige Zeiten, verlassen',
    structure: 'Lesen Sie mit einem warmen, emotionalen Ton.',
    commonMistakes: '„schwierigen" langsam und deutlich aussprechen.',
  ),
  const _SpeakingTopicData(
    number: 9,
    title: 'Kommunikation',
    prompt:
        'Lesen Sie die folgende Aussage vor:\n\n„Gute Kommunikation ist die Basis für erfolgreiche Beziehungen. Zuhören ist genauso wichtig wie Sprechen."',
    durationMinutes: 3,
    sampleAnswer:
        'Gute Kommunikation ist die Basis für erfolgreiche Beziehungen. Zuhören ist genauso wichtig wie Sprechen.',
    keyVocab: 'Kommunikation, Basis, Beziehungen, Zuhören',
    structure: 'Lesen Sie klar und deutlich.',
    commonMistakes: '„genauso" betonen.',
  ),
  const _SpeakingTopicData(
    number: 10,
    title: 'Zukunft',
    prompt:
        'Lesen Sie die folgende Aussage vor:\n\n„Die Zukunft gehört denen, die an die Schönheit ihrer Träume glauben. Mit Fleiß und Ausdauer können wir unsere Ziele erreichen."',
    durationMinutes: 3,
    sampleAnswer:
        'Die Zukunft gehört denen, die an die Schönheit ihrer Träume glauben. Mit Fleiß und Ausdauer können wir unsere Ziele erreichen.',
    keyVocab: 'Zukunft, Schönheit, Träume, Fleiß, Ausdauer, Ziele',
    structure: 'Lesen Sie mit inspiration and confidence.',
    commonMistakes: '„Ausdauer" mit „au" wie in „Haus" aussprechen.',
  ),
];

final List<_SpeakingTopicData> _teilBTopics = [
  const _SpeakingTopicData(
    number: 1,
    title: 'Urlaubsplanung',
    prompt:
        'Sprechen Sie über das Thema „Urlaub planen":\n• Wo möchten Sie hingehen?\n• Was möchten Sie dort machen?\n• Wie planen Sie die Reise?',
    durationMinutes: 4,
    sampleAnswer:
        'Ich möchte gerne nach Spanien in den Urlaub fahren. Ich interessiere mich für die spanische Kultur und das gute Wetter. Ich möchte Barcelona besuchen und die Strände genießen. Für die Reise plane ich, eine Woche dort zu bleiben und in einem Hotel in der Nähe des Strandes zu wohnen.',
    keyVocab:
        'Urlaub, buchen, Reise, Hotel, Strand, Kultur, Sehenswürdigkeiten',
    structure: 'Introduction → Description → Plans → Conclusion',
    commonMistakes: 'Use past tense for completed actions, present for plans.',
  ),
  const _SpeakingTopicData(
    number: 2,
    title: 'Gesunde Ernährung',
    prompt:
        'Sprechen Sie über das Thema „Gesunde Ernährung":\n• Was essen Sie gesund?\n• Kochen Sie selbst?\n• Was ist wichtig bei der Ernährung?',
    durationMinutes: 4,
    sampleAnswer:
        'Ich versuche, gesund zu essen. Ich esse viel Obst und Gemüse und trinke genug Wasser. Ja, ich koche meistens selbst, weil es gesünder und günstiger ist. Bei der Ernährung ist es wichtig, abwechslungsreich zu essen und nicht zu viel Zucker zu konsumieren.',
    keyVocab: 'Ernährung, Obst, Gemüse, kochen, abwechslungsreich, Zucker',
    structure: 'Personal habits → Cooking → General advice',
    commonMistakes: 'Don\'t forget articles and cases.',
  ),
  const _SpeakingTopicData(
    number: 3,
    title: 'Sport treiben',
    prompt:
        'Sprechen Sie über das Thema „Sport treiben":\n• Treiben Sie Sport?\n• Welchen Sport machen Sie?\n• Warum ist Sport wichtig?',
    durationMinutes: 4,
    sampleAnswer:
        'Ja, ich treibe regelmäßig Sport. Ich gehe zweimal pro Woche ins Fitnessstudio und schwimme am Wochenende. Sport ist wichtig, weil er gesund ist und Stress abbaut. Außerdem fühle ich mich danach besser und habe mehr Energie.',
    keyVocab:
        'Sport treiben, Fitnessstudio, schwimmen, Stress abbauen, Energie',
    structure: 'Personal practice → Specific activities → Importance',
    commonMistakes: 'Use correct verb forms (treiben, gehen, schwimmen).',
  ),
  const _SpeakingTopicData(
    number: 4,
    title: 'Berufswahl',
    prompt:
        'Sprechen Sie über das Thema „Berufswahl":\n• Was möchten Sie beruflich machen?\n• Warum haben Sie sich dafür entschieden?\n• Was ist wichtig bei der Berufswahl?',
    durationMinutes: 4,
    sampleAnswer:
        'Ich möchte gerne im Bereich Marketing arbeiten. Ich habe mich dafür entschieden, weil ich kreativ bin und gerne mit Menschen arbeite. Bei der Berufswahl ist es wichtig, dass man Spaß an der Arbeit hat und die Möglichkeit hat, sich weiterzuentwickeln.',
    keyVocab: 'Beruf, Marketing, kreativ, Berufswahl, Spaß, weiterentwickeln',
    structure: 'Career goal → Reason → General advice',
    commonMistakes: 'Use correct prepositions (im Bereich, an der Arbeit).',
  ),
  const _SpeakingTopicData(
    number: 5,
    title: 'Wohnen',
    prompt:
        'Sprechen Sie über das Thema „Wohnen":\n• Wo wohnen Sie?\n• Wie ist Ihre Wohnung?\n• Was ist wichtig beim Wohnen?',
    durationMinutes: 4,
    sampleAnswer:
        'Ich wohne in einer kleinen Wohnung in der Stadt. Die Wohnung hat zwei Zimmer, eine Küche und ein Bad. Mir ist wichtig, dass sie hell ist und in der Nähe meiner Arbeit liegt. Außerdem sollte sie nicht zu teuer sein.',
    keyVocab: 'Wohnung, Zimmer, Küche, Bad, hell, in der Nähe',
    structure: 'Current situation → Description → Preferences',
    commonMistakes: 'Use correct case for prepositions.',
  ),
  const _SpeakingTopicData(
    number: 6,
    title: 'Freunde',
    prompt:
        'Sprechen Sie über das Thema „Freunde":\n• Was macht gute Freunde aus?\n• Wie haben Sie Ihre besten Freunde kennengelernt?\n• Wie oft treffen Sie Ihre Freunde?',
    durationMinutes: 4,
    sampleAnswer:
        'Gute Freunde sind ehrlich und zuverlässig. Man kann mit ihnen über alles sprechen. Meine besten Freunde habe ich in der Schule und im Deutschkurs kennengelernt. Wir treffen uns ungefähr einmal pro Woche.',
    keyVocab: 'ehrlich, zuverlässig, kennengelernt, treffen',
    structure: 'Qualities → How you met → Frequency',
    commonMistakes: 'Use correct past tense forms (habe kennengelernt).',
  ),
  const _SpeakingTopicData(
    number: 7,
    title: 'Lernen',
    prompt:
        'Sprechen Sie über das Thema „Lernen":\n• Wie lernen Sie am besten?\n• Lernen Sie lieber allein oder in der Gruppe?\n• Welche Tipps haben Sie zum Lernen?',
    durationMinutes: 4,
    sampleAnswer:
        'Ich lerne am besten, wenn ich mir Notizen mache und sie wiederhole. Ich lerne lieber allein, weil ich mich besser konzentrieren kann. Mein Tipp ist: Regelmäßig lernen, nicht alles auf einmal.',
    keyVocab: 'Notizen, wiederholen, konzentrieren, regelmäßig, Tipp',
    structure: 'Learning method → Preference → Tips',
    commonMistakes: 'Use correct word order in sentences.',
  ),
  const _SpeakingTopicData(
    number: 8,
    title: 'Umwelt',
    prompt:
        'Sprechen Sie über das Thema „Umweltschutz":\n• Was tun Sie für die Umwelt?\n• Ist Umweltschutz wichtig?\n• Was können wir noch tun?',
    durationMinutes: 4,
    sampleAnswer:
        'Ich versuche, weniger Plastik zu verwenden und recycle so viel wie möglich. Ja, Umweltschutz ist sehr wichtig, weil wir nur einen Planeten haben. Wir können mehr Rad fahren, weniger Fleisch essen und energiesparende Geräte benutzen.',
    keyVocab: 'Umweltschutz, Plastik, recyceln, energiesparend, Rad fahren',
    structure: 'Personal actions → Importance → Suggestions',
    commonMistakes: 'Use correct verb forms (versuche, benutzen).',
  ),
  const _SpeakingTopicData(
    number: 9,
    title: 'Medien',
    prompt:
        'Sprechen Sie über das Thema „Medien":\n• Welche Medien nutzen Sie?\n• Wie viel Zeit verbringen Sie damit?\n• Was sind die Vor- und Nachteile?',
    durationMinutes: 4,
    sampleAnswer:
        'Ich nutze hauptsächlich mein Smartphone und den Computer. Ich verbringe etwa zwei Stunden pro Tag damit. Die Vorteile sind, dass man schnell Informationen bekommt und mit Freunden in Kontakt bleibt. Die Nachteile sind, dass man weniger Zeit für andere Aktivitäten hat.',
    keyVocab:
        'Medien, Smartphone, Computer, Informationen, Kontakt, Vorteile, Nachteile',
    structure: 'Media usage → Time spent → Pros and cons',
    commonMistakes: 'Use correct comparative forms.',
  ),
  const _SpeakingTopicData(
    number: 10,
    title: 'Sprachen lernen',
    prompt:
        'Sprechen Sie über das Thema „Sprachen lernen":\n• Welche Sprachen sprechen Sie?\n• Wie lernen Sie Sprachen?\n• Warum ist es wichtig, Sprachen zu lernen?',
    durationMinutes: 4,
    sampleAnswer:
        'Ich spreche Deutsch, Englisch und ein bisschen Spanisch. Ich lerne Sprachen, indem ich Bücher lese und Podcasts höre. Außerdem spreche ich so oft wie möglich mit Muttersprachlern. Sprachen zu lernen ist wichtig, weil es berufliche Chancen verbessert und man andere Kulturen besser versteht.',
    keyVocab: 'Sprachen, Muttersprachler, berufliche Chancen, Kulturen',
    structure: 'Languages spoken → Learning methods → Importance',
    commonMistakes: 'Use correct sentence structure with „indem".',
  ),
];

final List<_SpeakingTopicData> _teilCTopics = [
  const _SpeakingTopicData(
    number: 1,
    title: 'Arzttermin',
    prompt:
        'Hinterlassen Sie eine Nachricht auf dem Anrufbeantworter:\n• Sie möchten einen Termin beim Arzt vereinbaren\n• Sie haben Schmerzen im Rücken\n• Sie können nächste Woche vormittags',
    durationMinutes: 3,
    sampleAnswer:
        'Guten Tag, hier spricht Thomas Müller. Ich möchte gerne einen Termin bei Ihnen vereinbaren. Ich habe seit einigen Tagen Schmerzen im Rücken. Nächste Woche wäre mir gut, am liebsten vormittags. Bitte rufen Sie mich zurück unter der Nummer 0123 456789. Vielen Dank und auf Wiederhören.',
    keyVocab: 'Termin, vereinbaren, Schmerzen, Rücken, vormittags, zurückrufen',
    structure: 'Greeting → Request → Details → Contact → Goodbye',
    commonMistakes: 'Speak clearly and at normal pace.',
  ),
  const _SpeakingTopicData(
    number: 2,
    title: 'Hotelreservierung',
    prompt:
        'Hinterlassen Sie eine Nachricht auf dem Anrufbeantworter:\n• Sie möchten ein Zimmer reservieren\n• Für zwei Personen, zwei Nächte\n• Kommen Sie am Freitag an',
    durationMinutes: 3,
    sampleAnswer:
        'Guten Tag, mein Name ist Anna Schmidt. Ich möchte gerne ein Zimmer in Ihrem Hotel reservieren. Für zwei Personen, vom Freitag bis Sonntag, also zwei Nächte. Bitte teilen Sie mir den Preis mit. Ich freue mich auf Ihre Rückmeldung. Meine Telefonnummer ist 0987 654321. Vielen Dank.',
    keyVocab: 'reservieren, Zimmer, Hotel, zwei Nächte, Preis, Rückmeldung',
    structure: 'Greeting → Request → Dates → Contact info → Closing',
    commonMistakes: 'State dates clearly (Friday = Freitag).',
  ),
  const _SpeakingTopicData(
    number: 3,
    title: 'Restaurantreservierung',
    prompt:
        'Hinterlassen Sie eine Nachricht auf dem Anrufbeantworter:\n• Sie möchten einen Tisch reservieren\n• Für 6 Personen\n• Am Samstag um 19 Uhr',
    durationMinutes: 3,
    sampleAnswer:
        'Guten Tag, hier ist Thomas Weber. Ich möchte gerne einen Tisch in Ihrem Restaurant reservieren. Für sechs Personen, am Samstag, den 15. Juni, um 19 Uhr. Gibt es da noch freie Plätze? Bitte rufen Sie mich zurück unter 0176 12345678. Vielen Dank und auf Wiederhören.',
    keyVocab: 'Tisch, reservieren, Restaurant, Personen, freie Plätze',
    structure: 'Greeting → Request → Date/time → Question → Contact',
    commonMistakes: 'Say the date clearly.',
  ),
  const _SpeakingTopicData(
    number: 4,
    title: 'Arbeitgeber',
    prompt:
        'Hinterlassen Sie eine Nachricht auf dem Anrufbeantworter:\n• Sie sind krank und können nicht zur Arbeit kommen\n• Es ist eine Grippe\n• Sie rufen nächste Woche wieder an',
    durationMinutes: 3,
    sampleAnswer:
        'Guten Morgen, hier spricht Anna Schmidt. Ich muss Ihnen leider mitteilen, dass ich heute krank bin und nicht zur Arbeit kommen kann. Der Arzt hat Grippe diagnostiziert. Ich hoffe, bald wieder gesund zu sein, und melde mich Anfang nächster Woche. Gute Besserung!',
    keyVocab: 'krank, Arbeit, Grippe, Arzt, melden, gesund',
    structure: 'Greeting → Reason for absence → Expected duration → Closing',
    commonMistakes: 'Sound concerned but professional.',
  ),
  const _SpeakingTopicData(
    number: 5,
    title: 'Flugbuchung',
    prompt:
        'Hinterlassen Sie eine Nachricht auf dem Anrufbeantworter:\n• Sie möchten einen Flug umbuchen\n• Neuer Termin: nächsten Montag\n• Von Berlin nach München',
    durationMinutes: 3,
    sampleAnswer:
        'Guten Tag, hier ist Thomas Müller. Ich möchte gerne meinen Flug umbuchen. Ich fliege normalerweise von Berlin nach München und hätte gerne einen Termin am nächsten Montag. Könnten Sie mir bitte eine Alternative anbieten? Meine Buchungsnummer ist ABC123. Vielen Dank.',
    keyVocab: 'umbuchen, Flug, buchen, Alternative, Buchungsnummer',
    structure: 'Greeting → Request → Original booking → New request → Closing',
    commonMistakes: 'Include booking reference number.',
  ),
  const _SpeakingTopicData(
    number: 6,
    title: 'Nachbarschaft',
    prompt:
        'Hinterlassen Sie eine Nachricht auf dem Anrufbeantworter:\n• Ihr Nachbar hat etwas vergessen\n• Sie haben es in Ihrer Wohnung\n• Er kann es heute Abend abholen',
    durationMinutes: 3,
    sampleAnswer:
        'Guten Tag, Herr Schmidt. Hier ist Anna aus der Wohnung 3B. Ich glaube, Sie haben heute Morgen Ihren Schlüssel bei mir auf dem Tisch liegen lassen. Er ist jetzt bei mir. Sie können ihn heute Abend bei mir abholen. Bitte klingeln Sie einfach. Danke!',
    keyVocab: 'Nachbar, Schlüssel, Wohnung, abholen, klingeln',
    structure: 'Greeting → Explain situation → Solution → Call to action',
    commonMistakes: 'Be friendly but brief.',
  ),
  const _SpeakingTopicData(
    number: 7,
    title: 'Kurse',
    prompt:
        'Hinterlassen Sie eine Nachricht auf dem Anrufbeantworter:\n• Sie möchten sich für einen Deutschkurs anmelden\n• B1-Niveau\n• Morgen Nachmittag wäre möglich',
    durationMinutes: 3,
    sampleAnswer:
        'Guten Tag, mein Name ist Thomas Weber. Ich möchte mich gerne für einen Deutschkurs bei Ihnen anmelden. Mein Niveau ist ungefähr B1. Wäre es möglich, den Kurs morgen Nachmittag zu besuchen? Bitte rufen Sie mich zurück unter 0151 98765432. Vielen Dank.',
    keyVocab: 'anmelden, Deutschkurs, Niveau, besuchen, zurückrufen',
    structure: 'Greeting → Request → Details → Contact info',
    commonMistakes: 'Mention your German level clearly.',
  ),
  const _SpeakingTopicData(
    number: 8,
    title: 'Lieferung',
    prompt:
        'Hinterlassen Sie eine Nachricht auf dem Anrufbeantworter:\n• Ihre Lieferung ist nicht angekommen\n• Sie haben eine Woche gewartet\n• Bitte informieren Sie sich darüber',
    durationMinutes: 3,
    sampleAnswer:
        'Guten Tag, hier spricht Anna Schmidt. Ich habe vor einer Woche ein Paket bestellt, aber es ist noch nicht angekommen. Die Sendungsverfolgung zeigt, dass es zugestellt wurde, aber ich habe nichts bekommen. Könnten Sie bitte nachschauen? Meine Bestellnummer ist 12345. Danke.',
    keyVocab: 'Lieferung, Paket, Sendungsverfolgung, zugestellt, Bestellnummer',
    structure: 'Greeting → Problem → Details → Request → Order number',
    commonMistakes: 'Provide tracking/order number.',
  ),
  const _SpeakingTopicData(
    number: 9,
    title: 'Verspätung',
    prompt:
        'Hinterlassen Sie eine Nachricht auf dem Anrufbeantworter:\n• Sie kommen später zur Verabredung\n• Etwa 30 Minuten Verspätung\n• Bitte warten Sie auf mich',
    durationMinutes: 3,
    sampleAnswer:
        'Hallo, Thomas hier. Ich muss dir leider sagen, dass ich heute etwa dreißig Minuten später komme. Es gibt ein Problem mit der U-Bahn. Bitte warte auf mich oder ruf mich an, falls du schon gehen musst. Bis gleich!',
    keyVocab: 'später, Verspätung, U-Bahn, warten, anrufen',
    structure: 'Greeting → Problem → New ETA → Request',
    commonMistakes: 'Sound apologetic but clear.',
  ),
  const _SpeakingTopicData(
    number: 10,
    title: 'Geburtstagsfeier',
    prompt:
        'Hinterlassen Sie eine Nachricht auf dem Anrufbeantworter:\n• Einladung zu einer Geburtstagsfeier\n• Samstag um 18 Uhr\n• Bitte um Rückmeldung',
    durationMinutes: 3,
    sampleAnswer:
        'Hallo Maria! Hier ist Thomas. Ich möchte dich zu meiner Geburtstagsfeier einladen. Sie ist am Samstag um 18 Uhr bei mir zu Hause. Sag mir bitte bis Freitag, ob du kommen kannst. Ich freue mich auf dich!',
    keyVocab: 'Geburtstagsfeier, einladen, Samstag, Uhrzeit, Rückmeldung',
    structure: 'Greeting → Invitation → Date/time → Request for reply',
    commonMistakes: 'Be enthusiastic and friendly.',
  ),
];
