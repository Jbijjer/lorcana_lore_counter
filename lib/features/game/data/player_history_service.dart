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

    // Migrer les joueurs existants sans ID
    await _migratePlayersWithoutId();
  }

  /// Migre les joueurs existants qui n'ont pas d'ID
  Future<void> _migratePlayersWithoutId() async {
    if (_box == null) return;

    bool needsMigration = false;
    final updatedPlayers = <int, PlayerName>{};

    for (int i = 0; i < _box!.length; i++) {
      final player = _box!.getAt(i);
      if (player != null && player.id == null) {
        needsMigration = true;
        // Générer un ID unique pour ce joueur
        final newId = '${DateTime.now().millisecondsSinceEpoch}_$i';
        updatedPlayers[i] = player.copyWith(id: newId);
      }
    }

    if (needsMigration) {
      for (final entry in updatedPlayers.entries) {
        await _box!.putAt(entry.key, entry.value);
      }
    }
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
    print('➕ addOrUpdatePlayerName: name="$trimmedName"');

    // Vérifier si le nom existe déjà
    final existingIndex = _box!.values.toList().indexWhere(
      (p) => p.name.toLowerCase() == trimmedName.toLowerCase(),
    );

    if (existingIndex != -1) {
      // Mettre à jour le nom existant
      final existing = _box!.getAt(existingIndex);
      if (existing != null) {
        print('  ✏️ Found existing at index $existingIndex: id=${existing.id}');
        final updated = existing.copyWith(
          lastUsed: DateTime.now(),
          usageCount: existing.usageCount + 1,
        );
        await _box!.putAt(existingIndex, updated);
        print('  ✅ Updated player at index $existingIndex');
      }
    } else {
      // Ajouter un nouveau nom
      final newPlayerName = PlayerName(
        name: trimmedName,
        lastUsed: DateTime.now(),
      );
      await _box!.add(newPlayerName);
      print('  ✅ Added new player with id=${newPlayerName.id}');
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

  /// Récupère un joueur complet par son nom
  PlayerName? getPlayerByName(String name) {
    if (_box == null) return null;

    print('🔍 getPlayerByName: searching for "$name"');
    final index = _box!.values.toList().indexWhere(
      (p) => p.name.toLowerCase() == name.toLowerCase(),
    );

    if (index == -1) {
      print('  ❌ Player not found');
      return null;
    }

    final playerName = _box!.getAt(index);
    if (playerName == null) {
      print('  ❌ Player at index $index is null');
      return null;
    }

    print('  ✅ Found player at index $index: id=${playerName.id}');

    // Si le joueur n'a pas d'ID, en générer un et le sauvegarder immédiatement
    if (playerName.id == null || playerName.id!.isEmpty) {
      print('  ⚠️ Player has no ID, generating one...');
      final newId = '${DateTime.now().millisecondsSinceEpoch}_$index';
      final updatedPlayer = playerName.copyWith(id: newId);
      _box!.putAt(index, updatedPlayer);
      print('  ✅ Saved player with new ID: $newId');
      return updatedPlayer;
    }

    return playerName;
  }

  /// Récupère l'icône d'un joueur (retourne null si non définie)
  int? getPlayerIcon(String name) {
    final player = getPlayerByName(name);
    return player?.iconCodePoint;
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

  /// Met à jour un joueur par son ID
  Future<void> updatePlayerById({
    required String id,
    String? newName,
    String? oldName,
    Color? backgroundColorStart,
    Color? backgroundColorEnd,
    int? iconCodePoint,
  }) async {
    if (_box == null) return;

    print('🔧 updatePlayerById: id="$id", oldName="$oldName", newName="$newName"');
    print('  📦 Current box size: ${_box!.length}');
    print('  📋 All players in box:');
    for (int i = 0; i < _box!.length; i++) {
      final p = _box!.getAt(i);
      print('    [$i] name="${p?.name}", id="${p?.id}"');
    }

    // Chercher le joueur par ID
    int index = _box!.values.toList().indexWhere(
      (p) => p.id == id,
    );

    print('  🔎 Search by ID "$id": index=$index');

    // Si non trouvé par ID et qu'on a l'ancien nom, chercher par nom en fallback
    if (index == -1 && oldName != null && oldName.isNotEmpty) {
      print('  ⚠️ Not found by ID, searching by name "$oldName"...');
      index = _box!.values.toList().indexWhere(
        (p) => p.name.toLowerCase() == oldName.toLowerCase(),
      );
      print('  🔎 Search by name: index=$index');
    }

    if (index != -1) {
      final existing = _box!.getAt(index);
      if (existing != null) {
        print('  ✅ Found player at index $index: name="${existing.name}", id="${existing.id}"');
        // S'assurer que l'ID est présent
        final finalId = existing.id ?? id;
        print('  🆔 Using ID: $finalId');

        final updated = existing.copyWith(
          id: finalId,
          name: newName,
          lastUsed: DateTime.now(),
          usageCount: existing.usageCount + 1,
          backgroundColorStartValue: backgroundColorStart?.toARGB32(),
          backgroundColorEndValue: backgroundColorEnd?.toARGB32(),
          iconCodePoint: iconCodePoint,
        );
        await _box!.putAt(index, updated);
        print('  ✅ Updated player at index $index');
      }
    } else {
      print('  ❌ ERROR: Player not found by ID or name!');
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
