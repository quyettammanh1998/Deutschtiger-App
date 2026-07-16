// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'DeutschTiger';

  @override
  String get settings => 'Einstellungen';

  @override
  String get profile => 'Profil';

  @override
  String get messages => 'Nachrichten';

  @override
  String get editProfile => 'Profil bearbeiten';

  @override
  String get couldNotLoadProfile => 'Profil konnte nicht geladen werden.';

  @override
  String get home => 'Startseite';

  @override
  String get learner => 'Lernende:r';

  @override
  String get couldNotLoadHome =>
      'Startseite konnte nicht geladen werden. Bitte versuche es erneut.';

  @override
  String get couldNotLoadData =>
      'Daten konnten nicht geladen werden. Bitte versuche es erneut.';

  @override
  String get mission => 'Aufgabe';

  @override
  String get searchVocabulary => 'Wortschatz suchen...';

  @override
  String get todayMissions => 'Heutige Aufgaben';

  @override
  String get seeAll => 'Alle anzeigen';

  @override
  String get noBonusMissions => 'Heute gibt es keine Bonusaufgaben.';

  @override
  String get dailyMissionsHeading => '🎁 Bonusaufgaben';

  @override
  String get todaySession => 'Heutige Lerneinheit';

  @override
  String get dueWords => 'Fällige Wörter';

  @override
  String get goodMorning => 'Guten Morgen';

  @override
  String get goodNoon => 'Guten Tag';

  @override
  String get goodAfternoon => 'Guten Nachmittag';

  @override
  String get goodEvening => 'Guten Abend';

  @override
  String get headerEncouragement => 'Bereit, Deutsch zu meistern? 🚀';

  @override
  String get headerStreakStart => 'Loslegen';

  @override
  String get todayXp => 'XP heute';

  @override
  String get streak => 'Serie';

  @override
  String streakDays(int count) {
    return '$count Tage';
  }

  @override
  String get zeroMinutes => '0 Minuten';

  @override
  String minutesShort(int count) {
    return '$count Minuten';
  }

  @override
  String hoursShort(int count) {
    return '$count Std.';
  }

  @override
  String hoursMinutesShort(int hours, int minutes) {
    return '$hours Std. $minutes Min.';
  }

  @override
  String get wordsLearned => 'Gelernte Wörter';

  @override
  String get lookupCount => 'Nachschlagen';

  @override
  String get today => 'Heute';

  @override
  String get viewDetails => 'Details anzeigen';

  @override
  String get weeklyLeaderboard => '🏆 Diese Woche';

  @override
  String get seeFull => 'Vollständige Rangliste →';

  @override
  String get learnMoreToRank =>
      'Lerne heute weiter, um in der Rangliste aufzusteigen! 🔥';

  @override
  String get weeklyLeaderboardInTop3 => 'Du bist in den Top 3 — weiter so! 🎉';

  @override
  String get user => 'Nutzer:in';

  @override
  String get noWeeklyLeaderboard =>
      'Diese Woche ist noch niemand in der Rangliste.';

  @override
  String get noWeeklyLeaderboardSubtitle =>
      'Lerne heute und sei der/die Erste! 🔥';

  @override
  String get qaTabExam => '🎓 Prüfungsvorbereitung';

  @override
  String get qaTabVocab => 'Wortschatz & Wiederholung';

  @override
  String get qaTabListen => 'Hören & Sehen';

  @override
  String get qaTabAi => 'Schreiben & Sprechen (KI)';

  @override
  String get qaTabOther => 'Weitere';

  @override
  String get qaTabAll => 'Alle →';

  @override
  String get qaExamTitle => 'Prüfungsvorbereitung';

  @override
  String get qaExamSubtitle => 'Goethe, telc';

  @override
  String get qaVocabTitle => 'Wortschatz';

  @override
  String qaVocabSubtitle(int count) {
    return '$count+ Wörter';
  }

  @override
  String get qaNotesTitle => 'Notizbuch';

  @override
  String get qaNotesSubtitle => 'Gespeicherte Wörter';

  @override
  String get qaReviewTitle => 'Wiederholung';

  @override
  String get qaReviewSubtitle => 'Fällige Wörter';

  @override
  String get qaYoutubeTitle => 'YouTube';

  @override
  String get qaYoutubeSubtitle => 'Zweisprachige Videos';

  @override
  String get qaListenTitle => 'Hören';

  @override
  String get qaListenSubtitle => 'Hörtraining mit Video';

  @override
  String get qaNewsTitle => 'Nachrichten';

  @override
  String get qaNewsSubtitle => 'Deutsche News A1–B2';

  @override
  String get qaSentenceAiTitle => 'Sätze schreiben (KI)';

  @override
  String get qaSentenceAiSubtitle => 'Sätze bilden & schreiben, KI-Bewertung';

  @override
  String get qaAiTutorTitle => 'AI Tutor';

  @override
  String get qaAiTutorSubtitle => 'Mit KI chatten';

  @override
  String get qaGamesTitle => 'Spiele';

  @override
  String get qaGamesSubtitle => 'Lernen durch Spiele, XP verdienen';

  @override
  String get qaAffiliateTitle => 'Weiterempfehlen';

  @override
  String get qaAffiliateSubtitle => 'Provision verdienen';

  @override
  String get dailyPathHeroTitle => '☀️ Was steht heute an?';

  @override
  String dailyPathExamBadge(int days, String examLabel) {
    return 'Noch $days Tage bis zur $examLabel-Prüfung';
  }

  @override
  String dailyPathPlanSummary(int done, int total) {
    return 'Heutiger Plan · $done/$total Schritte';
  }

  @override
  String dailyPathMinutesRemaining(int minutes) {
    return 'noch etwa $minutes Minuten';
  }

  @override
  String dailyPathNextStep(int minutes) {
    return 'Nächster Schritt · ~$minutes Min.';
  }

  @override
  String get dailyPathCompleteCelebration => '🎉 Heutiger Lernpfad geschafft!';

  @override
  String dailyPathCompleteCelebrationWithStreak(int count) {
    return '🎉 Heutiger Lernpfad geschafft! Halte deine 🔥$count-Tage-Serie.';
  }

  @override
  String get dailyPathEmptyTitle => 'Heutigen Lernpfad starten';

  @override
  String get dailyPathEmptyDescription =>
      'Ein paar Minuten täglich halten deine Serie und deinen Fortschritt aufrecht.';

  @override
  String get dailyPathEmptyCta => 'Jetzt lernen';

  @override
  String get learnMore => 'Weiterlernen';

  @override
  String get start => 'Starten';

  @override
  String get couldNotCompleteAuth =>
      'Anmeldung konnte nicht abgeschlossen werden. Bitte versuche es erneut.';

  @override
  String get signUpSuccess =>
      'Registrierung erfolgreich. Bitte bestätige dein Konto über deine E-Mail.';

  @override
  String get welcomeLearnGerman => 'Deutsch lernen';

  @override
  String get welcomeEveryDayWith => 'jeden Tag mit ';

  @override
  String get welcomeDescription =>
      'Eine Deutschlern-App für vietnamesische Lernende — wiederhole Wortschatz, erledige tägliche Aufgaben und übe Lesen, Schreiben und Bewerbungsgespräche.';

  @override
  String get smartVocabularyReview => 'Intelligente Wortschatzwiederholung';

  @override
  String get smartVocabularyReviewDescription =>
      'Wiederhole Karteikarten kurz bevor du sie vergisst.';

  @override
  String get dailyMissionsAndStreak => 'Tägliche Aufgaben & Serie';

  @override
  String get dailyMissionsAndStreakDescription =>
      'Setze tägliche Ziele und halte deine Serie aufrecht.';

  @override
  String get trackProgress => 'Fortschritt verfolgen';

  @override
  String get trackProgressDescription =>
      'XP, Niveau und täglich gelernte Minuten.';

  @override
  String get startLearning => 'Lernen starten';

  @override
  String get alreadyHaveAccount => 'Hast du bereits ein Konto?';

  @override
  String get logIn => 'Anmelden';

  @override
  String get loginToContinue => 'Melde dich an, um weiterzulernen';

  @override
  String get continueWithGoogle => 'Mit Google fortfahren';

  @override
  String get continueWithApple => 'Mit Apple fortfahren';

  @override
  String get or => 'oder';

  @override
  String get email => 'E-Mail';

  @override
  String get password => 'Passwort';

  @override
  String get enterPassword => 'Passwort eingeben';

  @override
  String get forgotPassword => 'Passwort vergessen?';

  @override
  String get dontHaveAccount => 'Noch kein Konto?';

  @override
  String get signUp => 'Registrieren';

  @override
  String get createNewAccount => 'Neues Konto erstellen';

  @override
  String get displayName => 'Anzeigename';

  @override
  String get yourName => 'Dein Name';

  @override
  String get atLeastSixCharacters => 'Mindestens 6 Zeichen';

  @override
  String get createAccount => 'Konto erstellen';

  @override
  String get signUpWithGoogle => 'Mit Google registrieren';

  @override
  String get signUpWithApple => 'Mit Apple registrieren';

  @override
  String get passwordRecovery => 'Passwort wiederherstellen';

  @override
  String get passwordRecoveryDescription =>
      'Gib deine registrierte E-Mail-Adresse ein; wir senden dir einen Wiederherstellungslink.';

  @override
  String get passwordRecoverySent =>
      'Wiederherstellungs-E-Mail gesendet. Bitte prüfe deinen Posteingang.';

  @override
  String get sendRecoveryEmail => 'Wiederherstellungs-E-Mail senden';

  @override
  String get backToLogin => 'Zurück zur Anmeldung';

  @override
  String get emailRequired => 'Gib deine E-Mail-Adresse ein.';

  @override
  String get invalidEmail => 'Gib eine gültige E-Mail-Adresse ein.';

  @override
  String get passwordRequired => 'Gib dein Passwort ein.';

  @override
  String get passwordTooShort =>
      'Dein Passwort muss mindestens 6 Zeichen haben.';

  @override
  String get displayNameRequired => 'Gib einen Anzeigenamen ein.';

  @override
  String get displayNameTooShort => 'Dein Anzeigename ist zu kurz.';

  @override
  String get skip => 'Überspringen';

  @override
  String get continueAction => 'Weiter';

  @override
  String get smartVocabularyLearning => 'Wortschatz intelligent lernen';

  @override
  String get smartVocabularyLearningDescription =>
      'Wiederhole Karteikarten kurz bevor du sie vergisst. Mehr als 5.000 Wörter nach Themen von A1 bis C1.';

  @override
  String get goetheTelcPractice => 'Goethe / telc üben';

  @override
  String get goetheTelcPracticeDescription =>
      'A1–B2-Übungsprüfungen mit automatischer Bewertung und einem Lernpfad, der zu deinem Niveau passt.';

  @override
  String get gamificationAndStreak => 'Gamification & Serie';

  @override
  String get gamificationAndStreakDescription =>
      'XP, Niveau, Lernserie, Freundesranglisten und tägliche Belohnungen.';

  @override
  String get resetPassword => 'Passwort zurücksetzen';

  @override
  String get enterNewPassword => 'Neues Passwort eingeben';

  @override
  String get newPasswordDescription =>
      'Dein neues Passwort muss mindestens 8 Zeichen haben.';

  @override
  String get newPassword => 'Neues Passwort';

  @override
  String get confirmPassword => 'Passwort bestätigen';

  @override
  String get passwordResetSuccess =>
      'Dein Passwort wurde erfolgreich zurückgesetzt.';

  @override
  String get couldNotResetPassword =>
      'Passwort konnte nicht zurückgesetzt werden. Bitte versuche es erneut.';

  @override
  String get newPasswordRequired => 'Gib ein neues Passwort ein.';

  @override
  String get newPasswordTooShort =>
      'Dein neues Passwort muss mindestens 8 Zeichen haben.';

  @override
  String get passwordConfirmationMismatch =>
      'Die Passwortbestätigung stimmt nicht überein.';

  @override
  String get avatarUrlOptional => 'Profilbild-URL (optional)';

  @override
  String get saveChanges => 'Änderungen speichern';

  @override
  String get couldNotUpdateProfile =>
      'Profil konnte nicht aktualisiert werden. Bitte versuche es erneut.';

  @override
  String get premium => 'Premium';

  @override
  String get level => 'Stufe';

  @override
  String get totalXp => 'XP gesamt';

  @override
  String get leaderboardTitle => 'Rangliste';

  @override
  String get thisWeek => 'Diese Woche';

  @override
  String get allTime => 'Gesamtrangliste';

  @override
  String get couldNotLoadLeaderboard =>
      'Rangliste konnte nicht geladen werden. Bitte versuche es erneut.';

  @override
  String get noLeaderboardEntries => 'Es gibt noch keine Ranglisteneinträge.';

  @override
  String get exam => 'Prüfung';

  @override
  String get examPractice => 'Prüfungsvorbereitung';

  @override
  String get loadingExam => 'Prüfung wird geladen…';

  @override
  String get examQuestionPalette => 'Fragenübersicht';

  @override
  String examQuestionProgress(int current, int total) {
    return 'Frage $current / $total';
  }

  @override
  String get previous => 'Zurück';

  @override
  String get next => 'Weiter';

  @override
  String get done => 'Fertig';

  @override
  String get submitExam => 'Prüfung abgeben';

  @override
  String get exitExamTitle => 'Prüfung verlassen?';

  @override
  String get exitExamBody => 'Dein Fortschritt wurde automatisch gespeichert.';

  @override
  String get exit => 'Verlassen';

  @override
  String get submitExamTitle => 'Prüfung abgeben?';

  @override
  String submitExamUnanswered(int count) {
    return 'Du hast noch $count unbeantwortete Fragen. Trotzdem abgeben?';
  }

  @override
  String get reviewAnswers => 'Antworten prüfen';

  @override
  String get allFilters => 'Alle';

  @override
  String get couldNotLoadExams =>
      'Prüfungen konnten nicht geladen werden. Bitte versuche es erneut.';

  @override
  String get noSupportedExams =>
      'Es gibt noch keine passenden Lese- oder Hörprüfungen.';

  @override
  String get examReadinessTitle => 'Prüfungsbereitschaft';

  @override
  String get examReadinessEmpty =>
      'Noch keine Daten — mache mindestens 1 Prüfung, um deine Bereitschaft zu sehen.';

  @override
  String get examReadinessAttempts => 'Versuche';

  @override
  String get examReadinessBestScore => 'Bestes Ergebnis';

  @override
  String get examReadinessDueReviews => 'Fällige Wiederholungen';

  @override
  String get examReadinessSkillBreakdown => 'Nach Fertigkeit';

  @override
  String get examReadinessWeaknesses => 'Zu behebende Schwächen';

  @override
  String get examReadinessBandLabel => 'Geschätzte Bereitschaft';

  @override
  String get examScheduleTitle => 'Lernpartner finden';

  @override
  String get examBuddyListTab => 'Lernpartner-Liste';

  @override
  String get examMyRegistrationsTab => 'Meine Angaben';

  @override
  String get examBuddyListEmpty =>
      'Noch niemand hat einen Prüfungstermin registriert.';

  @override
  String examBuddyDaysUntil(int days) {
    return 'Noch $days Tage';
  }

  @override
  String get examBuddyPast => 'Bereits geprüft';

  @override
  String get examRegistrationAdd => 'Prüfungstermin hinzufügen';

  @override
  String get examRegistrationDelete => 'Prüfungstermin löschen';

  @override
  String get examRegistrationFormTitle => 'Prüfungstermin registrieren';

  @override
  String get examTypeLabel => 'Prüfungsart';

  @override
  String get examLevelLabel => 'Niveau';

  @override
  String get examDateLabel => 'Prüfungsdatum';

  @override
  String get examRegistrationSave => 'Speichern';

  @override
  String get communityExamsTitle => 'Community-Prüfungen';

  @override
  String get communityExamsEmpty => 'Noch keine Community-Prüfungen.';

  @override
  String get communityExamDetailTitle => 'Prüfungsdetails';

  @override
  String communityExamContributedBy(String name) {
    return 'Beigetragen von $name';
  }

  @override
  String get deThiListTitle => 'Öffentliche Prüfungen';

  @override
  String get deThiListEmpty => 'Noch keine öffentlichen Prüfungen.';

  @override
  String get deThiNotFound => 'Diese Prüfung wurde nicht gefunden.';

  @override
  String get deThiRevealAnswer => 'Antwort anzeigen';

  @override
  String deThiCorrectAnswer(String answer) {
    return 'Richtige Antwort: $answer';
  }

  @override
  String get examDictationPickerTitle => 'Hörprüfung auswählen';

  @override
  String get examDictationTitle => 'Diktatübung';

  @override
  String get examDictationNotFound =>
      'Für diese Prüfung gibt es noch keine Diktatdaten.';

  @override
  String get examDictationNoWords => 'Noch keine passenden Wörter zum Üben.';

  @override
  String get examDictationCheck => 'Prüfen';

  @override
  String examQuestionsCount(int count) {
    return '$count Fragen';
  }

  @override
  String examDurationMinutes(int count) {
    return '$count Min.';
  }

  @override
  String get practiceExam => 'Üben';

  @override
  String get examTestMode => 'Test';

  @override
  String get examReviewMode => 'Prüfen';

  @override
  String get couldNotPlayAudio =>
      'Audio konnte nicht abgespielt werden. Bitte versuche es erneut.';

  @override
  String get examListeningAudio => 'Hören';

  @override
  String get audioPlay => 'Audio abspielen';

  @override
  String get audioPause => 'Audio pausieren';

  @override
  String audioPlayCounter(int used, int max, String remaining) {
    return '$used/$max Wiedergaben · noch $remaining';
  }

  @override
  String get audioPlayLimitReached =>
      'Du hast alle erlaubten Wiedergaben verbraucht.';

  @override
  String get examResults => 'Ergebnis';

  @override
  String get couldNotLoadExamResult =>
      'Das Prüfungsergebnis konnte nicht geladen werden. Bitte versuche es erneut.';

  @override
  String get noExamResult => 'Für diese Prüfung gibt es noch kein Ergebnis.';

  @override
  String get passedExam => 'BESTANDEN';

  @override
  String get notPassedExam => 'NICHT BESTANDEN';

  @override
  String get examAnswered => 'Beantwortet';

  @override
  String examAnsweredQuestions(int answered, int total) {
    return '$answered/$total Fragen';
  }

  @override
  String get examTime => 'Zeit';

  @override
  String get examCorrectRate => 'Richtig beantwortet';

  @override
  String get examSectionAnalysis => 'Auswertung nach Teilen';

  @override
  String get examSectionReading => 'Lesen';

  @override
  String get examSectionListening => 'Hören';

  @override
  String examSectionSummary(int correct, int total, int minutes) {
    return '$correct/$total richtig · $minutes Min.';
  }

  @override
  String get reviewExam => 'Prüfung ansehen';

  @override
  String get retryExam => 'Erneut versuchen';

  @override
  String get examCorrect => 'Richtig';

  @override
  String get examNotCorrect => 'Nicht richtig';

  @override
  String examQuestionNumber(int number) {
    return 'Frage $number';
  }

  @override
  String matchingSelectRight(int number) {
    return 'Wähle rechts eine Zuordnung für Element $number';
  }

  @override
  String get removeMatch => 'Zuordnung entfernen';

  @override
  String examGapNumber(int number) {
    return 'Lücke $number';
  }

  @override
  String get takeMockExam => 'Probeprüfung';

  @override
  String get learn => 'Lernen';

  @override
  String get learningJourney => 'Lernreise';

  @override
  String get retryTodaySession => 'Heutige Lerneinheit neu laden';

  @override
  String get couldNotLoadTodayLesson =>
      'Die heutige Lektion konnte nicht geladen werden.';

  @override
  String get coursesTileTitle => 'Kurse';

  @override
  String get coursesHubTitle => 'Kurse';

  @override
  String get coursesFeaturedSection => 'Empfohlene Kurse';

  @override
  String get coursesMySection => 'In Bearbeitung';

  @override
  String get coursesAllSection => 'Alle Kurse';

  @override
  String get coursesEmptyCatalog => 'Noch keine Kurse vorhanden.';

  @override
  String coursesLessonsCount(int count) {
    return '$count Lektionen';
  }

  @override
  String coursesLessonsStarted(int count) {
    return '$count Lektionen begonnen';
  }

  @override
  String get coursesNoLessonsYet => 'Dieser Kurs hat noch keine Lektionen.';

  @override
  String get coursesLessonCompleted => 'Abgeschlossen';

  @override
  String get coursesMarkComplete => 'Als abgeschlossen markieren';

  @override
  String get coursesMarkIncomplete => 'Markierung entfernen';

  @override
  String get coursesVideoWebOnly =>
      'Das Video dieser Lektion ist derzeit nur im Web verfügbar.';

  @override
  String get coursesVocabularyTitle => 'Lektionswortschatz';

  @override
  String coursesExercisesHint(int count) {
    return '$count interaktive Übungen — verfügbar im Web.';
  }

  @override
  String get coursesNotesLabel => 'Deine Notizen';

  @override
  String get coursesNotesHint => 'Notizen zu dieser Lektion...';

  @override
  String get coursesNotesSave => 'Notiz speichern';

  @override
  String get coursesNotesSaved => 'Notiz gespeichert';

  @override
  String get coursesNotesSaveFailed =>
      'Notiz konnte nicht gespeichert werden, versuche es erneut.';

  @override
  String get coursesSignInRequired =>
      'Melde dich an, um Fortschritt und Notizen zu speichern.';

  @override
  String coursesLessonNumber(int number) {
    return 'Lektion $number';
  }

  @override
  String get missionComplete => 'Aufgabe abgeschlossen!';

  @override
  String get noMissionRounds =>
      'Die heutige Wortschatzlektion enthält keine Lernrunden.';

  @override
  String get startPractice => 'Übung beginnen';

  @override
  String get missionPractice => 'Üben';

  @override
  String get notRemembered => 'Nicht erinnert';

  @override
  String get rememberedCorrectly => 'Richtig erinnert';

  @override
  String get missionAnswerCorrect => 'Richtig!';

  @override
  String get missionAnswerTryAgain => 'Noch nicht ganz – weiter so!';

  @override
  String get saving => 'Wird gespeichert…';

  @override
  String get saveToDeck => 'In Stapel speichern';

  @override
  String get saved => 'Gespeichert';

  @override
  String get alreadySaved => 'Bereits gespeichert';

  @override
  String get wordSavedToDeck => 'Wort wurde im Stapel gespeichert.';

  @override
  String get openDeck => 'Stapel öffnen';

  @override
  String get couldNotSaveWord =>
      'Dieses Wort konnte nicht gespeichert werden. Melde dich an und versuche es erneut.';

  @override
  String get chooseDeck => 'Stapel auswählen';

  @override
  String get chooseDeckDescription =>
      'Speichere dieses Wort schnell oder wähle einen bestimmten Stapel.';

  @override
  String get quickSave => 'Schnell speichern';

  @override
  String get deviceSessionEnded => 'Deine Sitzung wurde beendet';

  @override
  String get deviceKickedBody =>
      'Dieses Gerät wurde abgemeldet. Bitte melde dich erneut an, um fortzufahren.';

  @override
  String get signInAgain => 'Erneut anmelden';

  @override
  String get wordNotFound => 'Dieses Wort wurde im Wörterbuch nicht gefunden.';

  @override
  String get lookingUpWord => 'Wort wird nachgeschlagen…';

  @override
  String get couldNotLookupWord =>
      'Dieses Wort kann gerade nicht nachgeschlagen werden. Bitte versuche es erneut.';

  @override
  String get meaning => 'Bedeutung';

  @override
  String get example => 'Beispiel';

  @override
  String get saveSentence => 'Satz speichern';

  @override
  String get sentenceSaved => 'Satz gespeichert';

  @override
  String get couldNotSaveSentence =>
      'Dieser Satz kann gerade nicht gespeichert werden.';

  @override
  String get couldNotSaveMissionRound =>
      'Diese Lernrunde konnte nicht gespeichert werden. Bitte versuche es erneut.';

  @override
  String get couldNotCompleteMission =>
      'Diese Aufgabe konnte nicht abgeschlossen werden. Bitte versuche es erneut.';

  @override
  String get score => 'Punkte';

  @override
  String get accuracy => 'Genauigkeit';

  @override
  String get playAgain => 'Nochmal spielen';

  @override
  String missionCompletedXp(int xp) {
    return 'Abgeschlossen · $xp XP';
  }

  @override
  String missionRoundsWords(int rounds, int words) {
    return '$rounds Runden · $words Wörter';
  }

  @override
  String get completed => 'Abgeschlossen';

  @override
  String get more => 'Mehr';

  @override
  String get moreFeaturesTitle => 'Alle Funktionen';

  @override
  String get close => 'Schließen';

  @override
  String get navConversation => 'Konversation';

  @override
  String get groupAccountOther => 'Konto & Mehr';

  @override
  String get featureYoutube => 'YouTube';

  @override
  String get featureReadListen => 'Lesen & Hören';

  @override
  String get featureListening => 'Hören';

  @override
  String get featureReadingFeed => 'Lesestoff';

  @override
  String get featureNews => 'Nachrichten';

  @override
  String get featureSubtitleWords => 'Untertitel-Wörter';

  @override
  String get featureFocusSession => 'Fokus-Sitzung';

  @override
  String get featureCasesHub => '4 Fälle üben';

  @override
  String get featureMinimalPairs => 'Minimalpaare';

  @override
  String get featureInterview => 'Interview';

  @override
  String get featureLearnerModel => 'Kompetenzprofil';

  @override
  String get featureExamReadiness => 'Prüfungsbereitschaft';

  @override
  String get featureErrorPatterns => 'Häufige Fehler';

  @override
  String get featureMessages => 'Nachrichten';

  @override
  String get featureFriends => 'Freunde';

  @override
  String get featureExamSchedule => 'Lernpartner finden';

  @override
  String get featureDailyQuote => 'Tageszitat';

  @override
  String get featureAffiliateIntro => 'Weiterempfehlen';

  @override
  String get featurePremiumUpgrade => 'Auf Premium upgraden';

  @override
  String get featureAdmin => 'Verwaltung';

  @override
  String get featureFeedback => 'Feedback';

  @override
  String get featureLeaderboardFull => 'Bestenliste';

  @override
  String get featureAiAssistant => 'KI-Assistent';

  @override
  String get groupVocabularyReview => 'Wortschatz & Wiederholung';

  @override
  String get groupExtraPractice => 'Weitere Übungen';

  @override
  String get groupGrammarSkills => 'Grammatik & Fähigkeiten';

  @override
  String get groupCommunityProgress => 'Community & Fortschritt';

  @override
  String get myWords => 'Meine Wörter';

  @override
  String get savedWords => 'Gespeichert';

  @override
  String get viewedWords => 'Angesehen';

  @override
  String get wordsToReview => 'Wiederholen';

  @override
  String get couldNotLoadMyWords =>
      'Deine Wörter konnten nicht geladen werden. Bitte versuche es erneut.';

  @override
  String get noWordsForFilter => 'In dieser Gruppe gibt es noch keine Wörter.';

  @override
  String myWordsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Wörter',
      one: '1 Wort',
      zero: 'Keine Wörter',
    );
    return '$_temp0';
  }

  @override
  String get flashcardDecks => 'Karteikartensätze';

  @override
  String get reviewDueDeckCards => 'Fällige Karten wiederholen';

  @override
  String get emptyDeckCards => 'Dieser Satz enthält noch keine Karten.';

  @override
  String get myDecks => 'Meine Karteikartensätze';

  @override
  String get createDeck => 'Satz erstellen';

  @override
  String get createNewDeck => 'Neuen Satz erstellen';

  @override
  String get editDeck => 'Satz bearbeiten';

  @override
  String get deleteDeck => 'Satz löschen';

  @override
  String deleteDeckConfirmation(Object name) {
    return 'Möchtest du \"$name\" wirklich löschen?';
  }

  @override
  String get couldNotLoadDecks =>
      'Deine Karteikartensätze konnten nicht geladen werden.';

  @override
  String get noDecks => 'Du hast noch keine Karteikartensätze';

  @override
  String get noDecksDescription =>
      'Erstelle einen Satz, um Themen deiner Wahl zu lernen.';

  @override
  String get deckName => 'Name des Satzes';

  @override
  String get deckNameHint => 'Zum Beispiel: Wortschatz für Reisen';

  @override
  String get deckDescriptionOptional => 'Beschreibung (optional)';

  @override
  String get deckDescriptionHint => 'Eine kurze Beschreibung dieses Satzes';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get delete => 'Löschen';

  @override
  String get save => 'Speichern';

  @override
  String wordsCount(int count) {
    return '$count Wörter';
  }

  @override
  String learnedWordsProgress(int learned, int total) {
    return '$learned/$total gelernt';
  }

  @override
  String get dailyReview => 'Tägliche Wiederholung';

  @override
  String get flashcardReview => 'Karteikarten wiederholen';

  @override
  String get tapToShowMeaning => 'Tippe, um die Bedeutung anzuzeigen';

  @override
  String get listenPronunciation => 'Aussprache anhören';

  @override
  String get couldNotLoadReviewData =>
      'Die Wiederholungsdaten konnten nicht geladen werden.';

  @override
  String get couldNotLoadReviewCards =>
      'Die Wiederholungskarten konnten nicht geladen werden.';

  @override
  String get noCardsDueToday => 'Heute sind keine Karten fällig 🎉';

  @override
  String get backToHome => 'Zurück zur Startseite';

  @override
  String reviewStreak(int count) {
    return '$count Tage in Folge! 🔥';
  }

  @override
  String get keepReviewStreak => 'Halte deine Serie mit täglicher Wiederholung';

  @override
  String get due => 'Fällig';

  @override
  String get reviewed => 'Wiederholt';

  @override
  String get startDailyReview => 'Wiederholung starten';

  @override
  String get showMeaning => 'Bedeutung anzeigen';

  @override
  String reviewProgress(int current, int total) {
    return '$current / $total';
  }

  @override
  String get couldNotSaveReview =>
      'Deine Wiederholung konnte nicht gespeichert werden. Bitte versuche es erneut.';

  @override
  String get ratingAgain => 'Nochmals';

  @override
  String get ratingAgainHint => '<1 Min.';

  @override
  String get ratingHard => 'Schwer';

  @override
  String get ratingHardHint => 'Schwer';

  @override
  String get ratingGood => 'Gut';

  @override
  String get ratingGoodHint => 'OK';

  @override
  String get ratingEasy => 'Leicht';

  @override
  String get ratingEasyHint => 'Leicht';

  @override
  String get vocabularyLibrary => 'Wortschatzbibliothek';

  @override
  String get vocabulary => 'Wortschatz';

  @override
  String get couldNotLoadVocabulary =>
      'Wortschatz konnte nicht geladen werden. Bitte versuche es erneut.';

  @override
  String get noVocabulary => 'Hier gibt es noch keinen Wortschatz.';

  @override
  String cefrLevelsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count CEFR-Stufen',
      one: '$count CEFR-Stufe',
    );
    return '$_temp0';
  }

  @override
  String get vocabularyByGoal => 'Nach Zielen';

  @override
  String get vocabularyByLevel => 'Nach Niveau';

  @override
  String get vocabularyByTopic => 'Nach Thema';

  @override
  String get learnByGoal => 'Nach Zielen lernen';

  @override
  String get learnByGoalDescription =>
      'Ziele sind schnelle Einstiege in dieselbe Wortschatzbibliothek nach Thema und Niveau.';

  @override
  String get goalDailyLife => 'Deutsch für den Alltag';

  @override
  String get goalSettlementHome => 'Ankommen & Wohnen';

  @override
  String get goalTravel => 'Reisen & Unterwegssein';

  @override
  String get goalFoodService => 'Essen & Restaurant';

  @override
  String get goalWork => 'Arbeit & Beruf';

  @override
  String get goalMedical => 'Gesundheit & Pflege';

  @override
  String get goalStudyExam => 'Lernen & Prüfungsvorbereitung';

  @override
  String cefrLevel(Object level) {
    return 'Niveau $level';
  }

  @override
  String get cefrBeginner => 'Anfänger:in';

  @override
  String get cefrPreIntermediate => 'Grundstufe';

  @override
  String get cefrIntermediate => 'Mittelstufe';

  @override
  String get cefrUpperIntermediate => 'Gute Mittelstufe';

  @override
  String get cefrAdvanced => 'Fortgeschritten';

  @override
  String get cefrProficient => 'Sehr fortgeschritten';

  @override
  String get noVocabularyTopics => 'Es gibt noch keine Wortschatzthemen.';

  @override
  String vocabularyTopicStats(Object label, int count) {
    return '$label · $count Wörter';
  }

  @override
  String vocabularyTopicTitle(Object topic) {
    return 'Wortschatz: $topic';
  }

  @override
  String get noVocabularyInLesson =>
      'In dieser Lektion gibt es noch keinen Wortschatz.';

  @override
  String get noMatchingVocabulary => 'Keine Wörter passen zu deinen Filtern.';

  @override
  String get clearVocabularyFilters => 'Versuche, einen Filter zu entfernen.';

  @override
  String get searchLessonVocabulary => 'Im Unterricht suchen…';

  @override
  String get allLevels => 'Alle';

  @override
  String lessonProgress(int learned, int total) {
    return 'Fortschritt: $learned / $total Wörter';
  }

  @override
  String get wordMeanings => 'Bedeutungen';

  @override
  String get wordExamples => 'Beispiele';

  @override
  String get viewVocabularyDetails => 'Details anzeigen';

  @override
  String get flipVocabularyCard => 'Karte umdrehen';

  @override
  String get noMeaning => 'Keine Bedeutung verfügbar';

  @override
  String get wordGender => 'Geschlecht';

  @override
  String get wordPlural => 'Plural';

  @override
  String get wordType => 'Wortart';

  @override
  String get auxiliaryVerb => 'Hilfsverb';

  @override
  String get comparative => 'Komparativ';

  @override
  String get superlative => 'Superlativ';

  @override
  String get verbConjugation => 'Verbkonjugation';

  @override
  String get principalForms => 'Stammformen';

  @override
  String get relatedWords => 'Verwandte Wörter';

  @override
  String get flashcardPractice => 'Karteikarten';

  @override
  String get practice => 'Üben';

  @override
  String get listeningPractice => 'Hörverstehen üben';

  @override
  String get newsReading => 'Nachrichten lesen';

  @override
  String get writingPractice => 'Schreiben üben';

  @override
  String get aiChat => 'KI-Chat';

  @override
  String get grammar => 'Grammatik';

  @override
  String get grammarSearchHint => 'Grammatiklektion suchen...';

  @override
  String get grammarNoResults => 'Keine Lektionen gefunden';

  @override
  String get grammarNoLessons => 'Noch keine Lektionen';

  @override
  String get grammarAllDone => '🎉 Alles geschafft!';

  @override
  String get grammarViewAll => 'Alle anzeigen';

  @override
  String get grammarMarkComplete => 'Als erledigt markieren';

  @override
  String get grammarCompleted => 'Erledigt';

  @override
  String get grammarAlreadyCompleted =>
      'Du hast diese Lektion bereits abgeschlossen.';

  @override
  String get grammarRelatedLessons => 'Verwandte Lektionen';

  @override
  String get grammarNotFound => 'Lektion nicht gefunden.';

  @override
  String get grammarArticleNotFound => 'Artikel nicht gefunden.';

  @override
  String get grammarArticles => 'Weiterführende Artikel';

  @override
  String get gamePractice => 'Lernspiele';

  @override
  String get community => 'Community';

  @override
  String get statistics => 'Statistiken';

  @override
  String get achievements => 'Erfolge';

  @override
  String get leaderboard => 'Rangliste';

  @override
  String get offlineMessage =>
      'Keine Internetverbindung. Einige Funktionen sind möglicherweise eingeschränkt.';

  @override
  String get appearance => 'Darstellung';

  @override
  String get themeMode => 'Darstellung';

  @override
  String get systemTheme => 'Systemeinstellung';

  @override
  String get lightTheme => 'Hell';

  @override
  String get darkTheme => 'Dunkel';

  @override
  String get sound => 'Audio';

  @override
  String get pronunciationVolume => 'Aussprachelautstärke';

  @override
  String get autoplayPronunciation => 'Aussprache automatisch abspielen';

  @override
  String get autoplayDescription => 'Audio beim Umdrehen einer Karte abspielen';

  @override
  String get language => 'Sprache';

  @override
  String get appLanguage => 'App-Sprache';

  @override
  String get selectLanguage => 'Sprache auswählen';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get learningReminders => 'Lernerinnerungen';

  @override
  String get learningRemindersDescription =>
      'Tägliche Lernerinnerungen erhalten';

  @override
  String get reminderTime => 'Erinnerungszeit';

  @override
  String get securityAndAccount => 'Sicherheit & Konto';

  @override
  String get security => 'Sicherheit';

  @override
  String get signedInDevices => 'Angemeldete Geräte';

  @override
  String get signOutOtherDevicesTitle => 'Von anderen Geräten abmelden?';

  @override
  String get signOutOtherDevicesBody =>
      'Alle anderen Sitzungen werden abgemeldet. Die aktuelle Sitzung auf diesem Gerät bleibt bestehen.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get signOut => 'Abmelden';

  @override
  String get signOutConfirm => 'Möchtest du dich wirklich abmelden?';

  @override
  String get signOutOtherDevices => 'Von allen anderen Geräten abmelden';

  @override
  String get signedOutOtherDevices => 'Von anderen Geräten abgemeldet.';

  @override
  String get signedOutDevice => 'Gerät abgemeldet.';

  @override
  String get signOutDeviceTitle => 'Dieses Gerät abmelden?';

  @override
  String signOutDeviceBody(Object device) {
    return 'Das Gerät \"$device\" wird von deinem Konto abgemeldet.';
  }

  @override
  String get couldNotSignOut =>
      'Abmeldung nicht möglich. Bitte versuche es erneut.';

  @override
  String get couldNotLoadDevices => 'Geräteliste konnte nicht geladen werden.';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get noSignedInDevices => 'Es sind keine Geräte angemeldet.';

  @override
  String get account => 'Konto';

  @override
  String get deleteAccount => 'Konto löschen';

  @override
  String get deleteAccountDescription =>
      'So forderst du die Löschung deines Kontos und zugehöriger Daten an.';

  @override
  String get accountDeletionUnavailableTitle =>
      'Kontolöschung in der App ist noch nicht verfügbar';

  @override
  String get accountDeletionUnavailableBody =>
      'Um die Löschung deines Kontos und zugehöriger Daten anzufordern, kontaktiere support@deutschtiger.com über deine registrierte E-Mail-Adresse. Die App kann keine Löschanfrage bestätigen, bis das Backend diesen Prozess unterstützt.';

  @override
  String get contactSupport => 'Support kontaktieren';

  @override
  String get unknownDevice => 'Unbekanntes Gerät';

  @override
  String get currentDevice => 'Aktuell';

  @override
  String get signOutThisDevice => 'Dieses Gerät abmelden';

  @override
  String get justNow => 'Gerade eben';

  @override
  String minutesAgo(int count) {
    return 'Vor $count Minuten';
  }

  @override
  String hoursAgo(int count) {
    return 'Vor $count Stunden';
  }

  @override
  String daysAgo(int count) {
    return 'Vor $count Tagen';
  }

  @override
  String get securityDevices => 'Sicherheit & Geräte';

  @override
  String get securityDevicesDescription =>
      'Sitzungen verwalten und Konto löschen';

  @override
  String get changePassword => 'Passwort ändern';

  @override
  String get changeEmail => 'E-Mail-Adresse ändern';

  @override
  String get exportData => 'Daten exportieren';

  @override
  String get exportDataDescription => 'Eine Kopie deiner Lerndaten anfordern';

  @override
  String get dataExportUnavailable =>
      'Der Datenexport in der App ist noch nicht verfügbar. Bitte kontaktiere support@deutschtiger.com.';

  @override
  String get couldNotOpenLink => 'Dieser Link konnte nicht geöffnet werden.';

  @override
  String get unexpectedDisplayError =>
      'Beim Anzeigen dieser Seite ist etwas schiefgelaufen.';

  @override
  String get openLinkError =>
      'Beim Öffnen des Links ist ein Fehler aufgetreten.';

  @override
  String get ratingThanks => 'Danke für deine Bewertung!';

  @override
  String get ai => 'KI';

  @override
  String get aiMemorySettings => 'KI-Speicher & Einstellungen';

  @override
  String get aiMemoryDescription => 'Niveau, Prüfungen und Grammatikhilfen';

  @override
  String get sendFeedback => 'Feedback senden';

  @override
  String get sendFeedbackDescription => 'Hilf uns, die App zu verbessern';

  @override
  String get feedbackTitle => 'Feedback senden';

  @override
  String get feedbackCategoryBug => 'Fehler melden';

  @override
  String get feedbackCategorySuggestion => 'Vorschlag';

  @override
  String get feedbackCategoryOther => 'Sonstiges';

  @override
  String get feedbackDescriptionHint => 'Beschreibe dein Feedback...';

  @override
  String get feedbackMessageRequired => 'Bitte gib dein Feedback ein.';

  @override
  String get feedbackSent => 'Vielen Dank für dein Feedback!';

  @override
  String get feedbackCouldNotSend =>
      'Feedback konnte nicht gesendet werden. Bitte versuche es erneut.';

  @override
  String get sendAction => 'Senden';

  @override
  String get about => 'Über die App';

  @override
  String get version => 'Version';

  @override
  String get termsOfService => 'Nutzungsbedingungen';

  @override
  String get privacyPolicy => 'Datenschutzerklärung';

  @override
  String get helpCenter => 'Hilfe';

  @override
  String get rateApp => 'App bewerten';

  @override
  String get statsScreenTitle => 'Lernstatistik';

  @override
  String get statsMasteryTitle => 'Vokabel-Gedächtnis';

  @override
  String get statsErrorPatternsTitle => 'Häufige Fehler';

  @override
  String get statsCurrentStreak => 'Aktuelle Serie';

  @override
  String get statsDaysUnit => 'Tage';

  @override
  String get statsCurrentLevel => 'Aktuelles Level';

  @override
  String get statsWordsLearned => 'Gelernte Wörter';

  @override
  String get statsTotalReviews => 'Wiederholungen gesamt';

  @override
  String get statsWeeklyXpChartTitle => 'XP der letzten 7 Tage';

  @override
  String get statsMasteryTrendEmpty =>
      'Noch keine täglichen Statistiken (wird jede Nacht aktualisiert).';

  @override
  String get statsErrorPatternsEmpty => 'Noch keine Fehlerdaten.';

  @override
  String get statsMasteryEmpty =>
      'Noch keine Daten. Wiederhole ein paar Wörter, um mit der Verfolgung zu beginnen.';

  @override
  String get statsMasteryNew => 'Neu';

  @override
  String get statsMasteryLearning => 'Lernen';

  @override
  String get statsMasteryYoung => 'Merken';

  @override
  String get statsMasteryMature => 'Gemeistert';

  @override
  String get statsMasteryTrendTitle => 'Wiederholungen der letzten 30 Tage';

  @override
  String get errorSourceSchreibenExam => 'Schreibprüfung';

  @override
  String get errorSourceSprechen => 'Sprechen';

  @override
  String get errorSourceSentenceBuilder => 'Satzübung';

  @override
  String get errorTypeArticleGender => 'Substantivgeschlecht (der/die/das)';

  @override
  String get errorTypeCaseAkkDat => 'Fall (Akkusativ/Dativ)';

  @override
  String get errorTypeVerbConjugation => 'Verbkonjugation';

  @override
  String get errorTypeVerbPosition => 'Verbstellung';

  @override
  String get errorTypeWordOrder => 'Wortstellung';

  @override
  String get errorTypePreposition => 'Präpositionen';

  @override
  String get errorTypePlural => 'Plural';

  @override
  String get errorTypeSpelling => 'Rechtschreibung';

  @override
  String get errorTypePunctuation => 'Zeichensetzung';

  @override
  String get errorTypeTenseConsistency => 'Tempuskonsistenz';

  @override
  String get errorTypeOther => 'Sonstiges';

  @override
  String get errorPatternsSortCount => 'Anzahl';

  @override
  String get errorPatternsSortRecent => 'Kürzlich';

  @override
  String get errorPatternsEmptyTitle => 'Noch keine Fehlerdaten';

  @override
  String get errorPatternsEmptyBody =>
      'Übe Satzbau oder mache eine Prüfung, um mit der Verfolgung zu beginnen!';

  @override
  String errorPatternsTimesCount(int count) {
    return '$count Mal';
  }

  @override
  String get errorPatternsExample => 'Beispiel';

  @override
  String get dailyQuoteTitle => 'Zitat des Tages';

  @override
  String get dailyQuoteCopySuccess => 'Zitat kopiert!';

  @override
  String get dailyQuoteExploreMore => 'Mehr entdecken';

  @override
  String get dailyQuoteRetryTooltip => 'Neu laden';

  @override
  String get back => 'Zurück';

  @override
  String get focusSessionTitle => 'Fokus-Sitzung';

  @override
  String focusSessionSummary(int count) {
    return 'Du hast heute $count Dinge zu üben.';
  }

  @override
  String get focusSessionDueWordsTitle => 'Fällige Wiederholungen';

  @override
  String get focusSessionDueWordsEmpty => 'Keine Wörter fällig 🎉';

  @override
  String get focusSessionReviewNow => 'Jetzt wiederholen';

  @override
  String get focusSessionExamFailTitle => 'Prüfungsfehler-Wörter';

  @override
  String get focusSessionExamFailEmpty => 'Noch keine Prüfungsdaten';

  @override
  String get focusSessionSubtitleWordsTitle => 'Wörter aus Videos';

  @override
  String get focusSessionSubtitleWordsEmpty =>
      'Noch keine Wörter aus Videos gesehen';

  @override
  String get focusSessionAddToReview => 'Zur Wiederholung hinzufügen';

  @override
  String get focusSessionWeaknessesTitle => 'Häufige Fehler';

  @override
  String get focusSessionWeaknessesEmpty =>
      'Noch keine Fehlerdaten — übe Schreiben für eine Analyse';

  @override
  String focusSessionWeaknessesCount(int count) {
    return '$count häufige Grammatikfehlertypen';
  }

  @override
  String get focusSessionCaughtUpTitle => 'Du machst das großartig!';

  @override
  String get focusSessionCaughtUpBody =>
      'Gerade keine Schwachstellen zu üben. Mach einen Test oder lerne neue Wörter für personalisierte Vorschläge.';

  @override
  String get learnerModelTitle => 'Lernerprofil';

  @override
  String get learnerModelCardsSuffix => 'Karten gemeistert';

  @override
  String get learnerModelMasteryHint =>
      'Gemeistert = stabile Erinnerung seit 21+ Tagen (FSRS).';

  @override
  String get learnerModelDueNow => 'Jetzt fällig';

  @override
  String get learnerModelWeakTotal => 'Schwachstellen';

  @override
  String get learnerModelTotalCards => 'Karten gesamt';

  @override
  String get learnerModelCoverageTitle => 'Abdeckung nach Niveau';

  @override
  String get learnerModelGrammarWeaknessesTitle => 'Grammatikschwächen';

  @override
  String learnerModelErrorCount(int count) {
    return '$count Fehler';
  }

  @override
  String get learnerModelCanDoSectionTitle => 'Was du auf Deutsch kannst';

  @override
  String get learnerModelCanDoEmpty =>
      'Noch keine Daten — übe Schreiben/Sprechen, um die Leiter hochzuklettern!';

  @override
  String get learnerModelWeakWordsTitle => 'Schwachstellen zum Üben';

  @override
  String get learnerModelWeakWordsEmpty =>
      'Keine Wörter brauchen zusätzliches Üben. Sehr gut!';

  @override
  String learnerModelLapsesCount(int count) {
    return '$count Aussetzer';
  }

  @override
  String get canDoStatusSpoken => 'Spricht es 🗣️';

  @override
  String get canDoStatusMastered => 'Kann es ✍️';

  @override
  String get canDoStatusInProgress => 'In Arbeit';

  @override
  String get canDoStatusNew => 'Nicht begonnen';

  @override
  String get canDoPracticeNow => 'Jetzt üben';

  @override
  String get canDoPracticeTitle => 'Ein Can-do üben';

  @override
  String canDoPracticeProgress(int current, int total) {
    return 'Satz $current/$total';
  }

  @override
  String canDoPracticeInstructionStructure(Object pattern) {
    return 'Schreibe einen Satz mit $pattern';
  }

  @override
  String canDoPracticeInstructionVocab(Object word) {
    return 'Schreibe einen Satz mit dem Wort «$word»';
  }

  @override
  String get canDoPracticeInputHint => 'Schreibe deinen deutschen Satz…';

  @override
  String get canDoPracticeError =>
      'Satz konnte nicht bewertet werden — versuche es gleich noch einmal.';

  @override
  String get canDoPracticeCorrectedPrefix => 'Korrigiert';

  @override
  String get canDoPracticeFinish => 'Fertig';

  @override
  String get canDoPracticeNext => 'Nächster Satz';

  @override
  String get canDoPracticeSubmitting => 'Wird bewertet…';

  @override
  String get canDoPracticeSubmit => 'Abschicken';

  @override
  String get canDoPracticeNotFound => 'Dieses Ziel wurde nicht gefunden.';

  @override
  String get canDoPracticeAllClear =>
      'Du hast alle Bausteine für dieses Ziel geschrieben 🎉';

  @override
  String canDoPracticeDone(int correct, int total) {
    return 'Fertig! $correct/$total Sätze bestanden — Fortschritt in der Karte gespeichert.';
  }

  @override
  String get topicExploreTitle => 'Nach Thema entdecken';

  @override
  String get topicExploreEmpty => 'Noch keine Themen.';

  @override
  String get practiceTitle => 'Übung';

  @override
  String get practiceChooseMode => 'Übungsmodus wählen';

  @override
  String get practiceModeCloze => 'Lücke füllen';

  @override
  String get practiceModeListening => 'Hörverstehen';

  @override
  String get practiceModeMatching => 'Zuordnen';

  @override
  String get practiceModeWriting => 'Schreiben';

  @override
  String get practiceClozeHint => 'Fehlendes deutsches Wort eingeben';

  @override
  String get practiceWritingHint => 'Deutsches Wort eingeben';

  @override
  String get practiceCheckAnswer => 'Prüfen';

  @override
  String get practiceListeningPrompt =>
      'Hören und die richtige Bedeutung wählen';

  @override
  String get practiceFeedbackCorrect => 'Richtig!';

  @override
  String practiceFeedbackWrong(String word) {
    return 'Falsch — die Antwort war \"$word\"';
  }

  @override
  String practiceMatchingProgress(int matched, int total, int attempts) {
    return '$matched/$total zugeordnet · $attempts Versuche';
  }

  @override
  String get practiceMatchingNeedsMoreWords =>
      'Dieses Set braucht mindestens 2 Wörter zum Zuordnen.';

  @override
  String get practiceResultsTitle => 'Fertig!';

  @override
  String practiceAccuracySummary(int correct, int total) {
    return '$correct/$total richtig';
  }

  @override
  String get practiceRestart => 'Erneut üben';

  @override
  String get practiceBackToDeck => 'Zurück zum Set';

  @override
  String get subtitleWordsTitle => 'Wörter aus Untertiteln';

  @override
  String get subtitleWordsEmpty =>
      'Noch keine neuen Wörter aus Untertiteln. Videos mit Untertiteln ansehen, um hier Wörter zu sammeln.';

  @override
  String subtitleWordsSeenCount(int count) {
    return '${count}x gesehen';
  }

  @override
  String subtitleWordsAddSelected(int count) {
    return '$count zur Wiederholung hinzufügen';
  }

  @override
  String subtitleWordsAddedCount(int count) {
    return '$count Wörter zur Wiederholungsliste hinzugefügt';
  }

  @override
  String get subtitleWordsAddFailed =>
      'Die ausgewählten Wörter konnten nicht gespeichert werden. Bitte erneut versuchen.';

  @override
  String get notificationMarkAllRead => 'Alle als gelesen markieren';

  @override
  String get notificationEmpty => 'Keine Benachrichtigungen';

  @override
  String get notificationLoadError =>
      'Benachrichtigungen konnten nicht geladen werden. Bitte versuche es erneut.';

  @override
  String get notificationSomeone => 'Jemand';

  @override
  String notificationFriendRequest(Object name) {
    return '$name hat dir eine Freundschaftsanfrage geschickt';
  }

  @override
  String notificationFriendAccepted(Object name) {
    return '$name hat deine Freundschaftsanfrage angenommen';
  }

  @override
  String notificationChallengeInvite(Object name) {
    return '$name hat dich herausgefordert';
  }

  @override
  String get notificationNewComment => 'Neuer Kommentar';

  @override
  String get notificationGradingDone => 'Die KI hat deinen Text bewertet';

  @override
  String get notificationDailyReview =>
      'Heute stehen Wörter zur Wiederholung an';

  @override
  String get notificationGeneric => 'Du hast eine neue Benachrichtigung';

  @override
  String get notificationPreferencesTitle => 'Benachrichtigungseinstellungen';

  @override
  String get notificationPreferencesEnabledTitle => 'Lernerinnerungen';

  @override
  String get notificationPreferencesEnabledDescription =>
      'Erhalte täglich eine Erinnerung zum Lernen';

  @override
  String get notificationPreferencesTime => 'Erinnerungszeit';

  @override
  String get notificationPreferencesContentMode =>
      'Inhalt der Benachrichtigung';

  @override
  String get notificationPreferencesContentWord => 'Vokabeln';

  @override
  String get notificationPreferencesContentReminder => 'Erinnerung';

  @override
  String get notificationPreferencesContentMix => 'Gemischt';

  @override
  String get notificationPreferencesSaveError =>
      'Konnte nicht gespeichert werden. Bitte versuche es erneut.';

  @override
  String get learningPreferencesTitle => 'Lerneinstellungen';

  @override
  String get learningPreferencesLevel => 'CEFR-Niveau';

  @override
  String get learningPreferencesDailyMinutes => 'Tägliche Lernminuten';

  @override
  String get learningPreferencesDailyXpGoal => 'Tägliches XP-Ziel';

  @override
  String get learningPreferencesSaveError =>
      'Konnte nicht gespeichert werden. Bitte versuche es erneut.';

  @override
  String get learningPreferencesLoadError =>
      'Lerneinstellungen konnten nicht geladen werden.';

  @override
  String get checkForUpdates => 'Nach Updates suchen';

  @override
  String get checkForUpdatesDescription =>
      'Prüfe, ob du die neueste Version nutzt';

  @override
  String get appUpToDate => 'Du nutzt die neueste Version';

  @override
  String get appUpdateAvailableTitle => 'Update verfügbar';

  @override
  String get appUpdateAvailableBody =>
      'Bitte aktualisiere die App, um sie weiter zu nutzen.';

  @override
  String get appUpdateAction => 'Jetzt aktualisieren';

  @override
  String get socialHubTitle => 'Community';

  @override
  String get socialTabMoments => 'Momente';

  @override
  String get socialTabFriends => 'Freunde';

  @override
  String get socialTabRequests => 'Anfragen';

  @override
  String get socialTabSearch => 'Suche';

  @override
  String get socialFriendsTitle => 'Freunde';

  @override
  String get socialMessagesTitle => 'Nachrichten';

  @override
  String get socialMomentsTitle => 'Momente';

  @override
  String get socialAnnouncementsTitle => 'Ankündigungen';

  @override
  String get socialProfileTitle => 'Profil';

  @override
  String get socialLoadFriendsError => 'Freunde konnten nicht geladen werden.';

  @override
  String get socialLoadRequestsError =>
      'Anfragen konnten nicht geladen werden.';

  @override
  String get socialLoadMessagesError =>
      'Nachrichten konnten nicht geladen werden.';

  @override
  String get socialLoadMomentsError => 'Momente konnten nicht geladen werden.';

  @override
  String get socialLoadCommentsError =>
      'Kommentare konnten nicht geladen werden.';

  @override
  String get socialLoadAnnouncementsError =>
      'Ankündigungen konnten nicht geladen werden.';

  @override
  String get socialLoadProfileError => 'Profil konnte nicht geladen werden.';

  @override
  String get socialSendMessageError =>
      'Nachricht konnte nicht gesendet werden. Bitte versuche es erneut.';

  @override
  String get socialSearchError => 'Suche fehlgeschlagen.';

  @override
  String get socialNoFriendsYet => 'Noch keine Freunde';

  @override
  String get socialNoPendingRequests => 'Keine offenen Anfragen';

  @override
  String get socialNoMessagesYet => 'Noch keine Nachrichten';

  @override
  String get socialNoMomentsYet => 'Noch keine Momente';

  @override
  String get socialNoCommentsYet => 'Noch keine Kommentare';

  @override
  String get socialNoAnnouncements => 'Derzeit keine Ankündigungen';

  @override
  String get socialSearchPrompt => 'Nach Namen suchen, um Freunde hinzuzufügen';

  @override
  String get socialSearchNoResults => 'Keine Nutzer gefunden';

  @override
  String get socialSearchHint => 'Freunde suchen…';

  @override
  String get socialChatAction => 'Chat';

  @override
  String get socialViewProfile => 'Profil ansehen';

  @override
  String get socialRemoveFriend => 'Freund entfernen';

  @override
  String get socialBlockUser => 'Blockieren';

  @override
  String socialBlockUserConfirm(String name) {
    return '$name blockieren? Diese Person kann dich danach nicht mehr kontaktieren.';
  }

  @override
  String get socialBlockUserConfirmGeneric =>
      'Diesen Nutzer blockieren? Er kann dich danach nicht mehr kontaktieren.';

  @override
  String get socialUserBlocked => 'Nutzer blockiert';

  @override
  String get socialUserBlockedNotice => 'Du hast diesen Nutzer blockiert.';

  @override
  String get socialAccept => 'Annehmen';

  @override
  String get socialDecline => 'Ablehnen';

  @override
  String get socialAddFriend => 'Freund hinzufügen';

  @override
  String get socialRequestSent => 'Anfrage gesendet';

  @override
  String get socialReportUser => 'Melden';

  @override
  String socialReportEmailSubject(String userId) {
    return 'Nutzer $userId melden';
  }

  @override
  String socialLevelLabel(int level) {
    return 'Level $level';
  }

  @override
  String get socialLevelShort => 'Level';

  @override
  String get socialStreakShort => 'Serie';

  @override
  String get socialFriendsShort => 'Freunde';

  @override
  String get socialStartChatting => 'Unterhaltung beginnen';

  @override
  String get socialTypeMessageHint => 'Nachricht eingeben…';

  @override
  String get socialCommentsTitle => 'Kommentare';

  @override
  String get pinnedShortcutsTitle => '🔗 Kurzbefehle';

  @override
  String get pinnedShortcutConversation => 'KI-Sprechtraining';

  @override
  String get pinnedShortcutWriteSentence => 'Satz schreiben (KI)';

  @override
  String get pinnedShortcutListening => 'Hören';

  @override
  String get pinnedShortcutYoutube => 'YouTube';

  @override
  String get pinnedShortcutCourse => 'Kurs';

  @override
  String get exploreSectionTitle => 'Entdecken';

  @override
  String get examCornerOverdue => '📅 Prüfungstermin verstrichen';

  @override
  String examCornerToday(String level) {
    return '🎯 Prüfung $level heute!';
  }

  @override
  String examCornerCountdown(String provider, String level, int days) {
    return '🎯 $provider $level · noch $days Tage';
  }

  @override
  String get examCornerReadiness => 'Bereitschaft';

  @override
  String get examCornerChangeGoal => 'Ziel ändern';

  @override
  String get examCornerContinue => 'Prüfung machen';

  @override
  String get examCornerSetNewGoal => 'Neues Ziel setzen';

  @override
  String get examGoalPromptTitle => 'Prüfungsziel setzen';

  @override
  String get examGoalPromptSubtitle =>
      'Lege einen Prüfungstermin fest, um den Countdown zu verfolgen und auf dem richtigen Niveau zu üben.';

  @override
  String get examGoalPromptCta => 'Prüfungstermin festlegen';

  @override
  String get examGoalSetterTitle => 'Prüfungsziel setzen';

  @override
  String get examGoalSetterProviderLabel => 'Prüfungsanbieter';

  @override
  String get examGoalSetterLevelLabel => 'Zielniveau';

  @override
  String get examGoalSetterDateLabel => 'Prüfungstermin';

  @override
  String get examGoalSetterDateRequired => 'Bitte einen Prüfungstermin wählen';

  @override
  String get examGoalSetterDateInPast =>
      'Der Prüfungstermin darf nicht vor heute liegen';

  @override
  String get examGoalSetterSave => 'Ziel speichern';

  @override
  String get examGoalSetterSaving => 'Wird gespeichert...';

  @override
  String get examGoalSetterSaveFailed =>
      'Speichern fehlgeschlagen, bitte erneut versuchen';

  @override
  String get premiumBannerCta => 'Auf Premium upgraden — unbegrenzt lernen';

  @override
  String get communityLinksTitle => 'Deutsch Tiger Community';

  @override
  String get communityZaloDescription => 'Deutsch-Lerngruppe';

  @override
  String get communityFacebookDescription => 'Deutsch Tiger VN';
}
