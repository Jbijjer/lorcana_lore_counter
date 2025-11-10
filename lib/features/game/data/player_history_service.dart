import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/player_name.dart';

part 'player_history_service.g.dart';

/// Service pour gérer l'historique des noms de joueurs
class PlayerHistoryService {
  static const String _boxName = 'player_history';
  Box<PlayerName>? _box;

  /// Initialise le service et ouvre la box Hive
  Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(PlayerNameAdapter());
    }
    _box = await Hive.openBox<PlayerName>(_boxName);
  }

  /// Récupère tous les noms de joueurs triés par dernière utilisation
  List<String> getAllPlayerNames() {
    if (_box == null) return [];

    final playerNames = _box!.values.toList();
    // Trier par dernière utilisation (plus récent en premier)
    playerNames.sort((a, b) => b.lastUsed.compareTo(a.lastUsed));

    return playerNames.map((p) => p.name).toList();
  }

  /// Ajoute ou met à jour un nom de joueur
  Future<void> addOrUpdatePlayerName(String name) async {
    if (_box == null || name.trim().isEmpty) return;

    final trimmedName = name.trim();

    // Vérifier si le nom existe déjà
    final existingIndex = _box!.values.toList().indexWhere(
      (p) => p.name.toLowerCase() == trimmedName.toLowerCase(),
    );

    if (existingIndex != -1) {
      // Mettre à jour le nom existant
      final existing = _box!.getAt(existingIndex);
      if (existing != null) {
        final updated = existing.copyWith(
          lastUsed: DateTime.now(),
          usageCount: existing.usageCount + 1,
        );
        await _box!.putAt(existingIndex, updated);
      }
    } else {
      // Ajouter un nouveau nom
      final newPlayerName = PlayerName(
        name: trimmedName,
        lastUsed: DateTime.now(),
      );
      await _box!.add(newPlayerName);
    }
  }

  /// Supprime un nom de joueur
  Future<void> deletePlayerName(String name) async {
    if (_box == null) return;

    final index = _box!.values.toList().indexWhere(
      (p) => p.name.toLowerCase() == name.toLowerCase(),
    );

    if (index != -1) {
      await _box!.deleteAt(index);
    }
  }

  /// Ferme la box Hive
  Future<void> dispose() async {
    await _box?.close();
  }
}

/// Provider pour le service d'historique des joueurs
@Riverpod(keepAlive: true)
PlayerHistoryService playerHistoryService(PlayerHistoryServiceRef ref) {
  final service = PlayerHistoryService();
  ref.onDispose(() => service.dispose());
  return service;
}

/// Provider pour la liste des noms de joueurs
@riverpod
List<String> playerNames(PlayerNamesRef ref) {
  final service = ref.watch(playerHistoryServiceProvider);
  return service.getAllPlayerNames();
}
