import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/day_record.dart';
import '../utils/date_utils.dart';
import '../core/result.dart';

final disciplineRepositoryProvider = Provider((ref) => DisciplineRepository());

class DisciplineRepository {
  Box<DayRecord>? _boxCache;
  
  Box<DayRecord> get _box {
    try {
      _boxCache ??= Hive.box<DayRecord>('days');
      return _boxCache!;
    } catch (e) {
      throw Exception('Failed to access Hive box: $e');
    }
  }

  String _getKey(DateTime date) {
    final normalized = DateUtilsExt.startOfDay(date);
    return normalized.toIso8601String().split('T')[0];
  }

  Result<DayRecord?> getDayRecord(DateTime date) {
    try {
      final key = _getKey(date);
      final record = _box.get(key);
      // Return defensive copy to prevent external mutations
      return Success(record?.copyWith());
    } catch (e) {
      return Failure('Failed to get day record: $e', e as Exception?);
    }
  }

  Result<void> saveDayRecord(DayRecord record) {
    try {
      final key = _getKey(record.date);
      // Store a copy to prevent external mutations affecting stored data
      _box.put(key, record.copyWith());
      return const Success(null);
    } catch (e) {
      return Failure('Failed to save day record: $e', e as Exception?);
    }
  }

  Result<List<DayRecord>> getAllRecords() {
    try {
      // Return defensive copies
      final records = _box.values.map((r) => r.copyWith()).toList();
      return Success(records);
    } catch (e) {
      return Failure('Failed to get all records: $e', e as Exception?);
    }
  }

  Result<DayRecord?> getLastRecord() {
    try {
      final recordsResult = getAllRecords();
      return recordsResult.fold(
        onSuccess: (records) {
          if (records.isEmpty) return const Success(null);
          records.sort((a, b) => b.date.compareTo(a.date));
          return Success(records.first);
        },
        onFailure: (message) => Failure(message),
      );
    } catch (e) {
      return Failure('Failed to get last record: $e', e as Exception?);
    }
  }

  Result<List<DayRecord>> getRecordsForMonth(DateTime month) {
    try {
      final startOfMonth = DateTime(month.year, month.month, 1);
      final endOfMonth = DateTime(month.year, month.month + 1, 0);
      
      final records = _box.values.where((record) {
        return record.date.isAfter(startOfMonth.subtract(const Duration(days: 1))) &&
               record.date.isBefore(endOfMonth.add(const Duration(days: 1)));
      }).map((r) => r.copyWith()).toList();
      
      return Success(records);
    } catch (e) {
      return Failure('Failed to get records formonth: $e', e as Exception?);
    }
  }

  Result<List<DayRecord>> getRecentRecords(int days) {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: days));
      
      final records = _box.values.where((record) {
        return record.date.isAfter(cutoffDate);
      }).map((r) => r.copyWith()).toList();
      
      records.sort((a, b) => b.date.compareTo(a.date));
      return Success(records);
    } catch (e) {
      return Failure('Failed to get recent records: $e', e as Exception?);
    }
  }

  Result<void> deleteRecord(DateTime date) {
    try {
      final key = _getKey(date);
      _box.delete(key);
      return const Success(null);
    } catch (e) {
      return Failure('Failed to delete record: $e', e as Exception?);
    }
  }

  Result<void> clearAllRecords() {
    try {
      _box.clear();
      return const Success(null);
    } catch (e) {
      return Failure('Failed to clear records: $e', e as Exception?);
    }
  }
}
