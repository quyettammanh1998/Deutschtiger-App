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
  String headerWordsLearned(int count) {
    return '📚 $count Wörter gelernt';
  }

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
  String get atLeastEightCharacters => 'Mindestens 8 Zeichen';

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
  String get passwordTooShortEight =>
      'Dein Passwort muss mindestens 8 Zeichen haben.';

  @override
  String get signupSubtitle => 'Erstelle ein Konto, um Deutsch zu lernen';

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
  String get verifyingResetLink => 'Wird überprüft...';

  @override
  String get resetLinkInvalid =>
      'Dieser Link zum Zurücksetzen des Passworts ist ungültig oder abgelaufen.';

  @override
  String get resendResetLink => 'Link erneut senden';

  @override
  String checkEmailForResetLink(String email) {
    return 'Prüfe $email, um dein Passwort zurückzusetzen.';
  }

  @override
  String get showPasswordTooltip => 'Passwort anzeigen';

  @override
  String get hidePasswordTooltip => 'Passwort verbergen';

  @override
  String get newPasswordHint => 'Mindestens 8 Zeichen';

  @override
  String get confirmPasswordHint => 'Neues Passwort wiederholen';

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
  String get leaderboardSubtitle =>
      'Miss dich beim wöchentlichen XP mit der Community und Freunden.';

  @override
  String get leaderboardWeeklyHeader => 'Wochenrangliste';

  @override
  String leaderboardResetCountdown(String countdown) {
    return 'Reset in $countdown';
  }

  @override
  String get leaderboardTabGlobal => 'Global';

  @override
  String get leaderboardTabFriends => 'Freunde';

  @override
  String get leaderboardHallOfFameToggle => 'Letzte Woche';

  @override
  String get leaderboardNoFriends =>
      'Noch keine Freunde in der Rangliste — füge Freunde hinzu, um zu vergleichen!';

  @override
  String get leaderboardFindFriends => 'Freunde finden →';

  @override
  String get leaderboardRankNew => 'Neu';

  @override
  String get leaderboardDetailTitle => 'Aufschlüsselung des Wochenscores';

  @override
  String get leaderboardDetailComposite => 'Gesamtpunktzahl';

  @override
  String get leaderboardDetailRawXp => 'Roh-XP';

  @override
  String get leaderboardDetailXp => 'Wochen-XP';

  @override
  String get leaderboardDetailExam => 'Prüfungspunkte';

  @override
  String get leaderboardDetailMission => 'Missionen';

  @override
  String get leaderboardDetailVocab => 'Wiederholte Wörter';

  @override
  String get leaderboardDetailStreak => 'Serie';

  @override
  String get leaderboardDetailTopContributor => 'Größter Beitrag';

  @override
  String get leaderboardDetailDampenedNote =>
      'Neue Konten haben vorübergehend einen reduzierten Rang. Schließe eine 3-Tage-Serie, 3 Missionen oder 1 Prüfung ab, um den vollen Rangwert freizuschalten.';

  @override
  String get leaderboardDetailViewProfile => 'Profil ansehen';

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
  String get examLandingSubtitle => 'Zertifikat & Niveau wählen';

  @override
  String get examBuddyCtaSubtitle =>
      'Verbinde dich mit jemandem, der am selben Tag prüft, um gemeinsam zu lernen';

  @override
  String get examShortDescTelc => 'Visum, Aufenthalt, Einbürgerung';

  @override
  String get examShortDescGoethe => 'International anerkanntes Zertifikat';

  @override
  String get examShortDescOsd => 'Österreichisches Deutschzertifikat';

  @override
  String get examRecommendedLabel => 'Empfohlen';

  @override
  String examLevelMismatchTitle(String level) {
    return 'Du bist aktuell auf Niveau $level';
  }

  @override
  String examLevelMismatchBody(String level) {
    return 'Die Prüfung $level könnte für dein aktuelles Niveau zu schwer sein. Trotzdem fortfahren?';
  }

  @override
  String get examLevelMismatchCancel => 'Abbrechen';

  @override
  String get examLevelMismatchContinue => 'Trotzdem fortfahren';

  @override
  String examSectionBundleCount(int count) {
    return '$count Prüfungssätze';
  }

  @override
  String get examBundleArapTitle => 'A-RAP';

  @override
  String get examBundleArapDesc =>
      'Offizielle Übungsprüfungen · Lesen · Hören · Schreiben · Sprachbausteine';

  @override
  String get examBundleSpeakingTitle => 'Sprechen';

  @override
  String get examBundleSpeakingDesc => 'Sprechen nach Themen üben';

  @override
  String get examBundleComingSoon => 'Bald verfügbar';

  @override
  String examSetCount(int count) {
    return '$count Prüfungssätze';
  }

  @override
  String examSetCompletedSuffix(int count) {
    return '$count abgeschlossen';
  }

  @override
  String examSetInProgressSuffix(int count) {
    return '$count in Bearbeitung';
  }

  @override
  String get examSetEmptyTitle => 'Noch keine Prüfungen';

  @override
  String get examSetEmptyBody =>
      'Für dieses Zertifikat und Niveau gibt es noch keine Prüfungen.';

  @override
  String get examSetPagePrev => 'Zurück';

  @override
  String get examSetPageNext => 'Weiter';

  @override
  String examSetPageIndicator(int current, int total) {
    return 'Seite $current / $total';
  }

  @override
  String examPartsCount(int count) {
    return '$count Teile';
  }

  @override
  String get examPartActionTest => 'Prüfungssimulation';

  @override
  String get examPartActionPractice => 'Üben';

  @override
  String get examSkillListEmptyTitle => 'Noch keine Prüfungen';

  @override
  String examSkillListEmptyBody(String skill) {
    return 'Es gibt noch keinen Teil $skill.';
  }

  @override
  String get examSkillListVocabChip => 'Wortschatz';

  @override
  String get examLocked => 'Gesperrt';

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
  String get coursesPremiumLabel => 'Premium';

  @override
  String get coursesViewContent => 'Inhalt ansehen';

  @override
  String get coursesUnlockArrow => 'Freischalten →';

  @override
  String get coursesViewArrow => 'Ansehen →';

  @override
  String get coursesHubSubtitle =>
      'Deutsch lernen mit Video + interaktiven Übungen der Deutschen Welle';

  @override
  String coursesCount(int count) {
    return '$count Kurse';
  }

  @override
  String coursesLessonsCountPlus(int count) {
    return '$count+ Lektionen';
  }

  @override
  String get coursesSearchHint => 'Kurse suchen...';

  @override
  String get coursesCollapse => 'Einklappen';

  @override
  String coursesShowMore(int count) {
    return '$count weitere Kurse anzeigen';
  }

  @override
  String coursesSearchResultsCount(int count, String query) {
    return '$count Ergebnisse für \"$query\"';
  }

  @override
  String coursesSearchNoResults(String query) {
    return 'Keine Ergebnisse für \"$query\"';
  }

  @override
  String coursesUpsellHubTitle(int count) {
    return 'Alle $count Kurse freischalten';
  }

  @override
  String coursesUpsellHubSubtitle(int limit) {
    return 'Du nutzt $limit kostenlose Kurse. Upgrade für Zugriff auf alle Inhalte.';
  }

  @override
  String get coursesUpsellCta => 'Upgrade';

  @override
  String coursesLevelHeading(String label) {
    return 'Level $label';
  }

  @override
  String get coursesLevelEmpty => 'Noch keine Daten für dieses Level.';

  @override
  String coursesLessonNumberShort(String number) {
    return 'Lektion $number';
  }

  @override
  String get coursesPaginationPrev => '← Zurück';

  @override
  String get coursesPaginationNext => 'Weiter →';

  @override
  String coursesPaginationInfo(int page, int totalPages, int start, int end) {
    return 'Seite $page/$totalPages · Zeige $start–$end';
  }

  @override
  String get coursesProgressTitle => 'Lernfortschritt';

  @override
  String get coursesProgressVideosWatched => 'Videos angesehen';

  @override
  String get coursesProgressLessonsStarted => 'Lektionen begonnen';

  @override
  String coursesUpsellDetailTitle(int count) {
    return 'Alle $count Lektionen freischalten.';
  }

  @override
  String coursesUpsellDetailSubtitle(int limit) {
    return 'Du siehst $limit kostenlose Lektionen.';
  }

  @override
  String get coursesLessonNotStarted => 'Nicht begonnen';

  @override
  String get coursesLessonNoVideo => 'Diese Lektion hat noch kein Video.';

  @override
  String get coursesLessonStripTitle => 'Lektionsliste';

  @override
  String get coursesTranscriptTitle => 'Untertitel';

  @override
  String get coursesTranscriptCopyDe => 'Deutsch kopieren';

  @override
  String get coursesTranscriptCopyVi => 'Vietnamesisch kopieren';

  @override
  String get coursesTranscriptHideVi => 'VI ausblenden';

  @override
  String get coursesTranscriptShowVi => 'VI anzeigen';

  @override
  String get coursesTranscriptEmpty =>
      'Diese Lektion hat noch keine Untertitel.';

  @override
  String coursesVocabularyCount(int count) {
    return 'Vokabeln ($count)';
  }

  @override
  String get coursesVocabularyEmpty =>
      'Diese Lektion hat noch keine Vokabelliste.';

  @override
  String get coursesCommentsTitle => 'Kommentare';

  @override
  String get coursesCommentsError => 'Kommentare konnten nicht geladen werden.';

  @override
  String get coursesCommentsEmpty => 'Noch keine Kommentare.';

  @override
  String get coursesCommentsPlaceholder => 'Kommentar schreiben...';

  @override
  String get coursesCommentsSendError =>
      'Kommentar konnte nicht gesendet werden, versuche es erneut.';

  @override
  String get coursesLessonVideoDone => '✓ Video abgeschlossen';

  @override
  String get coursesLessonMarkVideoDone =>
      '🎉 Video als abgeschlossen markieren';

  @override
  String get coursesLessonWatchHint =>
      '⏱️ Sieh mindestens 80% des Videos, um es abzuschließen';

  @override
  String get coursesLessonSaving => 'Speichern...';

  @override
  String get coursesProgressSaveCta => 'Fortschritt speichern';

  @override
  String get coursesProgressSaved => 'Fortschritt gespeichert';

  @override
  String get coursesProgressSaveFailed => 'Speichern fehlgeschlagen';

  @override
  String coursesLessonHeading(String number, String name) {
    return 'Lektion $number: $name';
  }

  @override
  String get coursesLockedLessonTitle => 'Lektion erfordert Premium';

  @override
  String get coursesLockedLessonDescription =>
      'Diese Lektion liegt außerhalb des kostenlosen Limits. Upgrade, um alle Inhalte freizuschalten.';

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
  String get missionResumeTitle => 'Unerledigtes fortsetzen';

  @override
  String get missionResumeContinueCta => 'Zur Vokabelrunde';

  @override
  String get missionCompleteTitle => 'Geschafft!';

  @override
  String get missionCompleteSubtitle =>
      'Vokabelschritt fertig — der heutige Pfad hat noch weitere Übungsschritte';

  @override
  String missionXpBadge(int xp) {
    return '+$xp XP';
  }

  @override
  String get missionClimbedTitle => 'Heute aufgestiegen:';

  @override
  String get missionStreakUpdated =>
      '🔥 Die heutige Streak wurde aktualisiert!';

  @override
  String get missionNextStepCta => 'Nächster Schritt →';

  @override
  String get missionMismatch =>
      'Sitzung stimmt nicht überein. Zurück zum Start.';

  @override
  String get missionAlreadyDoneToday =>
      'Die heutige Vokabellektion ist fertig 🎉 Zurück zum Pfad für den nächsten Schritt.';

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
  String get featurePronunciation => 'Aussprache';

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
  String deckListSubtitleWithFolders(int decks, int folders) {
    return '$decks Sätze · $folders Ordner';
  }

  @override
  String get deckIntroWhy =>
      'Wörter, die du selbst gespeichert hast, in Sätzen gruppiert.';

  @override
  String get deckIntroTodo =>
      'Öffne einen Satz zum Wiederholen oder füge neue Wörter hinzu.';

  @override
  String get deckIntroNext =>
      'Wörter kommen auch in den FSRS-Wiederholungsplan.';

  @override
  String get deckIntroNextLabel => 'Wiederholen';

  @override
  String get deckAllDecksTitle => 'Alle Sätze';

  @override
  String get deckQuickPracticeTitle => 'Schnellübung';

  @override
  String get deckQuickPracticeCta =>
      'Word Sprint mit deinen gespeicherten Wörtern spielen';

  @override
  String get deckStarredTitle => 'Favoriten';

  @override
  String get deckStarredSubtitle => 'Markierte Karten';

  @override
  String get deckFoldersTitle => 'Ordner';

  @override
  String get deckDefaultTooltip => 'Standardsatz';

  @override
  String get deckSetDefaultTooltip => 'Als Standard festlegen';

  @override
  String get deckDefaultBadge => 'Standard';

  @override
  String get deckMoveToFolder => 'In Ordner verschieben';

  @override
  String get deckActionCreateDeck => 'Satz erstellen';

  @override
  String get deckActionCreateDeckSubtitle => 'Neuen Wortschatz hinzufügen';

  @override
  String get deckActionCreateFolder => 'Ordner erstellen';

  @override
  String get deckActionCreateFolderSubtitle => 'Sätze in Gruppen organisieren';

  @override
  String get deckActionSpeak => 'Zu Notizen sprechen';

  @override
  String get deckActionSpeakSubtitle =>
      'Deutsch sprechen → jeder Satz wird eine Karte';

  @override
  String get deckFolderName => 'Ordnername';

  @override
  String get deckFolderNameHint => 'z. B. Wortschatz A1';

  @override
  String get deckNoFolder => 'Kein Ordner';

  @override
  String get deckNoSearchResults => 'Keine passenden Karten gefunden.';

  @override
  String get deckSearchHint => 'Wörter suchen...';

  @override
  String get deckStarredFilterTooltip => 'Nur Favoriten anzeigen';

  @override
  String get deckAddCard => 'Hinzufügen';

  @override
  String get deckCardFormRequired => 'Bitte Vorder- und Rückseite ausfüllen.';

  @override
  String get deckCardFormSaveError =>
      'Karte konnte nicht gespeichert werden. Bitte erneut versuchen.';

  @override
  String get deckEditCardTitle => 'Karte bearbeiten';

  @override
  String get deckNewCardTitle => 'Neue Karte hinzufügen';

  @override
  String get deckCardFrontLabel => 'Vorderseite (Deutsch)';

  @override
  String get deckCardFrontHint => 'z. B. das Haus';

  @override
  String get deckCardBackLabel => 'Rückseite (Vietnamesisch)';

  @override
  String get deckCardBackHint => 'z. B. Haus';

  @override
  String get deckCardExampleLabel => 'Beispielsatz (optional)';

  @override
  String get deckCardExampleHint => 'z. B. Das ist mein Haus.';

  @override
  String get deckCardExampleViLabel => 'Übersetzung des Beispiels (optional)';

  @override
  String get deckFolderEmpty => 'Dieser Ordner enthält noch keine Sätze.';

  @override
  String get deckStarredEmpty => 'Noch keine markierten Karten.';

  @override
  String get deckLessonTitle => 'Geführte Lektion';

  @override
  String deckLessonBatchProgress(int current, int total) {
    return 'Runde $current/$total';
  }

  @override
  String get deckBackToDeck => 'Zurück zum Satz';

  @override
  String get deckLessonBatchDoneTitle => 'Runde geschafft!';

  @override
  String deckLessonBatchDoneSubtitle(int correct, int total) {
    return '$correct/$total richtig';
  }

  @override
  String get deckLessonFinish => 'Fertig';

  @override
  String get deckLessonNextBatch => 'Nächste Runde';

  @override
  String get deckPlayCta => 'Spielen';

  @override
  String get deckLearnCta => 'Lernen';

  @override
  String get deckSpeakTitle => 'Zu Notizen sprechen';

  @override
  String get deckSpeakHelper =>
      'Sprich oder tippe Deutsch — jeder Satz wird eine Karteikarte.';

  @override
  String get deckSpeakMicTooltip => 'Zum Starten der Aufnahme antippen';

  @override
  String get deckSpeakMicComingSoon => 'Sprachaufnahme kommt bald';

  @override
  String get deckSpeakTextareaHint => 'Jede Zeile wird eine Karte...';

  @override
  String get deckSpeakDeckNameLabel => 'Name des Satzes';

  @override
  String get deckSpeakDeckNameHelper =>
      'Jeder Satz wird eine Karte in diesem Satz.';

  @override
  String deckSpeakSavedMessage(int count) {
    return '$count Sätze in einem neuen Satz gespeichert.';
  }

  @override
  String get deckSpeakViewDeck => 'Satz ansehen →';

  @override
  String get deckSpeakEmptyError =>
      'Gib mindestens einen Satz ein, bevor du speicherst.';

  @override
  String get deckSpeakSaveError =>
      'Konnte nicht gespeichert werden. Bitte erneut versuchen.';

  @override
  String get deckSpeakSaveCta => 'In Notizen speichern';

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
  String dailyReviewRoundLabel(int current, int total) {
    return 'Runde $current/$total';
  }

  @override
  String dailyReviewRoundWordCount(int count) {
    return '$count Wörter';
  }

  @override
  String get dailyReviewRoundStart => 'Starten';

  @override
  String dailyReviewRoundDone(String gameName) {
    return '$gameName fertig!';
  }

  @override
  String dailyReviewRoundProgress(int reviewed, int total) {
    return '$reviewed/$total Wörter wiederholt';
  }

  @override
  String get dailyReviewRoundFinish => 'Ergebnisse ansehen';

  @override
  String get dailyReviewRoundContinue => 'Weiter';

  @override
  String get dailyReviewRetryBanner =>
      'Wiederhole die Wörter, die du gerade geübt hast.';

  @override
  String get dailyReviewEmptyTitle => 'Keine Wörter zu wiederholen!';

  @override
  String get dailyReviewEmptySubtitle => 'Komm später wieder oder übe mehr';

  @override
  String get dailyReviewSessionLabel => 'Wiederholungssitzung';

  @override
  String get dailyReviewStatusExcellent => 'Ausgezeichnet';

  @override
  String get dailyReviewStatusGood => 'Ziemlich gut';

  @override
  String get dailyReviewStatusNeedsWork => 'Braucht mehr Übung';

  @override
  String get dailyReviewCompletedTitle => 'Fertig!';

  @override
  String get dailyReviewWeakWordsTitle => 'Wörter zum Wiederholen';

  @override
  String get dailyReviewCtaMore => 'Mehr wiederholen';

  @override
  String dailyReviewCtaRetryWeak(int count) {
    return '$count schwache Wörter üben';
  }

  @override
  String get dailyReviewCtaContinueLearning => 'Weiterlernen';

  @override
  String get dailyReviewCtaListening => '🎧 Hörverständnis üben';

  @override
  String get dailyReviewCtaAskAi => '✨ KI zu schwierigen Wörtern fragen';

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
  String get goalTechEngineering => 'Technik & Ingenieurwesen';

  @override
  String get goalShoppingBeauty => 'Einkaufen & Schönheit';

  @override
  String get goalFamilySocial => 'Familie & Beziehungen';

  @override
  String get goalLeisureCulture => 'Freizeit & Kultur';

  @override
  String get goalNatureEnvironment => 'Natur & Umwelt';

  @override
  String get vocabularyMine => 'Meine';

  @override
  String get vocabularyIntroWhy =>
      'Der System-Wortschatz — wähle ein Set zum Lernen und Wiederholen.';

  @override
  String get vocabularyIntroTodo => 'Öffne ein Set, um neue Karten zu lernen.';

  @override
  String get vocabularyIntroNext =>
      'Gelernte Wörter kommen in deinen Wiederholungsplan.';

  @override
  String get vocabularyIntroNextLabel => 'Wiederholung';

  @override
  String get vocabularyChooseGroupLabel => 'Themengruppe wählen';

  @override
  String vocabularyGoalTopicsCount(int count) {
    return '$count Themen';
  }

  @override
  String get vocabularyTopicSectionTitle => '📚 Wortschatzthemen';

  @override
  String get vocabularyTopicSectionDescription =>
      'Wähle eine Themengruppe und öffne dann jedes Unterthema nach Niveau.';

  @override
  String get vocabularyLevelSectionTitle => '🎯 GER-Niveaus';

  @override
  String get vocabularyLevelSectionDescription =>
      'Öffne ein Niveau und filtere nach Thema, oder tippe unten auf einen Themen-Chip.';

  @override
  String get vocabularyTipTitle => 'Lerntipp';

  @override
  String get vocabularyTipNext => 'Weiter';

  @override
  String get wordSprintSectionTitle => '⚡ Nach Thema üben';

  @override
  String get wordSprintStart => 'Start';

  @override
  String get wordSprintDescription => '60 Sekunden · 4 Antworten · Combo x3';

  @override
  String get vocabularySearchHint => 'Wörter suchen...';

  @override
  String get vocabularyWeakFilter => 'Schwach';

  @override
  String vocabularyMasteredCount(int done, int total) {
    return '$done/$total beherrscht';
  }

  @override
  String get vocabularyTabList => 'Liste';

  @override
  String get vocabularyTabMyWords => 'Meine Wörter';

  @override
  String get vocabularyStartLesson => 'Neue Wörter lernen';

  @override
  String get vocabularyNotFound => 'Wortset nicht gefunden';

  @override
  String get vocabularyMasteryMastered => 'Beherrscht';

  @override
  String get vocabularyMasteryKnown => 'Bekannt';

  @override
  String get vocabularyMasteryLearning => 'Lernend';

  @override
  String get vocabularyMasteryNew => 'Neu';

  @override
  String get myWordsGroupReviewing => 'In Wiederholung';

  @override
  String get myWordsGroupSaved => 'Im Notizbuch';

  @override
  String get myWordsGroupSeen => 'Gesehen';

  @override
  String myWordsSourceLabel(Object source) {
    return 'Quelle: $source';
  }

  @override
  String myWordsMoreCount(int count) {
    return '+$count weitere in dieser Gruppe';
  }

  @override
  String get myWordsEmptyTitle => 'Noch keine Wörter in deinem Bestand';

  @override
  String get myWordsEmptyDescription =>
      'Schlage Wörter beim Lesen/Ansehen nach oder speichere sie in deinem Notizbuch — sie erscheinen hier.';

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
  String grammarSearchInLevelHint(String level) {
    return 'In $level suchen...';
  }

  @override
  String grammarSearchResultsCount(int count, String query) {
    return '$count Ergebnisse für „$query“ — alle Niveaus';
  }

  @override
  String get grammarLeaderboardTitleAll => 'Bestenliste';

  @override
  String grammarLeaderboardTitleLevel(String level) {
    return 'Bestenliste $level';
  }

  @override
  String get grammarProgressLabel => 'Fortschritt';

  @override
  String grammarProgressLabelLevel(String level) {
    return 'Fortschritt $level';
  }

  @override
  String get grammarLeaderboardEmpty => 'Noch niemand dabei';

  @override
  String grammarYourRank(int rank, int count) {
    return 'Dein Rang: #$rank · $count Lektionen';
  }

  @override
  String grammarCompletedOfTotal(int done, int total) {
    return '$done/$total Lektionen abgeschlossen';
  }

  @override
  String grammarReadTime(int elapsed, int minTime) {
    return '⏱ ${elapsed}s / ${minTime}s';
  }

  @override
  String get grammarScrolled80 => '📜 80% gescrollt';

  @override
  String get grammarScrollNeeded => '📜 Bis 80% scrollen nötig';

  @override
  String get grammarReadGateHint =>
      'Der Button wird aktiv, sobald du 80% des Inhalts gescrollt und die Mindestzeit gelesen hast.';

  @override
  String get grammarMarkCompleteXp => 'Als erledigt markieren (+5 XP)';

  @override
  String get grammarMarkCompleteAgain => 'Erneut abschließen';

  @override
  String get grammarJustCompleted => '✓ Erledigt';

  @override
  String get grammarSaving => 'Wird gespeichert...';

  @override
  String get grammarArticleSource => 'Quelle: deutsch.vn';

  @override
  String get grammarPracticeExercises => 'Übungen';

  @override
  String get grammarExerciseCorrect => '✓ Richtig!';

  @override
  String grammarExerciseWrong(String answer) {
    return '✗ Falsch. Richtige Antwort: $answer.';
  }

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
  String get statsScreenSubtitle =>
      'Verfolge deinen Fortschritt, deine Gewohnheiten und deine tägliche Leistung.';

  @override
  String get statsOverviewLevelNote => 'Schaltet neue Inhalte frei';

  @override
  String get statsOverviewTotalXp => 'Gesamt-XP';

  @override
  String get statsOverviewXpNote => 'Angesammelte Erfahrungspunkte';

  @override
  String get statsOverviewStreakNote => 'Ununterbrochene Lernserie';

  @override
  String get statsOverviewBestStreak => 'Beste Serie';

  @override
  String get statsOverviewBestStreakNote => 'Persönlicher Rekord';

  @override
  String get statsProgressLevelTitle => 'Level-Fortschritt';

  @override
  String statsProgressLevelSubtitle(int level, int nextLevel) {
    return 'Level $level zu $nextLevel';
  }

  @override
  String statsProgressLevelRemaining(int count) {
    return 'Noch $count XP bis zum nächsten Level.';
  }

  @override
  String get statsProgressDailyTitle => 'Heutiges XP-Ziel';

  @override
  String get statsProgressDailySubtitle =>
      'Bleib bei deiner täglichen Lerngewohnheit';

  @override
  String get statsProgressDailyDone => 'Du hast das heutige Ziel erreicht.';

  @override
  String statsProgressDailyRemaining(int count) {
    return 'Noch $count XP bis zum Ziel.';
  }

  @override
  String statsXpChartWeekTotal(int total) {
    return 'Gesamt diese Woche: $total XP';
  }

  @override
  String statsXpChartMax(int max) {
    return 'Höchstwert: $max XP';
  }

  @override
  String get statsOnlineTimeTitle => 'Online-Zeit — letzte 7 Tage';

  @override
  String statsOnlineTimeWeekTotal(String duration) {
    return 'Gesamt diese Woche: $duration';
  }

  @override
  String statsOnlineTimeToday(String duration) {
    return 'Heute: $duration';
  }

  @override
  String get statsReviewCardsTitle => 'Wiederholungsstatistik';

  @override
  String get statsReviewToday => 'Wiederholungen heute';

  @override
  String get statsReviewTodayNote => 'Heute abgeschlossene Wiederholungen';

  @override
  String get statsReviewWeek => 'Wiederholungen diese Woche';

  @override
  String get statsReviewWeekNote => 'Gesamt über 7 Tage';

  @override
  String get statsReviewAccuracy => 'Genauigkeit';

  @override
  String get statsReviewAccuracyNote => 'Anteil richtiger Antworten';

  @override
  String get statsReviewDue => 'Fällige Wiederholungen';

  @override
  String get statsReviewDueNote => 'Fällige Karten';

  @override
  String get statsSuggestionsTitle => 'Verbesserungsvorschläge';

  @override
  String get statsSuggestionStreak => 'Starte heute eine neue Serie!';

  @override
  String get statsSuggestionListening =>
      'Diese Woche noch kein Hörverständnis geübt!';

  @override
  String get statsSuggestionReviewAll =>
      'Übe alle 3 Fertigkeiten gleichmäßig für schnelleren Fortschritt!';

  @override
  String get statsSpacedRepetitionTitle =>
      'Wie funktioniert Spaced Repetition?';

  @override
  String get statsSpacedRepetitionBody =>
      'Das System nutzt den SM-2-Algorithmus, um deinen Wiederholungsplan zu optimieren. Wörter, die du gut kannst, erscheinen seltener, schwierige Wörter kommen früher wieder. So sparst du Zeit und merkst dir Inhalte langfristig besser.';

  @override
  String get statsCefrTitle => 'Kompetenzprofil';

  @override
  String get statsCefrA1 => 'Anfänger';

  @override
  String get statsCefrA2 => 'Grundlegende Kenntnisse';

  @override
  String get statsCefrB1 => 'Fortgeschrittene Sprachverwendung';

  @override
  String get statsCefrB2 => 'Selbstständige Sprachverwendung';

  @override
  String get statsCefrC1 => 'Fachkundige Sprachkenntnisse';

  @override
  String get statsCefrC2 => 'Annähernd muttersprachliche Kenntnisse';

  @override
  String statsCefrWordsLearned(int count) {
    return '$count Wörter wiederholt';
  }

  @override
  String get statsNearAchievementsTitle => 'Fast geschafft';

  @override
  String get statsAchievementsGridTitle => 'Erfolgssammlung';

  @override
  String get statsLeaderboardTableTitle => 'Rangliste';

  @override
  String statsLeaderboardTop(int count) {
    return 'Top $count';
  }

  @override
  String get statsLeaderboardYou => 'Du';

  @override
  String get errorPatternsSubtitle =>
      'Grammatikfehler-Übersicht aus deinen Schreib-, Sprech- und Prüfungsantworten.';

  @override
  String get errorPatternsIntroWhy =>
      'Eine Zusammenfassung häufiger Fehler beim Schreiben, von der KI bewertet.';

  @override
  String get errorPatternsIntroTodo =>
      'Wähle einen Fehlertyp aus und übe genau diesen.';

  @override
  String get errorPatternsIntroNext =>
      'Behebst du einen Fehlertyp, tritt er seltener auf.';

  @override
  String get errorPatternsDrillWriting => 'Schreiben üben';

  @override
  String get errorPatternsDrillArtikel => 'Der/Die/Das üben';

  @override
  String get errorPatternsDrillSentenceBuilder => 'Sätze üben';

  @override
  String get errorPatternsDrillWordOrder => 'Wortstellung üben';

  @override
  String get errorPatternsDrillPreposition => 'Präpositionen üben';

  @override
  String get errorPatternsDrillNoun => 'Substantive wiederholen';

  @override
  String get errorPatternsDrillSpelling => 'Rechtschreibung üben';

  @override
  String get errorPatternsDrillGrammar => 'Grammatik wiederholen';

  @override
  String get errorPatternsDrillTense => 'Zeitformen üben';

  @override
  String get errorPatternsDrillExam => 'Prüfung machen';

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
  String get focusSessionSubtitle =>
      'Das solltest du jetzt üben, basierend auf deinen echten Schwachstellen.';

  @override
  String get focusSessionGoalDefaultCta =>
      'Prüfungsziel setzen für einen genaueren Pfad →';

  @override
  String focusSessionGoalWithDays(String level, int days) {
    return '🎯 Weil du $level in $days Tagen machst';
  }

  @override
  String focusSessionGoalNoDays(String level) {
    return '🎯 Wegen deines $level-Ziels';
  }

  @override
  String get focusSessionNoHistoryTitle =>
      'Nicht genug Daten für Schwachstellen';

  @override
  String get focusSessionNoHistoryBody =>
      'Du hast noch keine Wiederholungshistorie — speichere ein paar Wörter und mach eine Wiederholung, damit das System deine echten Schwachstellen erkennt.';

  @override
  String get focusSessionSaveWordsCta => 'Neue Wörter speichern';

  @override
  String get focusSessionReviewNowCta => 'Jetzt wiederholen';

  @override
  String get focusSessionLearnNewWordsCta => 'Neue Wörter lernen';

  @override
  String get focusSessionWeaknessesFooterLink => 'Häufige Fehler ansehen';

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
  String get learnerModelSubtitle =>
      'Beherrschung, Can-do-Punkte und Verbesserungsbereiche.';

  @override
  String get learnerModelReadinessTitle => 'Geschätzte Prüfungsbereitschaft';

  @override
  String get learnerModelReadinessBasis =>
      'Basierend auf: deinen letzten Übungsprüfungsergebnissen.';

  @override
  String get learnerModelReadinessNoData =>
      'Noch nicht genug Daten — mach ein paar Übungsprüfungen, um die Bereitschaft zu schätzen.';

  @override
  String learnerModelLevelPracticeCta(String level) {
    return 'Niveau $level üben →';
  }

  @override
  String get learnerModelWeeklyRecapTitle => 'Die letzte Woche';

  @override
  String get learnerModelWeeklyRecapEmpty =>
      'Diese Woche noch kein Aufstieg — übe mehr, um aufzusteigen!';

  @override
  String learnerModelWeeklyRecapStreak(int days) {
    return '🔥 $days-Tage-Produktionsserie';
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
  String get canDoPracticeBackLink => '← Kompetenzkarte';

  @override
  String get canDoPracticeBackToMap => 'Zurück zur Kompetenzkarte';

  @override
  String get canDoPracticeGoConversation => 'Konversation üben';

  @override
  String get topicExploreTitle => 'Nach Thema entdecken';

  @override
  String get topicExploreSubtitle =>
      'Priorisierte Wortschatzrichtungen ansehen · mit ⭐ anheften, um den Pfad zu steuern';

  @override
  String get learnPageIntroWhy =>
      'Hier lernst du jeden Tag Wortschatz und Grammatik nach deinem persönlichen Pfad.';

  @override
  String get learnPageIntroTodo =>
      'Mach die heutige Einheit, verfolge den A1→C2-Fortschritt und die Wochenmissionen.';

  @override
  String get learnPageIntroNext =>
      'Wenn die heutige Einheit fertig ist, komm für die nächste Mission zurück.';

  @override
  String get learnPageIntroCta => 'Zur Wiederholung';

  @override
  String get levelJourneyTitle => 'A1→C2-Reise';

  @override
  String get levelJourneyEmptyLevel => 'kommt bald';

  @override
  String get levelJourneyDetailCta => 'Details →';

  @override
  String get capabilityMapSnapshotTitle => 'Kompetenzkarte';

  @override
  String capabilityMapMasteredCount(int mastered, int total) {
    return '$mastered/$total Can-do-Punkte';
  }

  @override
  String get capabilityMapViewCta => 'Karte ansehen →';

  @override
  String get topicExploreEmpty => 'Noch keine Themen.';

  @override
  String get topicExploreSubtitleHeader =>
      'Wähle ein Thema, um Wortschatz in deiner benötigten Richtung zu üben.';

  @override
  String get topicSteeringTitle => 'Aktuell priorisierter Pfad';

  @override
  String get topicSteeringGoalGoethe => '🎓 Goethe-Prüfung';

  @override
  String get topicSteeringGoalConversation => '💬 Konversation';

  @override
  String get topicSteeringGoalNursing => '🏥 Pflege';

  @override
  String get topicSteeringGoalAbroad => '✈️ Studium/Arbeit im Ausland';

  @override
  String get topicSteeringEmpty =>
      'Noch kein Ziel gewählt — hefte unten ein Thema an, um deinen Pfad zu steuern.';

  @override
  String get topicSteeringFooterHint =>
      'Angeheftete ⭐ Themen werden in deiner täglichen Einheit priorisiert.';

  @override
  String topicGroupSubtitle(String label, int count) {
    return '$label · $count Themen';
  }

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
      'Karte antippen, um sie umzudrehen und die Bedeutung zu sehen';

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
  String get practiceChangeMode => 'Modus ändern';

  @override
  String get practiceBackToGames => 'Zurück zu Spielen';

  @override
  String get practiceNotEnoughWords => 'Gerade nicht genug Wörter zum Üben.';

  @override
  String get practiceListenPill => 'Anhören';

  @override
  String get practiceHintPill => 'Tipp';

  @override
  String practiceHintLetter(String letter) {
    return 'Beginnt mit \"$letter\"';
  }

  @override
  String get practiceRetryAnswer => 'Erneut versuchen';

  @override
  String get practiceMicTooltip => 'Zum Antworten sprechen';

  @override
  String get practiceListeningNotYet => 'Noch nicht';

  @override
  String get practiceListeningKnown => 'Ich wusste es';

  @override
  String get practiceListeningTapToFlip => '👆 Antippen zum Umdrehen';

  @override
  String get practiceListeningMeaningLabel => 'Bedeutung';

  @override
  String get practiceMatchingColumnDe => 'DEUTSCH';

  @override
  String get practiceMatchingColumnVi => 'VIETNAMESISCH';

  @override
  String get subtitleWordsTitle => 'In Videos gesehene Wörter';

  @override
  String get subtitleWordsSubtitle =>
      'Wörter, die du beim Videoschauen gesehen hast — mit einem Tipp zur Wiederholung hinzufügen.';

  @override
  String get subtitleWordsEmpty =>
      'Noch keine Untertitel-Wörter zum Hinzufügen.';

  @override
  String get subtitleWordsEmptyHint =>
      'Schau deutsche Videos und tippe auf Wörter, um sie hier zu speichern!';

  @override
  String subtitleWordsSeenCount(int count) {
    return '${count}x gesehen';
  }

  @override
  String get subtitleWordsLevelAll => 'Alle';

  @override
  String subtitleWordsLevelCount(String level, int count) {
    return '$level · $count';
  }

  @override
  String subtitleWordsSelectedCount(int count) {
    return '$count ausgewählt';
  }

  @override
  String subtitleWordsCountLabel(int count) {
    return '$count Wörter';
  }

  @override
  String get subtitleWordsSelectAll => 'Alle auswählen';

  @override
  String get subtitleWordsClearSelection => 'Auswahl aufheben';

  @override
  String subtitleWordsAddSelected(int count) {
    return '$count Wörter zur Wiederholung hinzufügen';
  }

  @override
  String get subtitleWordsAdding => 'Wird hinzugefügt...';

  @override
  String subtitleWordsAddedCount(int count) {
    return '$count Wörter hinzugefügt!';
  }

  @override
  String get subtitleWordsAddFailed =>
      'Die ausgewählten Wörter konnten nicht gespeichert werden. Bitte erneut versuchen.';

  @override
  String get practiceModeComingSoon => 'Demnächst';

  @override
  String get practiceModeSentence => 'Sätze schreiben';

  @override
  String get practiceModeSentenceDesc => 'Hören + einen ganzen Satz übersetzen';

  @override
  String get practiceModeClozeDesc => 'Das fehlende Wort einfügen';

  @override
  String get practiceModeListeningDesc =>
      'Hören und die Karte zum Raten umdrehen';

  @override
  String get practiceModeMatchingDesc =>
      'Deutsche Wörter mit ihrer Bedeutung verbinden';

  @override
  String get practiceModeWritingDesc =>
      'Hören + Bedeutung sehen → das deutsche Wort tippen';

  @override
  String get practiceModeRunner => 'Deutsch Runner';

  @override
  String get practiceModeRunnerDesc => 'Ein Vokabelspiel spielen';

  @override
  String get practiceModeFade => 'Ausblenden';

  @override
  String get practiceModeFadeDesc =>
      'Text blendet aus — den ganzen Satz erneut tippen';

  @override
  String get practiceModeDictation => 'Diktat';

  @override
  String get practiceModeDictationDesc =>
      'Einen Satz hören und Wort für Wort tippen';

  @override
  String get practiceModeChaining => 'Satzkette';

  @override
  String get practiceModeChainingDesc =>
      'Die Reihenfolge merken: dieser Satz → der nächste';

  @override
  String get practiceModeGist => 'Aus der Bedeutung schreiben';

  @override
  String get practiceModeGistDesc =>
      'Bedeutung + Hinweis sehen → den Satz umschreiben';

  @override
  String get practiceModeSpeaking => 'Sprechen';

  @override
  String get practiceModeSpeakingDesc =>
      'Den Satz laut vorlesen, bewertet werden';

  @override
  String get practiceIncludeGraduated => 'Gelernte Wörter einbeziehen';

  @override
  String practiceCardsReady(int count) {
    return '$count Karten bereit';
  }

  @override
  String practiceXpEarned(int xp) {
    return '+$xp XP';
  }

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
  String socialRemoveFriendConfirm(String name) {
    return '$name aus deiner Freundesliste entfernen?';
  }

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
  String get socialOnlineNow => 'Gerade online';

  @override
  String socialJoinedOn(String date) {
    return 'Beigetreten am $date';
  }

  @override
  String get socialLongestStreakShort => 'Beste';

  @override
  String get socialLearningJourneyTitle => 'Lernreise';

  @override
  String get socialWeeklyRankLabel => 'Wochenrang';

  @override
  String get socialWordsLearnedLabel => 'Gelernte Wörter';

  @override
  String get socialTotalReviewsLabel => 'Wiederholungen';

  @override
  String get socialAchievementsTitle => 'Erfolge';

  @override
  String get socialActivityTimelineTitle => 'Letzte Aktivität';

  @override
  String get achievementFirstPracticeName => 'Erster Schritt';

  @override
  String get achievementFirstPracticeDesc => 'Erste Übung abgeschlossen';

  @override
  String get achievementStreak3Name => '3-Tage-Serie';

  @override
  String get achievementStreak3Desc => '3 Tage in Folge lernen';

  @override
  String get achievementStreak7Name => 'Perfekte Woche';

  @override
  String get achievementStreak7Desc => '7 Tage in Folge lernen';

  @override
  String get achievementStreak30Name => 'Monat der Disziplin';

  @override
  String get achievementStreak30Desc => '30 Tage in Folge lernen';

  @override
  String get achievementCards10Name => '10 Wörter';

  @override
  String get achievementCards10Desc => '10 Karteikarten erstellen';

  @override
  String get achievementCards50Name => '50 Wörter';

  @override
  String get achievementCards50Desc => '50 Karteikarten erstellen';

  @override
  String get achievementCards100Name => '100 Wörter';

  @override
  String get achievementCards100Desc => '100 Karteikarten erstellen';

  @override
  String get achievementXp500Name => '500 XP';

  @override
  String get achievementXp500Desc => '500 XP insgesamt erreichen';

  @override
  String get achievementXp1000Name => 'Tausend XP';

  @override
  String get achievementXp1000Desc => '1000 XP insgesamt erreichen';

  @override
  String get achievementXp5000Name => 'Meister';

  @override
  String get achievementXp5000Desc => '5000 XP insgesamt erreichen';

  @override
  String get achievementLevel5Name => 'Level 5';

  @override
  String get achievementLevel5Desc => 'Level 5 erreichen';

  @override
  String get achievementLevel10Name => 'Level 10';

  @override
  String get achievementLevel10Desc => 'Level 10 erreichen';

  @override
  String get achievementReviews100Name => '100 Wiederholungen';

  @override
  String get achievementReviews100Desc => '100 Wiederholungen abschließen';

  @override
  String activityLevelUp(String level) {
    return 'Level $level erreicht';
  }

  @override
  String activityStreakMilestone(String streak) {
    return '$streak Tage in Folge';
  }

  @override
  String get activityAchievementUnlockedFallback => 'Neuer Erfolg';

  @override
  String get activityMissionFallback => 'Aufgabe';

  @override
  String get activityExamFallback => 'Prüfung';

  @override
  String activityDailyReview(String correct, String total) {
    return '$correct/$total Wörter wiederholt';
  }

  @override
  String activityVocabLearned(String count) {
    return '$count neue Wörter gelernt';
  }

  @override
  String get activityVideoFallback => 'Video';

  @override
  String socialFriendsSubtitle(int friends, int requests) {
    return '$friends Freunde · $requests Anfragen';
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
    return 'Lv.$level · $streak Tage Serie';
  }

  @override
  String get socialSuggestionsTitle => 'Vorgeschlagene Freunde';

  @override
  String socialConversationsCount(int count) {
    return '$count Unterhaltungen';
  }

  @override
  String get socialYouPrefix => 'Du';

  @override
  String get socialOffline => 'Offline';

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
  String examHeroTitle(String provider, String level) {
    return '🎯 Vorbereitung für $provider $level';
  }

  @override
  String get examHeroToday => 'Prüfung heute!';

  @override
  String examCornerDaysLeft(int days) {
    return 'Noch $days Tage';
  }

  @override
  String get examHeroNoAttemptsYet =>
      'Mach eine Übungsprüfung, um die Bereitschaft zu messen';

  @override
  String examHeroBasedOnAttempts(int count) {
    return 'Basierend auf $count absolvierten Prüfungen';
  }

  @override
  String examHeroCta(String provider, String level) {
    return '📝 $provider $level Prüfung machen';
  }

  @override
  String get examHeroReadyLabel => 'bereit';

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

  @override
  String get examReadinessGoalHeaderLabel => 'Übe für';

  @override
  String get examReadinessGoalDaysLeft => 'Tage bis zur Prüfung';

  @override
  String get examReadinessGoalTodayLabel => 'Heute ist Prüfungstag!';

  @override
  String get examReadinessGoalSetDate => 'Prüfungsdatum festlegen';

  @override
  String get examReadinessScoreTrendLabel => 'Punktetrend';

  @override
  String examReadinessScoreTrendDelta(String delta) {
    return '$delta Pkt.';
  }

  @override
  String examReadinessScoreTrendRecentCount(int n) {
    return '$n zuletzt';
  }

  @override
  String get examReadinessScoreTrendLatestPrefix => 'Neuester: ';

  @override
  String get examReadinessRecentAvgLabel => 'Ø-Punktzahl (kürzlich)';

  @override
  String examReadinessSkillPracticeCta(String skill) {
    return '$skill üben';
  }

  @override
  String examReadinessAttemptCountSuffix(int n) {
    return '$n×';
  }

  @override
  String get examReadinessWeaknessPracticeCta => 'Schwächen üben →';

  @override
  String get examReadinessWeaknessDrillCta => 'Üben →';

  @override
  String get examReadinessTodoTitle => 'Zu erledigen';

  @override
  String get examReadinessTodoDueReviewsPrefix => 'Sie haben ';

  @override
  String examReadinessTodoDueReviewsBold(int n) {
    return '$n fällige Wörter';
  }

  @override
  String get examReadinessIntroWhy =>
      'Sieh, wie bereit du für die Prüfung bist — Fertigkeit für Fertigkeit.';

  @override
  String get examReadinessIntroTodo =>
      'Schau dir die schwächste Fertigkeit an und übe sie jetzt.';

  @override
  String get examReadinessIntroNext =>
      'Komm nach dem Üben zurück, um deine Verbesserung zu sehen.';

  @override
  String scheduleBuddyCountFire(int n) {
    return '🔥 $n Lernpartner mit anstehender Prüfung';
  }

  @override
  String scheduleBuddyCountSoon(int n) {
    return '· $n Prüfung in 30 Tagen';
  }

  @override
  String scheduleBuddyCountPast(int n) {
    return '· $n bereits geprüft';
  }

  @override
  String get scheduleSearchHint => 'Suche nach Name/Prüfungstyp...';

  @override
  String get scheduleFilterAllExamTypes => 'Alle Prüfungstypen';

  @override
  String get scheduleFilterAllLevels => 'Alle Niveaus';

  @override
  String scheduleStatusUpcomingCount(int n) {
    return 'Bevorstehend ($n)';
  }

  @override
  String scheduleStatusPastCount(int n) {
    return 'Vergangen ($n)';
  }

  @override
  String scheduleResultCountUpcoming(int n) {
    return '$n Personen · nächster Termin zuerst';
  }

  @override
  String scheduleResultCountPast(int n) {
    return '$n Personen · neueste zuerst';
  }

  @override
  String get scheduleEmptyUpcoming => 'Niemand entspricht diesen Filtern.';

  @override
  String get scheduleEmptyPast =>
      'Niemand mit abgelegter Prüfung entspricht diesen Filtern.';

  @override
  String scheduleMyPlansCount(int n) {
    return '$n Termine · nächster zuerst';
  }

  @override
  String get scheduleMyPlansEmpty =>
      'Sie haben noch keinen Prüfungstermin registriert';

  @override
  String get schedulePrivacyNotePrefix =>
      '🔒 Ihre Kontaktdaten (Tel., E-Mail, Facebook) sind ';

  @override
  String get schedulePrivacyNoteBold => 'standardmäßig verborgen';

  @override
  String get schedulePrivacyNoteSuffix =>
      ' — nur registrierte Mitglieder können sie sehen.';

  @override
  String scheduleBuddyDaysAgo(int n) {
    return 'Vor $n Tagen geprüft';
  }

  @override
  String get scheduleBuddyToday => 'Heute Prüfung!';

  @override
  String scheduleBuddyDaysLeft(int n) {
    return 'Noch $n Tage';
  }

  @override
  String get dictationActivityMenuPrompt => 'Wähle eine Hörübung:';

  @override
  String get dictationActivityClozeTitle => 'Lücke ausfüllen';

  @override
  String get dictationActivityClozeDesc => 'Hören und fehlendes Wort eingeben';

  @override
  String get dictationActivityFullTitle => 'Diktat';

  @override
  String get dictationActivityFullDesc => 'Jeden Satz anhören und abtippen';

  @override
  String get dictationActivityKaraokeTitle => 'Zuhören & Mitlesen';

  @override
  String get dictationActivityKaraokeDesc =>
      'Untertitel folgen dem Audio, Wort antippen zum Nachschlagen';

  @override
  String dictationWordsCount(int n) {
    return '$n Wörter';
  }

  @override
  String get dictationWordSelectHint =>
      'Tippe auf die unterstrichenen Wörter, um sie zum Üben auszuwählen, dann auf Start.';

  @override
  String get dictationWordSelectCtaEmpty => 'Wähle mind. 1 Wort aus';

  @override
  String dictationWordSelectCta(int n) {
    return 'Übung starten — $n Wörter';
  }

  @override
  String get dictationBackToSelection => '← Neu auswählen';

  @override
  String dictationWordCount(int answered, int total) {
    return '$answered / $total Wörter';
  }

  @override
  String get dictationTypeWordHint => 'Wort eingeben...';

  @override
  String get dictationPlayingAudioHint => 'Audio läuft...';

  @override
  String get dictationCheckCta => 'Prüfen';

  @override
  String get dictationReplaySentenceTooltip => 'Satz wiederholen';

  @override
  String get dictationClozeSkip => 'Überspringen';

  @override
  String get dictationClozeReveal => 'Antwort zeigen';

  @override
  String get dictationNoWordsToPractice => 'Keine Wörter zum Üben.';

  @override
  String get dictationBackToWordSelection => '← Zurück zur Wortauswahl';

  @override
  String get dictationClozeResultTitle => 'Übungsergebnis';

  @override
  String get dictationClozeBackLabel => 'Andere Wörter wählen';

  @override
  String get dictationClozeMistakesTitle => 'Zu wiederholende Wörter';

  @override
  String get dictationEndRetry => 'Nochmal üben';

  @override
  String dictationEndCorrectCount(int correct, int total) {
    return '$correct / $total richtig';
  }

  @override
  String get dictationFullBackLabel => 'Clip wählen';

  @override
  String get dictationFullResultTitle => 'Diktat-Ergebnis';

  @override
  String get dictationFullNextClip => 'Nächster Clip →';

  @override
  String get dictationReplayThisSentence => 'Diesen Satz wiederholen';

  @override
  String get dictationTypeSentenceHint => 'Gehörtes eingeben...';

  @override
  String dictationSentenceProgress(int idx, int count) {
    return '$idx / $count Sätze';
  }

  @override
  String dictationCorrectCount(int n) {
    return '$n richtig';
  }

  @override
  String get dictationNextSentence => 'Nächster Satz →';

  @override
  String get dictationShowResult => 'Ergebnis anzeigen';

  @override
  String get dictationNoAudioData =>
      'Für diesen Clip gibt es noch keine Diktatdaten.';

  @override
  String get dictationBackPlain => '← Zurück';

  @override
  String get dictationKaraokeBackToMenu => '← Aktivität wählen';

  @override
  String get dictationKaraokeHint =>
      'Drücke ▶ zum Anhören — Untertitel folgen dem Audio. Satz antippen zum Wiederholen.';

  @override
  String get dictationKaraokeUntimed => '(keine synchronen Untertitel)';

  @override
  String get dictationKaraokePrev => '◀ Vorheriger';

  @override
  String get dictationKaraokeNext => 'Nächster ▶';

  @override
  String get deThiHeroTitle => 'Deutsche Prüfungsaufgaben';

  @override
  String get deThiHeroSubtitle =>
      'Übe zweisprachige Deutsch-Vietnamesisch-Lesetests. Kostenlos, sofortige Auswertung, keine Anmeldung nötig.';

  @override
  String get deThiStartCta => 'Jetzt starten →';

  @override
  String get deThiLoginCta => 'Anmelden';

  @override
  String get deThiPromoTitle => 'Deutsch umfassender lernen';

  @override
  String get deThiPromoSubtitle =>
      'Karteikarten · KI-Sprechen · B1/B2-Prüfungen';

  @override
  String get deThiPromoCta => 'Jetzt testen →';

  @override
  String deThiPassageLabel(int index) {
    return 'ABSCHNITT $index';
  }

  @override
  String deThiPassageOf(int index) {
    return 'Abschnitt $index';
  }

  @override
  String deThiPassageAnsweredCount(int answered, int total) {
    return '$answered/$total Fragen';
  }

  @override
  String get deThiTranslatePassage => 'Text übersetzen';

  @override
  String get deThiHideTranslation => 'Übersetzung ausblenden';

  @override
  String get deThiTranslateVi => 'Ins Vietnamesische übersetzen';

  @override
  String get deThiHideExplanation => 'Erklärung ausblenden';

  @override
  String get deThiExplanation => 'Erklärung';

  @override
  String get deThiVietnameseTranslationHeading => 'VIETNAMESISCHE ÜBERSETZUNG';

  @override
  String get deThiPrevPassage => 'Vorheriger Abschnitt';

  @override
  String get deThiNextPassage => 'Nächster Abschnitt';

  @override
  String deThiCorrectCountLabel(int correct, int total) {
    return '$correct/$total richtig';
  }

  @override
  String deThiScoreLabel(String score) {
    return '$score Punkte';
  }

  @override
  String get communityTabBrowse => 'Durchsuchen';

  @override
  String get communityTabContribute => 'Beitragen';

  @override
  String get communityTabMine => 'Meine Themen';

  @override
  String get communityContributeComingSoon =>
      'Themenbeitrag kommt bald.\nSchau später wieder vorbei!';

  @override
  String get communityMineEmptyGated =>
      'Du hast noch keine Themen beigetragen — bald verfügbar.';

  @override
  String get communitySearchHint => 'Themen suchen...';

  @override
  String get communityFilterAll => 'Alle';

  @override
  String get communityFilterGoetheWriting => 'Goethe Schreiben';

  @override
  String get communityFilterTelcSpeaking => 'Telc Sprechen';

  @override
  String communityTeilLabel(int n) {
    return 'Teil $n';
  }

  @override
  String get communityBackLink => 'Zurück';

  @override
  String get communityBadgeLabel => 'Community';

  @override
  String get communityHiddenBanner =>
      '⚠️ Dieses Thema wurde wegen mehrerer Meldungen ausgeblendet.';

  @override
  String get communityRealExamBadge => 'Echte Prüfung';

  @override
  String get communityTakeExamAction =>
      'Ich habe diese Prüfung gerade abgelegt';

  @override
  String get communityReportAction => 'Melden';

  @override
  String get communityGatedTooltip => 'Funktion kommt bald';

  @override
  String get communityAnonymousContributor => 'Anonym';

  @override
  String get communitySectionTask => '📝 Aufgabe';

  @override
  String get communitySectionAnalysis => '📋 Aufgabenanalyse';

  @override
  String get communitySectionModelAnswer => '✍️ Musterantwort';

  @override
  String get communitySectionUsefulPhrases => '💡 Nützliche Redewendungen';

  @override
  String get communitySectionGrammar => '📖 Grammatikschwerpunkt';

  @override
  String get communitySectionMistakes => '⚠️ Häufige Fehler';

  @override
  String get communitySectionSpeakingContent => '🎙️ Inhalt';

  @override
  String get examHeaderDefaultTitle => 'Prüfungsteil';

  @override
  String get examBackToResult => 'Ergebnis';

  @override
  String get examPaceOnTrack => 'Im Zeitplan';

  @override
  String get examPaceSlow => 'Etwas langsam';

  @override
  String get examPaceBehind => 'Schneller machen';

  @override
  String get examReaderGuideTooltip => 'Lesehilfe';

  @override
  String get examReaderGuideTitle => 'Lesetipps';

  @override
  String get examReaderGuideBody =>
      'Wortnachschlagen aktivieren, um ein Wort anzutippen und die Bedeutung zu sehen. Markierung aktivieren, um schwierige Wörter zu markieren. Schriftgröße in den Anzeigeeinstellungen anpassen.';

  @override
  String get examReaderGuideEnableWordLookup => 'Wortnachschlagen aktivieren';

  @override
  String get examReaderSettingsTooltip => 'Anzeigeeinstellungen';

  @override
  String get examReaderSettingsTitle => 'Anzeigeeinstellungen';

  @override
  String get examReaderSettingsFontSize => 'Schriftgröße';

  @override
  String get examReaderSettingsHighlight => 'Wortmarkierung';

  @override
  String get examReaderSettingsWordLookup => 'Zum Nachschlagen antippen';

  @override
  String get examReadingPaneTitle => 'Text';

  @override
  String get examTranslateParagraph => 'Text übersetzen';

  @override
  String get examHideTranslation => 'Übersetzung ausblenden';

  @override
  String get examNavPrevQuestion => 'Vorherige Frage';

  @override
  String get examNavNextQuestion => 'Nächste Frage';

  @override
  String get examNavOpenSheet => 'Fragenübersicht';

  @override
  String get examNavSheetTitle => 'Fragenliste';

  @override
  String get examNavSheetPracticeTitle => 'Üben';

  @override
  String get examNavLegendCurrent => 'Aktuell';

  @override
  String get examNavLegendAnswered => 'Beantwortet';

  @override
  String get examNavLegendWrong => 'Falsch';

  @override
  String get examNavLegendUnanswered => 'Unbeantwortet';

  @override
  String examNavStatCorrect(int count) {
    return '$count Richtig';
  }

  @override
  String examNavStatWrong(int count) {
    return '$count Falsch';
  }

  @override
  String examNavStatUnanswered(int count) {
    return '$count Unbeantwortet';
  }

  @override
  String get examCommentsTitle => 'Kommentare';

  @override
  String get examCommentsEmpty => 'Noch keine Kommentare.';

  @override
  String get examCommentsPlaceholder => 'Kommentar schreiben...';

  @override
  String get examCommentsSend => 'Senden';

  @override
  String get examCommentsError => 'Kommentare konnten nicht geladen werden.';

  @override
  String get examCommentsSendError =>
      'Kommentar konnte nicht gesendet werden. Bitte versuche es erneut.';

  @override
  String get examResultHeaderFallback => 'Prüfungsergebnis';

  @override
  String get examResultScoreLabel => 'Punktzahl';

  @override
  String get examResultMotivationPassedTitle => 'Bestanden!';

  @override
  String get examResultMotivationPassedBody =>
      'Gut gemacht! Du hast die Bestehensgrenze überschritten!';

  @override
  String get examResultMotivationFailTitle => 'Weiter üben!';

  @override
  String get examResultMotivationFailBody =>
      'Noch nicht geschafft — sieh dir deine Fehler an und versuche es erneut!';

  @override
  String get examResultStatSkipped => 'Übersprungen';

  @override
  String get examSmartReviewTitle => 'Empfehlungen nach der Prüfung';

  @override
  String get examSmartReviewSubtitle =>
      'Konzentriere dich auf falsche Antworten und schwache Teile.';

  @override
  String examSmartReviewPointsNeeded(int count) {
    return '$count Punkte zum Üben';
  }

  @override
  String get examSmartReviewJumpToWrong => 'Falsche Antworten ansehen';

  @override
  String get examSmartReviewPracticeSections => 'Nach Teilen üben';

  @override
  String get examSmartReviewWrongReview => 'Meine Fehler üben';

  @override
  String get examAttemptHistoryTitle => 'Versuchsverlauf';

  @override
  String get examAttemptHistoryEmpty => 'Noch keine Versuche';

  @override
  String get examAttemptModePractice => 'Üben';

  @override
  String get writingMyEssaysLink => 'Meine Aufsätze →';

  @override
  String get writingHistoryTooltip => 'Schreibverlauf';

  @override
  String get writingYourEssay => 'Dein Aufsatz';

  @override
  String get writingDraftSaved => '💾 Entwurf gespeichert';

  @override
  String get writingSubmittedBadge => 'Eingereicht';

  @override
  String writingWordCount(int count) {
    return '$count Wörter';
  }

  @override
  String writingRestorePromptSaved(String time, int count) {
    return 'Ein Entwurf von $time ($count Wörter) ist verfügbar. Wiederherstellen?';
  }

  @override
  String get writingRestore => 'Wiederherstellen';

  @override
  String get writingDiscard => 'Verwerfen';

  @override
  String get writingEditorPlaceholder => 'Schreiben Sie hier Ihre Antwort...';

  @override
  String get writingSubmitCta => 'Aufsatz einreichen';

  @override
  String get writingSubmitting => 'Wird eingereicht...';

  @override
  String get writingRegrade => 'Erneut mit KI bewerten';

  @override
  String get writingGrading => 'Wird bewertet...';

  @override
  String get writingMinWordsHint => 'Mindestens 10 Wörter';

  @override
  String get writingEditEssay => 'Aufsatz bearbeiten';

  @override
  String get writingGradeWithAi => 'Mit KI bewerten';

  @override
  String get writingRetry => 'Wiederholen';

  @override
  String writingRetryIn(int seconds) {
    return 'Erneut versuchen in ${seconds}s';
  }

  @override
  String get writingClose => 'Schließen';

  @override
  String get writingFeedbackUpdateHint =>
      'KI-Feedback — erneut bewerten, um das Ergebnis zu aktualisieren';

  @override
  String get writingRewriteTitle => 'Überarbeitung nach Feedback';

  @override
  String get writingRewriteDesc =>
      'Erstelle eine Musterüberarbeitung zum Vergleich und lade sie bei Bedarf in den Editor.';

  @override
  String get writingCreateRewrite => 'Überarbeitung erstellen';

  @override
  String get writingRecreateRewrite => 'Überarbeitung neu erstellen';

  @override
  String get writingCreatingRewrite => 'Wird erstellt...';

  @override
  String get writingUseRewrite => 'In den Editor laden';

  @override
  String get writingBeforeFix => 'Vorher';

  @override
  String get writingAfterFix => 'Nachher';

  @override
  String get writingGradeCategoryTask => 'Aufgabenerfüllung';

  @override
  String get writingGradeCategoryGrammar => 'Grammatik';

  @override
  String get writingGradeCategoryVocab => 'Wortschatz';

  @override
  String get writingGradeCategoryCoherence => 'Kohärenz & Kohäsion';

  @override
  String get writingCommonErrorsTitle => 'Häufige Fehler in diesem Aufsatz';

  @override
  String get writingDetailedAssessment => 'Detaillierte Bewertung';

  @override
  String writingSuggestionsTitle(int count) {
    return '💡 Vorschläge für natürlicheres Schreiben ($count)';
  }

  @override
  String writingCorrectionsTitle(int count) {
    return 'Korrekturen ($count)';
  }

  @override
  String writingFocusLink(int count) {
    return '🔁 Diese Grammatikfehler im Fokus üben ($count Fehler)';
  }

  @override
  String writingGoetheBreakdownTitle(String teilLabel) {
    return 'Goethe-Bewertung — $teilLabel';
  }

  @override
  String get writingGoetheInhalt => 'Inhalt';

  @override
  String get writingGoetheKommunikative => 'Kommunikative Gestaltung';

  @override
  String get writingGoetheFormale => 'Formale Richtigkeit';

  @override
  String get writingHistoryTitle => 'Schreibverlauf';

  @override
  String get writingHistoryEmpty => 'Noch keine Aufsätze';

  @override
  String writingScorePoints(int score) {
    return '$score/100';
  }

  @override
  String get goetheB1HubTitle => 'Goethe-Zertifikat B1';

  @override
  String get goetheB1HubSubtitle => '3 Übungssätze';

  @override
  String get goetheB1HubOfficialTitle => 'Offizielle Prüfungssätze';

  @override
  String get goetheB1HubOfficialDesc =>
      '30+ vollständige Übungsprüfungen · Lesen · Hören · Schreiben';

  @override
  String get goetheB1HubWritingTitle => 'Echte Schreiben-Aufgaben';

  @override
  String get goetheB1HubWritingDesc =>
      '30 Schreiben-Themen · Teil 1 · Teil 2 · Teil 3';

  @override
  String get goetheB1HubSpeakingTitle => 'Sprechen';

  @override
  String get goetheB1HubSpeakingDesc =>
      'Sprechthemen · Teil 1 · Teil 2 · Teil 3';

  @override
  String get goetheB1WritingEyebrow => 'Goethe B1 · 3 Teile · 100 Punkte';

  @override
  String get goetheB1WritingHeadingPrefix => 'Schreiben — ';

  @override
  String get goetheB1WritingHeadingSchreiben => 'Schreiben';

  @override
  String get goetheB1WritingBadgeReal => 'Echte Prüfungsaufgaben';

  @override
  String get goetheB1WritingBadgeYears => '2023–2026';

  @override
  String get goetheB1WritingBadgeQuality => 'Hochwertige Musterlösungen';

  @override
  String get goetheB1WritingHeroPitch =>
      'Übe das genaue Goethe-B1-Format mit echten Prüfungsthemen, damit du selbstbewusst in die Prüfung gehst.';

  @override
  String get goetheB1WritingHeroDesc =>
      'Schreiben umfasst 3 Teile, die der Goethe-B1-Prüfungsstruktur folgen, ausgewählt aus echten Prüfungsaufgaben 2023–2026 sowie laufend ergänzten Themen aus der Community. Jedes Thema bietet eine Musteraufgabe, Satzstrukturen zum Wiederholen, Ideen zur Ausarbeitung und schrittweises Schreibtraining mit verlässlichen Musterlösungen.';

  @override
  String get goetheB1WritingStatSourceLabel => 'Übungsquelle';

  @override
  String get goetheB1WritingStatSourceValue => 'Echte Goethe-Prüfungsaufgaben';

  @override
  String get goetheB1WritingStatTopicsLabel => 'Verfügbare Themen';

  @override
  String goetheB1WritingStatTopicsValue(int count) {
    return '$count+ Themen';
  }

  @override
  String get goetheB1WritingStatValueLabel => 'Übungswert';

  @override
  String get goetheB1WritingStatValueValue =>
      'Musterlösungen + Schritt für Schritt';

  @override
  String get goetheB1WritingLoadingTopics => 'Wird geladen...';

  @override
  String get goetheB1WritingAllExamsLink => '← Alle Schreibprüfungen';

  @override
  String get goetheB1WritingMyEssaysLink => 'Meine Aufsätze →';

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
      'Persönlichen Brief/E-Mail an einen Freund schreiben';

  @override
  String get goetheB1WritingTeil2Subtitle =>
      'Meinung in einem Forumsbeitrag äußern';

  @override
  String get goetheB1WritingTeil3Subtitle =>
      'Formelle E-Mail: Entschuldigung, Termin, Anmeldung';

  @override
  String get conversationHubTitle => 'KI-Gespräch';

  @override
  String get conversationHubSubtitle =>
      'Alltagsdeutsch · Entdecken & sprechen üben';

  @override
  String get conversationHubLoadError =>
      'Szenarienliste konnte nicht geladen werden.';

  @override
  String get conversationTabScenarios => 'Szenarien';

  @override
  String get conversationTabHistory => 'Übungsverlauf';

  @override
  String get conversationHeroBadge => 'KI erstellt sofort ein Gespräch';

  @override
  String get conversationHeroTitle =>
      'Worüber möchtest du heute sprechen üben?';

  @override
  String get conversationHeroSearchHint =>
      'Gib ein beliebiges Thema ein oder suche vorhandene…';

  @override
  String get conversationHeroCreateNow => 'Jetzt erstellen';

  @override
  String get conversationHeroUpgrade => 'Auf Plus upgraden ✨';

  @override
  String get conversationHeroTryNow => 'Jetzt ausprobieren:';

  @override
  String conversationQuotaFreeRemaining(int remaining, int max) {
    return 'Noch $remaining/$max kostenlose Gespräche heute';
  }

  @override
  String conversationQuotaWalled(int max) {
    return 'Du hast alle $max/$max kostenlosen Gespräche heute aufgebraucht';
  }

  @override
  String get conversationQuotaUnlimited => 'Unbegrenzt';

  @override
  String get conversationFilterLibraryTitle => 'Oder aus der Bibliothek wählen';

  @override
  String conversationFilterResultCount(int count) {
    return '$count Themen';
  }

  @override
  String get conversationFilterClear => 'Filter löschen';

  @override
  String get conversationFilterCategory => 'Kategorie';

  @override
  String get conversationFilterLevel => 'Niveau';

  @override
  String get conversationFilterAll => 'Alle';

  @override
  String conversationCreateCustomTitle(String topic) {
    return 'Eigenes Thema erstellen: „$topic“';
  }

  @override
  String get conversationCreateCustomHint =>
      'Nicht verfügbar — lass die KI ein neues Gespräch für dich erstellen';

  @override
  String get conversationEmptyNoResults => 'Keine Themen gefunden';

  @override
  String get conversationEmptyNoResultsHint =>
      'Versuche oben ein eigenes Thema einzugeben!';

  @override
  String get conversationHistoryLoadError =>
      'Übungsverlauf konnte nicht geladen werden.';

  @override
  String get conversationHistoryEmpty =>
      'Noch keine gespeicherten Übungssitzungen.';

  @override
  String get conversationHistoryEmptyHint =>
      'Beende ein Gespräch, um es hier zu speichern.';

  @override
  String conversationHistoryMeta(String level, int turns, String date) {
    return '$level · $turns Runden · $date';
  }

  @override
  String get conversationHistoryDelete => 'Löschen';

  @override
  String get conversationHistoryCancel => 'Abbrechen';

  @override
  String get conversationHistoryDetailLoadError =>
      'Das gespeicherte Gespräch konnte nicht geladen werden.';

  @override
  String get conversationHistoryBackToList => 'Zurück zur Liste';

  @override
  String get conversationLoadError =>
      'Szenario konnte nicht geladen werden. Bitte erneut versuchen.';

  @override
  String get conversationBack => 'Zurück';

  @override
  String get conversationContextLabel => 'Situation';

  @override
  String get conversationYourRoleLabel => 'Deine Rolle:';

  @override
  String get conversationListen => 'Anhören';

  @override
  String get conversationExaminerButton => 'Prüfer';

  @override
  String get conversationExaminerTitle => '⚖️ KI-Prüfer';

  @override
  String get conversationExaminerCoverageTitle => 'Zu behandelnde Inhalte';

  @override
  String get conversationExaminerVerdictPending =>
      'Die Gesamtbewertung wird noch entwickelt.';

  @override
  String get conversationExaminerNoVerdict =>
      'Für diese Sitzung liegt noch keine Bewertung vor.';

  @override
  String get conversationExit => 'Verlassen';

  @override
  String get conversationExitConfirmTitle => 'Gespräch verlassen?';

  @override
  String get conversationExitConfirmBody =>
      'Dein aktueller Fortschritt wird nicht gespeichert.';

  @override
  String get conversationExitConfirmCta => 'Verlassen';

  @override
  String get conversationExitCancelCta => 'Weiter';

  @override
  String get conversationComposerHint => 'Deutsch eingeben oder sprechen...';

  @override
  String get conversationComposerModeText => 'Schreiben';

  @override
  String get conversationComposerModeVoice => 'Mikrofon';

  @override
  String get conversationSuggestionsTitle => 'Vorschläge';

  @override
  String get conversationSuggestionsPending =>
      'Antwortvorschläge werden noch entwickelt.';

  @override
  String get conversationVoiceTapToSpeak => 'Zum Sprechen tippen';

  @override
  String get conversationVoiceComingSoon => 'Spracheingabe kommt bald.';

  @override
  String get conversationVoiceBackToText => 'Zurück zum Tippen';

  @override
  String get conversationDoneTitle => 'Gespräch abgeschlossen!';

  @override
  String conversationDoneSubtitle(String title, int turns) {
    return '$title · $turns Gesprächsrunden';
  }

  @override
  String get conversationDoneRestart => 'Erneut üben';

  @override
  String get conversationDoneChooseAnother => 'Anderes Szenario wählen';

  @override
  String get interviewImportTitle => 'Interviews aus einem Dokument üben';

  @override
  String get interviewImportDesc =>
      'Vorbereitungsdokument einfügen → KI erstellt das Interview; deine Antworten werden zu Hinweisen.';

  @override
  String get interviewImportBackToEdit => 'Dokument bearbeiten';

  @override
  String get interviewImportDocLabel => 'Interviewdokument';

  @override
  String get interviewImportDocHint =>
      'Füge die vorbereiteten Fragen + Antworten ein...';

  @override
  String get interviewImportLevelLabel => 'Niveau (CEFR)';

  @override
  String get interviewImportExtract => '✨ Fragen extrahieren';

  @override
  String get interviewImportExtracting => 'Wird extrahiert...';

  @override
  String get interviewImportTitleLabel => 'Name des Interviews';

  @override
  String get interviewImportEditHint =>
      'Fragen und Hinweise vor dem Speichern prüfen & bearbeiten. Hinweise sind nur für dich sichtbar, nicht für die KI.';

  @override
  String interviewImportQuestionLabel(int n) {
    return 'Frage $n';
  }

  @override
  String get interviewImportQuestionDeHint => 'Interviewfrage (Deutsch)';

  @override
  String get interviewImportQuestionViHint => 'Übersetzung (Vietnamesisch)';

  @override
  String get interviewImportHintDeHint =>
      'Hinweis — deine vorbereitete Antwort (Deutsch)';

  @override
  String get interviewImportHintViHint => 'Hinweis (Vietnamesisch)';

  @override
  String get interviewImportAddQuestion => '+ Frage hinzufügen';

  @override
  String get interviewImportSave => 'Speichern & üben beginnen';

  @override
  String get interviewImportSaving => 'Wird gespeichert...';

  @override
  String get pronunciationHubTitle => 'Deutsche Aussprache üben';

  @override
  String get pronunciationHubInfoBanner =>
      'Richtige Aussprache von Anfang an gibt dir mehr Selbstvertrauen und vermeidet Missverständnisse. Jedes Modul konzentriert sich auf eine schwierige Lautgruppe — Schritt für Schritt üben, hören und nachahmen.';

  @override
  String get pronunciationHubUmlauteTitle => 'Umlaute (ä, ö, ü)';

  @override
  String get pronunciationHubUmlauteDesc =>
      'Die drei charakteristischen deutschen Umlaute unterscheiden und üben';

  @override
  String get pronunciationHubIchAchTitle => 'Ich-laut / Ach-laut';

  @override
  String get pronunciationHubIchAchDesc =>
      'Unterscheide \'ch\' nach vorderen und hinteren Vokalen';

  @override
  String get pronunciationHubRSoundTitle => 'R-Sound';

  @override
  String get pronunciationHubRSoundDesc =>
      'Der charakteristische deutsche Kehlkopf-R-Laut';

  @override
  String get pronunciationHubSpStTitle => 'Anfangs-Sp / St';

  @override
  String get pronunciationHubSpStDesc =>
      'sp → schp, st → scht am Wort-/Silbenanfang';

  @override
  String get pronunciationLoadError =>
      'Daten konnten nicht geladen werden. Bitte erneut versuchen.';

  @override
  String get pronunciationRetry => 'Erneut versuchen';

  @override
  String get pronunciationNoData => 'Noch keine Übungsdaten.';

  @override
  String get pronunciationCompletedTitle => 'Abgeschlossen!';

  @override
  String pronunciationScoreCorrect(int score, int total) {
    return '$score / $total richtig';
  }

  @override
  String get pronunciationRetryCta => 'Nochmal üben';

  @override
  String get pronunciationBackCta => 'Zurück';

  @override
  String get pronunciationHintLabel => 'Aussprachetipp:';

  @override
  String get pronunciationPlayCta => 'Anhören';

  @override
  String get pronunciationNextCta => 'Gehört →';

  @override
  String get pronunciationDoneCta => 'Fertig';

  @override
  String get pronunciationModePronounce => 'Aussprache';

  @override
  String get pronunciationModeDistinguish => 'Unterscheiden';

  @override
  String get pronunciationModeDistinguishSpSt => 'sp/st unterscheiden';

  @override
  String get pronunciationModeCategorize => 'Kategorisieren';

  @override
  String get pronunciationUmlauteTitle => 'Umlaute üben';

  @override
  String get pronunciationIchAchTitle => 'Ich-laut / Ach-laut';

  @override
  String get pronunciationRSoundTitle => 'Deutscher R-Laut';

  @override
  String get pronunciationSpStTitle => 'Anfangs-Sp / St';

  @override
  String get pronunciationIchLautBadge => 'Ich-laut [ç]';

  @override
  String get pronunciationAchLautBadge => 'Ach-laut [x]';

  @override
  String get pronunciationCompareLabel => 'Vergleich:';

  @override
  String get pronunciationROverviewInfo =>
      'Der deutsche R-Laut hat je nach Position 4 Varianten. Die Liste unten hilft dir, die Regel schnell zu merken.';

  @override
  String get pronunciationRPositionInitial => 'Wortanfang [ʁ]';

  @override
  String get pronunciationRPositionAfterVowel => 'Nach Vokal [ɐ]';

  @override
  String get pronunciationRPositionCluster => 'Konsonantencluster [ʁ]';

  @override
  String get pronunciationRPositionVocalic => 'Wortende -er [ɐ]';

  @override
  String get pronunciationQuizPrompt =>
      'Hör zu und wähle das Wort, das du gerade gehört hast:';

  @override
  String get pronunciationQuizReplayHint => 'Tippen zum erneuten Abspielen';

  @override
  String pronunciationQuizScore(int count) {
    return '$count richtig';
  }

  @override
  String pronunciationStreak(int count) {
    return '🔥 $count in Folge!';
  }

  @override
  String get pronunciationQuizCorrect => '✓ Richtig!';

  @override
  String get pronunciationQuizWrong => '✗ Nicht ganz';

  @override
  String get pronunciationQuizHeardLabel => 'Gehörtes Wort:';

  @override
  String get pronunciationQuizComparing =>
      'Beide werden zum Vergleich abgespielt...';

  @override
  String get pronunciationQuizSeeResult => 'Ergebnis ansehen';

  @override
  String get pronunciationQuizInsufficientData =>
      'Nicht genug Daten für ein Quiz.';

  @override
  String get pronunciationMinimalPairsTitle => 'Minimalpaar-Hörtraining';

  @override
  String get pronunciationMinimalPairsPickerHint =>
      'Wähle ein Lautpaar zum Unterscheiden üben:';

  @override
  String pronunciationMinimalPairsCount(int count) {
    return '$count Wortpaare';
  }

  @override
  String get pronunciationMinimalPairsEmpty =>
      'Noch keine Lautpaar-Daten. Bitte später erneut versuchen.';

  @override
  String get pronunciationMinimalPairsPracticing => 'Übung:';

  @override
  String get pronunciationMinimalPairsPrompt =>
      'Welches Wort hast du gerade gehört?';

  @override
  String pronunciationMinimalPairsCorrectOf(int correct, int total) {
    return '$correct/$total richtig';
  }

  @override
  String get pronunciationMinimalPairsCorrectLabel => 'Richtig!';

  @override
  String pronunciationMinimalPairsWrongLabel(String word) {
    return 'Falsch — richtige Antwort: $word';
  }

  @override
  String get pronunciationEndCta => 'Beenden';

  @override
  String get pronunciationMinimalPairsResultTitle => 'Hörergebnis';

  @override
  String pronunciationMinimalPairsScoreLabel(int correct, int total) {
    return '$correct / $total richtig';
  }

  @override
  String get pronunciationMinimalPairsLowScoreHint =>
      'Hör dir das noch ein paar Mal an — dein Ohr gewöhnt sich an den Unterschied!';

  @override
  String get pronunciationChangePairCta => 'Paar wechseln';

  @override
  String sprechenExamLoadError(String error) {
    return 'Prüfung konnte nicht geladen werden: $error';
  }

  @override
  String get sprechenContentLockedTitle => 'Premium-Inhalt';

  @override
  String get sprechenPracticeCta => '🎤 Mit Tiger AI sprechen üben';

  @override
  String get sprechenTopicListTitle => 'Themenliste';

  @override
  String sprechenTopicListLoadError(String error) {
    return 'Fehler beim Laden der Liste: $error';
  }

  @override
  String get sprechenTopicListEmpty => '🎤 Noch keine Themen';

  @override
  String sprechenTopicListSummary(int count, int done) {
    return '$count Themen · $done abgeschlossen';
  }

  @override
  String get sprechenLeaderboardEmpty => 'Noch keine Ranglisten-Daten';

  @override
  String get sprechenTeilSetOverviewSubtitle =>
      'Sprechen üben — wähle einen Teil zum Starten';

  @override
  String get sprechenTeilCompletedBadge => '✓ Abgeschlossen';

  @override
  String get sprechenOverviewTitle => 'Sprechen';

  @override
  String sprechenOverviewSubtitle(String providerLabel) {
    return '$providerLabel · 3 Teile · 75 Punkte';
  }

  @override
  String get sprechenOverviewGoetheInfo =>
      'Sprechen macht 75 von 300 Punkten der Goethe-B1-Prüfung aus. Jeder Teil wird nach 3 Kriterien bewertet: Inhalt, Grammatik & Satzbau, Wortschatz & Flüssigkeit.';

  @override
  String get sprechenOverviewTelcInfo =>
      'Sprechen macht 75 von 300 Punkten der telc-B1-Prüfung aus.';

  @override
  String sprechenTopicCount(int count) {
    return '$count Themen';
  }

  @override
  String get sprechenTopicSearchHint =>
      'Nach Thema oder Themengruppe suchen...';

  @override
  String sprechenTopicListFilteredCount(int filtered, int total) {
    return '$filtered/$total Themen';
  }

  @override
  String get sprechenTopicListEmptyFiltered =>
      '🎤 Keine passenden Themen gefunden';

  @override
  String get sprechenBewertungMainErrors => 'Hauptfehler';

  @override
  String get sprechenHistoryButtonLabel => 'Verlauf';

  @override
  String get sprechenPracticeStartCta => 'Jetzt üben — mit KI sprechen';

  @override
  String get sprechenResultBackToList => 'Zurück zur Liste';

  @override
  String get sprechenNoSuggestions => 'Keine Vorschläge';

  @override
  String get sprechenInputHint => 'Antwort auf Deutsch eingeben...';

  @override
  String get sprechenMicComingSoon =>
      'Sprachmodus kommt bald — nutze vorerst Schreiben';

  @override
  String get sprechenMicUnsupported =>
      'In dieser Version wird nur Schreiben unterstützt';

  @override
  String get sprechenPartnerSubtitleDefault => 'Auf Deutsch antworten';

  @override
  String sprechenFeedbackScoreLabel(int score) {
    return '$score/5 · Feedback';
  }

  @override
  String get sprechenSessionHistoryEmpty => 'Noch keine Übungssitzungen';

  @override
  String get sprechenStudyPanelLocked =>
      'Premium-Inhalt — Upgrade für vollen Zugriff';

  @override
  String get sprechenStudyPanelEmpty =>
      'Noch kein Lerninhalt für dieses Thema.';

  @override
  String get conversationTranscriptEmpty => 'Kein Gesprächsinhalt vorhanden.';

  @override
  String get writingHotBadge => 'HOT';

  @override
  String get writingCompletedBadge => 'Gelernt';

  @override
  String get writingPremiumBadge => 'Premium';

  @override
  String get writingUnlockToView => 'Zum Anzeigen freischalten';

  @override
  String get writingBuyPremium => 'Premium kaufen';

  @override
  String get writingDifficultyEasy => 'Leicht';

  @override
  String get writingDifficultyMedium => 'Mittel';

  @override
  String get writingDifficultyHard => 'Schwer';

  @override
  String writingLeaderboardTitle(int teil) {
    return 'Bestenliste · Teil $teil';
  }

  @override
  String get writingLeaderboardEmpty =>
      'Noch niemand hat ein Thema abgeschlossen';

  @override
  String get writingLeaderboardYou => 'du';

  @override
  String get writingCommunityFolderTitle =>
      'Von der Community beigetragene Themen';

  @override
  String writingCommunityFolderCount(int count) {
    return '$count Themen hinzugefügt';
  }

  @override
  String get writingCommunityFolderEmpty =>
      'Noch keine Themen — sei der Erste!';

  @override
  String get writingSearchHint => 'Suche nach Thema, Bereich, Stichwort...';

  @override
  String get writingSprintPill => 'Sprint 10h';

  @override
  String get writingSprintComingSoon => 'Sprint 10h kommt bald';

  @override
  String writingTopicCount(int count) {
    return '$count Themen';
  }

  @override
  String writingTopicCountFiltered(int count, int total) {
    return '$count/$total Themen';
  }

  @override
  String get writingNoResultsTitle => 'Keine passenden Themen gefunden';

  @override
  String get writingNoResultsHint =>
      'Versuche auf Deutsch, Vietnamesisch oder mit einem anderen Themennamen zu suchen.';

  @override
  String writingFreeLimitTitle(int teil) {
    return 'Du siehst 5 kostenlose Themen von Teil $teil';
  }

  @override
  String get writingFreeLimitDesc =>
      'Upgrade auf Premium, um alle Schreiben-B1-Themen freizuschalten und KI-Bewertung ohne Limit zu nutzen.';

  @override
  String writingTeilLabel(int n) {
    return 'Teil $n';
  }

  @override
  String writingCommunityListTitle(int teil) {
    return 'Community-Themen · Teil $teil';
  }

  @override
  String get writingPracticeNotFound => 'Schreibthema nicht gefunden.';

  @override
  String writingWordCountHint(int min, int max) {
    return '📏 $min–$max Wörter';
  }

  @override
  String get writingShowTranslation => 'Übersetzung anzeigen';

  @override
  String get writingHideTranslation => 'Übersetzung ausblenden';

  @override
  String get writingRequirementsTitle => 'Schreibanforderungen';

  @override
  String get writingSectionTask => 'Aufgabe';

  @override
  String get writingSectionTaskAnalysis => 'Aufgabenanalyse';

  @override
  String get writingSectionTextStructure => 'Textstruktur';

  @override
  String get writingSectionPhrases => 'Nützliche Redemittel';

  @override
  String get writingSectionSamples => 'Beispielsätze';

  @override
  String get writingSectionModels => 'Musterlösungen';

  @override
  String get writingSectionGrammar => 'Wichtige Grammatik (Referenz)';

  @override
  String get writingSectionVocab => 'Wichtiger Wortschatz (Referenz)';

  @override
  String get writingSectionMistakes => 'Häufige Fehler (Referenz)';

  @override
  String get writingSectionExercises => 'Übungen';

  @override
  String writingApproachesLabel(int count) {
    return '$count Entwicklungsmöglichkeiten';
  }

  @override
  String get writingAnnotationsLabel => 'Anmerkungen:';

  @override
  String writingModelTabLabel(int n) {
    return 'Model $n';
  }

  @override
  String get writingColPart => 'Teil';

  @override
  String get writingColDe => 'Deutsch';

  @override
  String get writingColVi => 'Vietnamesisch';

  @override
  String writingKernwortschatzTitle(int count) {
    return 'Kernwortschatz ($count Wörter)';
  }

  @override
  String get writingGenusOther => 'Sonstige';

  @override
  String get writingTranslateExamples => '🌐 Beispiele übersetzen';

  @override
  String writingChunksTitle(int count) {
    return 'Chunks & Wendungen ($count)';
  }

  @override
  String writingKonnektorenTitle(int count) {
    return 'Konnektoren ($count)';
  }

  @override
  String get writingNoContent => 'Noch kein Inhalt.';

  @override
  String get writingCorrectCount => 'richtig';

  @override
  String get writingWrongSentenceLabel => 'FALSCHER SATZ';

  @override
  String get writingRevealAnswer => 'Antwort anzeigen';

  @override
  String get writingShowSampleAnswer => 'Musterantwort anzeigen';

  @override
  String get writingSampleAnswerLabel => 'Musterantwort';

  @override
  String get writingPlayAll => 'Alles abspielen';

  @override
  String writingExamTimesCount(int count) {
    return '📊 $count Prüfungstermine';
  }

  @override
  String get writingMinutesUnit => 'Min.';

  @override
  String get writingWordsUnit => 'Wörter';

  @override
  String writingProvenanceTitle(int count) {
    return 'Echte Prüfung — $count Mal';
  }

  @override
  String get writingSourcesLabel => 'Quellen';

  @override
  String get writingExamDatesToggle => 'Prüfungstermine anzeigen';

  @override
  String get writingLockTitle => 'Dieses Thema ist für Premium-Konten';

  @override
  String get writingLockOfficialCopy =>
      'Dies ist ein offizielles Premium-Thema. Upgrade, um den vollständigen Inhalt zu sehen.';

  @override
  String get writingLockLegacyCopy =>
      'Kostenlose Konten sehen nur die ersten 5 Themen jedes Teils. Upgrade auf Premium, um alles freizuschalten.';

  @override
  String get writingUnlockPremiumCta => 'Premium freischalten';

  @override
  String get writingCompleteMark => '🎯 Als abgeschlossen markieren';

  @override
  String get writingCompleteDone => '✓ Abgeschlossen — Gespeichert';

  @override
  String get writingCompleteSaving => 'Speichern...';

  @override
  String get writingStartPracticeCta => 'Eigenen Text schreiben → KI-Bewertung';

  @override
  String get writingTypingStartTitle => 'Diesen Text abtippen üben';

  @override
  String writingTypingStartDesc(int count) {
    return 'Es gibt $count deutsche Sätze auf dieser Seite — übe sie abzutippen.';
  }

  @override
  String get writingTypingStartCta => 'Tippen beginnen →';

  @override
  String get writingTypingPracticeTitle => 'Tippübung';

  @override
  String writingTypingProgress(int current, int total) {
    return 'Satz $current/$total';
  }

  @override
  String get writingTypingHint => 'Tippe den deutschen Satz...';

  @override
  String get writingTypingCheck => 'Prüfen';

  @override
  String get writingTypingCorrect => '✓ Richtig!';

  @override
  String get writingTypingIncorrect => '✗ Einiges stimmt noch nicht';

  @override
  String get writingTypingNext => 'Weiter →';

  @override
  String get writingTypingSkip => 'Überspringen';

  @override
  String writingTypingDoneCount(int count) {
    return 'Du hast $count Sätze getippt';
  }

  @override
  String get writingTypingClose => 'Schließen';

  @override
  String get listeningPageTitle => 'Hören';

  @override
  String get listeningPageSubtitle =>
      'Übe dein Hörverständnis mit Videos, Podcasts und Hörbüchern';

  @override
  String get listeningIntroWhy =>
      'Übe Hören/Lesen mit Inhalten, die zu deinem Niveau passen.';

  @override
  String get listeningIntroTodo =>
      'Wähle eine Quelle: Video, Podcast oder Lesetext.';

  @override
  String get listeningIntroNext => 'Speichere neue Wörter zur Wiederholung.';

  @override
  String get listeningOtherSourcesSection => 'Weitere';

  @override
  String get listeningSourceSprechenB1Desc =>
      'Übe Diktat-Hörverständnis mit Sprechen-B1-Videos';

  @override
  String get listeningSourceSprechenB2Desc =>
      'Übe Diktat-Hörverständnis mit Sprechen-B2-Videos';

  @override
  String get listeningSourceYoutubeDesc =>
      'Übe Hörverständnis mit untertitelten YouTube-Videos';

  @override
  String get listeningSourcePodcastDesc =>
      'Höre den Easy German Podcast mit zweisprachigen Untertiteln';

  @override
  String get listeningSourceAudiobookDesc =>
      'Höre leicht verständliche deutsche Hörbücher';

  @override
  String listeningSourceVideoCount(int count) {
    return '$count Videos';
  }

  @override
  String get easyGermanSegmentCountShort => 'Kurz';

  @override
  String get easyGermanSegmentCountMedium => 'Mittel';

  @override
  String get easyGermanSegmentCountLong => 'Lang';

  @override
  String get easyGermanLoadError =>
      'Die Videoliste konnte nicht geladen werden. Bitte später erneut versuchen.';

  @override
  String easyGermanSentenceCount(int count) {
    return '$count Sätze';
  }

  @override
  String get easyGermanSearchHint =>
      'Videos nach Titel oder Video-ID suchen...';

  @override
  String get easyGermanLeaderboardEmptyHint =>
      'Noch nicht genug Daten, um dieses Level zu ranken.';

  @override
  String get podcastLoadError =>
      'Die Episodenliste konnte nicht geladen werden. Bitte später erneut versuchen.';

  @override
  String get podcastDescription =>
      'Übe Hörverständnis mit alltäglichen deutschen Podcasts';

  @override
  String get podcastEpisodeCountLabel => 'Episoden';

  @override
  String get podcastMinutesLabel => 'Minuten Hörübung';

  @override
  String get podcastSearchHint => 'Episoden suchen...';

  @override
  String podcastNoResultsFor(String query) {
    return 'Keine Episoden gefunden für „$query“.';
  }

  @override
  String get podcastNoResultsInBucket =>
      'Keine Episoden in diesem Zeitbereich.';

  @override
  String podcastPageInfo(int page, int total, int count) {
    return 'Seite $page/$total ($count Episoden)';
  }

  @override
  String get podcastAudioLoadError =>
      'Audio konnte nicht geladen werden. Bitte erneut versuchen.';

  @override
  String get podcastEpisodeLoadError => 'Episode konnte nicht geladen werden.';

  @override
  String get podcastBackToList => 'Zurück zur Liste';

  @override
  String get podcastTranscriptEmpty =>
      'Für diese Episode ist noch kein Transkript verfügbar.';

  @override
  String get podcastLeaderboardSubtitle =>
      'Anzahl abgeschlossener Podcast-Episoden';

  @override
  String get podcastLeaderboardLoadError =>
      'Bestenliste konnte nicht geladen werden.';

  @override
  String podcastYourRank(int rank, int count) {
    return 'Dein Rang: #$rank · $count Episoden';
  }

  @override
  String get podcastSettingsTitle => 'Leseeinstellungen';

  @override
  String podcastFontSizeLabel(int percent) {
    return 'Schriftgröße ($percent%)';
  }

  @override
  String get podcastShowViTranslation => 'Vietnamesische Übersetzung anzeigen';

  @override
  String get podcastDurationLe10 => '≤ 10 Min.';

  @override
  String get podcastDurationLe20 => '10–20 Min.';

  @override
  String get podcastDurationLe60 => '20–60 Min.';

  @override
  String get podcastDurationGt60 => '> 60 Min.';

  @override
  String get videoCollectionWatched => 'Angesehen';

  @override
  String get videoCollectionEmptyTitle => 'Keine passenden Videos gefunden';

  @override
  String get videoCollectionEmptyHint =>
      'Versuche ein anderes Stichwort oder entferne die Filter.';

  @override
  String get videoCollectionLeaderboardTitle => 'Top-Lerner';

  @override
  String get videoCollectionLeaderboardSubtitle =>
      'Rangliste nach abgeschlossenen Videos und Wiederholungen.';

  @override
  String get videoCollectionLeaderboardEmptyHint =>
      'Noch nicht genug Daten für ein Ranking.';

  @override
  String videoCollectionLeaderboardStats(int count, int rewatch) {
    return '$count Videos · $rewatch Wiederholungen';
  }

  @override
  String videoCollectionPageInfo(int page, int total) {
    return 'Seite $page / $total';
  }

  @override
  String get videoCollectionStatusNew => 'Nicht angesehen';

  @override
  String get videoCollectionProgressEmpty => 'Noch keine Videodaten.';

  @override
  String get videoCollectionProgressStart =>
      'Öffne ein Video, um deinen Fortschritt zu speichern.';

  @override
  String get videoCollectionProgressDone => 'Du hast alles abgeschlossen!';

  @override
  String get videoCollectionProgressFinalStretch =>
      'Du bist auf der Zielgeraden!';

  @override
  String get videoCollectionProgressGoodPace => 'Guter Rhythmus – weiter so.';

  @override
  String get videoCollectionProgressGoodStart =>
      'Guter Start – schau dir noch ein paar Videos an.';

  @override
  String get videoCollectionStatRewatch => 'Wiederholungen';

  @override
  String get videoCollectionStatRemaining => 'Verbleibend';

  @override
  String get videoCollectionCompletionLabel => 'abgeschlossen';

  @override
  String videoCollectionPercentLabel(int percent, String label) {
    return '$percent% $label';
  }

  @override
  String videoCollectionSavedCount(int count) {
    return '$count Videos mit gespeichertem Fortschritt';
  }

  @override
  String get appOnlySettingsLabel => 'Nur App';

  @override
  String get appUpdateSectionDescription =>
      'Auf die neueste Store-Version prüfen und aktualisieren.';

  @override
  String get appUpdateSectionTitle => 'Auf neueste Version aktualisieren';

  @override
  String get confirmNewPassword => 'Neues Passwort bestätigen';

  @override
  String get couldNotChangePassword =>
      'Passwort konnte nicht geändert werden. Bitte erneut versuchen.';

  @override
  String get darkModeDescription =>
      'Weniger Augenbelastung beim abendlichen Lernen';

  @override
  String get darkModeToggle => 'Dunkelmodus';

  @override
  String get dismissAnnouncement => 'Ankündigung schließen';

  @override
  String get learningPreferencesGoalCommunication => 'Alltagskommunikation';

  @override
  String get learningPreferencesGoalGoethe => 'Goethe-Zertifikatsprüfung';

  @override
  String get learningPreferencesGoalMedical => 'Pflege-/Medizinbereich';

  @override
  String get learningPreferencesGoalOther => 'Andere';

  @override
  String get learningPreferencesGoalsLabel => 'Ziele';

  @override
  String get learningPreferencesGoalWork => 'Studium/Arbeit in Deutschland';

  @override
  String get learningPreferencesMinutesLabel => 'Tägliche Lernzeit';

  @override
  String learningPreferencesXpSummary(int xp, int words) {
    return 'Ziel: $xp XP/Tag · ~$words Wörter/Tag';
  }

  @override
  String get logoutConfirmMessage => 'Möchtest du dich wirklich abmelden?';

  @override
  String get minutesUnit => 'Min.';

  @override
  String get notificationPermissionBlockedBody =>
      'Bitte in den Systemeinstellungen → Benachrichtigungen wieder aktivieren.';

  @override
  String get notificationPermissionBlockedTitle =>
      'Benachrichtigungen sind blockiert';

  @override
  String get notificationPermissionEnableAction =>
      'Benachrichtigungen aktivieren';

  @override
  String get notificationPreferencesSendTest => 'Test senden';

  @override
  String get notificationPreferencesTestFailed =>
      'Senden fehlgeschlagen. Bitte später erneut versuchen.';

  @override
  String get notificationPreferencesTestSending => 'Wird gesendet…';

  @override
  String get notificationPreferencesTestSent =>
      'Gesendet! Sollte in Kürze auf deinem Gerät erscheinen.';

  @override
  String get notificationPreferencesTimezone => 'Zeitzone';

  @override
  String get passwordMinLength => 'Mindestens 8 Zeichen';

  @override
  String get reviewDisplay4Button =>
      '4-Stufen-Selbsteinschätzung (nach jeder Runde)';

  @override
  String get reviewDisplay4ButtonDesc =>
      'Zeigt nach jeder Runde Vergessen/Schwer/Gut/Leicht, um die automatische Bewertung anzupassen.';

  @override
  String get reviewDisplayAutoAdvance => 'Automatisch weiter';

  @override
  String get reviewDisplayAutoAdvanceDesc =>
      'An: springt nach der Antwort automatisch zur nächsten Karte. Aus (empfohlen): du tippst selbst auf \"Weiter\".';

  @override
  String get reviewDisplayContext => 'Beispielsatz anzeigen';

  @override
  String get reviewDisplayContextDesc =>
      'Zeigt einen kurzen Beispielsatz unter jedem Wort in der Zusammenfassung.';

  @override
  String get reviewDisplayTitle => 'Wiederholungsanzeige';

  @override
  String get settingsSavedMessage => 'Gespeichert!';

  @override
  String get settingsSubtitle => 'App anpassen';

  @override
  String get soundAndEffects => 'Ton & Effekte';

  @override
  String get soundAndEffectsDescription =>
      'Ton und Vibration bei richtigen/falschen Antworten in Lektionen';

  @override
  String listeningSprechenHeaderSubtitle(int count) {
    return '$count Videos · Diktat-Hörübung';
  }

  @override
  String get writingHubTitle => 'Schreibtraining (KI-Bewertung)';

  @override
  String get writingHubRubricButton => '📋 Bewertung';

  @override
  String get writingHubTabStart => 'Start';

  @override
  String get writingHubTabMy => 'Meine Texte';

  @override
  String get writingHubTabCommunity => 'Community';

  @override
  String get writingHubStartIntro =>
      'Wähle Prüfung und Niveau, um mit dem Schreibtraining zu beginnen.';

  @override
  String get writingHubCustomTitle => 'Eigenes Thema eingeben';

  @override
  String get writingHubCustomSubtitle =>
      'Beliebiges Thema einfügen → Prüfung & Niveau wählen → KI bewertet';

  @override
  String get writingHubSprintTitle => 'Sprint-Schnelltraining';

  @override
  String get writingHubSprintSubtitle =>
      'Goethe-B1-Beispielsätze schnell mit Karteikarten wiederholen';

  @override
  String get writingHubCommunityIntro =>
      'Von der Community beigetragene Schreibthemen, nach Teil gruppiert.';

  @override
  String get writingHubCommunityTeil1 => 'Teil 1 — Persönliche E-Mail';

  @override
  String get writingHubCommunityTeil2 => 'Teil 2 — Forumsbeitrag';

  @override
  String get writingHubCommunityTeil3 => 'Teil 3 — Formelle E-Mail';

  @override
  String get writingHubCommunityViewAll => 'Alle Community-Themen ansehen →';

  @override
  String get writingChooseNow => 'Jetzt Thema wählen';

  @override
  String get writingClearFilters => 'Filter zurücksetzen';

  @override
  String get writingShowMore => 'Mehr anzeigen';

  @override
  String get writingSortLabel => 'Sortieren:';

  @override
  String get writingSortByDate => 'Datum';

  @override
  String get writingSortByScore => 'Punktzahl';

  @override
  String get writingSubmissionsEmptyTitle => 'Noch keine Texte';

  @override
  String get writingSubmissionsEmptyDesc =>
      'Wähle ein Thema und beginne zu schreiben — dein Verlauf erscheint hier.';

  @override
  String get writingSubmissionsNoMatch =>
      'Keine Texte entsprechen diesem Filter.';

  @override
  String get writingCriteriaTrendTitle => 'Deine Schreibkriterien';

  @override
  String writingCriteriaTrendSubtitle(int count) {
    return 'Ø aus $count bewerteten Texten';
  }

  @override
  String get writingCriteriaWeakest => 'braucht am meisten Übung';

  @override
  String get writingCriterionTaskCompletion => 'Aufgabenerfüllung';

  @override
  String get writingCriterionGrammar => 'Grammatik';

  @override
  String get writingCriterionVocabulary => 'Wortschatz';

  @override
  String get writingCriterionCoherence => 'Kohärenz';

  @override
  String writingLevelTitle(String label) {
    return '$label · Schreiben';
  }

  @override
  String get writingLevelEmptyTitle => 'Noch keine offiziellen Themen';

  @override
  String writingLevelEmptyDesc(String label) {
    return '$label-Themen werden noch ergänzt — probiere die Community-Themen unten!';
  }

  @override
  String get writingLevelCommunitySectionTitle => 'Community-Themen';

  @override
  String get writingLevelContributeButton => '➕ Thema beitragen';

  @override
  String get writingLevelCommunityEmpty =>
      'Noch keine Community-Themen für dieses Niveau.';

  @override
  String get writingLevelNotFound =>
      'Dieses Schreib-Niveau wurde nicht gefunden.';

  @override
  String get writingLevelLocked => 'Dieses Thema ist nur für Premium-Konten.';

  @override
  String get writingCommunityAddVersion => '➕ Version hinzufügen';

  @override
  String get writingCommunityBackToList => 'Zurück zur Liste';

  @override
  String get writingCommunityCreateTitle => 'Community-Thema beitragen';

  @override
  String get writingCommunityNotFoundDesc =>
      'Dieses Thema wurde eventuell entfernt oder ist noch nicht veröffentlicht.';

  @override
  String get writingCommunityNotFoundTitle => 'Thema nicht gefunden';

  @override
  String get writingCommunityPointsHint =>
      'Ein Punkt pro Zeile — die KI hält sich daran an das Thema.';

  @override
  String get writingCommunityPointsTitle => 'Zu behandelnde Punkte';

  @override
  String get writingCommunityReportReason => 'Von einem Nutzer gemeldet';

  @override
  String get writingCommunityReportSent => 'Meldung gesendet, danke!';

  @override
  String get writingCommunitySubmit => 'Thema veröffentlichen';

  @override
  String get writingCommunityTaskHint => 'Füge hier dein Schreibthema ein…';

  @override
  String get writingCommunityTopicFallbackTitle => 'Community-Thema';

  @override
  String get writingCommunityVoteError =>
      'Etwas ist schiefgelaufen, bitte versuche es erneut.';

  @override
  String get writingCustomTitle => 'Eigenes Thema';

  @override
  String get writingCustomIntro =>
      'Füge dein Thema ein, wähle Prüfung & Niveau und schreib los — die KI bewertet wie bei einem vorgegebenen Thema.';

  @override
  String get writingCustomExamLabel => 'Prüfung';

  @override
  String get writingCustomLevelLabel => 'Niveau';

  @override
  String get writingCustomTeilLabel => 'Teil (optional)';

  @override
  String get writingCustomTeilNone => 'Keiner';

  @override
  String get writingCustomTaskLabel => 'Thema *';

  @override
  String get writingCustomTaskHintPolish =>
      'Vietnamesisches Thema, Stichwörter oder einen unvollständigen Entwurf eingeben — die KI erstellt ein vollständiges deutsches Thema…';

  @override
  String get writingCustomTaskHintPlain =>
      'Vollständiges deutsches Schreibthema hier einfügen…';

  @override
  String get writingCustomPointsLabelPolish =>
      'Hinweise / Kernideen (optional)';

  @override
  String get writingCustomPointsLabelPlain =>
      'Zu behandelnde Punkte (optional)';

  @override
  String get writingCustomPointsHint =>
      'Ein Punkt pro Zeile — die KI hält sich daran an das Thema.';

  @override
  String get writingCustomStartPolish => 'Verfeinern & losschreiben';

  @override
  String get writingCustomStartPlain => 'Losschreiben';

  @override
  String get writingCustomEditPrompt => '← Thema bearbeiten';

  @override
  String get writingCustomStartedTitle => 'Eigenes Thema';

  @override
  String get writingCustomContribute =>
      '📤 Dieses Thema mit der Community teilen';

  @override
  String get writingAiPolishTitle => '✨ Thema von der KI verfeinern lassen';

  @override
  String get writingAiPolishDesc =>
      'Verwandelt ein vietnamesisches Thema / Stichwörter / einen Entwurf in ein vollständiges deutsches Thema. Deaktivieren, wenn dein Thema schon vollständig ist.';

  @override
  String get writingAiPolishing => 'Thema wird verfeinert…';

  @override
  String get writingAiPolishError =>
      'KI konnte das Thema nicht verfeinern. Deaktivieren, um das Original zu nutzen, oder erneut versuchen.';

  @override
  String get writingSessionGradingTimelineTitle => 'Bewertungsverlauf';

  @override
  String get writingSessionNotFound =>
      'Dieser Text wurde nicht gefunden. Er könnte veraltet sein — gehe zurück zum Verlauf für aktuelle Texte.';

  @override
  String get writingSessionPracticeAgain => 'Erneut üben';

  @override
  String get writingSessionTitleFallback => 'Text';

  @override
  String get writingSessionYourAnswer => 'Dein Text';

  @override
  String get youtubeInvalidUrl => 'Ungültige YouTube-URL';

  @override
  String get youtubeAddVideoError =>
      'Video konnte nicht hinzugefügt werden, bitte später erneut versuchen.';

  @override
  String get youtubeDeleteVideoError => 'Video konnte nicht gelöscht werden.';

  @override
  String get youtubeLoadListError => 'Videoliste konnte nicht geladen werden.';

  @override
  String get youtubeEmptyState =>
      'Noch keine Videos. Füge oben eine YouTube-URL ein, um zu starten.';

  @override
  String get youtubeUntitledVideo => 'Video ohne Titel';

  @override
  String youtubeWatchCount(int count) {
    return 'Angesehen ×$count';
  }

  @override
  String get youtubeContinueWatching => 'Weiterschauen';

  @override
  String get youtubePopularVideos => 'Beliebte Videos';

  @override
  String get youtubePasteUrlHint => 'YouTube-URL einfügen...';

  @override
  String get youtubeRewatchMarked => 'Erneutes Ansehen erfasst';

  @override
  String get youtubeCompleteMarked => 'Als abgeschlossen markiert';

  @override
  String get youtubeSaveProgressError =>
      'Fortschritt konnte nicht gespeichert werden, bitte später erneut versuchen.';

  @override
  String get youtubeRewatchButton => 'Erneut ansehen';

  @override
  String get youtubeCompleteButton => 'Abgeschlossen';

  @override
  String get youtubePracticeShadowing => 'Shadowing';

  @override
  String get youtubeTranscriptLabel => 'Transkript';

  @override
  String get youtubeNotesLabel => 'Notizen';

  @override
  String get youtubeDictationShowVideoTooltip => 'Video anzeigen';

  @override
  String get youtubeDictationAudioOnlyTooltip => 'Nur Ton';

  @override
  String get youtubeTranscriptLoadError =>
      'Transkript konnte nicht geladen werden.';

  @override
  String get youtubeDictationNoTranscript =>
      'Dieses Video hat noch kein Transkript für Diktatübungen.';

  @override
  String get shadowingScreenTitle => 'Shadowing — Ausspracheübung';

  @override
  String get shadowingHideVideoTooltip => 'Video ausblenden (Ton läuft weiter)';

  @override
  String get shadowingNoTranscript =>
      'Dieses Video hat noch kein Transkript für Shadowing-Übungen.';

  @override
  String shadowingSentenceProgress(int index, int total) {
    return 'Satz $index/$total';
  }

  @override
  String get shadowingListenAgain => 'Erneut anhören';

  @override
  String get shadowingRecordTooltip => 'Aufnehmen';

  @override
  String get shadowingRecordComingSoonTooltip => 'Aufnahme kommt bald';

  @override
  String get shadowingRecordComingSoonHint =>
      'Aufnahme + KI-Ausspracheauswertung kommt bald — bleib gespannt auf das nächste Update.';

  @override
  String youtubeDictationProgress(int index, int total, int correct) {
    return 'Satz $index/$total · Richtig $correct';
  }

  @override
  String get youtubeDictationSentenceHint => 'Ganzen Satz eingeben...';

  @override
  String get youtubeDictationClozeHint => 'Fehlendes Wort eingeben...';

  @override
  String get youtubeDictationAnswerLabel => 'Antwort:';

  @override
  String get youtubeDictationRetryButton => '↻ Wiederholen';

  @override
  String get youtubeDictationNextButton => 'Weiter →';

  @override
  String get youtubeDictationCompleteTitle => 'Abgeschlossen!';

  @override
  String youtubeDictationCompleteSummary(int correct, int total, int skipped) {
    return '$correct/$total Sätze richtig · $skipped übersprungen';
  }

  @override
  String get youtubeDictationRestartButton => 'Neu starten';

  @override
  String get youtubeDictationModeLabel => 'Modus';

  @override
  String get youtubeDictationModeSentence => 'Ganzer Satz';

  @override
  String get youtubeDictationModeCloze => 'Lücke füllen';

  @override
  String get youtubeDictationAlwaysShowVietnamese =>
      'Vietnamesische Bedeutung immer anzeigen';

  @override
  String get writingSprintTitle => 'Sprint Anki';

  @override
  String get writingSprintSubtitle =>
      'Goethe B1 Schreiben — Wiederholung mit Spaced Repetition';

  @override
  String get writingSprintModePickerLabel => 'Modus wählen';

  @override
  String get writingSprintModeMarathonTitle => 'Marathon';

  @override
  String get writingSprintModeMarathonSubtitle => '1 Sitzung, 10 Stunden';

  @override
  String get writingSprintModeMarathonDetail =>
      'Schnelle Wiederholung: 1m · 10m · 30m · 2h. Alle Themen an einem Tag.';

  @override
  String get writingSprintModeDailyTitle => 'Täglich';

  @override
  String get writingSprintModeDailySubtitle => 'SM-2 über mehrere Tage';

  @override
  String get writingSprintModeDailyDetail =>
      'Anki-Algorithmus: ca. 1 Tag · 2,5 Tage · 4 Tage. Wenige Minuten täglich, längeres Behalten.';

  @override
  String get writingSprintModeSelected => 'Ausgewählt';

  @override
  String get writingSprintResumeButton => 'Vorherige Sitzung fortsetzen';

  @override
  String get writingSprintStartFreshButton =>
      'Neu starten (alte Sitzung löschen)';

  @override
  String writingSprintStartButton(int count) {
    return 'Starten — $count Themen';
  }

  @override
  String get writingSprintMockCta => '3-Aufsatz-Probeprüfung starten';

  @override
  String get writingSprintCheatsheetCta => 'Redemittel-Spickzettel';

  @override
  String writingSprintCardCounter(int teil, int num, int total) {
    return 'Teil $teil · Karte $num/$total';
  }

  @override
  String get writingSprintRequirementsLabel => 'ANFORDERUNGEN';

  @override
  String writingSprintOutlineLabel(int index) {
    return 'Gliederung $index (DE)';
  }

  @override
  String writingSprintOutlineHint(int index) {
    return 'Was schreiben Sie zu Punkt $index?';
  }

  @override
  String get writingSprintSkipButton => 'Überspringen';

  @override
  String get writingSprintCheckButton => 'Prüfen';

  @override
  String get writingSprintMatchGood => 'Gut! Sie erinnern sich an das meiste.';

  @override
  String get writingSprintMatchWeak =>
      'Wiederholung nötig — wählen Sie Again oder Hard.';

  @override
  String get writingSprintOutlineAnswerLabel => 'GLIEDERUNGSANTWORT';

  @override
  String writingSprintOutlineMissing(int index) {
    return '(Gliederung $index nicht verfügbar)';
  }

  @override
  String writingSprintYouWrote(String text) {
    return 'Sie schrieben: $text';
  }

  @override
  String get writingSprintMiniModelToggle => 'Mini-Modell anzeigen';

  @override
  String get writingSprintRedemittelLabel => 'REDEMITTEL';

  @override
  String get writingSprintSessionDoneTitle => 'Alles wiederholt!';

  @override
  String writingSprintSessionDoneBody(int count) {
    return 'Sie haben $count Themen in dieser Sitzung wiederholt.';
  }

  @override
  String get writingSprintBackToSprint => 'Zurück zum Sprint';

  @override
  String writingSprintTaskLabel(int teil) {
    return 'Aufgabe — Teil $teil';
  }

  @override
  String get writingSprintEssayHint => 'Schreiben Sie hier Ihren Aufsatz...';

  @override
  String writingSprintWordCount(int count, int min, int max) {
    return '$count Wörter (Ziel: $min–$max)';
  }

  @override
  String writingSprintSubmitButton(int count) {
    return 'Abschicken ($count Wörter)';
  }

  @override
  String get writingSprintGrading => 'Wird bewertet...';

  @override
  String writingSprintWordsNeeded(int count) {
    return '$count weitere Wörter nötig';
  }

  @override
  String get writingSprintNoMockTopics => 'Keine passenden Themen gefunden.';

  @override
  String get writingSprintMockAverageLabel => 'Durchschnitt aus 3 Aufsätzen';

  @override
  String writingSprintTeilTopicLabel(int teil, String title) {
    return 'Teil $teil — $title';
  }

  @override
  String get writingSprintNextEssay => 'Nächster Aufsatz →';

  @override
  String get writingSprintGradingLong =>
      'KI bewertet Ihren Aufsatz... (~5-10s)';

  @override
  String writingSprintTeilLabel(int teil) {
    return 'Teil $teil';
  }

  @override
  String get writingSprintErrorsToFixLabel => 'Zu korrigierende Fehler';

  @override
  String get writingSprintErrorWrongLabel => 'Falsch';

  @override
  String get writingSprintErrorFixLabel => 'Korrektur';

  @override
  String get writingSprintShowEssay => 'Aufsatz anzeigen';

  @override
  String get writingSprintHideEssay => 'Aufsatz ausblenden';

  @override
  String get writingSprintRegradeButton => 'Neu bewerten?';

  @override
  String get writingSprintCheatsheetTitle => 'Goethe B1 Schreiben Spickzettel';

  @override
  String writingSprintCheatsheetSummary(int topics, int clusters) {
    return '$topics Themen · $clusters Cluster';
  }

  @override
  String writingSprintCheatsheetOverviewTitle(int count) {
    return 'Übersicht — $count Cluster';
  }

  @override
  String writingSprintCheatsheetTopicCount(int count) {
    return '$count Themen';
  }

  @override
  String writingSprintCheatsheetTeilTitle(int teil, int count) {
    return 'Teil $teil — $count Themen';
  }

  @override
  String get writingSprintCheatsheetRedemittelTitle =>
      'Top-Redemittel nach Funktion';

  @override
  String get writingSprintCheatsheetMistakesTitle => 'Häufige B1-Fehler';

  @override
  String get writingSprintCheatsheetVerbKasusTitle =>
      'Kurzreferenz — Verb+Kasus';

  @override
  String get readingTabLabel => 'Geschichten';

  @override
  String get newsTabLabel => 'Nachrichten';

  @override
  String get readingHubTitle => 'Geschichten lesen';

  @override
  String readingHubTitleLevel(String level) {
    return '$level-Geschichten lesen';
  }

  @override
  String get readingHubSubtitleHome =>
      'Zweisprachige Deutsch–Vietnamesische Geschichten nach Niveau · mit Audio · A1–C2';

  @override
  String get readingHubSubtitleLevel =>
      'Wähle eine Geschichte · schließe die Übungen ab (≥60%), um sie als erledigt zu markieren';

  @override
  String get readingLevelCardEmpty => 'Noch keine Geschichten';

  @override
  String get readingLevelCardAllDone => '🎉 Alles geschafft!';

  @override
  String get readingViewAllArrow => 'Alle ansehen →';

  @override
  String readingSearchHintInLevel(String level) {
    return 'Geschichten in $level suchen...';
  }

  @override
  String readingCompletedCountOfTotal(int completed, int total) {
    return '$completed/$total Geschichten abgeschlossen';
  }

  @override
  String get readingSearchEmpty => 'Keine Geschichten gefunden';

  @override
  String get readingDoneChip => 'Gelesen';

  @override
  String get readingShowTranslation => 'Übersetzung anzeigen';

  @override
  String get readingTapWordHint =>
      'Tippe auf ein beliebiges Wort, um die Bedeutung nachzuschlagen.';

  @override
  String get readingSaveProgressError =>
      'Fortschritt konnte nicht gespeichert werden, bitte später erneut versuchen.';

  @override
  String get readingGlossaryTitle => 'Wortschatz & Erklärungen';

  @override
  String get readingMarkComplete => 'Als gelesen markieren';

  @override
  String get readingFeedAppBarTitle => 'Passendes Leseniveau';

  @override
  String get readingFeedEmptyReady =>
      'Momentan passen keine Geschichten zu deinem Niveau.';

  @override
  String get readingFeedEmptyNotReady =>
      'Die Geschichtenbibliothek wird noch vorbereitet — bitte in ein paar Minuten wiederkommen.';

  @override
  String get readingFeedSaveVocabHint =>
      'Speichere mehr Wortschatz, damit das System dir passendere Geschichten vorschlagen kann.';

  @override
  String readingFeedVocabSummary(int vocabNew, int coveragePct) {
    return '$vocabNew neue Wörter · $coveragePct% der schwierigen Wörter bekannt';
  }

  @override
  String get readListenTabRead => 'Lesen';

  @override
  String readingLeaderboardProgressTitle(String level) {
    return '$level-Fortschritt';
  }

  @override
  String readingLeaderboardTitleLevel(String level) {
    return '$level-Bestenliste';
  }

  @override
  String readingLeaderboardSubtitleLevel(String level) {
    return 'Anzahl abgeschlossener $level-Geschichten';
  }

  @override
  String get readingYourRankPrefix => 'Dein Rang: ';

  @override
  String readingYourRankSuffix(int count) {
    return ' · $count Geschichten';
  }

  @override
  String get newsHeaderTitle => 'Deutsche Nachrichten';

  @override
  String get newsHeaderSubtitle =>
      'Lies deutsche Nachrichten nach Niveau A1–B2 · mit Audio · Wortschatz · Übungen';

  @override
  String get newsFilterLevelLabel => 'Niveau:';

  @override
  String get newsFilterTopicLabel => 'Thema:';

  @override
  String newsPaginationInfo(int page, int total) {
    return 'Seite $page/$total';
  }

  @override
  String get newsPaginationNext => 'Weiter';

  @override
  String get newsEmptyFiltered => 'Keine Geschichten passen zum Filter.';

  @override
  String get newsEmptyNone => 'Noch keine Nachrichten.';

  @override
  String get newsChooseLevelLabel => 'Wähle ein Leseniveau';

  @override
  String get newsOtherLevelsPrefix =>
      '💡 Du kannst diese Geschichte auch auf einem anderen Niveau lesen: ';

  @override
  String get newsListenFullStory => 'Die ganze Geschichte anhören';

  @override
  String get newsAudioSpeedSlow => 'Langsam';

  @override
  String get newsAudioSpeedNormal => 'Normal';

  @override
  String get newsVocabTitle => 'Wortschatz';

  @override
  String get newsHasAudioLabel => 'Mit Audio';

  @override
  String get newsLeaderboardTitleWeekly => 'Wöchentliche Bestenliste';

  @override
  String get newsLeaderboardSubtitleWeekly =>
      'Anzahl der diese Woche abgeschlossenen Nachrichten';

  @override
  String get newsLeaderboardEmpty =>
      'Diese Woche hat noch niemand eine Geschichte abgeschlossen';

  @override
  String get newsQuizTitle => 'Testfragen';

  @override
  String get newsQuizSubmit => 'Einreichen';

  @override
  String newsQuizResult(int correct, int total, int percent) {
    return 'Ergebnis: $correct/$total richtig ($percent%)';
  }

  @override
  String get newsQuizPassedSuffix => ' — Fortschritt gespeichert ✅';

  @override
  String get saveWordsCtaDone =>
      '✓ Hinzugefügt — erscheint in der Wiederholung';

  @override
  String saveWordsCtaSave(int count) {
    return '📥 $count neue Wörter zur Wiederholung speichern';
  }

  @override
  String saveWordsCtaResolvedCount(int resolvable, int total) {
    return '$resolvable/$total Wörter im System verfügbar';
  }

  @override
  String get saveWordsCtaError =>
      'Wortschatz konnte nicht gespeichert werden, bitte später erneut versuchen.';

  @override
  String get newsStoryNotFound => 'Nachrichtenartikel nicht gefunden.';

  @override
  String get yesterday => 'Gestern';

  @override
  String newsWeeklyRingProgress(int done, int total) {
    return 'Diese Woche hast du $done/$total neu veröffentlichte Artikel gelesen';
  }

  @override
  String get newsWeeklyRingEmpty =>
      'Diese Woche wurden noch keine neuen Artikel veröffentlicht';

  @override
  String get readingListenFullStory => 'Die ganze Geschichte anhören';

  @override
  String get readingAudioSpeedTooltip => 'Geschwindigkeit';
}
