import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'accessibility_preferences.g.dart';

/// Préférences d'accessibilité de l'application
@HiveType(typeId: 1)
class AccessibilityPreferences {
  @HiveField(0)
  final bool highContrastMode;

  /// Mode de thème: 0 = système, 1 = clair, 2 = sombre
  @HiveField(1)
  final int themeModeIndex;

  const AccessibilityPreferences({
    this.highContrastMode = false,
    this.themeModeIndex = 0,
  });

  /// Crée des préférences par défaut
  factory AccessibilityPreferences.defaults() {
    return const AccessibilityPreferences();
  }

  /// Retourne le ThemeMode correspondant à l'index
  ThemeMode get themeMode {
    switch (themeModeIndex) {
      case 1:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  /// Copie avec modification
  AccessibilityPreferences copyWith({
    bool? highContrastMode,
    int? themeModeIndex,
  }) {
    return AccessibilityPreferences(
      highContrastMode: highContrastMode ?? this.highContrastMode,
      themeModeIndex: themeModeIndex ?? this.themeModeIndex,
    );
  }
}
