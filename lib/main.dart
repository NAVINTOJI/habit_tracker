import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'models/day_record.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  Hive.registerAdapter(DayRecordAdapter());
  Hive.registerAdapter(TaskStatusAdapter());
  
  await Hive.openBox<DayRecord>('days');
  await Hive.openBox('settings');
  
  runApp(const ProviderScope(child: DisciplineApp()));
}
