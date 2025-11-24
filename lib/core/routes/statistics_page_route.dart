import 'package:flutter/material.dart';
import '../../features/game/presentation/screens/statistics_screen.dart';

/// Route personnalisée avec animation pour l'écran des statistiques
/// Combine slide from bottom, fade et scale pour un effet élégant
class StatisticsPageRoute extends PageRouteBuilder<void> {
  StatisticsPageRoute()
      : super(
          pageBuilder: (context, animation, secondaryAnimation) {
            return const StatisticsScreen();
          },
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Animation courbe pour un effet plus naturel
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );

            // Slide depuis le bas
            final slideAnimation = Tween<Offset>(
              begin: const Offset(0, 0.15),
              end: Offset.zero,
            ).animate(curvedAnimation);

            // Fade in
            final fadeAnimation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
            ));

            // Scale légèrement (effet de zoom in)
            final scaleAnimation = Tween<double>(
              begin: 0.95,
              end: 1.0,
            ).animate(curvedAnimation);

            return SlideTransition(
              position: slideAnimation,
              child: FadeTransition(
                opacity: fadeAnimation,
                child: ScaleTransition(
                  scale: scaleAnimation,
                  child: child,
                ),
              ),
            );
          },
        );
}

/// Route alternative avec animation de type "révélation" depuis l'icône
/// Utilise un effet de cercle qui s'agrandit
class StatisticsRevealPageRoute extends PageRouteBuilder<void> {
  StatisticsRevealPageRoute({this.originOffset})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) {
            return const StatisticsScreen();
          },
          transitionDuration: const Duration(milliseconds: 600),
          reverseTransitionDuration: const Duration(milliseconds: 450),
          opaque: false,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _CircleRevealTransition(
              animation: animation,
              originOffset: originOffset,
              child: child,
            );
          },
        );

  /// Position d'origine de l'animation (centre du bouton cliqué)
  final Offset? originOffset;
}

/// Widget pour l'animation de révélation circulaire
class _CircleRevealTransition extends StatelessWidget {
  const _CircleRevealTransition({
    required this.animation,
    required this.child,
    this.originOffset,
  });

  final Animation<double> animation;
  final Widget child;
  final Offset? originOffset;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final origin = originOffset ?? Offset(screenSize.width / 2, screenSize.height / 2);

    // Calculer le rayon maximum nécessaire pour couvrir tout l'écran
    final maxRadius = (Offset(screenSize.width, screenSize.height) - origin).distance * 1.2;

    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutQuart,
      reverseCurve: Curves.easeInQuart,
    );

    final radiusAnimation = Tween<double>(
      begin: 0,
      end: maxRadius,
    ).animate(curvedAnimation);

    final fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return ClipPath(
          clipper: _CircleClipper(
            center: origin,
            radius: radiusAnimation.value,
          ),
          child: FadeTransition(
            opacity: fadeAnimation,
            child: Container(
              color: Theme.of(context).colorScheme.surface,
              child: child,
            ),
          ),
        );
      },
    );
  }
}

/// Clipper pour créer un cercle qui s'agrandit
class _CircleClipper extends CustomClipper<Path> {
  _CircleClipper({
    required this.center,
    required this.radius,
  });

  final Offset center;
  final double radius;

  @override
  Path getClip(Size size) {
    return Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));
  }

  @override
  bool shouldReclip(_CircleClipper oldClipper) {
    return center != oldClipper.center || radius != oldClipper.radius;
  }
}

/// Route avec animation de type "cartes" (effet de deck de cartes)
/// Les statistiques glissent depuis le côté comme des cartes
class StatisticsCardSlidePageRoute extends PageRouteBuilder<void> {
  StatisticsCardSlidePageRoute()
      : super(
          pageBuilder: (context, animation, secondaryAnimation) {
            return const StatisticsScreen();
          },
          transitionDuration: const Duration(milliseconds: 550),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Animation avec effet de ressort léger
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutBack,
              reverseCurve: Curves.easeInCubic,
            );

            // Slide depuis la droite avec rotation légère
            final slideAnimation = Tween<Offset>(
              begin: const Offset(1.0, 0),
              end: Offset.zero,
            ).animate(curvedAnimation);

            // Fade in
            final fadeAnimation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
            ));

            // Rotation légère initiale (effet de carte)
            final rotationAnimation = Tween<double>(
              begin: 0.05,
              end: 0.0,
            ).animate(curvedAnimation);

            return SlideTransition(
              position: slideAnimation,
              child: FadeTransition(
                opacity: fadeAnimation,
                child: Transform(
                  alignment: Alignment.centerRight,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001) // Perspective
                    ..rotateY(rotationAnimation.value),
                  child: child,
                ),
              ),
            );
          },
        );
}

/// Route avec animation "statistiques" - les barres semblent s'élever
/// Effet inspiré des graphiques qui montent
class StatisticsBarRisePageRoute extends PageRouteBuilder<void> {
  StatisticsBarRisePageRoute()
      : super(
          pageBuilder: (context, animation, secondaryAnimation) {
            return const StatisticsScreen();
          },
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Courbe avec léger dépassement pour effet dynamique
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );

            // Slide depuis le bas (comme des barres qui montent)
            final slideAnimation = Tween<Offset>(
              begin: const Offset(0, 0.3),
              end: Offset.zero,
            ).animate(curvedAnimation);

            // Fade progressif
            final fadeAnimation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
            ));

            // Scale vertical légèrement exagéré puis normal
            final scaleAnimation = Tween<double>(
              begin: 0.85,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.elasticOut,
            ));

            return AnimatedBuilder(
              animation: scaleAnimation,
              builder: (context, _) {
                return SlideTransition(
                  position: slideAnimation,
                  child: FadeTransition(
                    opacity: fadeAnimation,
                    child: Transform(
                      alignment: Alignment.bottomCenter,
                      transform: Matrix4.identity()..scale(1.0, scaleAnimation.value),
                      child: child,
                    ),
                  ),
                );
              },
            );
          },
        );
}

/// Extension pour faciliter la navigation vers les statistiques
extension StatisticsNavigation on NavigatorState {
  /// Navigue vers l'écran des statistiques avec animation élégante
  Future<void> pushStatistics() {
    return push(StatisticsPageRoute());
  }

  /// Navigue vers les statistiques avec effet de révélation circulaire
  Future<void> pushStatisticsWithReveal({Offset? from}) {
    return push(StatisticsRevealPageRoute(originOffset: from));
  }

  /// Navigue vers les statistiques avec effet de carte
  Future<void> pushStatisticsWithCardSlide() {
    return push(StatisticsCardSlidePageRoute());
  }

  /// Navigue vers les statistiques avec effet de barres montantes
  Future<void> pushStatisticsWithBarRise() {
    return push(StatisticsBarRisePageRoute());
  }
}
