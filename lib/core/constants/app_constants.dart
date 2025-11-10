/// Constantes globales de l'application
class AppConstants {
  AppConstants._();

  // Scores
  static const int winningScore = 20;
  static const int startingScore = 0;
  static const int minScore = 0;
  static const int maxScore = 99;

  // Incréments courants dans Lorcana
  static const List<int> quickIncrements = [1, 2, 3];

  // Animation
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration quickAnimationDuration = Duration(milliseconds: 150);

  // UI
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  
  static const double buttonSize = 60.0;
  static const double logoSize = 80.0;
  
  // Haptic feedback
  static const bool enableHapticFeedback = true;

  // Storage
  static const String gameBoxName = 'games';
  static const String playerBoxName = 'players';
  static const String settingsBoxName = 'settings';
}
