import 'dart:io';

void main() async {
  final file = File('lib/navigation/app_router.dart');
  var content = file.readAsStringSync();

  // Map of old import patterns to new ones
  final replacements = {
    '../../features/auth/presentation/': '../screens/auth/',
    '../../features/ai_tutor/presentation/': '../screens/ai_tutor/',
    '../../features/ai_tutor/presentation/widgets/': '../widgets/ai_tutor/',
    '../../features/ai/presentation/': '../screens/ai/',
    '../../features/affiliate/presentation/': '../screens/affiliate/',
    '../../features/exam/presentation/': '../screens/exam/',
    '../../features/flashcard/presentation/': '../screens/flashcard/',
    '../../features/journey/presentation/': '../screens/journey/',
    '../../features/journey/presentation/widgets/': '../widgets/journey/',
    '../../features/listening/presentation/': '../screens/listening/',
    '../../features/listening/domain/': '../data/listening/',
    '../../features/social/presentation/': '../screens/social/',
    '../../features/speaking/presentation/': '../screens/speaking/',
    '../../features/stats/presentation/': '../screens/stats/',
    '../../features/games/games/': '../screens/games/',
    '../../features/games/presentation/': '../screens/games/',
    '../../features/games/widgets/': '../widgets/games/',
    '../../features/leaderboard/presentation/': '../screens/leaderboard/',
    '../../features/legal/': '../screens/legal/',
    '../../features/profile/presentation/': '../screens/profile/',
    '../../features/settings/presentation/': '../screens/settings/',
    '../../features/reminders/presentation/': '../screens/reminders/',
    '../../features/progress/presentation/': '../screens/progress/',
    '../../features/grammar/presentation/': '../screens/grammar/',
    '../../features/interview/presentation/': '../screens/interview/',
    '../../features/interview/presentation/widgets/': '../widgets/interview/',
    '../../features/interview/domain/': '../data/interview/',
    '../../features/home/presentation/': '../screens/home/',
    '../../features/home/presentation/widgets/': '../widgets/home/',
    '../../features/webview/presentation/': '../screens/webview/',
    '../../features/vocabulary_search/presentation/':
        '../screens/vocab_search/',
    '../../features/vocabulary_search/widgets/': '../widgets/vocab_search/',
    '../../features/achievements/': '../screens/achievements/',
    '../../features/decks/presentation/': '../screens/decks/',
    '../../features/quiz/presentation/': '../screens/quiz/',
    '../data/': '../../data/',
    '../repositories/': '../../repositories/',
  };

  for (final entry in replacements.entries) {
    content = content.replaceAll(entry.key, entry.value);
  }

  file.writeAsStringSync(content);
  print('Fixed imports in app_router.dart');
}

// ignore_for_file: avoid_print
