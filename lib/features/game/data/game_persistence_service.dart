import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/game_state.dart';

part 'game_persistence_service.g.dart';

/// Service pour gérer la persistence de l'état de jeu
class GamePersistenceService {
  static const String _boxName = 'game_state';
  static const String _currentGameKey = 'current_game';
  Box<String>? _box;

  /// Initialise le service et ouvre la box Hive
  Future<void> init() async {
    _box = await Hive.openBox<String>(_boxName);
  }

  /// Sauvegarde l'état de jeu actuel
  Future<void> saveGame(GameState gameState) async {
    if (_box == null) return;

    // Sauvegarder uniquement si la partie est en cours
    if (gameState.status == GameStatus.inProgress) {
      final json = jsonEncode(gameState.toJson());
      await _box!.put(_currentGameKey, json);
    }
  }

  /// Charge le dernier état de jeu sauvegardé
  GameState? loadLastGame() {
    if (_box == null) return null;

    final jsonString = _box!.get(_currentGameKey);
    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final gameState = GameState.fromJson(json);

      // Retourner seulement si la partie est en cours
      if (gameState.status == GameStatus.inProgress) {
        return gameState;
      }
      return null;
    } catch (e) {
      // En cas d'erreur de désérialisation, supprimer la sauvegarde corrompue
      clearGame();
      return null;
    }
  }

  /// Supprime la sauvegarde de la partie en cours
  Future<void> clearGame() async {
    if (_box == null) return;
    await _box!.delete(_currentGameKey);
  }

  /// Vérifie s'il existe une partie sauvegardée
  bool hasOngoingGame() {
    if (_box == null) return false;
    final gameState = loadLastGame();
    return gameState != null && gameState.status == GameStatus.inProgress;
  }

  /// Ferme la box Hive
  Future<void> dispose() async {
    await _box?.close();
  }
}

/// Provider pour le service de persistence du jeu
@Riverpod(keepAlive: true)
GamePersistenceService gamePersistenceService(Ref ref) {
  final service = GamePersistenceService();
  ref.onDispose(() => service.dispose());
  return service;
}
