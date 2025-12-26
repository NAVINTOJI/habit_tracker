import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/design_tokens.dart';
import 'glass_card.dart';

class FireStreakCard extends StatefulWidget {
  final int currentStreak;
  final int bestStreak;

  const FireStreakCard({
    super.key,
    required this.currentStreak,
    required this.bestStreak,
  });

  @override
  State<FireStreakCard> createState() => _FireStreakCardState();
}

class _FireStreakCardState extends State<FireStreakCard> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _counterController;
  late Animation<double> _pulseAnimation;
  late Animation<int> _counterAnimation;
  
  int _previousStreak = 0;

  @override
  void initState() {
    super.initState();
    _previousStreak = widget.currentStreak;
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _counterController = AnimationController(
      duration: DesignTokens.durationSlow,
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _counterAnimation = IntTween(begin: 0, end: widget.currentStreak).animate(
      CurvedAnimation(parent: _counterController, curve: Curves.easeOut),
    );

    _counterController.forward();
  }

  @override
  void didUpdateWidget(FireStreakCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentStreak != oldWidget.currentStreak) {
      _counterAnimation = IntTween(
        begin: oldWidget.currentStreak,
        end: widget.currentStreak,
      ).animate(
        CurvedAnimation(parent: _counterController, curve: Curves.easeOut),
      );
      _counterController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _counterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(DesignTokens.spaceLG),
      shadows: [
        BoxShadow(
          color: AppTheme.primaryRed.withOpacity(0.3),
          blurRadius: 20,
          spreadRadius: 5,
          offset: const Offset(0, 10),
        ),
      ],
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStreakColumn(
                context,
                'Current Streak',
                _counterAnimation,
                Icons.local_fire_department,
                60.0,
                true,
              ),
              Container(
                width: 2,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.0),
                      Colors.white.withOpacity(0.3),
                      Colors.white.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
              _buildStreakColumn(
                context,
                'Best Streak',
                AlwaysStoppedAnimation(widget.bestStreak),
                Icons.emoji_events,
                40.0,
                false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStreakColumn(
    BuildContext context,
    String label,
    Animation<int> valueAnimation,
    IconData icon,
    double iconSize,
    bool animate,
  ) {
    return Column(
      children: [
        if (animate)
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: widget.currentStreak > 0 ? _pulseAnimation.value : 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: widget.currentStreak > 0
                        ? [
                            BoxShadow(
                              color: AppTheme.primaryOrange.withOpacity(0.5),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    icon,
                    size: iconSize,
                    color: widget.currentStreak > 0 
                        ? AppTheme.primaryOrange
                        : Colors.white54,
                  ),
                ),
              );
            },
          )
        else
          Icon(
            icon,
            size: iconSize,
            color: AppTheme.accentYellow,
          ),
        const SizedBox(height: 12),
        AnimatedBuilder(
          animation: valueAnimation,
          builder: (context, child) {
            return Text(
              '${valueAnimation.value}',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: animate ? 48 : 36,
                    fontWeight: FontWeight.w900,
                    foreground: Paint()
                      ..shader = AppTheme.fireGradient.createShader(
                        const Rect.fromLTWH(0, 0, 200, 70),
                      ),
                  ),
            );
          },
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
