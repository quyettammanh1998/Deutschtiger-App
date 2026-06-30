import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Supported locales.
enum AppLocale {
  vietnamese('vi', 'Tiếng Việt'),
  english('en', 'English'),
  german('de', 'Deutsch');

  const AppLocale(this.code, this.displayName);
  final String code;
  final String displayName;
}

class LocaleNotifier extends Notifier<AppLocale> {
  @override
  AppLocale build() => AppLocale.vietnamese;

  void setLocale(AppLocale locale) => state = locale;
}

final localeProvider = NotifierProvider<LocaleNotifier, AppLocale>(LocaleNotifier.new);

class I18nService {
  const I18nService();

  String translate(AppLocale locale, String key) {
    return _translations[locale.code]?[key] ?? key;
  }

  static const _translations = {
    'vi': {
      'login': 'Đăng nhập',
      'signup': 'Đăng ký',
      'email': 'Email',
      'password': 'Mật khẩu',
      'home': 'Trang chủ',
      'settings': 'Cài đặt',
      'profile': 'Hồ sơ',
      'logout': 'Đăng xuất',
      'vocabulary': 'Từ vựng',
      'grammar': 'Ngữ pháp',
      'quiz': 'Bài luyện tập',
      'leaderboard': 'Bảng xếp hạng',
      'achievements': 'Thành tựu',
      'progress': 'Tiến độ',
      'decks': 'Bộ từ',
      'search': 'Tìm kiếm',
      'saved': 'Đã lưu',
      'dark_mode': 'Chế độ tối',
      'notifications': 'Thông báo',
      'language': 'Ngôn ngữ',
      'account': 'Tài khoản',
      'daily_reminder': 'Nhắc nhở hàng ngày',
    },
    'en': {
      'login': 'Login',
      'signup': 'Sign up',
      'email': 'Email',
      'password': 'Password',
      'home': 'Home',
      'settings': 'Settings',
      'profile': 'Profile',
      'logout': 'Logout',
      'vocabulary': 'Vocabulary',
      'grammar': 'Grammar',
      'quiz': 'Practice',
      'leaderboard': 'Leaderboard',
      'achievements': 'Achievements',
      'progress': 'Progress',
      'decks': 'Word Decks',
      'search': 'Search',
      'saved': 'Saved',
      'dark_mode': 'Dark mode',
      'notifications': 'Notifications',
      'language': 'Language',
      'account': 'Account',
      'daily_reminder': 'Daily reminder',
    },
    'de': {
      'login': 'Anmelden',
      'signup': 'Registrieren',
      'email': 'E-Mail',
      'password': 'Passwort',
      'home': 'Startseite',
      'settings': 'Einstellungen',
      'profile': 'Profil',
      'logout': 'Abmelden',
      'vocabulary': 'Wortschatz',
      'grammar': 'Grammatik',
      'quiz': 'Übung',
      'leaderboard': 'Rangliste',
      'achievements': 'Erfolge',
      'progress': 'Fortschritt',
      'decks': 'Wortpakete',
      'search': 'Suchen',
      'saved': 'Gespeichert',
      'dark_mode': 'Dunkelmodus',
      'notifications': 'Benachrichtigungen',
      'language': 'Sprache',
      'account': 'Konto',
      'daily_reminder': 'Tägliche Erinnerung',
    },
  };
}

final i18nServiceProvider = Provider<I18nService>((ref) => const I18nService());
