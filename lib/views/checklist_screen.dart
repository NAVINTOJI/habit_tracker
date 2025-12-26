import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../theme/design_tokens.dart';
import '../viewmodels/checklist_viewmodel.dart';
import '../widgets/cinematic_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/animated_checkbox.dart';
import '../widgets/neumorphic_button.dart';
import '../models/day_record.dart';

class ChecklistScreen extends ConsumerWidget {
  const ChecklistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(checklistViewModelProvider);
    final notifier = ref.read(checklistViewModelProvider.notifier);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('DAILY CHECKLIST'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.white),
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: state.selectedDate,
                firstDate: DateTime(2024),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                    data: AppTheme.darkTheme.copyWith(
                      colorScheme: const ColorScheme.dark(
                        primary: AppTheme.primaryRed,
                        surface: AppTheme.cardDark,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (date != null) {
                notifier.loadDate(date);
              }
            },
          ),
        ],
      ),
      body: CinematicBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildDateHeader(context, state.selectedDate, state.isToday),
              Expanded(
                child: state.isLoading
                    ? _buildLoading()
                    : state.error != null
                        ? _buildError(context, state.error!, notifier)
                        : _buildChecklist(context, state, notifier),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateHeader(BuildContext context, DateTime date, bool isToday) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DesignTokens.spaceLG,
        DesignTokens.spaceSM,
        DesignTokens.spaceLG,
        DesignTokens.spaceLG,
      ),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spaceLG,
          vertical: DesignTokens.spaceMD,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(DesignTokens.spaceSM),
              decoration: BoxDecoration(
                color: AppTheme.primaryOrange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
              ),
              child: const Icon(
                Icons.event_note,
                color: AppTheme.primaryOrange,
                size: 24,
              ),
            ),
            const SizedBox(width: DesignTokens.spaceMD),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isToday ? "Today's Goals" : "Past Record",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  DateFormat('EEEE, MMMM d').format(date),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            if (isToday)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spaceSM,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.successGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.successGreen.withOpacity(0.5),
                  ),
                ),
                child: const Text(
                  'ACTIVE',
                  style: TextStyle(
                    color: AppTheme.successGreen,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklist(
    BuildContext context,
    ChecklistState state,
    ChecklistViewModel notifier,
  ) {
    final tasks = state.currentRecord.tasks.entries.toList();

    if (tasks.isEmpty) {
      return const Center(
        child: Text(
          'No tasks found for this day.',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spaceLG),
      itemCount: tasks.length + 1, // +1 for the bottom spacing
      itemBuilder: (context, index) {
        if (index == tasks.length) {
          return const SizedBox(height: 100); // Bottom padding
        }

        final entry = tasks[index];
        final taskName = entry.key;
        final status = entry.value;
        final isCompleted = status == TaskStatus.completed;
        final isMissed = status == TaskStatus.missed;

        return Padding(
          padding: const EdgeInsets.only(bottom: DesignTokens.spaceMD),
          child: GlassCard(
            padding: EdgeInsets.zero,
            opacity: isCompleted ? 0.2 : 0.1,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: state.isToday && !isMissed
                    ? () => notifier.toggleTask(taskName)
                    : null,
                borderRadius: BorderRadius.circular(DesignTokens.radiusXL),
                child: Padding(
                  padding: const EdgeInsets.all(DesignTokens.spaceMD),
                  child: Row(
                    children: [
                      if (isMissed)
                        const Icon(
                          Icons.close,
                          color: AppTheme.failureRed,
                          size: 28,
                        )
                      else
                        AnimatedCheckbox(
                          value: isCompleted,
                          onChanged: state.isToday
                              ? (_) => notifier.toggleTask(taskName)
                              : null,
                          enabled: state.isToday,
                        ),
                      const SizedBox(width: DesignTokens.spaceMD),
                      Expanded(
                        child: Text(
                          taskName,
                          style: TextStyle(
                            color: isCompleted
                                ? Colors.white
                                : isMissed
                                    ? AppTheme.failureRed.withOpacity(0.7)
                                    : Colors.white70,
                            fontSize: 16,
                            decoration: isCompleted || isMissed
                                ? TextDecoration.lineThrough
                                : null,
                            decorationColor: isMissed
                                ? AppTheme.failureRed
                                : Colors.white54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppTheme.primaryOrange,
      ),
    );
  }

  Widget _buildError(
    BuildContext context,
    String error,
    ChecklistViewModel notifier,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: AppTheme.failureRed, size: 48),
          const SizedBox(height: DesignTokens.spaceMD),
          Text(
            error,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DesignTokens.spaceLG),
          NeumorphicButton(
            onPressed: () => notifier.refresh(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
