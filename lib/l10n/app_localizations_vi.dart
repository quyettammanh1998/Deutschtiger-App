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
  String get coursesLessonCompleted => 'Đã hoàn thành';

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
  String get grammarArticles => 'Bài đọc thêm';

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
  String get topicExploreTitle => 'Khám phá theo chủ đề';

  @override
  String get topicExploreEmpty => 'Chưa có chủ đề nào.';

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
  String get practiceListeningPrompt => 'Nghe và chọn nghĩa đúng';

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
  String get subtitleWordsTitle => 'Từ trong phụ đề';

  @override
  String get subtitleWordsEmpty =>
      'Chưa có từ mới nào từ phụ đề. Xem video có phụ đề để gom từ tại đây.';

  @override
  String subtitleWordsSeenCount(int count) {
    return 'gặp $count lần';
  }

  @override
  String subtitleWordsAddSelected(int count) {
    return 'Thêm $count vào ôn tập';
  }

  @override
  String subtitleWordsAddedCount(int count) {
    return 'Đã thêm $count từ vào hàng đợi ôn tập';
  }

  @override
  String get subtitleWordsAddFailed =>
      'Không thể lưu các từ đã chọn. Vui lòng thử lại.';

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
}
