// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'DeutschTiger';

  @override
  String get settings => 'Settings';

  @override
  String get profile => 'Profile';

  @override
  String get messages => 'Messages';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get couldNotLoadProfile => 'Could not load profile.';

  @override
  String get home => 'Home';

  @override
  String get learner => 'Learner';

  @override
  String get couldNotLoadHome => 'Could not load Home. Please try again.';

  @override
  String get couldNotLoadData => 'Could not load data. Please try again.';

  @override
  String get mission => 'Mission';

  @override
  String get searchVocabulary => 'Search vocabulary...';

  @override
  String get todayMissions => 'Today\'s missions';

  @override
  String get seeAll => 'See all';

  @override
  String get noBonusMissions => 'There are no bonus missions today.';

  @override
  String get dailyMissionsHeading => '🎁 Bonus missions';

  @override
  String get todaySession => 'Today\'s session';

  @override
  String get dueWords => 'Words due';

  @override
  String get goodMorning => 'Good morning';

  @override
  String get goodNoon => 'Good afternoon';

  @override
  String get goodAfternoon => 'Good afternoon';

  @override
  String get goodEvening => 'Good evening';

  @override
  String get headerEncouragement => 'Ready to conquer German? 🚀';

  @override
  String get headerStreakStart => 'Get started';

  @override
  String get todayXp => 'XP today';

  @override
  String get streak => 'Streak';

  @override
  String streakDays(int count) {
    return '$count days';
  }

  @override
  String get zeroMinutes => '0 minutes';

  @override
  String minutesShort(int count) {
    return '$count minutes';
  }

  @override
  String hoursShort(int count) {
    return '$count hr';
  }

  @override
  String hoursMinutesShort(int hours, int minutes) {
    return '$hours hr $minutes min';
  }

  @override
  String get wordsLearned => 'Words learned';

  @override
  String get lookupCount => 'Lookups';

  @override
  String get today => 'Today';

  @override
  String get viewDetails => 'View details';

  @override
  String get weeklyLeaderboard => '🏆 This week';

  @override
  String get seeFull => 'See full leaderboard →';

  @override
  String get learnMoreToRank => 'Learn more today to climb the leaderboard! 🔥';

  @override
  String get weeklyLeaderboardInTop3 => 'You\'re in the top 3 — keep it up! 🎉';

  @override
  String get user => 'User';

  @override
  String get noWeeklyLeaderboard =>
      'No one is on this week\'s leaderboard yet.';

  @override
  String get noWeeklyLeaderboardSubtitle => 'Learn today to be the first! 🔥';

  @override
  String get qaTabExam => '🎓 Exam prep';

  @override
  String get qaTabVocab => 'Vocab & Review';

  @override
  String get qaTabListen => 'Listen & Watch';

  @override
  String get qaTabAi => 'Write & Speak (AI)';

  @override
  String get qaTabOther => 'Other';

  @override
  String get qaTabAll => 'All →';

  @override
  String get qaExamTitle => 'Exam prep';

  @override
  String get qaExamSubtitle => 'Goethe, telc';

  @override
  String get qaVocabTitle => 'Vocabulary';

  @override
  String qaVocabSubtitle(int count) {
    return '$count+ words';
  }

  @override
  String get qaNotesTitle => 'Notebook';

  @override
  String get qaNotesSubtitle => 'Words you saved';

  @override
  String get qaReviewTitle => 'Review';

  @override
  String get qaReviewSubtitle => 'Words due for review';

  @override
  String get qaYoutubeTitle => 'YouTube';

  @override
  String get qaYoutubeSubtitle => 'Bilingual videos';

  @override
  String get qaListenTitle => 'Listening';

  @override
  String get qaListenSubtitle => 'Practice listening with video';

  @override
  String get qaNewsTitle => 'News';

  @override
  String get qaNewsSubtitle => 'German news A1–B2';

  @override
  String get qaSentenceAiTitle => 'Sentence writing (AI)';

  @override
  String get qaSentenceAiSubtitle => 'Build & write sentences, AI graded';

  @override
  String get qaAiTutorTitle => 'AI Tutor';

  @override
  String get qaAiTutorSubtitle => 'Chat with AI';

  @override
  String get qaGamesTitle => 'Games';

  @override
  String get qaGamesSubtitle => 'Learn through games, earn XP';

  @override
  String get qaAffiliateTitle => 'Refer & earn';

  @override
  String get qaAffiliateSubtitle => 'Earn commission';

  @override
  String get dailyPathHeroTitle => '☀️ What\'s next today?';

  @override
  String dailyPathExamBadge(int days, String examLabel) {
    return '$days days to the $examLabel exam';
  }

  @override
  String dailyPathPlanSummary(int done, int total) {
    return 'Today\'s plan · $done/$total steps';
  }

  @override
  String dailyPathMinutesRemaining(int minutes) {
    return 'about $minutes minutes left';
  }

  @override
  String dailyPathNextStep(int minutes) {
    return 'Next step · ~$minutes min';
  }

  @override
  String get dailyPathCompleteCelebration => '🎉 Today\'s path is done!';

  @override
  String dailyPathCompleteCelebrationWithStreak(int count) {
    return '🎉 Today\'s path is done! Keep your 🔥$count-day streak going.';
  }

  @override
  String get dailyPathEmptyTitle => 'Start today\'s learning path';

  @override
  String get dailyPathEmptyDescription =>
      'A few minutes each day keeps your streak and progress going.';

  @override
  String get dailyPathEmptyCta => 'Start learning';

  @override
  String get learnMore => 'Learn more';

  @override
  String get start => 'Start';

  @override
  String get couldNotCompleteAuth =>
      'Could not complete sign-in. Please try again.';

  @override
  String get signUpSuccess =>
      'Sign-up succeeded. Check your email to confirm your account.';

  @override
  String get welcomeLearnGerman => 'Learn German';

  @override
  String get welcomeEveryDayWith => 'every day with ';

  @override
  String get welcomeDescription =>
      'A German learning app for Vietnamese learners — review vocabulary, complete daily missions, and practise reading, writing, and interviews.';

  @override
  String get smartVocabularyReview => 'Smart vocabulary review';

  @override
  String get smartVocabularyReviewDescription =>
      'Repeat flashcards right before you are about to forget them.';

  @override
  String get dailyMissionsAndStreak => 'Daily missions & streak';

  @override
  String get dailyMissionsAndStreakDescription =>
      'Set daily goals and keep your streak going.';

  @override
  String get trackProgress => 'Track your progress';

  @override
  String get trackProgressDescription =>
      'XP, level, and minutes learned each day.';

  @override
  String get startLearning => 'Start learning';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get logIn => 'Log in';

  @override
  String get loginToContinue => 'Log in to continue learning';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get continueWithApple => 'Continue with Apple';

  @override
  String get or => 'or';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get signUp => 'Sign up';

  @override
  String get createNewAccount => 'Create a new account';

  @override
  String get displayName => 'Display name';

  @override
  String get yourName => 'Your name';

  @override
  String get atLeastSixCharacters => 'At least 6 characters';

  @override
  String get createAccount => 'Create account';

  @override
  String get signUpWithGoogle => 'Sign up with Google';

  @override
  String get signUpWithApple => 'Sign up with Apple';

  @override
  String get passwordRecovery => 'Password recovery';

  @override
  String get passwordRecoveryDescription =>
      'Enter your registered email and we will send a recovery link.';

  @override
  String get passwordRecoverySent =>
      'Recovery email sent. Please check your inbox.';

  @override
  String get sendRecoveryEmail => 'Send recovery email';

  @override
  String get backToLogin => 'Back to login';

  @override
  String get emailRequired => 'Enter your email.';

  @override
  String get invalidEmail => 'Enter a valid email address.';

  @override
  String get passwordRequired => 'Enter your password.';

  @override
  String get passwordTooShort => 'Your password must be at least 6 characters.';

  @override
  String get displayNameRequired => 'Enter a display name.';

  @override
  String get displayNameTooShort => 'Your display name is too short.';

  @override
  String get skip => 'Skip';

  @override
  String get continueAction => 'Continue';

  @override
  String get smartVocabularyLearning => 'Learn vocabulary smartly';

  @override
  String get smartVocabularyLearningDescription =>
      'Repeat flashcards right before you are about to forget them. More than 5,000 words organised by A1–C1 topic.';

  @override
  String get goetheTelcPractice => 'Practise for Goethe / telc';

  @override
  String get goetheTelcPracticeDescription =>
      'A1–B2 mock exams with automatic grading and a study path tailored to your level.';

  @override
  String get gamificationAndStreak => 'Gamification & streak';

  @override
  String get gamificationAndStreakDescription =>
      'XP, level, learning streaks, friend leaderboards, and rewarding daily challenges.';

  @override
  String get resetPassword => 'Reset password';

  @override
  String get enterNewPassword => 'Enter a new password';

  @override
  String get newPasswordDescription =>
      'Your new password must be at least 8 characters.';

  @override
  String get newPassword => 'New password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get passwordResetSuccess => 'Your password was reset successfully.';

  @override
  String get couldNotResetPassword =>
      'Could not reset your password. Please try again.';

  @override
  String get newPasswordRequired => 'Enter a new password.';

  @override
  String get newPasswordTooShort =>
      'Your new password must be at least 8 characters.';

  @override
  String get passwordConfirmationMismatch =>
      'Your password confirmation does not match.';

  @override
  String get avatarUrlOptional => 'Avatar image URL (optional)';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get couldNotUpdateProfile =>
      'Could not update your profile. Please try again.';

  @override
  String get premium => 'Premium';

  @override
  String get level => 'Level';

  @override
  String get totalXp => 'Total XP';

  @override
  String get leaderboardTitle => 'Leaderboard';

  @override
  String get thisWeek => 'This week';

  @override
  String get allTime => 'All time';

  @override
  String get couldNotLoadLeaderboard =>
      'Could not load the leaderboard. Please try again.';

  @override
  String get noLeaderboardEntries => 'There are no leaderboard entries yet.';

  @override
  String get exam => 'Exam';

  @override
  String get examPractice => 'Exam practice';

  @override
  String get loadingExam => 'Loading exam…';

  @override
  String get examQuestionPalette => 'Question palette';

  @override
  String examQuestionProgress(int current, int total) {
    return 'Question $current / $total';
  }

  @override
  String get previous => 'Previous';

  @override
  String get next => 'Next';

  @override
  String get done => 'Done';

  @override
  String get submitExam => 'Submit exam';

  @override
  String get exitExamTitle => 'Exit exam?';

  @override
  String get exitExamBody => 'Your progress has been saved automatically.';

  @override
  String get exit => 'Exit';

  @override
  String get submitExamTitle => 'Submit exam?';

  @override
  String submitExamUnanswered(int count) {
    return 'You still have $count unanswered questions. Submit anyway?';
  }

  @override
  String get reviewAnswers => 'Review answers';

  @override
  String get allFilters => 'All';

  @override
  String get couldNotLoadExams => 'Could not load exams. Please try again.';

  @override
  String get noSupportedExams =>
      'There are no suitable reading or listening exams yet.';

  @override
  String get examReadinessTitle => 'Exam readiness';

  @override
  String get examReadinessEmpty =>
      'No data yet — complete at least 1 exam to see your readiness.';

  @override
  String get examReadinessAttempts => 'Attempts';

  @override
  String get examReadinessBestScore => 'Best score';

  @override
  String get examReadinessDueReviews => 'Words due for review';

  @override
  String get examReadinessSkillBreakdown => 'By skill';

  @override
  String get examReadinessWeaknesses => 'Weaknesses to fix';

  @override
  String get examReadinessBandLabel => 'Estimated readiness';

  @override
  String get examScheduleTitle => 'Find a study buddy';

  @override
  String get examBuddyListTab => 'Study buddy list';

  @override
  String get examMyRegistrationsTab => 'My info';

  @override
  String get examBuddyListEmpty => 'No one has registered an exam plan yet.';

  @override
  String examBuddyDaysUntil(int days) {
    return '$days days left';
  }

  @override
  String get examBuddyPast => 'Already taken';

  @override
  String get examRegistrationAdd => 'Add exam plan';

  @override
  String get examRegistrationDelete => 'Delete exam plan';

  @override
  String get examRegistrationFormTitle => 'Register exam plan';

  @override
  String get examTypeLabel => 'Exam type';

  @override
  String get examLevelLabel => 'Level';

  @override
  String get examDateLabel => 'Exam date';

  @override
  String get examRegistrationSave => 'Save';

  @override
  String get communityExamsTitle => 'Community exams';

  @override
  String get communityExamsEmpty => 'No community exams yet.';

  @override
  String get communityExamDetailTitle => 'Exam details';

  @override
  String communityExamContributedBy(String name) {
    return 'Contributed by $name';
  }

  @override
  String get deThiListTitle => 'Public exams';

  @override
  String get deThiListEmpty => 'No public exams yet.';

  @override
  String get deThiNotFound => 'This exam could not be found.';

  @override
  String get deThiRevealAnswer => 'Show answer';

  @override
  String deThiCorrectAnswer(String answer) {
    return 'Correct answer: $answer';
  }

  @override
  String get examDictationPickerTitle => 'Choose a listening exam';

  @override
  String get examDictationTitle => 'Dictation practice';

  @override
  String get examDictationNotFound => 'This exam has no dictation data yet.';

  @override
  String get examDictationNoWords => 'No suitable words to practice yet.';

  @override
  String get examDictationCheck => 'Check';

  @override
  String examQuestionsCount(int count) {
    return '$count questions';
  }

  @override
  String examDurationMinutes(int count) {
    return '$count min';
  }

  @override
  String get practiceExam => 'Practice';

  @override
  String get examTestMode => 'Test';

  @override
  String get examReviewMode => 'Review';

  @override
  String get couldNotPlayAudio =>
      'Audio could not be played. Please try again.';

  @override
  String get examListeningAudio => 'Listening';

  @override
  String get audioPlay => 'Play audio';

  @override
  String get audioPause => 'Pause audio';

  @override
  String audioPlayCounter(int used, int max, String remaining) {
    return '$used/$max plays · $remaining remaining';
  }

  @override
  String get audioPlayLimitReached => 'You have used all allowed plays.';

  @override
  String get examResults => 'Results';

  @override
  String get couldNotLoadExamResult =>
      'Could not load the exam result. Please try again.';

  @override
  String get noExamResult => 'There is no result for this exam yet.';

  @override
  String get passedExam => 'PASSED';

  @override
  String get notPassedExam => 'NOT PASSED';

  @override
  String get examAnswered => 'Answered';

  @override
  String examAnsweredQuestions(int answered, int total) {
    return '$answered/$total questions';
  }

  @override
  String get examTime => 'Time';

  @override
  String get examCorrectRate => 'Correct rate';

  @override
  String get examSectionAnalysis => 'Section analysis';

  @override
  String get examSectionReading => 'Reading';

  @override
  String get examSectionListening => 'Listening';

  @override
  String examSectionSummary(int correct, int total, int minutes) {
    return '$correct/$total correct · $minutes min';
  }

  @override
  String get reviewExam => 'Review exam';

  @override
  String get retryExam => 'Try again';

  @override
  String get examCorrect => 'Correct';

  @override
  String get examNotCorrect => 'Not correct';

  @override
  String examQuestionNumber(int number) {
    return 'Question $number';
  }

  @override
  String matchingSelectRight(int number) {
    return 'Choose a right-hand option to match item $number';
  }

  @override
  String get removeMatch => 'Remove match';

  @override
  String examGapNumber(int number) {
    return 'Gap $number';
  }

  @override
  String get takeMockExam => 'Mock exam';

  @override
  String get learn => 'Learn';

  @override
  String get learningJourney => 'Learning journey';

  @override
  String get retryTodaySession => 'Reload today\'s session';

  @override
  String get couldNotLoadTodayLesson => 'Could not load today\'s lesson.';

  @override
  String get coursesTileTitle => 'Courses';

  @override
  String get coursesHubTitle => 'Courses';

  @override
  String get coursesFeaturedSection => 'Featured courses';

  @override
  String get coursesMySection => 'In progress';

  @override
  String get coursesAllSection => 'All courses';

  @override
  String get coursesEmptyCatalog => 'No courses yet.';

  @override
  String coursesLessonsCount(int count) {
    return '$count lessons';
  }

  @override
  String coursesLessonsStarted(int count) {
    return '$count lessons started';
  }

  @override
  String get coursesNoLessonsYet => 'This course has no lessons yet.';

  @override
  String get coursesLessonCompleted => 'Completed';

  @override
  String get coursesMarkComplete => 'Mark as complete';

  @override
  String get coursesMarkIncomplete => 'Unmark complete';

  @override
  String get coursesVideoWebOnly =>
      'This lesson\'s video is currently only available on the web.';

  @override
  String get coursesVocabularyTitle => 'Lesson vocabulary';

  @override
  String coursesExercisesHint(int count) {
    return '$count interactive exercises — available on the web.';
  }

  @override
  String get coursesNotesLabel => 'Your notes';

  @override
  String get coursesNotesHint => 'Write your notes for this lesson...';

  @override
  String get coursesNotesSave => 'Save note';

  @override
  String get coursesNotesSaved => 'Note saved';

  @override
  String get coursesNotesSaveFailed => 'Could not save note, try again.';

  @override
  String get coursesSignInRequired => 'Sign in to save progress and notes.';

  @override
  String coursesLessonNumber(int number) {
    return 'Lesson $number';
  }

  @override
  String get missionComplete => 'Mission complete!';

  @override
  String get noMissionRounds =>
      'There are no learning rounds in today\'s vocabulary lesson.';

  @override
  String get startPractice => 'Start practice';

  @override
  String get missionPractice => 'Practice';

  @override
  String get notRemembered => 'Not remembered';

  @override
  String get rememberedCorrectly => 'Remembered correctly';

  @override
  String get missionAnswerCorrect => 'Correct!';

  @override
  String get missionAnswerTryAgain => 'Not quite—keep going!';

  @override
  String get saving => 'Saving…';

  @override
  String get saveToDeck => 'Save to deck';

  @override
  String get saved => 'Saved';

  @override
  String get alreadySaved => 'Already saved';

  @override
  String get wordSavedToDeck => 'Word saved to deck.';

  @override
  String get openDeck => 'Open deck';

  @override
  String get couldNotSaveWord =>
      'Could not save this word. Sign in and try again.';

  @override
  String get chooseDeck => 'Choose a deck';

  @override
  String get chooseDeckDescription =>
      'Quick-save this word or choose a specific deck.';

  @override
  String get quickSave => 'Quick save';

  @override
  String get deviceSessionEnded => 'Your session has ended';

  @override
  String get deviceKickedBody =>
      'This device was signed out. Please sign in again to continue.';

  @override
  String get signInAgain => 'Sign in again';

  @override
  String get wordNotFound => 'This word was not found in the dictionary.';

  @override
  String get lookingUpWord => 'Looking up word…';

  @override
  String get couldNotLookupWord =>
      'Could not look up this word right now. Please try again.';

  @override
  String get meaning => 'Meaning';

  @override
  String get example => 'Example';

  @override
  String get saveSentence => 'Save sentence';

  @override
  String get sentenceSaved => 'Sentence saved';

  @override
  String get couldNotSaveSentence => 'Could not save this sentence right now.';

  @override
  String get couldNotSaveMissionRound =>
      'Could not save this learning round. Please try again.';

  @override
  String get couldNotCompleteMission =>
      'Could not complete this mission. Please try again.';

  @override
  String get score => 'Score';

  @override
  String get accuracy => 'Accuracy';

  @override
  String get playAgain => 'Play again';

  @override
  String missionCompletedXp(int xp) {
    return 'Completed · $xp XP';
  }

  @override
  String missionRoundsWords(int rounds, int words) {
    return '$rounds rounds · $words words';
  }

  @override
  String get completed => 'Completed';

  @override
  String get more => 'More';

  @override
  String get moreFeaturesTitle => 'DeutschTiger features';

  @override
  String get close => 'Close';

  @override
  String get groupVocabularyReview => 'Vocabulary & review';

  @override
  String get groupExtraPractice => 'More practice';

  @override
  String get groupGrammarSkills => 'Grammar & skills';

  @override
  String get groupCommunityProgress => 'Community & progress';

  @override
  String get myWords => 'My words';

  @override
  String get savedWords => 'Saved';

  @override
  String get viewedWords => 'Viewed';

  @override
  String get wordsToReview => 'To review';

  @override
  String get couldNotLoadMyWords =>
      'Could not load your words. Please try again.';

  @override
  String get noWordsForFilter => 'There are no words in this group yet.';

  @override
  String myWordsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count words',
      one: '1 word',
      zero: 'No words',
    );
    return '$_temp0';
  }

  @override
  String get flashcardDecks => 'Flashcard decks';

  @override
  String get reviewDueDeckCards => 'Review due cards';

  @override
  String get emptyDeckCards => 'This deck does not have any cards yet.';

  @override
  String get myDecks => 'My decks';

  @override
  String get createDeck => 'Create deck';

  @override
  String get createNewDeck => 'Create a new deck';

  @override
  String get editDeck => 'Edit deck';

  @override
  String get deleteDeck => 'Delete deck';

  @override
  String deleteDeckConfirmation(Object name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String get couldNotLoadDecks => 'Could not load your decks.';

  @override
  String get noDecks => 'You do not have any decks yet';

  @override
  String get noDecksDescription =>
      'Create a deck to study the topics you choose.';

  @override
  String get deckName => 'Deck name';

  @override
  String get deckNameHint => 'For example: Travel vocabulary';

  @override
  String get deckDescriptionOptional => 'Description (optional)';

  @override
  String get deckDescriptionHint => 'A short description of this deck';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String wordsCount(int count) {
    return '$count words';
  }

  @override
  String learnedWordsProgress(int learned, int total) {
    return '$learned/$total learned';
  }

  @override
  String get dailyReview => 'Daily review';

  @override
  String get flashcardReview => 'Flashcard review';

  @override
  String get tapToShowMeaning => 'Tap to show the meaning';

  @override
  String get listenPronunciation => 'Listen to pronunciation';

  @override
  String get couldNotLoadReviewData => 'Could not load review data.';

  @override
  String get couldNotLoadReviewCards => 'Could not load review cards.';

  @override
  String get noCardsDueToday => 'There are no cards due today 🎉';

  @override
  String get backToHome => 'Back to Home';

  @override
  String reviewStreak(int count) {
    return '$count day streak! 🔥';
  }

  @override
  String get keepReviewStreak => 'Keep your streak by reviewing every day';

  @override
  String get due => 'Due';

  @override
  String get reviewed => 'Reviewed';

  @override
  String get startDailyReview => 'Start review';

  @override
  String get showMeaning => 'Show meaning';

  @override
  String reviewProgress(int current, int total) {
    return '$current / $total';
  }

  @override
  String get couldNotSaveReview =>
      'Your review could not be saved. Please try again.';

  @override
  String get ratingAgain => 'Again';

  @override
  String get ratingAgainHint => '<1 min';

  @override
  String get ratingHard => 'Hard';

  @override
  String get ratingHardHint => 'Hard';

  @override
  String get ratingGood => 'Good';

  @override
  String get ratingGoodHint => 'OK';

  @override
  String get ratingEasy => 'Easy';

  @override
  String get ratingEasyHint => 'Easy';

  @override
  String get vocabularyLibrary => 'Vocabulary library';

  @override
  String get vocabulary => 'Vocabulary';

  @override
  String get couldNotLoadVocabulary =>
      'Could not load vocabulary. Please try again.';

  @override
  String get noVocabulary => 'There is no vocabulary here yet.';

  @override
  String cefrLevelsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count CEFR levels',
      one: '$count CEFR level',
    );
    return '$_temp0';
  }

  @override
  String get vocabularyByGoal => 'By goal';

  @override
  String get vocabularyByLevel => 'By level';

  @override
  String get vocabularyByTopic => 'By topic';

  @override
  String get learnByGoal => 'Learn by goal';

  @override
  String get learnByGoalDescription =>
      'Goals are quick ways into the same vocabulary library by topic and level.';

  @override
  String get goalDailyLife => 'German for daily life';

  @override
  String get goalSettlementHome => 'Settlement & housing';

  @override
  String get goalTravel => 'Travel & transport';

  @override
  String get goalFoodService => 'Food & restaurants';

  @override
  String get goalWork => 'Work & careers';

  @override
  String get goalMedical => 'Healthcare & nursing';

  @override
  String get goalStudyExam => 'Study & exam preparation';

  @override
  String cefrLevel(Object level) {
    return 'Level $level';
  }

  @override
  String get cefrBeginner => 'Beginner';

  @override
  String get cefrPreIntermediate => 'Pre-intermediate';

  @override
  String get cefrIntermediate => 'Intermediate';

  @override
  String get cefrUpperIntermediate => 'Upper-intermediate';

  @override
  String get cefrAdvanced => 'Advanced';

  @override
  String get cefrProficient => 'Proficient';

  @override
  String get noVocabularyTopics => 'There are no vocabulary topics yet.';

  @override
  String vocabularyTopicStats(Object label, int count) {
    return '$label · $count words';
  }

  @override
  String vocabularyTopicTitle(Object topic) {
    return 'Vocabulary: $topic';
  }

  @override
  String get noVocabularyInLesson =>
      'There is no vocabulary in this lesson yet.';

  @override
  String get noMatchingVocabulary => 'No words match your filters.';

  @override
  String get clearVocabularyFilters => 'Try clearing a filter.';

  @override
  String get searchLessonVocabulary => 'Search this lesson…';

  @override
  String get allLevels => 'All';

  @override
  String lessonProgress(int learned, int total) {
    return 'Progress: $learned / $total words';
  }

  @override
  String get wordMeanings => 'Meanings';

  @override
  String get wordExamples => 'Examples';

  @override
  String get viewVocabularyDetails => 'View details';

  @override
  String get flipVocabularyCard => 'Flip card';

  @override
  String get noMeaning => 'No meaning available';

  @override
  String get wordGender => 'Gender';

  @override
  String get wordPlural => 'Plural';

  @override
  String get wordType => 'Type';

  @override
  String get auxiliaryVerb => 'Auxiliary verb';

  @override
  String get comparative => 'Comparative';

  @override
  String get superlative => 'Superlative';

  @override
  String get verbConjugation => 'Verb conjugation';

  @override
  String get principalForms => 'Principal forms';

  @override
  String get relatedWords => 'Related words';

  @override
  String get flashcardPractice => 'Flashcards';

  @override
  String get practice => 'Practice';

  @override
  String get listeningPractice => 'Listening practice';

  @override
  String get newsReading => 'German news';

  @override
  String get writingPractice => 'Writing practice';

  @override
  String get aiChat => 'AI chat';

  @override
  String get grammar => 'Grammar';

  @override
  String get grammarSearchHint => 'Search any grammar lesson...';

  @override
  String get grammarNoResults => 'No lessons found';

  @override
  String get grammarNoLessons => 'No lessons yet';

  @override
  String get grammarAllDone => '🎉 All done!';

  @override
  String get grammarViewAll => 'View all';

  @override
  String get grammarMarkComplete => 'Mark as complete';

  @override
  String get grammarCompleted => 'Completed';

  @override
  String get grammarAlreadyCompleted =>
      'You already completed this lesson before.';

  @override
  String get grammarRelatedLessons => 'Related lessons';

  @override
  String get grammarNotFound => 'Lesson not found.';

  @override
  String get grammarArticleNotFound => 'Article not found.';

  @override
  String get grammarArticles => 'Further reading';

  @override
  String get gamePractice => 'Practice games';

  @override
  String get community => 'Community';

  @override
  String get statistics => 'Statistics';

  @override
  String get achievements => 'Achievements';

  @override
  String get leaderboard => 'Leaderboard';

  @override
  String get offlineMessage =>
      'No internet connection. Some features may be limited.';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeMode => 'Theme';

  @override
  String get systemTheme => 'System default';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get sound => 'Sound';

  @override
  String get pronunciationVolume => 'Pronunciation volume';

  @override
  String get autoplayPronunciation => 'Autoplay pronunciation';

  @override
  String get autoplayDescription => 'Play audio when a card is flipped';

  @override
  String get language => 'Language';

  @override
  String get appLanguage => 'App language';

  @override
  String get selectLanguage => 'Choose language';

  @override
  String get notifications => 'Notifications';

  @override
  String get learningReminders => 'Learning reminders';

  @override
  String get learningRemindersDescription => 'Receive daily learning reminders';

  @override
  String get reminderTime => 'Reminder time';

  @override
  String get securityAndAccount => 'Security & account';

  @override
  String get security => 'Security';

  @override
  String get signedInDevices => 'Signed-in devices';

  @override
  String get signOutOtherDevicesTitle => 'Sign out of other devices?';

  @override
  String get signOutOtherDevicesBody =>
      'All other sessions will be signed out. You will keep the current session on this device.';

  @override
  String get cancel => 'Cancel';

  @override
  String get signOut => 'Sign out';

  @override
  String get signOutConfirm => 'Are you sure you want to sign out?';

  @override
  String get signOutOtherDevices => 'Sign out of all other devices';

  @override
  String get signedOutOtherDevices => 'Signed out of other devices.';

  @override
  String get signedOutDevice => 'Device signed out.';

  @override
  String get signOutDeviceTitle => 'Sign out this device?';

  @override
  String signOutDeviceBody(Object device) {
    return 'The device \"$device\" will be signed out of your account.';
  }

  @override
  String get couldNotSignOut => 'Could not sign out. Please try again.';

  @override
  String get couldNotLoadDevices => 'Could not load the device list.';

  @override
  String get retry => 'Retry';

  @override
  String get noSignedInDevices => 'There are no signed-in devices.';

  @override
  String get account => 'Account';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountDescription =>
      'See how to request deletion of your account and related data.';

  @override
  String get accountDeletionUnavailableTitle =>
      'In-app account deletion is not available yet';

  @override
  String get accountDeletionUnavailableBody =>
      'To request deletion of your account and related data, contact support@deutschtiger.com from your registered email address. The app cannot confirm a deletion request until the backend supports this process.';

  @override
  String get contactSupport => 'Contact support';

  @override
  String get unknownDevice => 'Unknown device';

  @override
  String get currentDevice => 'Current';

  @override
  String get signOutThisDevice => 'Sign out this device';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(int count) {
    return '$count minutes ago';
  }

  @override
  String hoursAgo(int count) {
    return '$count hours ago';
  }

  @override
  String daysAgo(int count) {
    return '$count days ago';
  }

  @override
  String get securityDevices => 'Security & devices';

  @override
  String get securityDevicesDescription =>
      'Manage sessions and delete your account';

  @override
  String get changePassword => 'Change password';

  @override
  String get changeEmail => 'Change email';

  @override
  String get exportData => 'Export data';

  @override
  String get exportDataDescription => 'Request a copy of your learning data';

  @override
  String get dataExportUnavailable =>
      'In-app data export is not available yet. Please contact support@deutschtiger.com.';

  @override
  String get couldNotOpenLink => 'This link could not be opened.';

  @override
  String get unexpectedDisplayError =>
      'Something went wrong while displaying this page.';

  @override
  String get openLinkError => 'An error occurred while opening the link.';

  @override
  String get ratingThanks => 'Thanks for rating the app!';

  @override
  String get ai => 'AI';

  @override
  String get aiMemorySettings => 'AI memory & settings';

  @override
  String get aiMemoryDescription => 'Level, exams and grammar hints';

  @override
  String get sendFeedback => 'Send feedback';

  @override
  String get sendFeedbackDescription => 'Help us improve the app';

  @override
  String get feedbackTitle => 'Send feedback';

  @override
  String get feedbackCategoryBug => 'Bug report';

  @override
  String get feedbackCategorySuggestion => 'Suggestion';

  @override
  String get feedbackCategoryOther => 'Other';

  @override
  String get feedbackDescriptionHint => 'Describe your feedback...';

  @override
  String get feedbackMessageRequired => 'Please enter your feedback.';

  @override
  String get feedbackSent => 'Thanks for your feedback!';

  @override
  String get feedbackCouldNotSend =>
      'Couldn\'t send feedback. Please try again.';

  @override
  String get sendAction => 'Send';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get termsOfService => 'Terms of service';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get helpCenter => 'Help center';

  @override
  String get rateApp => 'Rate the app';

  @override
  String get statsScreenTitle => 'Learning statistics';

  @override
  String get statsMasteryTitle => 'Vocabulary retention';

  @override
  String get statsErrorPatternsTitle => 'Common mistakes';

  @override
  String get statsCurrentStreak => 'Current streak';

  @override
  String get statsDaysUnit => 'days';

  @override
  String get statsCurrentLevel => 'Current level';

  @override
  String get statsWordsLearned => 'Words learned';

  @override
  String get statsTotalReviews => 'Total reviews';

  @override
  String get statsWeeklyXpChartTitle => 'XP over the last 7 days';

  @override
  String get statsMasteryTrendEmpty =>
      'No daily stats yet (updates every night).';

  @override
  String get statsErrorPatternsEmpty => 'No mistake data yet.';

  @override
  String get statsMasteryEmpty =>
      'No data yet. Review a few words to start tracking retention.';

  @override
  String get statsMasteryNew => 'New';

  @override
  String get statsMasteryLearning => 'Learning';

  @override
  String get statsMasteryYoung => 'Retaining';

  @override
  String get statsMasteryMature => 'Mastered';

  @override
  String get statsMasteryTrendTitle => 'Reviews over the last 30 days';

  @override
  String get errorSourceSchreibenExam => 'Writing exam';

  @override
  String get errorSourceSprechen => 'Speaking';

  @override
  String get errorSourceSentenceBuilder => 'Sentence practice';

  @override
  String get errorTypeArticleGender => 'Noun gender (der/die/das)';

  @override
  String get errorTypeCaseAkkDat => 'Case (Accusative/Dative)';

  @override
  String get errorTypeVerbConjugation => 'Verb conjugation';

  @override
  String get errorTypeVerbPosition => 'Verb position';

  @override
  String get errorTypeWordOrder => 'Word order';

  @override
  String get errorTypePreposition => 'Prepositions';

  @override
  String get errorTypePlural => 'Plural';

  @override
  String get errorTypeSpelling => 'Spelling';

  @override
  String get errorTypePunctuation => 'Punctuation';

  @override
  String get errorTypeTenseConsistency => 'Tense consistency';

  @override
  String get errorTypeOther => 'Other';

  @override
  String get errorPatternsSortCount => 'Count';

  @override
  String get errorPatternsSortRecent => 'Recent';

  @override
  String get errorPatternsEmptyTitle => 'No mistake data yet';

  @override
  String get errorPatternsEmptyBody =>
      'Practice sentence building or take an exam to start tracking!';

  @override
  String errorPatternsTimesCount(int count) {
    return '$count times';
  }

  @override
  String get errorPatternsExample => 'Example';

  @override
  String get dailyQuoteTitle => 'Quote of the day';

  @override
  String get dailyQuoteCopySuccess => 'Quote copied!';

  @override
  String get dailyQuoteExploreMore => 'Explore more';

  @override
  String get dailyQuoteRetryTooltip => 'Reload';

  @override
  String get back => 'Back';

  @override
  String get focusSessionTitle => 'Focus session';

  @override
  String focusSessionSummary(int count) {
    return 'You have $count items to practice today.';
  }

  @override
  String get focusSessionDueWordsTitle => 'Due reviews';

  @override
  String get focusSessionDueWordsEmpty => 'No words are due 🎉';

  @override
  String get focusSessionReviewNow => 'Review now';

  @override
  String get focusSessionExamFailTitle => 'Exam-fail words';

  @override
  String get focusSessionExamFailEmpty => 'No exam data yet';

  @override
  String get focusSessionSubtitleWordsTitle => 'Words from videos';

  @override
  String get focusSessionSubtitleWordsEmpty => 'No words seen in videos yet';

  @override
  String get focusSessionAddToReview => 'Add to review';

  @override
  String get focusSessionWeaknessesTitle => 'Common mistakes';

  @override
  String get focusSessionWeaknessesEmpty =>
      'No mistake data yet — practice writing to get an analysis';

  @override
  String focusSessionWeaknessesCount(int count) {
    return '$count common grammar mistake types';
  }

  @override
  String get focusSessionCaughtUpTitle => 'You\'re doing great!';

  @override
  String get focusSessionCaughtUpBody =>
      'No weak spots to practice right now. Take a test or learn new words for personalized suggestions.';

  @override
  String get learnerModelTitle => 'Learner profile';

  @override
  String get learnerModelCardsSuffix => 'cards mastered';

  @override
  String get learnerModelMasteryHint =>
      'Mastered = stable memory for 21+ days (FSRS).';

  @override
  String get learnerModelDueNow => 'Due now';

  @override
  String get learnerModelWeakTotal => 'Weak spots';

  @override
  String get learnerModelTotalCards => 'Total cards';

  @override
  String get learnerModelCoverageTitle => 'Coverage by level';

  @override
  String get learnerModelGrammarWeaknessesTitle => 'Grammar weaknesses';

  @override
  String learnerModelErrorCount(int count) {
    return '$count mistakes';
  }

  @override
  String get learnerModelCanDoSectionTitle => 'Things you can do in German';

  @override
  String get learnerModelCanDoEmpty =>
      'No data yet — practice writing/speaking to climb the ladder!';

  @override
  String get learnerModelWeakWordsTitle => 'Weak spots to practice';

  @override
  String get learnerModelWeakWordsEmpty =>
      'No words need extra practice. Great job!';

  @override
  String learnerModelLapsesCount(int count) {
    return '$count lapses';
  }

  @override
  String get canDoStatusSpoken => 'Speaks it 🗣️';

  @override
  String get canDoStatusMastered => 'Can do it ✍️';

  @override
  String get canDoStatusInProgress => 'In progress';

  @override
  String get canDoStatusNew => 'Not started';

  @override
  String get canDoPracticeNow => 'Practice now';

  @override
  String get canDoPracticeTitle => 'Practice a can-do';

  @override
  String canDoPracticeProgress(int current, int total) {
    return 'Sentence $current/$total';
  }

  @override
  String canDoPracticeInstructionStructure(Object pattern) {
    return 'Write a sentence using $pattern';
  }

  @override
  String canDoPracticeInstructionVocab(Object word) {
    return 'Write a sentence using the word «$word»';
  }

  @override
  String get canDoPracticeInputHint => 'Write your German sentence…';

  @override
  String get canDoPracticeError =>
      'Could not grade the sentence — try again shortly.';

  @override
  String get canDoPracticeCorrectedPrefix => 'Corrected';

  @override
  String get canDoPracticeFinish => 'Finish';

  @override
  String get canDoPracticeNext => 'Next sentence';

  @override
  String get canDoPracticeSubmitting => 'Grading…';

  @override
  String get canDoPracticeSubmit => 'Submit';

  @override
  String get canDoPracticeNotFound => 'This goal was not found.';

  @override
  String get canDoPracticeAllClear =>
      'You\'ve written all the blocks for this goal 🎉';

  @override
  String canDoPracticeDone(int correct, int total) {
    return 'Done! $correct/$total sentences passed — progress saved to the map.';
  }

  @override
  String get topicExploreTitle => 'Explore by topic';

  @override
  String get topicExploreEmpty => 'No topics yet.';

  @override
  String get practiceTitle => 'Practice';

  @override
  String get practiceChooseMode => 'Choose a practice mode';

  @override
  String get practiceModeCloze => 'Fill in the blank';

  @override
  String get practiceModeListening => 'Listening';

  @override
  String get practiceModeMatching => 'Matching';

  @override
  String get practiceModeWriting => 'Writing';

  @override
  String get practiceClozeHint => 'Type the missing German word';

  @override
  String get practiceWritingHint => 'Type the German word';

  @override
  String get practiceCheckAnswer => 'Check';

  @override
  String get practiceListeningPrompt => 'Listen and pick the correct meaning';

  @override
  String get practiceFeedbackCorrect => 'Correct!';

  @override
  String practiceFeedbackWrong(String word) {
    return 'Wrong — the answer was \"$word\"';
  }

  @override
  String practiceMatchingProgress(int matched, int total, int attempts) {
    return '$matched/$total matched · $attempts attempts';
  }

  @override
  String get practiceMatchingNeedsMoreWords =>
      'This deck needs at least 2 words to play matching.';

  @override
  String get practiceResultsTitle => 'Session complete!';

  @override
  String practiceAccuracySummary(int correct, int total) {
    return '$correct/$total correct';
  }

  @override
  String get practiceRestart => 'Practice again';

  @override
  String get practiceBackToDeck => 'Back to deck';

  @override
  String get subtitleWordsTitle => 'Words from subtitles';

  @override
  String get subtitleWordsEmpty =>
      'No new words from subtitles yet. Watch videos with subtitles to collect words here.';

  @override
  String subtitleWordsSeenCount(int count) {
    return 'seen ${count}x';
  }

  @override
  String subtitleWordsAddSelected(int count) {
    return 'Add $count to review';
  }

  @override
  String subtitleWordsAddedCount(int count) {
    return 'Added $count words to your review queue';
  }

  @override
  String get subtitleWordsAddFailed =>
      'Could not save the selected words. Please try again.';

  @override
  String get notificationMarkAllRead => 'Mark all as read';

  @override
  String get notificationEmpty => 'No notifications yet';

  @override
  String get notificationLoadError =>
      'Could not load notifications. Please try again.';

  @override
  String get notificationSomeone => 'Someone';

  @override
  String notificationFriendRequest(Object name) {
    return '$name sent you a friend request';
  }

  @override
  String notificationFriendAccepted(Object name) {
    return '$name accepted your friend request';
  }

  @override
  String notificationChallengeInvite(Object name) {
    return '$name challenged you';
  }

  @override
  String get notificationNewComment => 'New comment';

  @override
  String get notificationGradingDone => 'AI has graded your writing';

  @override
  String get notificationDailyReview => 'You have words due for review today';

  @override
  String get notificationGeneric => 'You have a new notification';

  @override
  String get notificationPreferencesTitle => 'Notification preferences';

  @override
  String get notificationPreferencesEnabledTitle => 'Learning reminders';

  @override
  String get notificationPreferencesEnabledDescription =>
      'Get a daily reminder to study';

  @override
  String get notificationPreferencesTime => 'Reminder time';

  @override
  String get notificationPreferencesContentMode => 'Notification content';

  @override
  String get notificationPreferencesContentWord => 'Vocabulary';

  @override
  String get notificationPreferencesContentReminder => 'Reminder';

  @override
  String get notificationPreferencesContentMix => 'Mixed';

  @override
  String get notificationPreferencesSaveError =>
      'Could not save. Please try again.';

  @override
  String get learningPreferencesTitle => 'Learning preferences';

  @override
  String get learningPreferencesLevel => 'CEFR level';

  @override
  String get learningPreferencesDailyMinutes => 'Daily study minutes';

  @override
  String get learningPreferencesDailyXpGoal => 'Daily XP goal';

  @override
  String get learningPreferencesSaveError =>
      'Could not save. Please try again.';

  @override
  String get learningPreferencesLoadError =>
      'Could not load learning preferences.';

  @override
  String get checkForUpdates => 'Check for updates';

  @override
  String get checkForUpdatesDescription =>
      'See if you\'re on the latest version';

  @override
  String get appUpToDate => 'You\'re on the latest version';

  @override
  String get appUpdateAvailableTitle => 'Update available';

  @override
  String get appUpdateAvailableBody =>
      'Please update the app to keep using it.';

  @override
  String get appUpdateAction => 'Update now';

  @override
  String get socialHubTitle => 'Community';

  @override
  String get socialTabMoments => 'Moments';

  @override
  String get socialTabFriends => 'Friends';

  @override
  String get socialTabRequests => 'Requests';

  @override
  String get socialTabSearch => 'Search';

  @override
  String get socialFriendsTitle => 'Friends';

  @override
  String get socialMessagesTitle => 'Messages';

  @override
  String get socialMomentsTitle => 'Moments';

  @override
  String get socialAnnouncementsTitle => 'Announcements';

  @override
  String get socialProfileTitle => 'Profile';

  @override
  String get socialLoadFriendsError => 'Could not load friends.';

  @override
  String get socialLoadRequestsError => 'Could not load requests.';

  @override
  String get socialLoadMessagesError => 'Could not load messages.';

  @override
  String get socialLoadMomentsError => 'Could not load moments.';

  @override
  String get socialLoadCommentsError => 'Could not load comments.';

  @override
  String get socialLoadAnnouncementsError => 'Could not load announcements.';

  @override
  String get socialLoadProfileError => 'Could not load profile.';

  @override
  String get socialSendMessageError =>
      'Could not send the message. Please try again.';

  @override
  String get socialSearchError => 'Search failed.';

  @override
  String get socialNoFriendsYet => 'No friends yet';

  @override
  String get socialNoPendingRequests => 'No pending requests';

  @override
  String get socialNoMessagesYet => 'No messages yet';

  @override
  String get socialNoMomentsYet => 'No moments yet';

  @override
  String get socialNoCommentsYet => 'No comments yet';

  @override
  String get socialNoAnnouncements => 'No announcements right now';

  @override
  String get socialSearchPrompt => 'Search by name to add a friend';

  @override
  String get socialSearchNoResults => 'No users found';

  @override
  String get socialSearchHint => 'Search friends…';

  @override
  String get socialChatAction => 'Chat';

  @override
  String get socialViewProfile => 'View profile';

  @override
  String get socialRemoveFriend => 'Remove friend';

  @override
  String get socialBlockUser => 'Block';

  @override
  String socialBlockUserConfirm(String name) {
    return 'Block $name? They will no longer be able to contact you.';
  }

  @override
  String get socialBlockUserConfirmGeneric =>
      'Block this user? They will no longer be able to contact you.';

  @override
  String get socialUserBlocked => 'User blocked';

  @override
  String get socialUserBlockedNotice => 'You have blocked this user.';

  @override
  String get socialAccept => 'Accept';

  @override
  String get socialDecline => 'Decline';

  @override
  String get socialAddFriend => 'Add friend';

  @override
  String get socialRequestSent => 'Request sent';

  @override
  String get socialReportUser => 'Report';

  @override
  String socialReportEmailSubject(String userId) {
    return 'Report user $userId';
  }

  @override
  String socialLevelLabel(int level) {
    return 'Level $level';
  }

  @override
  String get socialLevelShort => 'Level';

  @override
  String get socialStreakShort => 'Streak';

  @override
  String get socialFriendsShort => 'Friends';

  @override
  String get socialStartChatting => 'Start a conversation';

  @override
  String get socialTypeMessageHint => 'Type a message…';

  @override
  String get socialCommentsTitle => 'Comments';

  @override
  String get pinnedShortcutsTitle => '🔗 Shortcuts';

  @override
  String get pinnedShortcutConversation => 'AI Speaking';

  @override
  String get pinnedShortcutWriteSentence => 'Write a sentence (AI)';

  @override
  String get pinnedShortcutListening => 'Listening';

  @override
  String get pinnedShortcutYoutube => 'YouTube';

  @override
  String get pinnedShortcutCourse => 'Course';

  @override
  String get exploreSectionTitle => 'Explore';

  @override
  String get examCornerOverdue => '📅 Exam date has passed';

  @override
  String examCornerToday(String level) {
    return '🎯 $level exam today!';
  }

  @override
  String examCornerCountdown(String provider, String level, int days) {
    return '🎯 $provider $level · $days days left';
  }

  @override
  String get examCornerReadiness => 'Readiness';

  @override
  String get examCornerChangeGoal => 'Change goal';

  @override
  String get examCornerContinue => 'Take a test';

  @override
  String get examCornerSetNewGoal => 'Set a new goal';

  @override
  String get examGoalPromptTitle => 'Set an exam goal';

  @override
  String get examGoalPromptSubtitle =>
      'Set an exam date to track the countdown and practice at the right level.';

  @override
  String get examGoalPromptCta => 'Set exam date';

  @override
  String get examGoalSetterTitle => 'Set an exam goal';

  @override
  String get examGoalSetterProviderLabel => 'Exam provider';

  @override
  String get examGoalSetterLevelLabel => 'Target level';

  @override
  String get examGoalSetterDateLabel => 'Exam date';

  @override
  String get examGoalSetterDateRequired => 'Please choose an exam date';

  @override
  String get examGoalSetterDateInPast => 'Exam date can\'t be before today';

  @override
  String get examGoalSetterSave => 'Save goal';

  @override
  String get examGoalSetterSaving => 'Saving...';

  @override
  String get examGoalSetterSaveFailed => 'Save failed, try again later';

  @override
  String get premiumBannerCta => 'Upgrade to Premium — learn without limits';

  @override
  String get communityLinksTitle => 'Deutsch Tiger Community';

  @override
  String get communityZaloDescription => 'German learning group';

  @override
  String get communityFacebookDescription => 'Deutsch Tiger VN';
}
