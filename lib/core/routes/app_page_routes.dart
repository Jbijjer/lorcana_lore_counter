import 'package:flutter/material.dart';
import '../../features/game/presentation/screens/statistics_screen.dart';
import '../../features/game/presentation/screens/settings_screen.dart';
import '../../features/game/presentation/screens/manual_entry_screen.dart';
import '../../features/game/presentation/screens/play_screen.dart';
import '../../features/game/presentation/screens/home_screen.dart';

// ============================================================================
// STATISTICS SCREEN ROUTES
// ============================================================================

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
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );

            final slideAnimation = Tween<Offset>(
              begin: const Offset(0, 0.15),
              end: Offset.zero,
            ).animate(curvedAnimation);

            final fadeAnimation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
            ));

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

// ============================================================================
// SETTINGS SCREEN ROUTES
// ============================================================================

/// Route pour l'écran des paramètres avec animation de type "engrenage"
/// Slide depuis la droite avec légère rotation
class SettingsPageRoute extends PageRouteBuilder<void> {
  SettingsPageRoute({this.fromActiveGame = false})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) {
            return SettingsScreen(fromActiveGame: fromActiveGame);
          },
          transitionDuration: const Duration(milliseconds: 450),
          reverseTransitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );

            // Slide depuis la droite
            final slideAnimation = Tween<Offset>(
              begin: const Offset(0.3, 0),
              end: Offset.zero,
            ).animate(curvedAnimation);

            // Fade in progressif
            final fadeAnimation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
            ));

            // Légère rotation (effet engrenage)
            final rotationAnimation = Tween<double>(
              begin: 0.05,
              end: 0.0,
            ).animate(curvedAnimation);

            return SlideTransition(
              position: slideAnimation,
              child: FadeTransition(
                opacity: fadeAnimation,
                child: Transform.rotate(
                  angle: rotationAnimation.value,
                  child: child,
                ),
              ),
            );
          },
        );

  final bool fromActiveGame;
}

// ============================================================================
// MANUAL ENTRY SCREEN ROUTES
// ============================================================================

/// Route pour l'écran de saisie manuelle
/// Animation de formulaire qui glisse depuis le bas avec effet d'élévation
class ManualEntryPageRoute extends PageRouteBuilder<void> {
  ManualEntryPageRoute()
      : super(
          pageBuilder: (context, animation, secondaryAnimation) {
            return const ManualEntryScreen();
          },
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );

            // Slide depuis le bas (comme un formulaire qui monte)
            final slideAnimation = Tween<Offset>(
              begin: const Offset(0, 0.25),
              end: Offset.zero,
            ).animate(curvedAnimation);

            // Fade in
            final fadeAnimation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
            ));

            // Scale pour effet d'élévation
            final scaleAnimation = Tween<double>(
              begin: 0.92,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutBack,
            ));

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

// ============================================================================
// PLAY SCREEN ROUTES
// ============================================================================

/// Route pour l'écran de jeu avec animation dynamique
/// Effet de zoom avant avec fade pour une sensation immersive
class PlayScreenPageRoute extends PageRouteBuilder<void> {
  PlayScreenPageRoute({this.shouldCheckForOngoingGame = true})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) {
            return PlayScreen(shouldCheckForOngoingGame: shouldCheckForOngoingGame);
          },
          transitionDuration: const Duration(milliseconds: 550),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );

            // Fade in rapide
            final fadeAnimation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
            ));

            // Scale avec effet de zoom avant (immersion dans le jeu)
            final scaleAnimation = Tween<double>(
              begin: 0.85,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutBack,
            ));

            return FadeTransition(
              opacity: fadeAnimation,
              child: ScaleTransition(
                scale: scaleAnimation,
                child: child,
              ),
            );
          },
        );

  final bool shouldCheckForOngoingGame;
}

/// Route de remplacement pour PlayScreen (utilisé avec pushReplacement)
class PlayScreenReplaceRoute extends PageRouteBuilder<void> {
  PlayScreenReplaceRoute({this.shouldCheckForOngoingGame = true})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) {
            return PlayScreen(shouldCheckForOngoingGame: shouldCheckForOngoingGame);
          },
          transitionDuration: const Duration(milliseconds: 600),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutQuart,
              reverseCurve: Curves.easeInQuart,
            );

            // Fade croisé
            final fadeAnimation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
            ));

            // Scale avec effet de profondeur
            final scaleAnimation = Tween<double>(
              begin: 1.1,
              end: 1.0,
            ).animate(curvedAnimation);

            return FadeTransition(
              opacity: fadeAnimation,
              child: ScaleTransition(
                scale: scaleAnimation,
                child: child,
              ),
            );
          },
        );

  final bool shouldCheckForOngoingGame;
}

// ============================================================================
// HOME SCREEN ROUTES
// ============================================================================

/// Route pour retourner à l'écran d'accueil
/// Animation de "retour" avec slide vers la gauche et fade
class HomeScreenPageRoute extends PageRouteBuilder<void> {
  HomeScreenPageRoute()
      : super(
          pageBuilder: (context, animation, secondaryAnimation) {
            return const HomeScreen();
          },
          transitionDuration: const Duration(milliseconds: 450),
          reverseTransitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );

            // Slide depuis la gauche (effet de retour)
            final slideAnimation = Tween<Offset>(
              begin: const Offset(-0.2, 0),
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

            // Légère scale
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

/// Route de remplacement pour HomeScreen avec animation de "sortie de jeu"
class HomeScreenReplaceRoute extends PageRouteBuilder<void> {
  HomeScreenReplaceRoute()
      : super(
          pageBuilder: (context, animation, secondaryAnimation) {
            return const HomeScreen();
          },
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );

            // Fade croisé pour transition douce
            final fadeAnimation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: const Interval(0.1, 0.7, curve: Curves.easeInOut),
            ));

            // Scale inverse (zoom arrière = sortie du jeu)
            final scaleAnimation = Tween<double>(
              begin: 0.9,
              end: 1.0,
            ).animate(curvedAnimation);

            return FadeTransition(
              opacity: fadeAnimation,
              child: ScaleTransition(
                scale: scaleAnimation,
                child: child,
              ),
            );
          },
        );
}

// ============================================================================
// EXTENSIONS POUR NAVIGATION FACILITÉE
// ============================================================================

/// Extension pour faciliter la navigation avec animations
extension AnimatedNavigation on NavigatorState {
  // Statistics
  Future<T?> pushStatistics<T extends Object?>() {
    return push<T>(StatisticsPageRoute() as Route<T>);
  }

  // Settings
  Future<T?> pushSettings<T extends Object?>({bool fromActiveGame = false}) {
    return push<T>(SettingsPageRoute(fromActiveGame: fromActiveGame) as Route<T>);
  }

  // Manual Entry
  Future<T?> pushManualEntry<T extends Object?>() {
    return push<T>(ManualEntryPageRoute() as Route<T>);
  }

  // Play Screen
  Future<T?> pushPlayScreen<T extends Object?>({bool shouldCheckForOngoingGame = true}) {
    return push<T>(PlayScreenPageRoute(shouldCheckForOngoingGame: shouldCheckForOngoingGame) as Route<T>);
  }

  Future<T?> pushReplacementPlayScreen<T extends Object?, TO extends Object?>({
    bool shouldCheckForOngoingGame = true,
    TO? result,
  }) {
    return pushReplacement<T, TO>(
      PlayScreenReplaceRoute(shouldCheckForOngoingGame: shouldCheckForOngoingGame) as Route<T>,
      result: result,
    );
  }

  // Home Screen
  Future<T?> pushHome<T extends Object?>() {
    return push<T>(HomeScreenPageRoute() as Route<T>);
  }

  Future<T?> pushReplacementHome<T extends Object?, TO extends Object?>({TO? result}) {
    return pushReplacement<T, TO>(HomeScreenReplaceRoute() as Route<T>, result: result);
  }

  Future<T?> pushAndRemoveUntilHome<T extends Object?>() {
    return pushAndRemoveUntil<T>(HomeScreenReplaceRoute() as Route<T>, (route) => false);
  }
}
