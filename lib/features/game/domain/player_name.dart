import 'package:hive/hive.dart';

part 'player_name.g.dart';

/// Modèle représentant un nom de joueur dans l'historique
@HiveType(typeId: 0)
class PlayerName {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final DateTime lastUsed;

  @HiveField(2)
  final int usageCount;

  /// Couleur de fond de départ (nullable pour compatibilité)
  @HiveField(3)
  final int? backgroundColorStartValue;

  /// Couleur de fond de fin (nullable pour compatibilité)
  @HiveField(4)
  final int? backgroundColorEndValue;

  PlayerName({
    required this.name,
    required this.lastUsed,
    this.usageCount = 1,
    this.backgroundColorStartValue,
    this.backgroundColorEndValue,
  });

  /// Crée une copie avec les modifications spécifiées
  PlayerName copyWith({
    String? name,
    DateTime? lastUsed,
    int? usageCount,
    int? backgroundColorStartValue,
    int? backgroundColorEndValue,
  }) {
    return PlayerName(
      name: name ?? this.name,
      lastUsed: lastUsed ?? this.lastUsed,
      usageCount: usageCount ?? this.usageCount,
      backgroundColorStartValue: backgroundColorStartValue ?? this.backgroundColorStartValue,
      backgroundColorEndValue: backgroundColorEndValue ?? this.backgroundColorEndValue,
    );
  }
}
