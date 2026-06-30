import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/ai_models.dart';
import 'ai_provider.dart';

class AIWritingPracticePage extends ConsumerStatefulWidget {
  const AIWritingPracticePage({super.key});

  @override
  ConsumerState<AIWritingPracticePage> createState() => _AIWritingPracticePageState();
}

class _AIWritingPracticePageState extends ConsumerState<AIWritingPracticePage> {
  WritingPractice? _selectedPractice;
  final _textController = TextEditingController();
  bool _showFeedback = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(aiWritingNotifierProvider).loadPractices();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _selectPractice(WritingPractice practice) {
    setState(() {
      _selectedPractice = practice;
      _textController.text = practice.userText;
      _showFeedback = false;
    });
  }

  void _submitPractice() {
    if (_selectedPractice == null) return;
    
    ref.read(aiWritingNotifierProvider).submitPractice(
      _selectedPractice!.id,
      _textController.text,
    );
    
    setState(() => _showFeedback = true);
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(aiWritingNotifierProvider);
    final state = notifier.state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Writing Practice'),
        actions: [
          if (_selectedPractice != null)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _selectedPractice = null;
                  _textController.clear();
                  _showFeedback = false;
                });
              },
            ),
        ],
      ),
      body: _selectedPractice == null
          ? _PracticeList(
              practices: state.practices,
              isLoading: state.isLoading,
              onSelect: _selectPractice,
            )
          : _PracticeDetail(
              practice: _selectedPractice!,
              textController: _textController,
              isSubmitting: state.isSubmitting,
              showFeedback: _showFeedback,
              lastSubmitted: state.lastSubmitted,
              onSubmit: _submitPractice,
            ),
    );
  }
}

class _PracticeList extends StatelessWidget {
  final List<WritingPractice> practices;
  final bool isLoading;
  final Function(WritingPractice) onSelect;

  const _PracticeList({
    required this.practices,
    required this.isLoading,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (practices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.edit_note, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'No writing exercises available',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: practices.length,
      itemBuilder: (context, index) {
        final practice = practices[index];
        return _PracticeCard(
          practice: practice,
          onTap: () => onSelect(practice),
        );
      },
    );
  }
}

class _PracticeCard extends StatelessWidget {
  final WritingPractice practice;
  final VoidCallback onTap;

  const _PracticeCard({
    required this.practice,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(26),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          practice.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          practice.titleVi,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (practice.isCompleted)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withAlpha(26),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: AppColors.success,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${practice.overallScore.toInt()}%',
                            style: const TextStyle(
                              color: AppColors.success,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                practice.prompt,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.text_fields, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    '${practice.wordLimit} words',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                  const Spacer(),
                  Text(
                    practice.isCompleted ? 'View Feedback' : 'Start Writing',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward, size: 14, color: AppColors.primary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PracticeDetail extends StatelessWidget {
  final WritingPractice practice;
  final TextEditingController textController;
  final bool isSubmitting;
  final bool showFeedback;
  final WritingPractice? lastSubmitted;
  final VoidCallback onSubmit;

  const _PracticeDetail({
    required this.practice,
    required this.textController,
    required this.isSubmitting,
    required this.showFeedback,
    this.lastSubmitted,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final displayPractice = showFeedback && lastSubmitted != null 
        ? lastSubmitted! 
        : practice;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            displayPractice.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            displayPractice.titleVi,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[100]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lightbulb, color: Colors.blue[700], size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Prompt',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  displayPractice.prompt,
                  style: TextStyle(color: Colors.blue[900]),
                ),
                const SizedBox(height: 8),
                Text(
                  displayPractice.promptVi,
                  style: TextStyle(
                    color: Colors.blue[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: textController,
            maxLines: 10,
            enabled: !showFeedback,
            decoration: InputDecoration(
              hintText: 'Write your response here...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Word count: ${textController.text.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).length} / ${displayPractice.wordLimit}',
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
          const SizedBox(height: 16),
          if (!showFeedback)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSubmitting ? null : onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : const Text('Submit for AI Feedback'),
              ),
            ),
          if (showFeedback && displayPractice.isCompleted) ...[
            _ScoreCard(practice: displayPractice),
            const SizedBox(height: 16),
            _FeedbackSection(feedback: displayPractice.feedback),
          ],
        ],
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final WritingPractice practice;

  const _ScoreCard({required this.practice});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withAlpha(204)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'Overall Score',
            style: TextStyle(
              color: Colors.white.withAlpha(204),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${practice.overallScore.toInt()}%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ScoreItem(label: 'Grammar', score: practice.grammarScore),
              _ScoreItem(label: 'Vocabulary', score: practice.vocabularyScore),
              _ScoreItem(label: 'Coherence', score: practice.coherenceScore),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScoreItem extends StatelessWidget {
  final String label;
  final double score;

  const _ScoreItem({required this.label, required this.score});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withAlpha(179),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${score.toInt()}%',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _FeedbackSection extends StatelessWidget {
  final List<WritingFeedback> feedback;

  const _FeedbackSection({required this.feedback});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'AI Feedback',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...feedback.map((f) => _FeedbackItem(feedback: f)),
      ],
    );
  }
}

class _FeedbackItem extends StatelessWidget {
  final WritingFeedback feedback;

  const _FeedbackItem({required this.feedback});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: _getCategoryColor(feedback.category)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(feedback.category).withAlpha(26),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    feedback.category.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: _getCategoryColor(feedback.category),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (feedback.original.isNotEmpty) ...[
              Text(
                feedback.original,
                style: TextStyle(
                  color: Colors.red[700],
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(height: 4),
            ],
            if (feedback.suggestion.isNotEmpty)
              Text(
                feedback.suggestion,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            if (feedback.explanation.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                feedback.explanation,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'grammar':
        return Colors.red;
      case 'vocabulary':
        return Colors.blue;
      case 'coherence':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
