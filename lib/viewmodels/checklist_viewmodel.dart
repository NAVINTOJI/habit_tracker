import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/discipline_service.dart';
import '../models/day_record.dart';
import '../core/constants.dart';
import '../core/result.dart';

final checklistViewModelProvider = StateNotifierProvider<ChecklistViewModel, ChecklistState>((ref) {
  final service = ref.watch(disciplineServiceProvider);
  return ChecklistViewModel(service);
});

class ChecklistViewModel extends StateNotifier<ChecklistState> {
  final DisciplineService _service;
  Timer? _debounceTimer;

  ChecklistViewModel(this._service) : super(ChecklistState.initial()) {
    loadToday();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void loadToday() {
    state = state.copyWith(isLoading: true);
    
    final recordResult = _service.getTodayRecord();
    
    recordResult.fold(
      onSuccess: (record) {
        state = state.copyWith(
          currentRecord: record,
          selectedDate: record.date,
          isToday: true,
          isLoading: false,
          error: null,
        );
      },
      onFailure: (message) {
        state = state.copyWith(
          error: message,
          isLoading: false,
        );
      },
    );
  }

  void loadDate(DateTime date) {
    state = state.copyWith(isLoading: true);
    
    final recordResult = _service.getDayRecord(date);
    final now = DateTime.now();
    final isToday = date.year == now.year && 
                   date.month == now.month && 
                   date.day == now.day;
    
    recordResult.fold(
      onSuccess: (record) {
        state = state.copyWith(
          currentRecord: record,
          selectedDate: date,
          isToday: isToday,
          isLoading: false,
          error: null,
        );
      },
      onFailure: (message) {
        state = state.copyWith(
          error: message,
          isLoading: false,
        );
      },
    );
  }

  void toggleTask(String taskName) {
    if (!state.isToday) return;
    
    // Cancel existing debounce timer
    _debounceTimer?.cancel();
    
    // Optimistic UI update
    final optimisticRecord = state.currentRecord.withTaskToggled(taskName);
    state = state.copyWith(currentRecord: optimisticRecord);
    
    // Debounce the actual save
    _debounceTimer = Timer(AppConstants.toggleDebounce, () {
      final toggleResult = _service.toggleTask(state.selectedDate, taskName);
      
      toggleResult.fold(
        onSuccess: (_) {
          // Reload to ensure consistency
          loadToday();
        },
        onFailure: (message) {
          // Rollback on error
          state = state.copyWith(error: message);
          loadToday();
        },
      );
    });
  }

  void refresh() {
    if (state.isToday) {
      loadToday();
    } else {
      loadDate(state.selectedDate);
    }
  }
}

class ChecklistState {
  final DayRecord currentRecord;
  final DateTime selectedDate;
  final bool isToday;
  final bool isLoading;
  final String? error;

  ChecklistState({
    required this.currentRecord,
    required this.selectedDate,
    required this.isToday,
    this.isLoading = false,
    this.error,
  });

  factory ChecklistState.initial() {
    final now = DateTime.now();
    return ChecklistState(
      currentRecord: DayRecord(
        date: now,
        tasks: {},
        isPerfect: false,
      ),
      selectedDate: now,
      isToday: true,
      isLoading: true,
    );
  }

  ChecklistState copyWith({
    DayRecord? currentRecord,
    DateTime? selectedDate,
    bool? isToday,
    bool? isLoading,
    String? error,
  }) {
    return ChecklistState(
      currentRecord: currentRecord ?? this.currentRecord,
      selectedDate: selectedDate ?? this.selectedDate,
      isToday: isToday ?? this.isToday,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
