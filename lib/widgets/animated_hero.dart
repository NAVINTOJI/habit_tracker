import 'package:flutter/material.dart';

class AnimatedHero extends StatelessWidget {
  const AnimatedHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.15,
      child: Container(
        width: 300,
        height: 300,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Color(0xFFFF6B35),
              Color(0xFFE63946),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}
