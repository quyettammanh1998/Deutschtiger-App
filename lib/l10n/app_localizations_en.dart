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
  String headerWordsLearned(int count) {
    return '📚 Learned $count words';
  }

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
  String get atLeastEightCharacters => 'At least 8 characters';

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
  String get passwordTooShortEight =>
      'Your password must be at least 8 characters.';

  @override
  String get signupSubtitle => 'Create an account to start learning German';

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
  String get verifyingResetLink => 'Verifying...';

  @override
  String get resetLinkInvalid =>
      'This password reset link is invalid or has expired.';

  @override
  String get resendResetLink => 'Resend reset link';

  @override
  String checkEmailForResetLink(String email) {
    return 'Check $email to reset your password.';
  }

  @override
  String get showPasswordTooltip => 'Show password';

  @override
  String get hidePasswordTooltip => 'Hide password';

  @override
  String get newPasswordHint => 'At least 8 characters';

  @override
  String get confirmPasswordHint => 'Re-enter your new password';

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
  String get leaderboardSubtitle =>
      'Compete on weekly XP with the community and friends.';

  @override
  String get leaderboardWeeklyHeader => 'Weekly leaderboard';

  @override
  String leaderboardResetCountdown(String countdown) {
    return 'Resets $countdown';
  }

  @override
  String get leaderboardTabGlobal => 'Global';

  @override
  String get leaderboardTabFriends => 'Friends';

  @override
  String get leaderboardHallOfFameToggle => 'Last week';

  @override
  String get leaderboardNoFriends =>
      'No friends on the board yet — add friends to compete!';

  @override
  String get leaderboardFindFriends => 'Find friends →';

  @override
  String get leaderboardRankNew => 'New';

  @override
  String get leaderboardDetailTitle => 'Weekly score breakdown';

  @override
  String get leaderboardDetailComposite => 'Composite score';

  @override
  String get leaderboardDetailRawXp => 'Raw XP';

  @override
  String get leaderboardDetailXp => 'Weekly XP';

  @override
  String get leaderboardDetailExam => 'Exam points';

  @override
  String get leaderboardDetailMission => 'Missions';

  @override
  String get leaderboardDetailVocab => 'Words reviewed';

  @override
  String get leaderboardDetailStreak => 'Streak';

  @override
  String get leaderboardDetailTopContributor => 'Top contributor';

  @override
  String get leaderboardDetailDampenedNote =>
      'New accounts have a temporarily reduced rank. Complete a 3-day streak, 3 missions, or 1 exam to unlock the full rank score.';

  @override
  String get leaderboardDetailViewProfile => 'View profile';

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
  String get examLandingSubtitle => 'Choose a certificate & level';

  @override
  String get examBuddyCtaSubtitle =>
      'Connect with someone testing the same day to study together';

  @override
  String get examShortDescTelc => 'Visa, residency, citizenship';

  @override
  String get examShortDescGoethe => 'Internationally recognised certificate';

  @override
  String get examShortDescOsd => 'Austrian German certificate';

  @override
  String get examRecommendedLabel => 'Recommended';

  @override
  String examLevelMismatchTitle(String level) {
    return 'You are currently at $level';
  }

  @override
  String examLevelMismatchBody(String level) {
    return 'The $level exam may be too difficult for your current level. Continue anyway?';
  }

  @override
  String get examLevelMismatchCancel => 'Cancel';

  @override
  String get examLevelMismatchContinue => 'Continue anyway';

  @override
  String examSectionBundleCount(int count) {
    return '$count exam sets';
  }

  @override
  String get examBundleArapTitle => 'A-RAP';

  @override
  String get examBundleArapDesc =>
      'Official practice exams · Lesen · Hören · Schreiben · Sprachbausteine';

  @override
  String get examBundleSpeakingTitle => 'Speaking (Sprechen)';

  @override
  String get examBundleSpeakingDesc => 'Practice speaking by topic';

  @override
  String get examBundleComingSoon => 'Coming soon';

  @override
  String examSetCount(int count) {
    return '$count exam sets';
  }

  @override
  String examSetCompletedSuffix(int count) {
    return '$count completed';
  }

  @override
  String examSetInProgressSuffix(int count) {
    return '$count in progress';
  }

  @override
  String get examSetEmptyTitle => 'No exams yet';

  @override
  String get examSetEmptyBody =>
      'There are no exams for this certificate and level yet.';

  @override
  String get examSetPagePrev => 'Prev';

  @override
  String get examSetPageNext => 'Next';

  @override
  String examSetPageIndicator(int current, int total) {
    return 'Page $current / $total';
  }

  @override
  String examPartsCount(int count) {
    return '$count parts';
  }

  @override
  String get examPartActionTest => 'Mock exam';

  @override
  String get examPartActionPractice => 'Practice';

  @override
  String get examSkillListEmptyTitle => 'No exams yet';

  @override
  String examSkillListEmptyBody(String skill) {
    return 'There is no $skill part yet.';
  }

  @override
  String get examSkillListVocabChip => 'Vocabulary';

  @override
  String get examLocked => 'Locked';

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
  String get coursesPremiumLabel => 'Premium';

  @override
  String get coursesViewContent => 'View content';

  @override
  String get coursesUnlockArrow => 'Unlock →';

  @override
  String get coursesViewArrow => 'View →';

  @override
  String get coursesHubSubtitle =>
      'Learn German with video + interactive exercises from Deutsche Welle';

  @override
  String coursesCount(int count) {
    return '$count courses';
  }

  @override
  String coursesLessonsCountPlus(int count) {
    return '$count+ lessons';
  }

  @override
  String get coursesSearchHint => 'Search courses...';

  @override
  String get coursesCollapse => 'Collapse';

  @override
  String coursesShowMore(int count) {
    return 'Show $count more courses';
  }

  @override
  String coursesSearchResultsCount(int count, String query) {
    return '$count results for \"$query\"';
  }

  @override
  String coursesSearchNoResults(String query) {
    return 'No results for \"$query\"';
  }

  @override
  String coursesUpsellHubTitle(int count) {
    return 'Unlock all $count courses';
  }

  @override
  String coursesUpsellHubSubtitle(int limit) {
    return 'You\'re using $limit free courses. Upgrade to access all content.';
  }

  @override
  String get coursesUpsellCta => 'Upgrade';

  @override
  String coursesLevelHeading(String label) {
    return 'Level $label';
  }

  @override
  String get coursesLevelEmpty => 'No data for this level yet.';

  @override
  String coursesLessonNumberShort(String number) {
    return 'Lesson $number';
  }

  @override
  String get coursesPaginationPrev => '← Previous';

  @override
  String get coursesPaginationNext => 'Next →';

  @override
  String coursesPaginationInfo(int page, int totalPages, int start, int end) {
    return 'Page $page/$totalPages · Showing $start–$end';
  }

  @override
  String get coursesProgressTitle => 'Learning progress';

  @override
  String get coursesProgressVideosWatched => 'videos watched';

  @override
  String get coursesProgressLessonsStarted => 'lessons started';

  @override
  String coursesUpsellDetailTitle(int count) {
    return 'Unlock all $count lessons.';
  }

  @override
  String coursesUpsellDetailSubtitle(int limit) {
    return 'You\'re viewing $limit free lessons.';
  }

  @override
  String get coursesLessonNotStarted => 'Not started';

  @override
  String get coursesLessonNoVideo => 'This lesson has no video yet.';

  @override
  String get coursesLessonStripTitle => 'Lesson list';

  @override
  String get coursesTranscriptTitle => 'Transcript';

  @override
  String get coursesTranscriptCopyDe => 'Copy German';

  @override
  String get coursesTranscriptCopyVi => 'Copy Vietnamese';

  @override
  String get coursesTranscriptHideVi => 'Hide VI';

  @override
  String get coursesTranscriptShowVi => 'Show VI';

  @override
  String get coursesTranscriptEmpty => 'This lesson has no transcript yet.';

  @override
  String coursesVocabularyCount(int count) {
    return 'Vocabulary ($count)';
  }

  @override
  String get coursesVocabularyEmpty =>
      'This lesson has no vocabulary list yet.';

  @override
  String get coursesCommentsTitle => 'Comments';

  @override
  String get coursesCommentsError => 'Could not load comments.';

  @override
  String get coursesCommentsEmpty => 'No comments yet.';

  @override
  String get coursesCommentsPlaceholder => 'Write a comment...';

  @override
  String get coursesCommentsSendError => 'Could not send comment, try again.';

  @override
  String get coursesLessonVideoDone => '✓ Video completed';

  @override
  String get coursesLessonMarkVideoDone => '🎉 Mark video complete';

  @override
  String get coursesLessonWatchHint =>
      '⏱️ Watch at least 80% of the video to complete it';

  @override
  String get coursesLessonSaving => 'Saving...';

  @override
  String get coursesProgressSaveCta => 'Save progress';

  @override
  String get coursesProgressSaved => 'Progress saved';

  @override
  String get coursesProgressSaveFailed => 'Save failed';

  @override
  String coursesLessonHeading(String number, String name) {
    return 'Lesson $number: $name';
  }

  @override
  String get coursesLockedLessonTitle => 'Lesson requires Premium';

  @override
  String get coursesLockedLessonDescription =>
      'This lesson is beyond the free limit. Upgrade to unlock all content.';

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
  String get missionResumeTitle => 'Resume unfinished work';

  @override
  String get missionResumeContinueCta => 'Go to vocabulary round';

  @override
  String get missionCompleteTitle => 'Complete!';

  @override
  String get missionCompleteSubtitle =>
      'Vocabulary step done — today\'s path still has the next skill steps';

  @override
  String missionXpBadge(int xp) {
    return '+$xp XP';
  }

  @override
  String get missionClimbedTitle => 'You leveled up today:';

  @override
  String get missionStreakUpdated => '🔥 Today\'s streak has been updated!';

  @override
  String get missionNextStepCta => 'Next step →';

  @override
  String get missionMismatch => 'Session mismatch. Go home to start again.';

  @override
  String get missionAlreadyDoneToday =>
      'Today\'s vocabulary lesson is done 🎉 Go back to the path for the next step.';

  @override
  String get completed => 'Completed';

  @override
  String get more => 'More';

  @override
  String get moreFeaturesTitle => 'All features';

  @override
  String get close => 'Close';

  @override
  String get navConversation => 'Conversation';

  @override
  String get groupAccountOther => 'Account & More';

  @override
  String get featureYoutube => 'YouTube';

  @override
  String get featureReadListen => 'Read & Listen';

  @override
  String get featureListening => 'Listening';

  @override
  String get featureReadingFeed => 'Reading feed';

  @override
  String get featureNews => 'News';

  @override
  String get featureSubtitleWords => 'Subtitle words';

  @override
  String get featureFocusSession => 'Focus session';

  @override
  String get featureCasesHub => 'Practice 4 cases';

  @override
  String get featureMinimalPairs => 'Minimal pairs';

  @override
  String get featurePronunciation => 'Pronunciation';

  @override
  String get featureInterview => 'Interview';

  @override
  String get featureLearnerModel => 'Skill profile';

  @override
  String get featureExamReadiness => 'Exam readiness';

  @override
  String get featureErrorPatterns => 'Common mistakes';

  @override
  String get featureMessages => 'Messages';

  @override
  String get featureFriends => 'Friends';

  @override
  String get featureExamSchedule => 'Find a study buddy';

  @override
  String get featureDailyQuote => 'Daily quote';

  @override
  String get featureAffiliateIntro => 'Refer & earn';

  @override
  String get featurePremiumUpgrade => 'Upgrade to Premium';

  @override
  String get featureAdmin => 'Admin';

  @override
  String get featureFeedback => 'Feedback';

  @override
  String get featureLeaderboardFull => 'Leaderboard';

  @override
  String get featureAiAssistant => 'AI Assistant';

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
  String deckListSubtitleWithFolders(int decks, int folders) {
    return '$decks decks · $folders folders';
  }

  @override
  String get deckIntroWhy => 'Words you saved yourself, grouped into decks.';

  @override
  String get deckIntroTodo => 'Open a deck to review or add new words.';

  @override
  String get deckIntroNext => 'Words also join the FSRS review schedule.';

  @override
  String get deckIntroNextLabel => 'Review';

  @override
  String get deckAllDecksTitle => 'All decks';

  @override
  String get deckQuickPracticeTitle => 'Quick practice';

  @override
  String get deckQuickPracticeCta => 'Play Word Sprint with your saved words';

  @override
  String get deckStarredTitle => 'Starred';

  @override
  String get deckStarredSubtitle => 'Starred cards';

  @override
  String get deckFoldersTitle => 'Folders';

  @override
  String get deckDefaultTooltip => 'Default deck';

  @override
  String get deckSetDefaultTooltip => 'Set as default';

  @override
  String get deckDefaultBadge => 'Default';

  @override
  String get deckMoveToFolder => 'Move to folder';

  @override
  String get deckActionCreateDeck => 'Create deck';

  @override
  String get deckActionCreateDeckSubtitle => 'Add a new vocabulary set';

  @override
  String get deckActionCreateFolder => 'Create folder';

  @override
  String get deckActionCreateFolderSubtitle => 'Organize decks into groups';

  @override
  String get deckActionSpeak => 'Speak to notes';

  @override
  String get deckActionSpeakSubtitle =>
      'Speak German → save each sentence as a card';

  @override
  String get deckFolderName => 'Folder name';

  @override
  String get deckFolderNameHint => 'e.g. A1 vocabulary';

  @override
  String get deckNoFolder => 'No folder';

  @override
  String get deckNoSearchResults => 'No matching cards found.';

  @override
  String get deckSearchHint => 'Search words...';

  @override
  String get deckStarredFilterTooltip => 'Show starred only';

  @override
  String get deckAddCard => 'Add';

  @override
  String get deckCardFormRequired => 'Please fill in both the front and back.';

  @override
  String get deckCardFormSaveError =>
      'Could not save this card. Please try again.';

  @override
  String get deckEditCardTitle => 'Edit card';

  @override
  String get deckNewCardTitle => 'Add new card';

  @override
  String get deckCardFrontLabel => 'Front (German)';

  @override
  String get deckCardFrontHint => 'e.g. das Haus';

  @override
  String get deckCardBackLabel => 'Back (Vietnamese)';

  @override
  String get deckCardBackHint => 'e.g. house';

  @override
  String get deckCardExampleLabel => 'Example sentence (optional)';

  @override
  String get deckCardExampleHint => 'e.g. Das ist mein Haus.';

  @override
  String get deckCardExampleViLabel => 'Example translation (optional)';

  @override
  String get deckFolderEmpty => 'This folder has no decks yet.';

  @override
  String get deckStarredEmpty => 'No starred cards yet.';

  @override
  String get deckLessonTitle => 'Guided lesson';

  @override
  String deckLessonBatchProgress(int current, int total) {
    return 'Batch $current/$total';
  }

  @override
  String get deckBackToDeck => 'Back to deck';

  @override
  String get deckLessonBatchDoneTitle => 'Batch complete!';

  @override
  String deckLessonBatchDoneSubtitle(int correct, int total) {
    return '$correct/$total correct';
  }

  @override
  String get deckLessonFinish => 'Finish';

  @override
  String get deckLessonNextBatch => 'Next batch';

  @override
  String get deckPlayCta => 'Play';

  @override
  String get deckLearnCta => 'Learn';

  @override
  String get deckSpeakTitle => 'Speak to notes';

  @override
  String get deckSpeakHelper =>
      'Speak or type German — each sentence becomes a flashcard.';

  @override
  String get deckSpeakMicTooltip => 'Tap to start recording';

  @override
  String get deckSpeakMicComingSoon => 'Voice recording is coming soon';

  @override
  String get deckSpeakTextareaHint => 'Each line becomes one card...';

  @override
  String get deckSpeakDeckNameLabel => 'Deck name';

  @override
  String get deckSpeakDeckNameHelper =>
      'Each sentence becomes a card in this deck.';

  @override
  String deckSpeakSavedMessage(int count) {
    return 'Saved $count sentences to a new deck.';
  }

  @override
  String get deckSpeakViewDeck => 'View deck →';

  @override
  String get deckSpeakEmptyError =>
      'Enter at least one sentence before saving.';

  @override
  String get deckSpeakSaveError => 'Could not save. Please try again.';

  @override
  String get deckSpeakSaveCta => 'Save to Notes';

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
  String dailyReviewRoundLabel(int current, int total) {
    return 'Round $current/$total';
  }

  @override
  String dailyReviewRoundWordCount(int count) {
    return '$count words';
  }

  @override
  String get dailyReviewRoundStart => 'Start';

  @override
  String dailyReviewRoundDone(String gameName) {
    return '$gameName done!';
  }

  @override
  String dailyReviewRoundProgress(int reviewed, int total) {
    return 'Reviewed $reviewed/$total words';
  }

  @override
  String get dailyReviewRoundFinish => 'See results';

  @override
  String get dailyReviewRoundContinue => 'Continue';

  @override
  String get dailyReviewRetryBanner => 'Review the words you just practiced.';

  @override
  String get dailyReviewEmptyTitle => 'No words to review!';

  @override
  String get dailyReviewEmptySubtitle => 'Come back later or practice more';

  @override
  String get dailyReviewSessionLabel => 'Review session';

  @override
  String get dailyReviewStatusExcellent => 'Excellent';

  @override
  String get dailyReviewStatusGood => 'Good';

  @override
  String get dailyReviewStatusNeedsWork => 'Needs more practice';

  @override
  String get dailyReviewCompletedTitle => 'Completed!';

  @override
  String get dailyReviewWeakWordsTitle => 'Words to review again';

  @override
  String get dailyReviewCtaMore => 'Review more';

  @override
  String dailyReviewCtaRetryWeak(int count) {
    return 'Retry $count weak words';
  }

  @override
  String get dailyReviewCtaContinueLearning => 'Keep learning';

  @override
  String get dailyReviewCtaListening => '🎧 Practice listening';

  @override
  String get dailyReviewCtaAskAi => '✨ Ask AI about hard words';

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
  String get goalTechEngineering => 'Technology & engineering';

  @override
  String get goalShoppingBeauty => 'Shopping & beauty';

  @override
  String get goalFamilySocial => 'Family & relationships';

  @override
  String get goalLeisureCulture => 'Leisure & culture';

  @override
  String get goalNatureEnvironment => 'Nature & environment';

  @override
  String get vocabularyMine => 'Mine';

  @override
  String get vocabularyIntroWhy =>
      'The system\'s word bank — pick a set to learn and review.';

  @override
  String get vocabularyIntroTodo => 'Open a set to learn new cards.';

  @override
  String get vocabularyIntroNext =>
      'Learned words go into your Review schedule.';

  @override
  String get vocabularyIntroNextLabel => 'Review';

  @override
  String get vocabularyChooseGroupLabel => 'Choose a topic group';

  @override
  String vocabularyGoalTopicsCount(int count) {
    return '$count topics';
  }

  @override
  String get vocabularyTopicSectionTitle => '📚 Vocabulary topics';

  @override
  String get vocabularyTopicSectionDescription =>
      'Pick a topic group, then quickly open each sub-topic by level.';

  @override
  String get vocabularyLevelSectionTitle => '🎯 CEFR levels';

  @override
  String get vocabularyLevelSectionDescription =>
      'Enter a level and filter by topic, or tap a topic chip below.';

  @override
  String get vocabularyTipTitle => 'Learning tip';

  @override
  String get vocabularyTipNext => 'Next';

  @override
  String get wordSprintSectionTitle => '⚡ Practice by topic';

  @override
  String get wordSprintStart => 'Start';

  @override
  String get wordSprintDescription => '60 seconds · 4 answers · Combo x3';

  @override
  String get vocabularySearchHint => 'Search words...';

  @override
  String get vocabularyWeakFilter => 'Weak';

  @override
  String vocabularyMasteredCount(int done, int total) {
    return '$done/$total mastered';
  }

  @override
  String get vocabularyTabList => 'List';

  @override
  String get vocabularyTabMyWords => 'My words';

  @override
  String get vocabularyStartLesson => 'Learn new words';

  @override
  String get vocabularyNotFound => 'Word set not found';

  @override
  String get vocabularyMasteryMastered => 'Mastered';

  @override
  String get vocabularyMasteryKnown => 'Known';

  @override
  String get vocabularyMasteryLearning => 'Learning';

  @override
  String get vocabularyMasteryNew => 'New';

  @override
  String get myWordsGroupReviewing => 'In Review';

  @override
  String get myWordsGroupSaved => 'In Notebook';

  @override
  String get myWordsGroupSeen => 'Seen';

  @override
  String myWordsSourceLabel(Object source) {
    return 'source: $source';
  }

  @override
  String myWordsMoreCount(int count) {
    return '+$count more in this group';
  }

  @override
  String get myWordsEmptyTitle => 'No words in your bank yet';

  @override
  String get myWordsEmptyDescription =>
      'Look up words while reading/watching or save them to your Notebook — they\'ll show up here.';

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
  String grammarSearchInLevelHint(String level) {
    return 'Search within $level...';
  }

  @override
  String grammarSearchResultsCount(int count, String query) {
    return '$count results for “$query” — all levels';
  }

  @override
  String get grammarLeaderboardTitleAll => 'Leaderboard';

  @override
  String grammarLeaderboardTitleLevel(String level) {
    return 'Leaderboard $level';
  }

  @override
  String get grammarProgressLabel => 'Progress';

  @override
  String grammarProgressLabelLevel(String level) {
    return 'Progress $level';
  }

  @override
  String get grammarLeaderboardEmpty => 'No one has joined yet';

  @override
  String grammarYourRank(int rank, int count) {
    return 'Your rank: #$rank · $count lessons';
  }

  @override
  String grammarCompletedOfTotal(int done, int total) {
    return '$done/$total lessons completed';
  }

  @override
  String grammarReadTime(int elapsed, int minTime) {
    return '⏱ ${elapsed}s / ${minTime}s';
  }

  @override
  String get grammarScrolled80 => '📜 Scrolled 80%';

  @override
  String get grammarScrollNeeded => '📜 Scroll to 80% needed';

  @override
  String get grammarReadGateHint =>
      'The button unlocks once you scroll to 80% of the content and read for the minimum time.';

  @override
  String get grammarMarkCompleteXp => 'Mark as complete (+5 XP)';

  @override
  String get grammarMarkCompleteAgain => 'Complete again';

  @override
  String get grammarJustCompleted => '✓ Completed';

  @override
  String get grammarSaving => 'Saving...';

  @override
  String get grammarArticleSource => 'Source: deutsch.vn';

  @override
  String get grammarPracticeExercises => 'Practice exercises';

  @override
  String get grammarExerciseCorrect => '✓ Correct!';

  @override
  String grammarExerciseWrong(String answer) {
    return '✗ Wrong. Correct answer: $answer.';
  }

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
  String get statsScreenSubtitle =>
      'Track your progress, habits, and performance every day.';

  @override
  String get statsOverviewLevelNote => 'Unlocks new content';

  @override
  String get statsOverviewTotalXp => 'Total XP';

  @override
  String get statsOverviewXpNote => 'Accumulated experience points';

  @override
  String get statsOverviewStreakNote => 'Consecutive study streak';

  @override
  String get statsOverviewBestStreak => 'Best streak';

  @override
  String get statsOverviewBestStreakNote => 'Personal record';

  @override
  String get statsProgressLevelTitle => 'Level-up progress';

  @override
  String statsProgressLevelSubtitle(int level, int nextLevel) {
    return 'Level $level to $nextLevel';
  }

  @override
  String statsProgressLevelRemaining(int count) {
    return '$count XP left to level up.';
  }

  @override
  String get statsProgressDailyTitle => 'Today\'s XP goal';

  @override
  String get statsProgressDailySubtitle => 'Keep your daily study habit going';

  @override
  String get statsProgressDailyDone => 'You\'ve hit today\'s goal.';

  @override
  String statsProgressDailyRemaining(int count) {
    return '$count more XP needed to hit your goal.';
  }

  @override
  String statsXpChartWeekTotal(int total) {
    return 'Total this week: $total XP';
  }

  @override
  String statsXpChartMax(int max) {
    return 'Highest: $max XP';
  }

  @override
  String get statsOnlineTimeTitle => 'Online time — last 7 days';

  @override
  String statsOnlineTimeWeekTotal(String duration) {
    return 'Total this week: $duration';
  }

  @override
  String statsOnlineTimeToday(String duration) {
    return 'Today: $duration';
  }

  @override
  String get statsReviewCardsTitle => 'Review stats';

  @override
  String get statsReviewToday => 'Reviews today';

  @override
  String get statsReviewTodayNote => 'Reviews completed today';

  @override
  String get statsReviewWeek => 'Reviews this week';

  @override
  String get statsReviewWeekNote => 'Total over 7 days';

  @override
  String get statsReviewAccuracy => 'Accuracy';

  @override
  String get statsReviewAccuracyNote => 'Correct-answer rate';

  @override
  String get statsReviewDue => 'Due for review';

  @override
  String get statsReviewDueNote => 'Cards due for review';

  @override
  String get statsSuggestionsTitle => 'Suggestions to improve';

  @override
  String get statsSuggestionStreak => 'Start a new streak today!';

  @override
  String get statsSuggestionListening =>
      'You haven\'t practiced listening this week!';

  @override
  String get statsSuggestionReviewAll =>
      'Review all 3 skills evenly to progress faster!';

  @override
  String get statsSpacedRepetitionTitle => 'How does spaced repetition work?';

  @override
  String get statsSpacedRepetitionBody =>
      'The system uses the SM-2 algorithm to optimize your review schedule. Words you remember well appear less often, while harder words come back sooner. This saves time and improves long-term retention.';

  @override
  String get statsCefrTitle => 'Proficiency profile';

  @override
  String get statsCefrA1 => 'Beginner';

  @override
  String get statsCefrA2 => 'Pre-intermediate';

  @override
  String get statsCefrB1 => 'Intermediate';

  @override
  String get statsCefrB2 => 'Upper-intermediate';

  @override
  String get statsCefrC1 => 'Advanced';

  @override
  String get statsCefrC2 => 'Proficient';

  @override
  String statsCefrWordsLearned(int count) {
    return '$count words reviewed';
  }

  @override
  String get statsNearAchievementsTitle => 'Almost there';

  @override
  String get statsAchievementsGridTitle => 'Achievement collection';

  @override
  String get statsLeaderboardTableTitle => 'Leaderboard';

  @override
  String statsLeaderboardTop(int count) {
    return 'Top $count';
  }

  @override
  String get statsLeaderboardYou => 'You';

  @override
  String get errorPatternsSubtitle =>
      'Grammar mistake log, gathered from your writing, speaking, and exam answers.';

  @override
  String get errorPatternsIntroWhy =>
      'A summary of mistakes you make often when writing, graded by AI.';

  @override
  String get errorPatternsIntroTodo => 'Pick a mistake type and drill it.';

  @override
  String get errorPatternsIntroNext =>
      'Fix a mistake type and it will show up less often.';

  @override
  String get errorPatternsDrillWriting => 'Practice writing';

  @override
  String get errorPatternsDrillArtikel => 'Practice Der/Die/Das';

  @override
  String get errorPatternsDrillSentenceBuilder => 'Practice sentences';

  @override
  String get errorPatternsDrillWordOrder => 'Practice word order';

  @override
  String get errorPatternsDrillPreposition => 'Practice prepositions';

  @override
  String get errorPatternsDrillNoun => 'Review nouns';

  @override
  String get errorPatternsDrillSpelling => 'Practice spelling';

  @override
  String get errorPatternsDrillGrammar => 'Review grammar';

  @override
  String get errorPatternsDrillTense => 'Practice tenses';

  @override
  String get errorPatternsDrillExam => 'Take an exam';

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
  String get focusSessionSubtitle =>
      'What you should practice right now, based on your real weak spots.';

  @override
  String get focusSessionGoalDefaultCta =>
      'Set an exam goal for a more accurate path →';

  @override
  String focusSessionGoalWithDays(String level, int days) {
    return '🎯 Because you take $level in $days days';
  }

  @override
  String focusSessionGoalNoDays(String level) {
    return '🎯 Because of your $level goal';
  }

  @override
  String get focusSessionNoHistoryTitle => 'Not enough data to find weak spots';

  @override
  String get focusSessionNoHistoryBody =>
      'You have no review history yet — save a few words and do a review session so the system can find your real weak spots.';

  @override
  String get focusSessionSaveWordsCta => 'Save new words';

  @override
  String get focusSessionReviewNowCta => 'Review now';

  @override
  String get focusSessionLearnNewWordsCta => 'Learn new words';

  @override
  String get focusSessionWeaknessesFooterLink => 'See common mistakes';

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
  String get learnerModelSubtitle =>
      'Mastery, can-do items and areas to improve.';

  @override
  String get learnerModelReadinessTitle => 'Estimated exam readiness';

  @override
  String get learnerModelReadinessBasis =>
      'Based on: your recent practice-exam results.';

  @override
  String get learnerModelReadinessNoData =>
      'Not enough data yet — do a few practice exams to estimate readiness.';

  @override
  String learnerModelLevelPracticeCta(String level) {
    return 'Practice level $level →';
  }

  @override
  String get learnerModelWeeklyRecapTitle => 'This past week';

  @override
  String get learnerModelWeeklyRecapEmpty =>
      'No level-ups yet this week — practice more to level up!';

  @override
  String learnerModelWeeklyRecapStreak(int days) {
    return '🔥 $days-day production streak';
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
  String get canDoPracticeBackLink => '← Capability map';

  @override
  String get canDoPracticeBackToMap => 'Back to capability map';

  @override
  String get canDoPracticeGoConversation => 'Practice conversation';

  @override
  String get topicExploreTitle => 'Explore by topic';

  @override
  String get topicExploreSubtitle =>
      'See your priority vocabulary directions · pin ⭐ to steer your path';

  @override
  String get learnPageIntroWhy =>
      'This is where you learn vocabulary and grammar every day on your personal path.';

  @override
  String get learnPageIntroTodo =>
      'Do today\'s session, track A1→C2 progress and this week\'s missions.';

  @override
  String get learnPageIntroNext =>
      'Once today\'s session is done, come back here for the next mission.';

  @override
  String get learnPageIntroCta => 'Go to Review';

  @override
  String get levelJourneyTitle => 'A1→C2 journey';

  @override
  String get levelJourneyEmptyLevel => 'coming soon';

  @override
  String get levelJourneyDetailCta => 'Details →';

  @override
  String get capabilityMapSnapshotTitle => 'Capability map';

  @override
  String capabilityMapMasteredCount(int mastered, int total) {
    return '$mastered/$total can-do items';
  }

  @override
  String get capabilityMapViewCta => 'View map →';

  @override
  String get topicExploreEmpty => 'No topics yet.';

  @override
  String get topicExploreSubtitleHeader =>
      'Pick a topic to practice vocabulary in the direction you need.';

  @override
  String get topicSteeringTitle => 'Currently prioritized path';

  @override
  String get topicSteeringGoalGoethe => '🎓 Goethe exam';

  @override
  String get topicSteeringGoalConversation => '💬 Conversation';

  @override
  String get topicSteeringGoalNursing => '🏥 Nursing';

  @override
  String get topicSteeringGoalAbroad => '✈️ Study/work abroad';

  @override
  String get topicSteeringEmpty =>
      'No goal picked yet — pin a topic below to steer your path.';

  @override
  String get topicSteeringFooterHint =>
      'Pinned ⭐ topics are prioritized in your daily session.';

  @override
  String topicGroupSubtitle(String label, int count) {
    return '$label · $count topics';
  }

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
  String get practiceListeningPrompt =>
      'Tap the card to flip and reveal the meaning';

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
  String get practiceChangeMode => 'Change mode';

  @override
  String get practiceBackToGames => 'Back to games';

  @override
  String get practiceNotEnoughWords =>
      'Not enough words to practice right now.';

  @override
  String get practiceListenPill => 'Listen';

  @override
  String get practiceHintPill => 'Hint';

  @override
  String practiceHintLetter(String letter) {
    return 'Starts with \"$letter\"';
  }

  @override
  String get practiceRetryAnswer => 'Try again';

  @override
  String get practiceMicTooltip => 'Speak to answer';

  @override
  String get practiceListeningNotYet => 'Not yet';

  @override
  String get practiceListeningKnown => 'I knew it';

  @override
  String get practiceListeningTapToFlip => '👆 Tap to flip';

  @override
  String get practiceListeningMeaningLabel => 'Meaning';

  @override
  String get practiceMatchingColumnDe => 'GERMAN';

  @override
  String get practiceMatchingColumnVi => 'VIETNAMESE';

  @override
  String get subtitleWordsTitle => 'Words seen in videos';

  @override
  String get subtitleWordsSubtitle =>
      'Words you\'ve encountered while watching videos — add to review with one tap.';

  @override
  String get subtitleWordsEmpty => 'No subtitle words to add yet.';

  @override
  String get subtitleWordsEmptyHint =>
      'Watch German videos and tap words to save them here!';

  @override
  String subtitleWordsSeenCount(int count) {
    return 'seen ${count}x';
  }

  @override
  String get subtitleWordsLevelAll => 'All';

  @override
  String subtitleWordsLevelCount(String level, int count) {
    return '$level · $count';
  }

  @override
  String subtitleWordsSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String subtitleWordsCountLabel(int count) {
    return '$count words';
  }

  @override
  String get subtitleWordsSelectAll => 'Select all';

  @override
  String get subtitleWordsClearSelection => 'Clear';

  @override
  String subtitleWordsAddSelected(int count) {
    return 'Add $count words to review';
  }

  @override
  String get subtitleWordsAdding => 'Adding...';

  @override
  String subtitleWordsAddedCount(int count) {
    return 'Added $count words!';
  }

  @override
  String get subtitleWordsAddFailed =>
      'Could not save the selected words. Please try again.';

  @override
  String get practiceModeComingSoon => 'Coming soon';

  @override
  String get practiceModeSentence => 'Write sentences';

  @override
  String get practiceModeSentenceDesc => 'Listen + translate a full sentence';

  @override
  String get practiceModeClozeDesc => 'Fill in the missing word';

  @override
  String get practiceModeListeningDesc => 'Listen and flip the card to guess';

  @override
  String get practiceModeMatchingDesc => 'Match German words to their meaning';

  @override
  String get practiceModeWritingDesc =>
      'Listen + see meaning → type the German word';

  @override
  String get practiceModeRunner => 'Deutsch Runner';

  @override
  String get practiceModeRunnerDesc => 'Play a vocabulary game';

  @override
  String get practiceModeFade => 'Fade out';

  @override
  String get practiceModeFadeDesc => 'Text fades — retype the whole sentence';

  @override
  String get practiceModeDictation => 'Dictation';

  @override
  String get practiceModeDictationDesc =>
      'Listen to a sentence and type it word by word';

  @override
  String get practiceModeChaining => 'Sentence chaining';

  @override
  String get practiceModeChainingDesc =>
      'Remember the order: this sentence → the next';

  @override
  String get practiceModeGist => 'Write from meaning';

  @override
  String get practiceModeGistDesc =>
      'See the meaning + hint → rewrite the sentence';

  @override
  String get practiceModeSpeaking => 'Speaking';

  @override
  String get practiceModeSpeakingDesc => 'Read the sentence aloud, get scored';

  @override
  String get practiceIncludeGraduated => 'Include mastered words';

  @override
  String practiceCardsReady(int count) {
    return '$count cards ready';
  }

  @override
  String practiceXpEarned(int xp) {
    return '+$xp XP';
  }

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
  String socialRemoveFriendConfirm(String name) {
    return 'Remove $name from your friends list?';
  }

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
  String get socialOnlineNow => 'Online now';

  @override
  String socialJoinedOn(String date) {
    return 'Joined $date';
  }

  @override
  String get socialLongestStreakShort => 'Best';

  @override
  String get socialLearningJourneyTitle => 'Learning journey';

  @override
  String get socialWeeklyRankLabel => 'Weekly rank';

  @override
  String get socialWordsLearnedLabel => 'Words learned';

  @override
  String get socialTotalReviewsLabel => 'Reviews';

  @override
  String get socialAchievementsTitle => 'Achievements';

  @override
  String get socialActivityTimelineTitle => 'Recent activity';

  @override
  String get achievementFirstPracticeName => 'First step';

  @override
  String get achievementFirstPracticeDesc => 'Complete your first exercise';

  @override
  String get achievementStreak3Name => '3-day streak';

  @override
  String get achievementStreak3Desc => 'Keep a 3-day streak';

  @override
  String get achievementStreak7Name => 'Perfect week';

  @override
  String get achievementStreak7Desc => 'Keep a 7-day streak';

  @override
  String get achievementStreak30Name => 'Month of discipline';

  @override
  String get achievementStreak30Desc => 'Keep a 30-day streak';

  @override
  String get achievementCards10Name => '10 words';

  @override
  String get achievementCards10Desc => 'Create 10 flashcards';

  @override
  String get achievementCards50Name => '50 words';

  @override
  String get achievementCards50Desc => 'Create 50 flashcards';

  @override
  String get achievementCards100Name => '100 words';

  @override
  String get achievementCards100Desc => 'Create 100 flashcards';

  @override
  String get achievementXp500Name => 'Grind 500 XP';

  @override
  String get achievementXp500Desc => 'Reach 500 total XP';

  @override
  String get achievementXp1000Name => 'Thousand XP';

  @override
  String get achievementXp1000Desc => 'Reach 1000 total XP';

  @override
  String get achievementXp5000Name => 'Master';

  @override
  String get achievementXp5000Desc => 'Reach 5000 total XP';

  @override
  String get achievementLevel5Name => 'Level 5';

  @override
  String get achievementLevel5Desc => 'Reach Level 5';

  @override
  String get achievementLevel10Name => 'Level 10';

  @override
  String get achievementLevel10Desc => 'Reach Level 10';

  @override
  String get achievementReviews100Name => '100 reviews';

  @override
  String get achievementReviews100Desc => 'Complete 100 reviews';

  @override
  String activityLevelUp(String level) {
    return 'Reached Level $level';
  }

  @override
  String activityStreakMilestone(String streak) {
    return '$streak-day streak';
  }

  @override
  String get activityAchievementUnlockedFallback => 'New achievement';

  @override
  String get activityMissionFallback => 'Mission';

  @override
  String get activityExamFallback => 'Exam';

  @override
  String activityDailyReview(String correct, String total) {
    return 'Reviewed $correct/$total words';
  }

  @override
  String activityVocabLearned(String count) {
    return 'Learned $count new words';
  }

  @override
  String get activityVideoFallback => 'Video';

  @override
  String socialFriendsSubtitle(int friends, int requests) {
    return '$friends friends · $requests requests';
  }

  @override
  String socialOnlineSectionTitle(int count) {
    return 'Online — $count';
  }

  @override
  String socialOfflineSectionTitle(int count) {
    return 'Offline — $count';
  }

  @override
  String socialLevelStreakLabel(int level, int streak) {
    return 'Lv.$level · $streak-day streak';
  }

  @override
  String get socialSuggestionsTitle => 'Suggested friends';

  @override
  String socialConversationsCount(int count) {
    return '$count conversations';
  }

  @override
  String get socialYouPrefix => 'You';

  @override
  String get socialOffline => 'Offline';

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
  String examHeroTitle(String provider, String level) {
    return '🎯 Prep for $provider $level';
  }

  @override
  String get examHeroToday => 'Exam today!';

  @override
  String examCornerDaysLeft(int days) {
    return '$days days left';
  }

  @override
  String get examHeroNoAttemptsYet =>
      'Take a practice exam to measure readiness';

  @override
  String examHeroBasedOnAttempts(int count) {
    return 'Based on $count exams taken';
  }

  @override
  String examHeroCta(String provider, String level) {
    return '📝 Take $provider $level exam';
  }

  @override
  String get examHeroReadyLabel => 'ready';

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

  @override
  String get examReadinessGoalHeaderLabel => 'Practicing for';

  @override
  String get examReadinessGoalDaysLeft => 'days until the exam';

  @override
  String get examReadinessGoalTodayLabel => 'Today is exam day!';

  @override
  String get examReadinessGoalSetDate => 'Set exam date';

  @override
  String get examReadinessScoreTrendLabel => 'Score trend';

  @override
  String examReadinessScoreTrendDelta(String delta) {
    return '$delta pts';
  }

  @override
  String examReadinessScoreTrendRecentCount(int n) {
    return '$n most recent';
  }

  @override
  String get examReadinessScoreTrendLatestPrefix => 'Latest: ';

  @override
  String get examReadinessRecentAvgLabel => 'Recent avg. score';

  @override
  String examReadinessSkillPracticeCta(String skill) {
    return 'Practice $skill';
  }

  @override
  String examReadinessAttemptCountSuffix(int n) {
    return '$n attempts';
  }

  @override
  String get examReadinessWeaknessPracticeCta => 'Practice weak points →';

  @override
  String get examReadinessWeaknessDrillCta => 'Practice →';

  @override
  String get examReadinessTodoTitle => 'To do';

  @override
  String get examReadinessTodoDueReviewsPrefix => 'You have ';

  @override
  String examReadinessTodoDueReviewsBold(int n) {
    return '$n words due for review';
  }

  @override
  String get examReadinessIntroWhy =>
      'See how ready you are for the exam, skill by skill.';

  @override
  String get examReadinessIntroTodo =>
      'Check your weakest skill and practice it now.';

  @override
  String get examReadinessIntroNext =>
      'Come back after practicing to see your score improve.';

  @override
  String scheduleBuddyCountFire(int n) {
    return '🔥 $n buddies still have an upcoming exam';
  }

  @override
  String scheduleBuddyCountSoon(int n) {
    return '· $n exam within 30 days';
  }

  @override
  String scheduleBuddyCountPast(int n) {
    return '· $n already took it';
  }

  @override
  String get scheduleSearchHint => 'Search by name / exam type...';

  @override
  String get scheduleFilterAllExamTypes => 'All exam types';

  @override
  String get scheduleFilterAllLevels => 'All levels';

  @override
  String scheduleStatusUpcomingCount(int n) {
    return 'Upcoming ($n)';
  }

  @override
  String scheduleStatusPastCount(int n) {
    return 'Past ($n)';
  }

  @override
  String scheduleResultCountUpcoming(int n) {
    return '$n people · soonest first';
  }

  @override
  String scheduleResultCountPast(int n) {
    return '$n people · most recent first';
  }

  @override
  String get scheduleEmptyUpcoming => 'No one matches these filters yet.';

  @override
  String get scheduleEmptyPast =>
      'No one who took the exam matches these filters.';

  @override
  String scheduleMyPlansCount(int n) {
    return '$n plans · soonest first';
  }

  @override
  String get scheduleMyPlansEmpty => 'You haven\'t registered an exam plan yet';

  @override
  String get schedulePrivacyNotePrefix =>
      '🔒 Your contact info (phone, email, Facebook) ';

  @override
  String get schedulePrivacyNoteBold => 'is hidden by default';

  @override
  String get schedulePrivacyNoteSuffix =>
      ' — only registered members can see it.';

  @override
  String scheduleBuddyDaysAgo(int n) {
    return 'Took it $n days ago';
  }

  @override
  String get scheduleBuddyToday => 'Exam today!';

  @override
  String scheduleBuddyDaysLeft(int n) {
    return '$n days left';
  }

  @override
  String get dictationActivityMenuPrompt => 'Choose a listening activity:';

  @override
  String get dictationActivityClozeTitle => 'Fill in the blank';

  @override
  String get dictationActivityClozeDesc => 'Listen and type the missing word';

  @override
  String get dictationActivityFullTitle => 'Full sentence dictation';

  @override
  String get dictationActivityFullDesc =>
      'Listen to each sentence and type it back';

  @override
  String get dictationActivityKaraokeTitle => 'Listen & follow along';

  @override
  String get dictationActivityKaraokeDesc =>
      'Subtitles follow the audio, tap a word to look it up';

  @override
  String dictationWordsCount(int n) {
    return '$n words';
  }

  @override
  String get dictationWordSelectHint =>
      'Tap the underlined words to select them for practice, then press Start.';

  @override
  String get dictationWordSelectCtaEmpty => 'Select at least 1 word to start';

  @override
  String dictationWordSelectCta(int n) {
    return 'Start practice — $n words';
  }

  @override
  String get dictationBackToSelection => '← Select again';

  @override
  String dictationWordCount(int answered, int total) {
    return '$answered / $total words';
  }

  @override
  String get dictationTypeWordHint => 'Type the word...';

  @override
  String get dictationPlayingAudioHint => 'Playing audio...';

  @override
  String get dictationCheckCta => 'Check';

  @override
  String get dictationReplaySentenceTooltip => 'Replay sentence';

  @override
  String get dictationClozeSkip => 'Skip';

  @override
  String get dictationClozeReveal => 'Show answer';

  @override
  String get dictationNoWordsToPractice => 'No words to practice.';

  @override
  String get dictationBackToWordSelection => '← Back to word selection';

  @override
  String get dictationClozeResultTitle => 'Practice result';

  @override
  String get dictationClozeBackLabel => 'Choose other words';

  @override
  String get dictationClozeMistakesTitle => 'Words to review';

  @override
  String get dictationEndRetry => 'Practice again';

  @override
  String dictationEndCorrectCount(int correct, int total) {
    return '$correct / $total correct';
  }

  @override
  String get dictationFullBackLabel => 'Choose clip';

  @override
  String get dictationFullResultTitle => 'Dictation result';

  @override
  String get dictationFullNextClip => 'Next clip →';

  @override
  String get dictationReplayThisSentence => 'Replay this sentence';

  @override
  String get dictationTypeSentenceHint => 'Type what you heard...';

  @override
  String dictationSentenceProgress(int idx, int count) {
    return '$idx / $count sentences';
  }

  @override
  String dictationCorrectCount(int n) {
    return '$n correct';
  }

  @override
  String get dictationNextSentence => 'Next sentence →';

  @override
  String get dictationShowResult => 'Show result';

  @override
  String get dictationNoAudioData => 'This clip has no dictation data yet.';

  @override
  String get dictationBackPlain => '← Back';

  @override
  String get dictationKaraokeBackToMenu => '← Choose activity';

  @override
  String get dictationKaraokeHint =>
      'Press ▶ to listen — subtitles follow the audio. Tap a sentence to replay it.';

  @override
  String get dictationKaraokeUntimed => '(no synced subtitles)';

  @override
  String get dictationKaraokePrev => '◀ Previous';

  @override
  String get dictationKaraokeNext => 'Next ▶';

  @override
  String get deThiHeroTitle => 'German exam papers';

  @override
  String get deThiHeroSubtitle =>
      'Practice bilingual German–Vietnamese reading tests. Free, instant scoring, no login needed.';

  @override
  String get deThiStartCta => 'Start now →';

  @override
  String get deThiLoginCta => 'Log in';

  @override
  String get deThiPromoTitle => 'Learn German more completely';

  @override
  String get deThiPromoSubtitle => 'Flashcards · AI speaking · B1/B2 exams';

  @override
  String get deThiPromoCta => 'Try now →';

  @override
  String deThiPassageLabel(int index) {
    return 'PASSAGE $index';
  }

  @override
  String deThiPassageOf(int index) {
    return 'Passage $index';
  }

  @override
  String deThiPassageAnsweredCount(int answered, int total) {
    return '$answered/$total questions';
  }

  @override
  String get deThiTranslatePassage => 'Translate passage';

  @override
  String get deThiHideTranslation => 'Hide translation';

  @override
  String get deThiTranslateVi => 'Translate to Vietnamese';

  @override
  String get deThiHideExplanation => 'Hide explanation';

  @override
  String get deThiExplanation => 'Explanation';

  @override
  String get deThiVietnameseTranslationHeading => 'VIETNAMESE TRANSLATION';

  @override
  String get deThiPrevPassage => 'Previous passage';

  @override
  String get deThiNextPassage => 'Next passage';

  @override
  String deThiCorrectCountLabel(int correct, int total) {
    return '$correct/$total correct';
  }

  @override
  String deThiScoreLabel(String score) {
    return '$score points';
  }

  @override
  String get communityTabBrowse => 'Browse';

  @override
  String get communityTabContribute => 'Contribute';

  @override
  String get communityTabMine => 'My topics';

  @override
  String get communityContributeComingSoon =>
      'Contributing topics is coming soon.\nCheck back later!';

  @override
  String get communityMineEmptyGated =>
      'You haven\'t contributed any topics yet — coming soon.';

  @override
  String get communitySearchHint => 'Search topics...';

  @override
  String get communityFilterAll => 'All';

  @override
  String get communityFilterGoetheWriting => 'Goethe Writing';

  @override
  String get communityFilterTelcSpeaking => 'Telc Speaking';

  @override
  String communityTeilLabel(int n) {
    return 'Teil $n';
  }

  @override
  String get communityBackLink => 'Back';

  @override
  String get communityBadgeLabel => 'Community';

  @override
  String get communityHiddenBanner =>
      '⚠️ This topic was hidden due to multiple reports.';

  @override
  String get communityRealExamBadge => 'Real exam';

  @override
  String get communityTakeExamAction => 'I just took this exam';

  @override
  String get communityReportAction => 'Report';

  @override
  String get communityGatedTooltip => 'Feature coming soon';

  @override
  String get communityAnonymousContributor => 'Anonymous';

  @override
  String get communitySectionTask => '📝 Task';

  @override
  String get communitySectionAnalysis => '📋 Task analysis';

  @override
  String get communitySectionModelAnswer => '✍️ Model answer';

  @override
  String get communitySectionUsefulPhrases => '💡 Useful phrases';

  @override
  String get communitySectionGrammar => '📖 Grammar focus';

  @override
  String get communitySectionMistakes => '⚠️ Common mistakes';

  @override
  String get communitySectionSpeakingContent => '🎙️ Content';

  @override
  String get examHeaderDefaultTitle => 'Exam part';

  @override
  String get examBackToResult => 'Result';

  @override
  String get examPaceOnTrack => 'On track';

  @override
  String get examPaceSlow => 'A bit slow';

  @override
  String get examPaceBehind => 'Speed up';

  @override
  String get examReaderGuideTooltip => 'Reading guide';

  @override
  String get examReaderGuideTitle => 'Reading tips';

  @override
  String get examReaderGuideBody =>
      'Enable word lookup to tap any word for its meaning. Enable highlighting to mark tricky words. Adjust font size in Display settings.';

  @override
  String get examReaderGuideEnableWordLookup => 'Enable word lookup';

  @override
  String get examReaderSettingsTooltip => 'Display settings';

  @override
  String get examReaderSettingsTitle => 'Display settings';

  @override
  String get examReaderSettingsFontSize => 'Font size';

  @override
  String get examReaderSettingsHighlight => 'Word highlight';

  @override
  String get examReaderSettingsWordLookup => 'Tap to look up';

  @override
  String get examReadingPaneTitle => 'Passage';

  @override
  String get examTranslateParagraph => 'Translate passage';

  @override
  String get examHideTranslation => 'Hide translation';

  @override
  String get examNavPrevQuestion => 'Previous question';

  @override
  String get examNavNextQuestion => 'Next question';

  @override
  String get examNavOpenSheet => 'Question grid';

  @override
  String get examNavSheetTitle => 'Question list';

  @override
  String get examNavSheetPracticeTitle => 'Practice';

  @override
  String get examNavLegendCurrent => 'Viewing';

  @override
  String get examNavLegendAnswered => 'Answered';

  @override
  String get examNavLegendWrong => 'Wrong';

  @override
  String get examNavLegendUnanswered => 'Unanswered';

  @override
  String examNavStatCorrect(int count) {
    return '$count Correct';
  }

  @override
  String examNavStatWrong(int count) {
    return '$count Wrong';
  }

  @override
  String examNavStatUnanswered(int count) {
    return '$count Unanswered';
  }

  @override
  String get examCommentsTitle => 'Comments';

  @override
  String get examCommentsEmpty => 'No comments yet.';

  @override
  String get examCommentsPlaceholder => 'Write a comment...';

  @override
  String get examCommentsSend => 'Send';

  @override
  String get examCommentsError => 'Could not load comments.';

  @override
  String get examCommentsSendError =>
      'Could not send comment. Please try again.';

  @override
  String get examResultHeaderFallback => 'Exam result';

  @override
  String get examResultScoreLabel => 'Score';

  @override
  String get examResultMotivationPassedTitle => 'Passed!';

  @override
  String get examResultMotivationPassedBody =>
      'Great job! You cleared the pass threshold!';

  @override
  String get examResultMotivationFailTitle => 'Keep going!';

  @override
  String get examResultMotivationFailBody =>
      'Not quite there — review your mistakes and try again!';

  @override
  String get examResultStatSkipped => 'Skipped';

  @override
  String get examSmartReviewTitle => 'Post-exam review suggestions';

  @override
  String get examSmartReviewSubtitle =>
      'Focus on wrong answers and weak sections.';

  @override
  String examSmartReviewPointsNeeded(int count) {
    return '$count points to review';
  }

  @override
  String get examSmartReviewJumpToWrong => 'View wrong answers';

  @override
  String get examSmartReviewPracticeSections => 'Practice by section';

  @override
  String get examSmartReviewWrongReview => 'Review my mistakes';

  @override
  String get examAttemptHistoryTitle => 'Attempt history';

  @override
  String get examAttemptHistoryEmpty => 'No attempts yet';

  @override
  String get examAttemptModePractice => 'Practice';

  @override
  String get writingMyEssaysLink => 'My essays →';

  @override
  String get writingHistoryTooltip => 'Writing history';

  @override
  String get writingYourEssay => 'Your essay';

  @override
  String get writingDraftSaved => '💾 Draft saved';

  @override
  String get writingSubmittedBadge => 'Submitted';

  @override
  String writingWordCount(int count) {
    return '$count words';
  }

  @override
  String writingRestorePromptSaved(String time, int count) {
    return 'A draft saved at $time ($count words) is available. Restore it?';
  }

  @override
  String get writingRestore => 'Restore';

  @override
  String get writingDiscard => 'Discard';

  @override
  String get writingEditorPlaceholder =>
      'Schreiben Sie hier Ihre Antwort... (Write your answer here)';

  @override
  String get writingSubmitCta => 'Submit essay';

  @override
  String get writingSubmitting => 'Submitting...';

  @override
  String get writingRegrade => 'Re-grade with AI';

  @override
  String get writingGrading => 'Grading...';

  @override
  String get writingMinWordsHint => 'Minimum 10 words';

  @override
  String get writingEditEssay => 'Edit essay';

  @override
  String get writingGradeWithAi => 'Grade with AI';

  @override
  String get writingRetry => 'Retry';

  @override
  String writingRetryIn(int seconds) {
    return 'Retry in ${seconds}s';
  }

  @override
  String get writingClose => 'Close';

  @override
  String get writingFeedbackUpdateHint =>
      'AI feedback — re-grade to refresh the result';

  @override
  String get writingRewriteTitle => 'Rewrite from feedback';

  @override
  String get writingRewriteDesc =>
      'Generate a model rewrite to compare, then load it into the editor if you want to keep refining it.';

  @override
  String get writingCreateRewrite => 'Generate rewrite';

  @override
  String get writingRecreateRewrite => 'Regenerate rewrite';

  @override
  String get writingCreatingRewrite => 'Generating...';

  @override
  String get writingUseRewrite => 'Load into editor';

  @override
  String get writingBeforeFix => 'Before';

  @override
  String get writingAfterFix => 'After';

  @override
  String get writingGradeCategoryTask => 'Task completion';

  @override
  String get writingGradeCategoryGrammar => 'Grammar';

  @override
  String get writingGradeCategoryVocab => 'Vocabulary';

  @override
  String get writingGradeCategoryCoherence => 'Coherence & cohesion';

  @override
  String get writingCommonErrorsTitle => 'Common errors in this essay';

  @override
  String get writingDetailedAssessment => 'Detailed assessment';

  @override
  String writingSuggestionsTitle(int count) {
    return '💡 Suggestions for more natural writing ($count)';
  }

  @override
  String writingCorrectionsTitle(int count) {
    return 'Corrections ($count)';
  }

  @override
  String writingFocusLink(int count) {
    return '🔁 Fix these grammar errors in Focus ($count errors)';
  }

  @override
  String writingGoetheBreakdownTitle(String teilLabel) {
    return 'Goethe assessment — $teilLabel';
  }

  @override
  String get writingGoetheInhalt => 'Inhalt (Content)';

  @override
  String get writingGoetheKommunikative => 'Kommunikative (Communication)';

  @override
  String get writingGoetheFormale => 'Formale (Form)';

  @override
  String get writingHistoryTitle => 'Writing history';

  @override
  String get writingHistoryEmpty => 'No essays yet';

  @override
  String writingScorePoints(int score) {
    return '$score/100';
  }

  @override
  String get goetheB1HubTitle => 'Goethe-Zertifikat B1';

  @override
  String get goetheB1HubSubtitle => '3 exam practice sets';

  @override
  String get goetheB1HubOfficialTitle => 'Official exam sets';

  @override
  String get goetheB1HubOfficialDesc =>
      '30+ full practice exams · Lesen · Hören · Schreiben';

  @override
  String get goetheB1HubWritingTitle => 'Real writing exam bank';

  @override
  String get goetheB1HubWritingDesc =>
      '30 Schreiben topics · Teil 1 · Teil 2 · Teil 3';

  @override
  String get goetheB1HubSpeakingTitle => 'Speaking (Sprechen)';

  @override
  String get goetheB1HubSpeakingDesc =>
      'Speaking topics · Teil 1 · Teil 2 · Teil 3';

  @override
  String get goetheB1WritingEyebrow => 'Goethe B1 · 3 parts · 100 Punkte';

  @override
  String get goetheB1WritingHeadingPrefix => 'Writing — ';

  @override
  String get goetheB1WritingHeadingSchreiben => 'Schreiben';

  @override
  String get goetheB1WritingBadgeReal => 'Real exam papers';

  @override
  String get goetheB1WritingBadgeYears => '2023–2026';

  @override
  String get goetheB1WritingBadgeQuality => 'Quality model answers';

  @override
  String get goetheB1WritingHeroPitch =>
      'Practice the exact Goethe B1 format with authentic exam topics so you walk into the exam room confident.';

  @override
  String get goetheB1WritingHeroDesc =>
      'Schreiben covers 3 Teil that mirror the Goethe B1 exam structure, curated from real exam papers from 2023–2026 plus new community-contributed topics added regularly. Every topic gives you a sample task, sentence structures to review, ideas to develop and step-by-step writing practice with trustworthy model answers.';

  @override
  String get goetheB1WritingStatSourceLabel => 'Practice source';

  @override
  String get goetheB1WritingStatSourceValue => 'Real Goethe exam papers';

  @override
  String get goetheB1WritingStatTopicsLabel => 'Topics available';

  @override
  String goetheB1WritingStatTopicsValue(int count) {
    return '$count+ topics';
  }

  @override
  String get goetheB1WritingStatValueLabel => 'Practice value';

  @override
  String get goetheB1WritingStatValueValue => 'Model answers + step-by-step';

  @override
  String get goetheB1WritingLoadingTopics => 'Loading...';

  @override
  String get goetheB1WritingAllExamsLink => '← All writing exams';

  @override
  String get goetheB1WritingMyEssaysLink => 'My essays →';

  @override
  String goetheB1WritingTeilLabel(int n) {
    return 'Teil $n';
  }

  @override
  String goetheB1WritingPoints(int points) {
    return '$points Punkte';
  }

  @override
  String get goetheB1WritingTeil1Subtitle =>
      'Write a personal letter/email to a friend';

  @override
  String get goetheB1WritingTeil2Subtitle => 'Share an opinion in a forum post';

  @override
  String get goetheB1WritingTeil3Subtitle =>
      'Formal email: apology, appointment, registration';

  @override
  String get conversationHubTitle => 'AI Conversation';

  @override
  String get conversationHubSubtitle =>
      'Everyday German · Explore & practice speaking';

  @override
  String get conversationHubLoadError => 'Couldn\'t load the scenario list.';

  @override
  String get conversationTabScenarios => 'Scenarios';

  @override
  String get conversationTabHistory => 'Practice history';

  @override
  String get conversationHeroBadge => 'AI creates a conversation instantly';

  @override
  String get conversationHeroTitle =>
      'What do you want to practice speaking about today?';

  @override
  String get conversationHeroSearchHint =>
      'Type any topic or search existing ones…';

  @override
  String get conversationHeroCreateNow => 'Create now';

  @override
  String get conversationHeroUpgrade => 'Upgrade to Plus ✨';

  @override
  String get conversationHeroTryNow => 'Try now:';

  @override
  String conversationQuotaFreeRemaining(int remaining, int max) {
    return '$remaining/$max free conversations left today';
  }

  @override
  String conversationQuotaWalled(int max) {
    return 'You\'ve used all $max/$max free conversations today';
  }

  @override
  String get conversationQuotaUnlimited => 'Unlimited';

  @override
  String get conversationFilterLibraryTitle => 'Or pick from the library';

  @override
  String conversationFilterResultCount(int count) {
    return '$count topics';
  }

  @override
  String get conversationFilterClear => 'Clear filters';

  @override
  String get conversationFilterCategory => 'Category';

  @override
  String get conversationFilterLevel => 'Level';

  @override
  String get conversationFilterAll => 'All';

  @override
  String conversationCreateCustomTitle(String topic) {
    return 'Create custom topic: “$topic”';
  }

  @override
  String get conversationCreateCustomHint =>
      'Not available — let AI draft a new conversation for you';

  @override
  String get conversationEmptyNoResults => 'No topics found';

  @override
  String get conversationEmptyNoResultsHint =>
      'Try typing your own topic above!';

  @override
  String get conversationHistoryLoadError => 'Couldn\'t load practice history.';

  @override
  String get conversationHistoryEmpty => 'No saved practice sessions yet.';

  @override
  String get conversationHistoryEmptyHint =>
      'Finish a conversation to save it here.';

  @override
  String conversationHistoryMeta(String level, int turns, String date) {
    return '$level · $turns turns · $date';
  }

  @override
  String get conversationHistoryDelete => 'Delete';

  @override
  String get conversationHistoryCancel => 'Cancel';

  @override
  String get conversationHistoryDetailLoadError =>
      'Couldn\'t load the saved conversation.';

  @override
  String get conversationHistoryBackToList => 'Back to list';

  @override
  String get conversationLoadError =>
      'Couldn\'t load the scenario. Please try again.';

  @override
  String get conversationBack => 'Back';

  @override
  String get conversationContextLabel => 'Situation';

  @override
  String get conversationYourRoleLabel => 'Your role:';

  @override
  String get conversationListen => 'Listen';

  @override
  String get conversationExaminerButton => 'Examiner';

  @override
  String get conversationExaminerTitle => '⚖️ AI Examiner';

  @override
  String get conversationExaminerCoverageTitle => 'Content to cover';

  @override
  String get conversationExaminerVerdictPending =>
      'Overall assessment is coming soon.';

  @override
  String get conversationExaminerNoVerdict =>
      'No assessment for this session yet.';

  @override
  String get conversationExit => 'Exit';

  @override
  String get conversationExitConfirmTitle => 'Exit the conversation?';

  @override
  String get conversationExitConfirmBody =>
      'Your current progress won\'t be saved.';

  @override
  String get conversationExitConfirmCta => 'Exit';

  @override
  String get conversationExitCancelCta => 'Continue';

  @override
  String get conversationComposerHint => 'Type or speak German...';

  @override
  String get conversationComposerModeText => 'Type';

  @override
  String get conversationComposerModeVoice => 'Mic';

  @override
  String get conversationSuggestionsTitle => 'Suggestions';

  @override
  String get conversationSuggestionsPending =>
      'Answer suggestions are coming soon.';

  @override
  String get conversationVoiceTapToSpeak => 'Tap to speak';

  @override
  String get conversationVoiceComingSoon => 'Voice input is coming soon.';

  @override
  String get conversationVoiceBackToText => 'Back to typing';

  @override
  String get conversationDoneTitle => 'Conversation complete!';

  @override
  String conversationDoneSubtitle(String title, int turns) {
    return '$title · $turns conversation turns';
  }

  @override
  String get conversationDoneRestart => 'Practice again';

  @override
  String get conversationDoneChooseAnother => 'Choose another scenario';

  @override
  String get interviewImportTitle => 'Practice interviews from a document';

  @override
  String get interviewImportDesc =>
      'Paste your prep doc → AI builds the interview; your answers become hints.';

  @override
  String get interviewImportBackToEdit => 'Edit document';

  @override
  String get interviewImportDocLabel => 'Interview document';

  @override
  String get interviewImportDocHint =>
      'Paste the questions + answers you prepared...';

  @override
  String get interviewImportLevelLabel => 'Level (CEFR)';

  @override
  String get interviewImportExtract => '✨ Extract questions';

  @override
  String get interviewImportExtracting => 'Extracting...';

  @override
  String get interviewImportTitleLabel => 'Interview name';

  @override
  String get interviewImportEditHint =>
      'Review & edit questions and hints before saving. Hints are visible to you only, not the AI.';

  @override
  String interviewImportQuestionLabel(int n) {
    return 'Question $n';
  }

  @override
  String get interviewImportQuestionDeHint => 'Interview question (German)';

  @override
  String get interviewImportQuestionViHint => 'Translation (Vietnamese)';

  @override
  String get interviewImportHintDeHint =>
      'Hint — your prepared answer (German)';

  @override
  String get interviewImportHintViHint => 'Hint (Vietnamese)';

  @override
  String get interviewImportAddQuestion => '+ Add question';

  @override
  String get interviewImportSave => 'Save & start practicing';

  @override
  String get interviewImportSaving => 'Saving...';

  @override
  String get pronunciationHubTitle => 'German Pronunciation Practice';

  @override
  String get pronunciationHubInfoBanner =>
      'Correct pronunciation from the start builds confidence and avoids misunderstandings. Each module focuses on one tricky sound group — practice step by step, listen and imitate.';

  @override
  String get pronunciationHubUmlauteTitle => 'Umlauts (ä, ö, ü)';

  @override
  String get pronunciationHubUmlauteDesc =>
      'Distinguish and practice Germany\'s 3 characteristic umlaut vowels';

  @override
  String get pronunciationHubIchAchTitle => 'Ich-laut / Ach-laut';

  @override
  String get pronunciationHubIchAchDesc =>
      'Distinguish \'ch\' after front vs. back vowels';

  @override
  String get pronunciationHubRSoundTitle => 'R-Sound';

  @override
  String get pronunciationHubRSoundDesc =>
      'Germany\'s characteristic guttural R sound';

  @override
  String get pronunciationHubSpStTitle => 'Initial Sp / St';

  @override
  String get pronunciationHubSpStDesc =>
      'sp → shp, st → sht at the start of words and syllables';

  @override
  String get pronunciationLoadError => 'Couldn\'t load data. Please try again.';

  @override
  String get pronunciationRetry => 'Retry';

  @override
  String get pronunciationNoData => 'No practice data yet.';

  @override
  String get pronunciationCompletedTitle => 'Completed!';

  @override
  String pronunciationScoreCorrect(int score, int total) {
    return '$score / $total correct';
  }

  @override
  String get pronunciationRetryCta => 'Practice again';

  @override
  String get pronunciationBackCta => 'Back';

  @override
  String get pronunciationHintLabel => 'Pronunciation tip:';

  @override
  String get pronunciationPlayCta => 'Listen';

  @override
  String get pronunciationNextCta => 'I\'ve heard it →';

  @override
  String get pronunciationDoneCta => 'Done';

  @override
  String get pronunciationModePronounce => 'Pronounce';

  @override
  String get pronunciationModeDistinguish => 'Distinguish';

  @override
  String get pronunciationModeDistinguishSpSt => 'Distinguish sp/st';

  @override
  String get pronunciationModeCategorize => 'Categorize';

  @override
  String get pronunciationUmlauteTitle => 'Umlaut Practice';

  @override
  String get pronunciationIchAchTitle => 'Ich-laut / Ach-laut';

  @override
  String get pronunciationRSoundTitle => 'German R-Sound';

  @override
  String get pronunciationSpStTitle => 'Initial Sp / St';

  @override
  String get pronunciationIchLautBadge => 'Ich-laut [ç]';

  @override
  String get pronunciationAchLautBadge => 'Ach-laut [x]';

  @override
  String get pronunciationCompareLabel => 'Compare:';

  @override
  String get pronunciationROverviewInfo =>
      'The German R sound has 4 variants depending on position. The list below helps you remember the rule quickly.';

  @override
  String get pronunciationRPositionInitial => 'Word-initial [ʁ]';

  @override
  String get pronunciationRPositionAfterVowel => 'After vowel [ɐ]';

  @override
  String get pronunciationRPositionCluster => 'Consonant cluster [ʁ]';

  @override
  String get pronunciationRPositionVocalic => 'Word-final -er [ɐ]';

  @override
  String get pronunciationQuizPrompt =>
      'Listen and pick the word you just heard:';

  @override
  String get pronunciationQuizReplayHint => 'Tap to replay';

  @override
  String pronunciationQuizScore(int count) {
    return '$count correct';
  }

  @override
  String pronunciationStreak(int count) {
    return '🔥 $count in a row!';
  }

  @override
  String get pronunciationQuizCorrect => '✓ Correct!';

  @override
  String get pronunciationQuizWrong => '✗ Not quite';

  @override
  String get pronunciationQuizHeardLabel => 'Word you heard:';

  @override
  String get pronunciationQuizComparing => 'Playing both to compare...';

  @override
  String get pronunciationQuizSeeResult => 'See result';

  @override
  String get pronunciationQuizInsufficientData =>
      'Not enough data to build a quiz.';

  @override
  String get pronunciationMinimalPairsTitle => 'Minimal Pairs Listening';

  @override
  String get pronunciationMinimalPairsPickerHint =>
      'Choose a sound pair to practice distinguishing:';

  @override
  String pronunciationMinimalPairsCount(int count) {
    return '$count word pairs';
  }

  @override
  String get pronunciationMinimalPairsEmpty =>
      'No sound-pair data yet. Please try again later.';

  @override
  String get pronunciationMinimalPairsPracticing => 'Practicing:';

  @override
  String get pronunciationMinimalPairsPrompt => 'Which word did you just hear?';

  @override
  String pronunciationMinimalPairsCorrectOf(int correct, int total) {
    return '$correct/$total correct';
  }

  @override
  String get pronunciationMinimalPairsCorrectLabel => 'Correct!';

  @override
  String pronunciationMinimalPairsWrongLabel(String word) {
    return 'Wrong — correct answer: $word';
  }

  @override
  String get pronunciationEndCta => 'End';

  @override
  String get pronunciationMinimalPairsResultTitle => 'Listening result';

  @override
  String pronunciationMinimalPairsScoreLabel(int correct, int total) {
    return '$correct / $total correct';
  }

  @override
  String get pronunciationMinimalPairsLowScoreHint =>
      'Listen again a few more times — your ear will adjust to the difference!';

  @override
  String get pronunciationChangePairCta => 'Change pair';

  @override
  String sprechenExamLoadError(String error) {
    return 'Could not load the exam: $error';
  }

  @override
  String get sprechenContentLockedTitle => 'Premium content';

  @override
  String get sprechenPracticeCta => '🎤 Practice speaking with Tiger AI';

  @override
  String get sprechenTopicListTitle => 'Topic list';

  @override
  String sprechenTopicListLoadError(String error) {
    return 'Error loading the list: $error';
  }

  @override
  String get sprechenTopicListEmpty => '🎤 No topics yet';

  @override
  String sprechenTopicListSummary(int count, int done) {
    return '$count topics · $done completed';
  }

  @override
  String get sprechenLeaderboardEmpty => 'No leaderboard data yet';

  @override
  String get sprechenTeilSetOverviewSubtitle =>
      'Practice Sprechen — choose a part to start';

  @override
  String get sprechenTeilCompletedBadge => '✓ Completed';

  @override
  String get sprechenOverviewTitle => 'Speaking — Sprechen';

  @override
  String sprechenOverviewSubtitle(String providerLabel) {
    return '$providerLabel · 3 parts · 75 points';
  }

  @override
  String get sprechenOverviewGoetheInfo =>
      'Sprechen makes up 75/300 points of the Goethe B1 exam. Each Teil is graded on 3 criteria: content, grammar & sentence structure, vocabulary & fluency.';

  @override
  String get sprechenOverviewTelcInfo =>
      'Sprechen makes up 75/300 points of the telc B1 exam.';

  @override
  String sprechenTopicCount(int count) {
    return '$count topics';
  }

  @override
  String get sprechenTopicSearchHint => 'Search by topic name or tag group...';

  @override
  String sprechenTopicListFilteredCount(int filtered, int total) {
    return '$filtered/$total topics';
  }

  @override
  String get sprechenTopicListEmptyFiltered => '🎤 No matching topics found';

  @override
  String get sprechenBewertungMainErrors => 'Main errors';

  @override
  String get sprechenHistoryButtonLabel => 'History';

  @override
  String get sprechenPracticeStartCta => 'Start practicing — talk with AI';

  @override
  String get sprechenResultBackToList => 'Back to list';

  @override
  String get sprechenNoSuggestions => 'No suggestions';

  @override
  String get sprechenInputHint => 'Type your answer in German...';

  @override
  String get sprechenMicComingSoon =>
      'Voice mode coming soon — use Write for now';

  @override
  String get sprechenMicUnsupported =>
      'Only Write mode is supported in this version';

  @override
  String get sprechenPartnerSubtitleDefault => 'Reply in German';

  @override
  String sprechenFeedbackScoreLabel(int score) {
    return '$score/5 · feedback';
  }

  @override
  String get sprechenSessionHistoryEmpty => 'No practice sessions yet';

  @override
  String get sprechenStudyPanelLocked =>
      'Premium content — upgrade to view in full';

  @override
  String get sprechenStudyPanelEmpty => 'No study content for this topic yet.';

  @override
  String get conversationTranscriptEmpty => 'No conversation content.';

  @override
  String get writingHotBadge => 'HOT';

  @override
  String get writingCompletedBadge => 'Learned';

  @override
  String get writingPremiumBadge => 'Premium';

  @override
  String get writingUnlockToView => 'Unlock to view';

  @override
  String get writingBuyPremium => 'Buy Premium';

  @override
  String get writingDifficultyEasy => 'Easy';

  @override
  String get writingDifficultyMedium => 'Medium';

  @override
  String get writingDifficultyHard => 'Hard';

  @override
  String writingLeaderboardTitle(int teil) {
    return 'Leaderboard · Teil $teil';
  }

  @override
  String get writingLeaderboardEmpty => 'No one has completed a topic yet';

  @override
  String get writingLeaderboardYou => 'you';

  @override
  String get writingCommunityFolderTitle => 'Community-contributed topics';

  @override
  String writingCommunityFolderCount(int count) {
    return '$count topics added';
  }

  @override
  String get writingCommunityFolderEmpty => 'No topics yet — be the first!';

  @override
  String get writingSearchHint => 'Search by topic, theme, keyword...';

  @override
  String get writingSprintPill => 'Sprint 10h';

  @override
  String get writingSprintComingSoon => 'Sprint 10h is coming soon';

  @override
  String writingTopicCount(int count) {
    return '$count topics';
  }

  @override
  String writingTopicCountFiltered(int count, int total) {
    return '$count/$total topics';
  }

  @override
  String get writingNoResultsTitle => 'No matching topics found';

  @override
  String get writingNoResultsHint =>
      'Try searching in German, Vietnamese, or another topic name.';

  @override
  String writingFreeLimitTitle(int teil) {
    return 'You\'re viewing 5 free topics of Teil $teil';
  }

  @override
  String get writingFreeLimitDesc =>
      'Upgrade to Premium to unlock all Schreiben B1 topics and unlimited AI grading.';

  @override
  String writingTeilLabel(int n) {
    return 'Teil $n';
  }

  @override
  String writingCommunityListTitle(int teil) {
    return 'Community topics · Teil $teil';
  }

  @override
  String get writingPracticeNotFound => 'Writing topic not found.';

  @override
  String writingWordCountHint(int min, int max) {
    return '📏 $min–$max words';
  }

  @override
  String get writingShowTranslation => 'Show translation';

  @override
  String get writingHideTranslation => 'Hide translation';

  @override
  String get writingRequirementsTitle => 'Writing requirements';

  @override
  String get writingSectionTask => 'Task';

  @override
  String get writingSectionTaskAnalysis => 'Task analysis';

  @override
  String get writingSectionTextStructure => 'Text structure';

  @override
  String get writingSectionPhrases => 'Useful phrases';

  @override
  String get writingSectionSamples => 'Sample sentences';

  @override
  String get writingSectionModels => 'Model answers';

  @override
  String get writingSectionGrammar => 'Key grammar (reference)';

  @override
  String get writingSectionVocab => 'Key vocabulary (reference)';

  @override
  String get writingSectionMistakes => 'Common mistakes (reference)';

  @override
  String get writingSectionExercises => 'Practice exercises';

  @override
  String writingApproachesLabel(int count) {
    return '$count ways to develop';
  }

  @override
  String get writingAnnotationsLabel => 'Annotations:';

  @override
  String writingModelTabLabel(int n) {
    return 'Model $n';
  }

  @override
  String get writingColPart => 'Part';

  @override
  String get writingColDe => 'German';

  @override
  String get writingColVi => 'Vietnamese';

  @override
  String writingKernwortschatzTitle(int count) {
    return 'Core vocabulary ($count words)';
  }

  @override
  String get writingGenusOther => 'Other';

  @override
  String get writingTranslateExamples => '🌐 Translate examples';

  @override
  String writingChunksTitle(int count) {
    return 'Chunks & phrases ($count)';
  }

  @override
  String writingKonnektorenTitle(int count) {
    return 'Connectors ($count)';
  }

  @override
  String get writingNoContent => 'No content yet.';

  @override
  String get writingCorrectCount => 'correct';

  @override
  String get writingWrongSentenceLabel => 'WRONG SENTENCE';

  @override
  String get writingRevealAnswer => 'Show answer';

  @override
  String get writingShowSampleAnswer => 'Show sample answer';

  @override
  String get writingSampleAnswerLabel => 'Sample answer';

  @override
  String get writingPlayAll => 'Play all';

  @override
  String writingExamTimesCount(int count) {
    return '📊 $count times examined';
  }

  @override
  String get writingMinutesUnit => 'min';

  @override
  String get writingWordsUnit => 'words';

  @override
  String writingProvenanceTitle(int count) {
    return 'Real exam — $count times';
  }

  @override
  String get writingSourcesLabel => 'Sources';

  @override
  String get writingExamDatesToggle => 'View exam dates';

  @override
  String get writingLockTitle => 'This topic is for Premium accounts';

  @override
  String get writingLockOfficialCopy =>
      'This is an official Premium topic. Upgrade to view the full content.';

  @override
  String get writingLockLegacyCopy =>
      'Free accounts can only view the first 5 topics of each Teil. Upgrade to Premium to unlock all.';

  @override
  String get writingUnlockPremiumCta => 'Unlock Premium';

  @override
  String get writingCompleteMark => '🎯 Mark as complete';

  @override
  String get writingCompleteDone => '✓ Completed — Saved';

  @override
  String get writingCompleteSaving => 'Saving...';

  @override
  String get writingStartPracticeCta => 'Write your own essay → AI grading';

  @override
  String get writingTypingStartTitle => 'Type-practice this topic';

  @override
  String writingTypingStartDesc(int count) {
    return 'There are $count German sentences on this page — practice typing them.';
  }

  @override
  String get writingTypingStartCta => 'Start typing →';

  @override
  String get writingTypingPracticeTitle => 'Typing practice';

  @override
  String writingTypingProgress(int current, int total) {
    return 'Sentence $current/$total';
  }

  @override
  String get writingTypingHint => 'Type the German sentence...';

  @override
  String get writingTypingCheck => 'Check';

  @override
  String get writingTypingCorrect => '✓ Correct!';

  @override
  String get writingTypingIncorrect => '✗ A few things aren\'t right yet';

  @override
  String get writingTypingNext => 'Next →';

  @override
  String get writingTypingSkip => 'Skip';

  @override
  String writingTypingDoneCount(int count) {
    return 'You\'ve typed $count sentences';
  }

  @override
  String get writingTypingClose => 'Close';

  @override
  String get listeningPageTitle => 'Listening';

  @override
  String get listeningPageSubtitle =>
      'Practice German listening with videos, podcasts, and audiobooks';

  @override
  String get listeningIntroWhy =>
      'Practice listening/reading with content that matches your level.';

  @override
  String get listeningIntroTodo =>
      'Choose a source: video, podcast, or reading.';

  @override
  String get listeningIntroNext => 'Save new words you find for review.';

  @override
  String get listeningOtherSourcesSection => 'Other';

  @override
  String get listeningSourceSprechenB1Desc =>
      'Practice dictation listening with Sprechen B1 videos';

  @override
  String get listeningSourceSprechenB2Desc =>
      'Practice dictation listening with Sprechen B2 videos';

  @override
  String get listeningSourceYoutubeDesc =>
      'Practice listening with subtitled YouTube videos';

  @override
  String get listeningSourcePodcastDesc =>
      'Listen to Easy German Podcast with bilingual subtitles';

  @override
  String get listeningSourceAudiobookDesc => 'Listen to easy German audiobooks';

  @override
  String listeningSourceVideoCount(int count) {
    return '$count videos';
  }

  @override
  String get easyGermanSegmentCountShort => 'Short';

  @override
  String get easyGermanSegmentCountMedium => 'Medium';

  @override
  String get easyGermanSegmentCountLong => 'Long';

  @override
  String get easyGermanLoadError =>
      'Couldn\'t load the video list. Please try again later.';

  @override
  String easyGermanSentenceCount(int count) {
    return '$count sentences';
  }

  @override
  String get easyGermanSearchHint => 'Search videos by title or video ID...';

  @override
  String get easyGermanLeaderboardEmptyHint =>
      'Not enough data yet to rank this level.';

  @override
  String get podcastLoadError =>
      'Couldn\'t load the episode list. Please try again later.';

  @override
  String get podcastDescription =>
      'Practice listening with everyday German podcasts';

  @override
  String get podcastEpisodeCountLabel => 'episodes';

  @override
  String get podcastMinutesLabel => 'minutes of listening';

  @override
  String get podcastSearchHint => 'Search episodes...';

  @override
  String podcastNoResultsFor(String query) {
    return 'No episodes match \"$query\".';
  }

  @override
  String get podcastNoResultsInBucket => 'No episodes in this duration range.';

  @override
  String podcastPageInfo(int page, int total, int count) {
    return 'Page $page/$total ($count episodes)';
  }

  @override
  String get podcastAudioLoadError =>
      'Couldn\'t load the audio. Please try again.';

  @override
  String get podcastEpisodeLoadError => 'Couldn\'t load the episode.';

  @override
  String get podcastBackToList => 'Back to list';

  @override
  String get podcastTranscriptEmpty =>
      'No transcript available for this episode yet.';

  @override
  String get podcastLeaderboardSubtitle =>
      'Number of completed podcast episodes';

  @override
  String get podcastLeaderboardLoadError => 'Couldn\'t load the leaderboard.';

  @override
  String podcastYourRank(int rank, int count) {
    return 'Your rank: #$rank · $count episodes';
  }

  @override
  String get podcastSettingsTitle => 'Reading settings';

  @override
  String podcastFontSizeLabel(int percent) {
    return 'Font size ($percent%)';
  }

  @override
  String get podcastShowViTranslation => 'Show Vietnamese translation';

  @override
  String get podcastDurationLe10 => '≤ 10 min';

  @override
  String get podcastDurationLe20 => '10–20 min';

  @override
  String get podcastDurationLe60 => '20–60 min';

  @override
  String get podcastDurationGt60 => '> 60 min';

  @override
  String get videoCollectionWatched => 'Watched';

  @override
  String get videoCollectionEmptyTitle => 'No matching videos found';

  @override
  String get videoCollectionEmptyHint =>
      'Try another keyword or clear the filters.';

  @override
  String get videoCollectionLeaderboardTitle => 'Top learners';

  @override
  String get videoCollectionLeaderboardSubtitle =>
      'Ranked by completed videos and rewatches.';

  @override
  String get videoCollectionLeaderboardEmptyHint =>
      'Not enough data yet to rank.';

  @override
  String videoCollectionLeaderboardStats(int count, int rewatch) {
    return '$count videos · $rewatch rewatches';
  }

  @override
  String videoCollectionPageInfo(int page, int total) {
    return 'Page $page / $total';
  }

  @override
  String get videoCollectionStatusNew => 'Not watched';

  @override
  String get videoCollectionProgressEmpty => 'No video data yet.';

  @override
  String get videoCollectionProgressStart =>
      'Open a video to start saving your progress.';

  @override
  String get videoCollectionProgressDone => 'You\'ve completed everything!';

  @override
  String get videoCollectionProgressFinalStretch =>
      'You\'re in the home stretch!';

  @override
  String get videoCollectionProgressGoodPace => 'Great pace — keep it up.';

  @override
  String get videoCollectionProgressGoodStart =>
      'Good start — keep watching a few more videos.';

  @override
  String get videoCollectionStatRewatch => 'Rewatches';

  @override
  String get videoCollectionStatRemaining => 'Remaining';

  @override
  String get videoCollectionCompletionLabel => 'completed';

  @override
  String videoCollectionPercentLabel(int percent, String label) {
    return '$percent% $label';
  }

  @override
  String videoCollectionSavedCount(int count) {
    return '$count videos with saved progress';
  }

  @override
  String get appOnlySettingsLabel => 'App-only';

  @override
  String get appUpdateSectionDescription =>
      'Check and update to the latest store version.';

  @override
  String get appUpdateSectionTitle => 'Update to the latest version';

  @override
  String get confirmNewPassword => 'Confirm new password';

  @override
  String get couldNotChangePassword =>
      'Could not change password. Please try again.';

  @override
  String get darkModeDescription => 'Reduce eye strain when studying at night';

  @override
  String get darkModeToggle => 'Dark mode';

  @override
  String get dismissAnnouncement => 'Dismiss announcement';

  @override
  String get learningPreferencesGoalCommunication => 'Everyday communication';

  @override
  String get learningPreferencesGoalGoethe => 'Goethe certificate exam';

  @override
  String get learningPreferencesGoalMedical => 'Nursing/medical field';

  @override
  String get learningPreferencesGoalOther => 'Other';

  @override
  String get learningPreferencesGoalsLabel => 'Goals';

  @override
  String get learningPreferencesGoalWork => 'Study/work in Germany';

  @override
  String get learningPreferencesMinutesLabel => 'Daily study time';

  @override
  String learningPreferencesXpSummary(int xp, int words) {
    return 'Goal: $xp XP/day · ~$words words/day';
  }

  @override
  String get logoutConfirmMessage => 'Are you sure you want to sign out?';

  @override
  String get minutesUnit => 'min';

  @override
  String get notificationPermissionBlockedBody =>
      'Please re-enable it in system settings → Notifications.';

  @override
  String get notificationPermissionBlockedTitle => 'Notifications are blocked';

  @override
  String get notificationPermissionEnableAction => 'Enable notifications';

  @override
  String get notificationPreferencesSendTest => 'Send test';

  @override
  String get notificationPreferencesTestFailed =>
      'Failed to send. Please try again later.';

  @override
  String get notificationPreferencesTestSending => 'Sending…';

  @override
  String get notificationPreferencesTestSent =>
      'Sent! It should arrive on your device shortly.';

  @override
  String get notificationPreferencesTimezone => 'Timezone';

  @override
  String get passwordMinLength => 'At least 8 characters';

  @override
  String get reviewDisplay4Button => '4-level self-rating (after each round)';

  @override
  String get reviewDisplay4ButtonDesc =>
      'Show the Forgot/Hard/Good/Easy sheet after each round to fine-tune auto-grading.';

  @override
  String get reviewDisplayAutoAdvance => 'Auto-advance';

  @override
  String get reviewDisplayAutoAdvanceDesc =>
      'On: jump to the next card automatically after answering. Off (recommended): tap \"Continue\" to advance yourself.';

  @override
  String get reviewDisplayContext => 'Show example sentence';

  @override
  String get reviewDisplayContextDesc =>
      'Show a short example sentence under each word in the summary.';

  @override
  String get reviewDisplayTitle => 'Review display';

  @override
  String get settingsSavedMessage => 'Saved!';

  @override
  String get settingsSubtitle => 'Customize the app';

  @override
  String get soundAndEffects => 'Sound & effects';

  @override
  String get soundAndEffectsDescription =>
      'Sound and vibration for correct/incorrect answers in lessons';

  @override
  String listeningSprechenHeaderSubtitle(int count) {
    return '$count videos · Dictation listening practice';
  }

  @override
  String get writingHubTitle => 'Writing practice (AI graded)';

  @override
  String get writingHubRubricButton => '📋 How it\'s graded';

  @override
  String get writingHubTabStart => 'Start';

  @override
  String get writingHubTabMy => 'My essays';

  @override
  String get writingHubTabCommunity => 'Community';

  @override
  String get writingHubStartIntro =>
      'Pick an exam and level to start writing practice.';

  @override
  String get writingHubCustomTitle => 'Enter your own prompt';

  @override
  String get writingHubCustomSubtitle =>
      'Paste any prompt → pick exam & level → AI grades it';

  @override
  String get writingHubSprintTitle => 'Sprint quick review';

  @override
  String get writingHubSprintSubtitle =>
      'Quick spaced-repetition drill of Goethe B1 sample sentences';

  @override
  String get writingHubCommunityIntro =>
      'Writing prompts contributed by the community, grouped by Teil.';

  @override
  String get writingHubCommunityTeil1 => 'Teil 1 — Informal email';

  @override
  String get writingHubCommunityTeil2 => 'Teil 2 — Forum essay';

  @override
  String get writingHubCommunityTeil3 => 'Teil 3 — Formal email';

  @override
  String get writingHubCommunityViewAll => 'View all community prompts →';

  @override
  String get writingChooseNow => 'Choose a prompt now';

  @override
  String get writingClearFilters => 'Clear filters';

  @override
  String get writingShowMore => 'Show more';

  @override
  String get writingSortLabel => 'Sort:';

  @override
  String get writingSortByDate => 'Date';

  @override
  String get writingSortByScore => 'Score';

  @override
  String get writingSubmissionsEmptyTitle => 'No essays yet';

  @override
  String get writingSubmissionsEmptyDesc =>
      'Choose a prompt and start writing to see your history here.';

  @override
  String get writingSubmissionsNoMatch => 'No essays match this filter.';

  @override
  String get writingCriteriaTrendTitle => 'Your writing criteria';

  @override
  String writingCriteriaTrendSubtitle(int count) {
    return 'Avg over $count graded essays';
  }

  @override
  String get writingCriteriaWeakest => 'needs the most work';

  @override
  String get writingCriterionTaskCompletion => 'Task completion';

  @override
  String get writingCriterionGrammar => 'Grammar';

  @override
  String get writingCriterionVocabulary => 'Vocabulary';

  @override
  String get writingCriterionCoherence => 'Coherence';

  @override
  String writingLevelTitle(String label) {
    return '$label · Writing';
  }

  @override
  String get writingLevelEmptyTitle => 'No official prompts yet';

  @override
  String writingLevelEmptyDesc(String label) {
    return '$label prompts are being added — try the community prompts below!';
  }

  @override
  String get writingLevelCommunitySectionTitle => 'Community prompts';

  @override
  String get writingLevelContributeButton => '➕ Contribute a prompt';

  @override
  String get writingLevelCommunityEmpty =>
      'No community prompts for this level yet.';

  @override
  String get writingLevelNotFound => 'Couldn\'t find this writing level.';

  @override
  String get writingLevelLocked => 'This prompt is for Premium accounts.';

  @override
  String get writingCommunityAddVersion => '➕ Add a version';

  @override
  String get writingCommunityBackToList => 'Back to list';

  @override
  String get writingCommunityCreateTitle => 'Contribute a community prompt';

  @override
  String get writingCommunityNotFoundDesc =>
      'This prompt may have been removed or isn\'t public yet.';

  @override
  String get writingCommunityNotFoundTitle => 'Prompt not found';

  @override
  String get writingCommunityPointsHint =>
      'One point per line — the AI uses these to follow the prompt closely.';

  @override
  String get writingCommunityPointsTitle => 'Points to cover';

  @override
  String get writingCommunityReportReason => 'Reported by a user';

  @override
  String get writingCommunityReportSent => 'Report sent, thank you!';

  @override
  String get writingCommunitySubmit => 'Publish prompt';

  @override
  String get writingCommunityTaskHint => 'Paste your writing prompt here…';

  @override
  String get writingCommunityTopicFallbackTitle => 'Community prompt';

  @override
  String get writingCommunityVoteError =>
      'Something went wrong, please try again.';

  @override
  String get writingCustomTitle => 'Custom prompt';

  @override
  String get writingCustomIntro =>
      'Paste your prompt, pick an exam & level, then write — the AI grades and gives feedback just like a built-in prompt.';

  @override
  String get writingCustomExamLabel => 'Exam';

  @override
  String get writingCustomLevelLabel => 'Level';

  @override
  String get writingCustomTeilLabel => 'Teil (optional)';

  @override
  String get writingCustomTeilNone => 'None';

  @override
  String get writingCustomTaskLabel => 'Prompt *';

  @override
  String get writingCustomTaskHintPolish =>
      'Enter a Vietnamese prompt, keywords, or a rough draft — the AI will turn it into a full German prompt…';

  @override
  String get writingCustomTaskHintPlain =>
      'Paste a complete German writing prompt here…';

  @override
  String get writingCustomPointsLabelPolish => 'Hints / key ideas (optional)';

  @override
  String get writingCustomPointsLabelPlain => 'Points to cover (optional)';

  @override
  String get writingCustomPointsHint =>
      'One point per line — the AI uses these to follow the prompt closely.';

  @override
  String get writingCustomStartPolish => 'Polish & start writing';

  @override
  String get writingCustomStartPlain => 'Start writing';

  @override
  String get writingCustomEditPrompt => '← Edit prompt';

  @override
  String get writingCustomStartedTitle => 'Custom prompt';

  @override
  String get writingCustomContribute =>
      '📤 Contribute this prompt to the community';

  @override
  String get writingAiPolishTitle => '✨ Let AI polish the prompt';

  @override
  String get writingAiPolishDesc =>
      'Turns a Vietnamese prompt / keywords / rough draft into a proper German prompt. Uncheck if your prompt is already complete.';

  @override
  String get writingAiPolishing => 'Polishing prompt…';

  @override
  String get writingAiPolishError =>
      'AI failed to polish the prompt. Uncheck to use the original, or try again.';

  @override
  String get writingSessionGradingTimelineTitle => 'Grading history';

  @override
  String get writingSessionNotFound =>
      'Couldn\'t find this essay. It may be old — go back to your history to see recent essays.';

  @override
  String get writingSessionPracticeAgain => 'Practice again';

  @override
  String get writingSessionTitleFallback => 'Essay';

  @override
  String get writingSessionYourAnswer => 'Your essay';

  @override
  String get youtubeInvalidUrl => 'Invalid YouTube URL';

  @override
  String get youtubeAddVideoError =>
      'Couldn\'t add the video, try again later.';

  @override
  String get youtubeDeleteVideoError => 'Couldn\'t delete the video.';

  @override
  String get youtubeLoadListError => 'Couldn\'t load the video list.';

  @override
  String get youtubeEmptyState =>
      'No videos yet. Paste a YouTube URL above to get started.';

  @override
  String get youtubeUntitledVideo => 'Untitled video';

  @override
  String youtubeWatchCount(int count) {
    return 'Watched ×$count';
  }

  @override
  String get youtubeContinueWatching => 'Continue watching';

  @override
  String get youtubePopularVideos => 'Popular videos';

  @override
  String get youtubePasteUrlHint => 'Paste a YouTube URL...';

  @override
  String get youtubeRewatchMarked => 'Rewatch recorded';

  @override
  String get youtubeCompleteMarked => 'Marked as completed';

  @override
  String get youtubeSaveProgressError =>
      'Couldn\'t save progress, try again later.';

  @override
  String get youtubeRewatchButton => 'Rewatch';

  @override
  String get youtubeCompleteButton => 'Completed';

  @override
  String get youtubePracticeShadowing => 'Shadowing';

  @override
  String get youtubeTranscriptLabel => 'Transcript';

  @override
  String get youtubeNotesLabel => 'Notes';

  @override
  String get youtubeDictationShowVideoTooltip => 'Show video';

  @override
  String get youtubeDictationAudioOnlyTooltip => 'Audio only';

  @override
  String get youtubeTranscriptLoadError => 'Couldn\'t load the transcript.';

  @override
  String get youtubeDictationNoTranscript =>
      'This video has no transcript for dictation practice yet.';

  @override
  String get shadowingScreenTitle => 'Shadowing — Pronunciation practice';

  @override
  String get shadowingHideVideoTooltip => 'Hide video (audio still plays)';

  @override
  String get shadowingNoTranscript =>
      'This video has no transcript for shadowing practice yet.';

  @override
  String shadowingSentenceProgress(int index, int total) {
    return 'Sentence $index/$total';
  }

  @override
  String get shadowingListenAgain => 'Listen again';

  @override
  String get shadowingRecordTooltip => 'Record';

  @override
  String get shadowingRecordComingSoonTooltip => 'Recording coming soon';

  @override
  String get shadowingRecordComingSoonHint =>
      'Recording + AI pronunciation scoring coming soon — stay tuned for the next update.';

  @override
  String youtubeDictationProgress(int index, int total, int correct) {
    return 'Sentence $index/$total · Correct $correct';
  }

  @override
  String get youtubeDictationSentenceHint => 'Type the whole sentence...';

  @override
  String get youtubeDictationClozeHint => 'Fill in the missing word...';

  @override
  String get youtubeDictationAnswerLabel => 'Answer:';

  @override
  String get youtubeDictationRetryButton => '↻ Retry';

  @override
  String get youtubeDictationNextButton => 'Next →';

  @override
  String get youtubeDictationCompleteTitle => 'Completed!';

  @override
  String youtubeDictationCompleteSummary(int correct, int total, int skipped) {
    return '$correct/$total sentences correct · $skipped skipped';
  }

  @override
  String get youtubeDictationRestartButton => 'Start over';

  @override
  String get youtubeDictationModeLabel => 'Mode';

  @override
  String get youtubeDictationModeSentence => 'Whole sentence';

  @override
  String get youtubeDictationModeCloze => 'Fill in the blank';

  @override
  String get youtubeDictationAlwaysShowVietnamese =>
      'Always show Vietnamese meaning';

  @override
  String get writingSprintTitle => 'Sprint Anki';

  @override
  String get writingSprintSubtitle =>
      'Goethe B1 Writing — review with spaced repetition';

  @override
  String get writingSprintModePickerLabel => 'Choose a mode';

  @override
  String get writingSprintModeMarathonTitle => 'Marathon';

  @override
  String get writingSprintModeMarathonSubtitle => '1 session, 10 hours';

  @override
  String get writingSprintModeMarathonDetail =>
      'Fast repeats: 1m · 10m · 30m · 2h. Cover every topic in one sitting.';

  @override
  String get writingSprintModeDailyTitle => 'Daily';

  @override
  String get writingSprintModeDailySubtitle => 'Multi-day SM-2';

  @override
  String get writingSprintModeDailyDetail =>
      'Anki-style algorithm: ~1d · 2.5d · 4d. A few minutes a day, remembered longer.';

  @override
  String get writingSprintModeSelected => 'Selected';

  @override
  String get writingSprintResumeButton => 'Resume previous session';

  @override
  String get writingSprintStartFreshButton => 'Start fresh (clear old session)';

  @override
  String writingSprintStartButton(int count) {
    return 'Start — $count topics';
  }

  @override
  String get writingSprintMockCta => 'Take a 3-essay practice exam';

  @override
  String get writingSprintCheatsheetCta => 'Redemittel cheatsheet';

  @override
  String writingSprintCardCounter(int teil, int num, int total) {
    return 'Teil $teil · Card $num/$total';
  }

  @override
  String get writingSprintRequirementsLabel => 'REQUIREMENTS';

  @override
  String writingSprintOutlineLabel(int index) {
    return 'Outline $index (DE)';
  }

  @override
  String writingSprintOutlineHint(int index) {
    return 'What will you write for point $index?';
  }

  @override
  String get writingSprintSkipButton => 'Skip';

  @override
  String get writingSprintCheckButton => 'Check';

  @override
  String get writingSprintMatchGood =>
      'Good! You remember most of the content.';

  @override
  String get writingSprintMatchWeak => 'Needs review — pick Again or Hard.';

  @override
  String get writingSprintOutlineAnswerLabel => 'OUTLINE ANSWER';

  @override
  String writingSprintOutlineMissing(int index) {
    return '(outline $index not available)';
  }

  @override
  String writingSprintYouWrote(String text) {
    return 'You wrote: $text';
  }

  @override
  String get writingSprintMiniModelToggle => 'Show mini-model';

  @override
  String get writingSprintRedemittelLabel => 'REDEMITTEL';

  @override
  String get writingSprintSessionDoneTitle => 'All reviewed!';

  @override
  String writingSprintSessionDoneBody(int count) {
    return 'You reviewed $count topics this session.';
  }

  @override
  String get writingSprintBackToSprint => 'Back to Sprint';

  @override
  String writingSprintTaskLabel(int teil) {
    return 'Task — Teil $teil';
  }

  @override
  String get writingSprintEssayHint => 'Write your essay here...';

  @override
  String writingSprintWordCount(int count, int min, int max) {
    return '$count words (target: $min–$max)';
  }

  @override
  String writingSprintSubmitButton(int count) {
    return 'Submit ($count words)';
  }

  @override
  String get writingSprintGrading => 'Grading...';

  @override
  String writingSprintWordsNeeded(int count) {
    return '$count more words needed';
  }

  @override
  String get writingSprintNoMockTopics => 'No matching topics found.';

  @override
  String get writingSprintMockAverageLabel => 'Average score across 3 essays';

  @override
  String writingSprintTeilTopicLabel(int teil, String title) {
    return 'Teil $teil — $title';
  }

  @override
  String get writingSprintNextEssay => 'Next essay →';

  @override
  String get writingSprintGradingLong => 'AI is grading your essay... (~5-10s)';

  @override
  String writingSprintTeilLabel(int teil) {
    return 'Teil $teil';
  }

  @override
  String get writingSprintErrorsToFixLabel => 'Errors to fix';

  @override
  String get writingSprintErrorWrongLabel => 'Wrong';

  @override
  String get writingSprintErrorFixLabel => 'Fix';

  @override
  String get writingSprintShowEssay => 'Show essay';

  @override
  String get writingSprintHideEssay => 'Hide essay';

  @override
  String get writingSprintRegradeButton => 'Re-grade?';

  @override
  String get writingSprintCheatsheetTitle => 'Goethe B1 Writing Cheatsheet';

  @override
  String writingSprintCheatsheetSummary(int topics, int clusters) {
    return '$topics topics · $clusters clusters';
  }

  @override
  String writingSprintCheatsheetOverviewTitle(int count) {
    return 'Overview — $count clusters';
  }

  @override
  String writingSprintCheatsheetTopicCount(int count) {
    return '$count topics';
  }

  @override
  String writingSprintCheatsheetTeilTitle(int teil, int count) {
    return 'Teil $teil — $count topics';
  }

  @override
  String get writingSprintCheatsheetRedemittelTitle =>
      'Top Redemittel by function';

  @override
  String get writingSprintCheatsheetMistakesTitle => 'Common B1 mistakes';

  @override
  String get writingSprintCheatsheetVerbKasusTitle =>
      'Quick reference — Verb+Kasus';

  @override
  String get readingTabLabel => 'Stories';

  @override
  String get newsTabLabel => 'News';

  @override
  String get readingHubTitle => 'Read stories';

  @override
  String readingHubTitleLevel(String level) {
    return 'Read $level stories';
  }

  @override
  String get readingHubSubtitleHome =>
      'Bilingual German–Vietnamese stories by level · with audio · A1–C2';

  @override
  String get readingHubSubtitleLevel =>
      'Pick a story · complete the exercises (≥60%) to mark it done';

  @override
  String get readingLevelCardEmpty => 'No stories yet';

  @override
  String get readingLevelCardAllDone => '🎉 All done!';

  @override
  String get readingViewAllArrow => 'View all →';

  @override
  String readingSearchHintInLevel(String level) {
    return 'Search stories in $level...';
  }

  @override
  String readingCompletedCountOfTotal(int completed, int total) {
    return '$completed/$total stories completed';
  }

  @override
  String get readingSearchEmpty => 'No stories found';

  @override
  String get readingDoneChip => 'Read';

  @override
  String get readingShowTranslation => 'Show translation';

  @override
  String get readingTapWordHint => 'Tap any word to look up its meaning.';

  @override
  String get readingSaveProgressError =>
      'Couldn\'t save progress, please try again later.';

  @override
  String get readingGlossaryTitle => 'Vocabulary & explanations';

  @override
  String get readingMarkComplete => 'Mark as read';

  @override
  String get readingFeedAppBarTitle => 'Just-right reading';

  @override
  String get readingFeedEmptyReady => 'No stories match your level right now.';

  @override
  String get readingFeedEmptyNotReady =>
      'The story library is still being prepared — please check back in a few minutes.';

  @override
  String get readingFeedSaveVocabHint =>
      'Save more vocabulary so the system can personalize story suggestions for you.';

  @override
  String readingFeedVocabSummary(int vocabNew, int coveragePct) {
    return '$vocabNew new words · $coveragePct% of difficult words known';
  }

  @override
  String get readListenTabRead => 'Read';

  @override
  String readingLeaderboardProgressTitle(String level) {
    return '$level progress';
  }

  @override
  String readingLeaderboardTitleLevel(String level) {
    return '$level leaderboard';
  }

  @override
  String readingLeaderboardSubtitleLevel(String level) {
    return 'Number of $level stories completed';
  }

  @override
  String get readingYourRankPrefix => 'Your rank: ';

  @override
  String readingYourRankSuffix(int count) {
    return ' · $count stories';
  }

  @override
  String get newsHeaderTitle => 'German news';

  @override
  String get newsHeaderSubtitle =>
      'Read German news by level A1–B2 · with audio · vocabulary · exercises';

  @override
  String get newsFilterLevelLabel => 'Level:';

  @override
  String get newsFilterTopicLabel => 'Topic:';

  @override
  String newsPaginationInfo(int page, int total) {
    return 'Page $page/$total';
  }

  @override
  String get newsPaginationNext => 'Next';

  @override
  String get newsEmptyFiltered => 'No stories match the filter.';

  @override
  String get newsEmptyNone => 'No news yet.';

  @override
  String get newsChooseLevelLabel => 'Choose a reading level';

  @override
  String get newsOtherLevelsPrefix =>
      '💡 You can also read this story at another level: ';

  @override
  String get newsListenFullStory => 'Listen to the full story';

  @override
  String get newsAudioSpeedSlow => 'Slow';

  @override
  String get newsAudioSpeedNormal => 'Normal';

  @override
  String get newsVocabTitle => 'Vocabulary';

  @override
  String get newsHasAudioLabel => 'Has audio';

  @override
  String get newsLeaderboardTitleWeekly => 'Weekly leaderboard';

  @override
  String get newsLeaderboardSubtitleWeekly =>
      'Number of news stories completed this week';

  @override
  String get newsLeaderboardEmpty =>
      'No one has completed a story this week yet';

  @override
  String get newsQuizTitle => 'Quiz questions';

  @override
  String get newsQuizSubmit => 'Submit';

  @override
  String newsQuizResult(int correct, int total, int percent) {
    return 'Result: $correct/$total correct ($percent%)';
  }

  @override
  String get newsQuizPassedSuffix => ' — Progress saved ✅';

  @override
  String get saveWordsCtaDone => '✓ Added — will appear in Review';

  @override
  String saveWordsCtaSave(int count) {
    return '📥 Save $count new words to your Review deck';
  }

  @override
  String saveWordsCtaResolvedCount(int resolvable, int total) {
    return '$resolvable/$total words available in the system';
  }

  @override
  String get saveWordsCtaError =>
      'Couldn\'t save vocabulary, please try again later.';

  @override
  String get newsStoryNotFound => 'News story not found.';

  @override
  String get yesterday => 'Yesterday';

  @override
  String newsWeeklyRingProgress(int done, int total) {
    return 'This week you\'ve read $done/$total newly published stories';
  }

  @override
  String get newsWeeklyRingEmpty => 'No newly published stories this week yet';

  @override
  String get readingListenFullStory => 'Listen to the full story';

  @override
  String get readingAudioSpeedTooltip => 'Speed';
}
