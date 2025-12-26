import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/design_tokens.dart';
import '../theme/app_theme.dart';

/// Animated checkbox with smooth transitions and glow effect
class AnimatedCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final double size;
  final bool enabled;

  const AnimatedCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = 28.0,
    this.enabled = true,
  });

  @override
  State<AnimatedCheckbox> createState() => _AnimatedCheckboxState();
}

class _AnimatedCheckboxState extends State<AnimatedCheckbox>
    with TickerProviderStateMixin {
  late AnimationController _checkController;
  late AnimationController _scaleController;
  late Animation<double> _checkAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _checkController = AnimationController(
      duration: DesignTokens.durationNormal,
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _checkAnimation = CurvedAnimation(
      parent: _checkController,
      curve: Curves.easeInOut,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.easeOut,
      ),
    );

    if (widget.value) {
      _checkController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(AnimatedCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value) {
        _checkController.forward();
        _scaleController.forward().then((_) => _scaleController.reverse());
      } else {
        _checkController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _checkController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.enabled || widget.onChanged == null) return;
    
    HapticFeedback.selectionClick();
    widget.onChanged!(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_checkAnimation, _scaleAnimation]),
        builder: (context, child) {
          final isChecked = widget.value;
          final checkProgress = _checkAnimation.value;
          final scale = _scaleAnimation.value;

          return Transform.scale(
            scale: scale,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.lerp(
                  Colors.grey[800],
                  AppTheme.successGreen,
                  checkProgress,
                ),
                border: Border.all(
                  color: Color.lerp(
                    Colors.grey,
                    AppTheme.successGreen,
                    checkProgress,
                  )!,
                  width: 2,
                ),
                boxShadow: isChecked
                    ? [
                        BoxShadow(
                          color: AppTheme.successGreen.withOpacity(0.4 * checkProgress),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Icon(
                  Icons.check,
                  size: widget.size * 0.6,
                  color: Colors.white.withOpacity(checkProgress),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
