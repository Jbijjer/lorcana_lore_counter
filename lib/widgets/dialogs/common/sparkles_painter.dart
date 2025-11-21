import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// CustomPainter pour dessiner des particules scintillantes
///
/// Dessine de petites étoiles animées qui scintillent avec une animation sinusoïdale
///
/// Usage:
/// ```dart
/// AnimatedBuilder(
///   animation: shimmerController,
///   builder: (context, child) {
///     return CustomPaint(
///       painter: SparklesPainter(
///         animationValue: shimmerController.value,
///         color: playerColor,
///       ),
///     );
///   },
/// )
/// ```
class SparklesPainter extends CustomPainter {
  const SparklesPainter({
    required this.animationValue,
    required this.color,
    this.sparkleCount = 3,
    this.maxOpacity = 0.8,
    this.sparkleRadius = 2.0,
    this.seed = 42,
  });

  /// Valeur de l'animation (0.0 à 1.0)
  final double animationValue;

  /// Couleur des particules
  final Color color;

  /// Nombre de particules à dessiner
  final int sparkleCount;

  /// Opacité maximale des particules (0.0 à 1.0)
  final double maxOpacity;

  /// Rayon des particules
  final double sparkleRadius;

  /// Seed pour le générateur aléatoire (pour cohérence)
  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // Dessiner les étoiles scintillantes
    final random = math.Random(seed);
    for (int i = 0; i < sparkleCount; i++) {
      final x = size.width * random.nextDouble();
      final y = size.height * random.nextDouble();
      final sparklePhase = (animationValue + (i * 0.3)) % 1.0;
      final opacity = (math.sin(sparklePhase * math.pi * 2) + 1) / 2;

      paint.color = color.withValues(alpha: opacity * maxOpacity);

      // Dessiner une petite étoile
      canvas.drawCircle(Offset(x, y), sparkleRadius, paint);
    }
  }

  @override
  bool shouldRepaint(SparklesPainter oldDelegate) => true;
}

/// Variante du SparklesPainter qui ajuste la couleur en fonction de la luminosité
///
/// Utilise une couleur contrastante (noir sur fond clair, blanc sur fond sombre)
class ContrastSparklesPainter extends CustomPainter {
  const ContrastSparklesPainter({
    required this.animationValue,
    required this.baseColor,
    this.sparkleCount = 3,
    this.maxOpacity = 0.8,
    this.sparkleRadius = 2.0,
    this.seed = 42,
  });

  /// Valeur de l'animation (0.0 à 1.0)
  final double animationValue;

  /// Couleur de base pour calculer le contraste
  final Color baseColor;

  /// Nombre de particules à dessiner
  final int sparkleCount;

  /// Opacité maximale des particules (0.0 à 1.0)
  final double maxOpacity;

  /// Rayon des particules
  final double sparkleRadius;

  /// Seed pour le générateur aléatoire
  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    // Calculer une couleur contrastante
    final brightness = baseColor.computeLuminance();
    final sparkleColor = brightness > 0.5 ? AppTheme.pureBlack : AppTheme.pureWhite;

    final paint = Paint()
      ..color = sparkleColor.withValues(alpha: 0.6)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // Dessiner les étoiles scintillantes
    final random = math.Random(seed);
    for (int i = 0; i < sparkleCount; i++) {
      final x = size.width * random.nextDouble();
      final y = size.height * random.nextDouble();
      final sparklePhase = (animationValue + (i * 0.3)) % 1.0;
      final opacity = (math.sin(sparklePhase * math.pi * 2) + 1) / 2;

      paint.color = sparkleColor.withValues(alpha: opacity * maxOpacity);

      // Dessiner une petite étoile
      canvas.drawCircle(Offset(x, y), sparkleRadius, paint);
    }
  }

  @override
  bool shouldRepaint(ContrastSparklesPainter oldDelegate) => true;
}

/// Widget helper pour afficher facilement des sparkles
class SparklesOverlay extends StatelessWidget {
  const SparklesOverlay({
    required this.controller,
    required this.color,
    this.sparkleCount = 3,
    this.useContrast = false,
    super.key,
  });

  final AnimationController controller;
  final Color color;
  final int sparkleCount;
  final bool useContrast;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: useContrast
              ? ContrastSparklesPainter(
                  animationValue: controller.value,
                  baseColor: color,
                  sparkleCount: sparkleCount,
                )
              : SparklesPainter(
                  animationValue: controller.value,
                  color: color,
                  sparkleCount: sparkleCount,
                ),
        );
      },
    );
  }
}
