import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../repositories/social/social_repository.dart';
import '../../data/social/social_models.dart';

final socialRepositoryProvider = Provider((ref) => SocialRepository());

final momentsProvider = FutureProvider.family<List<SocialMoment>, int>((ref, page) async {
  final repo = ref.watch(socialRepositoryProvider);
  return repo.getMoments(page: page);
});

final studyGroupsProvider = FutureProvider<List<StudyGroup>>((ref) async {
  final repo = ref.watch(socialRepositoryProvider);
  return repo.getStudyGroups();
});

final challengesProvider = FutureProvider<List<Challenge>>((ref) async {
  final repo = ref.watch(socialRepositoryProvider);
  return repo.getChallenges();
});

final friendsProvider = FutureProvider<List<Friend>>((ref) async {
  final repo = ref.watch(socialRepositoryProvider);
  return repo.getFriends();
});

final conversationsProvider = FutureProvider<List<ChatConversation>>((ref) async {
  final repo = ref.watch(socialRepositoryProvider);
  return repo.getConversations();
});

class SocialNotifier extends Notifier<SocialState> {
  final SocialRepository _repo = SocialRepository();

  @override
  SocialState build() => SocialState();

  Future<void> loadMoments({int page = 1}) async {
    state = state.copyWith(isLoading: true);
    try {
      final moments = await _repo.getMoments(page: page);
      state = state.copyWith(
        moments: page == 1 ? moments : [...state.moments, ...moments],
        currentPage: page,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> createMoment(String content, {String? imageUrl}) async {
    try {
      final moment = await _repo.createMoment(content, imageUrl: imageUrl);
      state = state.copyWith(moments: [moment, ...state.moments]);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> likeMoment(String momentId) async {
    await _repo.likeMoment(momentId);
    final moments = state.moments.map((m) {
      if (m.id == momentId) {
        return m.copyWith(
          isLiked: !m.isLiked,
          likes: m.isLiked ? m.likes - 1 : m.likes + 1,
        );
      }
      return m;
    }).toList();
    state = state.copyWith(moments: moments);
  }

  void selectConversation(ChatConversation? conversation) {
    state = state.copyWith(selectedConversation: conversation);
  }

  void setSelectedTab(int index) {
    state = state.copyWith(selectedTab: index);
  }
}

class SocialState {
  final List<SocialMoment> moments;
  final ChatConversation? selectedConversation;
  final int currentPage;
  final bool isLoading;
  final String? error;
  final int selectedTab;

  SocialState({
    this.moments = const [],
    this.selectedConversation,
    this.currentPage = 1,
    this.isLoading = false,
    this.error,
    this.selectedTab = 0,
  });

  SocialState copyWith({
    List<SocialMoment>? moments,
    ChatConversation? selectedConversation,
    int? currentPage,
    bool? isLoading,
    String? error,
    int? selectedTab,
  }) {
    return SocialState(
      moments: moments ?? this.moments,
      selectedConversation: selectedConversation ?? this.selectedConversation,
      currentPage: currentPage ?? this.currentPage,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }
}

final socialNotifierProvider = NotifierProvider<SocialNotifier, SocialState>(
  SocialNotifier.new,
);

final selectedTabProvider = Provider<int>((ref) {
  final socialState = ref.watch(socialNotifierProvider);
  return socialState.selectedTab;
});
