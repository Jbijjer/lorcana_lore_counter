import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  /// Récupère les couleurs de fond d'un joueur (retourne null si non définies)
  (Color?, Color?) getPlayerColors(String name) {
    if (_box == null) return (null, null);

    final playerName = _box!.values.firstWhere(
      (p) => p.name.toLowerCase() == name.toLowerCase(),
      orElse: () => PlayerName(name: '', lastUsed: DateTime.now()),
    );

    if (playerName.name.isEmpty) return (null, null);

    final startColor = playerName.backgroundColorStartValue != null
        ? Color(playerName.backgroundColorStartValue!)
        : null;
    final endColor = playerName.backgroundColorEndValue != null
        ? Color(playerName.backgroundColorEndValue!)
        : null;

    return (startColor, endColor);
  }

  /// Met à jour les couleurs de fond d'un joueur
  Future<void> updatePlayerColors(String name, Color startColor, Color endColor) async {
    if (_box == null || name.trim().isEmpty) return;

    final trimmedName = name.trim();

    // Vérifier si le nom existe déjà
    final existingIndex = _box!.values.toList().indexWhere(
      (p) => p.name.toLowerCase() == trimmedName.toLowerCase(),
    );

    if (existingIndex != -1) {
      // Mettre à jour les couleurs du joueur existant
      final existing = _box!.getAt(existingIndex);
      if (existing != null) {
        final updated = existing.copyWith(
          backgroundColorStartValue: startColor.toARGB32(),
          backgroundColorEndValue: endColor.toARGB32(),
        );
        await _box!.putAt(existingIndex, updated);
      }
    } else {
      // Créer un nouveau joueur avec les couleurs
      final newPlayerName = PlayerName(
        name: trimmedName,
        lastUsed: DateTime.now(),
        backgroundColorStartValue: startColor.toARGB32(),
        backgroundColorEndValue: endColor.toARGB32(),
      );
      await _box!.add(newPlayerName);
    }
  }

  /// Récupère l'icône d'un joueur (retourne null si non définie)
  int? getPlayerIcon(String name) {
    if (_box == null) return null;

    final playerName = _box!.values.firstWhere(
      (p) => p.name.toLowerCase() == name.toLowerCase(),
      orElse: () => PlayerName(name: '', lastUsed: DateTime.now()),
    );

    if (playerName.name.isEmpty) return null;

    return playerName.iconCodePoint;
  }

  /// Met à jour l'icône d'un joueur
  Future<void> updatePlayerIcon(String name, int iconCodePoint) async {
    if (_box == null || name.trim().isEmpty) return;

    final trimmedName = name.trim();

    // Vérifier si le nom existe déjà
    final existingIndex = _box!.values.toList().indexWhere(
      (p) => p.name.toLowerCase() == trimmedName.toLowerCase(),
    );

    if (existingIndex != -1) {
      // Mettre à jour l'icône du joueur existant
      final existing = _box!.getAt(existingIndex);
      if (existing != null) {
        final updated = existing.copyWith(
          iconCodePoint: iconCodePoint,
        );
        await _box!.putAt(existingIndex, updated);
      }
    } else {
      // Créer un nouveau joueur avec l'icône
      final newPlayerName = PlayerName(
        name: trimmedName,
        lastUsed: DateTime.now(),
        iconCodePoint: iconCodePoint,
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
PlayerHistoryService playerHistoryService(Ref ref) {
  final service = PlayerHistoryService();
  ref.onDispose(() => service.dispose());
  return service;
}

/// Provider pour la liste des noms de joueurs
@riverpod
List<String> playerNames(Ref ref) {
  final service = ref.watch(playerHistoryServiceProvider);
  return service.getAllPlayerNames();
}
