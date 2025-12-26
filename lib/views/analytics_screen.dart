import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_theme.dart';
import '../theme/design_tokens.dart';
import '../services/discipline_service.dart';
import '../models/day_record.dart';
import '../core/result.dart';
import '../widgets/cinematic_background.dart';
import '../widgets/glass_card.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final disciplineService = ref.watch(disciplineServiceProvider);
    
    final recentRecordsResult = disciplineService.getRecentRecords(7);
    final recentRecords = recentRecordsResult.valueOrNull ?? <DayRecord>[];
    
    final streakResult = disciplineService.calculateStreak();
    final streak = streakResult.valueOrNull;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('PERFORMANCE'),
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(DesignTokens.spaceLG),
            child: Column(
              children: [
                _buildStatGrid(streak?.currentStreak ?? 0, streak?.bestStreak ?? 0),
                const SizedBox(height: DesignTokens.spaceLG),
                _buildChartCard(recentRecords),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatGrid(int currentStreak, int bestStreak) {
    return Row(
      children: [
        Expanded(
          child: GlassCard(
            padding: const EdgeInsets.all(DesignTokens.spaceMD),
            child: Column(
              children: [
                const Icon(Icons.bolt, color: AppTheme.primaryOrange, size: 32),
                const SizedBox(height: DesignTokens.spaceSM),
                Text(
                  '$currentStreak',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'Current Streak',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: DesignTokens.spaceMD),
        Expanded(
          child: GlassCard(
            padding: const EdgeInsets.all(DesignTokens.spaceMD),
            child: Column(
              children: [
                const Icon(Icons.emoji_events, color: AppTheme.accentYellow, size: 32),
                const SizedBox(height: DesignTokens.spaceSM),
                Text(
                  '$bestStreak',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'Best Record',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChartCard(List<DayRecord> records) {
    return GlassCard(
      height: 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Last 7 Days',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: DesignTokens.spaceLG),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: AppTheme.cardDark,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toInt()}%',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < records.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              (value.toInt() + 1).toString(), 
                              style: const TextStyle(color: Colors.white54, fontSize: 12),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: records.asMap().entries.map((entry) {
                  final index = entry.key;
                  final record = entry.value;
                  final percentage = record.completionPercentage;
                  
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: percentage,
                        color: percentage >= 100 
                            ? AppTheme.successGreen 
                            : percentage > 0 
                                ? AppTheme.primaryOrange 
                                : AppTheme.failureRed.withOpacity(0.5),
                        width: 16,
                        borderRadius: BorderRadius.circular(4),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: 100,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
