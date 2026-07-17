import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('vi'),
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In vi, this message translates to:
  /// **'DeutschTiger'**
  String get appTitle;

  /// No description provided for @settings.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get settings;

  /// No description provided for @profile.
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ'**
  String get profile;

  /// No description provided for @messages.
  ///
  /// In vi, this message translates to:
  /// **'Tin nhắn'**
  String get messages;

  /// No description provided for @editProfile.
  ///
  /// In vi, this message translates to:
  /// **'Sửa hồ sơ'**
  String get editProfile;

  /// No description provided for @couldNotLoadProfile.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được hồ sơ.'**
  String get couldNotLoadProfile;

  /// No description provided for @home.
  ///
  /// In vi, this message translates to:
  /// **'Trang chủ'**
  String get home;

  /// No description provided for @learner.
  ///
  /// In vi, this message translates to:
  /// **'Học viên'**
  String get learner;

  /// No description provided for @couldNotLoadHome.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải trang chủ. Vui lòng thử lại.'**
  String get couldNotLoadHome;

  /// No description provided for @couldNotLoadData.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được dữ liệu. Vui lòng thử lại.'**
  String get couldNotLoadData;

  /// No description provided for @mission.
  ///
  /// In vi, this message translates to:
  /// **'Nhiệm vụ'**
  String get mission;

  /// No description provided for @searchVocabulary.
  ///
  /// In vi, this message translates to:
  /// **'Tìm từ vựng tiếng Đức...'**
  String get searchVocabulary;

  /// No description provided for @todayMissions.
  ///
  /// In vi, this message translates to:
  /// **'Nhiệm vụ hôm nay'**
  String get todayMissions;

  /// No description provided for @seeAll.
  ///
  /// In vi, this message translates to:
  /// **'Xem tất cả'**
  String get seeAll;

  /// No description provided for @noBonusMissions.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có nhiệm vụ thưởng hôm nay.'**
  String get noBonusMissions;

  /// No description provided for @dailyMissionsHeading.
  ///
  /// In vi, this message translates to:
  /// **'🎁 Nhiệm vụ thưởng'**
  String get dailyMissionsHeading;

  /// No description provided for @todaySession.
  ///
  /// In vi, this message translates to:
  /// **'Phiên hôm nay'**
  String get todaySession;

  /// No description provided for @dueWords.
  ///
  /// In vi, this message translates to:
  /// **'Từ đến hạn'**
  String get dueWords;

  /// No description provided for @goodMorning.
  ///
  /// In vi, this message translates to:
  /// **'Chào buổi sáng'**
  String get goodMorning;

  /// No description provided for @goodNoon.
  ///
  /// In vi, this message translates to:
  /// **'Chào buổi trưa'**
  String get goodNoon;

  /// No description provided for @goodAfternoon.
  ///
  /// In vi, this message translates to:
  /// **'Chào buổi chiều'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In vi, this message translates to:
  /// **'Chào buổi tối'**
  String get goodEvening;

  /// No description provided for @headerEncouragement.
  ///
  /// In vi, this message translates to:
  /// **'Sẵn sàng chinh phục tiếng Đức? 🚀'**
  String get headerEncouragement;

  /// No description provided for @headerWordsLearned.
  ///
  /// In vi, this message translates to:
  /// **'📚 Đã học {count} từ vựng'**
  String headerWordsLearned(int count);

  /// No description provided for @headerStreakStart.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu'**
  String get headerStreakStart;

  /// No description provided for @todayXp.
  ///
  /// In vi, this message translates to:
  /// **'XP hôm nay'**
  String get todayXp;

  /// No description provided for @streak.
  ///
  /// In vi, this message translates to:
  /// **'Chuỗi ngày'**
  String get streak;

  /// No description provided for @streakDays.
  ///
  /// In vi, this message translates to:
  /// **'{count} ngày'**
  String streakDays(int count);

  /// No description provided for @zeroMinutes.
  ///
  /// In vi, this message translates to:
  /// **'0 phút'**
  String get zeroMinutes;

  /// No description provided for @minutesShort.
  ///
  /// In vi, this message translates to:
  /// **'{count} phút'**
  String minutesShort(int count);

  /// No description provided for @hoursShort.
  ///
  /// In vi, this message translates to:
  /// **'{count} giờ'**
  String hoursShort(int count);

  /// No description provided for @hoursMinutesShort.
  ///
  /// In vi, this message translates to:
  /// **'{hours} giờ {minutes} phút'**
  String hoursMinutesShort(int hours, int minutes);

  /// No description provided for @wordsLearned.
  ///
  /// In vi, this message translates to:
  /// **'Số từ đã học'**
  String get wordsLearned;

  /// No description provided for @lookupCount.
  ///
  /// In vi, this message translates to:
  /// **'Số lượt tra'**
  String get lookupCount;

  /// No description provided for @today.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay'**
  String get today;

  /// No description provided for @viewDetails.
  ///
  /// In vi, this message translates to:
  /// **'Xem chi tiết'**
  String get viewDetails;

  /// No description provided for @weeklyLeaderboard.
  ///
  /// In vi, this message translates to:
  /// **'🏆 Tuần này'**
  String get weeklyLeaderboard;

  /// No description provided for @seeFull.
  ///
  /// In vi, this message translates to:
  /// **'Xem đầy đủ →'**
  String get seeFull;

  /// No description provided for @learnMoreToRank.
  ///
  /// In vi, this message translates to:
  /// **'Học thêm hôm nay để leo hạng nhé! 🔥'**
  String get learnMoreToRank;

  /// No description provided for @weeklyLeaderboardInTop3.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đang trong top 3 — giữ phong độ nhé! 🎉'**
  String get weeklyLeaderboardInTop3;

  /// No description provided for @user.
  ///
  /// In vi, this message translates to:
  /// **'Người dùng'**
  String get user;

  /// No description provided for @noWeeklyLeaderboard.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có ai trên bảng tuần này.'**
  String get noWeeklyLeaderboard;

  /// No description provided for @noWeeklyLeaderboardSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Học hôm nay để trở thành người đầu tiên! 🔥'**
  String get noWeeklyLeaderboardSubtitle;

  /// No description provided for @qaTabExam.
  ///
  /// In vi, this message translates to:
  /// **'🎓 Luyện thi'**
  String get qaTabExam;

  /// No description provided for @qaTabVocab.
  ///
  /// In vi, this message translates to:
  /// **'Từ vựng & Ôn tập'**
  String get qaTabVocab;

  /// No description provided for @qaTabListen.
  ///
  /// In vi, this message translates to:
  /// **'Nghe & Xem'**
  String get qaTabListen;

  /// No description provided for @qaTabAi.
  ///
  /// In vi, this message translates to:
  /// **'Viết & Nói (AI)'**
  String get qaTabAi;

  /// No description provided for @qaTabOther.
  ///
  /// In vi, this message translates to:
  /// **'Khác'**
  String get qaTabOther;

  /// No description provided for @qaTabAll.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả →'**
  String get qaTabAll;

  /// No description provided for @qaExamTitle.
  ///
  /// In vi, this message translates to:
  /// **'Luyện thi'**
  String get qaExamTitle;

  /// No description provided for @qaExamSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Goethe, telc'**
  String get qaExamSubtitle;

  /// No description provided for @qaVocabTitle.
  ///
  /// In vi, this message translates to:
  /// **'Kho từ vựng'**
  String get qaVocabTitle;

  /// No description provided for @qaVocabSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'{count}+ từ'**
  String qaVocabSubtitle(int count);

  /// No description provided for @qaNotesTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sổ tay'**
  String get qaNotesTitle;

  /// No description provided for @qaNotesSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Từ bạn đã lưu'**
  String get qaNotesSubtitle;

  /// No description provided for @qaReviewTitle.
  ///
  /// In vi, this message translates to:
  /// **'Ôn tập'**
  String get qaReviewTitle;

  /// No description provided for @qaReviewSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Từ đến hạn ôn'**
  String get qaReviewSubtitle;

  /// No description provided for @qaYoutubeTitle.
  ///
  /// In vi, this message translates to:
  /// **'YouTube'**
  String get qaYoutubeTitle;

  /// No description provided for @qaYoutubeSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Video song ngữ'**
  String get qaYoutubeSubtitle;

  /// No description provided for @qaListenTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nghe'**
  String get qaListenTitle;

  /// No description provided for @qaListenSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Luyện nghe với video'**
  String get qaListenSubtitle;

  /// No description provided for @qaNewsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tin tức'**
  String get qaNewsTitle;

  /// No description provided for @qaNewsSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Tin Đức A1–B2'**
  String get qaNewsSubtitle;

  /// No description provided for @qaSentenceAiTitle.
  ///
  /// In vi, this message translates to:
  /// **'Viết câu (AI)'**
  String get qaSentenceAiTitle;

  /// No description provided for @qaSentenceAiSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Ghép & viết câu, AI chấm'**
  String get qaSentenceAiSubtitle;

  /// No description provided for @qaAiTutorTitle.
  ///
  /// In vi, this message translates to:
  /// **'AI Tutor'**
  String get qaAiTutorTitle;

  /// No description provided for @qaAiTutorSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Trò chuyện cùng AI'**
  String get qaAiTutorSubtitle;

  /// No description provided for @qaGamesTitle.
  ///
  /// In vi, this message translates to:
  /// **'Trò chơi'**
  String get qaGamesTitle;

  /// No description provided for @qaGamesSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Học qua game, có XP'**
  String get qaGamesSubtitle;

  /// No description provided for @qaAffiliateTitle.
  ///
  /// In vi, this message translates to:
  /// **'Giới thiệu'**
  String get qaAffiliateTitle;

  /// No description provided for @qaAffiliateSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhận hoa hồng'**
  String get qaAffiliateSubtitle;

  /// No description provided for @dailyPathHeroTitle.
  ///
  /// In vi, this message translates to:
  /// **'☀️ Hôm nay học gì tiếp?'**
  String get dailyPathHeroTitle;

  /// No description provided for @dailyPathExamBadge.
  ///
  /// In vi, this message translates to:
  /// **'Còn {days} ngày đến thi {examLabel}'**
  String dailyPathExamBadge(int days, String examLabel);

  /// No description provided for @dailyPathPlanSummary.
  ///
  /// In vi, this message translates to:
  /// **'Kế hoạch hôm nay · {done}/{total} bước'**
  String dailyPathPlanSummary(int done, int total);

  /// No description provided for @dailyPathMinutesRemaining.
  ///
  /// In vi, this message translates to:
  /// **'còn ~{minutes} phút'**
  String dailyPathMinutesRemaining(int minutes);

  /// No description provided for @dailyPathNextStep.
  ///
  /// In vi, this message translates to:
  /// **'Bước tiếp theo · ~{minutes} phút'**
  String dailyPathNextStep(int minutes);

  /// No description provided for @dailyPathCompleteCelebration.
  ///
  /// In vi, this message translates to:
  /// **'🎉 Xong lộ trình hôm nay!'**
  String get dailyPathCompleteCelebration;

  /// No description provided for @dailyPathCompleteCelebrationWithStreak.
  ///
  /// In vi, this message translates to:
  /// **'🎉 Xong lộ trình hôm nay! Giữ streak 🔥{count} nhé.'**
  String dailyPathCompleteCelebrationWithStreak(int count);

  /// No description provided for @dailyPathEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu lộ trình học hôm nay'**
  String get dailyPathEmptyTitle;

  /// No description provided for @dailyPathEmptyDescription.
  ///
  /// In vi, this message translates to:
  /// **'Vài phút mỗi ngày để giữ streak và tiến bộ đều đặn.'**
  String get dailyPathEmptyDescription;

  /// No description provided for @dailyPathEmptyCta.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu học'**
  String get dailyPathEmptyCta;

  /// No description provided for @learnMore.
  ///
  /// In vi, this message translates to:
  /// **'Học thêm'**
  String get learnMore;

  /// No description provided for @start.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu'**
  String get start;

  /// No description provided for @couldNotCompleteAuth.
  ///
  /// In vi, this message translates to:
  /// **'Không thể hoàn tất đăng nhập. Vui lòng thử lại.'**
  String get couldNotCompleteAuth;

  /// No description provided for @signUpSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký thành công! Kiểm tra email để xác nhận.'**
  String get signUpSuccess;

  /// No description provided for @welcomeLearnGerman.
  ///
  /// In vi, this message translates to:
  /// **'Học tiếng Đức'**
  String get welcomeLearnGerman;

  /// No description provided for @welcomeEveryDayWith.
  ///
  /// In vi, this message translates to:
  /// **'mỗi ngày cùng '**
  String get welcomeEveryDayWith;

  /// No description provided for @welcomeDescription.
  ///
  /// In vi, this message translates to:
  /// **'Ứng dụng học tiếng Đức cho người Việt — ôn từ vựng, nhiệm vụ hằng ngày và luyện đọc, viết, phỏng vấn.'**
  String get welcomeDescription;

  /// No description provided for @smartVocabularyReview.
  ///
  /// In vi, this message translates to:
  /// **'Ôn từ vựng thông minh'**
  String get smartVocabularyReview;

  /// No description provided for @smartVocabularyReviewDescription.
  ///
  /// In vi, this message translates to:
  /// **'Flashcard lặp lại đúng lúc bạn sắp quên.'**
  String get smartVocabularyReviewDescription;

  /// No description provided for @dailyMissionsAndStreak.
  ///
  /// In vi, this message translates to:
  /// **'Nhiệm vụ & chuỗi ngày học'**
  String get dailyMissionsAndStreak;

  /// No description provided for @dailyMissionsAndStreakDescription.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu mỗi ngày, giữ streak đều đặn.'**
  String get dailyMissionsAndStreakDescription;

  /// No description provided for @trackProgress.
  ///
  /// In vi, this message translates to:
  /// **'Theo dõi tiến độ'**
  String get trackProgress;

  /// No description provided for @trackProgressDescription.
  ///
  /// In vi, this message translates to:
  /// **'XP, cấp độ và số phút học mỗi ngày.'**
  String get trackProgressDescription;

  /// No description provided for @startLearning.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu học'**
  String get startLearning;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In vi, this message translates to:
  /// **'Đã có tài khoản?'**
  String get alreadyHaveAccount;

  /// No description provided for @logIn.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get logIn;

  /// No description provided for @loginToContinue.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập để tiếp tục học'**
  String get loginToContinue;

  /// No description provided for @continueWithGoogle.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục với Google'**
  String get continueWithGoogle;

  /// No description provided for @continueWithApple.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục với Apple'**
  String get continueWithApple;

  /// No description provided for @or.
  ///
  /// In vi, this message translates to:
  /// **'hoặc'**
  String get or;

  /// No description provided for @email.
  ///
  /// In vi, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu'**
  String get password;

  /// No description provided for @enterPassword.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mật khẩu'**
  String get enterPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có tài khoản?'**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký'**
  String get signUp;

  /// No description provided for @createNewAccount.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tài khoản mới'**
  String get createNewAccount;

  /// No description provided for @displayName.
  ///
  /// In vi, this message translates to:
  /// **'Tên hiển thị'**
  String get displayName;

  /// No description provided for @yourName.
  ///
  /// In vi, this message translates to:
  /// **'Tên của bạn'**
  String get yourName;

  /// No description provided for @atLeastSixCharacters.
  ///
  /// In vi, this message translates to:
  /// **'Ít nhất 6 ký tự'**
  String get atLeastSixCharacters;

  /// No description provided for @atLeastEightCharacters.
  ///
  /// In vi, this message translates to:
  /// **'Ít nhất 8 ký tự'**
  String get atLeastEightCharacters;

  /// No description provided for @createAccount.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tài khoản'**
  String get createAccount;

  /// No description provided for @signUpWithGoogle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký với Google'**
  String get signUpWithGoogle;

  /// No description provided for @signUpWithApple.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký với Apple'**
  String get signUpWithApple;

  /// No description provided for @passwordRecovery.
  ///
  /// In vi, this message translates to:
  /// **'Khôi phục mật khẩu'**
  String get passwordRecovery;

  /// No description provided for @passwordRecoveryDescription.
  ///
  /// In vi, this message translates to:
  /// **'Nhập email đã đăng ký, chúng tôi sẽ gửi liên kết khôi phục.'**
  String get passwordRecoveryDescription;

  /// No description provided for @passwordRecoverySent.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi email khôi phục. Vui lòng kiểm tra hộp thư.'**
  String get passwordRecoverySent;

  /// No description provided for @sendRecoveryEmail.
  ///
  /// In vi, this message translates to:
  /// **'Gửi email khôi phục'**
  String get sendRecoveryEmail;

  /// No description provided for @backToLogin.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại đăng nhập'**
  String get backToLogin;

  /// No description provided for @emailRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập email.'**
  String get emailRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In vi, this message translates to:
  /// **'Email không hợp lệ.'**
  String get invalidEmail;

  /// No description provided for @passwordRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập mật khẩu.'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu phải có ít nhất 6 ký tự.'**
  String get passwordTooShort;

  /// No description provided for @passwordTooShortEight.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu phải có ít nhất 8 ký tự.'**
  String get passwordTooShortEight;

  /// No description provided for @signupSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tài khoản để bắt đầu học tiếng Đức'**
  String get signupSubtitle;

  /// No description provided for @displayNameRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập tên hiển thị.'**
  String get displayNameRequired;

  /// No description provided for @displayNameTooShort.
  ///
  /// In vi, this message translates to:
  /// **'Tên quá ngắn.'**
  String get displayNameTooShort;

  /// No description provided for @skip.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ qua'**
  String get skip;

  /// No description provided for @continueAction.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục'**
  String get continueAction;

  /// No description provided for @smartVocabularyLearning.
  ///
  /// In vi, this message translates to:
  /// **'Học từ vựng thông minh'**
  String get smartVocabularyLearning;

  /// No description provided for @smartVocabularyLearningDescription.
  ///
  /// In vi, this message translates to:
  /// **'Flashcard lặp lại đúng lúc bạn sắp quên. Hơn 5000 từ vựng theo chủ đề A1–C1.'**
  String get smartVocabularyLearningDescription;

  /// No description provided for @goetheTelcPractice.
  ///
  /// In vi, this message translates to:
  /// **'Luyện thi Goethe / telc'**
  String get goetheTelcPractice;

  /// No description provided for @goetheTelcPracticeDescription.
  ///
  /// In vi, this message translates to:
  /// **'Bộ đề thi thử A1–B2 với chấm điểm tự động. Đề xuất lộ trình phù hợp với trình độ của bạn.'**
  String get goetheTelcPracticeDescription;

  /// No description provided for @gamificationAndStreak.
  ///
  /// In vi, this message translates to:
  /// **'Gamification & streak'**
  String get gamificationAndStreak;

  /// No description provided for @gamificationAndStreakDescription.
  ///
  /// In vi, this message translates to:
  /// **'XP, cấp độ, chuỗi ngày học, bảng xếp hạng bạn bè và nhiều phần thưởng hấp dẫn mỗi ngày.'**
  String get gamificationAndStreakDescription;

  /// No description provided for @resetPassword.
  ///
  /// In vi, this message translates to:
  /// **'Đặt lại mật khẩu'**
  String get resetPassword;

  /// No description provided for @enterNewPassword.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mật khẩu mới'**
  String get enterNewPassword;

  /// No description provided for @newPasswordDescription.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu mới phải có ít nhất 8 ký tự.'**
  String get newPasswordDescription;

  /// No description provided for @newPassword.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu mới'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận mật khẩu'**
  String get confirmPassword;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu đã được đặt lại thành công.'**
  String get passwordResetSuccess;

  /// No description provided for @couldNotResetPassword.
  ///
  /// In vi, this message translates to:
  /// **'Không thể đặt lại mật khẩu. Vui lòng thử lại.'**
  String get couldNotResetPassword;

  /// No description provided for @newPasswordRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập mật khẩu mới.'**
  String get newPasswordRequired;

  /// No description provided for @newPasswordTooShort.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu mới phải có ít nhất 8 ký tự.'**
  String get newPasswordTooShort;

  /// No description provided for @passwordConfirmationMismatch.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu xác nhận không khớp.'**
  String get passwordConfirmationMismatch;

  /// No description provided for @verifyingResetLink.
  ///
  /// In vi, this message translates to:
  /// **'Đang xác thực...'**
  String get verifyingResetLink;

  /// No description provided for @resetLinkInvalid.
  ///
  /// In vi, this message translates to:
  /// **'Link đặt lại mật khẩu không hợp lệ hoặc đã hết hạn.'**
  String get resetLinkInvalid;

  /// No description provided for @resendResetLink.
  ///
  /// In vi, this message translates to:
  /// **'Gửi lại link đặt lại'**
  String get resendResetLink;

  /// No description provided for @checkEmailForResetLink.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra email {email} để đặt lại mật khẩu.'**
  String checkEmailForResetLink(String email);

  /// No description provided for @showPasswordTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Hiện mật khẩu'**
  String get showPasswordTooltip;

  /// No description provided for @hidePasswordTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Ẩn mật khẩu'**
  String get hidePasswordTooltip;

  /// No description provided for @newPasswordHint.
  ///
  /// In vi, this message translates to:
  /// **'Tối thiểu 8 ký tự'**
  String get newPasswordHint;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập lại mật khẩu mới'**
  String get confirmPasswordHint;

  /// No description provided for @avatarUrlOptional.
  ///
  /// In vi, this message translates to:
  /// **'URL ảnh đại diện (tùy chọn)'**
  String get avatarUrlOptional;

  /// No description provided for @saveChanges.
  ///
  /// In vi, this message translates to:
  /// **'Lưu thay đổi'**
  String get saveChanges;

  /// No description provided for @couldNotUpdateProfile.
  ///
  /// In vi, this message translates to:
  /// **'Không thể cập nhật hồ sơ. Vui lòng thử lại.'**
  String get couldNotUpdateProfile;

  /// No description provided for @premium.
  ///
  /// In vi, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @level.
  ///
  /// In vi, this message translates to:
  /// **'Cấp độ'**
  String get level;

  /// No description provided for @totalXp.
  ///
  /// In vi, this message translates to:
  /// **'Tổng XP'**
  String get totalXp;

  /// No description provided for @leaderboardTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bảng xếp hạng'**
  String get leaderboardTitle;

  /// No description provided for @thisWeek.
  ///
  /// In vi, this message translates to:
  /// **'Tuần này'**
  String get thisWeek;

  /// No description provided for @allTime.
  ///
  /// In vi, this message translates to:
  /// **'Mọi thời đại'**
  String get allTime;

  /// No description provided for @couldNotLoadLeaderboard.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải bảng xếp hạng. Vui lòng thử lại.'**
  String get couldNotLoadLeaderboard;

  /// No description provided for @noLeaderboardEntries.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dữ liệu bảng xếp hạng.'**
  String get noLeaderboardEntries;

  /// No description provided for @leaderboardSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'So tài XP tuần với cộng đồng và bạn bè.'**
  String get leaderboardSubtitle;

  /// No description provided for @leaderboardWeeklyHeader.
  ///
  /// In vi, this message translates to:
  /// **'BXH tuần'**
  String get leaderboardWeeklyHeader;

  /// No description provided for @leaderboardResetCountdown.
  ///
  /// In vi, this message translates to:
  /// **'Reset {countdown}'**
  String leaderboardResetCountdown(String countdown);

  /// No description provided for @leaderboardTabGlobal.
  ///
  /// In vi, this message translates to:
  /// **'Toàn cầu'**
  String get leaderboardTabGlobal;

  /// No description provided for @leaderboardTabFriends.
  ///
  /// In vi, this message translates to:
  /// **'Bạn bè'**
  String get leaderboardTabFriends;

  /// No description provided for @leaderboardHallOfFameToggle.
  ///
  /// In vi, this message translates to:
  /// **'Tuần trước'**
  String get leaderboardHallOfFameToggle;

  /// No description provided for @leaderboardNoFriends.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có bạn bè trên bảng — kết bạn để so tài!'**
  String get leaderboardNoFriends;

  /// No description provided for @leaderboardFindFriends.
  ///
  /// In vi, this message translates to:
  /// **'Tìm bạn bè →'**
  String get leaderboardFindFriends;

  /// No description provided for @leaderboardRankNew.
  ///
  /// In vi, this message translates to:
  /// **'Mới'**
  String get leaderboardRankNew;

  /// No description provided for @leaderboardDetailTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết điểm tuần'**
  String get leaderboardDetailTitle;

  /// No description provided for @leaderboardDetailComposite.
  ///
  /// In vi, this message translates to:
  /// **'Composite score'**
  String get leaderboardDetailComposite;

  /// No description provided for @leaderboardDetailRawXp.
  ///
  /// In vi, this message translates to:
  /// **'XP gốc'**
  String get leaderboardDetailRawXp;

  /// No description provided for @leaderboardDetailXp.
  ///
  /// In vi, this message translates to:
  /// **'XP tuần'**
  String get leaderboardDetailXp;

  /// No description provided for @leaderboardDetailExam.
  ///
  /// In vi, this message translates to:
  /// **'Điểm exam'**
  String get leaderboardDetailExam;

  /// No description provided for @leaderboardDetailMission.
  ///
  /// In vi, this message translates to:
  /// **'Mission'**
  String get leaderboardDetailMission;

  /// No description provided for @leaderboardDetailVocab.
  ///
  /// In vi, this message translates to:
  /// **'Từ đã ôn'**
  String get leaderboardDetailVocab;

  /// No description provided for @leaderboardDetailStreak.
  ///
  /// In vi, this message translates to:
  /// **'Streak'**
  String get leaderboardDetailStreak;

  /// No description provided for @leaderboardDetailTopContributor.
  ///
  /// In vi, this message translates to:
  /// **'Đóng góp cao nhất'**
  String get leaderboardDetailTopContributor;

  /// No description provided for @leaderboardDetailDampenedNote.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản mới đang bị giảm rank tạm thời. Hoàn thành streak 3 ngày, 3 mission hoặc 1 exam để mở khoá điểm rank đầy đủ.'**
  String get leaderboardDetailDampenedNote;

  /// No description provided for @leaderboardDetailViewProfile.
  ///
  /// In vi, this message translates to:
  /// **'Xem hồ sơ'**
  String get leaderboardDetailViewProfile;

  /// No description provided for @exam.
  ///
  /// In vi, this message translates to:
  /// **'Thi'**
  String get exam;

  /// No description provided for @examPractice.
  ///
  /// In vi, this message translates to:
  /// **'Luyện thi'**
  String get examPractice;

  /// No description provided for @loadingExam.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải đề thi…'**
  String get loadingExam;

  /// No description provided for @examQuestionPalette.
  ///
  /// In vi, this message translates to:
  /// **'Bảng câu hỏi'**
  String get examQuestionPalette;

  /// No description provided for @examQuestionProgress.
  ///
  /// In vi, this message translates to:
  /// **'Câu {current} / {total}'**
  String examQuestionProgress(int current, int total);

  /// No description provided for @previous.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại'**
  String get previous;

  /// No description provided for @next.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục'**
  String get next;

  /// No description provided for @done.
  ///
  /// In vi, this message translates to:
  /// **'Xong'**
  String get done;

  /// No description provided for @submitExam.
  ///
  /// In vi, this message translates to:
  /// **'Nộp bài'**
  String get submitExam;

  /// No description provided for @exitExamTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thoát bài thi?'**
  String get exitExamTitle;

  /// No description provided for @exitExamBody.
  ///
  /// In vi, this message translates to:
  /// **'Tiến trình của bạn đã được lưu tự động.'**
  String get exitExamBody;

  /// No description provided for @exit.
  ///
  /// In vi, this message translates to:
  /// **'Thoát'**
  String get exit;

  /// No description provided for @submitExamTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nộp bài?'**
  String get submitExamTitle;

  /// No description provided for @submitExamUnanswered.
  ///
  /// In vi, this message translates to:
  /// **'Bạn còn {count} câu chưa làm. Vẫn nộp?'**
  String submitExamUnanswered(int count);

  /// No description provided for @reviewAnswers.
  ///
  /// In vi, this message translates to:
  /// **'Xem lại'**
  String get reviewAnswers;

  /// No description provided for @allFilters.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get allFilters;

  /// No description provided for @couldNotLoadExams.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được đề thi. Vui lòng thử lại.'**
  String get couldNotLoadExams;

  /// No description provided for @noSupportedExams.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có đề Lesen hoặc Hören phù hợp.'**
  String get noSupportedExams;

  /// No description provided for @examReadinessTitle.
  ///
  /// In vi, this message translates to:
  /// **'Mức sẵn sàng thi'**
  String get examReadinessTitle;

  /// No description provided for @examReadinessEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dữ liệu — hãy làm ít nhất 1 đề thi để xem mức sẵn sàng.'**
  String get examReadinessEmpty;

  /// No description provided for @examReadinessAttempts.
  ///
  /// In vi, this message translates to:
  /// **'Số lần đã thi'**
  String get examReadinessAttempts;

  /// No description provided for @examReadinessBestScore.
  ///
  /// In vi, this message translates to:
  /// **'Điểm cao nhất'**
  String get examReadinessBestScore;

  /// No description provided for @examReadinessDueReviews.
  ///
  /// In vi, this message translates to:
  /// **'Từ cần ôn lại'**
  String get examReadinessDueReviews;

  /// No description provided for @examReadinessSkillBreakdown.
  ///
  /// In vi, this message translates to:
  /// **'Theo kỹ năng'**
  String get examReadinessSkillBreakdown;

  /// No description provided for @examReadinessWeaknesses.
  ///
  /// In vi, this message translates to:
  /// **'Điểm yếu cần khắc phục'**
  String get examReadinessWeaknesses;

  /// No description provided for @examReadinessBandLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ước tính mức sẵn sàng'**
  String get examReadinessBandLabel;

  /// No description provided for @examLandingSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn chứng chỉ & cấp độ'**
  String get examLandingSubtitle;

  /// No description provided for @examBuddyCtaSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Kết nối với người cùng ngày thi để ôn cùng nhau'**
  String get examBuddyCtaSubtitle;

  /// No description provided for @examShortDescTelc.
  ///
  /// In vi, this message translates to:
  /// **'Visa, định cư, nhập tịch'**
  String get examShortDescTelc;

  /// No description provided for @examShortDescGoethe.
  ///
  /// In vi, this message translates to:
  /// **'Chứng chỉ quốc tế uy tín'**
  String get examShortDescGoethe;

  /// No description provided for @examShortDescOsd.
  ///
  /// In vi, this message translates to:
  /// **'Chứng chỉ tiếng Đức Áo'**
  String get examShortDescOsd;

  /// No description provided for @examRecommendedLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đề xuất'**
  String get examRecommendedLabel;

  /// No description provided for @examLevelMismatchTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đang ở trình độ {level}'**
  String examLevelMismatchTitle(String level);

  /// No description provided for @examLevelMismatchBody.
  ///
  /// In vi, this message translates to:
  /// **'Đề thi {level} có thể quá khó cho trình độ hiện tại. Bạn vẫn muốn tiếp tục?'**
  String examLevelMismatchBody(String level);

  /// No description provided for @examLevelMismatchCancel.
  ///
  /// In vi, this message translates to:
  /// **'Huỷ'**
  String get examLevelMismatchCancel;

  /// No description provided for @examLevelMismatchContinue.
  ///
  /// In vi, this message translates to:
  /// **'Vẫn tiếp tục'**
  String get examLevelMismatchContinue;

  /// No description provided for @examSectionBundleCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} bộ đề'**
  String examSectionBundleCount(int count);

  /// No description provided for @examBundleArapTitle.
  ///
  /// In vi, this message translates to:
  /// **'A-RAP'**
  String get examBundleArapTitle;

  /// No description provided for @examBundleArapDesc.
  ///
  /// In vi, this message translates to:
  /// **'Đề luyện thi chính thức · Lesen · Hören · Schreiben · Sprachbausteine'**
  String get examBundleArapDesc;

  /// No description provided for @examBundleSpeakingTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nói (Sprechen)'**
  String get examBundleSpeakingTitle;

  /// No description provided for @examBundleSpeakingDesc.
  ///
  /// In vi, this message translates to:
  /// **'Luyện kỹ năng nói theo chủ đề'**
  String get examBundleSpeakingDesc;

  /// No description provided for @examBundleComingSoon.
  ///
  /// In vi, this message translates to:
  /// **'Sắp có'**
  String get examBundleComingSoon;

  /// No description provided for @examSetCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} bộ đề'**
  String examSetCount(int count);

  /// No description provided for @examSetCompletedSuffix.
  ///
  /// In vi, this message translates to:
  /// **'{count} hoàn thành'**
  String examSetCompletedSuffix(int count);

  /// No description provided for @examSetInProgressSuffix.
  ///
  /// In vi, this message translates to:
  /// **'{count} đang làm'**
  String examSetInProgressSuffix(int count);

  /// No description provided for @examSetEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có đề thi'**
  String get examSetEmptyTitle;

  /// No description provided for @examSetEmptyBody.
  ///
  /// In vi, this message translates to:
  /// **'Hiện tại chưa có đề thi cho chứng chỉ và cấp độ này.'**
  String get examSetEmptyBody;

  /// No description provided for @examSetPagePrev.
  ///
  /// In vi, this message translates to:
  /// **'Trước'**
  String get examSetPagePrev;

  /// No description provided for @examSetPageNext.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp'**
  String get examSetPageNext;

  /// No description provided for @examSetPageIndicator.
  ///
  /// In vi, this message translates to:
  /// **'Trang {current} / {total}'**
  String examSetPageIndicator(int current, int total);

  /// No description provided for @examPartsCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} phần'**
  String examPartsCount(int count);

  /// No description provided for @examPartActionTest.
  ///
  /// In vi, this message translates to:
  /// **'Luyện thi'**
  String get examPartActionTest;

  /// No description provided for @examPartActionPractice.
  ///
  /// In vi, this message translates to:
  /// **'Luyện tập'**
  String get examPartActionPractice;

  /// No description provided for @examSkillListEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có đề thi'**
  String get examSkillListEmptyTitle;

  /// No description provided for @examSkillListEmptyBody.
  ///
  /// In vi, this message translates to:
  /// **'Hiện tại chưa có phần {skill} nào.'**
  String examSkillListEmptyBody(String skill);

  /// No description provided for @examSkillListVocabChip.
  ///
  /// In vi, this message translates to:
  /// **'Từ vựng'**
  String get examSkillListVocabChip;

  /// No description provided for @examLocked.
  ///
  /// In vi, this message translates to:
  /// **'Khóa'**
  String get examLocked;

  /// No description provided for @examScheduleTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tìm bạn ôn thi'**
  String get examScheduleTitle;

  /// No description provided for @examBuddyListTab.
  ///
  /// In vi, this message translates to:
  /// **'Danh sách bạn ôn thi'**
  String get examBuddyListTab;

  /// No description provided for @examMyRegistrationsTab.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin của tôi'**
  String get examMyRegistrationsTab;

  /// No description provided for @examBuddyListEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có ai đăng ký lịch thi.'**
  String get examBuddyListEmpty;

  /// No description provided for @examBuddyDaysUntil.
  ///
  /// In vi, this message translates to:
  /// **'Còn {days} ngày'**
  String examBuddyDaysUntil(int days);

  /// No description provided for @examBuddyPast.
  ///
  /// In vi, this message translates to:
  /// **'Đã thi'**
  String get examBuddyPast;

  /// No description provided for @examRegistrationAdd.
  ///
  /// In vi, this message translates to:
  /// **'Thêm lịch thi'**
  String get examRegistrationAdd;

  /// No description provided for @examRegistrationDelete.
  ///
  /// In vi, this message translates to:
  /// **'Xoá lịch thi'**
  String get examRegistrationDelete;

  /// No description provided for @examRegistrationFormTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký lịch thi'**
  String get examRegistrationFormTitle;

  /// No description provided for @examTypeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Loại thi'**
  String get examTypeLabel;

  /// No description provided for @examLevelLabel.
  ///
  /// In vi, this message translates to:
  /// **'Trình độ'**
  String get examLevelLabel;

  /// No description provided for @examDateLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngày thi'**
  String get examDateLabel;

  /// No description provided for @examRegistrationSave.
  ///
  /// In vi, this message translates to:
  /// **'Lưu'**
  String get examRegistrationSave;

  /// No description provided for @communityExamsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đề thi cộng đồng'**
  String get communityExamsTitle;

  /// No description provided for @communityExamsEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có đề thi cộng đồng nào.'**
  String get communityExamsEmpty;

  /// No description provided for @communityExamDetailTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết đề thi'**
  String get communityExamDetailTitle;

  /// No description provided for @communityExamContributedBy.
  ///
  /// In vi, this message translates to:
  /// **'Đóng góp bởi {name}'**
  String communityExamContributedBy(String name);

  /// No description provided for @deThiListTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đề thi công khai'**
  String get deThiListTitle;

  /// No description provided for @deThiListEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có đề thi công khai nào.'**
  String get deThiListEmpty;

  /// No description provided for @deThiNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy đề thi này.'**
  String get deThiNotFound;

  /// No description provided for @deThiRevealAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Xem đáp án'**
  String get deThiRevealAnswer;

  /// No description provided for @deThiCorrectAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Đáp án đúng: {answer}'**
  String deThiCorrectAnswer(String answer);

  /// No description provided for @examDictationPickerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn đề luyện nghe'**
  String get examDictationPickerTitle;

  /// No description provided for @examDictationTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nghe chép chính tả'**
  String get examDictationTitle;

  /// No description provided for @examDictationNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Đề này chưa có dữ liệu luyện nghe chép chính tả.'**
  String get examDictationNotFound;

  /// No description provided for @examDictationNoWords.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có từ vựng phù hợp để luyện.'**
  String get examDictationNoWords;

  /// No description provided for @examDictationCheck.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra'**
  String get examDictationCheck;

  /// No description provided for @examQuestionsCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} câu'**
  String examQuestionsCount(int count);

  /// No description provided for @examDurationMinutes.
  ///
  /// In vi, this message translates to:
  /// **'{count} phút'**
  String examDurationMinutes(int count);

  /// No description provided for @practiceExam.
  ///
  /// In vi, this message translates to:
  /// **'Luyện tập'**
  String get practiceExam;

  /// No description provided for @examTestMode.
  ///
  /// In vi, this message translates to:
  /// **'Thi'**
  String get examTestMode;

  /// No description provided for @examReviewMode.
  ///
  /// In vi, this message translates to:
  /// **'Xem lại'**
  String get examReviewMode;

  /// No description provided for @couldNotPlayAudio.
  ///
  /// In vi, this message translates to:
  /// **'Không thể phát audio. Vui lòng thử lại.'**
  String get couldNotPlayAudio;

  /// No description provided for @examListeningAudio.
  ///
  /// In vi, this message translates to:
  /// **'Nghe'**
  String get examListeningAudio;

  /// No description provided for @audioPlay.
  ///
  /// In vi, this message translates to:
  /// **'Phát audio'**
  String get audioPlay;

  /// No description provided for @audioPause.
  ///
  /// In vi, this message translates to:
  /// **'Tạm dừng audio'**
  String get audioPause;

  /// No description provided for @audioPlayCounter.
  ///
  /// In vi, this message translates to:
  /// **'Đã nghe {used}/{max} lượt · còn {remaining}'**
  String audioPlayCounter(int used, int max, String remaining);

  /// No description provided for @audioPlayLimitReached.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã dùng hết số lần nghe cho phép.'**
  String get audioPlayLimitReached;

  /// No description provided for @examResults.
  ///
  /// In vi, this message translates to:
  /// **'Kết quả'**
  String get examResults;

  /// No description provided for @couldNotLoadExamResult.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải kết quả bài thi. Vui lòng thử lại.'**
  String get couldNotLoadExamResult;

  /// No description provided for @noExamResult.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có kết quả cho đề thi này.'**
  String get noExamResult;

  /// No description provided for @passedExam.
  ///
  /// In vi, this message translates to:
  /// **'ĐẠT'**
  String get passedExam;

  /// No description provided for @notPassedExam.
  ///
  /// In vi, this message translates to:
  /// **'CHƯA ĐẠT'**
  String get notPassedExam;

  /// No description provided for @examAnswered.
  ///
  /// In vi, this message translates to:
  /// **'Đã trả lời'**
  String get examAnswered;

  /// No description provided for @examAnsweredQuestions.
  ///
  /// In vi, this message translates to:
  /// **'{answered}/{total} câu'**
  String examAnsweredQuestions(int answered, int total);

  /// No description provided for @examTime.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian'**
  String get examTime;

  /// No description provided for @examCorrectRate.
  ///
  /// In vi, this message translates to:
  /// **'Tỉ lệ đúng'**
  String get examCorrectRate;

  /// No description provided for @examSectionAnalysis.
  ///
  /// In vi, this message translates to:
  /// **'Phân tích phần thi'**
  String get examSectionAnalysis;

  /// No description provided for @examSectionReading.
  ///
  /// In vi, this message translates to:
  /// **'Đọc hiểu'**
  String get examSectionReading;

  /// No description provided for @examSectionListening.
  ///
  /// In vi, this message translates to:
  /// **'Nghe hiểu'**
  String get examSectionListening;

  /// No description provided for @examSectionSummary.
  ///
  /// In vi, this message translates to:
  /// **'{correct}/{total} câu đúng · {minutes} phút'**
  String examSectionSummary(int correct, int total, int minutes);

  /// No description provided for @reviewExam.
  ///
  /// In vi, this message translates to:
  /// **'Xem lại bài'**
  String get reviewExam;

  /// No description provided for @retryExam.
  ///
  /// In vi, this message translates to:
  /// **'Làm lại'**
  String get retryExam;

  /// No description provided for @examCorrect.
  ///
  /// In vi, this message translates to:
  /// **'Đúng'**
  String get examCorrect;

  /// No description provided for @examNotCorrect.
  ///
  /// In vi, this message translates to:
  /// **'Chưa đúng'**
  String get examNotCorrect;

  /// No description provided for @examQuestionNumber.
  ///
  /// In vi, this message translates to:
  /// **'Câu {number}'**
  String examQuestionNumber(int number);

  /// No description provided for @matchingSelectRight.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ô bên phải để nối với mục {number}'**
  String matchingSelectRight(int number);

  /// No description provided for @removeMatch.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ nối'**
  String get removeMatch;

  /// No description provided for @examGapNumber.
  ///
  /// In vi, this message translates to:
  /// **'Chỗ trống {number}'**
  String examGapNumber(int number);

  /// No description provided for @takeMockExam.
  ///
  /// In vi, this message translates to:
  /// **'Thi thử'**
  String get takeMockExam;

  /// No description provided for @learn.
  ///
  /// In vi, this message translates to:
  /// **'Học'**
  String get learn;

  /// No description provided for @learningJourney.
  ///
  /// In vi, this message translates to:
  /// **'Hành trình học'**
  String get learningJourney;

  /// No description provided for @retryTodaySession.
  ///
  /// In vi, this message translates to:
  /// **'Tải lại phiên hôm nay'**
  String get retryTodaySession;

  /// No description provided for @couldNotLoadTodayLesson.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được bài học hôm nay.'**
  String get couldNotLoadTodayLesson;

  /// No description provided for @coursesTileTitle.
  ///
  /// In vi, this message translates to:
  /// **'Khoá học'**
  String get coursesTileTitle;

  /// No description provided for @coursesHubTitle.
  ///
  /// In vi, this message translates to:
  /// **'Khoá học'**
  String get coursesHubTitle;

  /// No description provided for @coursesFeaturedSection.
  ///
  /// In vi, this message translates to:
  /// **'Khoá học nổi bật'**
  String get coursesFeaturedSection;

  /// No description provided for @coursesMySection.
  ///
  /// In vi, this message translates to:
  /// **'Đang học'**
  String get coursesMySection;

  /// No description provided for @coursesAllSection.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả khoá học'**
  String get coursesAllSection;

  /// No description provided for @coursesEmptyCatalog.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có khoá học nào.'**
  String get coursesEmptyCatalog;

  /// No description provided for @coursesLessonsCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} bài học'**
  String coursesLessonsCount(int count);

  /// No description provided for @coursesLessonsStarted.
  ///
  /// In vi, this message translates to:
  /// **'Đã học {count} bài'**
  String coursesLessonsStarted(int count);

  /// No description provided for @coursesNoLessonsYet.
  ///
  /// In vi, this message translates to:
  /// **'Khoá học này chưa có bài học.'**
  String get coursesNoLessonsYet;

  /// No description provided for @coursesLessonCompleted.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành'**
  String get coursesLessonCompleted;

  /// No description provided for @coursesMarkComplete.
  ///
  /// In vi, this message translates to:
  /// **'Đánh dấu hoàn thành'**
  String get coursesMarkComplete;

  /// No description provided for @coursesMarkIncomplete.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ đánh dấu hoàn thành'**
  String get coursesMarkIncomplete;

  /// No description provided for @coursesVideoWebOnly.
  ///
  /// In vi, this message translates to:
  /// **'Video của bài học này hiện chỉ xem được trên bản web.'**
  String get coursesVideoWebOnly;

  /// No description provided for @coursesVocabularyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Từ vựng bài học'**
  String get coursesVocabularyTitle;

  /// No description provided for @coursesExercisesHint.
  ///
  /// In vi, this message translates to:
  /// **'{count} bài tập tương tác — làm trên bản web.'**
  String coursesExercisesHint(int count);

  /// No description provided for @coursesNotesLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ghi chú của bạn'**
  String get coursesNotesLabel;

  /// No description provided for @coursesNotesHint.
  ///
  /// In vi, this message translates to:
  /// **'Ghi chú riêng cho bài học này...'**
  String get coursesNotesHint;

  /// No description provided for @coursesNotesSave.
  ///
  /// In vi, this message translates to:
  /// **'Lưu ghi chú'**
  String get coursesNotesSave;

  /// No description provided for @coursesNotesSaved.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu ghi chú'**
  String get coursesNotesSaved;

  /// No description provided for @coursesNotesSaveFailed.
  ///
  /// In vi, this message translates to:
  /// **'Lưu ghi chú thất bại, thử lại.'**
  String get coursesNotesSaveFailed;

  /// No description provided for @coursesSignInRequired.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập để lưu tiến độ và ghi chú.'**
  String get coursesSignInRequired;

  /// No description provided for @coursesLessonNumber.
  ///
  /// In vi, this message translates to:
  /// **'Bài {number}'**
  String coursesLessonNumber(int number);

  /// No description provided for @coursesPremiumLabel.
  ///
  /// In vi, this message translates to:
  /// **'Premium'**
  String get coursesPremiumLabel;

  /// No description provided for @coursesViewContent.
  ///
  /// In vi, this message translates to:
  /// **'Xem nội dung'**
  String get coursesViewContent;

  /// No description provided for @coursesUnlockArrow.
  ///
  /// In vi, this message translates to:
  /// **'Mở khóa →'**
  String get coursesUnlockArrow;

  /// No description provided for @coursesViewArrow.
  ///
  /// In vi, this message translates to:
  /// **'Xem →'**
  String get coursesViewArrow;

  /// No description provided for @coursesHubSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Học tiếng Đức qua video + bài tập tương tác từ Deutsche Welle'**
  String get coursesHubSubtitle;

  /// No description provided for @coursesCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} khoá'**
  String coursesCount(int count);

  /// No description provided for @coursesLessonsCountPlus.
  ///
  /// In vi, this message translates to:
  /// **'{count}+ bài học'**
  String coursesLessonsCountPlus(int count);

  /// No description provided for @coursesSearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm khoá học...'**
  String get coursesSearchHint;

  /// No description provided for @coursesCollapse.
  ///
  /// In vi, this message translates to:
  /// **'Thu gọn'**
  String get coursesCollapse;

  /// No description provided for @coursesShowMore.
  ///
  /// In vi, this message translates to:
  /// **'Xem thêm {count} khoá'**
  String coursesShowMore(int count);

  /// No description provided for @coursesSearchResultsCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} kết quả cho \"{query}\"'**
  String coursesSearchResultsCount(int count, String query);

  /// No description provided for @coursesSearchNoResults.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy \"{query}\"'**
  String coursesSearchNoResults(String query);

  /// No description provided for @coursesUpsellHubTitle.
  ///
  /// In vi, this message translates to:
  /// **'Mở khóa toàn bộ {count} khoá học'**
  String coursesUpsellHubTitle(int count);

  /// No description provided for @coursesUpsellHubSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đang dùng {limit} khoá miễn phí. Nâng cấp để truy cập tất cả nội dung.'**
  String coursesUpsellHubSubtitle(int limit);

  /// No description provided for @coursesUpsellCta.
  ///
  /// In vi, this message translates to:
  /// **'Nâng cấp'**
  String get coursesUpsellCta;

  /// No description provided for @coursesLevelHeading.
  ///
  /// In vi, this message translates to:
  /// **'Level {label}'**
  String coursesLevelHeading(String label);

  /// No description provided for @coursesLevelEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dữ liệu cho level này.'**
  String get coursesLevelEmpty;

  /// No description provided for @coursesLessonNumberShort.
  ///
  /// In vi, this message translates to:
  /// **'Bài {number}'**
  String coursesLessonNumberShort(String number);

  /// No description provided for @coursesPaginationPrev.
  ///
  /// In vi, this message translates to:
  /// **'← Trước'**
  String get coursesPaginationPrev;

  /// No description provided for @coursesPaginationNext.
  ///
  /// In vi, this message translates to:
  /// **'Sau →'**
  String get coursesPaginationNext;

  /// No description provided for @coursesPaginationInfo.
  ///
  /// In vi, this message translates to:
  /// **'Trang {page}/{totalPages} · Hiển thị {start}–{end}'**
  String coursesPaginationInfo(int page, int totalPages, int start, int end);

  /// No description provided for @coursesProgressTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tiến độ học'**
  String get coursesProgressTitle;

  /// No description provided for @coursesProgressVideosWatched.
  ///
  /// In vi, this message translates to:
  /// **'video đã xem'**
  String get coursesProgressVideosWatched;

  /// No description provided for @coursesProgressLessonsStarted.
  ///
  /// In vi, this message translates to:
  /// **'bài đã bắt đầu'**
  String get coursesProgressLessonsStarted;

  /// No description provided for @coursesUpsellDetailTitle.
  ///
  /// In vi, this message translates to:
  /// **'Mở khóa toàn bộ {count} bài học.'**
  String coursesUpsellDetailTitle(int count);

  /// No description provided for @coursesUpsellDetailSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đang xem {limit} bài miễn phí.'**
  String coursesUpsellDetailSubtitle(int limit);

  /// No description provided for @coursesLessonNotStarted.
  ///
  /// In vi, this message translates to:
  /// **'Chưa học'**
  String get coursesLessonNotStarted;

  /// No description provided for @coursesLessonNoVideo.
  ///
  /// In vi, this message translates to:
  /// **'Bài này chưa có video.'**
  String get coursesLessonNoVideo;

  /// No description provided for @coursesLessonStripTitle.
  ///
  /// In vi, this message translates to:
  /// **'Danh sách bài'**
  String get coursesLessonStripTitle;

  /// No description provided for @coursesTranscriptTitle.
  ///
  /// In vi, this message translates to:
  /// **'Phụ đề'**
  String get coursesTranscriptTitle;

  /// No description provided for @coursesTranscriptCopyDe.
  ///
  /// In vi, this message translates to:
  /// **'Sao chép tiếng Đức'**
  String get coursesTranscriptCopyDe;

  /// No description provided for @coursesTranscriptCopyVi.
  ///
  /// In vi, this message translates to:
  /// **'Sao chép tiếng Việt'**
  String get coursesTranscriptCopyVi;

  /// No description provided for @coursesTranscriptHideVi.
  ///
  /// In vi, this message translates to:
  /// **'Ẩn VI'**
  String get coursesTranscriptHideVi;

  /// No description provided for @coursesTranscriptShowVi.
  ///
  /// In vi, this message translates to:
  /// **'Hiện VI'**
  String get coursesTranscriptShowVi;

  /// No description provided for @coursesTranscriptEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Bài này chưa có phụ đề.'**
  String get coursesTranscriptEmpty;

  /// No description provided for @coursesVocabularyCount.
  ///
  /// In vi, this message translates to:
  /// **'Từ vựng ({count})'**
  String coursesVocabularyCount(int count);

  /// No description provided for @coursesVocabularyEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Bài này chưa có danh sách từ vựng.'**
  String get coursesVocabularyEmpty;

  /// No description provided for @coursesCommentsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bình luận'**
  String get coursesCommentsTitle;

  /// No description provided for @coursesCommentsError.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được bình luận.'**
  String get coursesCommentsError;

  /// No description provided for @coursesCommentsEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có bình luận nào.'**
  String get coursesCommentsEmpty;

  /// No description provided for @coursesCommentsPlaceholder.
  ///
  /// In vi, this message translates to:
  /// **'Viết bình luận...'**
  String get coursesCommentsPlaceholder;

  /// No description provided for @coursesCommentsSendError.
  ///
  /// In vi, this message translates to:
  /// **'Gửi bình luận thất bại, thử lại.'**
  String get coursesCommentsSendError;

  /// No description provided for @coursesLessonVideoDone.
  ///
  /// In vi, this message translates to:
  /// **'✓ Video đã hoàn thành'**
  String get coursesLessonVideoDone;

  /// No description provided for @coursesLessonMarkVideoDone.
  ///
  /// In vi, this message translates to:
  /// **'🎉 Đánh dấu hoàn thành video'**
  String get coursesLessonMarkVideoDone;

  /// No description provided for @coursesLessonWatchHint.
  ///
  /// In vi, this message translates to:
  /// **'⏱️ Xem ít nhất 80% video để hoàn thành'**
  String get coursesLessonWatchHint;

  /// No description provided for @coursesLessonSaving.
  ///
  /// In vi, this message translates to:
  /// **'Đang lưu...'**
  String get coursesLessonSaving;

  /// No description provided for @coursesProgressSaveCta.
  ///
  /// In vi, this message translates to:
  /// **'Lưu tiến độ'**
  String get coursesProgressSaveCta;

  /// No description provided for @coursesProgressSaved.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu tiến độ'**
  String get coursesProgressSaved;

  /// No description provided for @coursesProgressSaveFailed.
  ///
  /// In vi, this message translates to:
  /// **'Lưu thất bại'**
  String get coursesProgressSaveFailed;

  /// No description provided for @coursesLessonHeading.
  ///
  /// In vi, this message translates to:
  /// **'Bài {number}: {name}'**
  String coursesLessonHeading(String number, String name);

  /// No description provided for @coursesLockedLessonTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bài học yêu cầu Premium'**
  String get coursesLockedLessonTitle;

  /// No description provided for @coursesLockedLessonDescription.
  ///
  /// In vi, this message translates to:
  /// **'Bài học này nằm ngoài giới hạn miễn phí. Nâng cấp để mở khóa toàn bộ nội dung.'**
  String get coursesLockedLessonDescription;

  /// No description provided for @missionComplete.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành nhiệm vụ!'**
  String get missionComplete;

  /// No description provided for @noMissionRounds.
  ///
  /// In vi, this message translates to:
  /// **'Không có vòng học nào trong bài từ vựng hôm nay.'**
  String get noMissionRounds;

  /// No description provided for @startPractice.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu luyện tập'**
  String get startPractice;

  /// No description provided for @missionPractice.
  ///
  /// In vi, this message translates to:
  /// **'Luyện tập'**
  String get missionPractice;

  /// No description provided for @notRemembered.
  ///
  /// In vi, this message translates to:
  /// **'Chưa nhớ'**
  String get notRemembered;

  /// No description provided for @rememberedCorrectly.
  ///
  /// In vi, this message translates to:
  /// **'Nhớ đúng'**
  String get rememberedCorrectly;

  /// No description provided for @missionAnswerCorrect.
  ///
  /// In vi, this message translates to:
  /// **'Chính xác!'**
  String get missionAnswerCorrect;

  /// No description provided for @missionAnswerTryAgain.
  ///
  /// In vi, this message translates to:
  /// **'Chưa đúng, cố lên!'**
  String get missionAnswerTryAgain;

  /// No description provided for @saving.
  ///
  /// In vi, this message translates to:
  /// **'Đang lưu…'**
  String get saving;

  /// No description provided for @saveToDeck.
  ///
  /// In vi, this message translates to:
  /// **'Lưu vào bộ thẻ'**
  String get saveToDeck;

  /// No description provided for @saved.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu'**
  String get saved;

  /// No description provided for @alreadySaved.
  ///
  /// In vi, this message translates to:
  /// **'Đã có'**
  String get alreadySaved;

  /// No description provided for @wordSavedToDeck.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu từ vào bộ thẻ.'**
  String get wordSavedToDeck;

  /// No description provided for @openDeck.
  ///
  /// In vi, this message translates to:
  /// **'Mở bộ thẻ'**
  String get openDeck;

  /// No description provided for @couldNotSaveWord.
  ///
  /// In vi, this message translates to:
  /// **'Không thể lưu từ này. Hãy đăng nhập và thử lại.'**
  String get couldNotSaveWord;

  /// No description provided for @chooseDeck.
  ///
  /// In vi, this message translates to:
  /// **'Chọn bộ thẻ'**
  String get chooseDeck;

  /// No description provided for @chooseDeckDescription.
  ///
  /// In vi, this message translates to:
  /// **'Lưu nhanh từ này hoặc chọn một bộ thẻ cụ thể.'**
  String get chooseDeckDescription;

  /// No description provided for @quickSave.
  ///
  /// In vi, this message translates to:
  /// **'Lưu nhanh'**
  String get quickSave;

  /// No description provided for @deviceSessionEnded.
  ///
  /// In vi, this message translates to:
  /// **'Phiên đăng nhập đã kết thúc'**
  String get deviceSessionEnded;

  /// No description provided for @deviceKickedBody.
  ///
  /// In vi, this message translates to:
  /// **'Thiết bị này đã bị đăng xuất. Vui lòng đăng nhập lại để tiếp tục.'**
  String get deviceKickedBody;

  /// No description provided for @signInAgain.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập lại'**
  String get signInAgain;

  /// No description provided for @wordNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy từ này trong từ điển.'**
  String get wordNotFound;

  /// No description provided for @lookingUpWord.
  ///
  /// In vi, this message translates to:
  /// **'Đang tra từ…'**
  String get lookingUpWord;

  /// No description provided for @couldNotLookupWord.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tra từ này lúc này. Vui lòng thử lại.'**
  String get couldNotLookupWord;

  /// No description provided for @meaning.
  ///
  /// In vi, this message translates to:
  /// **'Nghĩa'**
  String get meaning;

  /// No description provided for @example.
  ///
  /// In vi, this message translates to:
  /// **'Ví dụ'**
  String get example;

  /// No description provided for @saveSentence.
  ///
  /// In vi, this message translates to:
  /// **'Lưu câu'**
  String get saveSentence;

  /// No description provided for @sentenceSaved.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu câu'**
  String get sentenceSaved;

  /// No description provided for @couldNotSaveSentence.
  ///
  /// In vi, this message translates to:
  /// **'Không thể lưu câu lúc này.'**
  String get couldNotSaveSentence;

  /// No description provided for @couldNotSaveMissionRound.
  ///
  /// In vi, this message translates to:
  /// **'Không lưu được vòng học này. Vui lòng thử lại.'**
  String get couldNotSaveMissionRound;

  /// No description provided for @couldNotCompleteMission.
  ///
  /// In vi, this message translates to:
  /// **'Không hoàn tất được nhiệm vụ này. Vui lòng thử lại.'**
  String get couldNotCompleteMission;

  /// No description provided for @score.
  ///
  /// In vi, this message translates to:
  /// **'Điểm'**
  String get score;

  /// No description provided for @accuracy.
  ///
  /// In vi, this message translates to:
  /// **'Độ chính xác'**
  String get accuracy;

  /// No description provided for @playAgain.
  ///
  /// In vi, this message translates to:
  /// **'Chơi lại'**
  String get playAgain;

  /// No description provided for @missionCompletedXp.
  ///
  /// In vi, this message translates to:
  /// **'Đã hoàn thành · {xp} XP'**
  String missionCompletedXp(int xp);

  /// No description provided for @missionRoundsWords.
  ///
  /// In vi, this message translates to:
  /// **'{rounds} vòng · {words} từ'**
  String missionRoundsWords(int rounds, int words);

  /// No description provided for @missionResumeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Mở lại bài đang dở'**
  String get missionResumeTitle;

  /// No description provided for @missionResumeContinueCta.
  ///
  /// In vi, this message translates to:
  /// **'Sang vòng từ vựng'**
  String get missionResumeContinueCta;

  /// No description provided for @missionCompleteTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành!'**
  String get missionCompleteTitle;

  /// No description provided for @missionCompleteSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Xong bước từ vựng — lộ trình hôm nay còn các bước kỹ năng tiếp theo'**
  String get missionCompleteSubtitle;

  /// No description provided for @missionXpBadge.
  ///
  /// In vi, this message translates to:
  /// **'+{xp} XP'**
  String missionXpBadge(int xp);

  /// No description provided for @missionClimbedTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay bạn đã leo bậc:'**
  String get missionClimbedTitle;

  /// No description provided for @missionStreakUpdated.
  ///
  /// In vi, this message translates to:
  /// **'🔥 Streak hôm nay đã được cập nhật!'**
  String get missionStreakUpdated;

  /// No description provided for @missionNextStepCta.
  ///
  /// In vi, this message translates to:
  /// **'Bước tiếp theo →'**
  String get missionNextStepCta;

  /// No description provided for @missionMismatch.
  ///
  /// In vi, this message translates to:
  /// **'Phiên học không khớp. Về trang chủ để bắt đầu lại.'**
  String get missionMismatch;

  /// No description provided for @missionAlreadyDoneToday.
  ///
  /// In vi, this message translates to:
  /// **'Đã xong bài từ vựng hôm nay 🎉 Quay lại lộ trình để làm bước tiếp theo.'**
  String get missionAlreadyDoneToday;

  /// No description provided for @completed.
  ///
  /// In vi, this message translates to:
  /// **'Đã xong'**
  String get completed;

  /// No description provided for @more.
  ///
  /// In vi, this message translates to:
  /// **'Thêm'**
  String get more;

  /// No description provided for @moreFeaturesTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả tính năng'**
  String get moreFeaturesTitle;

  /// No description provided for @close.
  ///
  /// In vi, this message translates to:
  /// **'Đóng'**
  String get close;

  /// No description provided for @navConversation.
  ///
  /// In vi, this message translates to:
  /// **'Hội thoại'**
  String get navConversation;

  /// No description provided for @groupAccountOther.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản & Khác'**
  String get groupAccountOther;

  /// No description provided for @featureYoutube.
  ///
  /// In vi, this message translates to:
  /// **'YouTube'**
  String get featureYoutube;

  /// No description provided for @featureReadListen.
  ///
  /// In vi, this message translates to:
  /// **'Đọc & Nghe'**
  String get featureReadListen;

  /// No description provided for @featureListening.
  ///
  /// In vi, this message translates to:
  /// **'Nghe'**
  String get featureListening;

  /// No description provided for @featureReadingFeed.
  ///
  /// In vi, this message translates to:
  /// **'Đọc bài'**
  String get featureReadingFeed;

  /// No description provided for @featureNews.
  ///
  /// In vi, this message translates to:
  /// **'Tin tức'**
  String get featureNews;

  /// No description provided for @featureSubtitleWords.
  ///
  /// In vi, this message translates to:
  /// **'Từ vựng phụ đề'**
  String get featureSubtitleWords;

  /// No description provided for @featureFocusSession.
  ///
  /// In vi, this message translates to:
  /// **'Phiên tập trung'**
  String get featureFocusSession;

  /// No description provided for @featureCasesHub.
  ///
  /// In vi, this message translates to:
  /// **'Luyện 4 Cách'**
  String get featureCasesHub;

  /// No description provided for @featureMinimalPairs.
  ///
  /// In vi, this message translates to:
  /// **'Cặp âm dễ nhầm'**
  String get featureMinimalPairs;

  /// No description provided for @featurePronunciation.
  ///
  /// In vi, this message translates to:
  /// **'Luyện phát âm'**
  String get featurePronunciation;

  /// No description provided for @featureInterview.
  ///
  /// In vi, this message translates to:
  /// **'Phỏng vấn'**
  String get featureInterview;

  /// No description provided for @featureLearnerModel.
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ năng lực'**
  String get featureLearnerModel;

  /// No description provided for @featureExamReadiness.
  ///
  /// In vi, this message translates to:
  /// **'Sẵn sàng thi'**
  String get featureExamReadiness;

  /// No description provided for @featureErrorPatterns.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi hay gặp'**
  String get featureErrorPatterns;

  /// No description provided for @featureMessages.
  ///
  /// In vi, this message translates to:
  /// **'Tin nhắn'**
  String get featureMessages;

  /// No description provided for @featureFriends.
  ///
  /// In vi, this message translates to:
  /// **'Bạn bè'**
  String get featureFriends;

  /// No description provided for @featureExamSchedule.
  ///
  /// In vi, this message translates to:
  /// **'Tìm bạn ôn thi'**
  String get featureExamSchedule;

  /// No description provided for @featureDailyQuote.
  ///
  /// In vi, this message translates to:
  /// **'Trích dẫn hằng ngày'**
  String get featureDailyQuote;

  /// No description provided for @featureAffiliateIntro.
  ///
  /// In vi, this message translates to:
  /// **'Giới thiệu'**
  String get featureAffiliateIntro;

  /// No description provided for @featurePremiumUpgrade.
  ///
  /// In vi, this message translates to:
  /// **'Nâng cấp Premium'**
  String get featurePremiumUpgrade;

  /// No description provided for @featureAdmin.
  ///
  /// In vi, this message translates to:
  /// **'Quản trị'**
  String get featureAdmin;

  /// No description provided for @featureFeedback.
  ///
  /// In vi, this message translates to:
  /// **'Góp ý'**
  String get featureFeedback;

  /// No description provided for @featureLeaderboardFull.
  ///
  /// In vi, this message translates to:
  /// **'Bảng xếp hạng'**
  String get featureLeaderboardFull;

  /// No description provided for @featureAiAssistant.
  ///
  /// In vi, this message translates to:
  /// **'Trợ lý AI'**
  String get featureAiAssistant;

  /// No description provided for @groupVocabularyReview.
  ///
  /// In vi, this message translates to:
  /// **'Từ vựng & ôn tập'**
  String get groupVocabularyReview;

  /// No description provided for @groupExtraPractice.
  ///
  /// In vi, this message translates to:
  /// **'Luyện thêm'**
  String get groupExtraPractice;

  /// No description provided for @groupGrammarSkills.
  ///
  /// In vi, this message translates to:
  /// **'Ngữ pháp & kỹ năng'**
  String get groupGrammarSkills;

  /// No description provided for @groupCommunityProgress.
  ///
  /// In vi, this message translates to:
  /// **'Cộng đồng & tiến độ'**
  String get groupCommunityProgress;

  /// No description provided for @myWords.
  ///
  /// In vi, this message translates to:
  /// **'Kho từ'**
  String get myWords;

  /// No description provided for @savedWords.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu'**
  String get savedWords;

  /// No description provided for @viewedWords.
  ///
  /// In vi, this message translates to:
  /// **'Đã xem'**
  String get viewedWords;

  /// No description provided for @wordsToReview.
  ///
  /// In vi, this message translates to:
  /// **'Cần ôn'**
  String get wordsToReview;

  /// No description provided for @couldNotLoadMyWords.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được kho từ. Vui lòng thử lại.'**
  String get couldNotLoadMyWords;

  /// No description provided for @noWordsForFilter.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có từ nào trong nhóm này.'**
  String get noWordsForFilter;

  /// No description provided for @myWordsCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} từ'**
  String myWordsCount(int count);

  /// No description provided for @flashcardDecks.
  ///
  /// In vi, this message translates to:
  /// **'Bộ thẻ'**
  String get flashcardDecks;

  /// No description provided for @reviewDueDeckCards.
  ///
  /// In vi, this message translates to:
  /// **'Ôn thẻ đến hạn'**
  String get reviewDueDeckCards;

  /// No description provided for @emptyDeckCards.
  ///
  /// In vi, this message translates to:
  /// **'Bộ thẻ chưa có từ nào.'**
  String get emptyDeckCards;

  /// No description provided for @myDecks.
  ///
  /// In vi, this message translates to:
  /// **'Bộ từ của tôi'**
  String get myDecks;

  /// No description provided for @createDeck.
  ///
  /// In vi, this message translates to:
  /// **'Tạo bộ từ'**
  String get createDeck;

  /// No description provided for @createNewDeck.
  ///
  /// In vi, this message translates to:
  /// **'Tạo bộ từ mới'**
  String get createNewDeck;

  /// No description provided for @editDeck.
  ///
  /// In vi, this message translates to:
  /// **'Sửa bộ từ'**
  String get editDeck;

  /// No description provided for @deleteDeck.
  ///
  /// In vi, this message translates to:
  /// **'Xóa bộ từ'**
  String get deleteDeck;

  /// No description provided for @deleteDeckConfirmation.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc muốn xóa \"{name}\"?'**
  String deleteDeckConfirmation(Object name);

  /// No description provided for @couldNotLoadDecks.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được danh sách bộ từ.'**
  String get couldNotLoadDecks;

  /// No description provided for @noDecks.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có bộ từ nào'**
  String get noDecks;

  /// No description provided for @noDecksDescription.
  ///
  /// In vi, this message translates to:
  /// **'Tạo bộ từ riêng để học theo chủ đề bạn thích.'**
  String get noDecksDescription;

  /// No description provided for @deckName.
  ///
  /// In vi, this message translates to:
  /// **'Tên bộ từ'**
  String get deckName;

  /// No description provided for @deckNameHint.
  ///
  /// In vi, this message translates to:
  /// **'Ví dụ: Từ vựng du lịch'**
  String get deckNameHint;

  /// No description provided for @deckDescriptionOptional.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả (tùy chọn)'**
  String get deckDescriptionOptional;

  /// No description provided for @deckDescriptionHint.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả ngắn về bộ từ'**
  String get deckDescriptionHint;

  /// No description provided for @deckListSubtitleWithFolders.
  ///
  /// In vi, this message translates to:
  /// **'{decks} bộ thẻ · {folders} thư mục'**
  String deckListSubtitleWithFolders(int decks, int folders);

  /// No description provided for @deckIntroWhy.
  ///
  /// In vi, this message translates to:
  /// **'Những từ bạn tự lưu, gom theo bộ riêng.'**
  String get deckIntroWhy;

  /// No description provided for @deckIntroTodo.
  ///
  /// In vi, this message translates to:
  /// **'Mở một bộ để ôn hoặc thêm từ mới.'**
  String get deckIntroTodo;

  /// No description provided for @deckIntroNext.
  ///
  /// In vi, this message translates to:
  /// **'Từ trong sổ cũng vào lịch Ôn tập FSRS.'**
  String get deckIntroNext;

  /// No description provided for @deckIntroNextLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ôn tập'**
  String get deckIntroNextLabel;

  /// No description provided for @deckAllDecksTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả decks'**
  String get deckAllDecksTitle;

  /// No description provided for @deckQuickPracticeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Luyện tập nhanh'**
  String get deckQuickPracticeTitle;

  /// No description provided for @deckQuickPracticeCta.
  ///
  /// In vi, this message translates to:
  /// **'Chơi Word Sprint với từ trong sổ'**
  String get deckQuickPracticeCta;

  /// No description provided for @deckStarredTitle.
  ///
  /// In vi, this message translates to:
  /// **'Starred'**
  String get deckStarredTitle;

  /// No description provided for @deckStarredSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Thẻ đã gắn sao'**
  String get deckStarredSubtitle;

  /// No description provided for @deckFoldersTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thư mục'**
  String get deckFoldersTitle;

  /// No description provided for @deckDefaultTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Bộ thẻ mặc định'**
  String get deckDefaultTooltip;

  /// No description provided for @deckSetDefaultTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Đặt làm mặc định'**
  String get deckSetDefaultTooltip;

  /// No description provided for @deckDefaultBadge.
  ///
  /// In vi, this message translates to:
  /// **'Mặc định'**
  String get deckDefaultBadge;

  /// No description provided for @deckMoveToFolder.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển vào thư mục'**
  String get deckMoveToFolder;

  /// No description provided for @deckActionCreateDeck.
  ///
  /// In vi, this message translates to:
  /// **'Tạo bộ thẻ'**
  String get deckActionCreateDeck;

  /// No description provided for @deckActionCreateDeckSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Thêm bộ từ vựng mới'**
  String get deckActionCreateDeckSubtitle;

  /// No description provided for @deckActionCreateFolder.
  ///
  /// In vi, this message translates to:
  /// **'Tạo thư mục'**
  String get deckActionCreateFolder;

  /// No description provided for @deckActionCreateFolderSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Sắp xếp bộ thẻ theo nhóm'**
  String get deckActionCreateFolderSubtitle;

  /// No description provided for @deckActionSpeak.
  ///
  /// In vi, this message translates to:
  /// **'Nói ra ghi chú'**
  String get deckActionSpeak;

  /// No description provided for @deckActionSpeakSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Nói tiếng Đức → lưu từng câu thành thẻ'**
  String get deckActionSpeakSubtitle;

  /// No description provided for @deckFolderName.
  ///
  /// In vi, this message translates to:
  /// **'Tên thư mục'**
  String get deckFolderName;

  /// No description provided for @deckFolderNameHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: Từ vựng A1'**
  String get deckFolderNameHint;

  /// No description provided for @deckNoFolder.
  ///
  /// In vi, this message translates to:
  /// **'Không thuộc thư mục'**
  String get deckNoFolder;

  /// No description provided for @deckNoSearchResults.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy thẻ phù hợp.'**
  String get deckNoSearchResults;

  /// No description provided for @deckSearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm từ...'**
  String get deckSearchHint;

  /// No description provided for @deckStarredFilterTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ xem starred'**
  String get deckStarredFilterTooltip;

  /// No description provided for @deckAddCard.
  ///
  /// In vi, this message translates to:
  /// **'Thêm'**
  String get deckAddCard;

  /// No description provided for @deckCardFormRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập đủ mặt trước và mặt sau.'**
  String get deckCardFormRequired;

  /// No description provided for @deckCardFormSaveError.
  ///
  /// In vi, this message translates to:
  /// **'Không lưu được thẻ. Vui lòng thử lại.'**
  String get deckCardFormSaveError;

  /// No description provided for @deckEditCardTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sửa thẻ'**
  String get deckEditCardTitle;

  /// No description provided for @deckNewCardTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thêm thẻ mới'**
  String get deckNewCardTitle;

  /// No description provided for @deckCardFrontLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mặt trước (tiếng Đức)'**
  String get deckCardFrontLabel;

  /// No description provided for @deckCardFrontHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: das Haus'**
  String get deckCardFrontHint;

  /// No description provided for @deckCardBackLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mặt sau (tiếng Việt)'**
  String get deckCardBackLabel;

  /// No description provided for @deckCardBackHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: ngôi nhà'**
  String get deckCardBackHint;

  /// No description provided for @deckCardExampleLabel.
  ///
  /// In vi, this message translates to:
  /// **'Câu ví dụ (tùy chọn)'**
  String get deckCardExampleLabel;

  /// No description provided for @deckCardExampleHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: Das ist mein Haus.'**
  String get deckCardExampleHint;

  /// No description provided for @deckCardExampleViLabel.
  ///
  /// In vi, this message translates to:
  /// **'Dịch câu ví dụ (tùy chọn)'**
  String get deckCardExampleViLabel;

  /// No description provided for @deckFolderEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Thư mục chưa có bộ thẻ nào.'**
  String get deckFolderEmpty;

  /// No description provided for @deckStarredEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có thẻ nào được gắn sao.'**
  String get deckStarredEmpty;

  /// No description provided for @deckLessonTitle.
  ///
  /// In vi, this message translates to:
  /// **'Học theo bài'**
  String get deckLessonTitle;

  /// No description provided for @deckLessonBatchProgress.
  ///
  /// In vi, this message translates to:
  /// **'Đợt {current}/{total}'**
  String deckLessonBatchProgress(int current, int total);

  /// No description provided for @deckBackToDeck.
  ///
  /// In vi, this message translates to:
  /// **'Về bộ thẻ'**
  String get deckBackToDeck;

  /// No description provided for @deckLessonBatchDoneTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xong đợt này!'**
  String get deckLessonBatchDoneTitle;

  /// No description provided for @deckLessonBatchDoneSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Đúng {correct}/{total} thẻ'**
  String deckLessonBatchDoneSubtitle(int correct, int total);

  /// No description provided for @deckLessonFinish.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành'**
  String get deckLessonFinish;

  /// No description provided for @deckLessonNextBatch.
  ///
  /// In vi, this message translates to:
  /// **'Đợt tiếp theo'**
  String get deckLessonNextBatch;

  /// No description provided for @deckPlayCta.
  ///
  /// In vi, this message translates to:
  /// **'Chơi'**
  String get deckPlayCta;

  /// No description provided for @deckLearnCta.
  ///
  /// In vi, this message translates to:
  /// **'Học'**
  String get deckLearnCta;

  /// No description provided for @deckSpeakTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nói ra ghi chú'**
  String get deckSpeakTitle;

  /// No description provided for @deckSpeakHelper.
  ///
  /// In vi, this message translates to:
  /// **'Nói hoặc gõ tiếng Đức — mỗi câu sẽ thành một thẻ ghi nhớ.'**
  String get deckSpeakHelper;

  /// No description provided for @deckSpeakMicTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Nhấn để bắt đầu ghi âm'**
  String get deckSpeakMicTooltip;

  /// No description provided for @deckSpeakMicComingSoon.
  ///
  /// In vi, this message translates to:
  /// **'Ghi âm giọng nói sẽ sớm ra mắt'**
  String get deckSpeakMicComingSoon;

  /// No description provided for @deckSpeakTextareaHint.
  ///
  /// In vi, this message translates to:
  /// **'Mỗi dòng là một câu sẽ thành một thẻ...'**
  String get deckSpeakTextareaHint;

  /// No description provided for @deckSpeakDeckNameLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tên bộ thẻ'**
  String get deckSpeakDeckNameLabel;

  /// No description provided for @deckSpeakDeckNameHelper.
  ///
  /// In vi, this message translates to:
  /// **'Mỗi câu sẽ thành một thẻ trong bộ này.'**
  String get deckSpeakDeckNameHelper;

  /// No description provided for @deckSpeakSavedMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu {count} câu vào bộ thẻ mới.'**
  String deckSpeakSavedMessage(int count);

  /// No description provided for @deckSpeakViewDeck.
  ///
  /// In vi, this message translates to:
  /// **'Xem bộ thẻ →'**
  String get deckSpeakViewDeck;

  /// No description provided for @deckSpeakEmptyError.
  ///
  /// In vi, this message translates to:
  /// **'Nhập ít nhất một câu trước khi lưu.'**
  String get deckSpeakEmptyError;

  /// No description provided for @deckSpeakSaveError.
  ///
  /// In vi, this message translates to:
  /// **'Không lưu được. Vui lòng thử lại.'**
  String get deckSpeakSaveError;

  /// No description provided for @deckSpeakSaveCta.
  ///
  /// In vi, this message translates to:
  /// **'Lưu vào Notes'**
  String get deckSpeakSaveCta;

  /// No description provided for @edit.
  ///
  /// In vi, this message translates to:
  /// **'Sửa'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In vi, this message translates to:
  /// **'Xóa'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In vi, this message translates to:
  /// **'Lưu'**
  String get save;

  /// No description provided for @wordsCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} từ'**
  String wordsCount(int count);

  /// No description provided for @learnedWordsProgress.
  ///
  /// In vi, this message translates to:
  /// **'Đã học {learned}/{total}'**
  String learnedWordsProgress(int learned, int total);

  /// No description provided for @dailyReview.
  ///
  /// In vi, this message translates to:
  /// **'Ôn hàng ngày'**
  String get dailyReview;

  /// No description provided for @flashcardReview.
  ///
  /// In vi, this message translates to:
  /// **'Ôn từ'**
  String get flashcardReview;

  /// No description provided for @tapToShowMeaning.
  ///
  /// In vi, this message translates to:
  /// **'Chạm để xem nghĩa'**
  String get tapToShowMeaning;

  /// No description provided for @listenPronunciation.
  ///
  /// In vi, this message translates to:
  /// **'Nghe phát âm'**
  String get listenPronunciation;

  /// No description provided for @couldNotLoadReviewData.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được dữ liệu ôn tập.'**
  String get couldNotLoadReviewData;

  /// No description provided for @couldNotLoadReviewCards.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được thẻ ôn tập.'**
  String get couldNotLoadReviewCards;

  /// No description provided for @noCardsDueToday.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay không có thẻ nào đến hạn 🎉'**
  String get noCardsDueToday;

  /// No description provided for @backToHome.
  ///
  /// In vi, this message translates to:
  /// **'Về trang chủ'**
  String get backToHome;

  /// No description provided for @reviewStreak.
  ///
  /// In vi, this message translates to:
  /// **'Chuỗi {count} ngày! 🔥'**
  String reviewStreak(int count);

  /// No description provided for @keepReviewStreak.
  ///
  /// In vi, this message translates to:
  /// **'Giữ streak bằng cách ôn từ mỗi ngày'**
  String get keepReviewStreak;

  /// No description provided for @due.
  ///
  /// In vi, this message translates to:
  /// **'Đến hạn'**
  String get due;

  /// No description provided for @reviewed.
  ///
  /// In vi, this message translates to:
  /// **'Đã ôn'**
  String get reviewed;

  /// No description provided for @startDailyReview.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu ôn tập'**
  String get startDailyReview;

  /// No description provided for @showMeaning.
  ///
  /// In vi, this message translates to:
  /// **'Xem nghĩa'**
  String get showMeaning;

  /// No description provided for @reviewProgress.
  ///
  /// In vi, this message translates to:
  /// **'{current} / {total}'**
  String reviewProgress(int current, int total);

  /// No description provided for @couldNotSaveReview.
  ///
  /// In vi, this message translates to:
  /// **'Không thể lưu lần ôn này. Vui lòng thử lại.'**
  String get couldNotSaveReview;

  /// No description provided for @ratingAgain.
  ///
  /// In vi, this message translates to:
  /// **'Lại'**
  String get ratingAgain;

  /// No description provided for @ratingAgainHint.
  ///
  /// In vi, this message translates to:
  /// **'<1 phút'**
  String get ratingAgainHint;

  /// No description provided for @ratingHard.
  ///
  /// In vi, this message translates to:
  /// **'Khó'**
  String get ratingHard;

  /// No description provided for @ratingHardHint.
  ///
  /// In vi, this message translates to:
  /// **'Khó'**
  String get ratingHardHint;

  /// No description provided for @ratingGood.
  ///
  /// In vi, this message translates to:
  /// **'Tốt'**
  String get ratingGood;

  /// No description provided for @ratingGoodHint.
  ///
  /// In vi, this message translates to:
  /// **'OK'**
  String get ratingGoodHint;

  /// No description provided for @ratingEasy.
  ///
  /// In vi, this message translates to:
  /// **'Dễ'**
  String get ratingEasy;

  /// No description provided for @ratingEasyHint.
  ///
  /// In vi, this message translates to:
  /// **'Dễ'**
  String get ratingEasyHint;

  /// No description provided for @dailyReviewRoundLabel.
  ///
  /// In vi, this message translates to:
  /// **'Vòng {current}/{total}'**
  String dailyReviewRoundLabel(int current, int total);

  /// No description provided for @dailyReviewRoundWordCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} từ'**
  String dailyReviewRoundWordCount(int count);

  /// No description provided for @dailyReviewRoundStart.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu'**
  String get dailyReviewRoundStart;

  /// No description provided for @dailyReviewRoundDone.
  ///
  /// In vi, this message translates to:
  /// **'Xong {gameName}!'**
  String dailyReviewRoundDone(String gameName);

  /// No description provided for @dailyReviewRoundProgress.
  ///
  /// In vi, this message translates to:
  /// **'Đã ôn {reviewed}/{total} từ'**
  String dailyReviewRoundProgress(int reviewed, int total);

  /// No description provided for @dailyReviewRoundFinish.
  ///
  /// In vi, this message translates to:
  /// **'Xem kết quả'**
  String get dailyReviewRoundFinish;

  /// No description provided for @dailyReviewRoundContinue.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục'**
  String get dailyReviewRoundContinue;

  /// No description provided for @dailyReviewRetryBanner.
  ///
  /// In vi, this message translates to:
  /// **'Ôn lại các từ bạn vừa luyện.'**
  String get dailyReviewRetryBanner;

  /// No description provided for @dailyReviewEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Không có từ cần ôn!'**
  String get dailyReviewEmptyTitle;

  /// No description provided for @dailyReviewEmptySubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại sau hoặc luyện tập thêm'**
  String get dailyReviewEmptySubtitle;

  /// No description provided for @dailyReviewSessionLabel.
  ///
  /// In vi, this message translates to:
  /// **'Phiên ôn tập'**
  String get dailyReviewSessionLabel;

  /// No description provided for @dailyReviewStatusExcellent.
  ///
  /// In vi, this message translates to:
  /// **'Xuất sắc'**
  String get dailyReviewStatusExcellent;

  /// No description provided for @dailyReviewStatusGood.
  ///
  /// In vi, this message translates to:
  /// **'Khá tốt'**
  String get dailyReviewStatusGood;

  /// No description provided for @dailyReviewStatusNeedsWork.
  ///
  /// In vi, this message translates to:
  /// **'Cần ôn thêm'**
  String get dailyReviewStatusNeedsWork;

  /// No description provided for @dailyReviewCompletedTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành!'**
  String get dailyReviewCompletedTitle;

  /// No description provided for @dailyReviewWeakWordsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Từ cần ôn lại'**
  String get dailyReviewWeakWordsTitle;

  /// No description provided for @dailyReviewCtaMore.
  ///
  /// In vi, this message translates to:
  /// **'Ôn thêm'**
  String get dailyReviewCtaMore;

  /// No description provided for @dailyReviewCtaRetryWeak.
  ///
  /// In vi, this message translates to:
  /// **'Luyện lại {count} từ yếu'**
  String dailyReviewCtaRetryWeak(int count);

  /// No description provided for @dailyReviewCtaContinueLearning.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục học'**
  String get dailyReviewCtaContinueLearning;

  /// No description provided for @dailyReviewCtaListening.
  ///
  /// In vi, this message translates to:
  /// **'🎧 Luyện nghe'**
  String get dailyReviewCtaListening;

  /// No description provided for @dailyReviewCtaAskAi.
  ///
  /// In vi, this message translates to:
  /// **'✨ Hỏi AI về từ khó'**
  String get dailyReviewCtaAskAi;

  /// No description provided for @vocabularyLibrary.
  ///
  /// In vi, this message translates to:
  /// **'Kho chung'**
  String get vocabularyLibrary;

  /// No description provided for @vocabulary.
  ///
  /// In vi, this message translates to:
  /// **'Kho từ vựng'**
  String get vocabulary;

  /// No description provided for @couldNotLoadVocabulary.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được từ vựng. Vui lòng thử lại.'**
  String get couldNotLoadVocabulary;

  /// No description provided for @noVocabulary.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có từ vựng ở đây.'**
  String get noVocabulary;

  /// No description provided for @cefrLevelsCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} cấp độ CEFR'**
  String cefrLevelsCount(int count);

  /// No description provided for @vocabularyByGoal.
  ///
  /// In vi, this message translates to:
  /// **'Theo mục tiêu'**
  String get vocabularyByGoal;

  /// No description provided for @vocabularyByLevel.
  ///
  /// In vi, this message translates to:
  /// **'Theo cấp độ'**
  String get vocabularyByLevel;

  /// No description provided for @vocabularyByTopic.
  ///
  /// In vi, this message translates to:
  /// **'Theo chủ đề'**
  String get vocabularyByTopic;

  /// No description provided for @learnByGoal.
  ///
  /// In vi, this message translates to:
  /// **'Học theo mục tiêu'**
  String get learnByGoal;

  /// No description provided for @learnByGoalDescription.
  ///
  /// In vi, this message translates to:
  /// **'Các mục tiêu là lối vào nhanh, dùng lại cùng kho từ theo chủ đề và cấp độ.'**
  String get learnByGoalDescription;

  /// No description provided for @goalDailyLife.
  ///
  /// In vi, this message translates to:
  /// **'Dùng tiếng Đức hằng ngày'**
  String get goalDailyLife;

  /// No description provided for @goalSettlementHome.
  ///
  /// In vi, this message translates to:
  /// **'Định cư & nhà ở'**
  String get goalSettlementHome;

  /// No description provided for @goalTravel.
  ///
  /// In vi, this message translates to:
  /// **'Du lịch & di chuyển'**
  String get goalTravel;

  /// No description provided for @goalFoodService.
  ///
  /// In vi, this message translates to:
  /// **'Ăn uống & nhà hàng'**
  String get goalFoodService;

  /// No description provided for @goalWork.
  ///
  /// In vi, this message translates to:
  /// **'Công việc & nghề nghiệp'**
  String get goalWork;

  /// No description provided for @goalMedical.
  ///
  /// In vi, this message translates to:
  /// **'Y khoa / điều dưỡng'**
  String get goalMedical;

  /// No description provided for @goalStudyExam.
  ///
  /// In vi, this message translates to:
  /// **'Học tập & ôn thi'**
  String get goalStudyExam;

  /// No description provided for @goalTechEngineering.
  ///
  /// In vi, this message translates to:
  /// **'Công nghệ & kỹ thuật'**
  String get goalTechEngineering;

  /// No description provided for @goalShoppingBeauty.
  ///
  /// In vi, this message translates to:
  /// **'Mua sắm & làm đẹp'**
  String get goalShoppingBeauty;

  /// No description provided for @goalFamilySocial.
  ///
  /// In vi, this message translates to:
  /// **'Gia đình & quan hệ'**
  String get goalFamilySocial;

  /// No description provided for @goalLeisureCulture.
  ///
  /// In vi, this message translates to:
  /// **'Giải trí & văn hoá'**
  String get goalLeisureCulture;

  /// No description provided for @goalNatureEnvironment.
  ///
  /// In vi, this message translates to:
  /// **'Thiên nhiên & môi trường'**
  String get goalNatureEnvironment;

  /// No description provided for @vocabularyMine.
  ///
  /// In vi, this message translates to:
  /// **'Của tôi'**
  String get vocabularyMine;

  /// No description provided for @vocabularyIntroWhy.
  ///
  /// In vi, this message translates to:
  /// **'Kho từ hệ thống — chọn bộ để học và ôn.'**
  String get vocabularyIntroWhy;

  /// No description provided for @vocabularyIntroTodo.
  ///
  /// In vi, this message translates to:
  /// **'Mở một bộ từ để học thẻ mới.'**
  String get vocabularyIntroTodo;

  /// No description provided for @vocabularyIntroNext.
  ///
  /// In vi, this message translates to:
  /// **'Từ đã học sẽ vào lịch Ôn tập.'**
  String get vocabularyIntroNext;

  /// No description provided for @vocabularyIntroNextLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ôn tập'**
  String get vocabularyIntroNextLabel;

  /// No description provided for @vocabularyChooseGroupLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chọn nhóm chủ đề'**
  String get vocabularyChooseGroupLabel;

  /// No description provided for @vocabularyGoalTopicsCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} chủ đề'**
  String vocabularyGoalTopicsCount(int count);

  /// No description provided for @vocabularyTopicSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'📚 Chủ đề từ vựng'**
  String get vocabularyTopicSectionTitle;

  /// No description provided for @vocabularyTopicSectionDescription.
  ///
  /// In vi, this message translates to:
  /// **'Chọn nhóm chủ đề rồi mở nhanh từng chủ đề con theo cấp độ.'**
  String get vocabularyTopicSectionDescription;

  /// No description provided for @vocabularyLevelSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'🎯 Cấp độ CEFR'**
  String get vocabularyLevelSectionTitle;

  /// No description provided for @vocabularyLevelSectionDescription.
  ///
  /// In vi, this message translates to:
  /// **'Vào từng cấp độ rồi lọc chủ đề; hoặc bấm thẳng chip chủ đề bên dưới.'**
  String get vocabularyLevelSectionDescription;

  /// No description provided for @vocabularyTipTitle.
  ///
  /// In vi, this message translates to:
  /// **'Mẹo học tập'**
  String get vocabularyTipTitle;

  /// No description provided for @vocabularyTipNext.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp'**
  String get vocabularyTipNext;

  /// No description provided for @wordSprintSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'⚡ Luyện tập với chủ đề'**
  String get wordSprintSectionTitle;

  /// No description provided for @wordSprintStart.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu'**
  String get wordSprintStart;

  /// No description provided for @wordSprintDescription.
  ///
  /// In vi, this message translates to:
  /// **'60 giây · 4 đáp án · Combo x3'**
  String get wordSprintDescription;

  /// No description provided for @vocabularySearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm từ...'**
  String get vocabularySearchHint;

  /// No description provided for @vocabularyWeakFilter.
  ///
  /// In vi, this message translates to:
  /// **'Yếu'**
  String get vocabularyWeakFilter;

  /// No description provided for @vocabularyMasteredCount.
  ///
  /// In vi, this message translates to:
  /// **'{done}/{total} đã thuộc'**
  String vocabularyMasteredCount(int done, int total);

  /// No description provided for @vocabularyTabList.
  ///
  /// In vi, this message translates to:
  /// **'Danh sách'**
  String get vocabularyTabList;

  /// No description provided for @vocabularyTabMyWords.
  ///
  /// In vi, this message translates to:
  /// **'Từ của tôi'**
  String get vocabularyTabMyWords;

  /// No description provided for @vocabularyStartLesson.
  ///
  /// In vi, this message translates to:
  /// **'Học từ mới'**
  String get vocabularyStartLesson;

  /// No description provided for @vocabularyNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy bộ từ'**
  String get vocabularyNotFound;

  /// No description provided for @vocabularyMasteryMastered.
  ///
  /// In vi, this message translates to:
  /// **'Đã thuộc'**
  String get vocabularyMasteryMastered;

  /// No description provided for @vocabularyMasteryKnown.
  ///
  /// In vi, this message translates to:
  /// **'Đang nhớ'**
  String get vocabularyMasteryKnown;

  /// No description provided for @vocabularyMasteryLearning.
  ///
  /// In vi, this message translates to:
  /// **'Đang học'**
  String get vocabularyMasteryLearning;

  /// No description provided for @vocabularyMasteryNew.
  ///
  /// In vi, this message translates to:
  /// **'Mới'**
  String get vocabularyMasteryNew;

  /// No description provided for @myWordsGroupReviewing.
  ///
  /// In vi, this message translates to:
  /// **'Trong Ôn tập'**
  String get myWordsGroupReviewing;

  /// No description provided for @myWordsGroupSaved.
  ///
  /// In vi, this message translates to:
  /// **'Trong Sổ từ'**
  String get myWordsGroupSaved;

  /// No description provided for @myWordsGroupSeen.
  ///
  /// In vi, this message translates to:
  /// **'Đã gặp'**
  String get myWordsGroupSeen;

  /// No description provided for @myWordsSourceLabel.
  ///
  /// In vi, this message translates to:
  /// **'nguồn: {source}'**
  String myWordsSourceLabel(Object source);

  /// No description provided for @myWordsMoreCount.
  ///
  /// In vi, this message translates to:
  /// **'+{count} từ nữa trong nhóm này'**
  String myWordsMoreCount(int count);

  /// No description provided for @myWordsEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có từ nào trong kho của bạn'**
  String get myWordsEmptyTitle;

  /// No description provided for @myWordsEmptyDescription.
  ///
  /// In vi, this message translates to:
  /// **'Tra từ khi đọc/xem video hoặc lưu từ vào Sổ từ — chúng sẽ hiện ở đây.'**
  String get myWordsEmptyDescription;

  /// No description provided for @cefrLevel.
  ///
  /// In vi, this message translates to:
  /// **'Cấp độ {level}'**
  String cefrLevel(Object level);

  /// No description provided for @cefrBeginner.
  ///
  /// In vi, this message translates to:
  /// **'Sơ cấp'**
  String get cefrBeginner;

  /// No description provided for @cefrPreIntermediate.
  ///
  /// In vi, this message translates to:
  /// **'Tiền trung cấp'**
  String get cefrPreIntermediate;

  /// No description provided for @cefrIntermediate.
  ///
  /// In vi, this message translates to:
  /// **'Trung cấp'**
  String get cefrIntermediate;

  /// No description provided for @cefrUpperIntermediate.
  ///
  /// In vi, this message translates to:
  /// **'Trung cấp cao'**
  String get cefrUpperIntermediate;

  /// No description provided for @cefrAdvanced.
  ///
  /// In vi, this message translates to:
  /// **'Cao cấp'**
  String get cefrAdvanced;

  /// No description provided for @cefrProficient.
  ///
  /// In vi, this message translates to:
  /// **'Thành thạo'**
  String get cefrProficient;

  /// No description provided for @noVocabularyTopics.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có chủ đề từ vựng nào.'**
  String get noVocabularyTopics;

  /// No description provided for @vocabularyTopicStats.
  ///
  /// In vi, this message translates to:
  /// **'{label} · {count} từ'**
  String vocabularyTopicStats(Object label, int count);

  /// No description provided for @vocabularyTopicTitle.
  ///
  /// In vi, this message translates to:
  /// **'Từ vựng: {topic}'**
  String vocabularyTopicTitle(Object topic);

  /// No description provided for @noVocabularyInLesson.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có từ vựng trong bài học này.'**
  String get noVocabularyInLesson;

  /// No description provided for @noMatchingVocabulary.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có từ phù hợp với bộ lọc.'**
  String get noMatchingVocabulary;

  /// No description provided for @clearVocabularyFilters.
  ///
  /// In vi, this message translates to:
  /// **'Hãy thử bỏ một bộ lọc.'**
  String get clearVocabularyFilters;

  /// No description provided for @searchLessonVocabulary.
  ///
  /// In vi, this message translates to:
  /// **'Tìm trong bài học…'**
  String get searchLessonVocabulary;

  /// No description provided for @allLevels.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get allLevels;

  /// No description provided for @lessonProgress.
  ///
  /// In vi, this message translates to:
  /// **'Tiến độ: {learned} / {total} từ'**
  String lessonProgress(int learned, int total);

  /// No description provided for @wordMeanings.
  ///
  /// In vi, this message translates to:
  /// **'Nghĩa'**
  String get wordMeanings;

  /// No description provided for @wordExamples.
  ///
  /// In vi, this message translates to:
  /// **'Ví dụ'**
  String get wordExamples;

  /// No description provided for @viewVocabularyDetails.
  ///
  /// In vi, this message translates to:
  /// **'Xem chi tiết'**
  String get viewVocabularyDetails;

  /// No description provided for @flipVocabularyCard.
  ///
  /// In vi, this message translates to:
  /// **'Lật thẻ'**
  String get flipVocabularyCard;

  /// No description provided for @noMeaning.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có nghĩa'**
  String get noMeaning;

  /// No description provided for @wordGender.
  ///
  /// In vi, this message translates to:
  /// **'Giống'**
  String get wordGender;

  /// No description provided for @wordPlural.
  ///
  /// In vi, this message translates to:
  /// **'Số nhiều'**
  String get wordPlural;

  /// No description provided for @wordType.
  ///
  /// In vi, this message translates to:
  /// **'Loại'**
  String get wordType;

  /// No description provided for @auxiliaryVerb.
  ///
  /// In vi, this message translates to:
  /// **'Trợ động từ'**
  String get auxiliaryVerb;

  /// No description provided for @comparative.
  ///
  /// In vi, this message translates to:
  /// **'So sánh hơn'**
  String get comparative;

  /// No description provided for @superlative.
  ///
  /// In vi, this message translates to:
  /// **'So sánh nhất'**
  String get superlative;

  /// No description provided for @verbConjugation.
  ///
  /// In vi, this message translates to:
  /// **'Chia động từ'**
  String get verbConjugation;

  /// No description provided for @principalForms.
  ///
  /// In vi, this message translates to:
  /// **'Dạng chính'**
  String get principalForms;

  /// No description provided for @relatedWords.
  ///
  /// In vi, this message translates to:
  /// **'Từ liên quan'**
  String get relatedWords;

  /// No description provided for @flashcardPractice.
  ///
  /// In vi, this message translates to:
  /// **'Flashcard'**
  String get flashcardPractice;

  /// No description provided for @practice.
  ///
  /// In vi, this message translates to:
  /// **'Luyện tập'**
  String get practice;

  /// No description provided for @listeningPractice.
  ///
  /// In vi, this message translates to:
  /// **'Luyện nghe'**
  String get listeningPractice;

  /// No description provided for @newsReading.
  ///
  /// In vi, this message translates to:
  /// **'Tin tức Đức'**
  String get newsReading;

  /// No description provided for @writingPractice.
  ///
  /// In vi, this message translates to:
  /// **'Luyện viết'**
  String get writingPractice;

  /// No description provided for @aiChat.
  ///
  /// In vi, this message translates to:
  /// **'AI chat'**
  String get aiChat;

  /// No description provided for @grammar.
  ///
  /// In vi, this message translates to:
  /// **'Ngữ pháp'**
  String get grammar;

  /// No description provided for @grammarSearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm bài ngữ pháp bất kỳ...'**
  String get grammarSearchHint;

  /// No description provided for @grammarNoResults.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy bài nào'**
  String get grammarNoResults;

  /// No description provided for @grammarNoLessons.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có bài học'**
  String get grammarNoLessons;

  /// No description provided for @grammarAllDone.
  ///
  /// In vi, this message translates to:
  /// **'🎉 Hoàn thành rồi!'**
  String get grammarAllDone;

  /// No description provided for @grammarViewAll.
  ///
  /// In vi, this message translates to:
  /// **'Xem tất cả'**
  String get grammarViewAll;

  /// No description provided for @grammarMarkComplete.
  ///
  /// In vi, this message translates to:
  /// **'Đánh dấu hoàn thành'**
  String get grammarMarkComplete;

  /// No description provided for @grammarCompleted.
  ///
  /// In vi, this message translates to:
  /// **'Đã hoàn thành'**
  String get grammarCompleted;

  /// No description provided for @grammarAlreadyCompleted.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã hoàn thành bài này trước đó.'**
  String get grammarAlreadyCompleted;

  /// No description provided for @grammarRelatedLessons.
  ///
  /// In vi, this message translates to:
  /// **'Bài liên quan'**
  String get grammarRelatedLessons;

  /// No description provided for @grammarNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy bài học.'**
  String get grammarNotFound;

  /// No description provided for @grammarArticleNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy bài viết.'**
  String get grammarArticleNotFound;

  /// No description provided for @grammarSearchInLevelHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm bài trong {level}...'**
  String grammarSearchInLevelHint(String level);

  /// No description provided for @grammarSearchResultsCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} kết quả cho “{query}” — tất cả trình độ'**
  String grammarSearchResultsCount(int count, String query);

  /// No description provided for @grammarLeaderboardTitleAll.
  ///
  /// In vi, this message translates to:
  /// **'Bảng xếp hạng'**
  String get grammarLeaderboardTitleAll;

  /// No description provided for @grammarLeaderboardTitleLevel.
  ///
  /// In vi, this message translates to:
  /// **'Bảng xếp hạng {level}'**
  String grammarLeaderboardTitleLevel(String level);

  /// No description provided for @grammarProgressLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tiến trình'**
  String get grammarProgressLabel;

  /// No description provided for @grammarProgressLabelLevel.
  ///
  /// In vi, this message translates to:
  /// **'Tiến trình {level}'**
  String grammarProgressLabelLevel(String level);

  /// No description provided for @grammarLeaderboardEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có ai tham gia'**
  String get grammarLeaderboardEmpty;

  /// No description provided for @grammarYourRank.
  ///
  /// In vi, this message translates to:
  /// **'Hạng của bạn: #{rank} · {count} bài'**
  String grammarYourRank(int rank, int count);

  /// No description provided for @grammarCompletedOfTotal.
  ///
  /// In vi, this message translates to:
  /// **'{done}/{total} bài đã hoàn thành'**
  String grammarCompletedOfTotal(int done, int total);

  /// No description provided for @grammarReadTime.
  ///
  /// In vi, this message translates to:
  /// **'⏱ {elapsed}s / {minTime}s'**
  String grammarReadTime(int elapsed, int minTime);

  /// No description provided for @grammarScrolled80.
  ///
  /// In vi, this message translates to:
  /// **'📜 Đã cuộn 80%'**
  String get grammarScrolled80;

  /// No description provided for @grammarScrollNeeded.
  ///
  /// In vi, this message translates to:
  /// **'📜 Cần cuộn đến 80%'**
  String get grammarScrollNeeded;

  /// No description provided for @grammarReadGateHint.
  ///
  /// In vi, this message translates to:
  /// **'Nút sẽ mở khi bạn cuộn đến 80% nội dung và đọc đủ thời gian tối thiểu.'**
  String get grammarReadGateHint;

  /// No description provided for @grammarMarkCompleteXp.
  ///
  /// In vi, this message translates to:
  /// **'Đánh dấu hoàn thành (+5 XP)'**
  String get grammarMarkCompleteXp;

  /// No description provided for @grammarMarkCompleteAgain.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành lại'**
  String get grammarMarkCompleteAgain;

  /// No description provided for @grammarJustCompleted.
  ///
  /// In vi, this message translates to:
  /// **'✓ Đã hoàn thành'**
  String get grammarJustCompleted;

  /// No description provided for @grammarSaving.
  ///
  /// In vi, this message translates to:
  /// **'Đang lưu...'**
  String get grammarSaving;

  /// No description provided for @grammarArticleSource.
  ///
  /// In vi, this message translates to:
  /// **'Nguồn: deutsch.vn'**
  String get grammarArticleSource;

  /// No description provided for @grammarPracticeExercises.
  ///
  /// In vi, this message translates to:
  /// **'Bài tập luyện tập'**
  String get grammarPracticeExercises;

  /// No description provided for @grammarExerciseCorrect.
  ///
  /// In vi, this message translates to:
  /// **'✓ Chính xác!'**
  String get grammarExerciseCorrect;

  /// No description provided for @grammarExerciseWrong.
  ///
  /// In vi, this message translates to:
  /// **'✗ Sai. Đáp án đúng: {answer}.'**
  String grammarExerciseWrong(String answer);

  /// No description provided for @gamePractice.
  ///
  /// In vi, this message translates to:
  /// **'Luyện game'**
  String get gamePractice;

  /// No description provided for @community.
  ///
  /// In vi, this message translates to:
  /// **'Cộng đồng'**
  String get community;

  /// No description provided for @statistics.
  ///
  /// In vi, this message translates to:
  /// **'Thống kê'**
  String get statistics;

  /// No description provided for @achievements.
  ///
  /// In vi, this message translates to:
  /// **'Thành tích'**
  String get achievements;

  /// No description provided for @leaderboard.
  ///
  /// In vi, this message translates to:
  /// **'BXH'**
  String get leaderboard;

  /// No description provided for @offlineMessage.
  ///
  /// In vi, this message translates to:
  /// **'Mất kết nối internet. Một số tính năng có thể bị giới hạn.'**
  String get offlineMessage;

  /// No description provided for @appearance.
  ///
  /// In vi, this message translates to:
  /// **'Giao diện'**
  String get appearance;

  /// No description provided for @themeMode.
  ///
  /// In vi, this message translates to:
  /// **'Chế độ giao diện'**
  String get themeMode;

  /// No description provided for @systemTheme.
  ///
  /// In vi, this message translates to:
  /// **'Theo hệ thống'**
  String get systemTheme;

  /// No description provided for @lightTheme.
  ///
  /// In vi, this message translates to:
  /// **'Sáng'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In vi, this message translates to:
  /// **'Tối'**
  String get darkTheme;

  /// No description provided for @sound.
  ///
  /// In vi, this message translates to:
  /// **'Âm thanh'**
  String get sound;

  /// No description provided for @pronunciationVolume.
  ///
  /// In vi, this message translates to:
  /// **'Âm lượng phát âm'**
  String get pronunciationVolume;

  /// No description provided for @autoplayPronunciation.
  ///
  /// In vi, this message translates to:
  /// **'Tự động phát âm'**
  String get autoplayPronunciation;

  /// No description provided for @autoplayDescription.
  ///
  /// In vi, this message translates to:
  /// **'Phát âm thanh khi lật thẻ'**
  String get autoplayDescription;

  /// No description provided for @language.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get language;

  /// No description provided for @appLanguage.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ ứng dụng'**
  String get appLanguage;

  /// No description provided for @selectLanguage.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngôn ngữ'**
  String get selectLanguage;

  /// No description provided for @notifications.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get notifications;

  /// No description provided for @learningReminders.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo nhắc nhở'**
  String get learningReminders;

  /// No description provided for @learningRemindersDescription.
  ///
  /// In vi, this message translates to:
  /// **'Nhận thông báo hàng ngày để học tập'**
  String get learningRemindersDescription;

  /// No description provided for @reminderTime.
  ///
  /// In vi, this message translates to:
  /// **'Giờ nhắc nhở'**
  String get reminderTime;

  /// No description provided for @securityAndAccount.
  ///
  /// In vi, this message translates to:
  /// **'Bảo mật & tài khoản'**
  String get securityAndAccount;

  /// No description provided for @security.
  ///
  /// In vi, this message translates to:
  /// **'Bảo mật'**
  String get security;

  /// No description provided for @signedInDevices.
  ///
  /// In vi, this message translates to:
  /// **'Thiết bị đang đăng nhập'**
  String get signedInDevices;

  /// No description provided for @signOutOtherDevicesTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất khỏi thiết bị khác?'**
  String get signOutOtherDevicesTitle;

  /// No description provided for @signOutOtherDevicesBody.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả phiên đăng nhập khác sẽ bị đăng xuất. Bạn vẫn giữ phiên hiện tại trên thiết bị này.'**
  String get signOutOtherDevicesBody;

  /// No description provided for @cancel.
  ///
  /// In vi, this message translates to:
  /// **'Huỷ'**
  String get cancel;

  /// No description provided for @signOut.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get signOut;

  /// No description provided for @signOutConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Bạn chắc chắn muốn đăng xuất?'**
  String get signOutConfirm;

  /// No description provided for @signOutOtherDevices.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất khỏi tất cả thiết bị khác'**
  String get signOutOtherDevices;

  /// No description provided for @signedOutOtherDevices.
  ///
  /// In vi, this message translates to:
  /// **'Đã đăng xuất khỏi các thiết bị khác.'**
  String get signedOutOtherDevices;

  /// No description provided for @signedOutDevice.
  ///
  /// In vi, this message translates to:
  /// **'Đã đăng xuất thiết bị.'**
  String get signedOutDevice;

  /// No description provided for @signOutDeviceTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất thiết bị này?'**
  String get signOutDeviceTitle;

  /// No description provided for @signOutDeviceBody.
  ///
  /// In vi, this message translates to:
  /// **'Thiết bị \"{device}\" sẽ bị đăng xuất khỏi tài khoản của bạn.'**
  String signOutDeviceBody(Object device);

  /// No description provided for @couldNotSignOut.
  ///
  /// In vi, this message translates to:
  /// **'Không thể đăng xuất. Vui lòng thử lại.'**
  String get couldNotSignOut;

  /// No description provided for @couldNotLoadDevices.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải danh sách thiết bị.'**
  String get couldNotLoadDevices;

  /// No description provided for @retry.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get retry;

  /// No description provided for @noSignedInDevices.
  ///
  /// In vi, this message translates to:
  /// **'Không có thiết bị nào đang đăng nhập.'**
  String get noSignedInDevices;

  /// No description provided for @account.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản'**
  String get account;

  /// No description provided for @deleteAccount.
  ///
  /// In vi, this message translates to:
  /// **'Xoá tài khoản'**
  String get deleteAccount;

  /// No description provided for @deleteAccountDescription.
  ///
  /// In vi, this message translates to:
  /// **'Xem cách yêu cầu xoá tài khoản và dữ liệu liên quan.'**
  String get deleteAccountDescription;

  /// No description provided for @accountDeletionUnavailableTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xoá tài khoản trong ứng dụng chưa khả dụng'**
  String get accountDeletionUnavailableTitle;

  /// No description provided for @accountDeletionUnavailableBody.
  ///
  /// In vi, this message translates to:
  /// **'Để yêu cầu xoá tài khoản và dữ liệu liên quan, hãy liên hệ support@deutschtiger.com từ địa chỉ email đã đăng ký. Ứng dụng không thể xác nhận yêu cầu xoá cho đến khi backend hỗ trợ quy trình này.'**
  String get accountDeletionUnavailableBody;

  /// No description provided for @contactSupport.
  ///
  /// In vi, this message translates to:
  /// **'Liên hệ hỗ trợ'**
  String get contactSupport;

  /// No description provided for @unknownDevice.
  ///
  /// In vi, this message translates to:
  /// **'Thiết bị không xác định'**
  String get unknownDevice;

  /// No description provided for @currentDevice.
  ///
  /// In vi, this message translates to:
  /// **'Hiện tại'**
  String get currentDevice;

  /// No description provided for @signOutThisDevice.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất thiết bị này'**
  String get signOutThisDevice;

  /// No description provided for @justNow.
  ///
  /// In vi, this message translates to:
  /// **'Vừa xong'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In vi, this message translates to:
  /// **'{count} phút trước'**
  String minutesAgo(int count);

  /// No description provided for @hoursAgo.
  ///
  /// In vi, this message translates to:
  /// **'{count} giờ trước'**
  String hoursAgo(int count);

  /// No description provided for @daysAgo.
  ///
  /// In vi, this message translates to:
  /// **'{count} ngày trước'**
  String daysAgo(int count);

  /// No description provided for @securityDevices.
  ///
  /// In vi, this message translates to:
  /// **'Bảo mật & thiết bị'**
  String get securityDevices;

  /// No description provided for @securityDevicesDescription.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý phiên đăng nhập, xoá tài khoản'**
  String get securityDevicesDescription;

  /// No description provided for @changePassword.
  ///
  /// In vi, this message translates to:
  /// **'Đổi mật khẩu'**
  String get changePassword;

  /// No description provided for @changeEmail.
  ///
  /// In vi, this message translates to:
  /// **'Đổi email'**
  String get changeEmail;

  /// No description provided for @exportData.
  ///
  /// In vi, this message translates to:
  /// **'Xuất dữ liệu'**
  String get exportData;

  /// No description provided for @exportDataDescription.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu bản sao dữ liệu học tập của bạn'**
  String get exportDataDescription;

  /// No description provided for @dataExportUnavailable.
  ///
  /// In vi, this message translates to:
  /// **'Xuất dữ liệu trong ứng dụng chưa khả dụng. Vui lòng liên hệ support@deutschtiger.com.'**
  String get dataExportUnavailable;

  /// No description provided for @couldNotOpenLink.
  ///
  /// In vi, this message translates to:
  /// **'Không thể mở liên kết này.'**
  String get couldNotOpenLink;

  /// No description provided for @unexpectedDisplayError.
  ///
  /// In vi, this message translates to:
  /// **'Đã xảy ra lỗi khi hiển thị trang này.'**
  String get unexpectedDisplayError;

  /// No description provided for @openLinkError.
  ///
  /// In vi, this message translates to:
  /// **'Đã xảy ra lỗi khi mở liên kết.'**
  String get openLinkError;

  /// No description provided for @ratingThanks.
  ///
  /// In vi, this message translates to:
  /// **'Cảm ơn bạn đã đánh giá!'**
  String get ratingThanks;

  /// No description provided for @ai.
  ///
  /// In vi, this message translates to:
  /// **'AI'**
  String get ai;

  /// No description provided for @aiMemorySettings.
  ///
  /// In vi, this message translates to:
  /// **'Bộ nhớ & cài đặt AI'**
  String get aiMemorySettings;

  /// No description provided for @aiMemoryDescription.
  ///
  /// In vi, this message translates to:
  /// **'Cấp độ, bài thi, gợi ý ngữ pháp'**
  String get aiMemoryDescription;

  /// No description provided for @sendFeedback.
  ///
  /// In vi, this message translates to:
  /// **'Gửi phản hồi'**
  String get sendFeedback;

  /// No description provided for @sendFeedbackDescription.
  ///
  /// In vi, this message translates to:
  /// **'Giúp chúng tôi cải thiện ứng dụng'**
  String get sendFeedbackDescription;

  /// No description provided for @feedbackTitle.
  ///
  /// In vi, this message translates to:
  /// **'Gửi phản hồi'**
  String get feedbackTitle;

  /// No description provided for @feedbackCategoryBug.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi'**
  String get feedbackCategoryBug;

  /// No description provided for @feedbackCategorySuggestion.
  ///
  /// In vi, this message translates to:
  /// **'Góp ý'**
  String get feedbackCategorySuggestion;

  /// No description provided for @feedbackCategoryOther.
  ///
  /// In vi, this message translates to:
  /// **'Khác'**
  String get feedbackCategoryOther;

  /// No description provided for @feedbackDescriptionHint.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả chi tiết...'**
  String get feedbackDescriptionHint;

  /// No description provided for @feedbackMessageRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập nội dung phản hồi.'**
  String get feedbackMessageRequired;

  /// No description provided for @feedbackSent.
  ///
  /// In vi, this message translates to:
  /// **'Cảm ơn bạn đã gửi phản hồi!'**
  String get feedbackSent;

  /// No description provided for @feedbackCouldNotSend.
  ///
  /// In vi, this message translates to:
  /// **'Không gửi được phản hồi, thử lại sau.'**
  String get feedbackCouldNotSend;

  /// No description provided for @sendAction.
  ///
  /// In vi, this message translates to:
  /// **'Gửi'**
  String get sendAction;

  /// No description provided for @about.
  ///
  /// In vi, this message translates to:
  /// **'Về ứng dụng'**
  String get about;

  /// No description provided for @version.
  ///
  /// In vi, this message translates to:
  /// **'Phiên bản'**
  String get version;

  /// No description provided for @termsOfService.
  ///
  /// In vi, this message translates to:
  /// **'Điều khoản sử dụng'**
  String get termsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In vi, this message translates to:
  /// **'Chính sách bảo mật'**
  String get privacyPolicy;

  /// No description provided for @helpCenter.
  ///
  /// In vi, this message translates to:
  /// **'Trung tâm trợ giúp'**
  String get helpCenter;

  /// No description provided for @rateApp.
  ///
  /// In vi, this message translates to:
  /// **'Đánh giá ứng dụng'**
  String get rateApp;

  /// No description provided for @statsScreenTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thống kê học tập'**
  String get statsScreenTitle;

  /// No description provided for @statsMasteryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Độ nhớ từ vựng'**
  String get statsMasteryTitle;

  /// No description provided for @statsErrorPatternsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi hay gặp'**
  String get statsErrorPatternsTitle;

  /// No description provided for @statsCurrentStreak.
  ///
  /// In vi, this message translates to:
  /// **'Streak hiện tại'**
  String get statsCurrentStreak;

  /// No description provided for @statsDaysUnit.
  ///
  /// In vi, this message translates to:
  /// **'ngày'**
  String get statsDaysUnit;

  /// No description provided for @statsCurrentLevel.
  ///
  /// In vi, this message translates to:
  /// **'Cấp độ hiện tại'**
  String get statsCurrentLevel;

  /// No description provided for @statsWordsLearned.
  ///
  /// In vi, this message translates to:
  /// **'Từ đã học'**
  String get statsWordsLearned;

  /// No description provided for @statsTotalReviews.
  ///
  /// In vi, this message translates to:
  /// **'Tổng lượt ôn'**
  String get statsTotalReviews;

  /// No description provided for @statsWeeklyXpChartTitle.
  ///
  /// In vi, this message translates to:
  /// **'XP 7 ngày qua'**
  String get statsWeeklyXpChartTitle;

  /// No description provided for @statsMasteryTrendEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dữ liệu thống kê theo ngày (cập nhật mỗi đêm).'**
  String get statsMasteryTrendEmpty;

  /// No description provided for @statsErrorPatternsEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dữ liệu lỗi.'**
  String get statsErrorPatternsEmpty;

  /// No description provided for @statsMasteryEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dữ liệu. Hãy ôn vài từ để bắt đầu theo dõi độ nhớ.'**
  String get statsMasteryEmpty;

  /// No description provided for @statsMasteryNew.
  ///
  /// In vi, this message translates to:
  /// **'Mới'**
  String get statsMasteryNew;

  /// No description provided for @statsMasteryLearning.
  ///
  /// In vi, this message translates to:
  /// **'Đang học'**
  String get statsMasteryLearning;

  /// No description provided for @statsMasteryYoung.
  ///
  /// In vi, this message translates to:
  /// **'Đang nhớ'**
  String get statsMasteryYoung;

  /// No description provided for @statsMasteryMature.
  ///
  /// In vi, this message translates to:
  /// **'Thuộc lòng'**
  String get statsMasteryMature;

  /// No description provided for @statsMasteryTrendTitle.
  ///
  /// In vi, this message translates to:
  /// **'Ôn tập 30 ngày qua'**
  String get statsMasteryTrendTitle;

  /// No description provided for @statsScreenSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Theo dõi tiến độ, thói quen và hiệu suất học mỗi ngày.'**
  String get statsScreenSubtitle;

  /// No description provided for @statsOverviewLevelNote.
  ///
  /// In vi, this message translates to:
  /// **'Mở khóa nội dung mới'**
  String get statsOverviewLevelNote;

  /// No description provided for @statsOverviewTotalXp.
  ///
  /// In vi, this message translates to:
  /// **'Tổng XP'**
  String get statsOverviewTotalXp;

  /// No description provided for @statsOverviewXpNote.
  ///
  /// In vi, this message translates to:
  /// **'Điểm kinh nghiệm tích lũy'**
  String get statsOverviewXpNote;

  /// No description provided for @statsOverviewStreakNote.
  ///
  /// In vi, this message translates to:
  /// **'Chuỗi học liên tiếp'**
  String get statsOverviewStreakNote;

  /// No description provided for @statsOverviewBestStreak.
  ///
  /// In vi, this message translates to:
  /// **'Streak tốt nhất'**
  String get statsOverviewBestStreak;

  /// No description provided for @statsOverviewBestStreakNote.
  ///
  /// In vi, this message translates to:
  /// **'Kỷ lục cá nhân'**
  String get statsOverviewBestStreakNote;

  /// No description provided for @statsProgressLevelTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tiến độ lên cấp'**
  String get statsProgressLevelTitle;

  /// No description provided for @statsProgressLevelSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Level {level} sang {nextLevel}'**
  String statsProgressLevelSubtitle(int level, int nextLevel);

  /// No description provided for @statsProgressLevelRemaining.
  ///
  /// In vi, this message translates to:
  /// **'Còn {count} XP để lên level.'**
  String statsProgressLevelRemaining(int count);

  /// No description provided for @statsProgressDailyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu XP hôm nay'**
  String get statsProgressDailyTitle;

  /// No description provided for @statsProgressDailySubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Duy trì thói quen học mỗi ngày'**
  String get statsProgressDailySubtitle;

  /// No description provided for @statsProgressDailyDone.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã hoàn thành mục tiêu hôm nay.'**
  String get statsProgressDailyDone;

  /// No description provided for @statsProgressDailyRemaining.
  ///
  /// In vi, this message translates to:
  /// **'Cần thêm {count} XP để đạt mục tiêu.'**
  String statsProgressDailyRemaining(int count);

  /// No description provided for @statsXpChartWeekTotal.
  ///
  /// In vi, this message translates to:
  /// **'Tổng tuần này: {total} XP'**
  String statsXpChartWeekTotal(int total);

  /// No description provided for @statsXpChartMax.
  ///
  /// In vi, this message translates to:
  /// **'Cao nhất: {max} XP'**
  String statsXpChartMax(int max);

  /// No description provided for @statsOnlineTimeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian online 7 ngày'**
  String get statsOnlineTimeTitle;

  /// No description provided for @statsOnlineTimeWeekTotal.
  ///
  /// In vi, this message translates to:
  /// **'Tổng tuần này: {duration}'**
  String statsOnlineTimeWeekTotal(String duration);

  /// No description provided for @statsOnlineTimeToday.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay: {duration}'**
  String statsOnlineTimeToday(String duration);

  /// No description provided for @statsReviewCardsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thống kê ôn tập'**
  String get statsReviewCardsTitle;

  /// No description provided for @statsReviewToday.
  ///
  /// In vi, this message translates to:
  /// **'Ôn tập hôm nay'**
  String get statsReviewToday;

  /// No description provided for @statsReviewTodayNote.
  ///
  /// In vi, this message translates to:
  /// **'Số lượt ôn trong ngày'**
  String get statsReviewTodayNote;

  /// No description provided for @statsReviewWeek.
  ///
  /// In vi, this message translates to:
  /// **'Ôn tập tuần này'**
  String get statsReviewWeek;

  /// No description provided for @statsReviewWeekNote.
  ///
  /// In vi, this message translates to:
  /// **'Tổng trong 7 ngày'**
  String get statsReviewWeekNote;

  /// No description provided for @statsReviewAccuracy.
  ///
  /// In vi, this message translates to:
  /// **'Độ chính xác'**
  String get statsReviewAccuracy;

  /// No description provided for @statsReviewAccuracyNote.
  ///
  /// In vi, this message translates to:
  /// **'Tỉ lệ trả lời đúng'**
  String get statsReviewAccuracyNote;

  /// No description provided for @statsReviewDue.
  ///
  /// In vi, this message translates to:
  /// **'Cần ôn tập'**
  String get statsReviewDue;

  /// No description provided for @statsReviewDueNote.
  ///
  /// In vi, this message translates to:
  /// **'Thẻ đến hạn ôn'**
  String get statsReviewDueNote;

  /// No description provided for @statsSuggestionsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý cải thiện'**
  String get statsSuggestionsTitle;

  /// No description provided for @statsSuggestionStreak.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu streak mới hôm nay!'**
  String get statsSuggestionStreak;

  /// No description provided for @statsSuggestionListening.
  ///
  /// In vi, this message translates to:
  /// **'Chưa luyện nghe tuần này!'**
  String get statsSuggestionListening;

  /// No description provided for @statsSuggestionReviewAll.
  ///
  /// In vi, this message translates to:
  /// **'Ôn đều 3 kỹ năng để tiến bộ nhanh hơn!'**
  String get statsSuggestionReviewAll;

  /// No description provided for @statsSpacedRepetitionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Spaced Repetition hoạt động thế nào?'**
  String get statsSpacedRepetitionTitle;

  /// No description provided for @statsSpacedRepetitionBody.
  ///
  /// In vi, this message translates to:
  /// **'Hệ thống dùng thuật toán SM-2 để tối ưu lịch ôn. Từ bạn nhớ tốt sẽ xuất hiện thưa hơn, còn từ khó sẽ quay lại sớm hơn. Cách này giúp tiết kiệm thời gian và tăng khả năng nhớ dài hạn.'**
  String get statsSpacedRepetitionBody;

  /// No description provided for @statsCefrTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ năng lực'**
  String get statsCefrTitle;

  /// No description provided for @statsCefrA1.
  ///
  /// In vi, this message translates to:
  /// **'Sơ cấp'**
  String get statsCefrA1;

  /// No description provided for @statsCefrA2.
  ///
  /// In vi, this message translates to:
  /// **'Tiền trung cấp'**
  String get statsCefrA2;

  /// No description provided for @statsCefrB1.
  ///
  /// In vi, this message translates to:
  /// **'Trung cấp'**
  String get statsCefrB1;

  /// No description provided for @statsCefrB2.
  ///
  /// In vi, this message translates to:
  /// **'Trung cấp cao'**
  String get statsCefrB2;

  /// No description provided for @statsCefrC1.
  ///
  /// In vi, this message translates to:
  /// **'Cao cấp'**
  String get statsCefrC1;

  /// No description provided for @statsCefrC2.
  ///
  /// In vi, this message translates to:
  /// **'Thành thạo'**
  String get statsCefrC2;

  /// No description provided for @statsCefrWordsLearned.
  ///
  /// In vi, this message translates to:
  /// **'{count} từ đã ôn tập'**
  String statsCefrWordsLearned(int count);

  /// No description provided for @statsNearAchievementsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thành tựu sắp đạt'**
  String get statsNearAchievementsTitle;

  /// No description provided for @statsAchievementsGridTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bộ sưu tập thành tựu'**
  String get statsAchievementsGridTitle;

  /// No description provided for @statsLeaderboardTableTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bảng xếp hạng'**
  String get statsLeaderboardTableTitle;

  /// No description provided for @statsLeaderboardTop.
  ///
  /// In vi, this message translates to:
  /// **'Top {count}'**
  String statsLeaderboardTop(int count);

  /// No description provided for @statsLeaderboardYou.
  ///
  /// In vi, this message translates to:
  /// **'Bạn'**
  String get statsLeaderboardYou;

  /// No description provided for @errorPatternsSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Sổ lỗi ngữ pháp, tổng hợp từ bài viết, bài nói và bài thi của bạn.'**
  String get errorPatternsSubtitle;

  /// No description provided for @errorPatternsIntroWhy.
  ///
  /// In vi, this message translates to:
  /// **'Tổng hợp lỗi bạn hay mắc khi viết, do AI chấm.'**
  String get errorPatternsIntroWhy;

  /// No description provided for @errorPatternsIntroTodo.
  ///
  /// In vi, this message translates to:
  /// **'Chọn một lỗi và bấm luyện đúng dạng đó.'**
  String get errorPatternsIntroTodo;

  /// No description provided for @errorPatternsIntroNext.
  ///
  /// In vi, this message translates to:
  /// **'Sửa được lỗi nào thì tần suất nó giảm dần.'**
  String get errorPatternsIntroNext;

  /// No description provided for @errorPatternsDrillWriting.
  ///
  /// In vi, this message translates to:
  /// **'Luyện viết'**
  String get errorPatternsDrillWriting;

  /// No description provided for @errorPatternsDrillArtikel.
  ///
  /// In vi, this message translates to:
  /// **'Luyện Der/Die/Das'**
  String get errorPatternsDrillArtikel;

  /// No description provided for @errorPatternsDrillSentenceBuilder.
  ///
  /// In vi, this message translates to:
  /// **'Luyện viết câu'**
  String get errorPatternsDrillSentenceBuilder;

  /// No description provided for @errorPatternsDrillWordOrder.
  ///
  /// In vi, this message translates to:
  /// **'Luyện xếp từ'**
  String get errorPatternsDrillWordOrder;

  /// No description provided for @errorPatternsDrillPreposition.
  ///
  /// In vi, this message translates to:
  /// **'Luyện giới từ'**
  String get errorPatternsDrillPreposition;

  /// No description provided for @errorPatternsDrillNoun.
  ///
  /// In vi, this message translates to:
  /// **'Ôn danh từ'**
  String get errorPatternsDrillNoun;

  /// No description provided for @errorPatternsDrillSpelling.
  ///
  /// In vi, this message translates to:
  /// **'Luyện chính tả'**
  String get errorPatternsDrillSpelling;

  /// No description provided for @errorPatternsDrillGrammar.
  ///
  /// In vi, this message translates to:
  /// **'Ôn ngữ pháp'**
  String get errorPatternsDrillGrammar;

  /// No description provided for @errorPatternsDrillTense.
  ///
  /// In vi, this message translates to:
  /// **'Luyện thì'**
  String get errorPatternsDrillTense;

  /// No description provided for @errorPatternsDrillExam.
  ///
  /// In vi, this message translates to:
  /// **'Làm bài thi'**
  String get errorPatternsDrillExam;

  /// No description provided for @errorSourceSchreibenExam.
  ///
  /// In vi, this message translates to:
  /// **'Thi viết'**
  String get errorSourceSchreibenExam;

  /// No description provided for @errorSourceSprechen.
  ///
  /// In vi, this message translates to:
  /// **'Nói'**
  String get errorSourceSprechen;

  /// No description provided for @errorSourceSentenceBuilder.
  ///
  /// In vi, this message translates to:
  /// **'Luyện câu'**
  String get errorSourceSentenceBuilder;

  /// No description provided for @errorTypeArticleGender.
  ///
  /// In vi, this message translates to:
  /// **'Giống danh từ (der/die/das)'**
  String get errorTypeArticleGender;

  /// No description provided for @errorTypeCaseAkkDat.
  ///
  /// In vi, this message translates to:
  /// **'Cách (Akkusativ/Dativ)'**
  String get errorTypeCaseAkkDat;

  /// No description provided for @errorTypeVerbConjugation.
  ///
  /// In vi, this message translates to:
  /// **'Chia động từ'**
  String get errorTypeVerbConjugation;

  /// No description provided for @errorTypeVerbPosition.
  ///
  /// In vi, this message translates to:
  /// **'Vị trí động từ'**
  String get errorTypeVerbPosition;

  /// No description provided for @errorTypeWordOrder.
  ///
  /// In vi, this message translates to:
  /// **'Trật tự từ'**
  String get errorTypeWordOrder;

  /// No description provided for @errorTypePreposition.
  ///
  /// In vi, this message translates to:
  /// **'Giới từ'**
  String get errorTypePreposition;

  /// No description provided for @errorTypePlural.
  ///
  /// In vi, this message translates to:
  /// **'Số nhiều'**
  String get errorTypePlural;

  /// No description provided for @errorTypeSpelling.
  ///
  /// In vi, this message translates to:
  /// **'Chính tả'**
  String get errorTypeSpelling;

  /// No description provided for @errorTypePunctuation.
  ///
  /// In vi, this message translates to:
  /// **'Dấu câu'**
  String get errorTypePunctuation;

  /// No description provided for @errorTypeTenseConsistency.
  ///
  /// In vi, this message translates to:
  /// **'Nhất quán thì'**
  String get errorTypeTenseConsistency;

  /// No description provided for @errorTypeOther.
  ///
  /// In vi, this message translates to:
  /// **'Khác'**
  String get errorTypeOther;

  /// No description provided for @errorPatternsSortCount.
  ///
  /// In vi, this message translates to:
  /// **'Số lần'**
  String get errorPatternsSortCount;

  /// No description provided for @errorPatternsSortRecent.
  ///
  /// In vi, this message translates to:
  /// **'Gần đây'**
  String get errorPatternsSortRecent;

  /// No description provided for @errorPatternsEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dữ liệu lỗi'**
  String get errorPatternsEmptyTitle;

  /// No description provided for @errorPatternsEmptyBody.
  ///
  /// In vi, this message translates to:
  /// **'Hãy luyện viết câu hoặc làm bài thi để bắt đầu theo dõi!'**
  String get errorPatternsEmptyBody;

  /// No description provided for @errorPatternsTimesCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} lần'**
  String errorPatternsTimesCount(int count);

  /// No description provided for @errorPatternsExample.
  ///
  /// In vi, this message translates to:
  /// **'Ví dụ'**
  String get errorPatternsExample;

  /// No description provided for @dailyQuoteTitle.
  ///
  /// In vi, this message translates to:
  /// **'Câu nói hôm nay'**
  String get dailyQuoteTitle;

  /// No description provided for @dailyQuoteCopySuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã sao chép câu nói!'**
  String get dailyQuoteCopySuccess;

  /// No description provided for @dailyQuoteExploreMore.
  ///
  /// In vi, this message translates to:
  /// **'Khám phá thêm'**
  String get dailyQuoteExploreMore;

  /// No description provided for @dailyQuoteRetryTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Tải lại'**
  String get dailyQuoteRetryTooltip;

  /// No description provided for @back.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại'**
  String get back;

  /// No description provided for @focusSessionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tập trung hôm nay'**
  String get focusSessionTitle;

  /// No description provided for @focusSessionSummary.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có {count} mục cần luyện hôm nay.'**
  String focusSessionSummary(int count);

  /// No description provided for @focusSessionDueWordsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Từ tới hạn ôn'**
  String get focusSessionDueWordsTitle;

  /// No description provided for @focusSessionDueWordsEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Không có từ nào tới hạn 🎉'**
  String get focusSessionDueWordsEmpty;

  /// No description provided for @focusSessionReviewNow.
  ///
  /// In vi, this message translates to:
  /// **'Ôn ngay'**
  String get focusSessionReviewNow;

  /// No description provided for @focusSessionExamFailTitle.
  ///
  /// In vi, this message translates to:
  /// **'Từ thi sai'**
  String get focusSessionExamFailTitle;

  /// No description provided for @focusSessionExamFailEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dữ liệu từ bài thi'**
  String get focusSessionExamFailEmpty;

  /// No description provided for @focusSessionSubtitleWordsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Từ từ video'**
  String get focusSessionSubtitleWordsTitle;

  /// No description provided for @focusSessionSubtitleWordsEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có từ nào gặp trong video'**
  String get focusSessionSubtitleWordsEmpty;

  /// No description provided for @focusSessionAddToReview.
  ///
  /// In vi, this message translates to:
  /// **'Thêm vào ôn'**
  String get focusSessionAddToReview;

  /// No description provided for @focusSessionWeaknessesTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi hay gặp'**
  String get focusSessionWeaknessesTitle;

  /// No description provided for @focusSessionWeaknessesEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dữ liệu lỗi — hãy luyện viết để nhận phân tích'**
  String get focusSessionWeaknessesEmpty;

  /// No description provided for @focusSessionWeaknessesCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} loại lỗi ngữ pháp thường gặp'**
  String focusSessionWeaknessesCount(int count);

  /// No description provided for @focusSessionCaughtUpTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đang rất ổn!'**
  String get focusSessionCaughtUpTitle;

  /// No description provided for @focusSessionCaughtUpBody.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có điểm yếu nào cần luyện. Hãy làm một bài kiểm tra hoặc học từ mới để nhận gợi ý cá nhân hóa.'**
  String get focusSessionCaughtUpBody;

  /// No description provided for @focusSessionSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Những gì bạn nên luyện ngay bây giờ, dựa trên điểm yếu thật của bạn.'**
  String get focusSessionSubtitle;

  /// No description provided for @focusSessionGoalDefaultCta.
  ///
  /// In vi, this message translates to:
  /// **'Đặt mục tiêu thi để lộ trình chính xác hơn →'**
  String get focusSessionGoalDefaultCta;

  /// No description provided for @focusSessionGoalWithDays.
  ///
  /// In vi, this message translates to:
  /// **'🎯 Vì bạn thi {level} sau {days} ngày'**
  String focusSessionGoalWithDays(String level, int days);

  /// No description provided for @focusSessionGoalNoDays.
  ///
  /// In vi, this message translates to:
  /// **'🎯 Vì mục tiêu {level} của bạn'**
  String focusSessionGoalNoDays(String level);

  /// No description provided for @focusSessionNoHistoryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa đủ dữ liệu để tìm điểm yếu'**
  String get focusSessionNoHistoryTitle;

  /// No description provided for @focusSessionNoHistoryBody.
  ///
  /// In vi, this message translates to:
  /// **'Bạn chưa có lịch sử ôn tập nào — hãy lưu vài từ và làm một buổi ôn để hệ thống nhận ra điểm yếu thật của bạn.'**
  String get focusSessionNoHistoryBody;

  /// No description provided for @focusSessionSaveWordsCta.
  ///
  /// In vi, this message translates to:
  /// **'Lưu từ mới'**
  String get focusSessionSaveWordsCta;

  /// No description provided for @focusSessionReviewNowCta.
  ///
  /// In vi, this message translates to:
  /// **'Ôn ngay'**
  String get focusSessionReviewNowCta;

  /// No description provided for @focusSessionLearnNewWordsCta.
  ///
  /// In vi, this message translates to:
  /// **'Học từ mới'**
  String get focusSessionLearnNewWordsCta;

  /// No description provided for @focusSessionWeaknessesFooterLink.
  ///
  /// In vi, this message translates to:
  /// **'Xem lỗi hay gặp'**
  String get focusSessionWeaknessesFooterLink;

  /// No description provided for @learnerModelTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ năng lực'**
  String get learnerModelTitle;

  /// No description provided for @learnerModelCardsSuffix.
  ///
  /// In vi, this message translates to:
  /// **'thẻ đã thuộc'**
  String get learnerModelCardsSuffix;

  /// No description provided for @learnerModelMasteryHint.
  ///
  /// In vi, this message translates to:
  /// **'Thuộc = ổn định ghi nhớ từ 21 ngày trở lên (FSRS).'**
  String get learnerModelMasteryHint;

  /// No description provided for @learnerModelDueNow.
  ///
  /// In vi, this message translates to:
  /// **'Tới hạn ôn'**
  String get learnerModelDueNow;

  /// No description provided for @learnerModelWeakTotal.
  ///
  /// In vi, this message translates to:
  /// **'Điểm yếu'**
  String get learnerModelWeakTotal;

  /// No description provided for @learnerModelTotalCards.
  ///
  /// In vi, this message translates to:
  /// **'Tổng thẻ'**
  String get learnerModelTotalCards;

  /// No description provided for @learnerModelCoverageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Độ phủ theo trình độ'**
  String get learnerModelCoverageTitle;

  /// No description provided for @learnerModelGrammarWeaknessesTitle.
  ///
  /// In vi, this message translates to:
  /// **'Điểm yếu ngữ pháp'**
  String get learnerModelGrammarWeaknessesTitle;

  /// No description provided for @learnerModelErrorCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} lần sai'**
  String learnerModelErrorCount(int count);

  /// No description provided for @learnerModelCanDoSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Việc làm được bằng tiếng Đức'**
  String get learnerModelCanDoSectionTitle;

  /// No description provided for @learnerModelCanDoEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dữ liệu — luyện sản sinh (viết/nói) để leo thang nhé!'**
  String get learnerModelCanDoEmpty;

  /// No description provided for @learnerModelWeakWordsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Điểm yếu cần luyện'**
  String get learnerModelWeakWordsTitle;

  /// No description provided for @learnerModelWeakWordsEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có từ nào cần luyện thêm. Tuyệt vời!'**
  String get learnerModelWeakWordsEmpty;

  /// No description provided for @learnerModelLapsesCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} lần quên'**
  String learnerModelLapsesCount(int count);

  /// No description provided for @learnerModelSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Độ thành thạo, việc làm được và điểm cần cải thiện.'**
  String get learnerModelSubtitle;

  /// No description provided for @learnerModelReadinessTitle.
  ///
  /// In vi, this message translates to:
  /// **'Mức sẵn sàng thi (ước lượng)'**
  String get learnerModelReadinessTitle;

  /// No description provided for @learnerModelReadinessBasis.
  ///
  /// In vi, this message translates to:
  /// **'Tính từ: kết quả luyện thi gần đây.'**
  String get learnerModelReadinessBasis;

  /// No description provided for @learnerModelReadinessNoData.
  ///
  /// In vi, this message translates to:
  /// **'Chưa đủ dữ liệu — làm vài đề luyện thi để ước lượng độ sẵn sàng.'**
  String get learnerModelReadinessNoData;

  /// No description provided for @learnerModelLevelPracticeCta.
  ///
  /// In vi, this message translates to:
  /// **'Luyện theo cấp {level} →'**
  String learnerModelLevelPracticeCta(String level);

  /// No description provided for @learnerModelWeeklyRecapTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tuần vừa qua'**
  String get learnerModelWeeklyRecapTitle;

  /// No description provided for @learnerModelWeeklyRecapEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có bậc nào leo tuần này — luyện thêm để lên bậc!'**
  String get learnerModelWeeklyRecapEmpty;

  /// No description provided for @learnerModelWeeklyRecapStreak.
  ///
  /// In vi, this message translates to:
  /// **'🔥 Chuỗi sản sinh {days} ngày'**
  String learnerModelWeeklyRecapStreak(int days);

  /// No description provided for @canDoStatusSpoken.
  ///
  /// In vi, this message translates to:
  /// **'Nói được 🗣️'**
  String get canDoStatusSpoken;

  /// No description provided for @canDoStatusMastered.
  ///
  /// In vi, this message translates to:
  /// **'Làm được ✍️'**
  String get canDoStatusMastered;

  /// No description provided for @canDoStatusInProgress.
  ///
  /// In vi, this message translates to:
  /// **'Đang lên'**
  String get canDoStatusInProgress;

  /// No description provided for @canDoStatusNew.
  ///
  /// In vi, this message translates to:
  /// **'Chưa bắt đầu'**
  String get canDoStatusNew;

  /// No description provided for @canDoPracticeNow.
  ///
  /// In vi, this message translates to:
  /// **'Luyện ngay'**
  String get canDoPracticeNow;

  /// No description provided for @canDoPracticeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Luyện việc làm được'**
  String get canDoPracticeTitle;

  /// No description provided for @canDoPracticeProgress.
  ///
  /// In vi, this message translates to:
  /// **'Câu {current}/{total}'**
  String canDoPracticeProgress(int current, int total);

  /// No description provided for @canDoPracticeInstructionStructure.
  ///
  /// In vi, this message translates to:
  /// **'Viết một câu có dùng {pattern}'**
  String canDoPracticeInstructionStructure(Object pattern);

  /// No description provided for @canDoPracticeInstructionVocab.
  ///
  /// In vi, this message translates to:
  /// **'Viết một câu có dùng từ «{word}»'**
  String canDoPracticeInstructionVocab(Object word);

  /// No description provided for @canDoPracticeInputHint.
  ///
  /// In vi, this message translates to:
  /// **'Viết câu tiếng Đức của bạn…'**
  String get canDoPracticeInputHint;

  /// No description provided for @canDoPracticeError.
  ///
  /// In vi, this message translates to:
  /// **'Không chấm được câu — thử lại sau ít phút.'**
  String get canDoPracticeError;

  /// No description provided for @canDoPracticeCorrectedPrefix.
  ///
  /// In vi, this message translates to:
  /// **'Sửa'**
  String get canDoPracticeCorrectedPrefix;

  /// No description provided for @canDoPracticeFinish.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành'**
  String get canDoPracticeFinish;

  /// No description provided for @canDoPracticeNext.
  ///
  /// In vi, this message translates to:
  /// **'Câu tiếp theo'**
  String get canDoPracticeNext;

  /// No description provided for @canDoPracticeSubmitting.
  ///
  /// In vi, this message translates to:
  /// **'Đang chấm…'**
  String get canDoPracticeSubmitting;

  /// No description provided for @canDoPracticeSubmit.
  ///
  /// In vi, this message translates to:
  /// **'Nộp câu'**
  String get canDoPracticeSubmit;

  /// No description provided for @canDoPracticeNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy mục tiêu này.'**
  String get canDoPracticeNotFound;

  /// No description provided for @canDoPracticeAllClear.
  ///
  /// In vi, this message translates to:
  /// **'Đã viết được hết các khối của mục tiêu này 🎉'**
  String get canDoPracticeAllClear;

  /// No description provided for @canDoPracticeDone.
  ///
  /// In vi, this message translates to:
  /// **'Xong! {correct}/{total} câu đạt — tiến độ đã được ghi vào bản đồ.'**
  String canDoPracticeDone(int correct, int total);

  /// No description provided for @canDoPracticeBackLink.
  ///
  /// In vi, this message translates to:
  /// **'← Bản đồ năng lực'**
  String get canDoPracticeBackLink;

  /// No description provided for @canDoPracticeBackToMap.
  ///
  /// In vi, this message translates to:
  /// **'Về bản đồ năng lực'**
  String get canDoPracticeBackToMap;

  /// No description provided for @canDoPracticeGoConversation.
  ///
  /// In vi, this message translates to:
  /// **'Luyện hội thoại'**
  String get canDoPracticeGoConversation;

  /// No description provided for @topicExploreTitle.
  ///
  /// In vi, this message translates to:
  /// **'Khám phá theo chủ đề'**
  String get topicExploreTitle;

  /// No description provided for @topicExploreSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Xem hướng từ vựng đang ưu tiên · ghim ⭐ để lái lộ trình'**
  String get topicExploreSubtitle;

  /// No description provided for @learnPageIntroWhy.
  ///
  /// In vi, this message translates to:
  /// **'Đây là nơi bạn học từ vựng và ngữ pháp mỗi ngày theo lộ trình cá nhân.'**
  String get learnPageIntroWhy;

  /// No description provided for @learnPageIntroTodo.
  ///
  /// In vi, this message translates to:
  /// **'Làm phiên hôm nay, xem tiến độ A1→C2 và nhiệm vụ tuần.'**
  String get learnPageIntroTodo;

  /// No description provided for @learnPageIntroNext.
  ///
  /// In vi, this message translates to:
  /// **'Xong phiên hôm nay, quay lại đây để nhận nhiệm vụ tiếp theo.'**
  String get learnPageIntroNext;

  /// No description provided for @learnPageIntroCta.
  ///
  /// In vi, this message translates to:
  /// **'Tới Ôn tập'**
  String get learnPageIntroCta;

  /// No description provided for @levelJourneyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hành trình A1→C2'**
  String get levelJourneyTitle;

  /// No description provided for @levelJourneyEmptyLevel.
  ///
  /// In vi, this message translates to:
  /// **'đang bổ sung'**
  String get levelJourneyEmptyLevel;

  /// No description provided for @levelJourneyDetailCta.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết →'**
  String get levelJourneyDetailCta;

  /// No description provided for @capabilityMapSnapshotTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bản đồ năng lực'**
  String get capabilityMapSnapshotTitle;

  /// No description provided for @capabilityMapMasteredCount.
  ///
  /// In vi, this message translates to:
  /// **'{mastered}/{total} việc đã làm được'**
  String capabilityMapMasteredCount(int mastered, int total);

  /// No description provided for @capabilityMapViewCta.
  ///
  /// In vi, this message translates to:
  /// **'Xem bản đồ →'**
  String get capabilityMapViewCta;

  /// No description provided for @topicExploreEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có chủ đề nào.'**
  String get topicExploreEmpty;

  /// No description provided for @topicExploreSubtitleHeader.
  ///
  /// In vi, this message translates to:
  /// **'Từ vựng hằng ngày tự chọn theo hướng của bạn — ghim ⭐ để lái thêm'**
  String get topicExploreSubtitleHeader;

  /// No description provided for @topicSteeringTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lộ trình đang ưu tiên'**
  String get topicSteeringTitle;

  /// No description provided for @topicSteeringGoalGoethe.
  ///
  /// In vi, this message translates to:
  /// **'🎓 Thi Goethe'**
  String get topicSteeringGoalGoethe;

  /// No description provided for @topicSteeringGoalConversation.
  ///
  /// In vi, this message translates to:
  /// **'💬 Giao tiếp'**
  String get topicSteeringGoalConversation;

  /// No description provided for @topicSteeringGoalNursing.
  ///
  /// In vi, this message translates to:
  /// **'🏥 Điều dưỡng'**
  String get topicSteeringGoalNursing;

  /// No description provided for @topicSteeringGoalAbroad.
  ///
  /// In vi, this message translates to:
  /// **'✈️ Du học · làm việc'**
  String get topicSteeringGoalAbroad;

  /// No description provided for @topicSteeringEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có hướng nào — ghim chủ đề bên dưới hoặc đặt mục tiêu trong Cài đặt.'**
  String get topicSteeringEmpty;

  /// No description provided for @topicSteeringFooterHint.
  ///
  /// In vi, this message translates to:
  /// **'Từ mới trong nhiệm vụ hằng ngày được chọn theo các hướng này, từ thiết yếu trước.'**
  String get topicSteeringFooterHint;

  /// No description provided for @topicGroupSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'{label} · {count} chủ đề'**
  String topicGroupSubtitle(String label, int count);

  /// No description provided for @practiceTitle.
  ///
  /// In vi, this message translates to:
  /// **'Luyện tập'**
  String get practiceTitle;

  /// No description provided for @practiceChooseMode.
  ///
  /// In vi, this message translates to:
  /// **'Chọn chế độ luyện tập'**
  String get practiceChooseMode;

  /// No description provided for @practiceModeCloze.
  ///
  /// In vi, this message translates to:
  /// **'Điền từ'**
  String get practiceModeCloze;

  /// No description provided for @practiceModeListening.
  ///
  /// In vi, this message translates to:
  /// **'Luyện nghe'**
  String get practiceModeListening;

  /// No description provided for @practiceModeMatching.
  ///
  /// In vi, this message translates to:
  /// **'Nối từ'**
  String get practiceModeMatching;

  /// No description provided for @practiceModeWriting.
  ///
  /// In vi, this message translates to:
  /// **'Luyện viết'**
  String get practiceModeWriting;

  /// No description provided for @practiceClozeHint.
  ///
  /// In vi, this message translates to:
  /// **'Gõ từ tiếng Đức còn thiếu'**
  String get practiceClozeHint;

  /// No description provided for @practiceWritingHint.
  ///
  /// In vi, this message translates to:
  /// **'Gõ từ tiếng Đức'**
  String get practiceWritingHint;

  /// No description provided for @practiceCheckAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra'**
  String get practiceCheckAnswer;

  /// No description provided for @practiceListeningPrompt.
  ///
  /// In vi, this message translates to:
  /// **'Chạm vào thẻ để lật và xem nghĩa'**
  String get practiceListeningPrompt;

  /// No description provided for @practiceFeedbackCorrect.
  ///
  /// In vi, this message translates to:
  /// **'Chính xác!'**
  String get practiceFeedbackCorrect;

  /// No description provided for @practiceFeedbackWrong.
  ///
  /// In vi, this message translates to:
  /// **'Sai rồi — đáp án là \"{word}\"'**
  String practiceFeedbackWrong(String word);

  /// No description provided for @practiceMatchingProgress.
  ///
  /// In vi, this message translates to:
  /// **'Đã nối {matched}/{total} · {attempts} lần thử'**
  String practiceMatchingProgress(int matched, int total, int attempts);

  /// No description provided for @practiceMatchingNeedsMoreWords.
  ///
  /// In vi, this message translates to:
  /// **'Bộ thẻ cần ít nhất 2 từ để chơi nối từ.'**
  String get practiceMatchingNeedsMoreWords;

  /// No description provided for @practiceResultsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành!'**
  String get practiceResultsTitle;

  /// No description provided for @practiceAccuracySummary.
  ///
  /// In vi, this message translates to:
  /// **'{correct}/{total} đúng'**
  String practiceAccuracySummary(int correct, int total);

  /// No description provided for @practiceRestart.
  ///
  /// In vi, this message translates to:
  /// **'Luyện lại'**
  String get practiceRestart;

  /// No description provided for @practiceBackToDeck.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại bộ thẻ'**
  String get practiceBackToDeck;

  /// No description provided for @practiceChangeMode.
  ///
  /// In vi, this message translates to:
  /// **'Đổi chế độ'**
  String get practiceChangeMode;

  /// No description provided for @practiceBackToGames.
  ///
  /// In vi, this message translates to:
  /// **'Về Game'**
  String get practiceBackToGames;

  /// No description provided for @practiceNotEnoughWords.
  ///
  /// In vi, this message translates to:
  /// **'Chưa đủ từ để luyện tập lúc này.'**
  String get practiceNotEnoughWords;

  /// No description provided for @practiceListenPill.
  ///
  /// In vi, this message translates to:
  /// **'Nghe'**
  String get practiceListenPill;

  /// No description provided for @practiceHintPill.
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý'**
  String get practiceHintPill;

  /// No description provided for @practiceHintLetter.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu bằng \"{letter}\"'**
  String practiceHintLetter(String letter);

  /// No description provided for @practiceRetryAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get practiceRetryAnswer;

  /// No description provided for @practiceMicTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Nói để nhập'**
  String get practiceMicTooltip;

  /// No description provided for @practiceListeningNotYet.
  ///
  /// In vi, this message translates to:
  /// **'Chưa nhớ'**
  String get practiceListeningNotYet;

  /// No description provided for @practiceListeningKnown.
  ///
  /// In vi, this message translates to:
  /// **'Đã nhớ'**
  String get practiceListeningKnown;

  /// No description provided for @practiceListeningTapToFlip.
  ///
  /// In vi, this message translates to:
  /// **'👆 Nhấn để lật'**
  String get practiceListeningTapToFlip;

  /// No description provided for @practiceListeningMeaningLabel.
  ///
  /// In vi, this message translates to:
  /// **'Nghĩa'**
  String get practiceListeningMeaningLabel;

  /// No description provided for @practiceMatchingColumnDe.
  ///
  /// In vi, this message translates to:
  /// **'TIẾNG ĐỨC'**
  String get practiceMatchingColumnDe;

  /// No description provided for @practiceMatchingColumnVi.
  ///
  /// In vi, this message translates to:
  /// **'TIẾNG VIỆT'**
  String get practiceMatchingColumnVi;

  /// No description provided for @subtitleWordsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Từ đã gặp trong video'**
  String get subtitleWordsTitle;

  /// No description provided for @subtitleWordsSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Những từ bạn đã gặp khi xem video — thêm vào ôn tập chỉ với 1 chạm.'**
  String get subtitleWordsSubtitle;

  /// No description provided for @subtitleWordsEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có từ phụ đề nào để thêm.'**
  String get subtitleWordsEmpty;

  /// No description provided for @subtitleWordsEmptyHint.
  ///
  /// In vi, this message translates to:
  /// **'Hãy xem video tiếng Đức và chạm vào từ để lưu lại!'**
  String get subtitleWordsEmptyHint;

  /// No description provided for @subtitleWordsSeenCount.
  ///
  /// In vi, this message translates to:
  /// **'đã thấy {count}x'**
  String subtitleWordsSeenCount(int count);

  /// No description provided for @subtitleWordsLevelAll.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get subtitleWordsLevelAll;

  /// No description provided for @subtitleWordsLevelCount.
  ///
  /// In vi, this message translates to:
  /// **'{level} · {count}'**
  String subtitleWordsLevelCount(String level, int count);

  /// No description provided for @subtitleWordsSelectedCount.
  ///
  /// In vi, this message translates to:
  /// **'Đã chọn {count} từ'**
  String subtitleWordsSelectedCount(int count);

  /// No description provided for @subtitleWordsCountLabel.
  ///
  /// In vi, this message translates to:
  /// **'{count} từ'**
  String subtitleWordsCountLabel(int count);

  /// No description provided for @subtitleWordsSelectAll.
  ///
  /// In vi, this message translates to:
  /// **'Chọn tất cả'**
  String get subtitleWordsSelectAll;

  /// No description provided for @subtitleWordsClearSelection.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ chọn'**
  String get subtitleWordsClearSelection;

  /// No description provided for @subtitleWordsAddSelected.
  ///
  /// In vi, this message translates to:
  /// **'Thêm {count} từ vào ôn tập'**
  String subtitleWordsAddSelected(int count);

  /// No description provided for @subtitleWordsAdding.
  ///
  /// In vi, this message translates to:
  /// **'Đang thêm...'**
  String get subtitleWordsAdding;

  /// No description provided for @subtitleWordsAddedCount.
  ///
  /// In vi, this message translates to:
  /// **'Đã thêm {count} từ!'**
  String subtitleWordsAddedCount(int count);

  /// No description provided for @subtitleWordsAddFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể lưu các từ đã chọn. Vui lòng thử lại.'**
  String get subtitleWordsAddFailed;

  /// No description provided for @practiceModeComingSoon.
  ///
  /// In vi, this message translates to:
  /// **'Sắp ra mắt'**
  String get practiceModeComingSoon;

  /// No description provided for @practiceModeSentence.
  ///
  /// In vi, this message translates to:
  /// **'Viết câu'**
  String get practiceModeSentence;

  /// No description provided for @practiceModeSentenceDesc.
  ///
  /// In vi, this message translates to:
  /// **'Nghe + dịch câu hoàn chỉnh'**
  String get practiceModeSentenceDesc;

  /// No description provided for @practiceModeClozeDesc.
  ///
  /// In vi, this message translates to:
  /// **'Điền từ còn thiếu vào câu'**
  String get practiceModeClozeDesc;

  /// No description provided for @practiceModeListeningDesc.
  ///
  /// In vi, this message translates to:
  /// **'Nghe và lật thẻ đoán nghĩa'**
  String get practiceModeListeningDesc;

  /// No description provided for @practiceModeMatchingDesc.
  ///
  /// In vi, this message translates to:
  /// **'Nối từ tiếng Đức với nghĩa'**
  String get practiceModeMatchingDesc;

  /// No description provided for @practiceModeWritingDesc.
  ///
  /// In vi, this message translates to:
  /// **'Nghe + xem nghĩa → gõ từ tiếng Đức'**
  String get practiceModeWritingDesc;

  /// No description provided for @practiceModeRunner.
  ///
  /// In vi, this message translates to:
  /// **'Deutsch Runner'**
  String get practiceModeRunner;

  /// No description provided for @practiceModeRunnerDesc.
  ///
  /// In vi, this message translates to:
  /// **'Chơi game học từ vựng'**
  String get practiceModeRunnerDesc;

  /// No description provided for @practiceModeFade.
  ///
  /// In vi, this message translates to:
  /// **'Mờ dần'**
  String get practiceModeFade;

  /// No description provided for @practiceModeFadeDesc.
  ///
  /// In vi, this message translates to:
  /// **'Che chữ tăng dần, gõ lại cả câu'**
  String get practiceModeFadeDesc;

  /// No description provided for @practiceModeDictation.
  ///
  /// In vi, this message translates to:
  /// **'Nghe-chép'**
  String get practiceModeDictation;

  /// No description provided for @practiceModeDictationDesc.
  ///
  /// In vi, this message translates to:
  /// **'Nghe câu rồi gõ lại từng từ'**
  String get practiceModeDictationDesc;

  /// No description provided for @practiceModeChaining.
  ///
  /// In vi, this message translates to:
  /// **'Nối câu'**
  String get practiceModeChaining;

  /// No description provided for @practiceModeChainingDesc.
  ///
  /// In vi, this message translates to:
  /// **'Nhớ thứ tự: câu này → câu kế'**
  String get practiceModeChainingDesc;

  /// No description provided for @practiceModeGist.
  ///
  /// In vi, this message translates to:
  /// **'Viết theo ý'**
  String get practiceModeGist;

  /// No description provided for @practiceModeGistDesc.
  ///
  /// In vi, this message translates to:
  /// **'Xem nghĩa + gợi ý → viết lại câu'**
  String get practiceModeGistDesc;

  /// No description provided for @practiceModeSpeaking.
  ///
  /// In vi, this message translates to:
  /// **'Luyện nói'**
  String get practiceModeSpeaking;

  /// No description provided for @practiceModeSpeakingDesc.
  ///
  /// In vi, this message translates to:
  /// **'Đọc to câu, chấm phát âm'**
  String get practiceModeSpeakingDesc;

  /// No description provided for @practiceIncludeGraduated.
  ///
  /// In vi, this message translates to:
  /// **'Bao gồm từ đã thuộc'**
  String get practiceIncludeGraduated;

  /// No description provided for @practiceCardsReady.
  ///
  /// In vi, this message translates to:
  /// **'{count} thẻ sẵn sàng'**
  String practiceCardsReady(int count);

  /// No description provided for @practiceXpEarned.
  ///
  /// In vi, this message translates to:
  /// **'+{xp} XP'**
  String practiceXpEarned(int xp);

  /// No description provided for @notificationMarkAllRead.
  ///
  /// In vi, this message translates to:
  /// **'Đánh dấu tất cả đã đọc'**
  String get notificationMarkAllRead;

  /// No description provided for @notificationEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Không có thông báo nào'**
  String get notificationEmpty;

  /// No description provided for @notificationLoadError.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được thông báo. Vui lòng thử lại.'**
  String get notificationLoadError;

  /// No description provided for @notificationSomeone.
  ///
  /// In vi, this message translates to:
  /// **'Ai đó'**
  String get notificationSomeone;

  /// No description provided for @notificationFriendRequest.
  ///
  /// In vi, this message translates to:
  /// **'{name} đã gửi lời mời kết bạn'**
  String notificationFriendRequest(Object name);

  /// No description provided for @notificationFriendAccepted.
  ///
  /// In vi, this message translates to:
  /// **'{name} đã chấp nhận lời mời kết bạn của bạn'**
  String notificationFriendAccepted(Object name);

  /// No description provided for @notificationChallengeInvite.
  ///
  /// In vi, this message translates to:
  /// **'{name} thách đấu bạn'**
  String notificationChallengeInvite(Object name);

  /// No description provided for @notificationNewComment.
  ///
  /// In vi, this message translates to:
  /// **'Bình luận mới'**
  String get notificationNewComment;

  /// No description provided for @notificationGradingDone.
  ///
  /// In vi, this message translates to:
  /// **'AI đã chấm bài viết của bạn'**
  String get notificationGradingDone;

  /// No description provided for @notificationDailyReview.
  ///
  /// In vi, this message translates to:
  /// **'Có từ cần ôn hôm nay'**
  String get notificationDailyReview;

  /// No description provided for @notificationGeneric.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có thông báo mới'**
  String get notificationGeneric;

  /// No description provided for @notificationPreferencesTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tuỳ chọn thông báo'**
  String get notificationPreferencesTitle;

  /// No description provided for @notificationPreferencesEnabledTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc nhở học tập'**
  String get notificationPreferencesEnabledTitle;

  /// No description provided for @notificationPreferencesEnabledDescription.
  ///
  /// In vi, this message translates to:
  /// **'Nhận thông báo nhắc học hàng ngày'**
  String get notificationPreferencesEnabledDescription;

  /// No description provided for @notificationPreferencesTime.
  ///
  /// In vi, this message translates to:
  /// **'Giờ nhắc nhở'**
  String get notificationPreferencesTime;

  /// No description provided for @notificationPreferencesContentMode.
  ///
  /// In vi, this message translates to:
  /// **'Nội dung thông báo'**
  String get notificationPreferencesContentMode;

  /// No description provided for @notificationPreferencesContentWord.
  ///
  /// In vi, this message translates to:
  /// **'Từ vựng'**
  String get notificationPreferencesContentWord;

  /// No description provided for @notificationPreferencesContentReminder.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc nhở'**
  String get notificationPreferencesContentReminder;

  /// No description provided for @notificationPreferencesContentMix.
  ///
  /// In vi, this message translates to:
  /// **'Xen kẽ'**
  String get notificationPreferencesContentMix;

  /// No description provided for @notificationPreferencesSaveError.
  ///
  /// In vi, this message translates to:
  /// **'Không lưu được. Vui lòng thử lại.'**
  String get notificationPreferencesSaveError;

  /// No description provided for @learningPreferencesTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tuỳ chọn học tập'**
  String get learningPreferencesTitle;

  /// No description provided for @learningPreferencesLevel.
  ///
  /// In vi, this message translates to:
  /// **'Trình độ CEFR'**
  String get learningPreferencesLevel;

  /// No description provided for @learningPreferencesDailyMinutes.
  ///
  /// In vi, this message translates to:
  /// **'Số phút học mỗi ngày'**
  String get learningPreferencesDailyMinutes;

  /// No description provided for @learningPreferencesDailyXpGoal.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu XP hàng ngày'**
  String get learningPreferencesDailyXpGoal;

  /// No description provided for @learningPreferencesSaveError.
  ///
  /// In vi, this message translates to:
  /// **'Không lưu được. Vui lòng thử lại.'**
  String get learningPreferencesSaveError;

  /// No description provided for @learningPreferencesLoadError.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được tuỳ chọn học tập.'**
  String get learningPreferencesLoadError;

  /// No description provided for @checkForUpdates.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra cập nhật'**
  String get checkForUpdates;

  /// No description provided for @checkForUpdatesDescription.
  ///
  /// In vi, this message translates to:
  /// **'Xem bạn đang dùng phiên bản mới nhất chưa'**
  String get checkForUpdatesDescription;

  /// No description provided for @appUpToDate.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đang dùng phiên bản mới nhất'**
  String get appUpToDate;

  /// No description provided for @appUpdateAvailableTitle.
  ///
  /// In vi, this message translates to:
  /// **'Có bản cập nhật mới'**
  String get appUpdateAvailableTitle;

  /// No description provided for @appUpdateAvailableBody.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng cập nhật ứng dụng để tiếp tục sử dụng.'**
  String get appUpdateAvailableBody;

  /// No description provided for @appUpdateAction.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật ngay'**
  String get appUpdateAction;

  /// No description provided for @socialHubTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cộng đồng'**
  String get socialHubTitle;

  /// No description provided for @socialTabMoments.
  ///
  /// In vi, this message translates to:
  /// **'Khoảnh khắc'**
  String get socialTabMoments;

  /// No description provided for @socialTabFriends.
  ///
  /// In vi, this message translates to:
  /// **'Bạn bè'**
  String get socialTabFriends;

  /// No description provided for @socialTabRequests.
  ///
  /// In vi, this message translates to:
  /// **'Lời mời'**
  String get socialTabRequests;

  /// No description provided for @socialTabSearch.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm'**
  String get socialTabSearch;

  /// No description provided for @socialFriendsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bạn bè'**
  String get socialFriendsTitle;

  /// No description provided for @socialMessagesTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tin nhắn'**
  String get socialMessagesTitle;

  /// No description provided for @socialMomentsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Khoảnh khắc'**
  String get socialMomentsTitle;

  /// No description provided for @socialAnnouncementsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get socialAnnouncementsTitle;

  /// No description provided for @socialProfileTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ'**
  String get socialProfileTitle;

  /// No description provided for @socialLoadFriendsError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải danh sách bạn bè.'**
  String get socialLoadFriendsError;

  /// No description provided for @socialLoadRequestsError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải lời mời kết bạn.'**
  String get socialLoadRequestsError;

  /// No description provided for @socialLoadMessagesError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải tin nhắn.'**
  String get socialLoadMessagesError;

  /// No description provided for @socialLoadMomentsError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải khoảnh khắc.'**
  String get socialLoadMomentsError;

  /// No description provided for @socialLoadCommentsError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải bình luận.'**
  String get socialLoadCommentsError;

  /// No description provided for @socialLoadAnnouncementsError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải thông báo.'**
  String get socialLoadAnnouncementsError;

  /// No description provided for @socialLoadProfileError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải hồ sơ.'**
  String get socialLoadProfileError;

  /// No description provided for @socialSendMessageError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể gửi tin nhắn. Vui lòng thử lại.'**
  String get socialSendMessageError;

  /// No description provided for @socialSearchError.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm thất bại.'**
  String get socialSearchError;

  /// No description provided for @socialNoFriendsYet.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có bạn bè'**
  String get socialNoFriendsYet;

  /// No description provided for @socialNoPendingRequests.
  ///
  /// In vi, this message translates to:
  /// **'Không có lời mời nào'**
  String get socialNoPendingRequests;

  /// No description provided for @socialNoMessagesYet.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có tin nhắn'**
  String get socialNoMessagesYet;

  /// No description provided for @socialNoMomentsYet.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có khoảnh khắc nào'**
  String get socialNoMomentsYet;

  /// No description provided for @socialNoCommentsYet.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có bình luận nào'**
  String get socialNoCommentsYet;

  /// No description provided for @socialNoAnnouncements.
  ///
  /// In vi, this message translates to:
  /// **'Hiện chưa có thông báo'**
  String get socialNoAnnouncements;

  /// No description provided for @socialSearchPrompt.
  ///
  /// In vi, this message translates to:
  /// **'Tìm theo tên để kết bạn'**
  String get socialSearchPrompt;

  /// No description provided for @socialSearchNoResults.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy người dùng'**
  String get socialSearchNoResults;

  /// No description provided for @socialSearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm bạn bè…'**
  String get socialSearchHint;

  /// No description provided for @socialChatAction.
  ///
  /// In vi, this message translates to:
  /// **'Nhắn tin'**
  String get socialChatAction;

  /// No description provided for @socialViewProfile.
  ///
  /// In vi, this message translates to:
  /// **'Xem hồ sơ'**
  String get socialViewProfile;

  /// No description provided for @socialRemoveFriend.
  ///
  /// In vi, this message translates to:
  /// **'Xoá bạn bè'**
  String get socialRemoveFriend;

  /// No description provided for @socialRemoveFriendConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Xoá {name} khỏi danh sách bạn bè?'**
  String socialRemoveFriendConfirm(String name);

  /// No description provided for @socialBlockUser.
  ///
  /// In vi, this message translates to:
  /// **'Chặn'**
  String get socialBlockUser;

  /// No description provided for @socialBlockUserConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Chặn {name}? Người này sẽ không thể liên hệ với bạn nữa.'**
  String socialBlockUserConfirm(String name);

  /// No description provided for @socialBlockUserConfirmGeneric.
  ///
  /// In vi, this message translates to:
  /// **'Chặn người dùng này? Họ sẽ không thể liên hệ với bạn nữa.'**
  String get socialBlockUserConfirmGeneric;

  /// No description provided for @socialUserBlocked.
  ///
  /// In vi, this message translates to:
  /// **'Đã chặn người dùng'**
  String get socialUserBlocked;

  /// No description provided for @socialUserBlockedNotice.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã chặn người dùng này.'**
  String get socialUserBlockedNotice;

  /// No description provided for @socialAccept.
  ///
  /// In vi, this message translates to:
  /// **'Chấp nhận'**
  String get socialAccept;

  /// No description provided for @socialDecline.
  ///
  /// In vi, this message translates to:
  /// **'Từ chối'**
  String get socialDecline;

  /// No description provided for @socialAddFriend.
  ///
  /// In vi, this message translates to:
  /// **'Kết bạn'**
  String get socialAddFriend;

  /// No description provided for @socialRequestSent.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi lời mời'**
  String get socialRequestSent;

  /// No description provided for @socialReportUser.
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo'**
  String get socialReportUser;

  /// No description provided for @socialReportEmailSubject.
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo người dùng {userId}'**
  String socialReportEmailSubject(String userId);

  /// No description provided for @socialLevelLabel.
  ///
  /// In vi, this message translates to:
  /// **'Cấp {level}'**
  String socialLevelLabel(int level);

  /// No description provided for @socialLevelShort.
  ///
  /// In vi, this message translates to:
  /// **'Cấp độ'**
  String get socialLevelShort;

  /// No description provided for @socialStreakShort.
  ///
  /// In vi, this message translates to:
  /// **'Chuỗi ngày'**
  String get socialStreakShort;

  /// No description provided for @socialFriendsShort.
  ///
  /// In vi, this message translates to:
  /// **'Bạn bè'**
  String get socialFriendsShort;

  /// No description provided for @socialStartChatting.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu trò chuyện'**
  String get socialStartChatting;

  /// No description provided for @socialTypeMessageHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập tin nhắn…'**
  String get socialTypeMessageHint;

  /// No description provided for @socialCommentsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bình luận'**
  String get socialCommentsTitle;

  /// No description provided for @socialOnlineNow.
  ///
  /// In vi, this message translates to:
  /// **'Đang online'**
  String get socialOnlineNow;

  /// No description provided for @socialJoinedOn.
  ///
  /// In vi, this message translates to:
  /// **'Tham gia {date}'**
  String socialJoinedOn(String date);

  /// No description provided for @socialLongestStreakShort.
  ///
  /// In vi, this message translates to:
  /// **'Dài nhất'**
  String get socialLongestStreakShort;

  /// No description provided for @socialLearningJourneyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hành trình học tập'**
  String get socialLearningJourneyTitle;

  /// No description provided for @socialWeeklyRankLabel.
  ///
  /// In vi, this message translates to:
  /// **'BXH tuần'**
  String get socialWeeklyRankLabel;

  /// No description provided for @socialWordsLearnedLabel.
  ///
  /// In vi, this message translates to:
  /// **'Từ đã học'**
  String get socialWordsLearnedLabel;

  /// No description provided for @socialTotalReviewsLabel.
  ///
  /// In vi, this message translates to:
  /// **'Lần ôn tập'**
  String get socialTotalReviewsLabel;

  /// No description provided for @socialAchievementsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thành tích'**
  String get socialAchievementsTitle;

  /// No description provided for @socialActivityTimelineTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hoạt động gần đây'**
  String get socialActivityTimelineTitle;

  /// No description provided for @achievementFirstPracticeName.
  ///
  /// In vi, this message translates to:
  /// **'Bước đầu'**
  String get achievementFirstPracticeName;

  /// No description provided for @achievementFirstPracticeDesc.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành bài tập đầu tiên'**
  String get achievementFirstPracticeDesc;

  /// No description provided for @achievementStreak3Name.
  ///
  /// In vi, this message translates to:
  /// **'3 ngày liên tiếp'**
  String get achievementStreak3Name;

  /// No description provided for @achievementStreak3Desc.
  ///
  /// In vi, this message translates to:
  /// **'Duy trì streak 3 ngày'**
  String get achievementStreak3Desc;

  /// No description provided for @achievementStreak7Name.
  ///
  /// In vi, this message translates to:
  /// **'Tuần hoàn hảo'**
  String get achievementStreak7Name;

  /// No description provided for @achievementStreak7Desc.
  ///
  /// In vi, this message translates to:
  /// **'Duy trì streak 7 ngày'**
  String get achievementStreak7Desc;

  /// No description provided for @achievementStreak30Name.
  ///
  /// In vi, this message translates to:
  /// **'Tháng kỷ luật'**
  String get achievementStreak30Name;

  /// No description provided for @achievementStreak30Desc.
  ///
  /// In vi, this message translates to:
  /// **'Duy trì streak 30 ngày'**
  String get achievementStreak30Desc;

  /// No description provided for @achievementCards10Name.
  ///
  /// In vi, this message translates to:
  /// **'10 từ vựng'**
  String get achievementCards10Name;

  /// No description provided for @achievementCards10Desc.
  ///
  /// In vi, this message translates to:
  /// **'Tạo 10 flashcard'**
  String get achievementCards10Desc;

  /// No description provided for @achievementCards50Name.
  ///
  /// In vi, this message translates to:
  /// **'50 từ vựng'**
  String get achievementCards50Name;

  /// No description provided for @achievementCards50Desc.
  ///
  /// In vi, this message translates to:
  /// **'Tạo 50 flashcard'**
  String get achievementCards50Desc;

  /// No description provided for @achievementCards100Name.
  ///
  /// In vi, this message translates to:
  /// **'100 từ vựng'**
  String get achievementCards100Name;

  /// No description provided for @achievementCards100Desc.
  ///
  /// In vi, this message translates to:
  /// **'Tạo 100 flashcard'**
  String get achievementCards100Desc;

  /// No description provided for @achievementXp500Name.
  ///
  /// In vi, this message translates to:
  /// **'Cày 500 XP'**
  String get achievementXp500Name;

  /// No description provided for @achievementXp500Desc.
  ///
  /// In vi, this message translates to:
  /// **'Đạt 500 XP tổng'**
  String get achievementXp500Desc;

  /// No description provided for @achievementXp1000Name.
  ///
  /// In vi, this message translates to:
  /// **'Nghìn XP'**
  String get achievementXp1000Name;

  /// No description provided for @achievementXp1000Desc.
  ///
  /// In vi, this message translates to:
  /// **'Đạt 1000 XP tổng'**
  String get achievementXp1000Desc;

  /// No description provided for @achievementXp5000Name.
  ///
  /// In vi, this message translates to:
  /// **'Cao thủ'**
  String get achievementXp5000Name;

  /// No description provided for @achievementXp5000Desc.
  ///
  /// In vi, this message translates to:
  /// **'Đạt 5000 XP tổng'**
  String get achievementXp5000Desc;

  /// No description provided for @achievementLevel5Name.
  ///
  /// In vi, this message translates to:
  /// **'Level 5'**
  String get achievementLevel5Name;

  /// No description provided for @achievementLevel5Desc.
  ///
  /// In vi, this message translates to:
  /// **'Đạt Level 5'**
  String get achievementLevel5Desc;

  /// No description provided for @achievementLevel10Name.
  ///
  /// In vi, this message translates to:
  /// **'Level 10'**
  String get achievementLevel10Name;

  /// No description provided for @achievementLevel10Desc.
  ///
  /// In vi, this message translates to:
  /// **'Đạt Level 10'**
  String get achievementLevel10Desc;

  /// No description provided for @achievementReviews100Name.
  ///
  /// In vi, this message translates to:
  /// **'100 lần ôn'**
  String get achievementReviews100Name;

  /// No description provided for @achievementReviews100Desc.
  ///
  /// In vi, this message translates to:
  /// **'Ôn tập 100 lần'**
  String get achievementReviews100Desc;

  /// No description provided for @activityLevelUp.
  ///
  /// In vi, this message translates to:
  /// **'Đạt Level {level}'**
  String activityLevelUp(String level);

  /// No description provided for @activityStreakMilestone.
  ///
  /// In vi, this message translates to:
  /// **'{streak} ngày liên tiếp'**
  String activityStreakMilestone(String streak);

  /// No description provided for @activityAchievementUnlockedFallback.
  ///
  /// In vi, this message translates to:
  /// **'Thành tích mới'**
  String get activityAchievementUnlockedFallback;

  /// No description provided for @activityMissionFallback.
  ///
  /// In vi, this message translates to:
  /// **'Nhiệm vụ'**
  String get activityMissionFallback;

  /// No description provided for @activityExamFallback.
  ///
  /// In vi, this message translates to:
  /// **'Bài thi'**
  String get activityExamFallback;

  /// No description provided for @activityDailyReview.
  ///
  /// In vi, this message translates to:
  /// **'Ôn tập {correct}/{total} từ'**
  String activityDailyReview(String correct, String total);

  /// No description provided for @activityVocabLearned.
  ///
  /// In vi, this message translates to:
  /// **'Học {count} từ vựng mới'**
  String activityVocabLearned(String count);

  /// No description provided for @activityVideoFallback.
  ///
  /// In vi, this message translates to:
  /// **'Video'**
  String get activityVideoFallback;

  /// No description provided for @socialFriendsSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'{friends} bạn bè · {requests} lời mời'**
  String socialFriendsSubtitle(int friends, int requests);

  /// No description provided for @socialOnlineSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đang online — {count}'**
  String socialOnlineSectionTitle(int count);

  /// No description provided for @socialOfflineSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Offline — {count}'**
  String socialOfflineSectionTitle(int count);

  /// No description provided for @socialLevelStreakLabel.
  ///
  /// In vi, this message translates to:
  /// **'Lv.{level} · {streak} ngày streak'**
  String socialLevelStreakLabel(int level, int streak);

  /// No description provided for @socialSuggestionsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý kết bạn'**
  String get socialSuggestionsTitle;

  /// No description provided for @socialConversationsCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} cuộc trò chuyện'**
  String socialConversationsCount(int count);

  /// No description provided for @socialYouPrefix.
  ///
  /// In vi, this message translates to:
  /// **'Bạn'**
  String get socialYouPrefix;

  /// No description provided for @socialOffline.
  ///
  /// In vi, this message translates to:
  /// **'Offline'**
  String get socialOffline;

  /// No description provided for @pinnedShortcutsTitle.
  ///
  /// In vi, this message translates to:
  /// **'🔗 Lối tắt'**
  String get pinnedShortcutsTitle;

  /// No description provided for @pinnedShortcutConversation.
  ///
  /// In vi, this message translates to:
  /// **'Luyện nói AI'**
  String get pinnedShortcutConversation;

  /// No description provided for @pinnedShortcutWriteSentence.
  ///
  /// In vi, this message translates to:
  /// **'Viết câu (AI)'**
  String get pinnedShortcutWriteSentence;

  /// No description provided for @pinnedShortcutListening.
  ///
  /// In vi, this message translates to:
  /// **'Nghe'**
  String get pinnedShortcutListening;

  /// No description provided for @pinnedShortcutYoutube.
  ///
  /// In vi, this message translates to:
  /// **'YouTube'**
  String get pinnedShortcutYoutube;

  /// No description provided for @pinnedShortcutCourse.
  ///
  /// In vi, this message translates to:
  /// **'Khóa học'**
  String get pinnedShortcutCourse;

  /// No description provided for @exploreSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Khám phá'**
  String get exploreSectionTitle;

  /// No description provided for @examCornerOverdue.
  ///
  /// In vi, this message translates to:
  /// **'📅 Đã qua ngày thi'**
  String get examCornerOverdue;

  /// No description provided for @examCornerToday.
  ///
  /// In vi, this message translates to:
  /// **'🎯 Thi {level} hôm nay!'**
  String examCornerToday(String level);

  /// No description provided for @examCornerCountdown.
  ///
  /// In vi, this message translates to:
  /// **'🎯 {provider} {level} · còn {days} ngày'**
  String examCornerCountdown(String provider, String level, int days);

  /// No description provided for @examCornerReadiness.
  ///
  /// In vi, this message translates to:
  /// **'Độ sẵn sàng'**
  String get examCornerReadiness;

  /// No description provided for @examCornerChangeGoal.
  ///
  /// In vi, this message translates to:
  /// **'Đổi mục tiêu'**
  String get examCornerChangeGoal;

  /// No description provided for @examCornerContinue.
  ///
  /// In vi, this message translates to:
  /// **'Làm đề'**
  String get examCornerContinue;

  /// No description provided for @examCornerSetNewGoal.
  ///
  /// In vi, this message translates to:
  /// **'Đặt mục tiêu mới'**
  String get examCornerSetNewGoal;

  /// No description provided for @examGoalPromptTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đặt mục tiêu thi'**
  String get examGoalPromptTitle;

  /// No description provided for @examGoalPromptSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Đặt ngày thi để theo dõi đếm ngược và luyện đề đúng trình độ.'**
  String get examGoalPromptSubtitle;

  /// No description provided for @examGoalPromptCta.
  ///
  /// In vi, this message translates to:
  /// **'Đặt ngày thi'**
  String get examGoalPromptCta;

  /// No description provided for @examHeroTitle.
  ///
  /// In vi, this message translates to:
  /// **'🎯 Luyện thi {provider} {level}'**
  String examHeroTitle(String provider, String level);

  /// No description provided for @examHeroToday.
  ///
  /// In vi, this message translates to:
  /// **'Thi hôm nay!'**
  String get examHeroToday;

  /// No description provided for @examCornerDaysLeft.
  ///
  /// In vi, this message translates to:
  /// **'Còn {days} ngày'**
  String examCornerDaysLeft(int days);

  /// No description provided for @examHeroNoAttemptsYet.
  ///
  /// In vi, this message translates to:
  /// **'Làm đề đầu tiên để đo độ sẵn sàng'**
  String get examHeroNoAttemptsYet;

  /// No description provided for @examHeroBasedOnAttempts.
  ///
  /// In vi, this message translates to:
  /// **'Dựa trên {count} đề đã làm'**
  String examHeroBasedOnAttempts(int count);

  /// No description provided for @examHeroCta.
  ///
  /// In vi, this message translates to:
  /// **'📝 Làm đề {provider} {level}'**
  String examHeroCta(String provider, String level);

  /// No description provided for @examHeroReadyLabel.
  ///
  /// In vi, this message translates to:
  /// **'sẵn sàng'**
  String get examHeroReadyLabel;

  /// No description provided for @examGoalSetterTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đặt mục tiêu thi'**
  String get examGoalSetterTitle;

  /// No description provided for @examGoalSetterProviderLabel.
  ///
  /// In vi, this message translates to:
  /// **'Kỳ thi'**
  String get examGoalSetterProviderLabel;

  /// No description provided for @examGoalSetterLevelLabel.
  ///
  /// In vi, this message translates to:
  /// **'Trình độ thi'**
  String get examGoalSetterLevelLabel;

  /// No description provided for @examGoalSetterDateLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngày thi'**
  String get examGoalSetterDateLabel;

  /// No description provided for @examGoalSetterDateRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng chọn ngày thi'**
  String get examGoalSetterDateRequired;

  /// No description provided for @examGoalSetterDateInPast.
  ///
  /// In vi, this message translates to:
  /// **'Ngày thi không thể trước hôm nay'**
  String get examGoalSetterDateInPast;

  /// No description provided for @examGoalSetterSave.
  ///
  /// In vi, this message translates to:
  /// **'Lưu mục tiêu'**
  String get examGoalSetterSave;

  /// No description provided for @examGoalSetterSaving.
  ///
  /// In vi, this message translates to:
  /// **'Đang lưu...'**
  String get examGoalSetterSaving;

  /// No description provided for @examGoalSetterSaveFailed.
  ///
  /// In vi, this message translates to:
  /// **'Lưu thất bại, thử lại sau'**
  String get examGoalSetterSaveFailed;

  /// No description provided for @premiumBannerCta.
  ///
  /// In vi, this message translates to:
  /// **'Nâng cấp Premium — học không giới hạn'**
  String get premiumBannerCta;

  /// No description provided for @communityLinksTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cộng đồng Deutsch Tiger'**
  String get communityLinksTitle;

  /// No description provided for @communityZaloDescription.
  ///
  /// In vi, this message translates to:
  /// **'Nhóm học tiếng Đức'**
  String get communityZaloDescription;

  /// No description provided for @communityFacebookDescription.
  ///
  /// In vi, this message translates to:
  /// **'Deutsch Tiger VN'**
  String get communityFacebookDescription;

  /// No description provided for @examReadinessGoalHeaderLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đang luyện cho'**
  String get examReadinessGoalHeaderLabel;

  /// No description provided for @examReadinessGoalDaysLeft.
  ///
  /// In vi, this message translates to:
  /// **'ngày đến kỳ thi'**
  String get examReadinessGoalDaysLeft;

  /// No description provided for @examReadinessGoalTodayLabel.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay là ngày thi!'**
  String get examReadinessGoalTodayLabel;

  /// No description provided for @examReadinessGoalSetDate.
  ///
  /// In vi, this message translates to:
  /// **'Đặt ngày thi'**
  String get examReadinessGoalSetDate;

  /// No description provided for @examReadinessScoreTrendLabel.
  ///
  /// In vi, this message translates to:
  /// **'Xu hướng điểm'**
  String get examReadinessScoreTrendLabel;

  /// No description provided for @examReadinessScoreTrendDelta.
  ///
  /// In vi, this message translates to:
  /// **'{delta} điểm'**
  String examReadinessScoreTrendDelta(String delta);

  /// No description provided for @examReadinessScoreTrendRecentCount.
  ///
  /// In vi, this message translates to:
  /// **'{n} lần gần nhất'**
  String examReadinessScoreTrendRecentCount(int n);

  /// No description provided for @examReadinessScoreTrendLatestPrefix.
  ///
  /// In vi, this message translates to:
  /// **'Gần nhất: '**
  String get examReadinessScoreTrendLatestPrefix;

  /// No description provided for @examReadinessRecentAvgLabel.
  ///
  /// In vi, this message translates to:
  /// **'Điểm TB gần đây'**
  String get examReadinessRecentAvgLabel;

  /// No description provided for @examReadinessSkillPracticeCta.
  ///
  /// In vi, this message translates to:
  /// **'Luyện {skill}'**
  String examReadinessSkillPracticeCta(String skill);

  /// No description provided for @examReadinessAttemptCountSuffix.
  ///
  /// In vi, this message translates to:
  /// **'{n} lần'**
  String examReadinessAttemptCountSuffix(int n);

  /// No description provided for @examReadinessWeaknessPracticeCta.
  ///
  /// In vi, this message translates to:
  /// **'Luyện điểm yếu →'**
  String get examReadinessWeaknessPracticeCta;

  /// No description provided for @examReadinessWeaknessDrillCta.
  ///
  /// In vi, this message translates to:
  /// **'Luyện →'**
  String get examReadinessWeaknessDrillCta;

  /// No description provided for @examReadinessTodoTitle.
  ///
  /// In vi, this message translates to:
  /// **'Việc cần làm'**
  String get examReadinessTodoTitle;

  /// No description provided for @examReadinessTodoDueReviewsPrefix.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có '**
  String get examReadinessTodoDueReviewsPrefix;

  /// No description provided for @examReadinessTodoDueReviewsBold.
  ///
  /// In vi, this message translates to:
  /// **'{n} từ tới hạn ôn'**
  String examReadinessTodoDueReviewsBold(int n);

  /// No description provided for @examReadinessIntroWhy.
  ///
  /// In vi, this message translates to:
  /// **'Xem bạn đã sẵn sàng cho kỳ thi tới mức nào, theo từng kỹ năng.'**
  String get examReadinessIntroWhy;

  /// No description provided for @examReadinessIntroTodo.
  ///
  /// In vi, this message translates to:
  /// **'Nhìn kỹ năng yếu nhất và bấm luyện ngay.'**
  String get examReadinessIntroTodo;

  /// No description provided for @examReadinessIntroNext.
  ///
  /// In vi, this message translates to:
  /// **'Luyện xong quay lại xem điểm cải thiện.'**
  String get examReadinessIntroNext;

  /// No description provided for @scheduleBuddyCountFire.
  ///
  /// In vi, this message translates to:
  /// **'🔥 {n} bạn còn hạn lịch thi'**
  String scheduleBuddyCountFire(int n);

  /// No description provided for @scheduleBuddyCountSoon.
  ///
  /// In vi, this message translates to:
  /// **'· {n} người thi trong 30 ngày tới'**
  String scheduleBuddyCountSoon(int n);

  /// No description provided for @scheduleBuddyCountPast.
  ///
  /// In vi, this message translates to:
  /// **'· {n} đã thi'**
  String scheduleBuddyCountPast(int n);

  /// No description provided for @scheduleSearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm theo tên / loại thi...'**
  String get scheduleSearchHint;

  /// No description provided for @scheduleFilterAllExamTypes.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả kì thi'**
  String get scheduleFilterAllExamTypes;

  /// No description provided for @scheduleFilterAllLevels.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả trình độ'**
  String get scheduleFilterAllLevels;

  /// No description provided for @scheduleStatusUpcomingCount.
  ///
  /// In vi, this message translates to:
  /// **'Còn hạn ({n})'**
  String scheduleStatusUpcomingCount(int n);

  /// No description provided for @scheduleStatusPastCount.
  ///
  /// In vi, this message translates to:
  /// **'Đã thi ({n})'**
  String scheduleStatusPastCount(int n);

  /// No description provided for @scheduleResultCountUpcoming.
  ///
  /// In vi, this message translates to:
  /// **'{n} người · gần ngày thi nhất xếp trước'**
  String scheduleResultCountUpcoming(int n);

  /// No description provided for @scheduleResultCountPast.
  ///
  /// In vi, this message translates to:
  /// **'{n} người · thi gần đây xếp trước'**
  String scheduleResultCountPast(int n);

  /// No description provided for @scheduleEmptyUpcoming.
  ///
  /// In vi, this message translates to:
  /// **'Không có ai còn hạn lịch thi khớp bộ lọc này.'**
  String get scheduleEmptyUpcoming;

  /// No description provided for @scheduleEmptyPast.
  ///
  /// In vi, this message translates to:
  /// **'Không có ai đã thi khớp bộ lọc này.'**
  String get scheduleEmptyPast;

  /// No description provided for @scheduleMyPlansCount.
  ///
  /// In vi, this message translates to:
  /// **'{n} lịch thi · gần ngày thi nhất xếp trước'**
  String scheduleMyPlansCount(int n);

  /// No description provided for @scheduleMyPlansEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Bạn chưa đăng ký lịch thi nào'**
  String get scheduleMyPlansEmpty;

  /// No description provided for @schedulePrivacyNotePrefix.
  ///
  /// In vi, this message translates to:
  /// **'🔒 Liên hệ của bạn (SĐT, email, Facebook) '**
  String get schedulePrivacyNotePrefix;

  /// No description provided for @schedulePrivacyNoteBold.
  ///
  /// In vi, this message translates to:
  /// **'ẩn mặc định'**
  String get schedulePrivacyNoteBold;

  /// No description provided for @schedulePrivacyNoteSuffix.
  ///
  /// In vi, this message translates to:
  /// **' — chỉ thành viên đã đăng ký mới xem được.'**
  String get schedulePrivacyNoteSuffix;

  /// No description provided for @scheduleBuddyDaysAgo.
  ///
  /// In vi, this message translates to:
  /// **'Đã thi {n} ngày trước'**
  String scheduleBuddyDaysAgo(int n);

  /// No description provided for @scheduleBuddyToday.
  ///
  /// In vi, this message translates to:
  /// **'Thi hôm nay!'**
  String get scheduleBuddyToday;

  /// No description provided for @scheduleBuddyDaysLeft.
  ///
  /// In vi, this message translates to:
  /// **'Còn {n} ngày'**
  String scheduleBuddyDaysLeft(int n);

  /// No description provided for @dictationActivityMenuPrompt.
  ///
  /// In vi, this message translates to:
  /// **'Chọn hoạt động luyện nghe:'**
  String get dictationActivityMenuPrompt;

  /// No description provided for @dictationActivityClozeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Điền từ vào chỗ trống'**
  String get dictationActivityClozeTitle;

  /// No description provided for @dictationActivityClozeDesc.
  ///
  /// In vi, this message translates to:
  /// **'Nghe và gõ từ còn thiếu'**
  String get dictationActivityClozeDesc;

  /// No description provided for @dictationActivityFullTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nghe chép chính tả'**
  String get dictationActivityFullTitle;

  /// No description provided for @dictationActivityFullDesc.
  ///
  /// In vi, this message translates to:
  /// **'Nghe từng câu và gõ lại cả câu'**
  String get dictationActivityFullDesc;

  /// No description provided for @dictationActivityKaraokeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nghe & đọc theo'**
  String get dictationActivityKaraokeTitle;

  /// No description provided for @dictationActivityKaraokeDesc.
  ///
  /// In vi, this message translates to:
  /// **'Phụ đề chạy theo audio, chạm từ để tra nghĩa'**
  String get dictationActivityKaraokeDesc;

  /// No description provided for @dictationWordsCount.
  ///
  /// In vi, this message translates to:
  /// **'{n} từ'**
  String dictationWordsCount(int n);

  /// No description provided for @dictationWordSelectHint.
  ///
  /// In vi, this message translates to:
  /// **'Chạm vào những từ gạch chân trong bài để chọn từ muốn luyện, rồi bấm Bắt đầu.'**
  String get dictationWordSelectHint;

  /// No description provided for @dictationWordSelectCtaEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ít nhất 1 từ để bắt đầu'**
  String get dictationWordSelectCtaEmpty;

  /// No description provided for @dictationWordSelectCta.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu luyện nghe — {n} từ'**
  String dictationWordSelectCta(int n);

  /// No description provided for @dictationBackToSelection.
  ///
  /// In vi, this message translates to:
  /// **'← Chọn lại'**
  String get dictationBackToSelection;

  /// No description provided for @dictationWordCount.
  ///
  /// In vi, this message translates to:
  /// **'{answered} / {total} từ'**
  String dictationWordCount(int answered, int total);

  /// No description provided for @dictationTypeWordHint.
  ///
  /// In vi, this message translates to:
  /// **'Gõ từ...'**
  String get dictationTypeWordHint;

  /// No description provided for @dictationPlayingAudioHint.
  ///
  /// In vi, this message translates to:
  /// **'Đang phát audio...'**
  String get dictationPlayingAudioHint;

  /// No description provided for @dictationCheckCta.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra'**
  String get dictationCheckCta;

  /// No description provided for @dictationReplaySentenceTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Nghe lại câu'**
  String get dictationReplaySentenceTooltip;

  /// No description provided for @dictationClozeSkip.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ qua'**
  String get dictationClozeSkip;

  /// No description provided for @dictationClozeReveal.
  ///
  /// In vi, this message translates to:
  /// **'Xem đáp án'**
  String get dictationClozeReveal;

  /// No description provided for @dictationNoWordsToPractice.
  ///
  /// In vi, this message translates to:
  /// **'Không có từ nào để luyện.'**
  String get dictationNoWordsToPractice;

  /// No description provided for @dictationBackToWordSelection.
  ///
  /// In vi, this message translates to:
  /// **'← Quay lại chọn từ'**
  String get dictationBackToWordSelection;

  /// No description provided for @dictationClozeResultTitle.
  ///
  /// In vi, this message translates to:
  /// **'Kết quả luyện nghe'**
  String get dictationClozeResultTitle;

  /// No description provided for @dictationClozeBackLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chọn từ khác'**
  String get dictationClozeBackLabel;

  /// No description provided for @dictationClozeMistakesTitle.
  ///
  /// In vi, this message translates to:
  /// **'Từ cần ôn lại'**
  String get dictationClozeMistakesTitle;

  /// No description provided for @dictationEndRetry.
  ///
  /// In vi, this message translates to:
  /// **'Luyện lại'**
  String get dictationEndRetry;

  /// No description provided for @dictationEndCorrectCount.
  ///
  /// In vi, this message translates to:
  /// **'{correct} / {total} đúng'**
  String dictationEndCorrectCount(int correct, int total);

  /// No description provided for @dictationFullBackLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chọn bài'**
  String get dictationFullBackLabel;

  /// No description provided for @dictationFullResultTitle.
  ///
  /// In vi, this message translates to:
  /// **'Kết quả chép chính tả'**
  String get dictationFullResultTitle;

  /// No description provided for @dictationFullNextClip.
  ///
  /// In vi, this message translates to:
  /// **'Bài tiếp theo →'**
  String get dictationFullNextClip;

  /// No description provided for @dictationReplayThisSentence.
  ///
  /// In vi, this message translates to:
  /// **'Nghe lại câu này'**
  String get dictationReplayThisSentence;

  /// No description provided for @dictationTypeSentenceHint.
  ///
  /// In vi, this message translates to:
  /// **'Gõ câu bạn nghe được...'**
  String get dictationTypeSentenceHint;

  /// No description provided for @dictationSentenceProgress.
  ///
  /// In vi, this message translates to:
  /// **'{idx} / {count} câu'**
  String dictationSentenceProgress(int idx, int count);

  /// No description provided for @dictationCorrectCount.
  ///
  /// In vi, this message translates to:
  /// **'{n} đúng'**
  String dictationCorrectCount(int n);

  /// No description provided for @dictationNextSentence.
  ///
  /// In vi, this message translates to:
  /// **'Câu tiếp →'**
  String get dictationNextSentence;

  /// No description provided for @dictationShowResult.
  ///
  /// In vi, this message translates to:
  /// **'Xem kết quả'**
  String get dictationShowResult;

  /// No description provided for @dictationNoAudioData.
  ///
  /// In vi, this message translates to:
  /// **'Bài nghe này chưa có dữ liệu chấm chính tả.'**
  String get dictationNoAudioData;

  /// No description provided for @dictationBackPlain.
  ///
  /// In vi, this message translates to:
  /// **'← Quay lại'**
  String get dictationBackPlain;

  /// No description provided for @dictationKaraokeBackToMenu.
  ///
  /// In vi, this message translates to:
  /// **'← Chọn hoạt động'**
  String get dictationKaraokeBackToMenu;

  /// No description provided for @dictationKaraokeHint.
  ///
  /// In vi, this message translates to:
  /// **'Bấm ▶ để nghe — phụ đề tự chạy theo audio. Chạm vào câu để nghe lại từ đó.'**
  String get dictationKaraokeHint;

  /// No description provided for @dictationKaraokeUntimed.
  ///
  /// In vi, this message translates to:
  /// **'(không có phụ đề đồng bộ)'**
  String get dictationKaraokeUntimed;

  /// No description provided for @dictationKaraokePrev.
  ///
  /// In vi, this message translates to:
  /// **'◀ Bài trước'**
  String get dictationKaraokePrev;

  /// No description provided for @dictationKaraokeNext.
  ///
  /// In vi, this message translates to:
  /// **'Bài sau ▶'**
  String get dictationKaraokeNext;

  /// No description provided for @deThiHeroTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đề thi tiếng Đức'**
  String get deThiHeroTitle;

  /// No description provided for @deThiHeroSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Luyện đề đọc hiểu song ngữ Đức–Việt. Miễn phí, chấm điểm tại chỗ, không cần đăng nhập.'**
  String get deThiHeroSubtitle;

  /// No description provided for @deThiStartCta.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu làm →'**
  String get deThiStartCta;

  /// No description provided for @deThiLoginCta.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get deThiLoginCta;

  /// No description provided for @deThiPromoTitle.
  ///
  /// In vi, this message translates to:
  /// **'Học tiếng Đức toàn diện hơn'**
  String get deThiPromoTitle;

  /// No description provided for @deThiPromoSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Flashcard · Luyện nói AI · Đề thi B1/B2'**
  String get deThiPromoSubtitle;

  /// No description provided for @deThiPromoCta.
  ///
  /// In vi, this message translates to:
  /// **'Thử ngay →'**
  String get deThiPromoCta;

  /// No description provided for @deThiPassageLabel.
  ///
  /// In vi, this message translates to:
  /// **'ĐOẠN {index}'**
  String deThiPassageLabel(int index);

  /// No description provided for @deThiPassageOf.
  ///
  /// In vi, this message translates to:
  /// **'Đoạn {index}'**
  String deThiPassageOf(int index);

  /// No description provided for @deThiPassageAnsweredCount.
  ///
  /// In vi, this message translates to:
  /// **'{answered}/{total} câu'**
  String deThiPassageAnsweredCount(int answered, int total);

  /// No description provided for @deThiTranslatePassage.
  ///
  /// In vi, this message translates to:
  /// **'Dịch đoạn văn'**
  String get deThiTranslatePassage;

  /// No description provided for @deThiHideTranslation.
  ///
  /// In vi, this message translates to:
  /// **'Ẩn bản dịch'**
  String get deThiHideTranslation;

  /// No description provided for @deThiTranslateVi.
  ///
  /// In vi, this message translates to:
  /// **'Dịch tiếng Việt'**
  String get deThiTranslateVi;

  /// No description provided for @deThiHideExplanation.
  ///
  /// In vi, this message translates to:
  /// **'Ẩn giải thích'**
  String get deThiHideExplanation;

  /// No description provided for @deThiExplanation.
  ///
  /// In vi, this message translates to:
  /// **'Giải thích'**
  String get deThiExplanation;

  /// No description provided for @deThiVietnameseTranslationHeading.
  ///
  /// In vi, this message translates to:
  /// **'BẢN DỊCH TIẾNG VIỆT'**
  String get deThiVietnameseTranslationHeading;

  /// No description provided for @deThiPrevPassage.
  ///
  /// In vi, this message translates to:
  /// **'Đoạn trước'**
  String get deThiPrevPassage;

  /// No description provided for @deThiNextPassage.
  ///
  /// In vi, this message translates to:
  /// **'Đoạn tiếp'**
  String get deThiNextPassage;

  /// No description provided for @deThiCorrectCountLabel.
  ///
  /// In vi, this message translates to:
  /// **'{correct}/{total} câu đúng'**
  String deThiCorrectCountLabel(int correct, int total);

  /// No description provided for @deThiScoreLabel.
  ///
  /// In vi, this message translates to:
  /// **'{score} điểm'**
  String deThiScoreLabel(String score);

  /// No description provided for @communityTabBrowse.
  ///
  /// In vi, this message translates to:
  /// **'Duyệt đề'**
  String get communityTabBrowse;

  /// No description provided for @communityTabContribute.
  ///
  /// In vi, this message translates to:
  /// **'Đóng góp'**
  String get communityTabContribute;

  /// No description provided for @communityTabMine.
  ///
  /// In vi, this message translates to:
  /// **'Đề của tôi'**
  String get communityTabMine;

  /// No description provided for @communityContributeComingSoon.
  ///
  /// In vi, this message translates to:
  /// **'Tính năng đóng góp đề thi đang được phát triển.\nHãy quay lại sau nhé!'**
  String get communityContributeComingSoon;

  /// No description provided for @communityMineEmptyGated.
  ///
  /// In vi, this message translates to:
  /// **'Bạn chưa đóng góp đề nào — tính năng này sắp ra mắt.'**
  String get communityMineEmptyGated;

  /// No description provided for @communitySearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm đề...'**
  String get communitySearchHint;

  /// No description provided for @communityFilterAll.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get communityFilterAll;

  /// No description provided for @communityFilterGoetheWriting.
  ///
  /// In vi, this message translates to:
  /// **'Goethe Viết'**
  String get communityFilterGoetheWriting;

  /// No description provided for @communityFilterTelcSpeaking.
  ///
  /// In vi, this message translates to:
  /// **'Telc Nói'**
  String get communityFilterTelcSpeaking;

  /// No description provided for @communityTeilLabel.
  ///
  /// In vi, this message translates to:
  /// **'Teil {n}'**
  String communityTeilLabel(int n);

  /// No description provided for @communityBackLink.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại'**
  String get communityBackLink;

  /// No description provided for @communityBadgeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Cộng đồng'**
  String get communityBadgeLabel;

  /// No description provided for @communityHiddenBanner.
  ///
  /// In vi, this message translates to:
  /// **'⚠️ Đề này đã bị ẩn do nhận nhiều báo cáo.'**
  String get communityHiddenBanner;

  /// No description provided for @communityRealExamBadge.
  ///
  /// In vi, this message translates to:
  /// **'Đề thật'**
  String get communityRealExamBadge;

  /// No description provided for @communityTakeExamAction.
  ///
  /// In vi, this message translates to:
  /// **'Tôi vừa thi'**
  String get communityTakeExamAction;

  /// No description provided for @communityReportAction.
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo'**
  String get communityReportAction;

  /// No description provided for @communityGatedTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Tính năng đang được phát triển'**
  String get communityGatedTooltip;

  /// No description provided for @communityAnonymousContributor.
  ///
  /// In vi, this message translates to:
  /// **'Ẩn danh'**
  String get communityAnonymousContributor;

  /// No description provided for @communitySectionTask.
  ///
  /// In vi, this message translates to:
  /// **'📝 Đề bài'**
  String get communitySectionTask;

  /// No description provided for @communitySectionAnalysis.
  ///
  /// In vi, this message translates to:
  /// **'📋 Phân tích đề'**
  String get communitySectionAnalysis;

  /// No description provided for @communitySectionModelAnswer.
  ///
  /// In vi, this message translates to:
  /// **'✍️ Bài mẫu'**
  String get communitySectionModelAnswer;

  /// No description provided for @communitySectionUsefulPhrases.
  ///
  /// In vi, this message translates to:
  /// **'💡 Cụm từ hữu ích'**
  String get communitySectionUsefulPhrases;

  /// No description provided for @communitySectionGrammar.
  ///
  /// In vi, this message translates to:
  /// **'📖 Ngữ pháp trọng tâm'**
  String get communitySectionGrammar;

  /// No description provided for @communitySectionMistakes.
  ///
  /// In vi, this message translates to:
  /// **'⚠️ Lỗi thường gặp'**
  String get communitySectionMistakes;

  /// No description provided for @communitySectionSpeakingContent.
  ///
  /// In vi, this message translates to:
  /// **'🎙️ Nội dung'**
  String get communitySectionSpeakingContent;

  /// No description provided for @examHeaderDefaultTitle.
  ///
  /// In vi, this message translates to:
  /// **'Phần thi'**
  String get examHeaderDefaultTitle;

  /// No description provided for @examBackToResult.
  ///
  /// In vi, this message translates to:
  /// **'Kết quả'**
  String get examBackToResult;

  /// No description provided for @examPaceOnTrack.
  ///
  /// In vi, this message translates to:
  /// **'Đúng tiến độ'**
  String get examPaceOnTrack;

  /// No description provided for @examPaceSlow.
  ///
  /// In vi, this message translates to:
  /// **'Hơi chậm'**
  String get examPaceSlow;

  /// No description provided for @examPaceBehind.
  ///
  /// In vi, this message translates to:
  /// **'Cần nhanh hơn'**
  String get examPaceBehind;

  /// No description provided for @examReaderGuideTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Hướng dẫn đọc'**
  String get examReaderGuideTooltip;

  /// No description provided for @examReaderGuideTitle.
  ///
  /// In vi, this message translates to:
  /// **'Mẹo đọc bài'**
  String get examReaderGuideTitle;

  /// No description provided for @examReaderGuideBody.
  ///
  /// In vi, this message translates to:
  /// **'Bật tra từ để chạm vào 1 từ và xem nghĩa ngay. Bật tô màu để đánh dấu từ khó. Chỉnh cỡ chữ trong Cài đặt hiển thị.'**
  String get examReaderGuideBody;

  /// No description provided for @examReaderGuideEnableWordLookup.
  ///
  /// In vi, this message translates to:
  /// **'Bật tra từ'**
  String get examReaderGuideEnableWordLookup;

  /// No description provided for @examReaderSettingsTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt hiển thị'**
  String get examReaderSettingsTooltip;

  /// No description provided for @examReaderSettingsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt hiển thị'**
  String get examReaderSettingsTitle;

  /// No description provided for @examReaderSettingsFontSize.
  ///
  /// In vi, this message translates to:
  /// **'Cỡ chữ'**
  String get examReaderSettingsFontSize;

  /// No description provided for @examReaderSettingsHighlight.
  ///
  /// In vi, this message translates to:
  /// **'Tô màu từ'**
  String get examReaderSettingsHighlight;

  /// No description provided for @examReaderSettingsWordLookup.
  ///
  /// In vi, this message translates to:
  /// **'Tra từ khi chạm'**
  String get examReaderSettingsWordLookup;

  /// No description provided for @examReadingPaneTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đoạn văn'**
  String get examReadingPaneTitle;

  /// No description provided for @examTranslateParagraph.
  ///
  /// In vi, this message translates to:
  /// **'Dịch đoạn văn'**
  String get examTranslateParagraph;

  /// No description provided for @examHideTranslation.
  ///
  /// In vi, this message translates to:
  /// **'Ẩn bản dịch'**
  String get examHideTranslation;

  /// No description provided for @examNavPrevQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Câu trước'**
  String get examNavPrevQuestion;

  /// No description provided for @examNavNextQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Câu tiếp'**
  String get examNavNextQuestion;

  /// No description provided for @examNavOpenSheet.
  ///
  /// In vi, this message translates to:
  /// **'Bảng câu hỏi'**
  String get examNavOpenSheet;

  /// No description provided for @examNavSheetTitle.
  ///
  /// In vi, this message translates to:
  /// **'Danh sách câu hỏi'**
  String get examNavSheetTitle;

  /// No description provided for @examNavSheetPracticeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Luyện tập'**
  String get examNavSheetPracticeTitle;

  /// No description provided for @examNavLegendCurrent.
  ///
  /// In vi, this message translates to:
  /// **'Đang xem'**
  String get examNavLegendCurrent;

  /// No description provided for @examNavLegendAnswered.
  ///
  /// In vi, this message translates to:
  /// **'Đã làm'**
  String get examNavLegendAnswered;

  /// No description provided for @examNavLegendWrong.
  ///
  /// In vi, this message translates to:
  /// **'Sai'**
  String get examNavLegendWrong;

  /// No description provided for @examNavLegendUnanswered.
  ///
  /// In vi, this message translates to:
  /// **'Chưa làm'**
  String get examNavLegendUnanswered;

  /// No description provided for @examNavStatCorrect.
  ///
  /// In vi, this message translates to:
  /// **'{count} Đúng'**
  String examNavStatCorrect(int count);

  /// No description provided for @examNavStatWrong.
  ///
  /// In vi, this message translates to:
  /// **'{count} Sai'**
  String examNavStatWrong(int count);

  /// No description provided for @examNavStatUnanswered.
  ///
  /// In vi, this message translates to:
  /// **'{count} Chưa làm'**
  String examNavStatUnanswered(int count);

  /// No description provided for @examCommentsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bình luận'**
  String get examCommentsTitle;

  /// No description provided for @examCommentsEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có bình luận nào.'**
  String get examCommentsEmpty;

  /// No description provided for @examCommentsPlaceholder.
  ///
  /// In vi, this message translates to:
  /// **'Viết bình luận...'**
  String get examCommentsPlaceholder;

  /// No description provided for @examCommentsSend.
  ///
  /// In vi, this message translates to:
  /// **'Gửi'**
  String get examCommentsSend;

  /// No description provided for @examCommentsError.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được bình luận.'**
  String get examCommentsError;

  /// No description provided for @examCommentsSendError.
  ///
  /// In vi, this message translates to:
  /// **'Gửi bình luận thất bại. Vui lòng thử lại.'**
  String get examCommentsSendError;

  /// No description provided for @examResultHeaderFallback.
  ///
  /// In vi, this message translates to:
  /// **'Kết quả bài thi'**
  String get examResultHeaderFallback;

  /// No description provided for @examResultScoreLabel.
  ///
  /// In vi, this message translates to:
  /// **'Điểm số'**
  String get examResultScoreLabel;

  /// No description provided for @examResultMotivationPassedTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đạt rồi!'**
  String get examResultMotivationPassedTitle;

  /// No description provided for @examResultMotivationPassedBody.
  ///
  /// In vi, this message translates to:
  /// **'Làm tốt lắm! Bạn đã vượt qua ngưỡng đậu!'**
  String get examResultMotivationPassedBody;

  /// No description provided for @examResultMotivationFailTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cố lên!'**
  String get examResultMotivationFailTitle;

  /// No description provided for @examResultMotivationFailBody.
  ///
  /// In vi, this message translates to:
  /// **'Chưa đạt — ôn lại phần sai và thử lại nhé!'**
  String get examResultMotivationFailBody;

  /// No description provided for @examResultStatSkipped.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ qua'**
  String get examResultStatSkipped;

  /// No description provided for @examSmartReviewTitle.
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý ôn sau bài thi'**
  String get examSmartReviewTitle;

  /// No description provided for @examSmartReviewSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Tập trung vào câu sai và phần yếu.'**
  String get examSmartReviewSubtitle;

  /// No description provided for @examSmartReviewPointsNeeded.
  ///
  /// In vi, this message translates to:
  /// **'{count} điểm cần ôn'**
  String examSmartReviewPointsNeeded(int count);

  /// No description provided for @examSmartReviewJumpToWrong.
  ///
  /// In vi, this message translates to:
  /// **'Xem câu sai'**
  String get examSmartReviewJumpToWrong;

  /// No description provided for @examSmartReviewPracticeSections.
  ///
  /// In vi, this message translates to:
  /// **'Luyện từng phần'**
  String get examSmartReviewPracticeSections;

  /// No description provided for @examSmartReviewWrongReview.
  ///
  /// In vi, this message translates to:
  /// **'Ôn lỗi cá nhân'**
  String get examSmartReviewWrongReview;

  /// No description provided for @examAttemptHistoryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử làm bài'**
  String get examAttemptHistoryTitle;

  /// No description provided for @examAttemptHistoryEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có lịch sử'**
  String get examAttemptHistoryEmpty;

  /// No description provided for @examAttemptModePractice.
  ///
  /// In vi, this message translates to:
  /// **'Luyện'**
  String get examAttemptModePractice;

  /// No description provided for @writingMyEssaysLink.
  ///
  /// In vi, this message translates to:
  /// **'Bài của tôi →'**
  String get writingMyEssaysLink;

  /// No description provided for @writingHistoryTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử bài viết'**
  String get writingHistoryTooltip;

  /// No description provided for @writingYourEssay.
  ///
  /// In vi, this message translates to:
  /// **'Bài viết của bạn'**
  String get writingYourEssay;

  /// No description provided for @writingDraftSaved.
  ///
  /// In vi, this message translates to:
  /// **'💾 Đã lưu nháp'**
  String get writingDraftSaved;

  /// No description provided for @writingSubmittedBadge.
  ///
  /// In vi, this message translates to:
  /// **'Đã nộp'**
  String get writingSubmittedBadge;

  /// No description provided for @writingWordCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} từ'**
  String writingWordCount(int count);

  /// No description provided for @writingRestorePromptSaved.
  ///
  /// In vi, this message translates to:
  /// **'Có bản nháp lưu lúc {time} ({count} từ). Khôi phục?'**
  String writingRestorePromptSaved(String time, int count);

  /// No description provided for @writingRestore.
  ///
  /// In vi, this message translates to:
  /// **'Khôi phục'**
  String get writingRestore;

  /// No description provided for @writingDiscard.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ'**
  String get writingDiscard;

  /// No description provided for @writingEditorPlaceholder.
  ///
  /// In vi, this message translates to:
  /// **'Schreiben Sie hier Ihre Antwort... (Viết bài của bạn ở đây)'**
  String get writingEditorPlaceholder;

  /// No description provided for @writingSubmitCta.
  ///
  /// In vi, this message translates to:
  /// **'Nộp bài viết'**
  String get writingSubmitCta;

  /// No description provided for @writingSubmitting.
  ///
  /// In vi, this message translates to:
  /// **'Đang nộp...'**
  String get writingSubmitting;

  /// No description provided for @writingRegrade.
  ///
  /// In vi, this message translates to:
  /// **'Chấm lại với AI'**
  String get writingRegrade;

  /// No description provided for @writingGrading.
  ///
  /// In vi, this message translates to:
  /// **'Đang chấm...'**
  String get writingGrading;

  /// No description provided for @writingMinWordsHint.
  ///
  /// In vi, this message translates to:
  /// **'Tối thiểu 10 từ'**
  String get writingMinWordsHint;

  /// No description provided for @writingEditEssay.
  ///
  /// In vi, this message translates to:
  /// **'Sửa bài viết'**
  String get writingEditEssay;

  /// No description provided for @writingGradeWithAi.
  ///
  /// In vi, this message translates to:
  /// **'Sửa với AI'**
  String get writingGradeWithAi;

  /// No description provided for @writingRetry.
  ///
  /// In vi, this message translates to:
  /// **'Làm lại'**
  String get writingRetry;

  /// No description provided for @writingRetryIn.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại sau {seconds}s'**
  String writingRetryIn(int seconds);

  /// No description provided for @writingClose.
  ///
  /// In vi, this message translates to:
  /// **'Đóng'**
  String get writingClose;

  /// No description provided for @writingFeedbackUpdateHint.
  ///
  /// In vi, this message translates to:
  /// **'Phản hồi AI — chấm lại để cập nhật kết quả mới'**
  String get writingFeedbackUpdateHint;

  /// No description provided for @writingRewriteTitle.
  ///
  /// In vi, this message translates to:
  /// **'Viết lại sau góp ý'**
  String get writingRewriteTitle;

  /// No description provided for @writingRewriteDesc.
  ///
  /// In vi, this message translates to:
  /// **'Tạo một bản sửa mẫu để so sánh, rồi đưa vào khung soạn thảo nếu muốn chỉnh tiếp.'**
  String get writingRewriteDesc;

  /// No description provided for @writingCreateRewrite.
  ///
  /// In vi, this message translates to:
  /// **'Tạo bản sửa mẫu'**
  String get writingCreateRewrite;

  /// No description provided for @writingRecreateRewrite.
  ///
  /// In vi, this message translates to:
  /// **'Tạo lại bản sửa'**
  String get writingRecreateRewrite;

  /// No description provided for @writingCreatingRewrite.
  ///
  /// In vi, this message translates to:
  /// **'Đang tạo...'**
  String get writingCreatingRewrite;

  /// No description provided for @writingUseRewrite.
  ///
  /// In vi, this message translates to:
  /// **'Đưa vào khung để chỉnh tiếp'**
  String get writingUseRewrite;

  /// No description provided for @writingBeforeFix.
  ///
  /// In vi, this message translates to:
  /// **'Trước khi sửa'**
  String get writingBeforeFix;

  /// No description provided for @writingAfterFix.
  ///
  /// In vi, this message translates to:
  /// **'Sau khi sửa'**
  String get writingAfterFix;

  /// No description provided for @writingGradeCategoryTask.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành đề bài'**
  String get writingGradeCategoryTask;

  /// No description provided for @writingGradeCategoryGrammar.
  ///
  /// In vi, this message translates to:
  /// **'Ngữ pháp'**
  String get writingGradeCategoryGrammar;

  /// No description provided for @writingGradeCategoryVocab.
  ///
  /// In vi, this message translates to:
  /// **'Từ vựng'**
  String get writingGradeCategoryVocab;

  /// No description provided for @writingGradeCategoryCoherence.
  ///
  /// In vi, this message translates to:
  /// **'Liên kết & mạch lạc'**
  String get writingGradeCategoryCoherence;

  /// No description provided for @writingCommonErrorsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi hay gặp trong bài này'**
  String get writingCommonErrorsTitle;

  /// No description provided for @writingDetailedAssessment.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết đánh giá'**
  String get writingDetailedAssessment;

  /// No description provided for @writingSuggestionsTitle.
  ///
  /// In vi, this message translates to:
  /// **'💡 Gợi ý viết tự nhiên hơn ({count})'**
  String writingSuggestionsTitle(int count);

  /// No description provided for @writingCorrectionsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sửa lỗi ({count})'**
  String writingCorrectionsTitle(int count);

  /// No description provided for @writingFocusLink.
  ///
  /// In vi, this message translates to:
  /// **'🔁 Vá lỗi ngữ pháp ở Tập trung ({count} lỗi)'**
  String writingFocusLink(int count);

  /// No description provided for @writingGoetheBreakdownTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đánh giá Goethe — {teilLabel}'**
  String writingGoetheBreakdownTitle(String teilLabel);

  /// No description provided for @writingGoetheInhalt.
  ///
  /// In vi, this message translates to:
  /// **'Inhalt (Nội dung)'**
  String get writingGoetheInhalt;

  /// No description provided for @writingGoetheKommunikative.
  ///
  /// In vi, this message translates to:
  /// **'Kommunikative (Giao tiếp)'**
  String get writingGoetheKommunikative;

  /// No description provided for @writingGoetheFormale.
  ///
  /// In vi, this message translates to:
  /// **'Formale (Hình thức)'**
  String get writingGoetheFormale;

  /// No description provided for @writingHistoryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử bài viết'**
  String get writingHistoryTitle;

  /// No description provided for @writingHistoryEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có bài viết nào'**
  String get writingHistoryEmpty;

  /// No description provided for @writingScorePoints.
  ///
  /// In vi, this message translates to:
  /// **'{score}/100'**
  String writingScorePoints(int score);

  /// No description provided for @goetheB1HubTitle.
  ///
  /// In vi, this message translates to:
  /// **'Goethe-Zertifikat B1'**
  String get goetheB1HubTitle;

  /// No description provided for @goetheB1HubSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'3 bộ đề luyện thi'**
  String get goetheB1HubSubtitle;

  /// No description provided for @goetheB1HubOfficialTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bộ đề thi chính thức'**
  String get goetheB1HubOfficialTitle;

  /// No description provided for @goetheB1HubOfficialDesc.
  ///
  /// In vi, this message translates to:
  /// **'30+ đề luyện thi đầy đủ · Lesen · Hören · Schreiben'**
  String get goetheB1HubOfficialDesc;

  /// No description provided for @goetheB1HubWritingTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bộ đề viết thực tế'**
  String get goetheB1HubWritingTitle;

  /// No description provided for @goetheB1HubWritingDesc.
  ///
  /// In vi, this message translates to:
  /// **'30 đề Schreiben theo chủ đề · Teil 1 · Teil 2 · Teil 3'**
  String get goetheB1HubWritingDesc;

  /// No description provided for @goetheB1HubSpeakingTitle.
  ///
  /// In vi, this message translates to:
  /// **'Luyện nói (Sprechen)'**
  String get goetheB1HubSpeakingTitle;

  /// No description provided for @goetheB1HubSpeakingDesc.
  ///
  /// In vi, this message translates to:
  /// **'Đề nói theo chủ đề · Teil 1 · Teil 2 · Teil 3'**
  String get goetheB1HubSpeakingDesc;

  /// No description provided for @goetheB1WritingEyebrow.
  ///
  /// In vi, this message translates to:
  /// **'Goethe B1 · 3 phần · 100 Punkte'**
  String get goetheB1WritingEyebrow;

  /// No description provided for @goetheB1WritingHeadingPrefix.
  ///
  /// In vi, this message translates to:
  /// **'Viết — '**
  String get goetheB1WritingHeadingPrefix;

  /// No description provided for @goetheB1WritingHeadingSchreiben.
  ///
  /// In vi, this message translates to:
  /// **'Schreiben'**
  String get goetheB1WritingHeadingSchreiben;

  /// No description provided for @goetheB1WritingBadgeReal.
  ///
  /// In vi, this message translates to:
  /// **'Đề thi thật'**
  String get goetheB1WritingBadgeReal;

  /// No description provided for @goetheB1WritingBadgeYears.
  ///
  /// In vi, this message translates to:
  /// **'2023–2026'**
  String get goetheB1WritingBadgeYears;

  /// No description provided for @goetheB1WritingBadgeQuality.
  ///
  /// In vi, this message translates to:
  /// **'Bài mẫu chất lượng'**
  String get goetheB1WritingBadgeQuality;

  /// No description provided for @goetheB1WritingHeroPitch.
  ///
  /// In vi, this message translates to:
  /// **'Luyện đúng format Goethe B1 với bộ đề sát thi thật để vào phòng thi tự tin hơn.'**
  String get goetheB1WritingHeroPitch;

  /// No description provided for @goetheB1WritingHeroDesc.
  ///
  /// In vi, this message translates to:
  /// **'Schreiben gồm 3 Teil bám sát cấu trúc bài thi Goethe B1, tuyển chọn từ đề thật giai đoạn 2023–2026 và chủ đề mới do cộng đồng bổ sung liên tục. Mỗi phần đều giúp bạn xem đề mẫu, ôn cấu trúc câu, học cách triển khai ý và luyện viết từng bước với bài mẫu đáng tin cậy.'**
  String get goetheB1WritingHeroDesc;

  /// No description provided for @goetheB1WritingStatSourceLabel.
  ///
  /// In vi, this message translates to:
  /// **'Nguồn luyện'**
  String get goetheB1WritingStatSourceLabel;

  /// No description provided for @goetheB1WritingStatSourceValue.
  ///
  /// In vi, this message translates to:
  /// **'Đề thi Goethe thật'**
  String get goetheB1WritingStatSourceValue;

  /// No description provided for @goetheB1WritingStatTopicsLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chủ đề hiện có'**
  String get goetheB1WritingStatTopicsLabel;

  /// No description provided for @goetheB1WritingStatTopicsValue.
  ///
  /// In vi, this message translates to:
  /// **'{count}+ chủ đề'**
  String goetheB1WritingStatTopicsValue(int count);

  /// No description provided for @goetheB1WritingStatValueLabel.
  ///
  /// In vi, this message translates to:
  /// **'Giá trị luyện tập'**
  String get goetheB1WritingStatValueLabel;

  /// No description provided for @goetheB1WritingStatValueValue.
  ///
  /// In vi, this message translates to:
  /// **'Mẫu viết + từng bước'**
  String get goetheB1WritingStatValueValue;

  /// No description provided for @goetheB1WritingLoadingTopics.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải...'**
  String get goetheB1WritingLoadingTopics;

  /// No description provided for @goetheB1WritingAllExamsLink.
  ///
  /// In vi, this message translates to:
  /// **'← Tất cả kỳ thi luyện viết'**
  String get goetheB1WritingAllExamsLink;

  /// No description provided for @goetheB1WritingMyEssaysLink.
  ///
  /// In vi, this message translates to:
  /// **'Bài của tôi →'**
  String get goetheB1WritingMyEssaysLink;

  /// No description provided for @goetheB1WritingTeilLabel.
  ///
  /// In vi, this message translates to:
  /// **'Teil {n}'**
  String goetheB1WritingTeilLabel(int n);

  /// No description provided for @goetheB1WritingPoints.
  ///
  /// In vi, this message translates to:
  /// **'{points} Punkte'**
  String goetheB1WritingPoints(int points);

  /// No description provided for @goetheB1WritingTeil1Subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Viết thư / email cá nhân cho bạn bè'**
  String get goetheB1WritingTeil1Subtitle;

  /// No description provided for @goetheB1WritingTeil2Subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Bày tỏ ý kiến trên diễn đàn'**
  String get goetheB1WritingTeil2Subtitle;

  /// No description provided for @goetheB1WritingTeil3Subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Email trang trọng: xin lỗi, đặt hẹn, đăng ký'**
  String get goetheB1WritingTeil3Subtitle;

  /// No description provided for @conversationHubTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hội thoại (AI)'**
  String get conversationHubTitle;

  /// No description provided for @conversationHubSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Alltagsdeutsch · Khám phá & luyện nói'**
  String get conversationHubSubtitle;

  /// No description provided for @conversationHubLoadError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải danh sách kịch bản.'**
  String get conversationHubLoadError;

  /// No description provided for @conversationTabScenarios.
  ///
  /// In vi, this message translates to:
  /// **'Kịch bản'**
  String get conversationTabScenarios;

  /// No description provided for @conversationTabHistory.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử luyện tập'**
  String get conversationTabHistory;

  /// No description provided for @conversationHeroBadge.
  ///
  /// In vi, this message translates to:
  /// **'AI tạo hội thoại tức thì'**
  String get conversationHeroBadge;

  /// No description provided for @conversationHeroTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bạn muốn luyện nói về điều gì hôm nay?'**
  String get conversationHeroTitle;

  /// No description provided for @conversationHeroSearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Gõ chủ đề bất kỳ hoặc tìm chủ đề có sẵn…'**
  String get conversationHeroSearchHint;

  /// No description provided for @conversationHeroCreateNow.
  ///
  /// In vi, this message translates to:
  /// **'Tạo ngay'**
  String get conversationHeroCreateNow;

  /// No description provided for @conversationHeroUpgrade.
  ///
  /// In vi, this message translates to:
  /// **'Nâng Plus ✨'**
  String get conversationHeroUpgrade;

  /// No description provided for @conversationHeroTryNow.
  ///
  /// In vi, this message translates to:
  /// **'Thử ngay:'**
  String get conversationHeroTryNow;

  /// No description provided for @conversationQuotaFreeRemaining.
  ///
  /// In vi, this message translates to:
  /// **'Còn {remaining}/{max} bài miễn phí hôm nay'**
  String conversationQuotaFreeRemaining(int remaining, int max);

  /// No description provided for @conversationQuotaWalled.
  ///
  /// In vi, this message translates to:
  /// **'Đã dùng hết {max}/{max} bài hội thoại hôm nay'**
  String conversationQuotaWalled(int max);

  /// No description provided for @conversationQuotaUnlimited.
  ///
  /// In vi, this message translates to:
  /// **'Không giới hạn'**
  String get conversationQuotaUnlimited;

  /// No description provided for @conversationFilterLibraryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hoặc chọn từ thư viện'**
  String get conversationFilterLibraryTitle;

  /// No description provided for @conversationFilterResultCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} chủ đề'**
  String conversationFilterResultCount(int count);

  /// No description provided for @conversationFilterClear.
  ///
  /// In vi, this message translates to:
  /// **'Xoá lọc'**
  String get conversationFilterClear;

  /// No description provided for @conversationFilterCategory.
  ///
  /// In vi, this message translates to:
  /// **'Thể loại'**
  String get conversationFilterCategory;

  /// No description provided for @conversationFilterLevel.
  ///
  /// In vi, this message translates to:
  /// **'Cấp độ'**
  String get conversationFilterLevel;

  /// No description provided for @conversationFilterAll.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get conversationFilterAll;

  /// No description provided for @conversationCreateCustomTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tạo chủ đề riêng: „{topic}”'**
  String conversationCreateCustomTitle(String topic);

  /// No description provided for @conversationCreateCustomHint.
  ///
  /// In vi, this message translates to:
  /// **'Không có sẵn — để AI soạn một hội thoại mới cho bạn'**
  String get conversationCreateCustomHint;

  /// No description provided for @conversationEmptyNoResults.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy chủ đề'**
  String get conversationEmptyNoResults;

  /// No description provided for @conversationEmptyNoResultsHint.
  ///
  /// In vi, this message translates to:
  /// **'Thử gõ chủ đề riêng ở ô phía trên nhé!'**
  String get conversationEmptyNoResultsHint;

  /// No description provided for @conversationHistoryLoadError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải lịch sử luyện tập.'**
  String get conversationHistoryLoadError;

  /// No description provided for @conversationHistoryEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có bài luyện tập nào được lưu.'**
  String get conversationHistoryEmpty;

  /// No description provided for @conversationHistoryEmptyHint.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành một cuộc hội thoại để lưu lại đây.'**
  String get conversationHistoryEmptyHint;

  /// No description provided for @conversationHistoryMeta.
  ///
  /// In vi, this message translates to:
  /// **'{level} · {turns} lượt · {date}'**
  String conversationHistoryMeta(String level, int turns, String date);

  /// No description provided for @conversationHistoryDelete.
  ///
  /// In vi, this message translates to:
  /// **'Xóa'**
  String get conversationHistoryDelete;

  /// No description provided for @conversationHistoryCancel.
  ///
  /// In vi, this message translates to:
  /// **'Hủy'**
  String get conversationHistoryCancel;

  /// No description provided for @conversationHistoryDetailLoadError.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được bài hội thoại đã lưu.'**
  String get conversationHistoryDetailLoadError;

  /// No description provided for @conversationHistoryBackToList.
  ///
  /// In vi, this message translates to:
  /// **'Về danh sách'**
  String get conversationHistoryBackToList;

  /// No description provided for @conversationLoadError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải kịch bản. Vui lòng thử lại.'**
  String get conversationLoadError;

  /// No description provided for @conversationBack.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại'**
  String get conversationBack;

  /// No description provided for @conversationContextLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tình huống'**
  String get conversationContextLabel;

  /// No description provided for @conversationYourRoleLabel.
  ///
  /// In vi, this message translates to:
  /// **'Vai bạn:'**
  String get conversationYourRoleLabel;

  /// No description provided for @conversationListen.
  ///
  /// In vi, this message translates to:
  /// **'Nghe'**
  String get conversationListen;

  /// No description provided for @conversationExaminerButton.
  ///
  /// In vi, this message translates to:
  /// **'Giám khảo'**
  String get conversationExaminerButton;

  /// No description provided for @conversationExaminerTitle.
  ///
  /// In vi, this message translates to:
  /// **'⚖️ Giám khảo AI'**
  String get conversationExaminerTitle;

  /// No description provided for @conversationExaminerCoverageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nội dung cần đề cập'**
  String get conversationExaminerCoverageTitle;

  /// No description provided for @conversationExaminerVerdictPending.
  ///
  /// In vi, this message translates to:
  /// **'Đánh giá tổng thể đang được phát triển.'**
  String get conversationExaminerVerdictPending;

  /// No description provided for @conversationExaminerNoVerdict.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có đánh giá cho bài này.'**
  String get conversationExaminerNoVerdict;

  /// No description provided for @conversationExit.
  ///
  /// In vi, this message translates to:
  /// **'Thoát'**
  String get conversationExit;

  /// No description provided for @conversationExitConfirmTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thoát hội thoại?'**
  String get conversationExitConfirmTitle;

  /// No description provided for @conversationExitConfirmBody.
  ///
  /// In vi, this message translates to:
  /// **'Tiến trình hiện tại sẽ không được lưu.'**
  String get conversationExitConfirmBody;

  /// No description provided for @conversationExitConfirmCta.
  ///
  /// In vi, this message translates to:
  /// **'Thoát'**
  String get conversationExitConfirmCta;

  /// No description provided for @conversationExitCancelCta.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục'**
  String get conversationExitCancelCta;

  /// No description provided for @conversationComposerHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập hoặc nói tiếng Đức...'**
  String get conversationComposerHint;

  /// No description provided for @conversationComposerModeText.
  ///
  /// In vi, this message translates to:
  /// **'Viết'**
  String get conversationComposerModeText;

  /// No description provided for @conversationComposerModeVoice.
  ///
  /// In vi, this message translates to:
  /// **'Mic'**
  String get conversationComposerModeVoice;

  /// No description provided for @conversationSuggestionsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý'**
  String get conversationSuggestionsTitle;

  /// No description provided for @conversationSuggestionsPending.
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý câu trả lời đang được phát triển.'**
  String get conversationSuggestionsPending;

  /// No description provided for @conversationVoiceTapToSpeak.
  ///
  /// In vi, this message translates to:
  /// **'Nhấn để nói'**
  String get conversationVoiceTapToSpeak;

  /// No description provided for @conversationVoiceComingSoon.
  ///
  /// In vi, this message translates to:
  /// **'Tính năng nói sẽ sớm ra mắt.'**
  String get conversationVoiceComingSoon;

  /// No description provided for @conversationVoiceBackToText.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại gõ'**
  String get conversationVoiceBackToText;

  /// No description provided for @conversationDoneTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành hội thoại!'**
  String get conversationDoneTitle;

  /// No description provided for @conversationDoneSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'{title} · {turns} lượt hội thoại'**
  String conversationDoneSubtitle(String title, int turns);

  /// No description provided for @conversationDoneRestart.
  ///
  /// In vi, this message translates to:
  /// **'Thực hành lại'**
  String get conversationDoneRestart;

  /// No description provided for @conversationDoneChooseAnother.
  ///
  /// In vi, this message translates to:
  /// **'Chọn kịch bản khác'**
  String get conversationDoneChooseAnother;

  /// No description provided for @interviewImportTitle.
  ///
  /// In vi, this message translates to:
  /// **'Luyện phỏng vấn từ tài liệu'**
  String get interviewImportTitle;

  /// No description provided for @interviewImportDesc.
  ///
  /// In vi, this message translates to:
  /// **'Dán tài liệu chuẩn bị → AI tạo buổi phỏng vấn; câu trả lời bạn soạn thành gợi ý.'**
  String get interviewImportDesc;

  /// No description provided for @interviewImportBackToEdit.
  ///
  /// In vi, this message translates to:
  /// **'Sửa tài liệu'**
  String get interviewImportBackToEdit;

  /// No description provided for @interviewImportDocLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tài liệu phỏng vấn'**
  String get interviewImportDocLabel;

  /// No description provided for @interviewImportDocHint.
  ///
  /// In vi, this message translates to:
  /// **'Dán câu hỏi + câu trả lời bạn đã chuẩn bị...'**
  String get interviewImportDocHint;

  /// No description provided for @interviewImportLevelLabel.
  ///
  /// In vi, this message translates to:
  /// **'Trình độ (CEFR)'**
  String get interviewImportLevelLabel;

  /// No description provided for @interviewImportExtract.
  ///
  /// In vi, this message translates to:
  /// **'✨ Trích xuất câu hỏi'**
  String get interviewImportExtract;

  /// No description provided for @interviewImportExtracting.
  ///
  /// In vi, this message translates to:
  /// **'Đang trích xuất...'**
  String get interviewImportExtracting;

  /// No description provided for @interviewImportTitleLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tên buổi phỏng vấn'**
  String get interviewImportTitleLabel;

  /// No description provided for @interviewImportEditHint.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra & sửa câu hỏi và gợi ý trước khi lưu. Gợi ý chỉ hiển thị cho bạn, AI không thấy.'**
  String get interviewImportEditHint;

  /// No description provided for @interviewImportQuestionLabel.
  ///
  /// In vi, this message translates to:
  /// **'Câu {n}'**
  String interviewImportQuestionLabel(int n);

  /// No description provided for @interviewImportQuestionDeHint.
  ///
  /// In vi, this message translates to:
  /// **'Câu hỏi phỏng vấn (tiếng Đức)'**
  String get interviewImportQuestionDeHint;

  /// No description provided for @interviewImportQuestionViHint.
  ///
  /// In vi, this message translates to:
  /// **'Dịch nghĩa (tiếng Việt)'**
  String get interviewImportQuestionViHint;

  /// No description provided for @interviewImportHintDeHint.
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý — câu trả lời bạn chuẩn bị (tiếng Đức)'**
  String get interviewImportHintDeHint;

  /// No description provided for @interviewImportHintViHint.
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý (tiếng Việt)'**
  String get interviewImportHintViHint;

  /// No description provided for @interviewImportAddQuestion.
  ///
  /// In vi, this message translates to:
  /// **'+ Thêm câu hỏi'**
  String get interviewImportAddQuestion;

  /// No description provided for @interviewImportSave.
  ///
  /// In vi, this message translates to:
  /// **'Lưu & bắt đầu luyện'**
  String get interviewImportSave;

  /// No description provided for @interviewImportSaving.
  ///
  /// In vi, this message translates to:
  /// **'Đang lưu...'**
  String get interviewImportSaving;

  /// No description provided for @pronunciationHubTitle.
  ///
  /// In vi, this message translates to:
  /// **'Luyện Phát Âm Tiếng Đức'**
  String get pronunciationHubTitle;

  /// No description provided for @pronunciationHubInfoBanner.
  ///
  /// In vi, this message translates to:
  /// **'Phát âm đúng từ đầu giúp bạn tự tin hơn khi nói và tránh hiểu nhầm. Mỗi mô-đun tập trung vào một nhóm âm khó — luyện từng bước, nghe và bắt chước.'**
  String get pronunciationHubInfoBanner;

  /// No description provided for @pronunciationHubUmlauteTitle.
  ///
  /// In vi, this message translates to:
  /// **'Umlaute (ä, ö, ü)'**
  String get pronunciationHubUmlauteTitle;

  /// No description provided for @pronunciationHubUmlauteDesc.
  ///
  /// In vi, this message translates to:
  /// **'Phân biệt và luyện 3 nguyên âm biến thể đặc trưng của tiếng Đức'**
  String get pronunciationHubUmlauteDesc;

  /// No description provided for @pronunciationHubIchAchTitle.
  ///
  /// In vi, this message translates to:
  /// **'Ich-laut / Ach-laut'**
  String get pronunciationHubIchAchTitle;

  /// No description provided for @pronunciationHubIchAchDesc.
  ///
  /// In vi, this message translates to:
  /// **'Phân biệt ch sau nguyên âm trước và sau'**
  String get pronunciationHubIchAchDesc;

  /// No description provided for @pronunciationHubRSoundTitle.
  ///
  /// In vi, this message translates to:
  /// **'R-Sound'**
  String get pronunciationHubRSoundTitle;

  /// No description provided for @pronunciationHubRSoundDesc.
  ///
  /// In vi, this message translates to:
  /// **'Âm r cổ họng đặc trưng của tiếng Đức'**
  String get pronunciationHubRSoundDesc;

  /// No description provided for @pronunciationHubSpStTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sp / St Ban đầu'**
  String get pronunciationHubSpStTitle;

  /// No description provided for @pronunciationHubSpStDesc.
  ///
  /// In vi, this message translates to:
  /// **'sp → shp, st → sht ở đầu từ và vần'**
  String get pronunciationHubSpStDesc;

  /// No description provided for @pronunciationLoadError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải dữ liệu. Vui lòng thử lại.'**
  String get pronunciationLoadError;

  /// No description provided for @pronunciationRetry.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get pronunciationRetry;

  /// No description provided for @pronunciationNoData.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dữ liệu luyện tập.'**
  String get pronunciationNoData;

  /// No description provided for @pronunciationCompletedTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành!'**
  String get pronunciationCompletedTitle;

  /// No description provided for @pronunciationScoreCorrect.
  ///
  /// In vi, this message translates to:
  /// **'{score} / {total} đúng'**
  String pronunciationScoreCorrect(int score, int total);

  /// No description provided for @pronunciationRetryCta.
  ///
  /// In vi, this message translates to:
  /// **'Luyện lại'**
  String get pronunciationRetryCta;

  /// No description provided for @pronunciationBackCta.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại'**
  String get pronunciationBackCta;

  /// No description provided for @pronunciationHintLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mẹo phát âm:'**
  String get pronunciationHintLabel;

  /// No description provided for @pronunciationPlayCta.
  ///
  /// In vi, this message translates to:
  /// **'Nghe phát âm'**
  String get pronunciationPlayCta;

  /// No description provided for @pronunciationNextCta.
  ///
  /// In vi, this message translates to:
  /// **'Tôi đã đọc →'**
  String get pronunciationNextCta;

  /// No description provided for @pronunciationDoneCta.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành'**
  String get pronunciationDoneCta;

  /// No description provided for @pronunciationModePronounce.
  ///
  /// In vi, this message translates to:
  /// **'Phát âm'**
  String get pronunciationModePronounce;

  /// No description provided for @pronunciationModeDistinguish.
  ///
  /// In vi, this message translates to:
  /// **'Phân biệt'**
  String get pronunciationModeDistinguish;

  /// No description provided for @pronunciationModeDistinguishSpSt.
  ///
  /// In vi, this message translates to:
  /// **'Phân biệt sp/st'**
  String get pronunciationModeDistinguishSpSt;

  /// No description provided for @pronunciationModeCategorize.
  ///
  /// In vi, this message translates to:
  /// **'Phân loại'**
  String get pronunciationModeCategorize;

  /// No description provided for @pronunciationUmlauteTitle.
  ///
  /// In vi, this message translates to:
  /// **'Luyện Umlaute'**
  String get pronunciationUmlauteTitle;

  /// No description provided for @pronunciationIchAchTitle.
  ///
  /// In vi, this message translates to:
  /// **'Ich-laut / Ach-laut'**
  String get pronunciationIchAchTitle;

  /// No description provided for @pronunciationRSoundTitle.
  ///
  /// In vi, this message translates to:
  /// **'R-Sound Tiếng Đức'**
  String get pronunciationRSoundTitle;

  /// No description provided for @pronunciationSpStTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sp / St Ban đầu'**
  String get pronunciationSpStTitle;

  /// No description provided for @pronunciationIchLautBadge.
  ///
  /// In vi, this message translates to:
  /// **'Ich-laut [ç]'**
  String get pronunciationIchLautBadge;

  /// No description provided for @pronunciationAchLautBadge.
  ///
  /// In vi, this message translates to:
  /// **'Ach-laut [x]'**
  String get pronunciationAchLautBadge;

  /// No description provided for @pronunciationCompareLabel.
  ///
  /// In vi, this message translates to:
  /// **'So sánh:'**
  String get pronunciationCompareLabel;

  /// No description provided for @pronunciationROverviewInfo.
  ///
  /// In vi, this message translates to:
  /// **'Âm R tiếng Đức có 4 biến thể tùy vị trí. Bảng dưới giúp bạn nhớ nhanh quy tắc.'**
  String get pronunciationROverviewInfo;

  /// No description provided for @pronunciationRPositionInitial.
  ///
  /// In vi, this message translates to:
  /// **'Đầu từ [ʁ]'**
  String get pronunciationRPositionInitial;

  /// No description provided for @pronunciationRPositionAfterVowel.
  ///
  /// In vi, this message translates to:
  /// **'Sau nguyên âm [ɐ]'**
  String get pronunciationRPositionAfterVowel;

  /// No description provided for @pronunciationRPositionCluster.
  ///
  /// In vi, this message translates to:
  /// **'Cụm phụ âm [ʁ]'**
  String get pronunciationRPositionCluster;

  /// No description provided for @pronunciationRPositionVocalic.
  ///
  /// In vi, this message translates to:
  /// **'Cuối từ -er [ɐ]'**
  String get pronunciationRPositionVocalic;

  /// No description provided for @pronunciationQuizPrompt.
  ///
  /// In vi, this message translates to:
  /// **'Nghe và chọn từ bạn vừa nghe:'**
  String get pronunciationQuizPrompt;

  /// No description provided for @pronunciationQuizReplayHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhấn để nghe lại'**
  String get pronunciationQuizReplayHint;

  /// No description provided for @pronunciationQuizScore.
  ///
  /// In vi, this message translates to:
  /// **'{count} đúng'**
  String pronunciationQuizScore(int count);

  /// No description provided for @pronunciationStreak.
  ///
  /// In vi, this message translates to:
  /// **'🔥 {count} liên tiếp!'**
  String pronunciationStreak(int count);

  /// No description provided for @pronunciationQuizCorrect.
  ///
  /// In vi, this message translates to:
  /// **'✓ Đúng rồi!'**
  String get pronunciationQuizCorrect;

  /// No description provided for @pronunciationQuizWrong.
  ///
  /// In vi, this message translates to:
  /// **'✗ Chưa đúng'**
  String get pronunciationQuizWrong;

  /// No description provided for @pronunciationQuizHeardLabel.
  ///
  /// In vi, this message translates to:
  /// **'Từ vừa nghe:'**
  String get pronunciationQuizHeardLabel;

  /// No description provided for @pronunciationQuizComparing.
  ///
  /// In vi, this message translates to:
  /// **'Đang phát cả hai để so sánh...'**
  String get pronunciationQuizComparing;

  /// No description provided for @pronunciationQuizSeeResult.
  ///
  /// In vi, this message translates to:
  /// **'Xem kết quả'**
  String get pronunciationQuizSeeResult;

  /// No description provided for @pronunciationQuizInsufficientData.
  ///
  /// In vi, this message translates to:
  /// **'Không đủ dữ liệu để tạo bài kiểm tra.'**
  String get pronunciationQuizInsufficientData;

  /// No description provided for @pronunciationMinimalPairsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Luyện nghe cặp tối thiểu'**
  String get pronunciationMinimalPairsTitle;

  /// No description provided for @pronunciationMinimalPairsPickerHint.
  ///
  /// In vi, this message translates to:
  /// **'Chọn cặp âm bạn muốn luyện nghe phân biệt:'**
  String get pronunciationMinimalPairsPickerHint;

  /// No description provided for @pronunciationMinimalPairsCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} cặp từ'**
  String pronunciationMinimalPairsCount(int count);

  /// No description provided for @pronunciationMinimalPairsEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dữ liệu cặp âm. Vui lòng thử lại sau.'**
  String get pronunciationMinimalPairsEmpty;

  /// No description provided for @pronunciationMinimalPairsPracticing.
  ///
  /// In vi, this message translates to:
  /// **'Đang luyện:'**
  String get pronunciationMinimalPairsPracticing;

  /// No description provided for @pronunciationMinimalPairsPrompt.
  ///
  /// In vi, this message translates to:
  /// **'Bạn vừa nghe từ nào?'**
  String get pronunciationMinimalPairsPrompt;

  /// No description provided for @pronunciationMinimalPairsCorrectOf.
  ///
  /// In vi, this message translates to:
  /// **'Đúng {correct}/{total}'**
  String pronunciationMinimalPairsCorrectOf(int correct, int total);

  /// No description provided for @pronunciationMinimalPairsCorrectLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chính xác!'**
  String get pronunciationMinimalPairsCorrectLabel;

  /// No description provided for @pronunciationMinimalPairsWrongLabel.
  ///
  /// In vi, this message translates to:
  /// **'Sai rồi — đáp án đúng: {word}'**
  String pronunciationMinimalPairsWrongLabel(String word);

  /// No description provided for @pronunciationEndCta.
  ///
  /// In vi, this message translates to:
  /// **'Kết thúc'**
  String get pronunciationEndCta;

  /// No description provided for @pronunciationMinimalPairsResultTitle.
  ///
  /// In vi, this message translates to:
  /// **'Kết quả luyện nghe'**
  String get pronunciationMinimalPairsResultTitle;

  /// No description provided for @pronunciationMinimalPairsScoreLabel.
  ///
  /// In vi, this message translates to:
  /// **'{correct} / {total} câu đúng'**
  String pronunciationMinimalPairsScoreLabel(int correct, int total);

  /// No description provided for @pronunciationMinimalPairsLowScoreHint.
  ///
  /// In vi, this message translates to:
  /// **'Hãy nghe lại nhiều lần — tai bạn sẽ quen dần với sự khác biệt!'**
  String get pronunciationMinimalPairsLowScoreHint;

  /// No description provided for @pronunciationChangePairCta.
  ///
  /// In vi, this message translates to:
  /// **'Đổi cặp âm'**
  String get pronunciationChangePairCta;

  /// No description provided for @sprechenExamLoadError.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được đề: {error}'**
  String sprechenExamLoadError(String error);

  /// No description provided for @sprechenContentLockedTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nội dung Premium'**
  String get sprechenContentLockedTitle;

  /// No description provided for @sprechenPracticeCta.
  ///
  /// In vi, this message translates to:
  /// **'🎤 Luyện nói cùng Tiger AI'**
  String get sprechenPracticeCta;

  /// No description provided for @sprechenTopicListTitle.
  ///
  /// In vi, this message translates to:
  /// **'Danh sách đề'**
  String get sprechenTopicListTitle;

  /// No description provided for @sprechenTopicListLoadError.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi tải danh sách: {error}'**
  String sprechenTopicListLoadError(String error);

  /// No description provided for @sprechenTopicListEmpty.
  ///
  /// In vi, this message translates to:
  /// **'🎤 Chưa có đề bài'**
  String get sprechenTopicListEmpty;

  /// No description provided for @sprechenTopicListSummary.
  ///
  /// In vi, this message translates to:
  /// **'{count} đề · {done} hoàn thành'**
  String sprechenTopicListSummary(int count, int done);

  /// No description provided for @sprechenLeaderboardEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dữ liệu xếp hạng'**
  String get sprechenLeaderboardEmpty;

  /// No description provided for @sprechenTeilSetOverviewSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Luyện Sprechen — chọn phần để bắt đầu'**
  String get sprechenTeilSetOverviewSubtitle;

  /// No description provided for @sprechenTeilCompletedBadge.
  ///
  /// In vi, this message translates to:
  /// **'✓ Hoàn thành'**
  String get sprechenTeilCompletedBadge;

  /// No description provided for @sprechenOverviewTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nói — Sprechen'**
  String get sprechenOverviewTitle;

  /// No description provided for @sprechenOverviewSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'{providerLabel} · 3 phần · 75 Punkte'**
  String sprechenOverviewSubtitle(String providerLabel);

  /// No description provided for @sprechenOverviewGoetheInfo.
  ///
  /// In vi, this message translates to:
  /// **'Sprechen chiếm 75/300 điểm trong bài thi Goethe B1. Mỗi Teil được chấm theo 3 tiêu chí: Nội dung, Ngữ pháp & cấu trúc câu, Từ vựng & lưu loát.'**
  String get sprechenOverviewGoetheInfo;

  /// No description provided for @sprechenOverviewTelcInfo.
  ///
  /// In vi, this message translates to:
  /// **'Sprechen chiếm 75/300 điểm trong bài thi telc B1.'**
  String get sprechenOverviewTelcInfo;

  /// No description provided for @sprechenTopicCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} đề'**
  String sprechenTopicCount(int count);

  /// No description provided for @sprechenTopicSearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm theo tên đề hoặc nhóm chủ đề...'**
  String get sprechenTopicSearchHint;

  /// No description provided for @sprechenTopicListFilteredCount.
  ///
  /// In vi, this message translates to:
  /// **'{filtered}/{total} đề'**
  String sprechenTopicListFilteredCount(int filtered, int total);

  /// No description provided for @sprechenTopicListEmptyFiltered.
  ///
  /// In vi, this message translates to:
  /// **'🎤 Không tìm thấy đề phù hợp'**
  String get sprechenTopicListEmptyFiltered;

  /// No description provided for @sprechenBewertungMainErrors.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi chính'**
  String get sprechenBewertungMainErrors;

  /// No description provided for @sprechenHistoryButtonLabel.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử'**
  String get sprechenHistoryButtonLabel;

  /// No description provided for @sprechenPracticeStartCta.
  ///
  /// In vi, this message translates to:
  /// **'Luyện thi ngay — Nói chuyện với AI'**
  String get sprechenPracticeStartCta;

  /// No description provided for @sprechenResultBackToList.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại danh sách'**
  String get sprechenResultBackToList;

  /// No description provided for @sprechenNoSuggestions.
  ///
  /// In vi, this message translates to:
  /// **'Không có gợi ý'**
  String get sprechenNoSuggestions;

  /// No description provided for @sprechenInputHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập câu trả lời bằng tiếng Đức...'**
  String get sprechenInputHint;

  /// No description provided for @sprechenMicComingSoon.
  ///
  /// In vi, this message translates to:
  /// **'Chế độ nói sắp ra mắt — dùng Viết trước nhé'**
  String get sprechenMicComingSoon;

  /// No description provided for @sprechenMicUnsupported.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ hỗ trợ Viết ở phiên bản này'**
  String get sprechenMicUnsupported;

  /// No description provided for @sprechenPartnerSubtitleDefault.
  ///
  /// In vi, this message translates to:
  /// **'Trả lời bằng tiếng Đức'**
  String get sprechenPartnerSubtitleDefault;

  /// No description provided for @sprechenFeedbackScoreLabel.
  ///
  /// In vi, this message translates to:
  /// **'{score}/5 · phản hồi'**
  String sprechenFeedbackScoreLabel(int score);

  /// No description provided for @sprechenSessionHistoryEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có phiên luyện tập nào'**
  String get sprechenSessionHistoryEmpty;

  /// No description provided for @sprechenStudyPanelLocked.
  ///
  /// In vi, this message translates to:
  /// **'Nội dung Premium — nâng cấp để xem đầy đủ'**
  String get sprechenStudyPanelLocked;

  /// No description provided for @sprechenStudyPanelEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có nội dung học cho đề này.'**
  String get sprechenStudyPanelEmpty;

  /// No description provided for @conversationTranscriptEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Không có nội dung hội thoại.'**
  String get conversationTranscriptEmpty;

  /// No description provided for @writingHotBadge.
  ///
  /// In vi, this message translates to:
  /// **'HOT'**
  String get writingHotBadge;

  /// No description provided for @writingCompletedBadge.
  ///
  /// In vi, this message translates to:
  /// **'Đã học'**
  String get writingCompletedBadge;

  /// No description provided for @writingPremiumBadge.
  ///
  /// In vi, this message translates to:
  /// **'Premium'**
  String get writingPremiumBadge;

  /// No description provided for @writingUnlockToView.
  ///
  /// In vi, this message translates to:
  /// **'Mở khóa để xem'**
  String get writingUnlockToView;

  /// No description provided for @writingBuyPremium.
  ///
  /// In vi, this message translates to:
  /// **'Mua Premium'**
  String get writingBuyPremium;

  /// No description provided for @writingDifficultyEasy.
  ///
  /// In vi, this message translates to:
  /// **'Dễ'**
  String get writingDifficultyEasy;

  /// No description provided for @writingDifficultyMedium.
  ///
  /// In vi, this message translates to:
  /// **'TB'**
  String get writingDifficultyMedium;

  /// No description provided for @writingDifficultyHard.
  ///
  /// In vi, this message translates to:
  /// **'Khó'**
  String get writingDifficultyHard;

  /// No description provided for @writingLeaderboardTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bảng xếp hạng · Teil {teil}'**
  String writingLeaderboardTitle(int teil);

  /// No description provided for @writingLeaderboardEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có ai hoàn thành đề nào'**
  String get writingLeaderboardEmpty;

  /// No description provided for @writingLeaderboardYou.
  ///
  /// In vi, this message translates to:
  /// **'bạn'**
  String get writingLeaderboardYou;

  /// No description provided for @writingCommunityFolderTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đề do cộng đồng đóng góp'**
  String get writingCommunityFolderTitle;

  /// No description provided for @writingCommunityFolderCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} đề đã được thêm'**
  String writingCommunityFolderCount(int count);

  /// No description provided for @writingCommunityFolderEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có đề — hãy là người đầu tiên!'**
  String get writingCommunityFolderEmpty;

  /// No description provided for @writingSearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm theo tên đề, chủ đề, từ khóa...'**
  String get writingSearchHint;

  /// No description provided for @writingSprintPill.
  ///
  /// In vi, this message translates to:
  /// **'Sprint 10h'**
  String get writingSprintPill;

  /// No description provided for @writingSprintComingSoon.
  ///
  /// In vi, this message translates to:
  /// **'Sprint 10h sẽ sớm ra mắt'**
  String get writingSprintComingSoon;

  /// No description provided for @writingTopicCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} đề'**
  String writingTopicCount(int count);

  /// No description provided for @writingTopicCountFiltered.
  ///
  /// In vi, this message translates to:
  /// **'{count}/{total} đề'**
  String writingTopicCountFiltered(int count, int total);

  /// No description provided for @writingNoResultsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy đề phù hợp'**
  String get writingNoResultsTitle;

  /// No description provided for @writingNoResultsHint.
  ///
  /// In vi, this message translates to:
  /// **'Thử tìm bằng tiếng Đức, tiếng Việt hoặc tên chủ đề khác.'**
  String get writingNoResultsHint;

  /// No description provided for @writingFreeLimitTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đang xem 5 đề miễn phí của Teil {teil}'**
  String writingFreeLimitTitle(int teil);

  /// No description provided for @writingFreeLimitDesc.
  ///
  /// In vi, this message translates to:
  /// **'Nâng cấp Premium để mở toàn bộ chủ đề Schreiben B1 và dùng AI chấm bài không giới hạn.'**
  String get writingFreeLimitDesc;

  /// No description provided for @writingTeilLabel.
  ///
  /// In vi, this message translates to:
  /// **'Teil {n}'**
  String writingTeilLabel(int n);

  /// No description provided for @writingCommunityListTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đề cộng đồng · Teil {teil}'**
  String writingCommunityListTitle(int teil);

  /// No description provided for @writingPracticeNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy đề viết.'**
  String get writingPracticeNotFound;

  /// No description provided for @writingWordCountHint.
  ///
  /// In vi, this message translates to:
  /// **'📏 {min}–{max} từ'**
  String writingWordCountHint(int min, int max);

  /// No description provided for @writingShowTranslation.
  ///
  /// In vi, this message translates to:
  /// **'Hiện dịch'**
  String get writingShowTranslation;

  /// No description provided for @writingHideTranslation.
  ///
  /// In vi, this message translates to:
  /// **'Ẩn dịch'**
  String get writingHideTranslation;

  /// No description provided for @writingRequirementsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu viết'**
  String get writingRequirementsTitle;

  /// No description provided for @writingSectionTask.
  ///
  /// In vi, this message translates to:
  /// **'Đề bài'**
  String get writingSectionTask;

  /// No description provided for @writingSectionTaskAnalysis.
  ///
  /// In vi, this message translates to:
  /// **'Phân tích đề (Task analysis)'**
  String get writingSectionTaskAnalysis;

  /// No description provided for @writingSectionTextStructure.
  ///
  /// In vi, this message translates to:
  /// **'Cấu trúc bài viết'**
  String get writingSectionTextStructure;

  /// No description provided for @writingSectionPhrases.
  ///
  /// In vi, this message translates to:
  /// **'Mẫu câu hữu ích'**
  String get writingSectionPhrases;

  /// No description provided for @writingSectionSamples.
  ///
  /// In vi, this message translates to:
  /// **'Câu mẫu theo điểm'**
  String get writingSectionSamples;

  /// No description provided for @writingSectionModels.
  ///
  /// In vi, this message translates to:
  /// **'Bài mẫu'**
  String get writingSectionModels;

  /// No description provided for @writingSectionGrammar.
  ///
  /// In vi, this message translates to:
  /// **'Ngữ pháp trọng tâm (tham khảo)'**
  String get writingSectionGrammar;

  /// No description provided for @writingSectionVocab.
  ///
  /// In vi, this message translates to:
  /// **'Từ vựng trọng tâm (tham khảo)'**
  String get writingSectionVocab;

  /// No description provided for @writingSectionMistakes.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi thường gặp (tham khảo)'**
  String get writingSectionMistakes;

  /// No description provided for @writingSectionExercises.
  ///
  /// In vi, this message translates to:
  /// **'Bài tập luyện'**
  String get writingSectionExercises;

  /// No description provided for @writingApproachesLabel.
  ///
  /// In vi, this message translates to:
  /// **'{count} cách triển khai'**
  String writingApproachesLabel(int count);

  /// No description provided for @writingAnnotationsLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chú thích:'**
  String get writingAnnotationsLabel;

  /// No description provided for @writingModelTabLabel.
  ///
  /// In vi, this message translates to:
  /// **'Model {n}'**
  String writingModelTabLabel(int n);

  /// No description provided for @writingColPart.
  ///
  /// In vi, this message translates to:
  /// **'Phần'**
  String get writingColPart;

  /// No description provided for @writingColDe.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Đức'**
  String get writingColDe;

  /// No description provided for @writingColVi.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Việt'**
  String get writingColVi;

  /// No description provided for @writingKernwortschatzTitle.
  ///
  /// In vi, this message translates to:
  /// **'Kernwortschatz ({count} từ)'**
  String writingKernwortschatzTitle(int count);

  /// No description provided for @writingGenusOther.
  ///
  /// In vi, this message translates to:
  /// **'Khác'**
  String get writingGenusOther;

  /// No description provided for @writingTranslateExamples.
  ///
  /// In vi, this message translates to:
  /// **'🌐 Dịch ví dụ'**
  String get writingTranslateExamples;

  /// No description provided for @writingChunksTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chunks & Wendungen ({count} cụm)'**
  String writingChunksTitle(int count);

  /// No description provided for @writingKonnektorenTitle.
  ///
  /// In vi, this message translates to:
  /// **'Konnektoren ({count} từ nối)'**
  String writingKonnektorenTitle(int count);

  /// No description provided for @writingNoContent.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có nội dung.'**
  String get writingNoContent;

  /// No description provided for @writingCorrectCount.
  ///
  /// In vi, this message translates to:
  /// **'câu đúng'**
  String get writingCorrectCount;

  /// No description provided for @writingWrongSentenceLabel.
  ///
  /// In vi, this message translates to:
  /// **'CÂU SAI'**
  String get writingWrongSentenceLabel;

  /// No description provided for @writingRevealAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Xem đáp án'**
  String get writingRevealAnswer;

  /// No description provided for @writingShowSampleAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Xem câu mẫu'**
  String get writingShowSampleAnswer;

  /// No description provided for @writingSampleAnswerLabel.
  ///
  /// In vi, this message translates to:
  /// **'Câu mẫu'**
  String get writingSampleAnswerLabel;

  /// No description provided for @writingPlayAll.
  ///
  /// In vi, this message translates to:
  /// **'Phát toàn bộ'**
  String get writingPlayAll;

  /// No description provided for @writingExamTimesCount.
  ///
  /// In vi, this message translates to:
  /// **'📊 {count} lần thi'**
  String writingExamTimesCount(int count);

  /// No description provided for @writingMinutesUnit.
  ///
  /// In vi, this message translates to:
  /// **'phút'**
  String get writingMinutesUnit;

  /// No description provided for @writingWordsUnit.
  ///
  /// In vi, this message translates to:
  /// **'từ'**
  String get writingWordsUnit;

  /// No description provided for @writingProvenanceTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đề thật — {count} lần thi'**
  String writingProvenanceTitle(int count);

  /// No description provided for @writingSourcesLabel.
  ///
  /// In vi, this message translates to:
  /// **'Nguồn'**
  String get writingSourcesLabel;

  /// No description provided for @writingExamDatesToggle.
  ///
  /// In vi, this message translates to:
  /// **'Xem ngày ra đề chi tiết'**
  String get writingExamDatesToggle;

  /// No description provided for @writingLockTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đề này dành cho tài khoản Premium'**
  String get writingLockTitle;

  /// No description provided for @writingLockOfficialCopy.
  ///
  /// In vi, this message translates to:
  /// **'Đây là đề chính thức Premium. Nâng cấp để xem đầy đủ nội dung.'**
  String get writingLockOfficialCopy;

  /// No description provided for @writingLockLegacyCopy.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản miễn phí chỉ xem 5 đề đầu của mỗi Teil. Nâng cấp Premium để mở toàn bộ.'**
  String get writingLockLegacyCopy;

  /// No description provided for @writingUnlockPremiumCta.
  ///
  /// In vi, this message translates to:
  /// **'Mở khóa Premium'**
  String get writingUnlockPremiumCta;

  /// No description provided for @writingCompleteMark.
  ///
  /// In vi, this message translates to:
  /// **'🎯 Đánh dấu hoàn thành'**
  String get writingCompleteMark;

  /// No description provided for @writingCompleteDone.
  ///
  /// In vi, this message translates to:
  /// **'✓ Đã hoàn thành — Lưu lại'**
  String get writingCompleteDone;

  /// No description provided for @writingCompleteSaving.
  ///
  /// In vi, this message translates to:
  /// **'Đang lưu...'**
  String get writingCompleteSaving;

  /// No description provided for @writingStartPracticeCta.
  ///
  /// In vi, this message translates to:
  /// **'Viết bài cá nhân → AI chấm'**
  String get writingStartPracticeCta;

  /// No description provided for @writingTypingStartTitle.
  ///
  /// In vi, this message translates to:
  /// **'Luyện gõ bài này'**
  String get writingTypingStartTitle;

  /// No description provided for @writingTypingStartDesc.
  ///
  /// In vi, this message translates to:
  /// **'Có {count} câu tiếng Đức trên trang — luyện gõ lại từng câu.'**
  String writingTypingStartDesc(int count);

  /// No description provided for @writingTypingStartCta.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu gõ →'**
  String get writingTypingStartCta;

  /// No description provided for @writingTypingPracticeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Luyện gõ'**
  String get writingTypingPracticeTitle;

  /// No description provided for @writingTypingProgress.
  ///
  /// In vi, this message translates to:
  /// **'Câu {current}/{total}'**
  String writingTypingProgress(int current, int total);

  /// No description provided for @writingTypingHint.
  ///
  /// In vi, this message translates to:
  /// **'Gõ lại câu tiếng Đức...'**
  String get writingTypingHint;

  /// No description provided for @writingTypingCheck.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra'**
  String get writingTypingCheck;

  /// No description provided for @writingTypingCorrect.
  ///
  /// In vi, this message translates to:
  /// **'✓ Chính xác!'**
  String get writingTypingCorrect;

  /// No description provided for @writingTypingIncorrect.
  ///
  /// In vi, this message translates to:
  /// **'✗ Còn vài chỗ chưa đúng'**
  String get writingTypingIncorrect;

  /// No description provided for @writingTypingNext.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp →'**
  String get writingTypingNext;

  /// No description provided for @writingTypingSkip.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ qua'**
  String get writingTypingSkip;

  /// No description provided for @writingTypingDoneCount.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã gõ xong {count} câu'**
  String writingTypingDoneCount(int count);

  /// No description provided for @writingTypingClose.
  ///
  /// In vi, this message translates to:
  /// **'Đóng'**
  String get writingTypingClose;

  /// No description provided for @listeningPageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nghe'**
  String get listeningPageTitle;

  /// No description provided for @listeningPageSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Luyện nghe tiếng Đức qua video, podcast và audiobook'**
  String get listeningPageSubtitle;

  /// No description provided for @listeningIntroWhy.
  ///
  /// In vi, this message translates to:
  /// **'Luyện nghe/đọc với nội dung vừa sức trình độ của bạn.'**
  String get listeningIntroWhy;

  /// No description provided for @listeningIntroTodo.
  ///
  /// In vi, this message translates to:
  /// **'Chọn nguồn: video, podcast, hay bài đọc.'**
  String get listeningIntroTodo;

  /// No description provided for @listeningIntroNext.
  ///
  /// In vi, this message translates to:
  /// **'Lưu từ mới gặp để đưa vào ôn tập.'**
  String get listeningIntroNext;

  /// No description provided for @listeningOtherSourcesSection.
  ///
  /// In vi, this message translates to:
  /// **'Khác'**
  String get listeningOtherSourcesSection;

  /// No description provided for @listeningSourceSprechenB1Desc.
  ///
  /// In vi, this message translates to:
  /// **'Luyện nghe chép chính tả với video Sprechen B1'**
  String get listeningSourceSprechenB1Desc;

  /// No description provided for @listeningSourceSprechenB2Desc.
  ///
  /// In vi, this message translates to:
  /// **'Luyện nghe chép chính tả với video Sprechen B2'**
  String get listeningSourceSprechenB2Desc;

  /// No description provided for @listeningSourceYoutubeDesc.
  ///
  /// In vi, this message translates to:
  /// **'Luyện nghe với video YouTube có phụ đề'**
  String get listeningSourceYoutubeDesc;

  /// No description provided for @listeningSourcePodcastDesc.
  ///
  /// In vi, this message translates to:
  /// **'Nghe Easy German Podcast với phụ đề song ngữ'**
  String get listeningSourcePodcastDesc;

  /// No description provided for @listeningSourceAudiobookDesc.
  ///
  /// In vi, this message translates to:
  /// **'Nghe sách nói tiếng Đức dễ hiểu'**
  String get listeningSourceAudiobookDesc;

  /// No description provided for @listeningSourceVideoCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} video'**
  String listeningSourceVideoCount(int count);

  /// No description provided for @easyGermanSegmentCountShort.
  ///
  /// In vi, this message translates to:
  /// **'Ngắn'**
  String get easyGermanSegmentCountShort;

  /// No description provided for @easyGermanSegmentCountMedium.
  ///
  /// In vi, this message translates to:
  /// **'Vừa'**
  String get easyGermanSegmentCountMedium;

  /// No description provided for @easyGermanSegmentCountLong.
  ///
  /// In vi, this message translates to:
  /// **'Dài'**
  String get easyGermanSegmentCountLong;

  /// No description provided for @easyGermanLoadError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải danh sách video. Vui lòng thử lại sau.'**
  String get easyGermanLoadError;

  /// No description provided for @easyGermanSentenceCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} câu'**
  String easyGermanSentenceCount(int count);

  /// No description provided for @easyGermanSearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm video theo tiêu đề hoặc video ID...'**
  String get easyGermanSearchHint;

  /// No description provided for @easyGermanLeaderboardEmptyHint.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có đủ dữ liệu để xếp hạng level này.'**
  String get easyGermanLeaderboardEmptyHint;

  /// No description provided for @podcastLoadError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải danh sách tập. Vui lòng thử lại sau.'**
  String get podcastLoadError;

  /// No description provided for @podcastDescription.
  ///
  /// In vi, this message translates to:
  /// **'Luyện nghe podcast tiếng Đức đời thường'**
  String get podcastDescription;

  /// No description provided for @podcastEpisodeCountLabel.
  ///
  /// In vi, this message translates to:
  /// **'tập podcast'**
  String get podcastEpisodeCountLabel;

  /// No description provided for @podcastMinutesLabel.
  ///
  /// In vi, this message translates to:
  /// **'phút luyện nghe'**
  String get podcastMinutesLabel;

  /// No description provided for @podcastSearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm tập podcast...'**
  String get podcastSearchHint;

  /// No description provided for @podcastNoResultsFor.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy tập nào khớp với \"{query}\".'**
  String podcastNoResultsFor(String query);

  /// No description provided for @podcastNoResultsInBucket.
  ///
  /// In vi, this message translates to:
  /// **'Không có tập nào trong khoảng thời lượng này.'**
  String get podcastNoResultsInBucket;

  /// No description provided for @podcastPageInfo.
  ///
  /// In vi, this message translates to:
  /// **'Trang {page}/{total} ({count} tập)'**
  String podcastPageInfo(int page, int total, int count);

  /// No description provided for @podcastAudioLoadError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải âm thanh. Vui lòng thử lại.'**
  String get podcastAudioLoadError;

  /// No description provided for @podcastEpisodeLoadError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải tập podcast.'**
  String get podcastEpisodeLoadError;

  /// No description provided for @podcastBackToList.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại danh sách'**
  String get podcastBackToList;

  /// No description provided for @podcastTranscriptEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có transcript cho tập này.'**
  String get podcastTranscriptEmpty;

  /// No description provided for @podcastLeaderboardSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Số tập podcast đã hoàn thành'**
  String get podcastLeaderboardSubtitle;

  /// No description provided for @podcastLeaderboardLoadError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải bảng xếp hạng.'**
  String get podcastLeaderboardLoadError;

  /// No description provided for @podcastYourRank.
  ///
  /// In vi, this message translates to:
  /// **'Hạng của bạn: #{rank} · {count} tập'**
  String podcastYourRank(int rank, int count);

  /// No description provided for @podcastSettingsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt đọc'**
  String get podcastSettingsTitle;

  /// No description provided for @podcastFontSizeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Cỡ chữ ({percent}%)'**
  String podcastFontSizeLabel(int percent);

  /// No description provided for @podcastShowViTranslation.
  ///
  /// In vi, this message translates to:
  /// **'Hiện bản dịch tiếng Việt'**
  String get podcastShowViTranslation;

  /// No description provided for @podcastDurationLe10.
  ///
  /// In vi, this message translates to:
  /// **'≤ 10 phút'**
  String get podcastDurationLe10;

  /// No description provided for @podcastDurationLe20.
  ///
  /// In vi, this message translates to:
  /// **'10–20 phút'**
  String get podcastDurationLe20;

  /// No description provided for @podcastDurationLe60.
  ///
  /// In vi, this message translates to:
  /// **'20–60 phút'**
  String get podcastDurationLe60;

  /// No description provided for @podcastDurationGt60.
  ///
  /// In vi, this message translates to:
  /// **'> 60 phút'**
  String get podcastDurationGt60;

  /// No description provided for @videoCollectionWatched.
  ///
  /// In vi, this message translates to:
  /// **'Đã xem'**
  String get videoCollectionWatched;

  /// No description provided for @videoCollectionEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy video phù hợp'**
  String get videoCollectionEmptyTitle;

  /// No description provided for @videoCollectionEmptyHint.
  ///
  /// In vi, this message translates to:
  /// **'Thử từ khóa khác hoặc xóa bộ lọc.'**
  String get videoCollectionEmptyHint;

  /// No description provided for @videoCollectionLeaderboardTitle.
  ///
  /// In vi, this message translates to:
  /// **'Top học tập'**
  String get videoCollectionLeaderboardTitle;

  /// No description provided for @videoCollectionLeaderboardSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Xếp hạng theo video hoàn thành và lượt xem lại.'**
  String get videoCollectionLeaderboardSubtitle;

  /// No description provided for @videoCollectionLeaderboardEmptyHint.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có đủ dữ liệu để xếp hạng.'**
  String get videoCollectionLeaderboardEmptyHint;

  /// No description provided for @videoCollectionLeaderboardStats.
  ///
  /// In vi, this message translates to:
  /// **'{count} video · {rewatch} xem lại'**
  String videoCollectionLeaderboardStats(int count, int rewatch);

  /// No description provided for @videoCollectionPageInfo.
  ///
  /// In vi, this message translates to:
  /// **'Trang {page} / {total}'**
  String videoCollectionPageInfo(int page, int total);

  /// No description provided for @videoCollectionStatusNew.
  ///
  /// In vi, this message translates to:
  /// **'Chưa xem'**
  String get videoCollectionStatusNew;

  /// No description provided for @videoCollectionProgressEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dữ liệu video.'**
  String get videoCollectionProgressEmpty;

  /// No description provided for @videoCollectionProgressStart.
  ///
  /// In vi, this message translates to:
  /// **'Mở một video để bắt đầu lưu tiến độ học.'**
  String get videoCollectionProgressStart;

  /// No description provided for @videoCollectionProgressDone.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã hoàn thành toàn bộ!'**
  String get videoCollectionProgressDone;

  /// No description provided for @videoCollectionProgressFinalStretch.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đang ở chặng cuối rồi!'**
  String get videoCollectionProgressFinalStretch;

  /// No description provided for @videoCollectionProgressGoodPace.
  ///
  /// In vi, this message translates to:
  /// **'Tiến độ đang rất ổn, tiếp tục giữ nhịp.'**
  String get videoCollectionProgressGoodPace;

  /// No description provided for @videoCollectionProgressGoodStart.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã bắt đầu tốt, tiếp tục thêm vài video nữa.'**
  String get videoCollectionProgressGoodStart;

  /// No description provided for @videoCollectionStatRewatch.
  ///
  /// In vi, this message translates to:
  /// **'Xem lại'**
  String get videoCollectionStatRewatch;

  /// No description provided for @videoCollectionStatRemaining.
  ///
  /// In vi, this message translates to:
  /// **'Còn lại'**
  String get videoCollectionStatRemaining;

  /// No description provided for @videoCollectionCompletionLabel.
  ///
  /// In vi, this message translates to:
  /// **'hoàn thành'**
  String get videoCollectionCompletionLabel;

  /// No description provided for @videoCollectionPercentLabel.
  ///
  /// In vi, this message translates to:
  /// **'{percent}% {label}'**
  String videoCollectionPercentLabel(int percent, String label);

  /// No description provided for @videoCollectionSavedCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} video đã lưu tiến độ'**
  String videoCollectionSavedCount(int count);

  /// No description provided for @appOnlySettingsLabel.
  ///
  /// In vi, this message translates to:
  /// **'Riêng ứng dụng'**
  String get appOnlySettingsLabel;

  /// No description provided for @appUpdateSectionDescription.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra và cập nhật lên phiên bản mới nhất từ store.'**
  String get appUpdateSectionDescription;

  /// No description provided for @appUpdateSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật lên bản mới nhất'**
  String get appUpdateSectionTitle;

  /// No description provided for @confirmNewPassword.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận mật khẩu mới'**
  String get confirmNewPassword;

  /// No description provided for @couldNotChangePassword.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi khi đổi mật khẩu. Vui lòng thử lại.'**
  String get couldNotChangePassword;

  /// No description provided for @darkModeDescription.
  ///
  /// In vi, this message translates to:
  /// **'Giảm mỏi mắt khi học ban đêm'**
  String get darkModeDescription;

  /// No description provided for @darkModeToggle.
  ///
  /// In vi, this message translates to:
  /// **'Chế độ tối'**
  String get darkModeToggle;

  /// No description provided for @dismissAnnouncement.
  ///
  /// In vi, this message translates to:
  /// **'Đóng thông báo'**
  String get dismissAnnouncement;

  /// No description provided for @learningPreferencesGoalCommunication.
  ///
  /// In vi, this message translates to:
  /// **'Giao tiếp hàng ngày'**
  String get learningPreferencesGoalCommunication;

  /// No description provided for @learningPreferencesGoalGoethe.
  ///
  /// In vi, this message translates to:
  /// **'Thi chứng chỉ Goethe'**
  String get learningPreferencesGoalGoethe;

  /// No description provided for @learningPreferencesGoalMedical.
  ///
  /// In vi, this message translates to:
  /// **'Chuyên ngành điều dưỡng-y khoa'**
  String get learningPreferencesGoalMedical;

  /// No description provided for @learningPreferencesGoalOther.
  ///
  /// In vi, this message translates to:
  /// **'Khác'**
  String get learningPreferencesGoalOther;

  /// No description provided for @learningPreferencesGoalsLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu'**
  String get learningPreferencesGoalsLabel;

  /// No description provided for @learningPreferencesGoalWork.
  ///
  /// In vi, this message translates to:
  /// **'Du học-làm việc tại Đức'**
  String get learningPreferencesGoalWork;

  /// No description provided for @learningPreferencesMinutesLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian học mỗi ngày'**
  String get learningPreferencesMinutesLabel;

  /// No description provided for @learningPreferencesXpSummary.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu: {xp} XP/ngày · ~{words} từ/ngày'**
  String learningPreferencesXpSummary(int xp, int words);

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc muốn đăng xuất?'**
  String get logoutConfirmMessage;

  /// No description provided for @minutesUnit.
  ///
  /// In vi, this message translates to:
  /// **'phút'**
  String get minutesUnit;

  /// No description provided for @notificationPermissionBlockedBody.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng bật lại trong cài đặt hệ thống → Thông báo.'**
  String get notificationPermissionBlockedBody;

  /// No description provided for @notificationPermissionBlockedTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo đã bị chặn'**
  String get notificationPermissionBlockedTitle;

  /// No description provided for @notificationPermissionEnableAction.
  ///
  /// In vi, this message translates to:
  /// **'Bật thông báo'**
  String get notificationPermissionEnableAction;

  /// No description provided for @notificationPreferencesSendTest.
  ///
  /// In vi, this message translates to:
  /// **'Gửi thử'**
  String get notificationPreferencesSendTest;

  /// No description provided for @notificationPreferencesTestFailed.
  ///
  /// In vi, this message translates to:
  /// **'Gửi thất bại. Thử lại sau.'**
  String get notificationPreferencesTestFailed;

  /// No description provided for @notificationPreferencesTestSending.
  ///
  /// In vi, this message translates to:
  /// **'Đang gửi…'**
  String get notificationPreferencesTestSending;

  /// No description provided for @notificationPreferencesTestSent.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi! Thông báo sẽ hiện trên thiết bị sau vài giây.'**
  String get notificationPreferencesTestSent;

  /// No description provided for @notificationPreferencesTimezone.
  ///
  /// In vi, this message translates to:
  /// **'Múi giờ'**
  String get notificationPreferencesTimezone;

  /// No description provided for @passwordMinLength.
  ///
  /// In vi, this message translates to:
  /// **'Tối thiểu 8 ký tự'**
  String get passwordMinLength;

  /// No description provided for @reviewDisplay4Button.
  ///
  /// In vi, this message translates to:
  /// **'Tự đánh giá 4-mức (sau mỗi vòng)'**
  String get reviewDisplay4Button;

  /// No description provided for @reviewDisplay4ButtonDesc.
  ///
  /// In vi, this message translates to:
  /// **'Hiện bảng Quên/Khó/Tốt/Dễ sau mỗi vòng để chỉnh lại đánh giá tự động.'**
  String get reviewDisplay4ButtonDesc;

  /// No description provided for @reviewDisplayAutoAdvance.
  ///
  /// In vi, this message translates to:
  /// **'Tự động chuyển câu'**
  String get reviewDisplayAutoAdvance;

  /// No description provided for @reviewDisplayAutoAdvanceDesc.
  ///
  /// In vi, this message translates to:
  /// **'Bật: tự nhảy sang câu kế sau khi trả lời. Tắt (khuyến nghị): bạn bấm \"Tiếp tục\" để chủ động chuyển.'**
  String get reviewDisplayAutoAdvanceDesc;

  /// No description provided for @reviewDisplayContext.
  ///
  /// In vi, this message translates to:
  /// **'Hiện câu ví dụ'**
  String get reviewDisplayContext;

  /// No description provided for @reviewDisplayContextDesc.
  ///
  /// In vi, this message translates to:
  /// **'Hiện một câu ví dụ ngắn dưới mỗi từ trong bảng tóm tắt.'**
  String get reviewDisplayContextDesc;

  /// No description provided for @reviewDisplayTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hiển thị ôn tập'**
  String get reviewDisplayTitle;

  /// No description provided for @settingsSavedMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu!'**
  String get settingsSavedMessage;

  /// No description provided for @settingsSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Tùy chỉnh ứng dụng'**
  String get settingsSubtitle;

  /// No description provided for @soundAndEffects.
  ///
  /// In vi, this message translates to:
  /// **'Âm thanh & hiệu ứng'**
  String get soundAndEffects;

  /// No description provided for @soundAndEffectsDescription.
  ///
  /// In vi, this message translates to:
  /// **'Âm thanh và rung khi trả lời đúng/sai trong bài học'**
  String get soundAndEffectsDescription;

  /// No description provided for @listeningSprechenHeaderSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'{count} video · Luyện nghe chép chính tả'**
  String listeningSprechenHeaderSubtitle(int count);

  /// No description provided for @writingHubTitle.
  ///
  /// In vi, this message translates to:
  /// **'Luyện viết (AI chấm)'**
  String get writingHubTitle;

  /// No description provided for @writingHubRubricButton.
  ///
  /// In vi, this message translates to:
  /// **'📋 Cách chấm'**
  String get writingHubRubricButton;

  /// No description provided for @writingHubTabStart.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu'**
  String get writingHubTabStart;

  /// No description provided for @writingHubTabMy.
  ///
  /// In vi, this message translates to:
  /// **'Bài của tôi'**
  String get writingHubTabMy;

  /// No description provided for @writingHubTabCommunity.
  ///
  /// In vi, this message translates to:
  /// **'Cộng đồng'**
  String get writingHubTabCommunity;

  /// No description provided for @writingHubStartIntro.
  ///
  /// In vi, this message translates to:
  /// **'Chọn kỳ thi và trình độ để bắt đầu luyện viết.'**
  String get writingHubStartIntro;

  /// No description provided for @writingHubCustomTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tự nhập đề của bạn'**
  String get writingHubCustomTitle;

  /// No description provided for @writingHubCustomSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Dán đề bất kỳ → chọn kì thi & trình độ → AI chấm'**
  String get writingHubCustomSubtitle;

  /// No description provided for @writingHubSprintTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sprint luyện cấp tốc'**
  String get writingHubSprintTitle;

  /// No description provided for @writingHubSprintSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Ôn nhanh mẫu câu Goethe B1 theo thẻ lặp lại'**
  String get writingHubSprintSubtitle;

  /// No description provided for @writingHubCommunityIntro.
  ///
  /// In vi, this message translates to:
  /// **'Đề luyện viết do cộng đồng đóng góp, nhóm theo từng phần thi.'**
  String get writingHubCommunityIntro;

  /// No description provided for @writingHubCommunityTeil1.
  ///
  /// In vi, this message translates to:
  /// **'Teil 1 — Email thân mật'**
  String get writingHubCommunityTeil1;

  /// No description provided for @writingHubCommunityTeil2.
  ///
  /// In vi, this message translates to:
  /// **'Teil 2 — Bài luận diễn đàn'**
  String get writingHubCommunityTeil2;

  /// No description provided for @writingHubCommunityTeil3.
  ///
  /// In vi, this message translates to:
  /// **'Teil 3 — Email trang trọng'**
  String get writingHubCommunityTeil3;

  /// No description provided for @writingHubCommunityViewAll.
  ///
  /// In vi, this message translates to:
  /// **'Xem tất cả đề cộng đồng →'**
  String get writingHubCommunityViewAll;

  /// No description provided for @writingChooseNow.
  ///
  /// In vi, this message translates to:
  /// **'Chọn đề ngay'**
  String get writingChooseNow;

  /// No description provided for @writingClearFilters.
  ///
  /// In vi, this message translates to:
  /// **'Xóa bộ lọc'**
  String get writingClearFilters;

  /// No description provided for @writingShowMore.
  ///
  /// In vi, this message translates to:
  /// **'Xem thêm'**
  String get writingShowMore;

  /// No description provided for @writingSortLabel.
  ///
  /// In vi, this message translates to:
  /// **'Sắp xếp:'**
  String get writingSortLabel;

  /// No description provided for @writingSortByDate.
  ///
  /// In vi, this message translates to:
  /// **'Ngày'**
  String get writingSortByDate;

  /// No description provided for @writingSortByScore.
  ///
  /// In vi, this message translates to:
  /// **'Điểm'**
  String get writingSortByScore;

  /// No description provided for @writingSubmissionsEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có bài viết nào'**
  String get writingSubmissionsEmptyTitle;

  /// No description provided for @writingSubmissionsEmptyDesc.
  ///
  /// In vi, this message translates to:
  /// **'Chọn đề và bắt đầu luyện viết để thấy lịch sử ở đây.'**
  String get writingSubmissionsEmptyDesc;

  /// No description provided for @writingSubmissionsNoMatch.
  ///
  /// In vi, this message translates to:
  /// **'Không có bài viết khớp bộ lọc.'**
  String get writingSubmissionsNoMatch;

  /// No description provided for @writingCriteriaTrendTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tiêu chí Viết của bạn'**
  String get writingCriteriaTrendTitle;

  /// No description provided for @writingCriteriaTrendSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'TB qua {count} bài đã chấm'**
  String writingCriteriaTrendSubtitle(int count);

  /// No description provided for @writingCriteriaWeakest.
  ///
  /// In vi, this message translates to:
  /// **'cần cải thiện nhất'**
  String get writingCriteriaWeakest;

  /// No description provided for @writingCriterionTaskCompletion.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành đề'**
  String get writingCriterionTaskCompletion;

  /// No description provided for @writingCriterionGrammar.
  ///
  /// In vi, this message translates to:
  /// **'Ngữ pháp'**
  String get writingCriterionGrammar;

  /// No description provided for @writingCriterionVocabulary.
  ///
  /// In vi, this message translates to:
  /// **'Từ vựng'**
  String get writingCriterionVocabulary;

  /// No description provided for @writingCriterionCoherence.
  ///
  /// In vi, this message translates to:
  /// **'Liên kết'**
  String get writingCriterionCoherence;

  /// No description provided for @writingLevelTitle.
  ///
  /// In vi, this message translates to:
  /// **'{label} · Viết'**
  String writingLevelTitle(String label);

  /// No description provided for @writingLevelEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có đề chính thức'**
  String get writingLevelEmptyTitle;

  /// No description provided for @writingLevelEmptyDesc.
  ///
  /// In vi, this message translates to:
  /// **'Đề {label} đang được cập nhật — thử đề cộng đồng bên dưới nhé!'**
  String writingLevelEmptyDesc(String label);

  /// No description provided for @writingLevelCommunitySectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đề cộng đồng'**
  String get writingLevelCommunitySectionTitle;

  /// No description provided for @writingLevelContributeButton.
  ///
  /// In vi, this message translates to:
  /// **'➕ Đóng góp đề'**
  String get writingLevelContributeButton;

  /// No description provided for @writingLevelCommunityEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có đề cộng đồng cho trình độ này.'**
  String get writingLevelCommunityEmpty;

  /// No description provided for @writingLevelNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy trình độ luyện viết này.'**
  String get writingLevelNotFound;

  /// No description provided for @writingLevelLocked.
  ///
  /// In vi, this message translates to:
  /// **'Đề này dành cho tài khoản Premium.'**
  String get writingLevelLocked;

  /// No description provided for @writingCommunityAddVersion.
  ///
  /// In vi, this message translates to:
  /// **'➕ Thêm phiên bản'**
  String get writingCommunityAddVersion;

  /// No description provided for @writingCommunityBackToList.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại danh sách'**
  String get writingCommunityBackToList;

  /// No description provided for @writingCommunityCreateTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đóng góp đề cộng đồng'**
  String get writingCommunityCreateTitle;

  /// No description provided for @writingCommunityNotFoundDesc.
  ///
  /// In vi, this message translates to:
  /// **'Đề có thể đã bị xóa hoặc chưa được công khai.'**
  String get writingCommunityNotFoundDesc;

  /// No description provided for @writingCommunityNotFoundTitle.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy đề này'**
  String get writingCommunityNotFoundTitle;

  /// No description provided for @writingCommunityPointsHint.
  ///
  /// In vi, this message translates to:
  /// **'Mỗi ý một dòng — AI dùng để bám sát yêu cầu đề.'**
  String get writingCommunityPointsHint;

  /// No description provided for @writingCommunityPointsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Các ý cần trả lời'**
  String get writingCommunityPointsTitle;

  /// No description provided for @writingCommunityReportReason.
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo từ người dùng'**
  String get writingCommunityReportReason;

  /// No description provided for @writingCommunityReportSent.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi báo cáo, cảm ơn bạn!'**
  String get writingCommunityReportSent;

  /// No description provided for @writingCommunitySubmit.
  ///
  /// In vi, this message translates to:
  /// **'Đăng đề'**
  String get writingCommunitySubmit;

  /// No description provided for @writingCommunityTaskHint.
  ///
  /// In vi, this message translates to:
  /// **'Dán đề viết của bạn vào đây…'**
  String get writingCommunityTaskHint;

  /// No description provided for @writingCommunityTopicFallbackTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đề cộng đồng'**
  String get writingCommunityTopicFallbackTitle;

  /// No description provided for @writingCommunityVoteError.
  ///
  /// In vi, this message translates to:
  /// **'Có lỗi xảy ra, thử lại sau.'**
  String get writingCommunityVoteError;

  /// No description provided for @writingCustomTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tự nhập đề'**
  String get writingCustomTitle;

  /// No description provided for @writingCustomIntro.
  ///
  /// In vi, this message translates to:
  /// **'Dán đề viết của bạn, chọn kì thi & trình độ, rồi viết bài — AI sẽ chấm và gợi ý như đề có sẵn.'**
  String get writingCustomIntro;

  /// No description provided for @writingCustomExamLabel.
  ///
  /// In vi, this message translates to:
  /// **'Kì thi'**
  String get writingCustomExamLabel;

  /// No description provided for @writingCustomLevelLabel.
  ///
  /// In vi, this message translates to:
  /// **'Trình độ'**
  String get writingCustomLevelLabel;

  /// No description provided for @writingCustomTeilLabel.
  ///
  /// In vi, this message translates to:
  /// **'Teil (tùy chọn)'**
  String get writingCustomTeilLabel;

  /// No description provided for @writingCustomTeilNone.
  ///
  /// In vi, this message translates to:
  /// **'Không'**
  String get writingCustomTeilNone;

  /// No description provided for @writingCustomTaskLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đề bài *'**
  String get writingCustomTaskLabel;

  /// No description provided for @writingCustomTaskHintPolish.
  ///
  /// In vi, this message translates to:
  /// **'Nhập đề tiếng Việt, từ khóa, hoặc đề chưa hoàn chỉnh — AI sẽ dựng thành đề tiếng Đức đầy đủ…'**
  String get writingCustomTaskHintPolish;

  /// No description provided for @writingCustomTaskHintPlain.
  ///
  /// In vi, this message translates to:
  /// **'Dán đề viết bằng tiếng Đức hoàn chỉnh vào đây…'**
  String get writingCustomTaskHintPlain;

  /// No description provided for @writingCustomPointsLabelPolish.
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý / ý chính (tùy chọn)'**
  String get writingCustomPointsLabelPolish;

  /// No description provided for @writingCustomPointsLabelPlain.
  ///
  /// In vi, this message translates to:
  /// **'Các ý cần trả lời (tùy chọn)'**
  String get writingCustomPointsLabelPlain;

  /// No description provided for @writingCustomPointsHint.
  ///
  /// In vi, this message translates to:
  /// **'Mỗi ý một dòng — AI dùng để bám sát yêu cầu đề.'**
  String get writingCustomPointsHint;

  /// No description provided for @writingCustomStartPolish.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thiện & bắt đầu viết'**
  String get writingCustomStartPolish;

  /// No description provided for @writingCustomStartPlain.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu viết'**
  String get writingCustomStartPlain;

  /// No description provided for @writingCustomEditPrompt.
  ///
  /// In vi, this message translates to:
  /// **'← Sửa đề'**
  String get writingCustomEditPrompt;

  /// No description provided for @writingCustomStartedTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đề tự nhập'**
  String get writingCustomStartedTitle;

  /// No description provided for @writingCustomContribute.
  ///
  /// In vi, this message translates to:
  /// **'📤 Đóng góp đề này cho cộng đồng'**
  String get writingCustomContribute;

  /// No description provided for @writingAiPolishTitle.
  ///
  /// In vi, this message translates to:
  /// **'✨ Để AI hoàn thiện đề'**
  String get writingAiPolishTitle;

  /// No description provided for @writingAiPolishDesc.
  ///
  /// In vi, this message translates to:
  /// **'Biến đề tiếng Việt / từ khóa / đề còn thiếu thành đề tiếng Đức chuẩn. Bỏ tích nếu bạn đã có đề đầy đủ.'**
  String get writingAiPolishDesc;

  /// No description provided for @writingAiPolishing.
  ///
  /// In vi, this message translates to:
  /// **'Đang hoàn thiện đề…'**
  String get writingAiPolishing;

  /// No description provided for @writingAiPolishError.
  ///
  /// In vi, this message translates to:
  /// **'AI hoàn thiện đề thất bại. Bỏ tích để dùng đề gốc, hoặc thử lại.'**
  String get writingAiPolishError;

  /// No description provided for @writingSessionGradingTimelineTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử chấm điểm'**
  String get writingSessionGradingTimelineTitle;

  /// No description provided for @writingSessionNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy bài viết này. Bài có thể đã cũ — quay lại lịch sử để xem các bài gần đây.'**
  String get writingSessionNotFound;

  /// No description provided for @writingSessionPracticeAgain.
  ///
  /// In vi, this message translates to:
  /// **'Luyện lại'**
  String get writingSessionPracticeAgain;

  /// No description provided for @writingSessionTitleFallback.
  ///
  /// In vi, this message translates to:
  /// **'Bài viết'**
  String get writingSessionTitleFallback;

  /// No description provided for @writingSessionYourAnswer.
  ///
  /// In vi, this message translates to:
  /// **'Bài viết của bạn'**
  String get writingSessionYourAnswer;

  /// No description provided for @youtubeInvalidUrl.
  ///
  /// In vi, this message translates to:
  /// **'URL YouTube không hợp lệ'**
  String get youtubeInvalidUrl;

  /// No description provided for @youtubeAddVideoError.
  ///
  /// In vi, this message translates to:
  /// **'Không thêm được video, thử lại sau.'**
  String get youtubeAddVideoError;

  /// No description provided for @youtubeDeleteVideoError.
  ///
  /// In vi, this message translates to:
  /// **'Không xoá được video.'**
  String get youtubeDeleteVideoError;

  /// No description provided for @youtubeLoadListError.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được danh sách video.'**
  String get youtubeLoadListError;

  /// No description provided for @youtubeEmptyState.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có video nào. Dán URL YouTube ở trên để bắt đầu.'**
  String get youtubeEmptyState;

  /// No description provided for @youtubeUntitledVideo.
  ///
  /// In vi, this message translates to:
  /// **'Video chưa có tiêu đề'**
  String get youtubeUntitledVideo;

  /// No description provided for @youtubeWatchCount.
  ///
  /// In vi, this message translates to:
  /// **'Đã xem ×{count}'**
  String youtubeWatchCount(int count);

  /// No description provided for @youtubeContinueWatching.
  ///
  /// In vi, this message translates to:
  /// **'Xem tiếp'**
  String get youtubeContinueWatching;

  /// No description provided for @youtubePopularVideos.
  ///
  /// In vi, this message translates to:
  /// **'Video phổ biến'**
  String get youtubePopularVideos;

  /// No description provided for @youtubePasteUrlHint.
  ///
  /// In vi, this message translates to:
  /// **'Dán URL YouTube...'**
  String get youtubePasteUrlHint;

  /// No description provided for @youtubeRewatchMarked.
  ///
  /// In vi, this message translates to:
  /// **'Đã ghi nhận xem lại'**
  String get youtubeRewatchMarked;

  /// No description provided for @youtubeCompleteMarked.
  ///
  /// In vi, this message translates to:
  /// **'Đã đánh dấu hoàn thành'**
  String get youtubeCompleteMarked;

  /// No description provided for @youtubeSaveProgressError.
  ///
  /// In vi, this message translates to:
  /// **'Không lưu được tiến độ, thử lại sau.'**
  String get youtubeSaveProgressError;

  /// No description provided for @youtubeRewatchButton.
  ///
  /// In vi, this message translates to:
  /// **'Xem lại'**
  String get youtubeRewatchButton;

  /// No description provided for @youtubeCompleteButton.
  ///
  /// In vi, this message translates to:
  /// **'Đã hoàn thành'**
  String get youtubeCompleteButton;

  /// No description provided for @youtubePracticeShadowing.
  ///
  /// In vi, this message translates to:
  /// **'Shadowing'**
  String get youtubePracticeShadowing;

  /// No description provided for @youtubeTranscriptLabel.
  ///
  /// In vi, this message translates to:
  /// **'Transcript'**
  String get youtubeTranscriptLabel;

  /// No description provided for @youtubeNotesLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ghi chú'**
  String get youtubeNotesLabel;

  /// No description provided for @youtubeDictationShowVideoTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Hiện video'**
  String get youtubeDictationShowVideoTooltip;

  /// No description provided for @youtubeDictationAudioOnlyTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ nghe'**
  String get youtubeDictationAudioOnlyTooltip;

  /// No description provided for @youtubeTranscriptLoadError.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được transcript.'**
  String get youtubeTranscriptLoadError;

  /// No description provided for @youtubeDictationNoTranscript.
  ///
  /// In vi, this message translates to:
  /// **'Video này chưa có transcript để luyện chính tả.'**
  String get youtubeDictationNoTranscript;

  /// No description provided for @shadowingScreenTitle.
  ///
  /// In vi, this message translates to:
  /// **'Shadowing — Luyện phát âm'**
  String get shadowingScreenTitle;

  /// No description provided for @shadowingHideVideoTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Ẩn video (vẫn nghe tiếng)'**
  String get shadowingHideVideoTooltip;

  /// No description provided for @shadowingNoTranscript.
  ///
  /// In vi, this message translates to:
  /// **'Video này chưa có transcript để luyện shadowing.'**
  String get shadowingNoTranscript;

  /// No description provided for @shadowingSentenceProgress.
  ///
  /// In vi, this message translates to:
  /// **'Câu {index}/{total}'**
  String shadowingSentenceProgress(int index, int total);

  /// No description provided for @shadowingListenAgain.
  ///
  /// In vi, this message translates to:
  /// **'Nghe lại'**
  String get shadowingListenAgain;

  /// No description provided for @shadowingRecordTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Ghi âm'**
  String get shadowingRecordTooltip;

  /// No description provided for @shadowingRecordComingSoonTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Ghi âm sắp ra mắt'**
  String get shadowingRecordComingSoonTooltip;

  /// No description provided for @shadowingRecordComingSoonHint.
  ///
  /// In vi, this message translates to:
  /// **'Ghi âm + chấm phát âm AI sắp ra mắt — theo dõi bản cập nhật tiếp theo.'**
  String get shadowingRecordComingSoonHint;

  /// No description provided for @youtubeDictationProgress.
  ///
  /// In vi, this message translates to:
  /// **'Câu {index}/{total} · Đúng {correct}'**
  String youtubeDictationProgress(int index, int total, int correct);

  /// No description provided for @youtubeDictationSentenceHint.
  ///
  /// In vi, this message translates to:
  /// **'Gõ cả câu...'**
  String get youtubeDictationSentenceHint;

  /// No description provided for @youtubeDictationClozeHint.
  ///
  /// In vi, this message translates to:
  /// **'Điền từ khuyết...'**
  String get youtubeDictationClozeHint;

  /// No description provided for @youtubeDictationAnswerLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đáp án:'**
  String get youtubeDictationAnswerLabel;

  /// No description provided for @youtubeDictationRetryButton.
  ///
  /// In vi, this message translates to:
  /// **'↻ Thử lại'**
  String get youtubeDictationRetryButton;

  /// No description provided for @youtubeDictationNextButton.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp →'**
  String get youtubeDictationNextButton;

  /// No description provided for @youtubeDictationCompleteTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành!'**
  String get youtubeDictationCompleteTitle;

  /// No description provided for @youtubeDictationCompleteSummary.
  ///
  /// In vi, this message translates to:
  /// **'Đúng {correct}/{total} câu · Bỏ qua {skipped}'**
  String youtubeDictationCompleteSummary(int correct, int total, int skipped);

  /// No description provided for @youtubeDictationRestartButton.
  ///
  /// In vi, this message translates to:
  /// **'Làm lại'**
  String get youtubeDictationRestartButton;

  /// No description provided for @youtubeDictationModeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chế độ'**
  String get youtubeDictationModeLabel;

  /// No description provided for @youtubeDictationModeSentence.
  ///
  /// In vi, this message translates to:
  /// **'Cả câu'**
  String get youtubeDictationModeSentence;

  /// No description provided for @youtubeDictationModeCloze.
  ///
  /// In vi, this message translates to:
  /// **'Điền từ khuyết'**
  String get youtubeDictationModeCloze;

  /// No description provided for @youtubeDictationAlwaysShowVietnamese.
  ///
  /// In vi, this message translates to:
  /// **'Luôn hiện nghĩa tiếng Việt'**
  String get youtubeDictationAlwaysShowVietnamese;

  /// No description provided for @writingSprintTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sprint Anki'**
  String get writingSprintTitle;

  /// No description provided for @writingSprintSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Goethe B1 Viết — ôn đề bằng lặp lại ngắt quãng (spaced repetition)'**
  String get writingSprintSubtitle;

  /// No description provided for @writingSprintModePickerLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chọn chế độ'**
  String get writingSprintModePickerLabel;

  /// No description provided for @writingSprintModeMarathonTitle.
  ///
  /// In vi, this message translates to:
  /// **'Marathon'**
  String get writingSprintModeMarathonTitle;

  /// No description provided for @writingSprintModeMarathonSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'1 session 10 giờ'**
  String get writingSprintModeMarathonSubtitle;

  /// No description provided for @writingSprintModeMarathonDetail.
  ///
  /// In vi, this message translates to:
  /// **'Lặp lại nhanh: 1 phút · 10 phút · 30 phút · 2 giờ. Ôn hết đề trong 1 buổi.'**
  String get writingSprintModeMarathonDetail;

  /// No description provided for @writingSprintModeDailyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hằng ngày'**
  String get writingSprintModeDailyTitle;

  /// No description provided for @writingSprintModeDailySubtitle.
  ///
  /// In vi, this message translates to:
  /// **'SM-2 nhiều ngày'**
  String get writingSprintModeDailySubtitle;

  /// No description provided for @writingSprintModeDailyDetail.
  ///
  /// In vi, this message translates to:
  /// **'Thuật toán Anki: khoảng 1 ngày · 2.5 ngày · 4 ngày. Vài phút/ngày, nhớ lâu hơn.'**
  String get writingSprintModeDailyDetail;

  /// No description provided for @writingSprintModeSelected.
  ///
  /// In vi, this message translates to:
  /// **'Đã chọn'**
  String get writingSprintModeSelected;

  /// No description provided for @writingSprintResumeButton.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục session cũ'**
  String get writingSprintResumeButton;

  /// No description provided for @writingSprintStartFreshButton.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu mới (xoá session cũ)'**
  String get writingSprintStartFreshButton;

  /// No description provided for @writingSprintStartButton.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu — {count} đề'**
  String writingSprintStartButton(int count);

  /// No description provided for @writingSprintMockCta.
  ///
  /// In vi, this message translates to:
  /// **'Thi thử 3 đề ngay'**
  String get writingSprintMockCta;

  /// No description provided for @writingSprintCheatsheetCta.
  ///
  /// In vi, this message translates to:
  /// **'Cheatsheet Redemittel'**
  String get writingSprintCheatsheetCta;

  /// No description provided for @writingSprintCardCounter.
  ///
  /// In vi, this message translates to:
  /// **'Teil {teil} · Card {num}/{total}'**
  String writingSprintCardCounter(int teil, int num, int total);

  /// No description provided for @writingSprintRequirementsLabel.
  ///
  /// In vi, this message translates to:
  /// **'YÊU CẦU'**
  String get writingSprintRequirementsLabel;

  /// No description provided for @writingSprintOutlineLabel.
  ///
  /// In vi, this message translates to:
  /// **'Outline {index} (DE)'**
  String writingSprintOutlineLabel(int index);

  /// No description provided for @writingSprintOutlineHint.
  ///
  /// In vi, this message translates to:
  /// **'Bạn sẽ viết gì cho ý {index}?'**
  String writingSprintOutlineHint(int index);

  /// No description provided for @writingSprintSkipButton.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ qua'**
  String get writingSprintSkipButton;

  /// No description provided for @writingSprintCheckButton.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra'**
  String get writingSprintCheckButton;

  /// No description provided for @writingSprintMatchGood.
  ///
  /// In vi, this message translates to:
  /// **'Tốt! Bạn nhớ phần lớn nội dung.'**
  String get writingSprintMatchGood;

  /// No description provided for @writingSprintMatchWeak.
  ///
  /// In vi, this message translates to:
  /// **'Cần ôn lại — chọn Again hoặc Hard.'**
  String get writingSprintMatchWeak;

  /// No description provided for @writingSprintOutlineAnswerLabel.
  ///
  /// In vi, this message translates to:
  /// **'ĐÁP ÁN OUTLINE'**
  String get writingSprintOutlineAnswerLabel;

  /// No description provided for @writingSprintOutlineMissing.
  ///
  /// In vi, this message translates to:
  /// **'(outline {index} chưa có)'**
  String writingSprintOutlineMissing(int index);

  /// No description provided for @writingSprintYouWrote.
  ///
  /// In vi, this message translates to:
  /// **'Bạn viết: {text}'**
  String writingSprintYouWrote(String text);

  /// No description provided for @writingSprintMiniModelToggle.
  ///
  /// In vi, this message translates to:
  /// **'Xem mini-model'**
  String get writingSprintMiniModelToggle;

  /// No description provided for @writingSprintRedemittelLabel.
  ///
  /// In vi, this message translates to:
  /// **'REDEMITTEL'**
  String get writingSprintRedemittelLabel;

  /// No description provided for @writingSprintSessionDoneTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả đã ôn xong!'**
  String get writingSprintSessionDoneTitle;

  /// No description provided for @writingSprintSessionDoneBody.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã ôn {count} đề trong session này.'**
  String writingSprintSessionDoneBody(int count);

  /// No description provided for @writingSprintBackToSprint.
  ///
  /// In vi, this message translates to:
  /// **'Về Sprint'**
  String get writingSprintBackToSprint;

  /// No description provided for @writingSprintTaskLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đề — Teil {teil}'**
  String writingSprintTaskLabel(int teil);

  /// No description provided for @writingSprintEssayHint.
  ///
  /// In vi, this message translates to:
  /// **'Viết bài của bạn ở đây...'**
  String get writingSprintEssayHint;

  /// No description provided for @writingSprintWordCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} từ (mục tiêu: {min}–{max})'**
  String writingSprintWordCount(int count, int min, int max);

  /// No description provided for @writingSprintSubmitButton.
  ///
  /// In vi, this message translates to:
  /// **'Nộp bài ({count} từ)'**
  String writingSprintSubmitButton(int count);

  /// No description provided for @writingSprintGrading.
  ///
  /// In vi, this message translates to:
  /// **'Đang chấm...'**
  String get writingSprintGrading;

  /// No description provided for @writingSprintWordsNeeded.
  ///
  /// In vi, this message translates to:
  /// **'Cần thêm {count} từ nữa'**
  String writingSprintWordsNeeded(int count);

  /// No description provided for @writingSprintNoMockTopics.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm được đề phù hợp.'**
  String get writingSprintNoMockTopics;

  /// No description provided for @writingSprintMockAverageLabel.
  ///
  /// In vi, this message translates to:
  /// **'Điểm trung bình 3 bài'**
  String get writingSprintMockAverageLabel;

  /// No description provided for @writingSprintTeilTopicLabel.
  ///
  /// In vi, this message translates to:
  /// **'Teil {teil} — {title}'**
  String writingSprintTeilTopicLabel(int teil, String title);

  /// No description provided for @writingSprintNextEssay.
  ///
  /// In vi, this message translates to:
  /// **'Bài tiếp theo →'**
  String get writingSprintNextEssay;

  /// No description provided for @writingSprintGradingLong.
  ///
  /// In vi, this message translates to:
  /// **'AI đang chấm bài... (~5-10 giây)'**
  String get writingSprintGradingLong;

  /// No description provided for @writingSprintTeilLabel.
  ///
  /// In vi, this message translates to:
  /// **'Teil {teil}'**
  String writingSprintTeilLabel(int teil);

  /// No description provided for @writingSprintErrorsToFixLabel.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi cần sửa'**
  String get writingSprintErrorsToFixLabel;

  /// No description provided for @writingSprintErrorWrongLabel.
  ///
  /// In vi, this message translates to:
  /// **'Sai'**
  String get writingSprintErrorWrongLabel;

  /// No description provided for @writingSprintErrorFixLabel.
  ///
  /// In vi, this message translates to:
  /// **'Sửa'**
  String get writingSprintErrorFixLabel;

  /// No description provided for @writingSprintShowEssay.
  ///
  /// In vi, this message translates to:
  /// **'Xem bài viết'**
  String get writingSprintShowEssay;

  /// No description provided for @writingSprintHideEssay.
  ///
  /// In vi, this message translates to:
  /// **'Ẩn bài viết'**
  String get writingSprintHideEssay;

  /// No description provided for @writingSprintRegradeButton.
  ///
  /// In vi, this message translates to:
  /// **'Chấm lại?'**
  String get writingSprintRegradeButton;

  /// No description provided for @writingSprintCheatsheetTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cheatsheet Goethe B1 Viết'**
  String get writingSprintCheatsheetTitle;

  /// No description provided for @writingSprintCheatsheetSummary.
  ///
  /// In vi, this message translates to:
  /// **'{topics} đề · {clusters} clusters'**
  String writingSprintCheatsheetSummary(int topics, int clusters);

  /// No description provided for @writingSprintCheatsheetOverviewTitle.
  ///
  /// In vi, this message translates to:
  /// **'Toàn cảnh — {count} Clusters'**
  String writingSprintCheatsheetOverviewTitle(int count);

  /// No description provided for @writingSprintCheatsheetTopicCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} đề'**
  String writingSprintCheatsheetTopicCount(int count);

  /// No description provided for @writingSprintCheatsheetTeilTitle.
  ///
  /// In vi, this message translates to:
  /// **'Teil {teil} — {count} đề'**
  String writingSprintCheatsheetTeilTitle(int teil, int count);

  /// No description provided for @writingSprintCheatsheetRedemittelTitle.
  ///
  /// In vi, this message translates to:
  /// **'Top Redemittel theo chức năng'**
  String get writingSprintCheatsheetRedemittelTitle;

  /// No description provided for @writingSprintCheatsheetMistakesTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi thường gặp B1'**
  String get writingSprintCheatsheetMistakesTitle;

  /// No description provided for @writingSprintCheatsheetVerbKasusTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quick Reference — Verb+Kasus'**
  String get writingSprintCheatsheetVerbKasusTitle;

  /// No description provided for @readingTabLabel.
  ///
  /// In vi, this message translates to:
  /// **'Truyện'**
  String get readingTabLabel;

  /// No description provided for @newsTabLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tin tức'**
  String get newsTabLabel;

  /// No description provided for @readingHubTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đọc truyện'**
  String get readingHubTitle;

  /// No description provided for @readingHubTitleLevel.
  ///
  /// In vi, this message translates to:
  /// **'Đọc truyện {level}'**
  String readingHubTitleLevel(String level);

  /// No description provided for @readingHubSubtitleHome.
  ///
  /// In vi, this message translates to:
  /// **'Truyện song ngữ Đức–Việt theo cấp độ · có audio · A1–C2'**
  String get readingHubSubtitleHome;

  /// No description provided for @readingHubSubtitleLevel.
  ///
  /// In vi, this message translates to:
  /// **'Chọn bài · hoàn thành bài tập (≥60%) để đánh dấu xong'**
  String get readingHubSubtitleLevel;

  /// No description provided for @readingLevelCardEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có bài đọc'**
  String get readingLevelCardEmpty;

  /// No description provided for @readingLevelCardAllDone.
  ///
  /// In vi, this message translates to:
  /// **'🎉 Hoàn thành rồi!'**
  String get readingLevelCardAllDone;

  /// No description provided for @readingViewAllArrow.
  ///
  /// In vi, this message translates to:
  /// **'Xem tất cả →'**
  String get readingViewAllArrow;

  /// No description provided for @readingSearchHintInLevel.
  ///
  /// In vi, this message translates to:
  /// **'Tìm bài đọc trong {level}...'**
  String readingSearchHintInLevel(String level);

  /// No description provided for @readingCompletedCountOfTotal.
  ///
  /// In vi, this message translates to:
  /// **'{completed}/{total} bài đã hoàn thành'**
  String readingCompletedCountOfTotal(int completed, int total);

  /// No description provided for @readingSearchEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy bài nào'**
  String get readingSearchEmpty;

  /// No description provided for @readingDoneChip.
  ///
  /// In vi, this message translates to:
  /// **'Đã đọc'**
  String get readingDoneChip;

  /// No description provided for @readingShowTranslation.
  ///
  /// In vi, this message translates to:
  /// **'Hiện bản dịch'**
  String get readingShowTranslation;

  /// No description provided for @readingTapWordHint.
  ///
  /// In vi, this message translates to:
  /// **'Chạm vào từ bất kỳ để tra nghĩa.'**
  String get readingTapWordHint;

  /// No description provided for @readingSaveProgressError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể lưu tiến độ, thử lại sau.'**
  String get readingSaveProgressError;

  /// No description provided for @readingGlossaryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Từ vựng & giải thích'**
  String get readingGlossaryTitle;

  /// No description provided for @readingMarkComplete.
  ///
  /// In vi, this message translates to:
  /// **'Đánh dấu đã đọc'**
  String get readingMarkComplete;

  /// No description provided for @readingFeedAppBarTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đọc vừa sức'**
  String get readingFeedAppBarTitle;

  /// No description provided for @readingFeedEmptyReady.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có bài đọc phù hợp trình độ của bạn lúc này.'**
  String get readingFeedEmptyReady;

  /// No description provided for @readingFeedEmptyNotReady.
  ///
  /// In vi, this message translates to:
  /// **'Đang chuẩn bị kho bài đọc — vui lòng quay lại sau ít phút.'**
  String get readingFeedEmptyNotReady;

  /// No description provided for @readingFeedSaveVocabHint.
  ///
  /// In vi, this message translates to:
  /// **'Lưu thêm từ vựng để hệ thống cá nhân hóa gợi ý bài đọc cho bạn.'**
  String get readingFeedSaveVocabHint;

  /// No description provided for @readingFeedVocabSummary.
  ///
  /// In vi, this message translates to:
  /// **'{vocabNew} từ mới · Đã biết {coveragePct}% từ khó'**
  String readingFeedVocabSummary(int vocabNew, int coveragePct);

  /// No description provided for @readListenTabRead.
  ///
  /// In vi, this message translates to:
  /// **'Đọc'**
  String get readListenTabRead;

  /// No description provided for @readingLeaderboardProgressTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tiến trình {level}'**
  String readingLeaderboardProgressTitle(String level);

  /// No description provided for @readingLeaderboardTitleLevel.
  ///
  /// In vi, this message translates to:
  /// **'Bảng xếp hạng {level}'**
  String readingLeaderboardTitleLevel(String level);

  /// No description provided for @readingLeaderboardSubtitleLevel.
  ///
  /// In vi, this message translates to:
  /// **'Số bài {level} đã hoàn thành'**
  String readingLeaderboardSubtitleLevel(String level);

  /// No description provided for @readingYourRankPrefix.
  ///
  /// In vi, this message translates to:
  /// **'Hạng của bạn: '**
  String get readingYourRankPrefix;

  /// No description provided for @readingYourRankSuffix.
  ///
  /// In vi, this message translates to:
  /// **' · {count} bài'**
  String readingYourRankSuffix(int count);

  /// No description provided for @newsHeaderTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tin tức Đức'**
  String get newsHeaderTitle;

  /// No description provided for @newsHeaderSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Đọc tin tức bằng tiếng Đức theo cấp độ A1–B2 · có audio · từ vựng · bài tập'**
  String get newsHeaderSubtitle;

  /// No description provided for @newsFilterLevelLabel.
  ///
  /// In vi, this message translates to:
  /// **'Trình độ:'**
  String get newsFilterLevelLabel;

  /// No description provided for @newsFilterTopicLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chủ đề:'**
  String get newsFilterTopicLabel;

  /// No description provided for @newsPaginationInfo.
  ///
  /// In vi, this message translates to:
  /// **'Trang {page}/{total}'**
  String newsPaginationInfo(int page, int total);

  /// No description provided for @newsPaginationNext.
  ///
  /// In vi, this message translates to:
  /// **'Sau'**
  String get newsPaginationNext;

  /// No description provided for @newsEmptyFiltered.
  ///
  /// In vi, this message translates to:
  /// **'Không có bài nào phù hợp bộ lọc.'**
  String get newsEmptyFiltered;

  /// No description provided for @newsEmptyNone.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có tin tức.'**
  String get newsEmptyNone;

  /// No description provided for @newsChooseLevelLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chọn trình độ đọc'**
  String get newsChooseLevelLabel;

  /// No description provided for @newsOtherLevelsPrefix.
  ///
  /// In vi, this message translates to:
  /// **'💡 Bạn có thể đọc bài này ở trình độ khác: '**
  String get newsOtherLevelsPrefix;

  /// No description provided for @newsListenFullStory.
  ///
  /// In vi, this message translates to:
  /// **'Nghe toàn bài'**
  String get newsListenFullStory;

  /// No description provided for @newsAudioSpeedSlow.
  ///
  /// In vi, this message translates to:
  /// **'Chậm'**
  String get newsAudioSpeedSlow;

  /// No description provided for @newsAudioSpeedNormal.
  ///
  /// In vi, this message translates to:
  /// **'Thường'**
  String get newsAudioSpeedNormal;

  /// No description provided for @newsVocabTitle.
  ///
  /// In vi, this message translates to:
  /// **'Từ vựng'**
  String get newsVocabTitle;

  /// No description provided for @newsHasAudioLabel.
  ///
  /// In vi, this message translates to:
  /// **'Có audio'**
  String get newsHasAudioLabel;

  /// No description provided for @newsLeaderboardTitleWeekly.
  ///
  /// In vi, this message translates to:
  /// **'Bảng xếp hạng tuần'**
  String get newsLeaderboardTitleWeekly;

  /// No description provided for @newsLeaderboardSubtitleWeekly.
  ///
  /// In vi, this message translates to:
  /// **'Số bài tin tức hoàn thành trong tuần này'**
  String get newsLeaderboardSubtitleWeekly;

  /// No description provided for @newsLeaderboardEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có ai hoàn thành bài nào tuần này'**
  String get newsLeaderboardEmpty;

  /// No description provided for @newsQuizTitle.
  ///
  /// In vi, this message translates to:
  /// **'Câu hỏi kiểm tra'**
  String get newsQuizTitle;

  /// No description provided for @newsQuizSubmit.
  ///
  /// In vi, this message translates to:
  /// **'Nộp bài'**
  String get newsQuizSubmit;

  /// No description provided for @newsQuizResult.
  ///
  /// In vi, this message translates to:
  /// **'Kết quả: {correct}/{total} câu đúng ({percent}%)'**
  String newsQuizResult(int correct, int total, int percent);

  /// No description provided for @newsQuizPassedSuffix.
  ///
  /// In vi, this message translates to:
  /// **' — Đã lưu tiến độ ✅'**
  String get newsQuizPassedSuffix;

  /// No description provided for @saveWordsCtaDone.
  ///
  /// In vi, this message translates to:
  /// **'✓ Đã thêm — sẽ xuất hiện trong Ôn tập'**
  String get saveWordsCtaDone;

  /// No description provided for @saveWordsCtaSave.
  ///
  /// In vi, this message translates to:
  /// **'📥 Lưu {count} từ mới vào Kho ôn'**
  String saveWordsCtaSave(int count);

  /// No description provided for @saveWordsCtaResolvedCount.
  ///
  /// In vi, this message translates to:
  /// **'{resolvable}/{total} từ có trong hệ thống'**
  String saveWordsCtaResolvedCount(int resolvable, int total);

  /// No description provided for @saveWordsCtaError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể lưu từ vựng, thử lại sau.'**
  String get saveWordsCtaError;

  /// No description provided for @newsStoryNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy tin tức.'**
  String get newsStoryNotFound;

  /// No description provided for @yesterday.
  ///
  /// In vi, this message translates to:
  /// **'Hôm qua'**
  String get yesterday;

  /// No description provided for @newsWeeklyRingProgress.
  ///
  /// In vi, this message translates to:
  /// **'Tuần này bạn đã đọc {done}/{total} bài mới xuất bản'**
  String newsWeeklyRingProgress(int done, int total);

  /// No description provided for @newsWeeklyRingEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có bài mới xuất bản tuần này'**
  String get newsWeeklyRingEmpty;

  /// No description provided for @readingListenFullStory.
  ///
  /// In vi, this message translates to:
  /// **'Nghe toàn bài'**
  String get readingListenFullStory;

  /// No description provided for @readingAudioSpeedTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Tốc độ'**
  String get readingAudioSpeedTooltip;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
