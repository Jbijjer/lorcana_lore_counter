import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/accessibility_preferences.dart';

part 'accessibility_provider.g.dart';

/// Box Hive pour les préférences d'accessibilité
const String _accessibilityBoxName = 'accessibility_preferences';
const String _accessibilityKey = 'preferences';

/// Provider pour gérer les préférences d'accessibilité
@riverpod
class AccessibilityNotifier extends _$AccessibilityNotifier {
  late Box<AccessibilityPreferences> _box;

  @override
  Future<AccessibilityPreferences> build() async {
    // Ouvrir ou créer la box Hive
    if (!Hive.isBoxOpen(_accessibilityBoxName)) {
      _box = await Hive.openBox<AccessibilityPreferences>(_accessibilityBoxName);
    } else {
      _box = Hive.box<AccessibilityPreferences>(_accessibilityBoxName);
    }

    // Charger les préférences ou utiliser les valeurs par défaut
    return _box.get(_accessibilityKey) ?? AccessibilityPreferences.defaults();
  }

  /// Active ou désactive le mode contraste élevé
  Future<void> toggleHighContrast() async {
    final current = await future;
    final updated = current.copyWith(highContrastMode: !current.highContrastMode);
    await _box.put(_accessibilityKey, updated);
    state = AsyncValue.data(updated);
  }

  /// Définit le mode contraste élevé
  Future<void> setHighContrast(bool enabled) async {
    final current = await future;
    final updated = current.copyWith(highContrastMode: enabled);
    await _box.put(_accessibilityKey, updated);
    state = AsyncValue.data(updated);
  }
}
