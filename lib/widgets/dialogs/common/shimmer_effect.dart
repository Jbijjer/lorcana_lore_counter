import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Effet shimmer horizontal réutilisable
///
/// Crée un effet de lumière qui se déplace horizontalement sur un widget
///
/// Usage:
/// ```dart
/// ShimmerEffect(
///   controller: shimmerController,
///   borderRadius: BorderRadius.circular(16),
///   opacity: 0.3,
/// )
/// ```
class ShimmerEffect extends StatelessWidget {
  const ShimmerEffect({
    required this.controller,
    this.borderRadius,
    this.opacity = 0.3,
    this.width,
    super.key,
  });

  /// Controller d'animation pour contrôler le shimmer (doit être en repeat)
  final AnimationController controller;

  /// Border radius pour clipper l'effet
  final BorderRadius? borderRadius;

  /// Opacité de l'effet shimmer (0.0 à 1.0)
  final double opacity;

  /// Largeur de la bande de lumière (en proportion de l'écran)
  /// Par défaut: 0.5 (50% de la largeur de l'écran)
  final double? width;

  @override
  Widget build(BuildContext context) {
    final shimmerWidth = width ?? 0.5;
    final screenWidth = MediaQuery.of(context).size.width;

    return Positioned.fill(
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return ClipRRect(
              borderRadius: borderRadius ?? BorderRadius.zero,
              child: Transform.translate(
                offset: Offset(
                  (screenWidth * controller.value) - (screenWidth * shimmerWidth),
                  0,
                ),
                child: Container(
                  width: screenWidth * shimmerWidth,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        AppTheme.transparentColor,
                        AppTheme.pureWhite.withValues(alpha: opacity),
                        AppTheme.transparentColor,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Version simplifiée pour les cas standards
///
/// Usage avec controller:
/// ```dart
/// Stack(
///   children: [
///     Container(...),
///     SimpleShimmerEffect(controller: shimmerController),
///   ],
/// )
/// ```
///
/// Usage avec valeur d'animation:
/// ```dart
/// SimpleShimmerEffect(
///   animationValue: shimmerController.value,
///   borderRadius: 16,
/// )
/// ```
class SimpleShimmerEffect extends StatelessWidget {
  const SimpleShimmerEffect({
    this.controller,
    this.animationValue,
    this.borderRadius = 16,
    this.alpha = 0.3,
    super.key,
  }) : assert(
          controller != null || animationValue != null,
          'Either controller or animationValue must be provided',
        );

  final AnimationController? controller;
  final double? animationValue;
  final double borderRadius;
  final double alpha;

  @override
  Widget build(BuildContext context) {
    if (controller != null) {
      return AnimatedBuilder(
        animation: controller!,
        builder: (context, child) => _buildShimmer(controller!.value),
      );
    } else {
      return _buildShimmer(animationValue!);
    }
  }

  Widget _buildShimmer(double value) {
    return Positioned.fill(
      child: IgnorePointer(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Transform.translate(
            offset: Offset(
              -200 + (value * 400),
              0,
            ),
            child: Container(
              width: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppTheme.transparentColor,
                    AppTheme.pureWhite.withValues(alpha: alpha),
                    AppTheme.transparentColor,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
