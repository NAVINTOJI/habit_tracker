import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/discipline_repository.dart';
import '../models/day_record.dart';
import '../models/streak_data.dart';
import '../utils/date_utils.dart';
import '../core/result.dart';
import '../core/constants.dart';

final disciplineServiceProvider = Provider((ref) {
  final repository = ref.watch(disciplineRepositoryProvider);
  return DisciplineService(repository);
});

class DisciplineService {
  final DisciplineRepository _repository;

  DisciplineService(this._repository);

  List<String> get defaultTasks => AppConstants.defaultTasks;

  Result<DayRecord> getTodayRecord() {
    final today = DateUtilsExt.startOfDay(DateTime.now());
    return getDayRecord(today);
  }

  Result<DayRecord> getDayRecord(DateTime date) {
    final normalized = DateUtilsExt.startOfDay(date);
    final recordResult = _repository.getDayRecord(normalized);
    
    return recordResult.fold(
      onSuccess: (record) => Success(record ?? _createNewDayRecord(normalized)),
      onFailure: (message) => Failure(message),
    );
  }

  Result<void> toggleTask(DateTime date, String taskName) {
    try {
      final recordResult = getDayRecord(date);
      
      return recordResult.fold(
        onSuccess: (record) {
          // Use immutable update method
          final updatedRecord = record.withTaskToggled(taskName);
          return _repository.saveDayRecord(updatedRecord);
        },
        onFailure: (message) => Failure(message),
      );
    } catch (e) {
      return Failure('Failed to toggle task: $e', e as Exception?);
    }
  }

  Result<void> processMissedDays() {
    try {
      final today = DateUtilsExt.startOfDay(DateTime.now());
      final lastRecordResult = _repository.getLastRecord();
      
      return lastRecordResult.fold(
        onSuccess: (lastRecord) {
          if (lastRecord == null) return const Success(null);

          DateTime checkDate = lastRecord.date.add(const Duration(days: 1));
          
          while (checkDate.isBefore(today)) {
            final existingResult = _repository.getDayRecord(checkDate);
            existingResult.fold(
              onSuccess: (existing) {
                if (existing == null) {
                  final missedRecord = _createMissedDayRecord(checkDate);
                  _repository.saveDayRecord(missedRecord);
                }
              },
              onFailure: (_) {}, // Continue processing other days
            );
            checkDate = checkDate.add(const Duration(days: 1));
          }
          
          return const Success(null);
        },
        onFailure: (message) => Failure(message),
      );
    } catch (e) {
      return Failure('Failed to process missed days: $e', e as Exception?);
    }
  }

  Result<StreakData> calculateStreak() {
    try {
      final allRecordsResult = _repository.getAllRecords();
      
      return allRecordsResult.fold(
        onSuccess: (allRecords) {
          if (allRecords.isEmpty) {
            return const Success(StreakData(currentStreak: 0, bestStreak: 0));
          }

          allRecords.sort((a, b) => b.date.compareTo(a.date));

          int bestStreak = 0;
          int tempStreak = 0;
          DateTime? lastPerfectDay;

          // Calculate best streak
          for (var record in allRecords) {
            if (record.isPerfect) {
              tempStreak++;
              if (tempStreak > bestStreak) {
                bestStreak = tempStreak;
              }
              lastPerfectDay ??= record.date;
            } else {
              tempStreak = 0;
            }
          }

          // Calculate current streak - must be consecutive days from today
          int currentStreak = 0;
          final today = DateUtilsExt.startOfDay(DateTime.now());
          DateTime checkDate = today;
          
          for (var record in allRecords) {
            if (DateUtilsExt.isSameDay(record.date, checkDate)) {
              if (record.isPerfect) {
                currentStreak++;
                checkDate = checkDate.subtract(const Duration(days: 1));
              } else {
                break;
              }
            } else if (record.date.isBefore(checkDate)) {
              // Gap in records, streak broken
              break;
            }
          }

          return Success(StreakData(
            currentStreak: currentStreak,
            bestStreak: bestStreak,
            lastPerfectDay: lastPerfectDay,
          ));
        },
        onFailure: (message) => Failure(message),
      );
    } catch (e) {
      return Failure('Failed to calculate streak: $e', e as Exception?);
    }
  }

  Result<List<DayRecord>> getRecordsForMonth(DateTime month) {
    return _repository.getRecordsForMonth(month);
  }

  Result<List<DayRecord>> getRecentRecords(int days) {
    return _repository.getRecentRecords(days);
  }

  DayRecord _createNewDayRecord(DateTime date) {
    final tasks = <String, TaskStatus>{};
    for (var task in defaultTasks) {
      tasks[task] = TaskStatus.pending;
    }
    
    return DayRecord(
      date: date,
      tasks: tasks,
      isPerfect: false,
    );
  }

  DayRecord _createMissedDayRecord(DateTime date) {
    final tasks = <String, TaskStatus>{};
    for (var task in defaultTasks) {
      tasks[task] = TaskStatus.missed;
    }
    
    return DayRecord(
      date: date,
      tasks: tasks,
      isPerfect: false,
    );
  }
}
