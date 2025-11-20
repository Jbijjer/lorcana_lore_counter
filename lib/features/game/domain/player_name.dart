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

  /// Code point de l'icône (DÉPRÉCIÉ - maintenu pour compatibilité avec anciennes données)
  @HiveField(5)
  final int? iconCodePoint;

  /// ID unique du joueur (nullable pour compatibilité avec les anciennes données)
  @HiveField(6)
  final String? id;

  /// Chemin de l'asset de l'icône (remplace iconCodePoint)
  @HiveField(7)
  final String? iconAssetPath;

  PlayerName({
    required this.name,
    required this.lastUsed,
    this.usageCount = 1,
    this.backgroundColorStartValue,
    this.backgroundColorEndValue,
    this.iconCodePoint,
    String? id,
    this.iconAssetPath,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  /// Crée une copie avec les modifications spécifiées
  PlayerName copyWith({
    String? name,
    DateTime? lastUsed,
    int? usageCount,
    int? backgroundColorStartValue,
    int? backgroundColorEndValue,
    int? iconCodePoint,
    String? id,
    String? iconAssetPath,
  }) {
    return PlayerName(
      name: name ?? this.name,
      lastUsed: lastUsed ?? this.lastUsed,
      usageCount: usageCount ?? this.usageCount,
      backgroundColorStartValue: backgroundColorStartValue ?? this.backgroundColorStartValue,
      backgroundColorEndValue: backgroundColorEndValue ?? this.backgroundColorEndValue,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      id: id ?? this.id,
      iconAssetPath: iconAssetPath ?? this.iconAssetPath,
    );
  }
}
