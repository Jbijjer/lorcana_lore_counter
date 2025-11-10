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

  PlayerName({
    required this.name,
    required this.lastUsed,
    this.usageCount = 1,
  });

  /// Crée une copie avec les modifications spécifiées
  PlayerName copyWith({
    String? name,
    DateTime? lastUsed,
    int? usageCount,
  }) {
    return PlayerName(
      name: name ?? this.name,
      lastUsed: lastUsed ?? this.lastUsed,
      usageCount: usageCount ?? this.usageCount,
    );
  }
}
