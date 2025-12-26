import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Cinematic animated background with particle system and gradient animation
/// Optimized for 60 FPS with RepaintBoundary and efficient drawing
class CinematicBackground extends StatefulWidget {
  final Widget? child;
  
  const CinematicBackground({super.key, this.child});

  @override
  State<CinematicBackground> createState() => _CinematicBackgroundState();
}

class _CinematicBackgroundState extends State<CinematicBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    
    // Initialize particles
    for (int i = 0; i < 25; i++) {
      _particles.add(Particle.random(_random));
    }

    _controller = AnimationController(
      duration: const Duration(seconds: 60),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Animated gradient background
        RepaintBoundary(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: GradientBackgroundPainter(
                  animation: _controller.value,
                ),
                size: Size.infinite,
              );
            },
          ),
        ),
        // Particle system
        RepaintBoundary(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              // Update particles
              for (var particle in _particles) {
                particle.update(_controller.value);
              }
              
              return CustomPaint(
                painter: ParticlePainter(
                  particles: _particles,
                  animation: _controller.value,
                ),
                size: Size.infinite,
              );
            },
          ),
        ),
        // Content
        if (widget.child != null) widget.child!,
      ],
    );
  }
}

class GradientBackgroundPainter extends CustomPainter {
  final double animation;

  GradientBackgroundPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    
    // Animated gradient colors
    final color1 = Color.lerp(
      const Color(0xFF1A1A2E),
      const Color(0xFF16213E),
      (math.sin(animation * 2 * math.pi) + 1) / 2,
    )!;
    
    final color2 = Color.lerp(
      const Color(0xFF0F3460),
      const Color(0xFF1A1A2E),
      (math.cos(animation * 2 * math.pi * 0.7) + 1) / 2,
    )!;
    
    final color3 = Color.lerp(
      const Color(0xFF16213E),
      AppTheme.primaryRed.withOpacity(0.1),
      (math.sin(animation * 2 * math.pi * 0.5) + 1) / 2,
    )!;

    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [color1, color2, color3],
      stops: const [0.0, 0.5, 1.0],
    );

    final paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(GradientBackgroundPainter oldDelegate) {
    return animation != oldDelegate.animation;
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animation;

  ParticlePainter({required this.particles, required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color.withOpacity(particle.opacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, particle.blur);

      canvas.drawCircle(
        Offset(
          particle.x * size.width,
          particle.y * size.height,
        ),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}

class Particle {
  double x;
  double y;
  double size;
  double opacity;
  double blur;
  Color color;
  double speedX;
  double speedY;
  double initialX;
  double initialY;
  double orbitRadius;
  double orbitSpeed;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.blur,
    required this.color,
    required this.speedX,
    required this.speedY,
    required this.initialX,
    required this.initialY,
    required this.orbitRadius,
    required this.orbitSpeed,
  });

  factory Particle.random(math.Random random) {
    final colors = [
      AppTheme.primaryRed,
      AppTheme.primaryOrange,
      AppTheme.accentYellow,
    ];

    return Particle(
      x: random.nextDouble(),
      y: random.nextDouble(),
      size: random.nextDouble() * 4 + 2,
      opacity: random.nextDouble() * 0.3 + 0.1,
      blur: random.nextDouble() * 8 + 4,
      color: colors[random.nextInt(colors.length)],
      speedX: (random.nextDouble() - 0.5) * 0.0002,
      speedY: (random.nextDouble() - 0.5) * 0.0002,
      initialX: random.nextDouble(),
      initialY: random.nextDouble(),
      orbitRadius: random.nextDouble() * 0.05 + 0.02,
      orbitSpeed: random.nextDouble() * 0.5 + 0.3,
    );
  }

  void update(double time) {
    // Orbital motion
    final angle = time * orbitSpeed * 2 * math.pi;
    x = initialX + math.cos(angle) * orbitRadius;
    y = initialY + math.sin(angle) * orbitRadius;

    // Wrap around edges
    if (x > 1.0) x = 0.0;
    if (x < 0.0) x = 1.0;
    if (y > 1.0) y = 0.0;
    if (y < 0.0) y = 1.0;
  }
}
