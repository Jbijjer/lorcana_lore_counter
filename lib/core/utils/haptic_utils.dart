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

  /// Feedback fort pour les actions critiques
  static Future<void> heavy() async {
    if (AppConstants.enableHapticFeedback) {
      await HapticFeedback.heavyImpact();
    }
  }

  /// Feedback pour les sélections
  static Future<void> selection() async {
    if (AppConstants.enableHapticFeedback) {
      await HapticFeedback.selectionClick();
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

  /// Feedback pour les erreurs
  static Future<void> error() async {
    if (AppConstants.enableHapticFeedback) {
      await HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 100));
      await HapticFeedback.heavyImpact();
    }
  }
}
