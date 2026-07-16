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
  /// **'Đã hoàn thành'**
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

  /// No description provided for @grammarArticles.
  ///
  /// In vi, this message translates to:
  /// **'Bài đọc thêm'**
  String get grammarArticles;

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

  /// No description provided for @topicExploreTitle.
  ///
  /// In vi, this message translates to:
  /// **'Khám phá theo chủ đề'**
  String get topicExploreTitle;

  /// No description provided for @topicExploreEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có chủ đề nào.'**
  String get topicExploreEmpty;

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
  /// **'Từ trong phụ đề'**
  String get subtitleWordsTitle;

  /// No description provided for @subtitleWordsEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có từ mới nào từ phụ đề. Xem video có phụ đề để gom từ tại đây.'**
  String get subtitleWordsEmpty;

  /// No description provided for @subtitleWordsSeenCount.
  ///
  /// In vi, this message translates to:
  /// **'gặp {count} lần'**
  String subtitleWordsSeenCount(int count);

  /// No description provided for @subtitleWordsAddSelected.
  ///
  /// In vi, this message translates to:
  /// **'Thêm {count} vào ôn tập'**
  String subtitleWordsAddSelected(int count);

  /// No description provided for @subtitleWordsAddedCount.
  ///
  /// In vi, this message translates to:
  /// **'Đã thêm {count} từ vào hàng đợi ôn tập'**
  String subtitleWordsAddedCount(int count);

  /// No description provided for @subtitleWordsAddFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể lưu các từ đã chọn. Vui lòng thử lại.'**
  String get subtitleWordsAddFailed;

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
