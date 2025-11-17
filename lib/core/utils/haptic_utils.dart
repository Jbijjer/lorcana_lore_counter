import 'package:flutter/services.dart';
import '../constants/app_constants.dart';

/// Utilitaires pour le feedback haptique
class HapticUtils {
  HapticUtils._();

  /// Feedback léger pour les interactions standard
  static Future<void> light() async {
    if (AppConstants.enableHapticFeedback) {
      await HapticFeedback.lightImpact();
    }
  }

  /// Feedback moyen pour les actions importantes
  static Future<void> medium() async {
    if (AppConstants.enableHapticFeedback) {
      await HapticFeedback.mediumImpact();
    }
  }

  /// Feedback pour les vibrations (succès)
  static Future<void> success() async {
    if (AppConstants.enableHapticFeedback) {
      await HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(milliseconds: 100));
      await HapticFeedback.lightImpact();
    }
  }
}
