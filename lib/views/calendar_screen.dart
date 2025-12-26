import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../theme/design_tokens.dart';
import '../services/discipline_service.dart';
import '../models/day_record.dart';
import '../core/result.dart';
import '../widgets/cinematic_background.dart';
import '../widgets/glass_card.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final disciplineService = ref.watch(disciplineServiceProvider);
    final monthRecordsResult = disciplineService.getRecordsForMonth(_focusedMonth);
    
    final monthRecords = monthRecordsResult.valueOrNull ?? <DayRecord>[];

    // Map records by day for easy lookup
    final recordsByDay = <int, DayRecord>{
      for (var record in monthRecords) record.date.day: record
    };

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('HISTORY'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: CinematicBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildMonthHeader(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(DesignTokens.spaceLG),
                  child: GlassCard(
                    child: Column(
                      children: [
                        _buildDaysOfWeek(),
                        const SizedBox(height: DesignTokens.spaceMD),
                        Expanded(
                          child: _buildCalendarGrid(recordsByDay),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _buildLegend(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spaceLG),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spaceMD,
          vertical: DesignTokens.spaceSM,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, color: Colors.white),
              onPressed: () {
                setState(() {
                  _focusedMonth = DateTime(
                    _focusedMonth.year,
                    _focusedMonth.month - 1,
                  );
                });
              },
            ),
            Text(
              DateFormat('MMMM yyyy').format(_focusedMonth).toUpperCase(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Colors.white,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: Colors.white),
              onPressed: () {
                setState(() {
                  _focusedMonth = DateTime(
                    _focusedMonth.year,
                    _focusedMonth.month + 1,
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaysOfWeek() {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days
          .map((d) => Text(
                d,
                style: const TextStyle(
                  color: Colors.white54,
                  fontWeight: FontWeight.bold,
                ),
              ))
          .toList(),
    );
  }

  Widget _buildCalendarGrid(Map<int, DayRecord> records) {
    final daysInMonth = DateUtils.getDaysInMonth(
      _focusedMonth.year,
      _focusedMonth.month,
    );
    final firstDayOffset = DateTime(
      _focusedMonth.year,
      _focusedMonth.month,
      1,
    ).weekday - 1;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: daysInMonth + firstDayOffset,
      itemBuilder: (context, index) {
        if (index < firstDayOffset) return const SizedBox();

        final day = index - firstDayOffset + 1;
        final record = records[day];

        return _buildDayCell(day, record);
      },
    );
  }

  Widget _buildDayCell(int day, DayRecord? record) {
    Color? bgColor;
    Color textColor = Colors.white;

    if (record != null) {
      if (record.isPerfect) {
        bgColor = AppTheme.successGreen;
        textColor = Colors.black;
      } else if (record.isFailed) {
        bgColor = AppTheme.failureRed;
      } else {
        // Partial or pending
        final percentage = record.completionPercentage;
        if (percentage > 0) {
          bgColor = Colors.white.withOpacity(0.1 + (percentage / 100) * 0.4);
        }
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: bgColor ?? Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: record?.isPerfect == true
            ? Border.all(color: AppTheme.successGreen, width: 2)
            : null,
      ),
      child: Center(
        child: Text(
          '$day',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.all(DesignTokens.spaceLG),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildLegendItem(AppTheme.successGreen, 'Perfect'),
          _buildLegendItem(AppTheme.failureRed, 'Failed'),
          _buildLegendItem(Colors.white.withOpacity(0.2), 'Partial'),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }
}
