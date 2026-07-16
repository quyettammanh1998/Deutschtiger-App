import '../../../l10n/app_localizations.dart';

/// One "learning goal" entry point — web parity: `GOAL_VOCAB_PATHS` in
/// `vocabulary-page.tsx`. `title` is ARB'd (short, matches existing 7-goal
/// pattern); `description` stays inline Vietnamese like the web copy (short
/// marketing blurb — same exception class as other hardcoded VN UI strings
/// per the plan's ARB rule).
class GoalVocabPath {
  const GoalVocabPath({
    required this.id,
    required this.icon,
    required this.description,
    required this.topicKeys,
  });

  final String id;
  final String icon;
  final String description;
  final List<String> topicKeys;

  String title(AppLocalizations l10n) => switch (id) {
    'daily-life' => l10n.goalDailyLife,
    'settlement-home' => l10n.goalSettlementHome,
    'travel' => l10n.goalTravel,
    'food-service' => l10n.goalFoodService,
    'work' => l10n.goalWork,
    'medical' => l10n.goalMedical,
    'study-exam' => l10n.goalStudyExam,
    'tech-engineering' => l10n.goalTechEngineering,
    'shopping-beauty' => l10n.goalShoppingBeauty,
    'family-social' => l10n.goalFamilySocial,
    'leisure-culture' => l10n.goalLeisureCulture,
    'nature-environment' => l10n.goalNatureEnvironment,
    _ => id,
  };
}

/// Web parity: `GOAL_VOCAB_PATHS` (`vocabulary-page.tsx:50-249`) — all 13
/// entries, same topic-key sets.
const kGoalVocabPaths = <GoalVocabPath>[
  GoalVocabPath(
    id: 'daily-life',
    icon: '🏙️',
    description: 'Những nhóm từ dùng thường xuyên khi sống, hỏi đường, mua đồ và nói chuyện cơ bản.',
    topicKeys: ['alltag', 'time', 'numbers', 'people', 'feelings-and-emotions', 'familie', 'family-members', 'einkaufen', 'restaurant'],
  ),
  GoalVocabPath(
    id: 'settlement-home',
    icon: '🏠',
    description: 'Từ vựng cần cho thuê nhà, vật dụng, giấy tờ đời sống và sinh hoạt tại Đức.',
    topicKeys: ['wohnen', 'house', 'furniture', 'bathroom', 'buildings-and-places', 'countries', 'traffic'],
  ),
  GoalVocabPath(
    id: 'travel',
    icon: '🧳',
    description: 'Sân bay, khách sạn, phương tiện, lái xe và các tình huống đi lại.',
    topicKeys: ['reisen', 'travel', 'traffic', 'vehicles-and-transportation', 'car-driving-vocabulary', 'car-parts', 'hotel-vocabulary', 'camping', 'countries'],
  ),
  GoalVocabPath(
    id: 'food-service',
    icon: '🍽️',
    description: 'Đồ ăn, đồ uống, bếp, gọi món, khách sạn và nghề đầu bếp.',
    topicKeys: ['restaurant', 'food', 'drinks', 'kitchen', 'chef-vocabulary', 'restaurant-and-hotel-vocabulary', 'hotel-vocabulary'],
  ),
  GoalVocabPath(
    id: 'work',
    icon: '💼',
    description: 'Nghề nghiệp, kinh doanh, dịch vụ và các nhóm từ chuyên ngành.',
    topicKeys: ['arbeit', 'jobs', 'business', 'sales-vocabulary', 'sample-sentences-for-sales-topics', 'hotel-vocabulary', 'restaurant-and-hotel-vocabulary', 'chef-vocabulary', 'computer-science-vocabulary', 'construction-vocabulary', 'mechanical-vocabulary', 'vocabulary-specialized-electricity', 'materials-elements', 'nail-vocabulary'],
  ),
  GoalVocabPath(
    id: 'medical',
    icon: '🩺',
    description: 'Từ vựng sức khỏe, điều dưỡng, nha khoa và chăm sóc bệnh nhân.',
    topicKeys: ['gesundheit', 'body-parts', 'health-fitness', 'nursing-vocabulary', 'dental-assistant-vocabulary'],
  ),
  GoalVocabPath(
    id: 'study-exam',
    icon: '🎓',
    description: 'Trường học, toán, từ nối, trạng từ và các nhóm ngữ pháp hay gặp trong bài thi.',
    topicKeys: ['schule', 'school-education', 'premium-gifts', 'verbs-with-prepositions', 'adjectives-with-prepositions', 'conjunction', 'adverb-zeit', 'adverb-ort', 'adverb-haufigkeit', 'adverb-grad', 'math-and-geometry'],
  ),
  GoalVocabPath(
    id: 'tech-engineering',
    icon: '🛠️',
    description: 'Tin học, điện tử, cơ khí, xây dựng, ô tô, vật liệu và khoa học.',
    topicKeys: ['medien', 'computer-science-vocabulary', 'tech-electronics', 'car-technology', 'mechanical-vocabulary', 'construction-vocabulary', 'vocabulary-specialized-electricity', 'materials-elements', 'science'],
  ),
  GoalVocabPath(
    id: 'shopping-beauty',
    icon: '🛍️',
    description: 'Quần áo, màu sắc, mỹ phẩm, nail, trang sức và giao tiếp khi mua hàng.',
    topicKeys: ['einkaufen', 'shopping', 'clothes-accessories', 'beauty-cosmetics', 'nail-vocabulary', 'jewelry', 'colors'],
  ),
  GoalVocabPath(
    id: 'family-social',
    icon: '👥',
    description: 'Gia đình, con người, cảm xúc, tình yêu và những câu nói trong quan hệ xã hội.',
    topicKeys: ['familie', 'family-members', 'people', 'feelings-and-emotions', 'vocabulary-about-love', 'love-vocabulary-words', 'ways-to-express-love-in-german', 'best-vocabulary-phrases-about-love'],
  ),
  GoalVocabPath(
    id: 'leisure-culture',
    icon: '🎭',
    description: 'Thể thao, phim ảnh, nghệ thuật, trò chơi, lễ hội và các dịp đặc biệt.',
    topicKeys: ['freizeit', 'sports', 'games-entertainment', 'film-and-television', 'art', 'festival', 'christmas', 'easter', 'winter', 'tet-holiday'],
  ),
  GoalVocabPath(
    id: 'nature-environment',
    icon: '🌿',
    description: 'Động vật, cây cối, thời tiết, khoa học tự nhiên và hoạt động ngoài trời.',
    topicKeys: ['natur', 'animals', 'plants', 'weather', 'science', 'camping'],
  ),
];
