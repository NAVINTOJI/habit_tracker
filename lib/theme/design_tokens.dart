import 'package:flutter/material.dart';

/// Design tokens for consistent spacing, sizing, and animation
class DesignTokens {
  DesignTokens._();
  
  // Spacing
  static const double spaceXS = 4.0;
  static const double spaceSM = 8.0;
  static const double spaceMD = 16.0;
  static const double spaceLG = 24.0;
  static const double spaceXL = 32.0;
  static const double space2XL = 48.0;
  
  // BorderRadius
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 20.0;
  static const double radius2XL = 24.0;
  static const double radiusFull = 9999.0;
  
  // Shadows for 3D effects
  static List<BoxShadow> shadowSM(Color color) => [
    BoxShadow(
      color: color.withOpacity(0.1),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];
  
  static List<BoxShadow> shadowMD(Color color) => [
    BoxShadow(
      color: color.withOpacity(0.15),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> shadowLG(Color color) => [
    BoxShadow(
      color: color.withOpacity(0.2),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];
  
  static List<BoxShadow> shadowXL(Color color) => [
    BoxShadow(
      color: color.withOpacity(0.25),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];
  
  // Neumorphic shadows (light and dark)
  static List<BoxShadow> neumorphicLight = [
    BoxShadow(
      color: Colors.white.withOpacity(0.5),
      blurRadius: 10,
      offset: const Offset(-5, -5),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      blurRadius: 10,
      offset: const Offset(5, 5),
    ),
  ];
  
  static List<BoxShadow> neumorphicPressed = [
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      blurRadius: 8,
      offset: const Offset(2, 2),
      spreadRadius: -2,
    ),
    BoxShadow(
      color: Colors.white.withOpacity(0.5),
      blurRadius: 8,
      offset: const Offset(-2, -2),
      spreadRadius: -2,
    ),
  ];
  
  // Animation durations
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 250);
  static const Duration durationSlow = Duration(milliseconds: 400);
  static const Duration durationVerySlow = Duration(milliseconds: 600);
  
  // Animation curves
  static const Curve curveDefault = Curves.easeInOut;
  static const Curve curveSpring = Curves.elasticOut;
  static const Curve curveBounce = Curves.bounceOut;
  static const Curve curveSmooth = Curves.easeOutCubic;
  
  // Glassmorphism
  static const double glassBlur = 10.0;
  static const double glassOpacity = 0.15;
  static const double glassBorderOpacity = 0.2;
}
