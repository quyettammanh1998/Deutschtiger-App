import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/ai/ai_models.dart';

/// Writing-practice remains mock: Schreiben grading has no confirmed backend
/// contract in this phase (see `docs/api-changelog.md` — AI chat/sessions/
/// memory/profile are live via `AIRepository`, writing-practice grading is a
/// later phase). Kept isolated here so it is easy to delete once that
/// endpoint exists.
class AIWritingMockRepository {
  Future<List<WritingPractice>> getWritingPractices() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockWritingPractices;
  }

  Future<WritingPractice> submitWriting({
    required String practiceId,
    required String content,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    final practice = _mockWritingPractices.firstWhere(
      (p) => p.id == practiceId,
      orElse: () => _mockWritingPractices.first,
    );
    return practice.copyWith(
      userText: content,
      isCompleted: true,
      overallScore: 75.0 + Random().nextDouble() * 20,
      grammarScore: 70.0 + Random().nextDouble() * 20,
      vocabularyScore: 75.0 + Random().nextDouble() * 20,
      coherenceScore: 72.0 + Random().nextDouble() * 20,
      submittedAt: DateTime.now(),
      feedback: _generateWritingFeedback(content),
    );
  }

  List<WritingFeedback> _generateWritingFeedback(String content) {
    final feedback = <WritingFeedback>[];
    final words = content.split(RegExp(r'\s+'));

    if (words.length < 50) {
      feedback.add(
        const WritingFeedback(
          id: 'wf-1',
          type: 'length',
          original: '',
          suggestion: 'Versuchen Sie, längere Sätze zu schreiben (mindestens 100 Wörter).',
          explanation: 'Your text is too short. Try to write more detailed sentences.',
          category: 'content',
        ),
      );
    }

    if (!content.contains('.') && !content.contains(',')) {
      feedback.add(
        const WritingFeedback(
          id: 'wf-2',
          type: 'punctuation',
          original: '',
          suggestion: 'Fügen Sie mehr Satzzeichen hinzu: Kommas und Punkte.',
          explanation: 'Use proper punctuation to structure your text.',
          category: 'format',
        ),
      );
    }

    feedback.add(
      const WritingFeedback(
        id: 'wf-3',
        type: 'general',
        original: '',
        suggestion:
            'Gut gemacht! Versuchen Sie, mehr connectors wie "außerdem", "deshalb", "jedoch" zu verwenden.',
        explanation: 'Good attempt! Consider adding more connecting words.',
        category: 'coherence',
      ),
    );

    return feedback;
  }

  static const List<WritingPractice> _mockWritingPractices = [
    WritingPractice(
      id: 'practice-1',
      title: 'Mein Alltag',
      titleVi: 'My Daily Routine',
      prompt: 'Beschreiben Sie Ihren typischen Arbeitstag. Was machen Sie morgens, nachmittags und abends?',
      promptVi: 'Describe your typical work day. What do you do in the morning, afternoon, and evening?',
      wordLimit: 100,
      isCompleted: true,
      overallScore: 78.0,
      grammarScore: 75.0,
      vocabularyScore: 80.0,
      coherenceScore: 79.0,
      createdAt: null,
    ),
    WritingPractice(
      id: 'practice-2',
      title: 'Urlaub',
      titleVi: 'Vacation',
      prompt: 'Schreiben Sie über Ihren letzten Urlaub. Wo sind Sie hingefahren? Was haben Sie gemacht?',
      promptVi: 'Write about your last vacation. Where did you go? What did you do?',
      wordLimit: 120,
      isCompleted: false,
      createdAt: null,
    ),
    WritingPractice(
      id: 'practice-3',
      title: 'Meine Familie',
      titleVi: 'My Family',
      prompt: 'Beschreiben Sie Ihre Familie. Wer sind die Mitglieder? Was machen sie?',
      promptVi: 'Describe your family. Who are the members? What do they do?',
      wordLimit: 100,
      isCompleted: false,
      createdAt: null,
    ),
    WritingPractice(
      id: 'practice-4',
      title: 'Gesund leben',
      titleVi: 'Living Healthy',
      prompt: 'Was bedeutet "gesund leben" für Sie? Welche Gewohnheiten haben Sie?',
      promptVi: 'What does "living healthy" mean to you? What habits do you have?',
      wordLimit: 150,
      isCompleted: false,
      createdAt: null,
    ),
  ];
}

final aiWritingMockRepositoryProvider = Provider<AIWritingMockRepository>(
  (ref) => AIWritingMockRepository(),
);
