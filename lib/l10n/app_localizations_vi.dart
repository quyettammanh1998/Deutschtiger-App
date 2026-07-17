// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'DeutschTiger';

  @override
  String get settings => 'Cài đặt';

  @override
  String get profile => 'Hồ sơ';

  @override
  String get messages => 'Tin nhắn';

  @override
  String get editProfile => 'Sửa hồ sơ';

  @override
  String get couldNotLoadProfile => 'Không tải được hồ sơ.';

  @override
  String get home => 'Trang chủ';

  @override
  String get learner => 'Học viên';

  @override
  String get couldNotLoadHome => 'Không thể tải trang chủ. Vui lòng thử lại.';

  @override
  String get couldNotLoadData => 'Không tải được dữ liệu. Vui lòng thử lại.';

  @override
  String get mission => 'Nhiệm vụ';

  @override
  String get searchVocabulary => 'Tìm từ vựng tiếng Đức...';

  @override
  String get todayMissions => 'Nhiệm vụ hôm nay';

  @override
  String get seeAll => 'Xem tất cả';

  @override
  String get noBonusMissions => 'Chưa có nhiệm vụ thưởng hôm nay.';

  @override
  String get dailyMissionsHeading => '🎁 Nhiệm vụ thưởng';

  @override
  String get todaySession => 'Phiên hôm nay';

  @override
  String get dueWords => 'Từ đến hạn';

  @override
  String get goodMorning => 'Chào buổi sáng';

  @override
  String get goodNoon => 'Chào buổi trưa';

  @override
  String get goodAfternoon => 'Chào buổi chiều';

  @override
  String get goodEvening => 'Chào buổi tối';

  @override
  String get headerEncouragement => 'Sẵn sàng chinh phục tiếng Đức? 🚀';

  @override
  String headerWordsLearned(int count) {
    return '📚 Đã học $count từ vựng';
  }

  @override
  String get headerStreakStart => 'Bắt đầu';

  @override
  String get todayXp => 'XP hôm nay';

  @override
  String get streak => 'Chuỗi ngày';

  @override
  String streakDays(int count) {
    return '$count ngày';
  }

  @override
  String get zeroMinutes => '0 phút';

  @override
  String minutesShort(int count) {
    return '$count phút';
  }

  @override
  String hoursShort(int count) {
    return '$count giờ';
  }

  @override
  String hoursMinutesShort(int hours, int minutes) {
    return '$hours giờ $minutes phút';
  }

  @override
  String get wordsLearned => 'Số từ đã học';

  @override
  String get lookupCount => 'Số lượt tra';

  @override
  String get today => 'Hôm nay';

  @override
  String get viewDetails => 'Xem chi tiết';

  @override
  String get weeklyLeaderboard => '🏆 Tuần này';

  @override
  String get seeFull => 'Xem đầy đủ →';

  @override
  String get learnMoreToRank => 'Học thêm hôm nay để leo hạng nhé! 🔥';

  @override
  String get weeklyLeaderboardInTop3 =>
      'Bạn đang trong top 3 — giữ phong độ nhé! 🎉';

  @override
  String get user => 'Người dùng';

  @override
  String get noWeeklyLeaderboard => 'Chưa có ai trên bảng tuần này.';

  @override
  String get noWeeklyLeaderboardSubtitle =>
      'Học hôm nay để trở thành người đầu tiên! 🔥';

  @override
  String get qaTabExam => '🎓 Luyện thi';

  @override
  String get qaTabVocab => 'Từ vựng & Ôn tập';

  @override
  String get qaTabListen => 'Nghe & Xem';

  @override
  String get qaTabAi => 'Viết & Nói (AI)';

  @override
  String get qaTabOther => 'Khác';

  @override
  String get qaTabAll => 'Tất cả →';

  @override
  String get qaExamTitle => 'Luyện thi';

  @override
  String get qaExamSubtitle => 'Goethe, telc';

  @override
  String get qaVocabTitle => 'Kho từ vựng';

  @override
  String qaVocabSubtitle(int count) {
    return '$count+ từ';
  }

  @override
  String get qaNotesTitle => 'Sổ tay';

  @override
  String get qaNotesSubtitle => 'Từ bạn đã lưu';

  @override
  String get qaReviewTitle => 'Ôn tập';

  @override
  String get qaReviewSubtitle => 'Từ đến hạn ôn';

  @override
  String get qaYoutubeTitle => 'YouTube';

  @override
  String get qaYoutubeSubtitle => 'Video song ngữ';

  @override
  String get qaListenTitle => 'Nghe';

  @override
  String get qaListenSubtitle => 'Luyện nghe với video';

  @override
  String get qaNewsTitle => 'Tin tức';

  @override
  String get qaNewsSubtitle => 'Tin Đức A1–B2';

  @override
  String get qaSentenceAiTitle => 'Viết câu (AI)';

  @override
  String get qaSentenceAiSubtitle => 'Ghép & viết câu, AI chấm';

  @override
  String get qaAiTutorTitle => 'AI Tutor';

  @override
  String get qaAiTutorSubtitle => 'Trò chuyện cùng AI';

  @override
  String get qaGamesTitle => 'Trò chơi';

  @override
  String get qaGamesSubtitle => 'Học qua game, có XP';

  @override
  String get qaAffiliateTitle => 'Giới thiệu';

  @override
  String get qaAffiliateSubtitle => 'Nhận hoa hồng';

  @override
  String get dailyPathHeroTitle => '☀️ Hôm nay học gì tiếp?';

  @override
  String dailyPathExamBadge(int days, String examLabel) {
    return 'Còn $days ngày đến thi $examLabel';
  }

  @override
  String dailyPathPlanSummary(int done, int total) {
    return 'Kế hoạch hôm nay · $done/$total bước';
  }

  @override
  String dailyPathMinutesRemaining(int minutes) {
    return 'còn ~$minutes phút';
  }

  @override
  String dailyPathNextStep(int minutes) {
    return 'Bước tiếp theo · ~$minutes phút';
  }

  @override
  String get dailyPathCompleteCelebration => '🎉 Xong lộ trình hôm nay!';

  @override
  String dailyPathCompleteCelebrationWithStreak(int count) {
    return '🎉 Xong lộ trình hôm nay! Giữ streak 🔥$count nhé.';
  }

  @override
  String get dailyPathEmptyTitle => 'Bắt đầu lộ trình học hôm nay';

  @override
  String get dailyPathEmptyDescription =>
      'Vài phút mỗi ngày để giữ streak và tiến bộ đều đặn.';

  @override
  String get dailyPathEmptyCta => 'Bắt đầu học';

  @override
  String get learnMore => 'Học thêm';

  @override
  String get start => 'Bắt đầu';

  @override
  String get couldNotCompleteAuth =>
      'Không thể hoàn tất đăng nhập. Vui lòng thử lại.';

  @override
  String get signUpSuccess => 'Đăng ký thành công! Kiểm tra email để xác nhận.';

  @override
  String get welcomeLearnGerman => 'Học tiếng Đức';

  @override
  String get welcomeEveryDayWith => 'mỗi ngày cùng ';

  @override
  String get welcomeDescription =>
      'Ứng dụng học tiếng Đức cho người Việt — ôn từ vựng, nhiệm vụ hằng ngày và luyện đọc, viết, phỏng vấn.';

  @override
  String get smartVocabularyReview => 'Ôn từ vựng thông minh';

  @override
  String get smartVocabularyReviewDescription =>
      'Flashcard lặp lại đúng lúc bạn sắp quên.';

  @override
  String get dailyMissionsAndStreak => 'Nhiệm vụ & chuỗi ngày học';

  @override
  String get dailyMissionsAndStreakDescription =>
      'Mục tiêu mỗi ngày, giữ streak đều đặn.';

  @override
  String get trackProgress => 'Theo dõi tiến độ';

  @override
  String get trackProgressDescription => 'XP, cấp độ và số phút học mỗi ngày.';

  @override
  String get startLearning => 'Bắt đầu học';

  @override
  String get alreadyHaveAccount => 'Đã có tài khoản?';

  @override
  String get logIn => 'Đăng nhập';

  @override
  String get loginToContinue => 'Đăng nhập để tiếp tục học';

  @override
  String get continueWithGoogle => 'Tiếp tục với Google';

  @override
  String get continueWithApple => 'Tiếp tục với Apple';

  @override
  String get or => 'hoặc';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mật khẩu';

  @override
  String get enterPassword => 'Nhập mật khẩu';

  @override
  String get forgotPassword => 'Quên mật khẩu?';

  @override
  String get dontHaveAccount => 'Chưa có tài khoản?';

  @override
  String get signUp => 'Đăng ký';

  @override
  String get createNewAccount => 'Tạo tài khoản mới';

  @override
  String get displayName => 'Tên hiển thị';

  @override
  String get yourName => 'Tên của bạn';

  @override
  String get atLeastSixCharacters => 'Ít nhất 6 ký tự';

  @override
  String get atLeastEightCharacters => 'Ít nhất 8 ký tự';

  @override
  String get createAccount => 'Tạo tài khoản';

  @override
  String get signUpWithGoogle => 'Đăng ký với Google';

  @override
  String get signUpWithApple => 'Đăng ký với Apple';

  @override
  String get passwordRecovery => 'Khôi phục mật khẩu';

  @override
  String get passwordRecoveryDescription =>
      'Nhập email đã đăng ký, chúng tôi sẽ gửi liên kết khôi phục.';

  @override
  String get passwordRecoverySent =>
      'Đã gửi email khôi phục. Vui lòng kiểm tra hộp thư.';

  @override
  String get sendRecoveryEmail => 'Gửi email khôi phục';

  @override
  String get backToLogin => 'Quay lại đăng nhập';

  @override
  String get emailRequired => 'Vui lòng nhập email.';

  @override
  String get invalidEmail => 'Email không hợp lệ.';

  @override
  String get passwordRequired => 'Vui lòng nhập mật khẩu.';

  @override
  String get passwordTooShort => 'Mật khẩu phải có ít nhất 6 ký tự.';

  @override
  String get passwordTooShortEight => 'Mật khẩu phải có ít nhất 8 ký tự.';

  @override
  String get signupSubtitle => 'Tạo tài khoản để bắt đầu học tiếng Đức';

  @override
  String get displayNameRequired => 'Vui lòng nhập tên hiển thị.';

  @override
  String get displayNameTooShort => 'Tên quá ngắn.';

  @override
  String get skip => 'Bỏ qua';

  @override
  String get continueAction => 'Tiếp tục';

  @override
  String get smartVocabularyLearning => 'Học từ vựng thông minh';

  @override
  String get smartVocabularyLearningDescription =>
      'Flashcard lặp lại đúng lúc bạn sắp quên. Hơn 5000 từ vựng theo chủ đề A1–C1.';

  @override
  String get goetheTelcPractice => 'Luyện thi Goethe / telc';

  @override
  String get goetheTelcPracticeDescription =>
      'Bộ đề thi thử A1–B2 với chấm điểm tự động. Đề xuất lộ trình phù hợp với trình độ của bạn.';

  @override
  String get gamificationAndStreak => 'Gamification & streak';

  @override
  String get gamificationAndStreakDescription =>
      'XP, cấp độ, chuỗi ngày học, bảng xếp hạng bạn bè và nhiều phần thưởng hấp dẫn mỗi ngày.';

  @override
  String get resetPassword => 'Đặt lại mật khẩu';

  @override
  String get enterNewPassword => 'Nhập mật khẩu mới';

  @override
  String get newPasswordDescription => 'Mật khẩu mới phải có ít nhất 8 ký tự.';

  @override
  String get newPassword => 'Mật khẩu mới';

  @override
  String get confirmPassword => 'Xác nhận mật khẩu';

  @override
  String get passwordResetSuccess => 'Mật khẩu đã được đặt lại thành công.';

  @override
  String get couldNotResetPassword =>
      'Không thể đặt lại mật khẩu. Vui lòng thử lại.';

  @override
  String get newPasswordRequired => 'Vui lòng nhập mật khẩu mới.';

  @override
  String get newPasswordTooShort => 'Mật khẩu mới phải có ít nhất 8 ký tự.';

  @override
  String get passwordConfirmationMismatch => 'Mật khẩu xác nhận không khớp.';

  @override
  String get verifyingResetLink => 'Đang xác thực...';

  @override
  String get resetLinkInvalid =>
      'Link đặt lại mật khẩu không hợp lệ hoặc đã hết hạn.';

  @override
  String get resendResetLink => 'Gửi lại link đặt lại';

  @override
  String checkEmailForResetLink(String email) {
    return 'Kiểm tra email $email để đặt lại mật khẩu.';
  }

  @override
  String get showPasswordTooltip => 'Hiện mật khẩu';

  @override
  String get hidePasswordTooltip => 'Ẩn mật khẩu';

  @override
  String get newPasswordHint => 'Tối thiểu 8 ký tự';

  @override
  String get confirmPasswordHint => 'Nhập lại mật khẩu mới';

  @override
  String get avatarUrlOptional => 'URL ảnh đại diện (tùy chọn)';

  @override
  String get saveChanges => 'Lưu thay đổi';

  @override
  String get couldNotUpdateProfile =>
      'Không thể cập nhật hồ sơ. Vui lòng thử lại.';

  @override
  String get premium => 'Premium';

  @override
  String get level => 'Cấp độ';

  @override
  String get totalXp => 'Tổng XP';

  @override
  String get leaderboardTitle => 'Bảng xếp hạng';

  @override
  String get thisWeek => 'Tuần này';

  @override
  String get allTime => 'Mọi thời đại';

  @override
  String get couldNotLoadLeaderboard =>
      'Không thể tải bảng xếp hạng. Vui lòng thử lại.';

  @override
  String get noLeaderboardEntries => 'Chưa có dữ liệu bảng xếp hạng.';

  @override
  String get leaderboardSubtitle => 'So tài XP tuần với cộng đồng và bạn bè.';

  @override
  String get leaderboardWeeklyHeader => 'BXH tuần';

  @override
  String leaderboardResetCountdown(String countdown) {
    return 'Reset $countdown';
  }

  @override
  String get leaderboardTabGlobal => 'Toàn cầu';

  @override
  String get leaderboardTabFriends => 'Bạn bè';

  @override
  String get leaderboardHallOfFameToggle => 'Tuần trước';

  @override
  String get leaderboardNoFriends =>
      'Chưa có bạn bè trên bảng — kết bạn để so tài!';

  @override
  String get leaderboardFindFriends => 'Tìm bạn bè →';

  @override
  String get leaderboardRankNew => 'Mới';

  @override
  String get leaderboardDetailTitle => 'Chi tiết điểm tuần';

  @override
  String get leaderboardDetailComposite => 'Composite score';

  @override
  String get leaderboardDetailRawXp => 'XP gốc';

  @override
  String get leaderboardDetailXp => 'XP tuần';

  @override
  String get leaderboardDetailExam => 'Điểm exam';

  @override
  String get leaderboardDetailMission => 'Mission';

  @override
  String get leaderboardDetailVocab => 'Từ đã ôn';

  @override
  String get leaderboardDetailStreak => 'Streak';

  @override
  String get leaderboardDetailTopContributor => 'Đóng góp cao nhất';

  @override
  String get leaderboardDetailDampenedNote =>
      'Tài khoản mới đang bị giảm rank tạm thời. Hoàn thành streak 3 ngày, 3 mission hoặc 1 exam để mở khoá điểm rank đầy đủ.';

  @override
  String get leaderboardDetailViewProfile => 'Xem hồ sơ';

  @override
  String get exam => 'Thi';

  @override
  String get examPractice => 'Luyện thi';

  @override
  String get loadingExam => 'Đang tải đề thi…';

  @override
  String get examQuestionPalette => 'Bảng câu hỏi';

  @override
  String examQuestionProgress(int current, int total) {
    return 'Câu $current / $total';
  }

  @override
  String get previous => 'Quay lại';

  @override
  String get next => 'Tiếp tục';

  @override
  String get done => 'Xong';

  @override
  String get submitExam => 'Nộp bài';

  @override
  String get exitExamTitle => 'Thoát bài thi?';

  @override
  String get exitExamBody => 'Tiến trình của bạn đã được lưu tự động.';

  @override
  String get exit => 'Thoát';

  @override
  String get submitExamTitle => 'Nộp bài?';

  @override
  String submitExamUnanswered(int count) {
    return 'Bạn còn $count câu chưa làm. Vẫn nộp?';
  }

  @override
  String get reviewAnswers => 'Xem lại';

  @override
  String get allFilters => 'Tất cả';

  @override
  String get couldNotLoadExams => 'Không tải được đề thi. Vui lòng thử lại.';

  @override
  String get noSupportedExams => 'Chưa có đề Lesen hoặc Hören phù hợp.';

  @override
  String get examReadinessTitle => 'Mức sẵn sàng thi';

  @override
  String get examReadinessEmpty =>
      'Chưa có dữ liệu — hãy làm ít nhất 1 đề thi để xem mức sẵn sàng.';

  @override
  String get examReadinessAttempts => 'Số lần đã thi';

  @override
  String get examReadinessBestScore => 'Điểm cao nhất';

  @override
  String get examReadinessDueReviews => 'Từ cần ôn lại';

  @override
  String get examReadinessSkillBreakdown => 'Theo kỹ năng';

  @override
  String get examReadinessWeaknesses => 'Điểm yếu cần khắc phục';

  @override
  String get examReadinessBandLabel => 'Ước tính mức sẵn sàng';

  @override
  String get examLandingSubtitle => 'Chọn chứng chỉ & cấp độ';

  @override
  String get examBuddyCtaSubtitle =>
      'Kết nối với người cùng ngày thi để ôn cùng nhau';

  @override
  String get examShortDescTelc => 'Visa, định cư, nhập tịch';

  @override
  String get examShortDescGoethe => 'Chứng chỉ quốc tế uy tín';

  @override
  String get examShortDescOsd => 'Chứng chỉ tiếng Đức Áo';

  @override
  String get examRecommendedLabel => 'Đề xuất';

  @override
  String examLevelMismatchTitle(String level) {
    return 'Bạn đang ở trình độ $level';
  }

  @override
  String examLevelMismatchBody(String level) {
    return 'Đề thi $level có thể quá khó cho trình độ hiện tại. Bạn vẫn muốn tiếp tục?';
  }

  @override
  String get examLevelMismatchCancel => 'Huỷ';

  @override
  String get examLevelMismatchContinue => 'Vẫn tiếp tục';

  @override
  String examSectionBundleCount(int count) {
    return '$count bộ đề';
  }

  @override
  String get examBundleArapTitle => 'A-RAP';

  @override
  String get examBundleArapDesc =>
      'Đề luyện thi chính thức · Lesen · Hören · Schreiben · Sprachbausteine';

  @override
  String get examBundleSpeakingTitle => 'Nói (Sprechen)';

  @override
  String get examBundleSpeakingDesc => 'Luyện kỹ năng nói theo chủ đề';

  @override
  String get examBundleComingSoon => 'Sắp có';

  @override
  String examSetCount(int count) {
    return '$count bộ đề';
  }

  @override
  String examSetCompletedSuffix(int count) {
    return '$count hoàn thành';
  }

  @override
  String examSetInProgressSuffix(int count) {
    return '$count đang làm';
  }

  @override
  String get examSetEmptyTitle => 'Chưa có đề thi';

  @override
  String get examSetEmptyBody =>
      'Hiện tại chưa có đề thi cho chứng chỉ và cấp độ này.';

  @override
  String get examSetPagePrev => 'Trước';

  @override
  String get examSetPageNext => 'Tiếp';

  @override
  String examSetPageIndicator(int current, int total) {
    return 'Trang $current / $total';
  }

  @override
  String examPartsCount(int count) {
    return '$count phần';
  }

  @override
  String get examPartActionTest => 'Luyện thi';

  @override
  String get examPartActionPractice => 'Luyện tập';

  @override
  String get examSkillListEmptyTitle => 'Chưa có đề thi';

  @override
  String examSkillListEmptyBody(String skill) {
    return 'Hiện tại chưa có phần $skill nào.';
  }

  @override
  String get examSkillListVocabChip => 'Từ vựng';

  @override
  String get examLocked => 'Khóa';

  @override
  String get examScheduleTitle => 'Tìm bạn ôn thi';

  @override
  String get examBuddyListTab => 'Danh sách bạn ôn thi';

  @override
  String get examMyRegistrationsTab => 'Thông tin của tôi';

  @override
  String get examBuddyListEmpty => 'Chưa có ai đăng ký lịch thi.';

  @override
  String examBuddyDaysUntil(int days) {
    return 'Còn $days ngày';
  }

  @override
  String get examBuddyPast => 'Đã thi';

  @override
  String get examRegistrationAdd => 'Thêm lịch thi';

  @override
  String get examRegistrationDelete => 'Xoá lịch thi';

  @override
  String get examRegistrationFormTitle => 'Đăng ký lịch thi';

  @override
  String get examTypeLabel => 'Loại thi';

  @override
  String get examLevelLabel => 'Trình độ';

  @override
  String get examDateLabel => 'Ngày thi';

  @override
  String get examRegistrationSave => 'Lưu';

  @override
  String get communityExamsTitle => 'Đề thi cộng đồng';

  @override
  String get communityExamsEmpty => 'Chưa có đề thi cộng đồng nào.';

  @override
  String get communityExamDetailTitle => 'Chi tiết đề thi';

  @override
  String communityExamContributedBy(String name) {
    return 'Đóng góp bởi $name';
  }

  @override
  String get deThiListTitle => 'Đề thi công khai';

  @override
  String get deThiListEmpty => 'Chưa có đề thi công khai nào.';

  @override
  String get deThiNotFound => 'Không tìm thấy đề thi này.';

  @override
  String get deThiRevealAnswer => 'Xem đáp án';

  @override
  String deThiCorrectAnswer(String answer) {
    return 'Đáp án đúng: $answer';
  }

  @override
  String get examDictationPickerTitle => 'Chọn đề luyện nghe';

  @override
  String get examDictationTitle => 'Nghe chép chính tả';

  @override
  String get examDictationNotFound =>
      'Đề này chưa có dữ liệu luyện nghe chép chính tả.';

  @override
  String get examDictationNoWords => 'Chưa có từ vựng phù hợp để luyện.';

  @override
  String get examDictationCheck => 'Kiểm tra';

  @override
  String examQuestionsCount(int count) {
    return '$count câu';
  }

  @override
  String examDurationMinutes(int count) {
    return '$count phút';
  }

  @override
  String get practiceExam => 'Luyện tập';

  @override
  String get examTestMode => 'Thi';

  @override
  String get examReviewMode => 'Xem lại';

  @override
  String get couldNotPlayAudio => 'Không thể phát audio. Vui lòng thử lại.';

  @override
  String get examListeningAudio => 'Nghe';

  @override
  String get audioPlay => 'Phát audio';

  @override
  String get audioPause => 'Tạm dừng audio';

  @override
  String audioPlayCounter(int used, int max, String remaining) {
    return 'Đã nghe $used/$max lượt · còn $remaining';
  }

  @override
  String get audioPlayLimitReached => 'Bạn đã dùng hết số lần nghe cho phép.';

  @override
  String get examResults => 'Kết quả';

  @override
  String get couldNotLoadExamResult =>
      'Không thể tải kết quả bài thi. Vui lòng thử lại.';

  @override
  String get noExamResult => 'Chưa có kết quả cho đề thi này.';

  @override
  String get passedExam => 'ĐẠT';

  @override
  String get notPassedExam => 'CHƯA ĐẠT';

  @override
  String get examAnswered => 'Đã trả lời';

  @override
  String examAnsweredQuestions(int answered, int total) {
    return '$answered/$total câu';
  }

  @override
  String get examTime => 'Thời gian';

  @override
  String get examCorrectRate => 'Tỉ lệ đúng';

  @override
  String get examSectionAnalysis => 'Phân tích phần thi';

  @override
  String get examSectionReading => 'Đọc hiểu';

  @override
  String get examSectionListening => 'Nghe hiểu';

  @override
  String examSectionSummary(int correct, int total, int minutes) {
    return '$correct/$total câu đúng · $minutes phút';
  }

  @override
  String get reviewExam => 'Xem lại bài';

  @override
  String get retryExam => 'Làm lại';

  @override
  String get examCorrect => 'Đúng';

  @override
  String get examNotCorrect => 'Chưa đúng';

  @override
  String examQuestionNumber(int number) {
    return 'Câu $number';
  }

  @override
  String matchingSelectRight(int number) {
    return 'Chọn ô bên phải để nối với mục $number';
  }

  @override
  String get removeMatch => 'Bỏ nối';

  @override
  String examGapNumber(int number) {
    return 'Chỗ trống $number';
  }

  @override
  String get takeMockExam => 'Thi thử';

  @override
  String get learn => 'Học';

  @override
  String get learningJourney => 'Hành trình học';

  @override
  String get retryTodaySession => 'Tải lại phiên hôm nay';

  @override
  String get couldNotLoadTodayLesson => 'Không tải được bài học hôm nay.';

  @override
  String get coursesTileTitle => 'Khoá học';

  @override
  String get coursesHubTitle => 'Khoá học';

  @override
  String get coursesFeaturedSection => 'Khoá học nổi bật';

  @override
  String get coursesMySection => 'Đang học';

  @override
  String get coursesAllSection => 'Tất cả khoá học';

  @override
  String get coursesEmptyCatalog => 'Chưa có khoá học nào.';

  @override
  String coursesLessonsCount(int count) {
    return '$count bài học';
  }

  @override
  String coursesLessonsStarted(int count) {
    return 'Đã học $count bài';
  }

  @override
  String get coursesNoLessonsYet => 'Khoá học này chưa có bài học.';

  @override
  String get coursesLessonCompleted => 'Hoàn thành';

  @override
  String get coursesMarkComplete => 'Đánh dấu hoàn thành';

  @override
  String get coursesMarkIncomplete => 'Bỏ đánh dấu hoàn thành';

  @override
  String get coursesVideoWebOnly =>
      'Video của bài học này hiện chỉ xem được trên bản web.';

  @override
  String get coursesVocabularyTitle => 'Từ vựng bài học';

  @override
  String coursesExercisesHint(int count) {
    return '$count bài tập tương tác — làm trên bản web.';
  }

  @override
  String get coursesNotesLabel => 'Ghi chú của bạn';

  @override
  String get coursesNotesHint => 'Ghi chú riêng cho bài học này...';

  @override
  String get coursesNotesSave => 'Lưu ghi chú';

  @override
  String get coursesNotesSaved => 'Đã lưu ghi chú';

  @override
  String get coursesNotesSaveFailed => 'Lưu ghi chú thất bại, thử lại.';

  @override
  String get coursesSignInRequired => 'Đăng nhập để lưu tiến độ và ghi chú.';

  @override
  String coursesLessonNumber(int number) {
    return 'Bài $number';
  }

  @override
  String get coursesPremiumLabel => 'Premium';

  @override
  String get coursesViewContent => 'Xem nội dung';

  @override
  String get coursesUnlockArrow => 'Mở khóa →';

  @override
  String get coursesViewArrow => 'Xem →';

  @override
  String get coursesHubSubtitle =>
      'Học tiếng Đức qua video + bài tập tương tác từ Deutsche Welle';

  @override
  String coursesCount(int count) {
    return '$count khoá';
  }

  @override
  String coursesLessonsCountPlus(int count) {
    return '$count+ bài học';
  }

  @override
  String get coursesSearchHint => 'Tìm khoá học...';

  @override
  String get coursesCollapse => 'Thu gọn';

  @override
  String coursesShowMore(int count) {
    return 'Xem thêm $count khoá';
  }

  @override
  String coursesSearchResultsCount(int count, String query) {
    return '$count kết quả cho \"$query\"';
  }

  @override
  String coursesSearchNoResults(String query) {
    return 'Không tìm thấy \"$query\"';
  }

  @override
  String coursesUpsellHubTitle(int count) {
    return 'Mở khóa toàn bộ $count khoá học';
  }

  @override
  String coursesUpsellHubSubtitle(int limit) {
    return 'Bạn đang dùng $limit khoá miễn phí. Nâng cấp để truy cập tất cả nội dung.';
  }

  @override
  String get coursesUpsellCta => 'Nâng cấp';

  @override
  String coursesLevelHeading(String label) {
    return 'Level $label';
  }

  @override
  String get coursesLevelEmpty => 'Chưa có dữ liệu cho level này.';

  @override
  String coursesLessonNumberShort(String number) {
    return 'Bài $number';
  }

  @override
  String get coursesPaginationPrev => '← Trước';

  @override
  String get coursesPaginationNext => 'Sau →';

  @override
  String coursesPaginationInfo(int page, int totalPages, int start, int end) {
    return 'Trang $page/$totalPages · Hiển thị $start–$end';
  }

  @override
  String get coursesProgressTitle => 'Tiến độ học';

  @override
  String get coursesProgressVideosWatched => 'video đã xem';

  @override
  String get coursesProgressLessonsStarted => 'bài đã bắt đầu';

  @override
  String coursesUpsellDetailTitle(int count) {
    return 'Mở khóa toàn bộ $count bài học.';
  }

  @override
  String coursesUpsellDetailSubtitle(int limit) {
    return 'Bạn đang xem $limit bài miễn phí.';
  }

  @override
  String get coursesLessonNotStarted => 'Chưa học';

  @override
  String get coursesLessonNoVideo => 'Bài này chưa có video.';

  @override
  String get coursesLessonStripTitle => 'Danh sách bài';

  @override
  String get coursesTranscriptTitle => 'Phụ đề';

  @override
  String get coursesTranscriptCopyDe => 'Sao chép tiếng Đức';

  @override
  String get coursesTranscriptCopyVi => 'Sao chép tiếng Việt';

  @override
  String get coursesTranscriptHideVi => 'Ẩn VI';

  @override
  String get coursesTranscriptShowVi => 'Hiện VI';

  @override
  String get coursesTranscriptEmpty => 'Bài này chưa có phụ đề.';

  @override
  String coursesVocabularyCount(int count) {
    return 'Từ vựng ($count)';
  }

  @override
  String get coursesVocabularyEmpty => 'Bài này chưa có danh sách từ vựng.';

  @override
  String get coursesCommentsTitle => 'Bình luận';

  @override
  String get coursesCommentsError => 'Không tải được bình luận.';

  @override
  String get coursesCommentsEmpty => 'Chưa có bình luận nào.';

  @override
  String get coursesCommentsPlaceholder => 'Viết bình luận...';

  @override
  String get coursesCommentsSendError => 'Gửi bình luận thất bại, thử lại.';

  @override
  String get coursesLessonVideoDone => '✓ Video đã hoàn thành';

  @override
  String get coursesLessonMarkVideoDone => '🎉 Đánh dấu hoàn thành video';

  @override
  String get coursesLessonWatchHint => '⏱️ Xem ít nhất 80% video để hoàn thành';

  @override
  String get coursesLessonSaving => 'Đang lưu...';

  @override
  String get coursesProgressSaveCta => 'Lưu tiến độ';

  @override
  String get coursesProgressSaved => 'Đã lưu tiến độ';

  @override
  String get coursesProgressSaveFailed => 'Lưu thất bại';

  @override
  String coursesLessonHeading(String number, String name) {
    return 'Bài $number: $name';
  }

  @override
  String get coursesLockedLessonTitle => 'Bài học yêu cầu Premium';

  @override
  String get coursesLockedLessonDescription =>
      'Bài học này nằm ngoài giới hạn miễn phí. Nâng cấp để mở khóa toàn bộ nội dung.';

  @override
  String get missionComplete => 'Hoàn thành nhiệm vụ!';

  @override
  String get noMissionRounds =>
      'Không có vòng học nào trong bài từ vựng hôm nay.';

  @override
  String get startPractice => 'Bắt đầu luyện tập';

  @override
  String get missionPractice => 'Luyện tập';

  @override
  String get notRemembered => 'Chưa nhớ';

  @override
  String get rememberedCorrectly => 'Nhớ đúng';

  @override
  String get missionAnswerCorrect => 'Chính xác!';

  @override
  String get missionAnswerTryAgain => 'Chưa đúng, cố lên!';

  @override
  String get saving => 'Đang lưu…';

  @override
  String get saveToDeck => 'Lưu vào bộ thẻ';

  @override
  String get saved => 'Đã lưu';

  @override
  String get alreadySaved => 'Đã có';

  @override
  String get wordSavedToDeck => 'Đã lưu từ vào bộ thẻ.';

  @override
  String get openDeck => 'Mở bộ thẻ';

  @override
  String get couldNotSaveWord =>
      'Không thể lưu từ này. Hãy đăng nhập và thử lại.';

  @override
  String get chooseDeck => 'Chọn bộ thẻ';

  @override
  String get chooseDeckDescription =>
      'Lưu nhanh từ này hoặc chọn một bộ thẻ cụ thể.';

  @override
  String get quickSave => 'Lưu nhanh';

  @override
  String get deviceSessionEnded => 'Phiên đăng nhập đã kết thúc';

  @override
  String get deviceKickedBody =>
      'Thiết bị này đã bị đăng xuất. Vui lòng đăng nhập lại để tiếp tục.';

  @override
  String get signInAgain => 'Đăng nhập lại';

  @override
  String get wordNotFound => 'Không tìm thấy từ này trong từ điển.';

  @override
  String get lookingUpWord => 'Đang tra từ…';

  @override
  String get couldNotLookupWord =>
      'Không thể tra từ này lúc này. Vui lòng thử lại.';

  @override
  String get meaning => 'Nghĩa';

  @override
  String get example => 'Ví dụ';

  @override
  String get saveSentence => 'Lưu câu';

  @override
  String get sentenceSaved => 'Đã lưu câu';

  @override
  String get couldNotSaveSentence => 'Không thể lưu câu lúc này.';

  @override
  String get couldNotSaveMissionRound =>
      'Không lưu được vòng học này. Vui lòng thử lại.';

  @override
  String get couldNotCompleteMission =>
      'Không hoàn tất được nhiệm vụ này. Vui lòng thử lại.';

  @override
  String get score => 'Điểm';

  @override
  String get accuracy => 'Độ chính xác';

  @override
  String get playAgain => 'Chơi lại';

  @override
  String missionCompletedXp(int xp) {
    return 'Đã hoàn thành · $xp XP';
  }

  @override
  String missionRoundsWords(int rounds, int words) {
    return '$rounds vòng · $words từ';
  }

  @override
  String get missionResumeTitle => 'Mở lại bài đang dở';

  @override
  String get missionResumeContinueCta => 'Sang vòng từ vựng';

  @override
  String get missionCompleteTitle => 'Hoàn thành!';

  @override
  String get missionCompleteSubtitle =>
      'Xong bước từ vựng — lộ trình hôm nay còn các bước kỹ năng tiếp theo';

  @override
  String missionXpBadge(int xp) {
    return '+$xp XP';
  }

  @override
  String get missionClimbedTitle => 'Hôm nay bạn đã leo bậc:';

  @override
  String get missionStreakUpdated => '🔥 Streak hôm nay đã được cập nhật!';

  @override
  String get missionNextStepCta => 'Bước tiếp theo →';

  @override
  String get missionMismatch =>
      'Phiên học không khớp. Về trang chủ để bắt đầu lại.';

  @override
  String get missionAlreadyDoneToday =>
      'Đã xong bài từ vựng hôm nay 🎉 Quay lại lộ trình để làm bước tiếp theo.';

  @override
  String get completed => 'Đã xong';

  @override
  String get more => 'Thêm';

  @override
  String get moreFeaturesTitle => 'Tất cả tính năng';

  @override
  String get close => 'Đóng';

  @override
  String get navConversation => 'Hội thoại';

  @override
  String get groupAccountOther => 'Tài khoản & Khác';

  @override
  String get featureYoutube => 'YouTube';

  @override
  String get featureReadListen => 'Đọc & Nghe';

  @override
  String get featureListening => 'Nghe';

  @override
  String get featureReadingFeed => 'Đọc bài';

  @override
  String get featureNews => 'Tin tức';

  @override
  String get featureSubtitleWords => 'Từ vựng phụ đề';

  @override
  String get featureFocusSession => 'Phiên tập trung';

  @override
  String get featureCasesHub => 'Luyện 4 Cách';

  @override
  String get featureMinimalPairs => 'Cặp âm dễ nhầm';

  @override
  String get featurePronunciation => 'Luyện phát âm';

  @override
  String get featureInterview => 'Phỏng vấn';

  @override
  String get featureLearnerModel => 'Hồ sơ năng lực';

  @override
  String get featureExamReadiness => 'Sẵn sàng thi';

  @override
  String get featureErrorPatterns => 'Lỗi hay gặp';

  @override
  String get featureMessages => 'Tin nhắn';

  @override
  String get featureFriends => 'Bạn bè';

  @override
  String get featureExamSchedule => 'Tìm bạn ôn thi';

  @override
  String get featureDailyQuote => 'Trích dẫn hằng ngày';

  @override
  String get featureAffiliateIntro => 'Giới thiệu';

  @override
  String get featurePremiumUpgrade => 'Nâng cấp Premium';

  @override
  String get featureAdmin => 'Quản trị';

  @override
  String get featureFeedback => 'Góp ý';

  @override
  String get featureLeaderboardFull => 'Bảng xếp hạng';

  @override
  String get featureAiAssistant => 'Trợ lý AI';

  @override
  String get groupVocabularyReview => 'Từ vựng & ôn tập';

  @override
  String get groupExtraPractice => 'Luyện thêm';

  @override
  String get groupGrammarSkills => 'Ngữ pháp & kỹ năng';

  @override
  String get groupCommunityProgress => 'Cộng đồng & tiến độ';

  @override
  String get myWords => 'Kho từ';

  @override
  String get savedWords => 'Đã lưu';

  @override
  String get viewedWords => 'Đã xem';

  @override
  String get wordsToReview => 'Cần ôn';

  @override
  String get couldNotLoadMyWords => 'Không tải được kho từ. Vui lòng thử lại.';

  @override
  String get noWordsForFilter => 'Chưa có từ nào trong nhóm này.';

  @override
  String myWordsCount(int count) {
    return '$count từ';
  }

  @override
  String get flashcardDecks => 'Bộ thẻ';

  @override
  String get reviewDueDeckCards => 'Ôn thẻ đến hạn';

  @override
  String get emptyDeckCards => 'Bộ thẻ chưa có từ nào.';

  @override
  String get myDecks => 'Bộ từ của tôi';

  @override
  String get createDeck => 'Tạo bộ từ';

  @override
  String get createNewDeck => 'Tạo bộ từ mới';

  @override
  String get editDeck => 'Sửa bộ từ';

  @override
  String get deleteDeck => 'Xóa bộ từ';

  @override
  String deleteDeckConfirmation(Object name) {
    return 'Bạn có chắc muốn xóa \"$name\"?';
  }

  @override
  String get couldNotLoadDecks => 'Không tải được danh sách bộ từ.';

  @override
  String get noDecks => 'Chưa có bộ từ nào';

  @override
  String get noDecksDescription =>
      'Tạo bộ từ riêng để học theo chủ đề bạn thích.';

  @override
  String get deckName => 'Tên bộ từ';

  @override
  String get deckNameHint => 'Ví dụ: Từ vựng du lịch';

  @override
  String get deckDescriptionOptional => 'Mô tả (tùy chọn)';

  @override
  String get deckDescriptionHint => 'Mô tả ngắn về bộ từ';

  @override
  String deckListSubtitleWithFolders(int decks, int folders) {
    return '$decks bộ thẻ · $folders thư mục';
  }

  @override
  String get deckIntroWhy => 'Những từ bạn tự lưu, gom theo bộ riêng.';

  @override
  String get deckIntroTodo => 'Mở một bộ để ôn hoặc thêm từ mới.';

  @override
  String get deckIntroNext => 'Từ trong sổ cũng vào lịch Ôn tập FSRS.';

  @override
  String get deckIntroNextLabel => 'Ôn tập';

  @override
  String get deckAllDecksTitle => 'Tất cả decks';

  @override
  String get deckQuickPracticeTitle => 'Luyện tập nhanh';

  @override
  String get deckQuickPracticeCta => 'Chơi Word Sprint với từ trong sổ';

  @override
  String get deckStarredTitle => 'Starred';

  @override
  String get deckStarredSubtitle => 'Thẻ đã gắn sao';

  @override
  String get deckFoldersTitle => 'Thư mục';

  @override
  String get deckDefaultTooltip => 'Bộ thẻ mặc định';

  @override
  String get deckSetDefaultTooltip => 'Đặt làm mặc định';

  @override
  String get deckDefaultBadge => 'Mặc định';

  @override
  String get deckMoveToFolder => 'Chuyển vào thư mục';

  @override
  String get deckActionCreateDeck => 'Tạo bộ thẻ';

  @override
  String get deckActionCreateDeckSubtitle => 'Thêm bộ từ vựng mới';

  @override
  String get deckActionCreateFolder => 'Tạo thư mục';

  @override
  String get deckActionCreateFolderSubtitle => 'Sắp xếp bộ thẻ theo nhóm';

  @override
  String get deckActionSpeak => 'Nói ra ghi chú';

  @override
  String get deckActionSpeakSubtitle =>
      'Nói tiếng Đức → lưu từng câu thành thẻ';

  @override
  String get deckFolderName => 'Tên thư mục';

  @override
  String get deckFolderNameHint => 'VD: Từ vựng A1';

  @override
  String get deckNoFolder => 'Không thuộc thư mục';

  @override
  String get deckNoSearchResults => 'Không tìm thấy thẻ phù hợp.';

  @override
  String get deckSearchHint => 'Tìm từ...';

  @override
  String get deckStarredFilterTooltip => 'Chỉ xem starred';

  @override
  String get deckAddCard => 'Thêm';

  @override
  String get deckCardFormRequired => 'Vui lòng nhập đủ mặt trước và mặt sau.';

  @override
  String get deckCardFormSaveError => 'Không lưu được thẻ. Vui lòng thử lại.';

  @override
  String get deckEditCardTitle => 'Sửa thẻ';

  @override
  String get deckNewCardTitle => 'Thêm thẻ mới';

  @override
  String get deckCardFrontLabel => 'Mặt trước (tiếng Đức)';

  @override
  String get deckCardFrontHint => 'VD: das Haus';

  @override
  String get deckCardBackLabel => 'Mặt sau (tiếng Việt)';

  @override
  String get deckCardBackHint => 'VD: ngôi nhà';

  @override
  String get deckCardExampleLabel => 'Câu ví dụ (tùy chọn)';

  @override
  String get deckCardExampleHint => 'VD: Das ist mein Haus.';

  @override
  String get deckCardExampleViLabel => 'Dịch câu ví dụ (tùy chọn)';

  @override
  String get deckFolderEmpty => 'Thư mục chưa có bộ thẻ nào.';

  @override
  String get deckStarredEmpty => 'Chưa có thẻ nào được gắn sao.';

  @override
  String get deckLessonTitle => 'Học theo bài';

  @override
  String deckLessonBatchProgress(int current, int total) {
    return 'Đợt $current/$total';
  }

  @override
  String get deckBackToDeck => 'Về bộ thẻ';

  @override
  String get deckLessonBatchDoneTitle => 'Xong đợt này!';

  @override
  String deckLessonBatchDoneSubtitle(int correct, int total) {
    return 'Đúng $correct/$total thẻ';
  }

  @override
  String get deckLessonFinish => 'Hoàn thành';

  @override
  String get deckLessonNextBatch => 'Đợt tiếp theo';

  @override
  String get deckPlayCta => 'Chơi';

  @override
  String get deckLearnCta => 'Học';

  @override
  String get deckSpeakTitle => 'Nói ra ghi chú';

  @override
  String get deckSpeakHelper =>
      'Nói hoặc gõ tiếng Đức — mỗi câu sẽ thành một thẻ ghi nhớ.';

  @override
  String get deckSpeakMicTooltip => 'Nhấn để bắt đầu ghi âm';

  @override
  String get deckSpeakMicComingSoon => 'Ghi âm giọng nói sẽ sớm ra mắt';

  @override
  String get deckSpeakTextareaHint => 'Mỗi dòng là một câu sẽ thành một thẻ...';

  @override
  String get deckSpeakDeckNameLabel => 'Tên bộ thẻ';

  @override
  String get deckSpeakDeckNameHelper =>
      'Mỗi câu sẽ thành một thẻ trong bộ này.';

  @override
  String deckSpeakSavedMessage(int count) {
    return 'Đã lưu $count câu vào bộ thẻ mới.';
  }

  @override
  String get deckSpeakViewDeck => 'Xem bộ thẻ →';

  @override
  String get deckSpeakEmptyError => 'Nhập ít nhất một câu trước khi lưu.';

  @override
  String get deckSpeakSaveError => 'Không lưu được. Vui lòng thử lại.';

  @override
  String get deckSpeakSaveCta => 'Lưu vào Notes';

  @override
  String get edit => 'Sửa';

  @override
  String get delete => 'Xóa';

  @override
  String get save => 'Lưu';

  @override
  String wordsCount(int count) {
    return '$count từ';
  }

  @override
  String learnedWordsProgress(int learned, int total) {
    return 'Đã học $learned/$total';
  }

  @override
  String get dailyReview => 'Ôn hàng ngày';

  @override
  String get flashcardReview => 'Ôn từ';

  @override
  String get tapToShowMeaning => 'Chạm để xem nghĩa';

  @override
  String get listenPronunciation => 'Nghe phát âm';

  @override
  String get couldNotLoadReviewData => 'Không tải được dữ liệu ôn tập.';

  @override
  String get couldNotLoadReviewCards => 'Không tải được thẻ ôn tập.';

  @override
  String get noCardsDueToday => 'Hôm nay không có thẻ nào đến hạn 🎉';

  @override
  String get backToHome => 'Về trang chủ';

  @override
  String reviewStreak(int count) {
    return 'Chuỗi $count ngày! 🔥';
  }

  @override
  String get keepReviewStreak => 'Giữ streak bằng cách ôn từ mỗi ngày';

  @override
  String get due => 'Đến hạn';

  @override
  String get reviewed => 'Đã ôn';

  @override
  String get startDailyReview => 'Bắt đầu ôn tập';

  @override
  String get showMeaning => 'Xem nghĩa';

  @override
  String reviewProgress(int current, int total) {
    return '$current / $total';
  }

  @override
  String get couldNotSaveReview =>
      'Không thể lưu lần ôn này. Vui lòng thử lại.';

  @override
  String get ratingAgain => 'Lại';

  @override
  String get ratingAgainHint => '<1 phút';

  @override
  String get ratingHard => 'Khó';

  @override
  String get ratingHardHint => 'Khó';

  @override
  String get ratingGood => 'Tốt';

  @override
  String get ratingGoodHint => 'OK';

  @override
  String get ratingEasy => 'Dễ';

  @override
  String get ratingEasyHint => 'Dễ';

  @override
  String dailyReviewRoundLabel(int current, int total) {
    return 'Vòng $current/$total';
  }

  @override
  String dailyReviewRoundWordCount(int count) {
    return '$count từ';
  }

  @override
  String get dailyReviewRoundStart => 'Bắt đầu';

  @override
  String dailyReviewRoundDone(String gameName) {
    return 'Xong $gameName!';
  }

  @override
  String dailyReviewRoundProgress(int reviewed, int total) {
    return 'Đã ôn $reviewed/$total từ';
  }

  @override
  String get dailyReviewRoundFinish => 'Xem kết quả';

  @override
  String get dailyReviewRoundContinue => 'Tiếp tục';

  @override
  String get dailyReviewRetryBanner => 'Ôn lại các từ bạn vừa luyện.';

  @override
  String get dailyReviewEmptyTitle => 'Không có từ cần ôn!';

  @override
  String get dailyReviewEmptySubtitle => 'Quay lại sau hoặc luyện tập thêm';

  @override
  String get dailyReviewSessionLabel => 'Phiên ôn tập';

  @override
  String get dailyReviewStatusExcellent => 'Xuất sắc';

  @override
  String get dailyReviewStatusGood => 'Khá tốt';

  @override
  String get dailyReviewStatusNeedsWork => 'Cần ôn thêm';

  @override
  String get dailyReviewCompletedTitle => 'Hoàn thành!';

  @override
  String get dailyReviewWeakWordsTitle => 'Từ cần ôn lại';

  @override
  String get dailyReviewCtaMore => 'Ôn thêm';

  @override
  String dailyReviewCtaRetryWeak(int count) {
    return 'Luyện lại $count từ yếu';
  }

  @override
  String get dailyReviewCtaContinueLearning => 'Tiếp tục học';

  @override
  String get dailyReviewCtaListening => '🎧 Luyện nghe';

  @override
  String get dailyReviewCtaAskAi => '✨ Hỏi AI về từ khó';

  @override
  String get vocabularyLibrary => 'Kho chung';

  @override
  String get vocabulary => 'Kho từ vựng';

  @override
  String get couldNotLoadVocabulary =>
      'Không tải được từ vựng. Vui lòng thử lại.';

  @override
  String get noVocabulary => 'Chưa có từ vựng ở đây.';

  @override
  String cefrLevelsCount(int count) {
    return '$count cấp độ CEFR';
  }

  @override
  String get vocabularyByGoal => 'Theo mục tiêu';

  @override
  String get vocabularyByLevel => 'Theo cấp độ';

  @override
  String get vocabularyByTopic => 'Theo chủ đề';

  @override
  String get learnByGoal => 'Học theo mục tiêu';

  @override
  String get learnByGoalDescription =>
      'Các mục tiêu là lối vào nhanh, dùng lại cùng kho từ theo chủ đề và cấp độ.';

  @override
  String get goalDailyLife => 'Dùng tiếng Đức hằng ngày';

  @override
  String get goalSettlementHome => 'Định cư & nhà ở';

  @override
  String get goalTravel => 'Du lịch & di chuyển';

  @override
  String get goalFoodService => 'Ăn uống & nhà hàng';

  @override
  String get goalWork => 'Công việc & nghề nghiệp';

  @override
  String get goalMedical => 'Y khoa / điều dưỡng';

  @override
  String get goalStudyExam => 'Học tập & ôn thi';

  @override
  String get goalTechEngineering => 'Công nghệ & kỹ thuật';

  @override
  String get goalShoppingBeauty => 'Mua sắm & làm đẹp';

  @override
  String get goalFamilySocial => 'Gia đình & quan hệ';

  @override
  String get goalLeisureCulture => 'Giải trí & văn hoá';

  @override
  String get goalNatureEnvironment => 'Thiên nhiên & môi trường';

  @override
  String get vocabularyMine => 'Của tôi';

  @override
  String get vocabularyIntroWhy => 'Kho từ hệ thống — chọn bộ để học và ôn.';

  @override
  String get vocabularyIntroTodo => 'Mở một bộ từ để học thẻ mới.';

  @override
  String get vocabularyIntroNext => 'Từ đã học sẽ vào lịch Ôn tập.';

  @override
  String get vocabularyIntroNextLabel => 'Ôn tập';

  @override
  String get vocabularyChooseGroupLabel => 'Chọn nhóm chủ đề';

  @override
  String vocabularyGoalTopicsCount(int count) {
    return '$count chủ đề';
  }

  @override
  String get vocabularyTopicSectionTitle => '📚 Chủ đề từ vựng';

  @override
  String get vocabularyTopicSectionDescription =>
      'Chọn nhóm chủ đề rồi mở nhanh từng chủ đề con theo cấp độ.';

  @override
  String get vocabularyLevelSectionTitle => '🎯 Cấp độ CEFR';

  @override
  String get vocabularyLevelSectionDescription =>
      'Vào từng cấp độ rồi lọc chủ đề; hoặc bấm thẳng chip chủ đề bên dưới.';

  @override
  String get vocabularyTipTitle => 'Mẹo học tập';

  @override
  String get vocabularyTipNext => 'Tiếp';

  @override
  String get wordSprintSectionTitle => '⚡ Luyện tập với chủ đề';

  @override
  String get wordSprintStart => 'Bắt đầu';

  @override
  String get wordSprintDescription => '60 giây · 4 đáp án · Combo x3';

  @override
  String get vocabularySearchHint => 'Tìm từ...';

  @override
  String get vocabularyWeakFilter => 'Yếu';

  @override
  String vocabularyMasteredCount(int done, int total) {
    return '$done/$total đã thuộc';
  }

  @override
  String get vocabularyTabList => 'Danh sách';

  @override
  String get vocabularyTabMyWords => 'Từ của tôi';

  @override
  String get vocabularyStartLesson => 'Học từ mới';

  @override
  String get vocabularyNotFound => 'Không tìm thấy bộ từ';

  @override
  String get vocabularyMasteryMastered => 'Đã thuộc';

  @override
  String get vocabularyMasteryKnown => 'Đang nhớ';

  @override
  String get vocabularyMasteryLearning => 'Đang học';

  @override
  String get vocabularyMasteryNew => 'Mới';

  @override
  String get myWordsGroupReviewing => 'Trong Ôn tập';

  @override
  String get myWordsGroupSaved => 'Trong Sổ từ';

  @override
  String get myWordsGroupSeen => 'Đã gặp';

  @override
  String myWordsSourceLabel(Object source) {
    return 'nguồn: $source';
  }

  @override
  String myWordsMoreCount(int count) {
    return '+$count từ nữa trong nhóm này';
  }

  @override
  String get myWordsEmptyTitle => 'Chưa có từ nào trong kho của bạn';

  @override
  String get myWordsEmptyDescription =>
      'Tra từ khi đọc/xem video hoặc lưu từ vào Sổ từ — chúng sẽ hiện ở đây.';

  @override
  String cefrLevel(Object level) {
    return 'Cấp độ $level';
  }

  @override
  String get cefrBeginner => 'Sơ cấp';

  @override
  String get cefrPreIntermediate => 'Tiền trung cấp';

  @override
  String get cefrIntermediate => 'Trung cấp';

  @override
  String get cefrUpperIntermediate => 'Trung cấp cao';

  @override
  String get cefrAdvanced => 'Cao cấp';

  @override
  String get cefrProficient => 'Thành thạo';

  @override
  String get noVocabularyTopics => 'Chưa có chủ đề từ vựng nào.';

  @override
  String vocabularyTopicStats(Object label, int count) {
    return '$label · $count từ';
  }

  @override
  String vocabularyTopicTitle(Object topic) {
    return 'Từ vựng: $topic';
  }

  @override
  String get noVocabularyInLesson => 'Chưa có từ vựng trong bài học này.';

  @override
  String get noMatchingVocabulary => 'Chưa có từ phù hợp với bộ lọc.';

  @override
  String get clearVocabularyFilters => 'Hãy thử bỏ một bộ lọc.';

  @override
  String get searchLessonVocabulary => 'Tìm trong bài học…';

  @override
  String get allLevels => 'Tất cả';

  @override
  String lessonProgress(int learned, int total) {
    return 'Tiến độ: $learned / $total từ';
  }

  @override
  String get wordMeanings => 'Nghĩa';

  @override
  String get wordExamples => 'Ví dụ';

  @override
  String get viewVocabularyDetails => 'Xem chi tiết';

  @override
  String get flipVocabularyCard => 'Lật thẻ';

  @override
  String get noMeaning => 'Chưa có nghĩa';

  @override
  String get wordGender => 'Giống';

  @override
  String get wordPlural => 'Số nhiều';

  @override
  String get wordType => 'Loại';

  @override
  String get auxiliaryVerb => 'Trợ động từ';

  @override
  String get comparative => 'So sánh hơn';

  @override
  String get superlative => 'So sánh nhất';

  @override
  String get verbConjugation => 'Chia động từ';

  @override
  String get principalForms => 'Dạng chính';

  @override
  String get relatedWords => 'Từ liên quan';

  @override
  String get flashcardPractice => 'Flashcard';

  @override
  String get practice => 'Luyện tập';

  @override
  String get listeningPractice => 'Luyện nghe';

  @override
  String get newsReading => 'Tin tức Đức';

  @override
  String get writingPractice => 'Luyện viết';

  @override
  String get aiChat => 'AI chat';

  @override
  String get grammar => 'Ngữ pháp';

  @override
  String get grammarSearchHint => 'Tìm bài ngữ pháp bất kỳ...';

  @override
  String get grammarNoResults => 'Không tìm thấy bài nào';

  @override
  String get grammarNoLessons => 'Chưa có bài học';

  @override
  String get grammarAllDone => '🎉 Hoàn thành rồi!';

  @override
  String get grammarViewAll => 'Xem tất cả';

  @override
  String get grammarMarkComplete => 'Đánh dấu hoàn thành';

  @override
  String get grammarCompleted => 'Đã hoàn thành';

  @override
  String get grammarAlreadyCompleted => 'Bạn đã hoàn thành bài này trước đó.';

  @override
  String get grammarRelatedLessons => 'Bài liên quan';

  @override
  String get grammarNotFound => 'Không tìm thấy bài học.';

  @override
  String get grammarArticleNotFound => 'Không tìm thấy bài viết.';

  @override
  String grammarSearchInLevelHint(String level) {
    return 'Tìm bài trong $level...';
  }

  @override
  String grammarSearchResultsCount(int count, String query) {
    return '$count kết quả cho “$query” — tất cả trình độ';
  }

  @override
  String get grammarLeaderboardTitleAll => 'Bảng xếp hạng';

  @override
  String grammarLeaderboardTitleLevel(String level) {
    return 'Bảng xếp hạng $level';
  }

  @override
  String get grammarProgressLabel => 'Tiến trình';

  @override
  String grammarProgressLabelLevel(String level) {
    return 'Tiến trình $level';
  }

  @override
  String get grammarLeaderboardEmpty => 'Chưa có ai tham gia';

  @override
  String grammarYourRank(int rank, int count) {
    return 'Hạng của bạn: #$rank · $count bài';
  }

  @override
  String grammarCompletedOfTotal(int done, int total) {
    return '$done/$total bài đã hoàn thành';
  }

  @override
  String grammarReadTime(int elapsed, int minTime) {
    return '⏱ ${elapsed}s / ${minTime}s';
  }

  @override
  String get grammarScrolled80 => '📜 Đã cuộn 80%';

  @override
  String get grammarScrollNeeded => '📜 Cần cuộn đến 80%';

  @override
  String get grammarReadGateHint =>
      'Nút sẽ mở khi bạn cuộn đến 80% nội dung và đọc đủ thời gian tối thiểu.';

  @override
  String get grammarMarkCompleteXp => 'Đánh dấu hoàn thành (+5 XP)';

  @override
  String get grammarMarkCompleteAgain => 'Hoàn thành lại';

  @override
  String get grammarJustCompleted => '✓ Đã hoàn thành';

  @override
  String get grammarSaving => 'Đang lưu...';

  @override
  String get grammarArticleSource => 'Nguồn: deutsch.vn';

  @override
  String get grammarPracticeExercises => 'Bài tập luyện tập';

  @override
  String get grammarExerciseCorrect => '✓ Chính xác!';

  @override
  String grammarExerciseWrong(String answer) {
    return '✗ Sai. Đáp án đúng: $answer.';
  }

  @override
  String get gamePractice => 'Luyện game';

  @override
  String get community => 'Cộng đồng';

  @override
  String get statistics => 'Thống kê';

  @override
  String get achievements => 'Thành tích';

  @override
  String get leaderboard => 'BXH';

  @override
  String get offlineMessage =>
      'Mất kết nối internet. Một số tính năng có thể bị giới hạn.';

  @override
  String get appearance => 'Giao diện';

  @override
  String get themeMode => 'Chế độ giao diện';

  @override
  String get systemTheme => 'Theo hệ thống';

  @override
  String get lightTheme => 'Sáng';

  @override
  String get darkTheme => 'Tối';

  @override
  String get sound => 'Âm thanh';

  @override
  String get pronunciationVolume => 'Âm lượng phát âm';

  @override
  String get autoplayPronunciation => 'Tự động phát âm';

  @override
  String get autoplayDescription => 'Phát âm thanh khi lật thẻ';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get appLanguage => 'Ngôn ngữ ứng dụng';

  @override
  String get selectLanguage => 'Chọn ngôn ngữ';

  @override
  String get notifications => 'Thông báo';

  @override
  String get learningReminders => 'Thông báo nhắc nhở';

  @override
  String get learningRemindersDescription =>
      'Nhận thông báo hàng ngày để học tập';

  @override
  String get reminderTime => 'Giờ nhắc nhở';

  @override
  String get securityAndAccount => 'Bảo mật & tài khoản';

  @override
  String get security => 'Bảo mật';

  @override
  String get signedInDevices => 'Thiết bị đang đăng nhập';

  @override
  String get signOutOtherDevicesTitle => 'Đăng xuất khỏi thiết bị khác?';

  @override
  String get signOutOtherDevicesBody =>
      'Tất cả phiên đăng nhập khác sẽ bị đăng xuất. Bạn vẫn giữ phiên hiện tại trên thiết bị này.';

  @override
  String get cancel => 'Huỷ';

  @override
  String get signOut => 'Đăng xuất';

  @override
  String get signOutConfirm => 'Bạn chắc chắn muốn đăng xuất?';

  @override
  String get signOutOtherDevices => 'Đăng xuất khỏi tất cả thiết bị khác';

  @override
  String get signedOutOtherDevices => 'Đã đăng xuất khỏi các thiết bị khác.';

  @override
  String get signedOutDevice => 'Đã đăng xuất thiết bị.';

  @override
  String get signOutDeviceTitle => 'Đăng xuất thiết bị này?';

  @override
  String signOutDeviceBody(Object device) {
    return 'Thiết bị \"$device\" sẽ bị đăng xuất khỏi tài khoản của bạn.';
  }

  @override
  String get couldNotSignOut => 'Không thể đăng xuất. Vui lòng thử lại.';

  @override
  String get couldNotLoadDevices => 'Không thể tải danh sách thiết bị.';

  @override
  String get retry => 'Thử lại';

  @override
  String get noSignedInDevices => 'Không có thiết bị nào đang đăng nhập.';

  @override
  String get account => 'Tài khoản';

  @override
  String get deleteAccount => 'Xoá tài khoản';

  @override
  String get deleteAccountDescription =>
      'Xem cách yêu cầu xoá tài khoản và dữ liệu liên quan.';

  @override
  String get accountDeletionUnavailableTitle =>
      'Xoá tài khoản trong ứng dụng chưa khả dụng';

  @override
  String get accountDeletionUnavailableBody =>
      'Để yêu cầu xoá tài khoản và dữ liệu liên quan, hãy liên hệ support@deutschtiger.com từ địa chỉ email đã đăng ký. Ứng dụng không thể xác nhận yêu cầu xoá cho đến khi backend hỗ trợ quy trình này.';

  @override
  String get contactSupport => 'Liên hệ hỗ trợ';

  @override
  String get unknownDevice => 'Thiết bị không xác định';

  @override
  String get currentDevice => 'Hiện tại';

  @override
  String get signOutThisDevice => 'Đăng xuất thiết bị này';

  @override
  String get justNow => 'Vừa xong';

  @override
  String minutesAgo(int count) {
    return '$count phút trước';
  }

  @override
  String hoursAgo(int count) {
    return '$count giờ trước';
  }

  @override
  String daysAgo(int count) {
    return '$count ngày trước';
  }

  @override
  String get securityDevices => 'Bảo mật & thiết bị';

  @override
  String get securityDevicesDescription =>
      'Quản lý phiên đăng nhập, xoá tài khoản';

  @override
  String get changePassword => 'Đổi mật khẩu';

  @override
  String get changeEmail => 'Đổi email';

  @override
  String get exportData => 'Xuất dữ liệu';

  @override
  String get exportDataDescription => 'Yêu cầu bản sao dữ liệu học tập của bạn';

  @override
  String get dataExportUnavailable =>
      'Xuất dữ liệu trong ứng dụng chưa khả dụng. Vui lòng liên hệ support@deutschtiger.com.';

  @override
  String get couldNotOpenLink => 'Không thể mở liên kết này.';

  @override
  String get unexpectedDisplayError => 'Đã xảy ra lỗi khi hiển thị trang này.';

  @override
  String get openLinkError => 'Đã xảy ra lỗi khi mở liên kết.';

  @override
  String get ratingThanks => 'Cảm ơn bạn đã đánh giá!';

  @override
  String get ai => 'AI';

  @override
  String get aiMemorySettings => 'Bộ nhớ & cài đặt AI';

  @override
  String get aiMemoryDescription => 'Cấp độ, bài thi, gợi ý ngữ pháp';

  @override
  String get sendFeedback => 'Gửi phản hồi';

  @override
  String get sendFeedbackDescription => 'Giúp chúng tôi cải thiện ứng dụng';

  @override
  String get feedbackTitle => 'Gửi phản hồi';

  @override
  String get feedbackCategoryBug => 'Lỗi';

  @override
  String get feedbackCategorySuggestion => 'Góp ý';

  @override
  String get feedbackCategoryOther => 'Khác';

  @override
  String get feedbackDescriptionHint => 'Mô tả chi tiết...';

  @override
  String get feedbackMessageRequired => 'Vui lòng nhập nội dung phản hồi.';

  @override
  String get feedbackSent => 'Cảm ơn bạn đã gửi phản hồi!';

  @override
  String get feedbackCouldNotSend => 'Không gửi được phản hồi, thử lại sau.';

  @override
  String get sendAction => 'Gửi';

  @override
  String get about => 'Về ứng dụng';

  @override
  String get version => 'Phiên bản';

  @override
  String get termsOfService => 'Điều khoản sử dụng';

  @override
  String get privacyPolicy => 'Chính sách bảo mật';

  @override
  String get helpCenter => 'Trung tâm trợ giúp';

  @override
  String get rateApp => 'Đánh giá ứng dụng';

  @override
  String get statsScreenTitle => 'Thống kê học tập';

  @override
  String get statsMasteryTitle => 'Độ nhớ từ vựng';

  @override
  String get statsErrorPatternsTitle => 'Lỗi hay gặp';

  @override
  String get statsCurrentStreak => 'Streak hiện tại';

  @override
  String get statsDaysUnit => 'ngày';

  @override
  String get statsCurrentLevel => 'Cấp độ hiện tại';

  @override
  String get statsWordsLearned => 'Từ đã học';

  @override
  String get statsTotalReviews => 'Tổng lượt ôn';

  @override
  String get statsWeeklyXpChartTitle => 'XP 7 ngày qua';

  @override
  String get statsMasteryTrendEmpty =>
      'Chưa có dữ liệu thống kê theo ngày (cập nhật mỗi đêm).';

  @override
  String get statsErrorPatternsEmpty => 'Chưa có dữ liệu lỗi.';

  @override
  String get statsMasteryEmpty =>
      'Chưa có dữ liệu. Hãy ôn vài từ để bắt đầu theo dõi độ nhớ.';

  @override
  String get statsMasteryNew => 'Mới';

  @override
  String get statsMasteryLearning => 'Đang học';

  @override
  String get statsMasteryYoung => 'Đang nhớ';

  @override
  String get statsMasteryMature => 'Thuộc lòng';

  @override
  String get statsMasteryTrendTitle => 'Ôn tập 30 ngày qua';

  @override
  String get statsScreenSubtitle =>
      'Theo dõi tiến độ, thói quen và hiệu suất học mỗi ngày.';

  @override
  String get statsOverviewLevelNote => 'Mở khóa nội dung mới';

  @override
  String get statsOverviewTotalXp => 'Tổng XP';

  @override
  String get statsOverviewXpNote => 'Điểm kinh nghiệm tích lũy';

  @override
  String get statsOverviewStreakNote => 'Chuỗi học liên tiếp';

  @override
  String get statsOverviewBestStreak => 'Streak tốt nhất';

  @override
  String get statsOverviewBestStreakNote => 'Kỷ lục cá nhân';

  @override
  String get statsProgressLevelTitle => 'Tiến độ lên cấp';

  @override
  String statsProgressLevelSubtitle(int level, int nextLevel) {
    return 'Level $level sang $nextLevel';
  }

  @override
  String statsProgressLevelRemaining(int count) {
    return 'Còn $count XP để lên level.';
  }

  @override
  String get statsProgressDailyTitle => 'Mục tiêu XP hôm nay';

  @override
  String get statsProgressDailySubtitle => 'Duy trì thói quen học mỗi ngày';

  @override
  String get statsProgressDailyDone => 'Bạn đã hoàn thành mục tiêu hôm nay.';

  @override
  String statsProgressDailyRemaining(int count) {
    return 'Cần thêm $count XP để đạt mục tiêu.';
  }

  @override
  String statsXpChartWeekTotal(int total) {
    return 'Tổng tuần này: $total XP';
  }

  @override
  String statsXpChartMax(int max) {
    return 'Cao nhất: $max XP';
  }

  @override
  String get statsOnlineTimeTitle => 'Thời gian online 7 ngày';

  @override
  String statsOnlineTimeWeekTotal(String duration) {
    return 'Tổng tuần này: $duration';
  }

  @override
  String statsOnlineTimeToday(String duration) {
    return 'Hôm nay: $duration';
  }

  @override
  String get statsReviewCardsTitle => 'Thống kê ôn tập';

  @override
  String get statsReviewToday => 'Ôn tập hôm nay';

  @override
  String get statsReviewTodayNote => 'Số lượt ôn trong ngày';

  @override
  String get statsReviewWeek => 'Ôn tập tuần này';

  @override
  String get statsReviewWeekNote => 'Tổng trong 7 ngày';

  @override
  String get statsReviewAccuracy => 'Độ chính xác';

  @override
  String get statsReviewAccuracyNote => 'Tỉ lệ trả lời đúng';

  @override
  String get statsReviewDue => 'Cần ôn tập';

  @override
  String get statsReviewDueNote => 'Thẻ đến hạn ôn';

  @override
  String get statsSuggestionsTitle => 'Gợi ý cải thiện';

  @override
  String get statsSuggestionStreak => 'Bắt đầu streak mới hôm nay!';

  @override
  String get statsSuggestionListening => 'Chưa luyện nghe tuần này!';

  @override
  String get statsSuggestionReviewAll =>
      'Ôn đều 3 kỹ năng để tiến bộ nhanh hơn!';

  @override
  String get statsSpacedRepetitionTitle =>
      'Spaced Repetition hoạt động thế nào?';

  @override
  String get statsSpacedRepetitionBody =>
      'Hệ thống dùng thuật toán SM-2 để tối ưu lịch ôn. Từ bạn nhớ tốt sẽ xuất hiện thưa hơn, còn từ khó sẽ quay lại sớm hơn. Cách này giúp tiết kiệm thời gian và tăng khả năng nhớ dài hạn.';

  @override
  String get statsCefrTitle => 'Hồ sơ năng lực';

  @override
  String get statsCefrA1 => 'Sơ cấp';

  @override
  String get statsCefrA2 => 'Tiền trung cấp';

  @override
  String get statsCefrB1 => 'Trung cấp';

  @override
  String get statsCefrB2 => 'Trung cấp cao';

  @override
  String get statsCefrC1 => 'Cao cấp';

  @override
  String get statsCefrC2 => 'Thành thạo';

  @override
  String statsCefrWordsLearned(int count) {
    return '$count từ đã ôn tập';
  }

  @override
  String get statsNearAchievementsTitle => 'Thành tựu sắp đạt';

  @override
  String get statsAchievementsGridTitle => 'Bộ sưu tập thành tựu';

  @override
  String get statsLeaderboardTableTitle => 'Bảng xếp hạng';

  @override
  String statsLeaderboardTop(int count) {
    return 'Top $count';
  }

  @override
  String get statsLeaderboardYou => 'Bạn';

  @override
  String get errorPatternsSubtitle =>
      'Sổ lỗi ngữ pháp, tổng hợp từ bài viết, bài nói và bài thi của bạn.';

  @override
  String get errorPatternsIntroWhy =>
      'Tổng hợp lỗi bạn hay mắc khi viết, do AI chấm.';

  @override
  String get errorPatternsIntroTodo =>
      'Chọn một lỗi và bấm luyện đúng dạng đó.';

  @override
  String get errorPatternsIntroNext =>
      'Sửa được lỗi nào thì tần suất nó giảm dần.';

  @override
  String get errorPatternsDrillWriting => 'Luyện viết';

  @override
  String get errorPatternsDrillArtikel => 'Luyện Der/Die/Das';

  @override
  String get errorPatternsDrillSentenceBuilder => 'Luyện viết câu';

  @override
  String get errorPatternsDrillWordOrder => 'Luyện xếp từ';

  @override
  String get errorPatternsDrillPreposition => 'Luyện giới từ';

  @override
  String get errorPatternsDrillNoun => 'Ôn danh từ';

  @override
  String get errorPatternsDrillSpelling => 'Luyện chính tả';

  @override
  String get errorPatternsDrillGrammar => 'Ôn ngữ pháp';

  @override
  String get errorPatternsDrillTense => 'Luyện thì';

  @override
  String get errorPatternsDrillExam => 'Làm bài thi';

  @override
  String get errorSourceSchreibenExam => 'Thi viết';

  @override
  String get errorSourceSprechen => 'Nói';

  @override
  String get errorSourceSentenceBuilder => 'Luyện câu';

  @override
  String get errorTypeArticleGender => 'Giống danh từ (der/die/das)';

  @override
  String get errorTypeCaseAkkDat => 'Cách (Akkusativ/Dativ)';

  @override
  String get errorTypeVerbConjugation => 'Chia động từ';

  @override
  String get errorTypeVerbPosition => 'Vị trí động từ';

  @override
  String get errorTypeWordOrder => 'Trật tự từ';

  @override
  String get errorTypePreposition => 'Giới từ';

  @override
  String get errorTypePlural => 'Số nhiều';

  @override
  String get errorTypeSpelling => 'Chính tả';

  @override
  String get errorTypePunctuation => 'Dấu câu';

  @override
  String get errorTypeTenseConsistency => 'Nhất quán thì';

  @override
  String get errorTypeOther => 'Khác';

  @override
  String get errorPatternsSortCount => 'Số lần';

  @override
  String get errorPatternsSortRecent => 'Gần đây';

  @override
  String get errorPatternsEmptyTitle => 'Chưa có dữ liệu lỗi';

  @override
  String get errorPatternsEmptyBody =>
      'Hãy luyện viết câu hoặc làm bài thi để bắt đầu theo dõi!';

  @override
  String errorPatternsTimesCount(int count) {
    return '$count lần';
  }

  @override
  String get errorPatternsExample => 'Ví dụ';

  @override
  String get dailyQuoteTitle => 'Câu nói hôm nay';

  @override
  String get dailyQuoteCopySuccess => 'Đã sao chép câu nói!';

  @override
  String get dailyQuoteExploreMore => 'Khám phá thêm';

  @override
  String get dailyQuoteRetryTooltip => 'Tải lại';

  @override
  String get back => 'Quay lại';

  @override
  String get focusSessionTitle => 'Tập trung hôm nay';

  @override
  String focusSessionSummary(int count) {
    return 'Bạn có $count mục cần luyện hôm nay.';
  }

  @override
  String get focusSessionDueWordsTitle => 'Từ tới hạn ôn';

  @override
  String get focusSessionDueWordsEmpty => 'Không có từ nào tới hạn 🎉';

  @override
  String get focusSessionReviewNow => 'Ôn ngay';

  @override
  String get focusSessionExamFailTitle => 'Từ thi sai';

  @override
  String get focusSessionExamFailEmpty => 'Chưa có dữ liệu từ bài thi';

  @override
  String get focusSessionSubtitleWordsTitle => 'Từ từ video';

  @override
  String get focusSessionSubtitleWordsEmpty => 'Chưa có từ nào gặp trong video';

  @override
  String get focusSessionAddToReview => 'Thêm vào ôn';

  @override
  String get focusSessionWeaknessesTitle => 'Lỗi hay gặp';

  @override
  String get focusSessionWeaknessesEmpty =>
      'Chưa có dữ liệu lỗi — hãy luyện viết để nhận phân tích';

  @override
  String focusSessionWeaknessesCount(int count) {
    return '$count loại lỗi ngữ pháp thường gặp';
  }

  @override
  String get focusSessionCaughtUpTitle => 'Bạn đang rất ổn!';

  @override
  String get focusSessionCaughtUpBody =>
      'Chưa có điểm yếu nào cần luyện. Hãy làm một bài kiểm tra hoặc học từ mới để nhận gợi ý cá nhân hóa.';

  @override
  String get focusSessionSubtitle =>
      'Những gì bạn nên luyện ngay bây giờ, dựa trên điểm yếu thật của bạn.';

  @override
  String get focusSessionGoalDefaultCta =>
      'Đặt mục tiêu thi để lộ trình chính xác hơn →';

  @override
  String focusSessionGoalWithDays(String level, int days) {
    return '🎯 Vì bạn thi $level sau $days ngày';
  }

  @override
  String focusSessionGoalNoDays(String level) {
    return '🎯 Vì mục tiêu $level của bạn';
  }

  @override
  String get focusSessionNoHistoryTitle => 'Chưa đủ dữ liệu để tìm điểm yếu';

  @override
  String get focusSessionNoHistoryBody =>
      'Bạn chưa có lịch sử ôn tập nào — hãy lưu vài từ và làm một buổi ôn để hệ thống nhận ra điểm yếu thật của bạn.';

  @override
  String get focusSessionSaveWordsCta => 'Lưu từ mới';

  @override
  String get focusSessionReviewNowCta => 'Ôn ngay';

  @override
  String get focusSessionLearnNewWordsCta => 'Học từ mới';

  @override
  String get focusSessionWeaknessesFooterLink => 'Xem lỗi hay gặp';

  @override
  String get learnerModelTitle => 'Hồ sơ năng lực';

  @override
  String get learnerModelCardsSuffix => 'thẻ đã thuộc';

  @override
  String get learnerModelMasteryHint =>
      'Thuộc = ổn định ghi nhớ từ 21 ngày trở lên (FSRS).';

  @override
  String get learnerModelDueNow => 'Tới hạn ôn';

  @override
  String get learnerModelWeakTotal => 'Điểm yếu';

  @override
  String get learnerModelTotalCards => 'Tổng thẻ';

  @override
  String get learnerModelCoverageTitle => 'Độ phủ theo trình độ';

  @override
  String get learnerModelGrammarWeaknessesTitle => 'Điểm yếu ngữ pháp';

  @override
  String learnerModelErrorCount(int count) {
    return '$count lần sai';
  }

  @override
  String get learnerModelCanDoSectionTitle => 'Việc làm được bằng tiếng Đức';

  @override
  String get learnerModelCanDoEmpty =>
      'Chưa có dữ liệu — luyện sản sinh (viết/nói) để leo thang nhé!';

  @override
  String get learnerModelWeakWordsTitle => 'Điểm yếu cần luyện';

  @override
  String get learnerModelWeakWordsEmpty =>
      'Chưa có từ nào cần luyện thêm. Tuyệt vời!';

  @override
  String learnerModelLapsesCount(int count) {
    return '$count lần quên';
  }

  @override
  String get learnerModelSubtitle =>
      'Độ thành thạo, việc làm được và điểm cần cải thiện.';

  @override
  String get learnerModelReadinessTitle => 'Mức sẵn sàng thi (ước lượng)';

  @override
  String get learnerModelReadinessBasis =>
      'Tính từ: kết quả luyện thi gần đây.';

  @override
  String get learnerModelReadinessNoData =>
      'Chưa đủ dữ liệu — làm vài đề luyện thi để ước lượng độ sẵn sàng.';

  @override
  String learnerModelLevelPracticeCta(String level) {
    return 'Luyện theo cấp $level →';
  }

  @override
  String get learnerModelWeeklyRecapTitle => 'Tuần vừa qua';

  @override
  String get learnerModelWeeklyRecapEmpty =>
      'Chưa có bậc nào leo tuần này — luyện thêm để lên bậc!';

  @override
  String learnerModelWeeklyRecapStreak(int days) {
    return '🔥 Chuỗi sản sinh $days ngày';
  }

  @override
  String get canDoStatusSpoken => 'Nói được 🗣️';

  @override
  String get canDoStatusMastered => 'Làm được ✍️';

  @override
  String get canDoStatusInProgress => 'Đang lên';

  @override
  String get canDoStatusNew => 'Chưa bắt đầu';

  @override
  String get canDoPracticeNow => 'Luyện ngay';

  @override
  String get canDoPracticeTitle => 'Luyện việc làm được';

  @override
  String canDoPracticeProgress(int current, int total) {
    return 'Câu $current/$total';
  }

  @override
  String canDoPracticeInstructionStructure(Object pattern) {
    return 'Viết một câu có dùng $pattern';
  }

  @override
  String canDoPracticeInstructionVocab(Object word) {
    return 'Viết một câu có dùng từ «$word»';
  }

  @override
  String get canDoPracticeInputHint => 'Viết câu tiếng Đức của bạn…';

  @override
  String get canDoPracticeError => 'Không chấm được câu — thử lại sau ít phút.';

  @override
  String get canDoPracticeCorrectedPrefix => 'Sửa';

  @override
  String get canDoPracticeFinish => 'Hoàn thành';

  @override
  String get canDoPracticeNext => 'Câu tiếp theo';

  @override
  String get canDoPracticeSubmitting => 'Đang chấm…';

  @override
  String get canDoPracticeSubmit => 'Nộp câu';

  @override
  String get canDoPracticeNotFound => 'Không tìm thấy mục tiêu này.';

  @override
  String get canDoPracticeAllClear =>
      'Đã viết được hết các khối của mục tiêu này 🎉';

  @override
  String canDoPracticeDone(int correct, int total) {
    return 'Xong! $correct/$total câu đạt — tiến độ đã được ghi vào bản đồ.';
  }

  @override
  String get canDoPracticeBackLink => '← Bản đồ năng lực';

  @override
  String get canDoPracticeBackToMap => 'Về bản đồ năng lực';

  @override
  String get canDoPracticeGoConversation => 'Luyện hội thoại';

  @override
  String get topicExploreTitle => 'Khám phá theo chủ đề';

  @override
  String get topicExploreSubtitle =>
      'Xem hướng từ vựng đang ưu tiên · ghim ⭐ để lái lộ trình';

  @override
  String get learnPageIntroWhy =>
      'Đây là nơi bạn học từ vựng và ngữ pháp mỗi ngày theo lộ trình cá nhân.';

  @override
  String get learnPageIntroTodo =>
      'Làm phiên hôm nay, xem tiến độ A1→C2 và nhiệm vụ tuần.';

  @override
  String get learnPageIntroNext =>
      'Xong phiên hôm nay, quay lại đây để nhận nhiệm vụ tiếp theo.';

  @override
  String get learnPageIntroCta => 'Tới Ôn tập';

  @override
  String get levelJourneyTitle => 'Hành trình A1→C2';

  @override
  String get levelJourneyEmptyLevel => 'đang bổ sung';

  @override
  String get levelJourneyDetailCta => 'Chi tiết →';

  @override
  String get capabilityMapSnapshotTitle => 'Bản đồ năng lực';

  @override
  String capabilityMapMasteredCount(int mastered, int total) {
    return '$mastered/$total việc đã làm được';
  }

  @override
  String get capabilityMapViewCta => 'Xem bản đồ →';

  @override
  String get topicExploreEmpty => 'Chưa có chủ đề nào.';

  @override
  String get topicExploreSubtitleHeader =>
      'Từ vựng hằng ngày tự chọn theo hướng của bạn — ghim ⭐ để lái thêm';

  @override
  String get topicSteeringTitle => 'Lộ trình đang ưu tiên';

  @override
  String get topicSteeringGoalGoethe => '🎓 Thi Goethe';

  @override
  String get topicSteeringGoalConversation => '💬 Giao tiếp';

  @override
  String get topicSteeringGoalNursing => '🏥 Điều dưỡng';

  @override
  String get topicSteeringGoalAbroad => '✈️ Du học · làm việc';

  @override
  String get topicSteeringEmpty =>
      'Chưa có hướng nào — ghim chủ đề bên dưới hoặc đặt mục tiêu trong Cài đặt.';

  @override
  String get topicSteeringFooterHint =>
      'Từ mới trong nhiệm vụ hằng ngày được chọn theo các hướng này, từ thiết yếu trước.';

  @override
  String topicGroupSubtitle(String label, int count) {
    return '$label · $count chủ đề';
  }

  @override
  String get practiceTitle => 'Luyện tập';

  @override
  String get practiceChooseMode => 'Chọn chế độ luyện tập';

  @override
  String get practiceModeCloze => 'Điền từ';

  @override
  String get practiceModeListening => 'Luyện nghe';

  @override
  String get practiceModeMatching => 'Nối từ';

  @override
  String get practiceModeWriting => 'Luyện viết';

  @override
  String get practiceClozeHint => 'Gõ từ tiếng Đức còn thiếu';

  @override
  String get practiceWritingHint => 'Gõ từ tiếng Đức';

  @override
  String get practiceCheckAnswer => 'Kiểm tra';

  @override
  String get practiceListeningPrompt => 'Chạm vào thẻ để lật và xem nghĩa';

  @override
  String get practiceFeedbackCorrect => 'Chính xác!';

  @override
  String practiceFeedbackWrong(String word) {
    return 'Sai rồi — đáp án là \"$word\"';
  }

  @override
  String practiceMatchingProgress(int matched, int total, int attempts) {
    return 'Đã nối $matched/$total · $attempts lần thử';
  }

  @override
  String get practiceMatchingNeedsMoreWords =>
      'Bộ thẻ cần ít nhất 2 từ để chơi nối từ.';

  @override
  String get practiceResultsTitle => 'Hoàn thành!';

  @override
  String practiceAccuracySummary(int correct, int total) {
    return '$correct/$total đúng';
  }

  @override
  String get practiceRestart => 'Luyện lại';

  @override
  String get practiceBackToDeck => 'Quay lại bộ thẻ';

  @override
  String get practiceChangeMode => 'Đổi chế độ';

  @override
  String get practiceBackToGames => 'Về Game';

  @override
  String get practiceNotEnoughWords => 'Chưa đủ từ để luyện tập lúc này.';

  @override
  String get practiceListenPill => 'Nghe';

  @override
  String get practiceHintPill => 'Gợi ý';

  @override
  String practiceHintLetter(String letter) {
    return 'Bắt đầu bằng \"$letter\"';
  }

  @override
  String get practiceRetryAnswer => 'Thử lại';

  @override
  String get practiceMicTooltip => 'Nói để nhập';

  @override
  String get practiceListeningNotYet => 'Chưa nhớ';

  @override
  String get practiceListeningKnown => 'Đã nhớ';

  @override
  String get practiceListeningTapToFlip => '👆 Nhấn để lật';

  @override
  String get practiceListeningMeaningLabel => 'Nghĩa';

  @override
  String get practiceMatchingColumnDe => 'TIẾNG ĐỨC';

  @override
  String get practiceMatchingColumnVi => 'TIẾNG VIỆT';

  @override
  String get subtitleWordsTitle => 'Từ đã gặp trong video';

  @override
  String get subtitleWordsSubtitle =>
      'Những từ bạn đã gặp khi xem video — thêm vào ôn tập chỉ với 1 chạm.';

  @override
  String get subtitleWordsEmpty => 'Chưa có từ phụ đề nào để thêm.';

  @override
  String get subtitleWordsEmptyHint =>
      'Hãy xem video tiếng Đức và chạm vào từ để lưu lại!';

  @override
  String subtitleWordsSeenCount(int count) {
    return 'đã thấy ${count}x';
  }

  @override
  String get subtitleWordsLevelAll => 'Tất cả';

  @override
  String subtitleWordsLevelCount(String level, int count) {
    return '$level · $count';
  }

  @override
  String subtitleWordsSelectedCount(int count) {
    return 'Đã chọn $count từ';
  }

  @override
  String subtitleWordsCountLabel(int count) {
    return '$count từ';
  }

  @override
  String get subtitleWordsSelectAll => 'Chọn tất cả';

  @override
  String get subtitleWordsClearSelection => 'Bỏ chọn';

  @override
  String subtitleWordsAddSelected(int count) {
    return 'Thêm $count từ vào ôn tập';
  }

  @override
  String get subtitleWordsAdding => 'Đang thêm...';

  @override
  String subtitleWordsAddedCount(int count) {
    return 'Đã thêm $count từ!';
  }

  @override
  String get subtitleWordsAddFailed =>
      'Không thể lưu các từ đã chọn. Vui lòng thử lại.';

  @override
  String get practiceModeComingSoon => 'Sắp ra mắt';

  @override
  String get practiceModeSentence => 'Viết câu';

  @override
  String get practiceModeSentenceDesc => 'Nghe + dịch câu hoàn chỉnh';

  @override
  String get practiceModeClozeDesc => 'Điền từ còn thiếu vào câu';

  @override
  String get practiceModeListeningDesc => 'Nghe và lật thẻ đoán nghĩa';

  @override
  String get practiceModeMatchingDesc => 'Nối từ tiếng Đức với nghĩa';

  @override
  String get practiceModeWritingDesc => 'Nghe + xem nghĩa → gõ từ tiếng Đức';

  @override
  String get practiceModeRunner => 'Deutsch Runner';

  @override
  String get practiceModeRunnerDesc => 'Chơi game học từ vựng';

  @override
  String get practiceModeFade => 'Mờ dần';

  @override
  String get practiceModeFadeDesc => 'Che chữ tăng dần, gõ lại cả câu';

  @override
  String get practiceModeDictation => 'Nghe-chép';

  @override
  String get practiceModeDictationDesc => 'Nghe câu rồi gõ lại từng từ';

  @override
  String get practiceModeChaining => 'Nối câu';

  @override
  String get practiceModeChainingDesc => 'Nhớ thứ tự: câu này → câu kế';

  @override
  String get practiceModeGist => 'Viết theo ý';

  @override
  String get practiceModeGistDesc => 'Xem nghĩa + gợi ý → viết lại câu';

  @override
  String get practiceModeSpeaking => 'Luyện nói';

  @override
  String get practiceModeSpeakingDesc => 'Đọc to câu, chấm phát âm';

  @override
  String get practiceIncludeGraduated => 'Bao gồm từ đã thuộc';

  @override
  String practiceCardsReady(int count) {
    return '$count thẻ sẵn sàng';
  }

  @override
  String practiceXpEarned(int xp) {
    return '+$xp XP';
  }

  @override
  String get notificationMarkAllRead => 'Đánh dấu tất cả đã đọc';

  @override
  String get notificationEmpty => 'Không có thông báo nào';

  @override
  String get notificationLoadError =>
      'Không tải được thông báo. Vui lòng thử lại.';

  @override
  String get notificationSomeone => 'Ai đó';

  @override
  String notificationFriendRequest(Object name) {
    return '$name đã gửi lời mời kết bạn';
  }

  @override
  String notificationFriendAccepted(Object name) {
    return '$name đã chấp nhận lời mời kết bạn của bạn';
  }

  @override
  String notificationChallengeInvite(Object name) {
    return '$name thách đấu bạn';
  }

  @override
  String get notificationNewComment => 'Bình luận mới';

  @override
  String get notificationGradingDone => 'AI đã chấm bài viết của bạn';

  @override
  String get notificationDailyReview => 'Có từ cần ôn hôm nay';

  @override
  String get notificationGeneric => 'Bạn có thông báo mới';

  @override
  String get notificationPreferencesTitle => 'Tuỳ chọn thông báo';

  @override
  String get notificationPreferencesEnabledTitle => 'Nhắc nhở học tập';

  @override
  String get notificationPreferencesEnabledDescription =>
      'Nhận thông báo nhắc học hàng ngày';

  @override
  String get notificationPreferencesTime => 'Giờ nhắc nhở';

  @override
  String get notificationPreferencesContentMode => 'Nội dung thông báo';

  @override
  String get notificationPreferencesContentWord => 'Từ vựng';

  @override
  String get notificationPreferencesContentReminder => 'Nhắc nhở';

  @override
  String get notificationPreferencesContentMix => 'Xen kẽ';

  @override
  String get notificationPreferencesSaveError =>
      'Không lưu được. Vui lòng thử lại.';

  @override
  String get learningPreferencesTitle => 'Tuỳ chọn học tập';

  @override
  String get learningPreferencesLevel => 'Trình độ CEFR';

  @override
  String get learningPreferencesDailyMinutes => 'Số phút học mỗi ngày';

  @override
  String get learningPreferencesDailyXpGoal => 'Mục tiêu XP hàng ngày';

  @override
  String get learningPreferencesSaveError =>
      'Không lưu được. Vui lòng thử lại.';

  @override
  String get learningPreferencesLoadError => 'Không tải được tuỳ chọn học tập.';

  @override
  String get checkForUpdates => 'Kiểm tra cập nhật';

  @override
  String get checkForUpdatesDescription =>
      'Xem bạn đang dùng phiên bản mới nhất chưa';

  @override
  String get appUpToDate => 'Bạn đang dùng phiên bản mới nhất';

  @override
  String get appUpdateAvailableTitle => 'Có bản cập nhật mới';

  @override
  String get appUpdateAvailableBody =>
      'Vui lòng cập nhật ứng dụng để tiếp tục sử dụng.';

  @override
  String get appUpdateAction => 'Cập nhật ngay';

  @override
  String get socialHubTitle => 'Cộng đồng';

  @override
  String get socialTabMoments => 'Khoảnh khắc';

  @override
  String get socialTabFriends => 'Bạn bè';

  @override
  String get socialTabRequests => 'Lời mời';

  @override
  String get socialTabSearch => 'Tìm kiếm';

  @override
  String get socialFriendsTitle => 'Bạn bè';

  @override
  String get socialMessagesTitle => 'Tin nhắn';

  @override
  String get socialMomentsTitle => 'Khoảnh khắc';

  @override
  String get socialAnnouncementsTitle => 'Thông báo';

  @override
  String get socialProfileTitle => 'Hồ sơ';

  @override
  String get socialLoadFriendsError => 'Không thể tải danh sách bạn bè.';

  @override
  String get socialLoadRequestsError => 'Không thể tải lời mời kết bạn.';

  @override
  String get socialLoadMessagesError => 'Không thể tải tin nhắn.';

  @override
  String get socialLoadMomentsError => 'Không thể tải khoảnh khắc.';

  @override
  String get socialLoadCommentsError => 'Không thể tải bình luận.';

  @override
  String get socialLoadAnnouncementsError => 'Không thể tải thông báo.';

  @override
  String get socialLoadProfileError => 'Không thể tải hồ sơ.';

  @override
  String get socialSendMessageError =>
      'Không thể gửi tin nhắn. Vui lòng thử lại.';

  @override
  String get socialSearchError => 'Tìm kiếm thất bại.';

  @override
  String get socialNoFriendsYet => 'Chưa có bạn bè';

  @override
  String get socialNoPendingRequests => 'Không có lời mời nào';

  @override
  String get socialNoMessagesYet => 'Chưa có tin nhắn';

  @override
  String get socialNoMomentsYet => 'Chưa có khoảnh khắc nào';

  @override
  String get socialNoCommentsYet => 'Chưa có bình luận nào';

  @override
  String get socialNoAnnouncements => 'Hiện chưa có thông báo';

  @override
  String get socialSearchPrompt => 'Tìm theo tên để kết bạn';

  @override
  String get socialSearchNoResults => 'Không tìm thấy người dùng';

  @override
  String get socialSearchHint => 'Tìm bạn bè…';

  @override
  String get socialChatAction => 'Nhắn tin';

  @override
  String get socialViewProfile => 'Xem hồ sơ';

  @override
  String get socialRemoveFriend => 'Xoá bạn bè';

  @override
  String socialRemoveFriendConfirm(String name) {
    return 'Xoá $name khỏi danh sách bạn bè?';
  }

  @override
  String get socialBlockUser => 'Chặn';

  @override
  String socialBlockUserConfirm(String name) {
    return 'Chặn $name? Người này sẽ không thể liên hệ với bạn nữa.';
  }

  @override
  String get socialBlockUserConfirmGeneric =>
      'Chặn người dùng này? Họ sẽ không thể liên hệ với bạn nữa.';

  @override
  String get socialUserBlocked => 'Đã chặn người dùng';

  @override
  String get socialUserBlockedNotice => 'Bạn đã chặn người dùng này.';

  @override
  String get socialAccept => 'Chấp nhận';

  @override
  String get socialDecline => 'Từ chối';

  @override
  String get socialAddFriend => 'Kết bạn';

  @override
  String get socialRequestSent => 'Đã gửi lời mời';

  @override
  String get socialReportUser => 'Báo cáo';

  @override
  String socialReportEmailSubject(String userId) {
    return 'Báo cáo người dùng $userId';
  }

  @override
  String socialLevelLabel(int level) {
    return 'Cấp $level';
  }

  @override
  String get socialLevelShort => 'Cấp độ';

  @override
  String get socialStreakShort => 'Chuỗi ngày';

  @override
  String get socialFriendsShort => 'Bạn bè';

  @override
  String get socialStartChatting => 'Bắt đầu trò chuyện';

  @override
  String get socialTypeMessageHint => 'Nhập tin nhắn…';

  @override
  String get socialCommentsTitle => 'Bình luận';

  @override
  String get socialOnlineNow => 'Đang online';

  @override
  String socialJoinedOn(String date) {
    return 'Tham gia $date';
  }

  @override
  String get socialLongestStreakShort => 'Dài nhất';

  @override
  String get socialLearningJourneyTitle => 'Hành trình học tập';

  @override
  String get socialWeeklyRankLabel => 'BXH tuần';

  @override
  String get socialWordsLearnedLabel => 'Từ đã học';

  @override
  String get socialTotalReviewsLabel => 'Lần ôn tập';

  @override
  String get socialAchievementsTitle => 'Thành tích';

  @override
  String get socialActivityTimelineTitle => 'Hoạt động gần đây';

  @override
  String get achievementFirstPracticeName => 'Bước đầu';

  @override
  String get achievementFirstPracticeDesc => 'Hoàn thành bài tập đầu tiên';

  @override
  String get achievementStreak3Name => '3 ngày liên tiếp';

  @override
  String get achievementStreak3Desc => 'Duy trì streak 3 ngày';

  @override
  String get achievementStreak7Name => 'Tuần hoàn hảo';

  @override
  String get achievementStreak7Desc => 'Duy trì streak 7 ngày';

  @override
  String get achievementStreak30Name => 'Tháng kỷ luật';

  @override
  String get achievementStreak30Desc => 'Duy trì streak 30 ngày';

  @override
  String get achievementCards10Name => '10 từ vựng';

  @override
  String get achievementCards10Desc => 'Tạo 10 flashcard';

  @override
  String get achievementCards50Name => '50 từ vựng';

  @override
  String get achievementCards50Desc => 'Tạo 50 flashcard';

  @override
  String get achievementCards100Name => '100 từ vựng';

  @override
  String get achievementCards100Desc => 'Tạo 100 flashcard';

  @override
  String get achievementXp500Name => 'Cày 500 XP';

  @override
  String get achievementXp500Desc => 'Đạt 500 XP tổng';

  @override
  String get achievementXp1000Name => 'Nghìn XP';

  @override
  String get achievementXp1000Desc => 'Đạt 1000 XP tổng';

  @override
  String get achievementXp5000Name => 'Cao thủ';

  @override
  String get achievementXp5000Desc => 'Đạt 5000 XP tổng';

  @override
  String get achievementLevel5Name => 'Level 5';

  @override
  String get achievementLevel5Desc => 'Đạt Level 5';

  @override
  String get achievementLevel10Name => 'Level 10';

  @override
  String get achievementLevel10Desc => 'Đạt Level 10';

  @override
  String get achievementReviews100Name => '100 lần ôn';

  @override
  String get achievementReviews100Desc => 'Ôn tập 100 lần';

  @override
  String activityLevelUp(String level) {
    return 'Đạt Level $level';
  }

  @override
  String activityStreakMilestone(String streak) {
    return '$streak ngày liên tiếp';
  }

  @override
  String get activityAchievementUnlockedFallback => 'Thành tích mới';

  @override
  String get activityMissionFallback => 'Nhiệm vụ';

  @override
  String get activityExamFallback => 'Bài thi';

  @override
  String activityDailyReview(String correct, String total) {
    return 'Ôn tập $correct/$total từ';
  }

  @override
  String activityVocabLearned(String count) {
    return 'Học $count từ vựng mới';
  }

  @override
  String get activityVideoFallback => 'Video';

  @override
  String socialFriendsSubtitle(int friends, int requests) {
    return '$friends bạn bè · $requests lời mời';
  }

  @override
  String socialOnlineSectionTitle(int count) {
    return 'Đang online — $count';
  }

  @override
  String socialOfflineSectionTitle(int count) {
    return 'Offline — $count';
  }

  @override
  String socialLevelStreakLabel(int level, int streak) {
    return 'Lv.$level · $streak ngày streak';
  }

  @override
  String get socialSuggestionsTitle => 'Gợi ý kết bạn';

  @override
  String socialConversationsCount(int count) {
    return '$count cuộc trò chuyện';
  }

  @override
  String get socialYouPrefix => 'Bạn';

  @override
  String get socialOffline => 'Offline';

  @override
  String get pinnedShortcutsTitle => '🔗 Lối tắt';

  @override
  String get pinnedShortcutConversation => 'Luyện nói AI';

  @override
  String get pinnedShortcutWriteSentence => 'Viết câu (AI)';

  @override
  String get pinnedShortcutListening => 'Nghe';

  @override
  String get pinnedShortcutYoutube => 'YouTube';

  @override
  String get pinnedShortcutCourse => 'Khóa học';

  @override
  String get exploreSectionTitle => 'Khám phá';

  @override
  String get examCornerOverdue => '📅 Đã qua ngày thi';

  @override
  String examCornerToday(String level) {
    return '🎯 Thi $level hôm nay!';
  }

  @override
  String examCornerCountdown(String provider, String level, int days) {
    return '🎯 $provider $level · còn $days ngày';
  }

  @override
  String get examCornerReadiness => 'Độ sẵn sàng';

  @override
  String get examCornerChangeGoal => 'Đổi mục tiêu';

  @override
  String get examCornerContinue => 'Làm đề';

  @override
  String get examCornerSetNewGoal => 'Đặt mục tiêu mới';

  @override
  String get examGoalPromptTitle => 'Đặt mục tiêu thi';

  @override
  String get examGoalPromptSubtitle =>
      'Đặt ngày thi để theo dõi đếm ngược và luyện đề đúng trình độ.';

  @override
  String get examGoalPromptCta => 'Đặt ngày thi';

  @override
  String examHeroTitle(String provider, String level) {
    return '🎯 Luyện thi $provider $level';
  }

  @override
  String get examHeroToday => 'Thi hôm nay!';

  @override
  String examCornerDaysLeft(int days) {
    return 'Còn $days ngày';
  }

  @override
  String get examHeroNoAttemptsYet => 'Làm đề đầu tiên để đo độ sẵn sàng';

  @override
  String examHeroBasedOnAttempts(int count) {
    return 'Dựa trên $count đề đã làm';
  }

  @override
  String examHeroCta(String provider, String level) {
    return '📝 Làm đề $provider $level';
  }

  @override
  String get examHeroReadyLabel => 'sẵn sàng';

  @override
  String get examGoalSetterTitle => 'Đặt mục tiêu thi';

  @override
  String get examGoalSetterProviderLabel => 'Kỳ thi';

  @override
  String get examGoalSetterLevelLabel => 'Trình độ thi';

  @override
  String get examGoalSetterDateLabel => 'Ngày thi';

  @override
  String get examGoalSetterDateRequired => 'Vui lòng chọn ngày thi';

  @override
  String get examGoalSetterDateInPast => 'Ngày thi không thể trước hôm nay';

  @override
  String get examGoalSetterSave => 'Lưu mục tiêu';

  @override
  String get examGoalSetterSaving => 'Đang lưu...';

  @override
  String get examGoalSetterSaveFailed => 'Lưu thất bại, thử lại sau';

  @override
  String get premiumBannerCta => 'Nâng cấp Premium — học không giới hạn';

  @override
  String get communityLinksTitle => 'Cộng đồng Deutsch Tiger';

  @override
  String get communityZaloDescription => 'Nhóm học tiếng Đức';

  @override
  String get communityFacebookDescription => 'Deutsch Tiger VN';

  @override
  String get examReadinessGoalHeaderLabel => 'Đang luyện cho';

  @override
  String get examReadinessGoalDaysLeft => 'ngày đến kỳ thi';

  @override
  String get examReadinessGoalTodayLabel => 'Hôm nay là ngày thi!';

  @override
  String get examReadinessGoalSetDate => 'Đặt ngày thi';

  @override
  String get examReadinessScoreTrendLabel => 'Xu hướng điểm';

  @override
  String examReadinessScoreTrendDelta(String delta) {
    return '$delta điểm';
  }

  @override
  String examReadinessScoreTrendRecentCount(int n) {
    return '$n lần gần nhất';
  }

  @override
  String get examReadinessScoreTrendLatestPrefix => 'Gần nhất: ';

  @override
  String get examReadinessRecentAvgLabel => 'Điểm TB gần đây';

  @override
  String examReadinessSkillPracticeCta(String skill) {
    return 'Luyện $skill';
  }

  @override
  String examReadinessAttemptCountSuffix(int n) {
    return '$n lần';
  }

  @override
  String get examReadinessWeaknessPracticeCta => 'Luyện điểm yếu →';

  @override
  String get examReadinessWeaknessDrillCta => 'Luyện →';

  @override
  String get examReadinessTodoTitle => 'Việc cần làm';

  @override
  String get examReadinessTodoDueReviewsPrefix => 'Bạn có ';

  @override
  String examReadinessTodoDueReviewsBold(int n) {
    return '$n từ tới hạn ôn';
  }

  @override
  String get examReadinessIntroWhy =>
      'Xem bạn đã sẵn sàng cho kỳ thi tới mức nào, theo từng kỹ năng.';

  @override
  String get examReadinessIntroTodo =>
      'Nhìn kỹ năng yếu nhất và bấm luyện ngay.';

  @override
  String get examReadinessIntroNext =>
      'Luyện xong quay lại xem điểm cải thiện.';

  @override
  String scheduleBuddyCountFire(int n) {
    return '🔥 $n bạn còn hạn lịch thi';
  }

  @override
  String scheduleBuddyCountSoon(int n) {
    return '· $n người thi trong 30 ngày tới';
  }

  @override
  String scheduleBuddyCountPast(int n) {
    return '· $n đã thi';
  }

  @override
  String get scheduleSearchHint => 'Tìm theo tên / loại thi...';

  @override
  String get scheduleFilterAllExamTypes => 'Tất cả kì thi';

  @override
  String get scheduleFilterAllLevels => 'Tất cả trình độ';

  @override
  String scheduleStatusUpcomingCount(int n) {
    return 'Còn hạn ($n)';
  }

  @override
  String scheduleStatusPastCount(int n) {
    return 'Đã thi ($n)';
  }

  @override
  String scheduleResultCountUpcoming(int n) {
    return '$n người · gần ngày thi nhất xếp trước';
  }

  @override
  String scheduleResultCountPast(int n) {
    return '$n người · thi gần đây xếp trước';
  }

  @override
  String get scheduleEmptyUpcoming =>
      'Không có ai còn hạn lịch thi khớp bộ lọc này.';

  @override
  String get scheduleEmptyPast => 'Không có ai đã thi khớp bộ lọc này.';

  @override
  String scheduleMyPlansCount(int n) {
    return '$n lịch thi · gần ngày thi nhất xếp trước';
  }

  @override
  String get scheduleMyPlansEmpty => 'Bạn chưa đăng ký lịch thi nào';

  @override
  String get schedulePrivacyNotePrefix =>
      '🔒 Liên hệ của bạn (SĐT, email, Facebook) ';

  @override
  String get schedulePrivacyNoteBold => 'ẩn mặc định';

  @override
  String get schedulePrivacyNoteSuffix =>
      ' — chỉ thành viên đã đăng ký mới xem được.';

  @override
  String scheduleBuddyDaysAgo(int n) {
    return 'Đã thi $n ngày trước';
  }

  @override
  String get scheduleBuddyToday => 'Thi hôm nay!';

  @override
  String scheduleBuddyDaysLeft(int n) {
    return 'Còn $n ngày';
  }

  @override
  String get dictationActivityMenuPrompt => 'Chọn hoạt động luyện nghe:';

  @override
  String get dictationActivityClozeTitle => 'Điền từ vào chỗ trống';

  @override
  String get dictationActivityClozeDesc => 'Nghe và gõ từ còn thiếu';

  @override
  String get dictationActivityFullTitle => 'Nghe chép chính tả';

  @override
  String get dictationActivityFullDesc => 'Nghe từng câu và gõ lại cả câu';

  @override
  String get dictationActivityKaraokeTitle => 'Nghe & đọc theo';

  @override
  String get dictationActivityKaraokeDesc =>
      'Phụ đề chạy theo audio, chạm từ để tra nghĩa';

  @override
  String dictationWordsCount(int n) {
    return '$n từ';
  }

  @override
  String get dictationWordSelectHint =>
      'Chạm vào những từ gạch chân trong bài để chọn từ muốn luyện, rồi bấm Bắt đầu.';

  @override
  String get dictationWordSelectCtaEmpty => 'Chọn ít nhất 1 từ để bắt đầu';

  @override
  String dictationWordSelectCta(int n) {
    return 'Bắt đầu luyện nghe — $n từ';
  }

  @override
  String get dictationBackToSelection => '← Chọn lại';

  @override
  String dictationWordCount(int answered, int total) {
    return '$answered / $total từ';
  }

  @override
  String get dictationTypeWordHint => 'Gõ từ...';

  @override
  String get dictationPlayingAudioHint => 'Đang phát audio...';

  @override
  String get dictationCheckCta => 'Kiểm tra';

  @override
  String get dictationReplaySentenceTooltip => 'Nghe lại câu';

  @override
  String get dictationClozeSkip => 'Bỏ qua';

  @override
  String get dictationClozeReveal => 'Xem đáp án';

  @override
  String get dictationNoWordsToPractice => 'Không có từ nào để luyện.';

  @override
  String get dictationBackToWordSelection => '← Quay lại chọn từ';

  @override
  String get dictationClozeResultTitle => 'Kết quả luyện nghe';

  @override
  String get dictationClozeBackLabel => 'Chọn từ khác';

  @override
  String get dictationClozeMistakesTitle => 'Từ cần ôn lại';

  @override
  String get dictationEndRetry => 'Luyện lại';

  @override
  String dictationEndCorrectCount(int correct, int total) {
    return '$correct / $total đúng';
  }

  @override
  String get dictationFullBackLabel => 'Chọn bài';

  @override
  String get dictationFullResultTitle => 'Kết quả chép chính tả';

  @override
  String get dictationFullNextClip => 'Bài tiếp theo →';

  @override
  String get dictationReplayThisSentence => 'Nghe lại câu này';

  @override
  String get dictationTypeSentenceHint => 'Gõ câu bạn nghe được...';

  @override
  String dictationSentenceProgress(int idx, int count) {
    return '$idx / $count câu';
  }

  @override
  String dictationCorrectCount(int n) {
    return '$n đúng';
  }

  @override
  String get dictationNextSentence => 'Câu tiếp →';

  @override
  String get dictationShowResult => 'Xem kết quả';

  @override
  String get dictationNoAudioData =>
      'Bài nghe này chưa có dữ liệu chấm chính tả.';

  @override
  String get dictationBackPlain => '← Quay lại';

  @override
  String get dictationKaraokeBackToMenu => '← Chọn hoạt động';

  @override
  String get dictationKaraokeHint =>
      'Bấm ▶ để nghe — phụ đề tự chạy theo audio. Chạm vào câu để nghe lại từ đó.';

  @override
  String get dictationKaraokeUntimed => '(không có phụ đề đồng bộ)';

  @override
  String get dictationKaraokePrev => '◀ Bài trước';

  @override
  String get dictationKaraokeNext => 'Bài sau ▶';

  @override
  String get deThiHeroTitle => 'Đề thi tiếng Đức';

  @override
  String get deThiHeroSubtitle =>
      'Luyện đề đọc hiểu song ngữ Đức–Việt. Miễn phí, chấm điểm tại chỗ, không cần đăng nhập.';

  @override
  String get deThiStartCta => 'Bắt đầu làm →';

  @override
  String get deThiLoginCta => 'Đăng nhập';

  @override
  String get deThiPromoTitle => 'Học tiếng Đức toàn diện hơn';

  @override
  String get deThiPromoSubtitle => 'Flashcard · Luyện nói AI · Đề thi B1/B2';

  @override
  String get deThiPromoCta => 'Thử ngay →';

  @override
  String deThiPassageLabel(int index) {
    return 'ĐOẠN $index';
  }

  @override
  String deThiPassageOf(int index) {
    return 'Đoạn $index';
  }

  @override
  String deThiPassageAnsweredCount(int answered, int total) {
    return '$answered/$total câu';
  }

  @override
  String get deThiTranslatePassage => 'Dịch đoạn văn';

  @override
  String get deThiHideTranslation => 'Ẩn bản dịch';

  @override
  String get deThiTranslateVi => 'Dịch tiếng Việt';

  @override
  String get deThiHideExplanation => 'Ẩn giải thích';

  @override
  String get deThiExplanation => 'Giải thích';

  @override
  String get deThiVietnameseTranslationHeading => 'BẢN DỊCH TIẾNG VIỆT';

  @override
  String get deThiPrevPassage => 'Đoạn trước';

  @override
  String get deThiNextPassage => 'Đoạn tiếp';

  @override
  String deThiCorrectCountLabel(int correct, int total) {
    return '$correct/$total câu đúng';
  }

  @override
  String deThiScoreLabel(String score) {
    return '$score điểm';
  }

  @override
  String get communityTabBrowse => 'Duyệt đề';

  @override
  String get communityTabContribute => 'Đóng góp';

  @override
  String get communityTabMine => 'Đề của tôi';

  @override
  String get communityContributeComingSoon =>
      'Tính năng đóng góp đề thi đang được phát triển.\nHãy quay lại sau nhé!';

  @override
  String get communityMineEmptyGated =>
      'Bạn chưa đóng góp đề nào — tính năng này sắp ra mắt.';

  @override
  String get communitySearchHint => 'Tìm đề...';

  @override
  String get communityFilterAll => 'Tất cả';

  @override
  String get communityFilterGoetheWriting => 'Goethe Viết';

  @override
  String get communityFilterTelcSpeaking => 'Telc Nói';

  @override
  String communityTeilLabel(int n) {
    return 'Teil $n';
  }

  @override
  String get communityBackLink => 'Quay lại';

  @override
  String get communityBadgeLabel => 'Cộng đồng';

  @override
  String get communityHiddenBanner =>
      '⚠️ Đề này đã bị ẩn do nhận nhiều báo cáo.';

  @override
  String get communityRealExamBadge => 'Đề thật';

  @override
  String get communityTakeExamAction => 'Tôi vừa thi';

  @override
  String get communityReportAction => 'Báo cáo';

  @override
  String get communityGatedTooltip => 'Tính năng đang được phát triển';

  @override
  String get communityAnonymousContributor => 'Ẩn danh';

  @override
  String get communitySectionTask => '📝 Đề bài';

  @override
  String get communitySectionAnalysis => '📋 Phân tích đề';

  @override
  String get communitySectionModelAnswer => '✍️ Bài mẫu';

  @override
  String get communitySectionUsefulPhrases => '💡 Cụm từ hữu ích';

  @override
  String get communitySectionGrammar => '📖 Ngữ pháp trọng tâm';

  @override
  String get communitySectionMistakes => '⚠️ Lỗi thường gặp';

  @override
  String get communitySectionSpeakingContent => '🎙️ Nội dung';

  @override
  String get examHeaderDefaultTitle => 'Phần thi';

  @override
  String get examBackToResult => 'Kết quả';

  @override
  String get examPaceOnTrack => 'Đúng tiến độ';

  @override
  String get examPaceSlow => 'Hơi chậm';

  @override
  String get examPaceBehind => 'Cần nhanh hơn';

  @override
  String get examReaderGuideTooltip => 'Hướng dẫn đọc';

  @override
  String get examReaderGuideTitle => 'Mẹo đọc bài';

  @override
  String get examReaderGuideBody =>
      'Bật tra từ để chạm vào 1 từ và xem nghĩa ngay. Bật tô màu để đánh dấu từ khó. Chỉnh cỡ chữ trong Cài đặt hiển thị.';

  @override
  String get examReaderGuideEnableWordLookup => 'Bật tra từ';

  @override
  String get examReaderSettingsTooltip => 'Cài đặt hiển thị';

  @override
  String get examReaderSettingsTitle => 'Cài đặt hiển thị';

  @override
  String get examReaderSettingsFontSize => 'Cỡ chữ';

  @override
  String get examReaderSettingsHighlight => 'Tô màu từ';

  @override
  String get examReaderSettingsWordLookup => 'Tra từ khi chạm';

  @override
  String get examReadingPaneTitle => 'Đoạn văn';

  @override
  String get examTranslateParagraph => 'Dịch đoạn văn';

  @override
  String get examHideTranslation => 'Ẩn bản dịch';

  @override
  String get examNavPrevQuestion => 'Câu trước';

  @override
  String get examNavNextQuestion => 'Câu tiếp';

  @override
  String get examNavOpenSheet => 'Bảng câu hỏi';

  @override
  String get examNavSheetTitle => 'Danh sách câu hỏi';

  @override
  String get examNavSheetPracticeTitle => 'Luyện tập';

  @override
  String get examNavLegendCurrent => 'Đang xem';

  @override
  String get examNavLegendAnswered => 'Đã làm';

  @override
  String get examNavLegendWrong => 'Sai';

  @override
  String get examNavLegendUnanswered => 'Chưa làm';

  @override
  String examNavStatCorrect(int count) {
    return '$count Đúng';
  }

  @override
  String examNavStatWrong(int count) {
    return '$count Sai';
  }

  @override
  String examNavStatUnanswered(int count) {
    return '$count Chưa làm';
  }

  @override
  String get examCommentsTitle => 'Bình luận';

  @override
  String get examCommentsEmpty => 'Chưa có bình luận nào.';

  @override
  String get examCommentsPlaceholder => 'Viết bình luận...';

  @override
  String get examCommentsSend => 'Gửi';

  @override
  String get examCommentsError => 'Không tải được bình luận.';

  @override
  String get examCommentsSendError =>
      'Gửi bình luận thất bại. Vui lòng thử lại.';

  @override
  String get examResultHeaderFallback => 'Kết quả bài thi';

  @override
  String get examResultScoreLabel => 'Điểm số';

  @override
  String get examResultMotivationPassedTitle => 'Đạt rồi!';

  @override
  String get examResultMotivationPassedBody =>
      'Làm tốt lắm! Bạn đã vượt qua ngưỡng đậu!';

  @override
  String get examResultMotivationFailTitle => 'Cố lên!';

  @override
  String get examResultMotivationFailBody =>
      'Chưa đạt — ôn lại phần sai và thử lại nhé!';

  @override
  String get examResultStatSkipped => 'Bỏ qua';

  @override
  String get examSmartReviewTitle => 'Gợi ý ôn sau bài thi';

  @override
  String get examSmartReviewSubtitle => 'Tập trung vào câu sai và phần yếu.';

  @override
  String examSmartReviewPointsNeeded(int count) {
    return '$count điểm cần ôn';
  }

  @override
  String get examSmartReviewJumpToWrong => 'Xem câu sai';

  @override
  String get examSmartReviewPracticeSections => 'Luyện từng phần';

  @override
  String get examSmartReviewWrongReview => 'Ôn lỗi cá nhân';

  @override
  String get examAttemptHistoryTitle => 'Lịch sử làm bài';

  @override
  String get examAttemptHistoryEmpty => 'Chưa có lịch sử';

  @override
  String get examAttemptModePractice => 'Luyện';

  @override
  String get writingMyEssaysLink => 'Bài của tôi →';

  @override
  String get writingHistoryTooltip => 'Lịch sử bài viết';

  @override
  String get writingYourEssay => 'Bài viết của bạn';

  @override
  String get writingDraftSaved => '💾 Đã lưu nháp';

  @override
  String get writingSubmittedBadge => 'Đã nộp';

  @override
  String writingWordCount(int count) {
    return '$count từ';
  }

  @override
  String writingRestorePromptSaved(String time, int count) {
    return 'Có bản nháp lưu lúc $time ($count từ). Khôi phục?';
  }

  @override
  String get writingRestore => 'Khôi phục';

  @override
  String get writingDiscard => 'Bỏ';

  @override
  String get writingEditorPlaceholder =>
      'Schreiben Sie hier Ihre Antwort... (Viết bài của bạn ở đây)';

  @override
  String get writingSubmitCta => 'Nộp bài viết';

  @override
  String get writingSubmitting => 'Đang nộp...';

  @override
  String get writingRegrade => 'Chấm lại với AI';

  @override
  String get writingGrading => 'Đang chấm...';

  @override
  String get writingMinWordsHint => 'Tối thiểu 10 từ';

  @override
  String get writingEditEssay => 'Sửa bài viết';

  @override
  String get writingGradeWithAi => 'Sửa với AI';

  @override
  String get writingRetry => 'Làm lại';

  @override
  String writingRetryIn(int seconds) {
    return 'Thử lại sau ${seconds}s';
  }

  @override
  String get writingClose => 'Đóng';

  @override
  String get writingFeedbackUpdateHint =>
      'Phản hồi AI — chấm lại để cập nhật kết quả mới';

  @override
  String get writingRewriteTitle => 'Viết lại sau góp ý';

  @override
  String get writingRewriteDesc =>
      'Tạo một bản sửa mẫu để so sánh, rồi đưa vào khung soạn thảo nếu muốn chỉnh tiếp.';

  @override
  String get writingCreateRewrite => 'Tạo bản sửa mẫu';

  @override
  String get writingRecreateRewrite => 'Tạo lại bản sửa';

  @override
  String get writingCreatingRewrite => 'Đang tạo...';

  @override
  String get writingUseRewrite => 'Đưa vào khung để chỉnh tiếp';

  @override
  String get writingBeforeFix => 'Trước khi sửa';

  @override
  String get writingAfterFix => 'Sau khi sửa';

  @override
  String get writingGradeCategoryTask => 'Hoàn thành đề bài';

  @override
  String get writingGradeCategoryGrammar => 'Ngữ pháp';

  @override
  String get writingGradeCategoryVocab => 'Từ vựng';

  @override
  String get writingGradeCategoryCoherence => 'Liên kết & mạch lạc';

  @override
  String get writingCommonErrorsTitle => 'Lỗi hay gặp trong bài này';

  @override
  String get writingDetailedAssessment => 'Chi tiết đánh giá';

  @override
  String writingSuggestionsTitle(int count) {
    return '💡 Gợi ý viết tự nhiên hơn ($count)';
  }

  @override
  String writingCorrectionsTitle(int count) {
    return 'Sửa lỗi ($count)';
  }

  @override
  String writingFocusLink(int count) {
    return '🔁 Vá lỗi ngữ pháp ở Tập trung ($count lỗi)';
  }

  @override
  String writingGoetheBreakdownTitle(String teilLabel) {
    return 'Đánh giá Goethe — $teilLabel';
  }

  @override
  String get writingGoetheInhalt => 'Inhalt (Nội dung)';

  @override
  String get writingGoetheKommunikative => 'Kommunikative (Giao tiếp)';

  @override
  String get writingGoetheFormale => 'Formale (Hình thức)';

  @override
  String get writingHistoryTitle => 'Lịch sử bài viết';

  @override
  String get writingHistoryEmpty => 'Chưa có bài viết nào';

  @override
  String writingScorePoints(int score) {
    return '$score/100';
  }

  @override
  String get goetheB1HubTitle => 'Goethe-Zertifikat B1';

  @override
  String get goetheB1HubSubtitle => '3 bộ đề luyện thi';

  @override
  String get goetheB1HubOfficialTitle => 'Bộ đề thi chính thức';

  @override
  String get goetheB1HubOfficialDesc =>
      '30+ đề luyện thi đầy đủ · Lesen · Hören · Schreiben';

  @override
  String get goetheB1HubWritingTitle => 'Bộ đề viết thực tế';

  @override
  String get goetheB1HubWritingDesc =>
      '30 đề Schreiben theo chủ đề · Teil 1 · Teil 2 · Teil 3';

  @override
  String get goetheB1HubSpeakingTitle => 'Luyện nói (Sprechen)';

  @override
  String get goetheB1HubSpeakingDesc =>
      'Đề nói theo chủ đề · Teil 1 · Teil 2 · Teil 3';

  @override
  String get goetheB1WritingEyebrow => 'Goethe B1 · 3 phần · 100 Punkte';

  @override
  String get goetheB1WritingHeadingPrefix => 'Viết — ';

  @override
  String get goetheB1WritingHeadingSchreiben => 'Schreiben';

  @override
  String get goetheB1WritingBadgeReal => 'Đề thi thật';

  @override
  String get goetheB1WritingBadgeYears => '2023–2026';

  @override
  String get goetheB1WritingBadgeQuality => 'Bài mẫu chất lượng';

  @override
  String get goetheB1WritingHeroPitch =>
      'Luyện đúng format Goethe B1 với bộ đề sát thi thật để vào phòng thi tự tin hơn.';

  @override
  String get goetheB1WritingHeroDesc =>
      'Schreiben gồm 3 Teil bám sát cấu trúc bài thi Goethe B1, tuyển chọn từ đề thật giai đoạn 2023–2026 và chủ đề mới do cộng đồng bổ sung liên tục. Mỗi phần đều giúp bạn xem đề mẫu, ôn cấu trúc câu, học cách triển khai ý và luyện viết từng bước với bài mẫu đáng tin cậy.';

  @override
  String get goetheB1WritingStatSourceLabel => 'Nguồn luyện';

  @override
  String get goetheB1WritingStatSourceValue => 'Đề thi Goethe thật';

  @override
  String get goetheB1WritingStatTopicsLabel => 'Chủ đề hiện có';

  @override
  String goetheB1WritingStatTopicsValue(int count) {
    return '$count+ chủ đề';
  }

  @override
  String get goetheB1WritingStatValueLabel => 'Giá trị luyện tập';

  @override
  String get goetheB1WritingStatValueValue => 'Mẫu viết + từng bước';

  @override
  String get goetheB1WritingLoadingTopics => 'Đang tải...';

  @override
  String get goetheB1WritingAllExamsLink => '← Tất cả kỳ thi luyện viết';

  @override
  String get goetheB1WritingMyEssaysLink => 'Bài của tôi →';

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
      'Viết thư / email cá nhân cho bạn bè';

  @override
  String get goetheB1WritingTeil2Subtitle => 'Bày tỏ ý kiến trên diễn đàn';

  @override
  String get goetheB1WritingTeil3Subtitle =>
      'Email trang trọng: xin lỗi, đặt hẹn, đăng ký';

  @override
  String get conversationHubTitle => 'Hội thoại (AI)';

  @override
  String get conversationHubSubtitle => 'Alltagsdeutsch · Khám phá & luyện nói';

  @override
  String get conversationHubLoadError => 'Không thể tải danh sách kịch bản.';

  @override
  String get conversationTabScenarios => 'Kịch bản';

  @override
  String get conversationTabHistory => 'Lịch sử luyện tập';

  @override
  String get conversationHeroBadge => 'AI tạo hội thoại tức thì';

  @override
  String get conversationHeroTitle => 'Bạn muốn luyện nói về điều gì hôm nay?';

  @override
  String get conversationHeroSearchHint =>
      'Gõ chủ đề bất kỳ hoặc tìm chủ đề có sẵn…';

  @override
  String get conversationHeroCreateNow => 'Tạo ngay';

  @override
  String get conversationHeroUpgrade => 'Nâng Plus ✨';

  @override
  String get conversationHeroTryNow => 'Thử ngay:';

  @override
  String conversationQuotaFreeRemaining(int remaining, int max) {
    return 'Còn $remaining/$max bài miễn phí hôm nay';
  }

  @override
  String conversationQuotaWalled(int max) {
    return 'Đã dùng hết $max/$max bài hội thoại hôm nay';
  }

  @override
  String get conversationQuotaUnlimited => 'Không giới hạn';

  @override
  String get conversationFilterLibraryTitle => 'Hoặc chọn từ thư viện';

  @override
  String conversationFilterResultCount(int count) {
    return '$count chủ đề';
  }

  @override
  String get conversationFilterClear => 'Xoá lọc';

  @override
  String get conversationFilterCategory => 'Thể loại';

  @override
  String get conversationFilterLevel => 'Cấp độ';

  @override
  String get conversationFilterAll => 'Tất cả';

  @override
  String conversationCreateCustomTitle(String topic) {
    return 'Tạo chủ đề riêng: „$topic”';
  }

  @override
  String get conversationCreateCustomHint =>
      'Không có sẵn — để AI soạn một hội thoại mới cho bạn';

  @override
  String get conversationEmptyNoResults => 'Không tìm thấy chủ đề';

  @override
  String get conversationEmptyNoResultsHint =>
      'Thử gõ chủ đề riêng ở ô phía trên nhé!';

  @override
  String get conversationHistoryLoadError => 'Không thể tải lịch sử luyện tập.';

  @override
  String get conversationHistoryEmpty => 'Chưa có bài luyện tập nào được lưu.';

  @override
  String get conversationHistoryEmptyHint =>
      'Hoàn thành một cuộc hội thoại để lưu lại đây.';

  @override
  String conversationHistoryMeta(String level, int turns, String date) {
    return '$level · $turns lượt · $date';
  }

  @override
  String get conversationHistoryDelete => 'Xóa';

  @override
  String get conversationHistoryCancel => 'Hủy';

  @override
  String get conversationHistoryDetailLoadError =>
      'Không tải được bài hội thoại đã lưu.';

  @override
  String get conversationHistoryBackToList => 'Về danh sách';

  @override
  String get conversationLoadError =>
      'Không thể tải kịch bản. Vui lòng thử lại.';

  @override
  String get conversationBack => 'Quay lại';

  @override
  String get conversationContextLabel => 'Tình huống';

  @override
  String get conversationYourRoleLabel => 'Vai bạn:';

  @override
  String get conversationListen => 'Nghe';

  @override
  String get conversationExaminerButton => 'Giám khảo';

  @override
  String get conversationExaminerTitle => '⚖️ Giám khảo AI';

  @override
  String get conversationExaminerCoverageTitle => 'Nội dung cần đề cập';

  @override
  String get conversationExaminerVerdictPending =>
      'Đánh giá tổng thể đang được phát triển.';

  @override
  String get conversationExaminerNoVerdict => 'Chưa có đánh giá cho bài này.';

  @override
  String get conversationExit => 'Thoát';

  @override
  String get conversationExitConfirmTitle => 'Thoát hội thoại?';

  @override
  String get conversationExitConfirmBody =>
      'Tiến trình hiện tại sẽ không được lưu.';

  @override
  String get conversationExitConfirmCta => 'Thoát';

  @override
  String get conversationExitCancelCta => 'Tiếp tục';

  @override
  String get conversationComposerHint => 'Nhập hoặc nói tiếng Đức...';

  @override
  String get conversationComposerModeText => 'Viết';

  @override
  String get conversationComposerModeVoice => 'Mic';

  @override
  String get conversationSuggestionsTitle => 'Gợi ý';

  @override
  String get conversationSuggestionsPending =>
      'Gợi ý câu trả lời đang được phát triển.';

  @override
  String get conversationVoiceTapToSpeak => 'Nhấn để nói';

  @override
  String get conversationVoiceComingSoon => 'Tính năng nói sẽ sớm ra mắt.';

  @override
  String get conversationVoiceBackToText => 'Quay lại gõ';

  @override
  String get conversationDoneTitle => 'Hoàn thành hội thoại!';

  @override
  String conversationDoneSubtitle(String title, int turns) {
    return '$title · $turns lượt hội thoại';
  }

  @override
  String get conversationDoneRestart => 'Thực hành lại';

  @override
  String get conversationDoneChooseAnother => 'Chọn kịch bản khác';

  @override
  String get interviewImportTitle => 'Luyện phỏng vấn từ tài liệu';

  @override
  String get interviewImportDesc =>
      'Dán tài liệu chuẩn bị → AI tạo buổi phỏng vấn; câu trả lời bạn soạn thành gợi ý.';

  @override
  String get interviewImportBackToEdit => 'Sửa tài liệu';

  @override
  String get interviewImportDocLabel => 'Tài liệu phỏng vấn';

  @override
  String get interviewImportDocHint =>
      'Dán câu hỏi + câu trả lời bạn đã chuẩn bị...';

  @override
  String get interviewImportLevelLabel => 'Trình độ (CEFR)';

  @override
  String get interviewImportExtract => '✨ Trích xuất câu hỏi';

  @override
  String get interviewImportExtracting => 'Đang trích xuất...';

  @override
  String get interviewImportTitleLabel => 'Tên buổi phỏng vấn';

  @override
  String get interviewImportEditHint =>
      'Kiểm tra & sửa câu hỏi và gợi ý trước khi lưu. Gợi ý chỉ hiển thị cho bạn, AI không thấy.';

  @override
  String interviewImportQuestionLabel(int n) {
    return 'Câu $n';
  }

  @override
  String get interviewImportQuestionDeHint => 'Câu hỏi phỏng vấn (tiếng Đức)';

  @override
  String get interviewImportQuestionViHint => 'Dịch nghĩa (tiếng Việt)';

  @override
  String get interviewImportHintDeHint =>
      'Gợi ý — câu trả lời bạn chuẩn bị (tiếng Đức)';

  @override
  String get interviewImportHintViHint => 'Gợi ý (tiếng Việt)';

  @override
  String get interviewImportAddQuestion => '+ Thêm câu hỏi';

  @override
  String get interviewImportSave => 'Lưu & bắt đầu luyện';

  @override
  String get interviewImportSaving => 'Đang lưu...';

  @override
  String get pronunciationHubTitle => 'Luyện Phát Âm Tiếng Đức';

  @override
  String get pronunciationHubInfoBanner =>
      'Phát âm đúng từ đầu giúp bạn tự tin hơn khi nói và tránh hiểu nhầm. Mỗi mô-đun tập trung vào một nhóm âm khó — luyện từng bước, nghe và bắt chước.';

  @override
  String get pronunciationHubUmlauteTitle => 'Umlaute (ä, ö, ü)';

  @override
  String get pronunciationHubUmlauteDesc =>
      'Phân biệt và luyện 3 nguyên âm biến thể đặc trưng của tiếng Đức';

  @override
  String get pronunciationHubIchAchTitle => 'Ich-laut / Ach-laut';

  @override
  String get pronunciationHubIchAchDesc =>
      'Phân biệt ch sau nguyên âm trước và sau';

  @override
  String get pronunciationHubRSoundTitle => 'R-Sound';

  @override
  String get pronunciationHubRSoundDesc =>
      'Âm r cổ họng đặc trưng của tiếng Đức';

  @override
  String get pronunciationHubSpStTitle => 'Sp / St Ban đầu';

  @override
  String get pronunciationHubSpStDesc => 'sp → shp, st → sht ở đầu từ và vần';

  @override
  String get pronunciationLoadError =>
      'Không thể tải dữ liệu. Vui lòng thử lại.';

  @override
  String get pronunciationRetry => 'Thử lại';

  @override
  String get pronunciationNoData => 'Chưa có dữ liệu luyện tập.';

  @override
  String get pronunciationCompletedTitle => 'Hoàn thành!';

  @override
  String pronunciationScoreCorrect(int score, int total) {
    return '$score / $total đúng';
  }

  @override
  String get pronunciationRetryCta => 'Luyện lại';

  @override
  String get pronunciationBackCta => 'Quay lại';

  @override
  String get pronunciationHintLabel => 'Mẹo phát âm:';

  @override
  String get pronunciationPlayCta => 'Nghe phát âm';

  @override
  String get pronunciationNextCta => 'Tôi đã đọc →';

  @override
  String get pronunciationDoneCta => 'Hoàn thành';

  @override
  String get pronunciationModePronounce => 'Phát âm';

  @override
  String get pronunciationModeDistinguish => 'Phân biệt';

  @override
  String get pronunciationModeDistinguishSpSt => 'Phân biệt sp/st';

  @override
  String get pronunciationModeCategorize => 'Phân loại';

  @override
  String get pronunciationUmlauteTitle => 'Luyện Umlaute';

  @override
  String get pronunciationIchAchTitle => 'Ich-laut / Ach-laut';

  @override
  String get pronunciationRSoundTitle => 'R-Sound Tiếng Đức';

  @override
  String get pronunciationSpStTitle => 'Sp / St Ban đầu';

  @override
  String get pronunciationIchLautBadge => 'Ich-laut [ç]';

  @override
  String get pronunciationAchLautBadge => 'Ach-laut [x]';

  @override
  String get pronunciationCompareLabel => 'So sánh:';

  @override
  String get pronunciationROverviewInfo =>
      'Âm R tiếng Đức có 4 biến thể tùy vị trí. Bảng dưới giúp bạn nhớ nhanh quy tắc.';

  @override
  String get pronunciationRPositionInitial => 'Đầu từ [ʁ]';

  @override
  String get pronunciationRPositionAfterVowel => 'Sau nguyên âm [ɐ]';

  @override
  String get pronunciationRPositionCluster => 'Cụm phụ âm [ʁ]';

  @override
  String get pronunciationRPositionVocalic => 'Cuối từ -er [ɐ]';

  @override
  String get pronunciationQuizPrompt => 'Nghe và chọn từ bạn vừa nghe:';

  @override
  String get pronunciationQuizReplayHint => 'Nhấn để nghe lại';

  @override
  String pronunciationQuizScore(int count) {
    return '$count đúng';
  }

  @override
  String pronunciationStreak(int count) {
    return '🔥 $count liên tiếp!';
  }

  @override
  String get pronunciationQuizCorrect => '✓ Đúng rồi!';

  @override
  String get pronunciationQuizWrong => '✗ Chưa đúng';

  @override
  String get pronunciationQuizHeardLabel => 'Từ vừa nghe:';

  @override
  String get pronunciationQuizComparing => 'Đang phát cả hai để so sánh...';

  @override
  String get pronunciationQuizSeeResult => 'Xem kết quả';

  @override
  String get pronunciationQuizInsufficientData =>
      'Không đủ dữ liệu để tạo bài kiểm tra.';

  @override
  String get pronunciationMinimalPairsTitle => 'Luyện nghe cặp tối thiểu';

  @override
  String get pronunciationMinimalPairsPickerHint =>
      'Chọn cặp âm bạn muốn luyện nghe phân biệt:';

  @override
  String pronunciationMinimalPairsCount(int count) {
    return '$count cặp từ';
  }

  @override
  String get pronunciationMinimalPairsEmpty =>
      'Chưa có dữ liệu cặp âm. Vui lòng thử lại sau.';

  @override
  String get pronunciationMinimalPairsPracticing => 'Đang luyện:';

  @override
  String get pronunciationMinimalPairsPrompt => 'Bạn vừa nghe từ nào?';

  @override
  String pronunciationMinimalPairsCorrectOf(int correct, int total) {
    return 'Đúng $correct/$total';
  }

  @override
  String get pronunciationMinimalPairsCorrectLabel => 'Chính xác!';

  @override
  String pronunciationMinimalPairsWrongLabel(String word) {
    return 'Sai rồi — đáp án đúng: $word';
  }

  @override
  String get pronunciationEndCta => 'Kết thúc';

  @override
  String get pronunciationMinimalPairsResultTitle => 'Kết quả luyện nghe';

  @override
  String pronunciationMinimalPairsScoreLabel(int correct, int total) {
    return '$correct / $total câu đúng';
  }

  @override
  String get pronunciationMinimalPairsLowScoreHint =>
      'Hãy nghe lại nhiều lần — tai bạn sẽ quen dần với sự khác biệt!';

  @override
  String get pronunciationChangePairCta => 'Đổi cặp âm';

  @override
  String sprechenExamLoadError(String error) {
    return 'Không tải được đề: $error';
  }

  @override
  String get sprechenContentLockedTitle => 'Nội dung Premium';

  @override
  String get sprechenPracticeCta => '🎤 Luyện nói cùng Tiger AI';

  @override
  String get sprechenTopicListTitle => 'Danh sách đề';

  @override
  String sprechenTopicListLoadError(String error) {
    return 'Lỗi tải danh sách: $error';
  }

  @override
  String get sprechenTopicListEmpty => '🎤 Chưa có đề bài';

  @override
  String sprechenTopicListSummary(int count, int done) {
    return '$count đề · $done hoàn thành';
  }

  @override
  String get sprechenLeaderboardEmpty => 'Chưa có dữ liệu xếp hạng';

  @override
  String get sprechenTeilSetOverviewSubtitle =>
      'Luyện Sprechen — chọn phần để bắt đầu';

  @override
  String get sprechenTeilCompletedBadge => '✓ Hoàn thành';

  @override
  String get sprechenOverviewTitle => 'Nói — Sprechen';

  @override
  String sprechenOverviewSubtitle(String providerLabel) {
    return '$providerLabel · 3 phần · 75 Punkte';
  }

  @override
  String get sprechenOverviewGoetheInfo =>
      'Sprechen chiếm 75/300 điểm trong bài thi Goethe B1. Mỗi Teil được chấm theo 3 tiêu chí: Nội dung, Ngữ pháp & cấu trúc câu, Từ vựng & lưu loát.';

  @override
  String get sprechenOverviewTelcInfo =>
      'Sprechen chiếm 75/300 điểm trong bài thi telc B1.';

  @override
  String sprechenTopicCount(int count) {
    return '$count đề';
  }

  @override
  String get sprechenTopicSearchHint => 'Tìm theo tên đề hoặc nhóm chủ đề...';

  @override
  String sprechenTopicListFilteredCount(int filtered, int total) {
    return '$filtered/$total đề';
  }

  @override
  String get sprechenTopicListEmptyFiltered => '🎤 Không tìm thấy đề phù hợp';

  @override
  String get sprechenBewertungMainErrors => 'Lỗi chính';

  @override
  String get sprechenHistoryButtonLabel => 'Lịch sử';

  @override
  String get sprechenPracticeStartCta => 'Luyện thi ngay — Nói chuyện với AI';

  @override
  String get sprechenResultBackToList => 'Quay lại danh sách';

  @override
  String get sprechenNoSuggestions => 'Không có gợi ý';

  @override
  String get sprechenInputHint => 'Nhập câu trả lời bằng tiếng Đức...';

  @override
  String get sprechenMicComingSoon =>
      'Chế độ nói sắp ra mắt — dùng Viết trước nhé';

  @override
  String get sprechenMicUnsupported => 'Chỉ hỗ trợ Viết ở phiên bản này';

  @override
  String get sprechenPartnerSubtitleDefault => 'Trả lời bằng tiếng Đức';

  @override
  String sprechenFeedbackScoreLabel(int score) {
    return '$score/5 · phản hồi';
  }

  @override
  String get sprechenSessionHistoryEmpty => 'Chưa có phiên luyện tập nào';

  @override
  String get sprechenStudyPanelLocked =>
      'Nội dung Premium — nâng cấp để xem đầy đủ';

  @override
  String get sprechenStudyPanelEmpty => 'Chưa có nội dung học cho đề này.';

  @override
  String get conversationTranscriptEmpty => 'Không có nội dung hội thoại.';

  @override
  String get writingHotBadge => 'HOT';

  @override
  String get writingCompletedBadge => 'Đã học';

  @override
  String get writingPremiumBadge => 'Premium';

  @override
  String get writingUnlockToView => 'Mở khóa để xem';

  @override
  String get writingBuyPremium => 'Mua Premium';

  @override
  String get writingDifficultyEasy => 'Dễ';

  @override
  String get writingDifficultyMedium => 'TB';

  @override
  String get writingDifficultyHard => 'Khó';

  @override
  String writingLeaderboardTitle(int teil) {
    return 'Bảng xếp hạng · Teil $teil';
  }

  @override
  String get writingLeaderboardEmpty => 'Chưa có ai hoàn thành đề nào';

  @override
  String get writingLeaderboardYou => 'bạn';

  @override
  String get writingCommunityFolderTitle => 'Đề do cộng đồng đóng góp';

  @override
  String writingCommunityFolderCount(int count) {
    return '$count đề đã được thêm';
  }

  @override
  String get writingCommunityFolderEmpty =>
      'Chưa có đề — hãy là người đầu tiên!';

  @override
  String get writingSearchHint => 'Tìm theo tên đề, chủ đề, từ khóa...';

  @override
  String get writingSprintPill => 'Sprint 10h';

  @override
  String get writingSprintComingSoon => 'Sprint 10h sẽ sớm ra mắt';

  @override
  String writingTopicCount(int count) {
    return '$count đề';
  }

  @override
  String writingTopicCountFiltered(int count, int total) {
    return '$count/$total đề';
  }

  @override
  String get writingNoResultsTitle => 'Không tìm thấy đề phù hợp';

  @override
  String get writingNoResultsHint =>
      'Thử tìm bằng tiếng Đức, tiếng Việt hoặc tên chủ đề khác.';

  @override
  String writingFreeLimitTitle(int teil) {
    return 'Bạn đang xem 5 đề miễn phí của Teil $teil';
  }

  @override
  String get writingFreeLimitDesc =>
      'Nâng cấp Premium để mở toàn bộ chủ đề Schreiben B1 và dùng AI chấm bài không giới hạn.';

  @override
  String writingTeilLabel(int n) {
    return 'Teil $n';
  }

  @override
  String writingCommunityListTitle(int teil) {
    return 'Đề cộng đồng · Teil $teil';
  }

  @override
  String get writingPracticeNotFound => 'Không tìm thấy đề viết.';

  @override
  String writingWordCountHint(int min, int max) {
    return '📏 $min–$max từ';
  }

  @override
  String get writingShowTranslation => 'Hiện dịch';

  @override
  String get writingHideTranslation => 'Ẩn dịch';

  @override
  String get writingRequirementsTitle => 'Yêu cầu viết';

  @override
  String get writingSectionTask => 'Đề bài';

  @override
  String get writingSectionTaskAnalysis => 'Phân tích đề (Task analysis)';

  @override
  String get writingSectionTextStructure => 'Cấu trúc bài viết';

  @override
  String get writingSectionPhrases => 'Mẫu câu hữu ích';

  @override
  String get writingSectionSamples => 'Câu mẫu theo điểm';

  @override
  String get writingSectionModels => 'Bài mẫu';

  @override
  String get writingSectionGrammar => 'Ngữ pháp trọng tâm (tham khảo)';

  @override
  String get writingSectionVocab => 'Từ vựng trọng tâm (tham khảo)';

  @override
  String get writingSectionMistakes => 'Lỗi thường gặp (tham khảo)';

  @override
  String get writingSectionExercises => 'Bài tập luyện';

  @override
  String writingApproachesLabel(int count) {
    return '$count cách triển khai';
  }

  @override
  String get writingAnnotationsLabel => 'Chú thích:';

  @override
  String writingModelTabLabel(int n) {
    return 'Model $n';
  }

  @override
  String get writingColPart => 'Phần';

  @override
  String get writingColDe => 'Tiếng Đức';

  @override
  String get writingColVi => 'Tiếng Việt';

  @override
  String writingKernwortschatzTitle(int count) {
    return 'Kernwortschatz ($count từ)';
  }

  @override
  String get writingGenusOther => 'Khác';

  @override
  String get writingTranslateExamples => '🌐 Dịch ví dụ';

  @override
  String writingChunksTitle(int count) {
    return 'Chunks & Wendungen ($count cụm)';
  }

  @override
  String writingKonnektorenTitle(int count) {
    return 'Konnektoren ($count từ nối)';
  }

  @override
  String get writingNoContent => 'Chưa có nội dung.';

  @override
  String get writingCorrectCount => 'câu đúng';

  @override
  String get writingWrongSentenceLabel => 'CÂU SAI';

  @override
  String get writingRevealAnswer => 'Xem đáp án';

  @override
  String get writingShowSampleAnswer => 'Xem câu mẫu';

  @override
  String get writingSampleAnswerLabel => 'Câu mẫu';

  @override
  String get writingPlayAll => 'Phát toàn bộ';

  @override
  String writingExamTimesCount(int count) {
    return '📊 $count lần thi';
  }

  @override
  String get writingMinutesUnit => 'phút';

  @override
  String get writingWordsUnit => 'từ';

  @override
  String writingProvenanceTitle(int count) {
    return 'Đề thật — $count lần thi';
  }

  @override
  String get writingSourcesLabel => 'Nguồn';

  @override
  String get writingExamDatesToggle => 'Xem ngày ra đề chi tiết';

  @override
  String get writingLockTitle => 'Đề này dành cho tài khoản Premium';

  @override
  String get writingLockOfficialCopy =>
      'Đây là đề chính thức Premium. Nâng cấp để xem đầy đủ nội dung.';

  @override
  String get writingLockLegacyCopy =>
      'Tài khoản miễn phí chỉ xem 5 đề đầu của mỗi Teil. Nâng cấp Premium để mở toàn bộ.';

  @override
  String get writingUnlockPremiumCta => 'Mở khóa Premium';

  @override
  String get writingCompleteMark => '🎯 Đánh dấu hoàn thành';

  @override
  String get writingCompleteDone => '✓ Đã hoàn thành — Lưu lại';

  @override
  String get writingCompleteSaving => 'Đang lưu...';

  @override
  String get writingStartPracticeCta => 'Viết bài cá nhân → AI chấm';

  @override
  String get writingTypingStartTitle => 'Luyện gõ bài này';

  @override
  String writingTypingStartDesc(int count) {
    return 'Có $count câu tiếng Đức trên trang — luyện gõ lại từng câu.';
  }

  @override
  String get writingTypingStartCta => 'Bắt đầu gõ →';

  @override
  String get writingTypingPracticeTitle => 'Luyện gõ';

  @override
  String writingTypingProgress(int current, int total) {
    return 'Câu $current/$total';
  }

  @override
  String get writingTypingHint => 'Gõ lại câu tiếng Đức...';

  @override
  String get writingTypingCheck => 'Kiểm tra';

  @override
  String get writingTypingCorrect => '✓ Chính xác!';

  @override
  String get writingTypingIncorrect => '✗ Còn vài chỗ chưa đúng';

  @override
  String get writingTypingNext => 'Tiếp →';

  @override
  String get writingTypingSkip => 'Bỏ qua';

  @override
  String writingTypingDoneCount(int count) {
    return 'Bạn đã gõ xong $count câu';
  }

  @override
  String get writingTypingClose => 'Đóng';

  @override
  String get listeningPageTitle => 'Nghe';

  @override
  String get listeningPageSubtitle =>
      'Luyện nghe tiếng Đức qua video, podcast và audiobook';

  @override
  String get listeningIntroWhy =>
      'Luyện nghe/đọc với nội dung vừa sức trình độ của bạn.';

  @override
  String get listeningIntroTodo => 'Chọn nguồn: video, podcast, hay bài đọc.';

  @override
  String get listeningIntroNext => 'Lưu từ mới gặp để đưa vào ôn tập.';

  @override
  String get listeningOtherSourcesSection => 'Khác';

  @override
  String get listeningSourceSprechenB1Desc =>
      'Luyện nghe chép chính tả với video Sprechen B1';

  @override
  String get listeningSourceSprechenB2Desc =>
      'Luyện nghe chép chính tả với video Sprechen B2';

  @override
  String get listeningSourceYoutubeDesc =>
      'Luyện nghe với video YouTube có phụ đề';

  @override
  String get listeningSourcePodcastDesc =>
      'Nghe Easy German Podcast với phụ đề song ngữ';

  @override
  String get listeningSourceAudiobookDesc => 'Nghe sách nói tiếng Đức dễ hiểu';

  @override
  String listeningSourceVideoCount(int count) {
    return '$count video';
  }

  @override
  String get easyGermanSegmentCountShort => 'Ngắn';

  @override
  String get easyGermanSegmentCountMedium => 'Vừa';

  @override
  String get easyGermanSegmentCountLong => 'Dài';

  @override
  String get easyGermanLoadError =>
      'Không thể tải danh sách video. Vui lòng thử lại sau.';

  @override
  String easyGermanSentenceCount(int count) {
    return '$count câu';
  }

  @override
  String get easyGermanSearchHint => 'Tìm video theo tiêu đề hoặc video ID...';

  @override
  String get easyGermanLeaderboardEmptyHint =>
      'Chưa có đủ dữ liệu để xếp hạng level này.';

  @override
  String get podcastLoadError =>
      'Không thể tải danh sách tập. Vui lòng thử lại sau.';

  @override
  String get podcastDescription => 'Luyện nghe podcast tiếng Đức đời thường';

  @override
  String get podcastEpisodeCountLabel => 'tập podcast';

  @override
  String get podcastMinutesLabel => 'phút luyện nghe';

  @override
  String get podcastSearchHint => 'Tìm tập podcast...';

  @override
  String podcastNoResultsFor(String query) {
    return 'Không tìm thấy tập nào khớp với \"$query\".';
  }

  @override
  String get podcastNoResultsInBucket =>
      'Không có tập nào trong khoảng thời lượng này.';

  @override
  String podcastPageInfo(int page, int total, int count) {
    return 'Trang $page/$total ($count tập)';
  }

  @override
  String get podcastAudioLoadError =>
      'Không thể tải âm thanh. Vui lòng thử lại.';

  @override
  String get podcastEpisodeLoadError => 'Không thể tải tập podcast.';

  @override
  String get podcastBackToList => 'Quay lại danh sách';

  @override
  String get podcastTranscriptEmpty => 'Chưa có transcript cho tập này.';

  @override
  String get podcastLeaderboardSubtitle => 'Số tập podcast đã hoàn thành';

  @override
  String get podcastLeaderboardLoadError => 'Không thể tải bảng xếp hạng.';

  @override
  String podcastYourRank(int rank, int count) {
    return 'Hạng của bạn: #$rank · $count tập';
  }

  @override
  String get podcastSettingsTitle => 'Cài đặt đọc';

  @override
  String podcastFontSizeLabel(int percent) {
    return 'Cỡ chữ ($percent%)';
  }

  @override
  String get podcastShowViTranslation => 'Hiện bản dịch tiếng Việt';

  @override
  String get podcastDurationLe10 => '≤ 10 phút';

  @override
  String get podcastDurationLe20 => '10–20 phút';

  @override
  String get podcastDurationLe60 => '20–60 phút';

  @override
  String get podcastDurationGt60 => '> 60 phút';

  @override
  String get videoCollectionWatched => 'Đã xem';

  @override
  String get videoCollectionEmptyTitle => 'Không tìm thấy video phù hợp';

  @override
  String get videoCollectionEmptyHint => 'Thử từ khóa khác hoặc xóa bộ lọc.';

  @override
  String get videoCollectionLeaderboardTitle => 'Top học tập';

  @override
  String get videoCollectionLeaderboardSubtitle =>
      'Xếp hạng theo video hoàn thành và lượt xem lại.';

  @override
  String get videoCollectionLeaderboardEmptyHint =>
      'Chưa có đủ dữ liệu để xếp hạng.';

  @override
  String videoCollectionLeaderboardStats(int count, int rewatch) {
    return '$count video · $rewatch xem lại';
  }

  @override
  String videoCollectionPageInfo(int page, int total) {
    return 'Trang $page / $total';
  }

  @override
  String get videoCollectionStatusNew => 'Chưa xem';

  @override
  String get videoCollectionProgressEmpty => 'Chưa có dữ liệu video.';

  @override
  String get videoCollectionProgressStart =>
      'Mở một video để bắt đầu lưu tiến độ học.';

  @override
  String get videoCollectionProgressDone => 'Bạn đã hoàn thành toàn bộ!';

  @override
  String get videoCollectionProgressFinalStretch =>
      'Bạn đang ở chặng cuối rồi!';

  @override
  String get videoCollectionProgressGoodPace =>
      'Tiến độ đang rất ổn, tiếp tục giữ nhịp.';

  @override
  String get videoCollectionProgressGoodStart =>
      'Bạn đã bắt đầu tốt, tiếp tục thêm vài video nữa.';

  @override
  String get videoCollectionStatRewatch => 'Xem lại';

  @override
  String get videoCollectionStatRemaining => 'Còn lại';

  @override
  String get videoCollectionCompletionLabel => 'hoàn thành';

  @override
  String videoCollectionPercentLabel(int percent, String label) {
    return '$percent% $label';
  }

  @override
  String videoCollectionSavedCount(int count) {
    return '$count video đã lưu tiến độ';
  }

  @override
  String get appOnlySettingsLabel => 'Riêng ứng dụng';

  @override
  String get appUpdateSectionDescription =>
      'Kiểm tra và cập nhật lên phiên bản mới nhất từ store.';

  @override
  String get appUpdateSectionTitle => 'Cập nhật lên bản mới nhất';

  @override
  String get confirmNewPassword => 'Xác nhận mật khẩu mới';

  @override
  String get couldNotChangePassword =>
      'Lỗi khi đổi mật khẩu. Vui lòng thử lại.';

  @override
  String get darkModeDescription => 'Giảm mỏi mắt khi học ban đêm';

  @override
  String get darkModeToggle => 'Chế độ tối';

  @override
  String get dismissAnnouncement => 'Đóng thông báo';

  @override
  String get learningPreferencesGoalCommunication => 'Giao tiếp hàng ngày';

  @override
  String get learningPreferencesGoalGoethe => 'Thi chứng chỉ Goethe';

  @override
  String get learningPreferencesGoalMedical => 'Chuyên ngành điều dưỡng-y khoa';

  @override
  String get learningPreferencesGoalOther => 'Khác';

  @override
  String get learningPreferencesGoalsLabel => 'Mục tiêu';

  @override
  String get learningPreferencesGoalWork => 'Du học-làm việc tại Đức';

  @override
  String get learningPreferencesMinutesLabel => 'Thời gian học mỗi ngày';

  @override
  String learningPreferencesXpSummary(int xp, int words) {
    return 'Mục tiêu: $xp XP/ngày · ~$words từ/ngày';
  }

  @override
  String get logoutConfirmMessage => 'Bạn có chắc muốn đăng xuất?';

  @override
  String get minutesUnit => 'phút';

  @override
  String get notificationPermissionBlockedBody =>
      'Vui lòng bật lại trong cài đặt hệ thống → Thông báo.';

  @override
  String get notificationPermissionBlockedTitle => 'Thông báo đã bị chặn';

  @override
  String get notificationPermissionEnableAction => 'Bật thông báo';

  @override
  String get notificationPreferencesSendTest => 'Gửi thử';

  @override
  String get notificationPreferencesTestFailed => 'Gửi thất bại. Thử lại sau.';

  @override
  String get notificationPreferencesTestSending => 'Đang gửi…';

  @override
  String get notificationPreferencesTestSent =>
      'Đã gửi! Thông báo sẽ hiện trên thiết bị sau vài giây.';

  @override
  String get notificationPreferencesTimezone => 'Múi giờ';

  @override
  String get passwordMinLength => 'Tối thiểu 8 ký tự';

  @override
  String get reviewDisplay4Button => 'Tự đánh giá 4-mức (sau mỗi vòng)';

  @override
  String get reviewDisplay4ButtonDesc =>
      'Hiện bảng Quên/Khó/Tốt/Dễ sau mỗi vòng để chỉnh lại đánh giá tự động.';

  @override
  String get reviewDisplayAutoAdvance => 'Tự động chuyển câu';

  @override
  String get reviewDisplayAutoAdvanceDesc =>
      'Bật: tự nhảy sang câu kế sau khi trả lời. Tắt (khuyến nghị): bạn bấm \"Tiếp tục\" để chủ động chuyển.';

  @override
  String get reviewDisplayContext => 'Hiện câu ví dụ';

  @override
  String get reviewDisplayContextDesc =>
      'Hiện một câu ví dụ ngắn dưới mỗi từ trong bảng tóm tắt.';

  @override
  String get reviewDisplayTitle => 'Hiển thị ôn tập';

  @override
  String get settingsSavedMessage => 'Đã lưu!';

  @override
  String get settingsSubtitle => 'Tùy chỉnh ứng dụng';

  @override
  String get soundAndEffects => 'Âm thanh & hiệu ứng';

  @override
  String get soundAndEffectsDescription =>
      'Âm thanh và rung khi trả lời đúng/sai trong bài học';

  @override
  String listeningSprechenHeaderSubtitle(int count) {
    return '$count video · Luyện nghe chép chính tả';
  }

  @override
  String get writingHubTitle => 'Luyện viết (AI chấm)';

  @override
  String get writingHubRubricButton => '📋 Cách chấm';

  @override
  String get writingHubTabStart => 'Bắt đầu';

  @override
  String get writingHubTabMy => 'Bài của tôi';

  @override
  String get writingHubTabCommunity => 'Cộng đồng';

  @override
  String get writingHubStartIntro =>
      'Chọn kỳ thi và trình độ để bắt đầu luyện viết.';

  @override
  String get writingHubCustomTitle => 'Tự nhập đề của bạn';

  @override
  String get writingHubCustomSubtitle =>
      'Dán đề bất kỳ → chọn kì thi & trình độ → AI chấm';

  @override
  String get writingHubSprintTitle => 'Sprint luyện cấp tốc';

  @override
  String get writingHubSprintSubtitle =>
      'Ôn nhanh mẫu câu Goethe B1 theo thẻ lặp lại';

  @override
  String get writingHubCommunityIntro =>
      'Đề luyện viết do cộng đồng đóng góp, nhóm theo từng phần thi.';

  @override
  String get writingHubCommunityTeil1 => 'Teil 1 — Email thân mật';

  @override
  String get writingHubCommunityTeil2 => 'Teil 2 — Bài luận diễn đàn';

  @override
  String get writingHubCommunityTeil3 => 'Teil 3 — Email trang trọng';

  @override
  String get writingHubCommunityViewAll => 'Xem tất cả đề cộng đồng →';

  @override
  String get writingChooseNow => 'Chọn đề ngay';

  @override
  String get writingClearFilters => 'Xóa bộ lọc';

  @override
  String get writingShowMore => 'Xem thêm';

  @override
  String get writingSortLabel => 'Sắp xếp:';

  @override
  String get writingSortByDate => 'Ngày';

  @override
  String get writingSortByScore => 'Điểm';

  @override
  String get writingSubmissionsEmptyTitle => 'Chưa có bài viết nào';

  @override
  String get writingSubmissionsEmptyDesc =>
      'Chọn đề và bắt đầu luyện viết để thấy lịch sử ở đây.';

  @override
  String get writingSubmissionsNoMatch => 'Không có bài viết khớp bộ lọc.';

  @override
  String get writingCriteriaTrendTitle => 'Tiêu chí Viết của bạn';

  @override
  String writingCriteriaTrendSubtitle(int count) {
    return 'TB qua $count bài đã chấm';
  }

  @override
  String get writingCriteriaWeakest => 'cần cải thiện nhất';

  @override
  String get writingCriterionTaskCompletion => 'Hoàn thành đề';

  @override
  String get writingCriterionGrammar => 'Ngữ pháp';

  @override
  String get writingCriterionVocabulary => 'Từ vựng';

  @override
  String get writingCriterionCoherence => 'Liên kết';

  @override
  String writingLevelTitle(String label) {
    return '$label · Viết';
  }

  @override
  String get writingLevelEmptyTitle => 'Chưa có đề chính thức';

  @override
  String writingLevelEmptyDesc(String label) {
    return 'Đề $label đang được cập nhật — thử đề cộng đồng bên dưới nhé!';
  }

  @override
  String get writingLevelCommunitySectionTitle => 'Đề cộng đồng';

  @override
  String get writingLevelContributeButton => '➕ Đóng góp đề';

  @override
  String get writingLevelCommunityEmpty =>
      'Chưa có đề cộng đồng cho trình độ này.';

  @override
  String get writingLevelNotFound => 'Không tìm thấy trình độ luyện viết này.';

  @override
  String get writingLevelLocked => 'Đề này dành cho tài khoản Premium.';

  @override
  String get writingCommunityAddVersion => '➕ Thêm phiên bản';

  @override
  String get writingCommunityBackToList => 'Quay lại danh sách';

  @override
  String get writingCommunityCreateTitle => 'Đóng góp đề cộng đồng';

  @override
  String get writingCommunityNotFoundDesc =>
      'Đề có thể đã bị xóa hoặc chưa được công khai.';

  @override
  String get writingCommunityNotFoundTitle => 'Không tìm thấy đề này';

  @override
  String get writingCommunityPointsHint =>
      'Mỗi ý một dòng — AI dùng để bám sát yêu cầu đề.';

  @override
  String get writingCommunityPointsTitle => 'Các ý cần trả lời';

  @override
  String get writingCommunityReportReason => 'Báo cáo từ người dùng';

  @override
  String get writingCommunityReportSent => 'Đã gửi báo cáo, cảm ơn bạn!';

  @override
  String get writingCommunitySubmit => 'Đăng đề';

  @override
  String get writingCommunityTaskHint => 'Dán đề viết của bạn vào đây…';

  @override
  String get writingCommunityTopicFallbackTitle => 'Đề cộng đồng';

  @override
  String get writingCommunityVoteError => 'Có lỗi xảy ra, thử lại sau.';

  @override
  String get writingCustomTitle => 'Tự nhập đề';

  @override
  String get writingCustomIntro =>
      'Dán đề viết của bạn, chọn kì thi & trình độ, rồi viết bài — AI sẽ chấm và gợi ý như đề có sẵn.';

  @override
  String get writingCustomExamLabel => 'Kì thi';

  @override
  String get writingCustomLevelLabel => 'Trình độ';

  @override
  String get writingCustomTeilLabel => 'Teil (tùy chọn)';

  @override
  String get writingCustomTeilNone => 'Không';

  @override
  String get writingCustomTaskLabel => 'Đề bài *';

  @override
  String get writingCustomTaskHintPolish =>
      'Nhập đề tiếng Việt, từ khóa, hoặc đề chưa hoàn chỉnh — AI sẽ dựng thành đề tiếng Đức đầy đủ…';

  @override
  String get writingCustomTaskHintPlain =>
      'Dán đề viết bằng tiếng Đức hoàn chỉnh vào đây…';

  @override
  String get writingCustomPointsLabelPolish => 'Gợi ý / ý chính (tùy chọn)';

  @override
  String get writingCustomPointsLabelPlain => 'Các ý cần trả lời (tùy chọn)';

  @override
  String get writingCustomPointsHint =>
      'Mỗi ý một dòng — AI dùng để bám sát yêu cầu đề.';

  @override
  String get writingCustomStartPolish => 'Hoàn thiện & bắt đầu viết';

  @override
  String get writingCustomStartPlain => 'Bắt đầu viết';

  @override
  String get writingCustomEditPrompt => '← Sửa đề';

  @override
  String get writingCustomStartedTitle => 'Đề tự nhập';

  @override
  String get writingCustomContribute => '📤 Đóng góp đề này cho cộng đồng';

  @override
  String get writingAiPolishTitle => '✨ Để AI hoàn thiện đề';

  @override
  String get writingAiPolishDesc =>
      'Biến đề tiếng Việt / từ khóa / đề còn thiếu thành đề tiếng Đức chuẩn. Bỏ tích nếu bạn đã có đề đầy đủ.';

  @override
  String get writingAiPolishing => 'Đang hoàn thiện đề…';

  @override
  String get writingAiPolishError =>
      'AI hoàn thiện đề thất bại. Bỏ tích để dùng đề gốc, hoặc thử lại.';

  @override
  String get writingSessionGradingTimelineTitle => 'Lịch sử chấm điểm';

  @override
  String get writingSessionNotFound =>
      'Không tìm thấy bài viết này. Bài có thể đã cũ — quay lại lịch sử để xem các bài gần đây.';

  @override
  String get writingSessionPracticeAgain => 'Luyện lại';

  @override
  String get writingSessionTitleFallback => 'Bài viết';

  @override
  String get writingSessionYourAnswer => 'Bài viết của bạn';

  @override
  String get youtubeInvalidUrl => 'URL YouTube không hợp lệ';

  @override
  String get youtubeAddVideoError => 'Không thêm được video, thử lại sau.';

  @override
  String get youtubeDeleteVideoError => 'Không xoá được video.';

  @override
  String get youtubeLoadListError => 'Không tải được danh sách video.';

  @override
  String get youtubeEmptyState =>
      'Chưa có video nào. Dán URL YouTube ở trên để bắt đầu.';

  @override
  String get youtubeUntitledVideo => 'Video chưa có tiêu đề';

  @override
  String youtubeWatchCount(int count) {
    return 'Đã xem ×$count';
  }

  @override
  String get youtubeContinueWatching => 'Xem tiếp';

  @override
  String get youtubePopularVideos => 'Video phổ biến';

  @override
  String get youtubePasteUrlHint => 'Dán URL YouTube...';

  @override
  String get youtubeRewatchMarked => 'Đã ghi nhận xem lại';

  @override
  String get youtubeCompleteMarked => 'Đã đánh dấu hoàn thành';

  @override
  String get youtubeSaveProgressError => 'Không lưu được tiến độ, thử lại sau.';

  @override
  String get youtubeRewatchButton => 'Xem lại';

  @override
  String get youtubeCompleteButton => 'Đã hoàn thành';

  @override
  String get youtubePracticeShadowing => 'Shadowing';

  @override
  String get youtubeTranscriptLabel => 'Transcript';

  @override
  String get youtubeNotesLabel => 'Ghi chú';

  @override
  String get youtubeDictationShowVideoTooltip => 'Hiện video';

  @override
  String get youtubeDictationAudioOnlyTooltip => 'Chỉ nghe';

  @override
  String get youtubeTranscriptLoadError => 'Không tải được transcript.';

  @override
  String get youtubeDictationNoTranscript =>
      'Video này chưa có transcript để luyện chính tả.';

  @override
  String get shadowingScreenTitle => 'Shadowing — Luyện phát âm';

  @override
  String get shadowingHideVideoTooltip => 'Ẩn video (vẫn nghe tiếng)';

  @override
  String get shadowingNoTranscript =>
      'Video này chưa có transcript để luyện shadowing.';

  @override
  String shadowingSentenceProgress(int index, int total) {
    return 'Câu $index/$total';
  }

  @override
  String get shadowingListenAgain => 'Nghe lại';

  @override
  String get shadowingRecordTooltip => 'Ghi âm';

  @override
  String get shadowingRecordComingSoonTooltip => 'Ghi âm sắp ra mắt';

  @override
  String get shadowingRecordComingSoonHint =>
      'Ghi âm + chấm phát âm AI sắp ra mắt — theo dõi bản cập nhật tiếp theo.';

  @override
  String youtubeDictationProgress(int index, int total, int correct) {
    return 'Câu $index/$total · Đúng $correct';
  }

  @override
  String get youtubeDictationSentenceHint => 'Gõ cả câu...';

  @override
  String get youtubeDictationClozeHint => 'Điền từ khuyết...';

  @override
  String get youtubeDictationAnswerLabel => 'Đáp án:';

  @override
  String get youtubeDictationRetryButton => '↻ Thử lại';

  @override
  String get youtubeDictationNextButton => 'Tiếp →';

  @override
  String get youtubeDictationCompleteTitle => 'Hoàn thành!';

  @override
  String youtubeDictationCompleteSummary(int correct, int total, int skipped) {
    return 'Đúng $correct/$total câu · Bỏ qua $skipped';
  }

  @override
  String get youtubeDictationRestartButton => 'Làm lại';

  @override
  String get youtubeDictationModeLabel => 'Chế độ';

  @override
  String get youtubeDictationModeSentence => 'Cả câu';

  @override
  String get youtubeDictationModeCloze => 'Điền từ khuyết';

  @override
  String get youtubeDictationAlwaysShowVietnamese =>
      'Luôn hiện nghĩa tiếng Việt';

  @override
  String get writingSprintTitle => 'Sprint Anki';

  @override
  String get writingSprintSubtitle =>
      'Goethe B1 Viết — ôn đề bằng lặp lại ngắt quãng (spaced repetition)';

  @override
  String get writingSprintModePickerLabel => 'Chọn chế độ';

  @override
  String get writingSprintModeMarathonTitle => 'Marathon';

  @override
  String get writingSprintModeMarathonSubtitle => '1 session 10 giờ';

  @override
  String get writingSprintModeMarathonDetail =>
      'Lặp lại nhanh: 1 phút · 10 phút · 30 phút · 2 giờ. Ôn hết đề trong 1 buổi.';

  @override
  String get writingSprintModeDailyTitle => 'Hằng ngày';

  @override
  String get writingSprintModeDailySubtitle => 'SM-2 nhiều ngày';

  @override
  String get writingSprintModeDailyDetail =>
      'Thuật toán Anki: khoảng 1 ngày · 2.5 ngày · 4 ngày. Vài phút/ngày, nhớ lâu hơn.';

  @override
  String get writingSprintModeSelected => 'Đã chọn';

  @override
  String get writingSprintResumeButton => 'Tiếp tục session cũ';

  @override
  String get writingSprintStartFreshButton => 'Bắt đầu mới (xoá session cũ)';

  @override
  String writingSprintStartButton(int count) {
    return 'Bắt đầu — $count đề';
  }

  @override
  String get writingSprintMockCta => 'Thi thử 3 đề ngay';

  @override
  String get writingSprintCheatsheetCta => 'Cheatsheet Redemittel';

  @override
  String writingSprintCardCounter(int teil, int num, int total) {
    return 'Teil $teil · Card $num/$total';
  }

  @override
  String get writingSprintRequirementsLabel => 'YÊU CẦU';

  @override
  String writingSprintOutlineLabel(int index) {
    return 'Outline $index (DE)';
  }

  @override
  String writingSprintOutlineHint(int index) {
    return 'Bạn sẽ viết gì cho ý $index?';
  }

  @override
  String get writingSprintSkipButton => 'Bỏ qua';

  @override
  String get writingSprintCheckButton => 'Kiểm tra';

  @override
  String get writingSprintMatchGood => 'Tốt! Bạn nhớ phần lớn nội dung.';

  @override
  String get writingSprintMatchWeak => 'Cần ôn lại — chọn Again hoặc Hard.';

  @override
  String get writingSprintOutlineAnswerLabel => 'ĐÁP ÁN OUTLINE';

  @override
  String writingSprintOutlineMissing(int index) {
    return '(outline $index chưa có)';
  }

  @override
  String writingSprintYouWrote(String text) {
    return 'Bạn viết: $text';
  }

  @override
  String get writingSprintMiniModelToggle => 'Xem mini-model';

  @override
  String get writingSprintRedemittelLabel => 'REDEMITTEL';

  @override
  String get writingSprintSessionDoneTitle => 'Tất cả đã ôn xong!';

  @override
  String writingSprintSessionDoneBody(int count) {
    return 'Bạn đã ôn $count đề trong session này.';
  }

  @override
  String get writingSprintBackToSprint => 'Về Sprint';

  @override
  String writingSprintTaskLabel(int teil) {
    return 'Đề — Teil $teil';
  }

  @override
  String get writingSprintEssayHint => 'Viết bài của bạn ở đây...';

  @override
  String writingSprintWordCount(int count, int min, int max) {
    return '$count từ (mục tiêu: $min–$max)';
  }

  @override
  String writingSprintSubmitButton(int count) {
    return 'Nộp bài ($count từ)';
  }

  @override
  String get writingSprintGrading => 'Đang chấm...';

  @override
  String writingSprintWordsNeeded(int count) {
    return 'Cần thêm $count từ nữa';
  }

  @override
  String get writingSprintNoMockTopics => 'Không tìm được đề phù hợp.';

  @override
  String get writingSprintMockAverageLabel => 'Điểm trung bình 3 bài';

  @override
  String writingSprintTeilTopicLabel(int teil, String title) {
    return 'Teil $teil — $title';
  }

  @override
  String get writingSprintNextEssay => 'Bài tiếp theo →';

  @override
  String get writingSprintGradingLong => 'AI đang chấm bài... (~5-10 giây)';

  @override
  String writingSprintTeilLabel(int teil) {
    return 'Teil $teil';
  }

  @override
  String get writingSprintErrorsToFixLabel => 'Lỗi cần sửa';

  @override
  String get writingSprintErrorWrongLabel => 'Sai';

  @override
  String get writingSprintErrorFixLabel => 'Sửa';

  @override
  String get writingSprintShowEssay => 'Xem bài viết';

  @override
  String get writingSprintHideEssay => 'Ẩn bài viết';

  @override
  String get writingSprintRegradeButton => 'Chấm lại?';

  @override
  String get writingSprintCheatsheetTitle => 'Cheatsheet Goethe B1 Viết';

  @override
  String writingSprintCheatsheetSummary(int topics, int clusters) {
    return '$topics đề · $clusters clusters';
  }

  @override
  String writingSprintCheatsheetOverviewTitle(int count) {
    return 'Toàn cảnh — $count Clusters';
  }

  @override
  String writingSprintCheatsheetTopicCount(int count) {
    return '$count đề';
  }

  @override
  String writingSprintCheatsheetTeilTitle(int teil, int count) {
    return 'Teil $teil — $count đề';
  }

  @override
  String get writingSprintCheatsheetRedemittelTitle =>
      'Top Redemittel theo chức năng';

  @override
  String get writingSprintCheatsheetMistakesTitle => 'Lỗi thường gặp B1';

  @override
  String get writingSprintCheatsheetVerbKasusTitle =>
      'Quick Reference — Verb+Kasus';

  @override
  String get readingTabLabel => 'Truyện';

  @override
  String get newsTabLabel => 'Tin tức';

  @override
  String get readingHubTitle => 'Đọc truyện';

  @override
  String readingHubTitleLevel(String level) {
    return 'Đọc truyện $level';
  }

  @override
  String get readingHubSubtitleHome =>
      'Truyện song ngữ Đức–Việt theo cấp độ · có audio · A1–C2';

  @override
  String get readingHubSubtitleLevel =>
      'Chọn bài · hoàn thành bài tập (≥60%) để đánh dấu xong';

  @override
  String get readingLevelCardEmpty => 'Chưa có bài đọc';

  @override
  String get readingLevelCardAllDone => '🎉 Hoàn thành rồi!';

  @override
  String get readingViewAllArrow => 'Xem tất cả →';

  @override
  String readingSearchHintInLevel(String level) {
    return 'Tìm bài đọc trong $level...';
  }

  @override
  String readingCompletedCountOfTotal(int completed, int total) {
    return '$completed/$total bài đã hoàn thành';
  }

  @override
  String get readingSearchEmpty => 'Không tìm thấy bài nào';

  @override
  String get readingDoneChip => 'Đã đọc';

  @override
  String get readingShowTranslation => 'Hiện bản dịch';

  @override
  String get readingTapWordHint => 'Chạm vào từ bất kỳ để tra nghĩa.';

  @override
  String get readingSaveProgressError => 'Không thể lưu tiến độ, thử lại sau.';

  @override
  String get readingGlossaryTitle => 'Từ vựng & giải thích';

  @override
  String get readingMarkComplete => 'Đánh dấu đã đọc';

  @override
  String get readingFeedAppBarTitle => 'Đọc vừa sức';

  @override
  String get readingFeedEmptyReady =>
      'Chưa có bài đọc phù hợp trình độ của bạn lúc này.';

  @override
  String get readingFeedEmptyNotReady =>
      'Đang chuẩn bị kho bài đọc — vui lòng quay lại sau ít phút.';

  @override
  String get readingFeedSaveVocabHint =>
      'Lưu thêm từ vựng để hệ thống cá nhân hóa gợi ý bài đọc cho bạn.';

  @override
  String readingFeedVocabSummary(int vocabNew, int coveragePct) {
    return '$vocabNew từ mới · Đã biết $coveragePct% từ khó';
  }

  @override
  String get readListenTabRead => 'Đọc';

  @override
  String readingLeaderboardProgressTitle(String level) {
    return 'Tiến trình $level';
  }

  @override
  String readingLeaderboardTitleLevel(String level) {
    return 'Bảng xếp hạng $level';
  }

  @override
  String readingLeaderboardSubtitleLevel(String level) {
    return 'Số bài $level đã hoàn thành';
  }

  @override
  String get readingYourRankPrefix => 'Hạng của bạn: ';

  @override
  String readingYourRankSuffix(int count) {
    return ' · $count bài';
  }

  @override
  String get newsHeaderTitle => 'Tin tức Đức';

  @override
  String get newsHeaderSubtitle =>
      'Đọc tin tức bằng tiếng Đức theo cấp độ A1–B2 · có audio · từ vựng · bài tập';

  @override
  String get newsFilterLevelLabel => 'Trình độ:';

  @override
  String get newsFilterTopicLabel => 'Chủ đề:';

  @override
  String newsPaginationInfo(int page, int total) {
    return 'Trang $page/$total';
  }

  @override
  String get newsPaginationNext => 'Sau';

  @override
  String get newsEmptyFiltered => 'Không có bài nào phù hợp bộ lọc.';

  @override
  String get newsEmptyNone => 'Chưa có tin tức.';

  @override
  String get newsChooseLevelLabel => 'Chọn trình độ đọc';

  @override
  String get newsOtherLevelsPrefix =>
      '💡 Bạn có thể đọc bài này ở trình độ khác: ';

  @override
  String get newsListenFullStory => 'Nghe toàn bài';

  @override
  String get newsAudioSpeedSlow => 'Chậm';

  @override
  String get newsAudioSpeedNormal => 'Thường';

  @override
  String get newsVocabTitle => 'Từ vựng';

  @override
  String get newsHasAudioLabel => 'Có audio';

  @override
  String get newsLeaderboardTitleWeekly => 'Bảng xếp hạng tuần';

  @override
  String get newsLeaderboardSubtitleWeekly =>
      'Số bài tin tức hoàn thành trong tuần này';

  @override
  String get newsLeaderboardEmpty => 'Chưa có ai hoàn thành bài nào tuần này';

  @override
  String get newsQuizTitle => 'Câu hỏi kiểm tra';

  @override
  String get newsQuizSubmit => 'Nộp bài';

  @override
  String newsQuizResult(int correct, int total, int percent) {
    return 'Kết quả: $correct/$total câu đúng ($percent%)';
  }

  @override
  String get newsQuizPassedSuffix => ' — Đã lưu tiến độ ✅';

  @override
  String get saveWordsCtaDone => '✓ Đã thêm — sẽ xuất hiện trong Ôn tập';

  @override
  String saveWordsCtaSave(int count) {
    return '📥 Lưu $count từ mới vào Kho ôn';
  }

  @override
  String saveWordsCtaResolvedCount(int resolvable, int total) {
    return '$resolvable/$total từ có trong hệ thống';
  }

  @override
  String get saveWordsCtaError => 'Không thể lưu từ vựng, thử lại sau.';

  @override
  String get newsStoryNotFound => 'Không tìm thấy tin tức.';

  @override
  String get yesterday => 'Hôm qua';

  @override
  String newsWeeklyRingProgress(int done, int total) {
    return 'Tuần này bạn đã đọc $done/$total bài mới xuất bản';
  }

  @override
  String get newsWeeklyRingEmpty => 'Chưa có bài mới xuất bản tuần này';

  @override
  String get readingListenFullStory => 'Nghe toàn bài';

  @override
  String get readingAudioSpeedTooltip => 'Tốc độ';
}
