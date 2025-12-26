import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';
import '../theme/app_theme.dart';

/// Glassmorphism card with frosted glass effect
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final double borderRadius;
  final double blur;
  final double opacity;
  final BorderSide? border;
  final List<BoxShadow>? shadows;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.borderRadius = DesignTokens.radiusXL,
    this.blur = DesignTokens.glassBlur,
    this.opacity = DesignTokens.glassOpacity,
    this.border,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          padding: padding ?? const EdgeInsets.all(DesignTokens.spaceLG),
          decoration: BoxDecoration(
            color: AppTheme.cardDark.withOpacity(opacity),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: border?.color ?? Colors.white.withOpacity(DesignTokens.glassBorderOpacity),
              width: border?.width ?? 1.5,
            ),
            boxShadow: shadows ?? DesignTokens.shadowLG(AppTheme.primaryRed),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Glassmorphism container with gradient overlay option
class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final double borderRadius;
  final Gradient? gradient;
  final double blur;
  final double opacity;

  const GlassContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius = DesignTokens.radiusLG,
    this.gradient,
    this.blur = DesignTokens.glassBlur,
    this.opacity = DesignTokens.glassOpacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            width: width,
            height: height,
            padding: padding,
            decoration: BoxDecoration(
              gradient: gradient,
              color: gradient == null 
                  ? AppTheme.cardDark.withOpacity(opacity) 
                  : null,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: Colors.white.withOpacity(0.15),
                width: 1,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
