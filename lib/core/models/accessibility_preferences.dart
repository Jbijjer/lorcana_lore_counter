import 'package:hive_ce/hive.dart';

part 'accessibility_preferences.g.dart';

/// Préférences d'accessibilité de l'application
@HiveType(typeId: 1)
class AccessibilityPreferences {
  @HiveField(0)
  final bool highContrastMode;

  const AccessibilityPreferences({
    this.highContrastMode = false,
  });

  /// Crée des préférences par défaut
  factory AccessibilityPreferences.defaults() {
    return const AccessibilityPreferences();
  }

  /// Copie avec modification
  AccessibilityPreferences copyWith({
    bool? highContrastMode,
  }) {
    return AccessibilityPreferences(
      highContrastMode: highContrastMode ?? this.highContrastMode,
    );
  }
}
