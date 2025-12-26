import 'package:hive/hive.dart';

part 'day_record.g.dart';

@HiveType(typeId: 0)
class DayRecord extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  Map<String, TaskStatus> tasks;

  @HiveField(2)
  bool isPerfect;

  DayRecord({
    required this.date,
    required this.tasks,
    this.isPerfect = false,
  });

  bool get isComplete {
    return tasks.values.every((status) => status != TaskStatus.pending);
  }

  bool get isFailed {
    return tasks.values.any((status) => status == TaskStatus.missed);
  }

  int get completedCount {
    return tasks.values.where((status) => status == TaskStatus.completed).length;
  }

  int get totalCount {
    return tasks.length;
  }

  double get completionPercentage {
    if (totalCount == 0) return 0.0;
    return (completedCount / totalCount) * 100;
  }

  void checkTaskCompletion() {
    isPerfect = tasks.values.every((status) => status == TaskStatus.completed);
  }

  /// Creates a defensive copy of this record
  DayRecord copyWith({
    DateTime? date,
    Map<String, TaskStatus>? tasks,
    bool? isPerfect,
  }) {
    return DayRecord(
      date: date ?? this.date,
      tasks: tasks != null ? Map<String, TaskStatus>.from(tasks) : Map<String, TaskStatus>.from(this.tasks),
      isPerfect: isPerfect ?? this.isPerfect,
    );
  }

  /// Creates a copy with a task status updated
  DayRecord withTaskToggled(String taskName) {
    final newTasks = Map<String, TaskStatus>.from(tasks);
    final currentStatus = newTasks[taskName] ?? TaskStatus.pending;
    
    newTasks[taskName] = switch (currentStatus) {
      TaskStatus.pending => TaskStatus.completed,
      TaskStatus.completed => TaskStatus.pending,
      TaskStatus.missed => TaskStatus.missed, // Can't toggle missed tasks
    };
    
    final newIsPerfect = newTasks.values.every((status) => status == TaskStatus.completed);
    
    return DayRecord(
      date: date,
      tasks: newTasks,
      isPerfect: newIsPerfect,
    );
  }
}

@HiveType(typeId: 1)
enum TaskStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  completed,
  @HiveField(2)
  missed,
}
