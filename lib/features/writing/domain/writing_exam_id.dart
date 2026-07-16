/// Stable persistence-key builder for Goethe B1 writing practice — web parity
/// `buildGoetheB1WritingExamId` (`src/lib/exam/exam-id-builder.ts`). Resolves
/// W1 unresolved question #1: every W2+ caller MUST use this helper instead
/// of hand-rolling the `examId` string passed into `WritingPracticePanel`.
///
/// Format: `goethe-b1-writing-teil-{teil}/{slug}/schreiben`.
String buildGoetheB1WritingExamId({required int teil, required String slug}) {
  return 'goethe-b1-writing-teil-$teil/$slug/schreiben';
}
