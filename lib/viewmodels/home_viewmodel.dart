import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/discipline_service.dart';
import '../services/quote_service.dart';
import '../models/streak_data.dart';
import '../core/result.dart';

final homeViewModelProvider = StateNotifierProvider<HomeViewModel, HomeState>((ref) {
  final service = ref.watch(disciplineServiceProvider);
  return HomeViewModel(service);
});

class HomeViewModel extends StateNotifier<HomeState> {
  final DisciplineService _service;
  final QuoteService _quoteService = QuoteService();

  HomeViewModel(this._service) : super(HomeState.initial()) {
    _initialize();
  }

  Future<void> _initialize() async {
    state = state.copyWith(isLoading: true);
    
    // Process missed days
    final processResult = _service.processMissedDays();
    processResult.fold(
      onSuccess: (_) {},
      onFailure: (message) {
        state = state.copyWith(error: message, isLoading: false);
        return;
      },
    );
    
    await refresh();
  }

  Future<void> refresh() async {
    state = state.copyWith(isRefreshing: true, error: null);
    
    final streakResult = _service.calculateStreak();
    
    streakResult.fold(
      onSuccess: (streak) {
        final quote = _quoteService.getRandomQuote();
        final message = _quoteService.getMotivationalMessage(streak.currentStreak);
        
        state = state.copyWith(
          streak: streak,
          quote: quote,
          motivationalMessage: message,
          isLoading: false,
          isRefreshing: false,
          error: null,
        );
      },
      onFailure: (message) {
        state = state.copyWith(
          error: message,
          isLoading: false,
          isRefreshing: false,
        );
      },
    );
  }
}

class HomeState {
  final StreakData streak;
  final String quote;
  final String motivationalMessage;
  final bool isLoading;
  final bool isRefreshing;
  final String? error;

  HomeState({
    required this.streak,
    required this.quote,
    required this.motivationalMessage,
    this.isLoading = false,
    this.isRefreshing = false,
    this.error,
  });

  factory HomeState.initial() {
    return HomeState(
      streak: StreakData(currentStreak: 0, bestStreak: 0),
      quote: "Loading...",
      motivationalMessage: "Let's begin!",
      isLoading: true,
    );
  }

  HomeState copyWith({
    StreakData? streak,
    String? quote,
    String? motivationalMessage,
    bool? isLoading,
    bool? isRefreshing,
    String? error,
  }) {
    return HomeState(
      streak: streak ?? this.streak,
      quote: quote ?? this.quote,
      motivationalMessage: motivationalMessage ?? this.motivationalMessage,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: error,
    );
  }
}
