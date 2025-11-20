import 'package:flutter/material.dart';

/// Mixin qui fournit les animations standard pour les dialogues
///
/// Ce mixin configure automatiquement :
/// - Une animation d'entrée élastique (scale)
/// - Une animation de rotation
/// - Une animation de fade
/// - Une animation shimmer en boucle
///
/// Usage:
/// ```dart
/// class _MyDialogState extends State<MyDialog> with TickerProviderStateMixin, DialogAnimationsMixin {
///   @override
///   void initState() {
///     super.initState();
///     initDialogAnimations();
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return buildAnimatedDialog(
///       child: Dialog(...),
///     );
///   }
/// }
/// ```
mixin DialogAnimationsMixin<T extends StatefulWidget> on State<T>, TickerProviderStateMixin<T> {
  late AnimationController _dialogAnimationController;
  late AnimationController _shimmerController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _fadeAnimation;

  /// Controller pour l'animation d'entrée du dialogue
  AnimationController get dialogAnimationController => _dialogAnimationController;

  /// Controller pour l'animation shimmer
  AnimationController get shimmerController => _shimmerController;

  /// Animation de mise à l'échelle (scale)
  Animation<double> get scaleAnimation => _scaleAnimation;

  /// Animation de rotation
  Animation<double> get rotationAnimation => _rotationAnimation;

  /// Animation de fondu (fade)
  Animation<double> get fadeAnimation => _fadeAnimation;

  /// Initialise toutes les animations du dialogue
  ///
  /// À appeler dans initState() après super.initState()
  void initDialogAnimations() {
    // Animation d'entrée du dialog
    _dialogAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _dialogAnimationController,
      curve: Curves.elasticOut,
    );

    _rotationAnimation = Tween<double>(
      begin: -0.1,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _dialogAnimationController,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = CurvedAnimation(
      parent: _dialogAnimationController,
      curve: Curves.easeIn,
    );

    // Animation shimmer pour les effets visuels
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _dialogAnimationController.forward();
  }

  /// Dispose toutes les animations du dialogue
  ///
  /// À appeler dans dispose() avant super.dispose()
  void disposeDialogAnimations() {
    _dialogAnimationController.dispose();
    _shimmerController.dispose();
  }

  /// Construit un dialogue avec les animations standard
  ///
  /// Encapsule automatiquement le child dans les transitions de fade, scale et rotation
  Widget buildAnimatedDialog({required Widget child}) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: RotationTransition(
          turns: _rotationAnimation,
          child: child,
        ),
      ),
    );
  }
}
