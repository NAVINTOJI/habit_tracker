import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../theme/design_tokens.dart';
import '../viewmodels/home_viewmodel.dart';
import '../widgets/fire_streak_card.dart';
import '../widgets/quote_card.dart';
import '../widgets/cinematic_background.dart';
import '../widgets/neumorphic_button.dart';
import 'checklist_screen.dart';
import 'calendar_screen.dart';
import 'analytics_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('DISCIPLINE TRACKER'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CalendarScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
              );
            },
          ),
        ],
      ),
      body: CinematicBackground(
        child: SafeArea(
          child: homeState.error != null
              ? _buildErrorState(context, ref, homeState.error!)
              : RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(homeViewModelProvider.notifier).refresh();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(DesignTokens.spaceLG),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: DesignTokens.spaceLG),
                          if (homeState.isLoading) ...[
                            _buildLoadingState(context),
                          ] else ...[
                            FireStreakCard(
                              currentStreak: homeState.streak.currentStreak,
                              bestStreak: homeState.streak.bestStreak,
                            ),
                            const SizedBox(height: DesignTokens.spaceLG),
                            QuoteCard(
                              quote: homeState.quote,
                              message: homeState.motivationalMessage,
                            ),
                            const SizedBox(height: DesignTokens.spaceLG),
                            NeumorphicButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ChecklistScreen(),
                                  ),
                                ).then((_) {
                                  ref.read(homeViewModelProvider.notifier).refresh();
                                });
                              },
                              padding: const EdgeInsets.symmetric(
                                vertical: DesignTokens.spaceLG,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.check_circle_outline, size: 28),
                                  SizedBox(width: DesignTokens.spaceSM),
                                  Text(
                                    'TODAY\'S CHECKLIST',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: DesignTokens.spaceMD),
                            Row(
                              children: [
                                Expanded(
                                  child: NeumorphicButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const CalendarScreen(),
                                        ),
                                      );
                                    },
                                    padding: const EdgeInsets.symmetric(
                                      vertical: DesignTokens.spaceLG,
                                    ),
                                    child: Column(
                                      children: const [
                                        Icon(Icons.calendar_month, size: 32),
                                        SizedBox(height: DesignTokens.spaceXS),
                                        Text(
                                          'CALENDAR',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: DesignTokens.spaceMD),
                                Expanded(
                                  child: NeumorphicButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const AnalyticsScreen(),
                                        ),
                                      );
                                    },
                                    padding: const EdgeInsets.symmetric(
                                      vertical: DesignTokens.spaceLG,
                                    ),
                                    child: Column(
                                      children: const [
                                        Icon(Icons.analytics, size: 32),
                                        SizedBox(height: DesignTokens.spaceXS),
                                        Text(
                                          'STATS',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(AppTheme.primaryOrange),
          ),
          SizedBox(height: DesignTokens.spaceLG),
          Text(
            'Loading your discipline data...',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spaceLG),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppTheme.failureRed,
              size: 64,
            ),
            const SizedBox(height: DesignTokens.spaceLG),
            Text(
              'Oops! Something went wrong',
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DesignTokens.spaceSM),
            Text(
              error,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DesignTokens.spaceLG),
            NeumorphicButton(
              onPressed: () {
                ref.read(homeViewModelProvider.notifier).refresh();
              },
              child: const Text('TRY AGAIN'),
            ),
          ],
        ),
      ),
    );
  }
}
