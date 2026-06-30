import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class ExamPracticePage extends ConsumerStatefulWidget {
  final String examId;
  final bool timed;

  const ExamPracticePage({
    super.key,
    required this.examId,
    this.timed = false,
  });

  @override
  ConsumerState<ExamPracticePage> createState() => _ExamPracticePageState();
}

class _ExamPracticePageState extends ConsumerState<ExamPracticePage> {
  int _currentSection = 0;
  int _currentQuestion = 0;
  int _totalQuestions = 68;
  int _elapsedSeconds = 0;
  Timer? _timer;
  bool _isExamStarted = false;
  final Map<int, int?> _answers = {};

  final List<_SectionInfo> _sections = const [
    _SectionInfo(
      name: 'Lesen (Reading)',
      nameVi: 'Đọc hiểu',
      questions: 25,
      duration: 25,
      color: Colors.blue,
    ),
    _SectionInfo(
      name: 'Hören (Listening)',
      nameVi: 'Nghe hiểu',
      questions: 25,
      duration: 40,
      color: Colors.purple,
    ),
    _SectionInfo(
      name: 'Schreiben (Writing)',
      nameVi: 'Viết',
      questions: 3,
      duration: 20,
      color: Colors.orange,
    ),
    _SectionInfo(
      name: 'Sprechen (Speaking)',
      nameVi: 'Nói',
      questions: 3,
      duration: 20,
      color: Colors.teal,
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.timed) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _elapsedSeconds++;
        });
      }
    });
  }

  void _startExam() {
    setState(() {
      _isExamStarted = true;
      _currentSection = 0;
      _currentQuestion = 0;
    });
    if (widget.timed) {
      _startTimer();
    }
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (!_isExamStarted) {
      return _ExamIntroScreen(
        examId: widget.examId,
        onStart: _startExam,
      );
    }

    return _ExamInProgressScreen(
      examId: widget.examId,
      sections: _sections,
      currentSection: _currentSection,
      currentQuestion: _currentQuestion,
      elapsedSeconds: _elapsedSeconds,
      answers: _answers,
      timed: widget.timed,
      totalQuestions: _totalQuestions,
      onSectionChange: (section) {
        setState(() {
          _currentSection = section;
          _currentQuestion = 0;
        });
      },
      onQuestionChange: (question) {
        setState(() {
          _currentQuestion = question;
        });
      },
      onAnswer: (question, answer) {
        setState(() {
          _answers[question] = answer;
        });
      },
      onFinish: () => _finishExam(context),
    );
  }

  void _finishExam(BuildContext context) {
    _timer?.cancel();
    context.pushReplacement('/exam/result/${widget.examId}');
  }
}

class _SectionInfo {
  final String name;
  final String nameVi;
  final int questions;
  final int duration;
  final Color color;

  const _SectionInfo({
    required this.name,
    required this.nameVi,
    required this.questions,
    required this.duration,
    required this.color,
  });
}

class _ExamIntroScreen extends StatelessWidget {
  final String examId;
  final VoidCallback onStart;

  const _ExamIntroScreen({
    required this.examId,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: const Text(
          'Start Exam',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.tigerOrange,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Goethe B1 Practice Exam',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              examId,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.mutedForeground,
              ),
            ),
            const SizedBox(height: 24),
            _InfoCard(
              icon: Icons.info_outline,
              title: 'Exam Structure',
              items: [
                'Lesen (Reading): 25 questions - 25 min',
                'Hören (Listening): 25 questions - 40 min',
                'Schreiben (Writing): 3 tasks - 20 min',
                'Sprechen (Speaking): 3 tasks - 20 min',
                'Total: 68 questions - 105 min',
              ],
            ),
            const SizedBox(height: 16),
            _InfoCard(
              icon: Icons.warning_amber,
              title: 'Instructions',
              items: [
                'Read each question carefully',
                'Select the best answer',
                'You can navigate between questions',
                'Your progress is auto-saved',
                'Submit when finished',
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onStart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tigerOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Start Exam',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> items;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.tigerOrange, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class _ExamInProgressScreen extends StatelessWidget {
  final String examId;
  final List<_SectionInfo> sections;
  final int currentSection;
  final int currentQuestion;
  final int elapsedSeconds;
  final Map<int, int?> answers;
  final bool timed;
  final int totalQuestions;
  final Function(int) onSectionChange;
  final Function(int) onQuestionChange;
  final Function(int, int) onAnswer;
  final VoidCallback onFinish;

  const _ExamInProgressScreen({
    required this.examId,
    required this.sections,
    required this.currentSection,
    required this.currentQuestion,
    required this.elapsedSeconds,
    required this.answers,
    required this.timed,
    required this.totalQuestions,
    required this.onSectionChange,
    required this.onQuestionChange,
    required this.onAnswer,
    required this.onFinish,
  });

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final section = sections[currentSection];

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              section.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.tigerOrange,
              ),
            ),
            Text(
              'Question ${currentQuestion + 1} of ${section.questions}',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.mutedForeground,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _showExitDialog(context),
        ),
        actions: [
          if (timed)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: elapsedSeconds > 6000
                    ? AppColors.destructive.withValues(alpha: 0.1)
                    : AppColors.tigerOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.timer,
                    size: 16,
                    color: elapsedSeconds > 6000
                        ? AppColors.destructive
                        : AppColors.tigerOrange,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatTime(elapsedSeconds),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: elapsedSeconds > 6000
                          ? AppColors.destructive
                          : AppColors.tigerOrange,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          _SectionTabBar(
            sections: sections,
            currentSection: currentSection,
            answers: answers,
            onSectionTap: onSectionChange,
          ),
          Expanded(
            child: _QuestionCard(
              section: section,
              questionIndex: currentQuestion,
              totalQuestions: section.questions,
              onAnswer: (answer) => onAnswer(currentQuestion, answer),
            ),
          ),
          _NavigationBar(
            currentQuestion: currentQuestion,
            totalQuestions: section.questions,
            onPrevious: () {
              if (currentQuestion > 0) {
                onQuestionChange(currentQuestion - 1);
              }
            },
            onNext: () {
              if (currentQuestion < section.questions - 1) {
                onQuestionChange(currentQuestion + 1);
              } else if (currentSection < sections.length - 1) {
                onSectionChange(currentSection + 1);
              }
            },
            onFinish: onFinish,
            isLastQuestion: currentQuestion == section.questions - 1,
            isLastSection: currentSection == sections.length - 1,
          ),
        ],
      ),
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Exam?'),
        content: const Text(
          'Are you sure you want to exit? Your progress will be saved.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.destructive,
            ),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}

class _SectionTabBar extends StatelessWidget {
  final List<_SectionInfo> sections;
  final int currentSection;
  final Map<int, int?> answers;
  final Function(int) onSectionTap;

  const _SectionTabBar({
    required this.sections,
    required this.currentSection,
    required this.answers,
    required this.onSectionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: sections.asMap().entries.map((entry) {
          final index = entry.key;
          final section = entry.value;
          final isSelected = index == currentSection;

          return Expanded(
            child: GestureDetector(
              onTap: () => onSectionTap(index),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected ? section.color : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      section.name.split(' ').first,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? section.color : AppColors.mutedForeground,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${section.questions}',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _QuestionCard extends StatefulWidget {
  final _SectionInfo section;
  final int questionIndex;
  final int totalQuestions;
  final Function(int) onAnswer;

  const _QuestionCard({
    required this.section,
    required this.questionIndex,
    required this.totalQuestions,
    required this.onAnswer,
  });

  @override
  State<_QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<_QuestionCard> {
  int? _selectedAnswer;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
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
                      color: widget.section.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Q${widget.questionIndex + 1}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: widget.section.color,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                _getSampleQuestion(),
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              ..._getAnswerOptions().asMap().entries.map((entry) {
                final index = entry.key;
                final option = entry.value;
                final isSelected = _selectedAnswer == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAnswer = index;
                    });
                    widget.onAnswer(index);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? widget.section.color.withValues(alpha: 0.1)
                          : AppColors.muted,
                      border: Border.all(
                        color: isSelected
                            ? widget.section.color
                            : AppColors.border,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? widget.section.color
                                : AppColors.card,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? widget.section.color
                                  : AppColors.border,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              String.fromCharCode(65 + index),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.mutedForeground,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            option,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  String _getSampleQuestion() {
    if (widget.section.name.startsWith('Lesen')) {
      return 'Lesen Sie den Text und beantworten Sie die Fragen.\n\nMaria arbeitet seit drei Jahren bei einer großen Firma in Berlin. Sie ist mit ihrer Arbeit sehr zufrieden, aber sie würde gerne mehr Verantwortung haben. Letzte Woche hat sie sich um eine Beförderung beworben.';
    } else if (widget.section.name.startsWith('Hören')) {
      return 'Hören Sie den Text und beantworten Sie die Fragen.\n\nSie hören eine Durchsage am Bahnhof.';
    } else if (widget.section.name.startsWith('Schreiben')) {
      return 'Schreiben Sie eine E-Mail (80 Wörter).\n\nSie haben einen neuen Job gefunden. Schreiben Sie eine E-Mail an Ihren Freund/Ihre Freundin und berichten Sie davon.';
    }
    return 'Answer the following question about daily life in Germany.';
  }

  List<String> _getAnswerOptions() {
    if (widget.section.name.startsWith('Lesen') || widget.section.name.startsWith('Hören')) {
      return [
        'Maria ist seit fünf Jahren bei der Firma.',
        'Maria ist zufrieden mit ihrer Arbeit.',
        'Maria hat keine Beförderung bekommen.',
        'Maria arbeitet in Hamburg.',
      ];
    }
    return [
      'Option A',
      'Option B',
      'Option C',
      'Option D',
    ];
  }
}

class _NavigationBar extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onFinish;
  final bool isLastQuestion;
  final bool isLastSection;

  const _NavigationBar({
    required this.currentQuestion,
    required this.totalQuestions,
    required this.onPrevious,
    required this.onNext,
    required this.onFinish,
    required this.isLastQuestion,
    required this.isLastSection,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          if (currentQuestion > 0)
            TextButton.icon(
              onPressed: onPrevious,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Previous'),
            ),
          const Spacer(),
          if (isLastQuestion && isLastSection)
            ElevatedButton(
              onPressed: onFinish,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
              ),
              child: const Text('Finish Exam'),
            )
          else
            ElevatedButton.icon(
              onPressed: onNext,
              icon: const Icon(Icons.arrow_forward),
              label: Text(isLastQuestion ? 'Next Section' : 'Next'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tigerOrange,
                foregroundColor: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}
