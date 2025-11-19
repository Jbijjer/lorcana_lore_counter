import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/game_state.dart';
import '../../domain/player.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/game_persistence_service.dart';

part 'game_provider.g.dart';

/// Provider pour gérer l'état du jeu
@riverpod
class Game extends _$Game {
  @override
  GameState? build() {
    return null;
  }

  /// Sauvegarde automatiquement l'état du jeu
  void _saveState() {
    if (state != null) {
      ref.read(gamePersistenceServiceProvider).saveGame(state!);
    }
  }

  /// Charge une partie existante
  void loadGame(GameState gameState) {
    state = gameState;
  }

  /// Démarre une nouvelle partie
  void startGame({
    required Player player1,
    required Player player2,
    MatchFormat matchFormat = MatchFormat.bestOf3,
  }) {
    state = GameState.create(
      player1: player1,
      player2: player2,
      matchFormat: matchFormat,
    );
    _saveState();
  }

  /// Incrémente le score du joueur 1
  void incrementPlayer1Score(int amount) {
    if (state == null) return;

    final newScore = (state!.player1Score + amount)
        .clamp(AppConstants.minScore, AppConstants.maxScore);

    state = state!.copyWith(player1Score: newScore);
    _saveState();
  }

  /// Décrémente le score du joueur 1
  void decrementPlayer1Score(int amount) {
    incrementPlayer1Score(-amount);
  }

  /// Incrémente le score du joueur 2
  void incrementPlayer2Score(int amount) {
    if (state == null) return;

    final newScore = (state!.player2Score + amount)
        .clamp(AppConstants.minScore, AppConstants.maxScore);

    state = state!.copyWith(player2Score: newScore);
    _saveState();
  }

  /// Décrémente le score du joueur 2
  void decrementPlayer2Score(int amount) {
    incrementPlayer2Score(-amount);
  }

  /// Définit directement le score du joueur 1
  void setPlayer1Score(int newScore) {
    if (state == null) return;

    final clampedScore = newScore.clamp(AppConstants.minScore, AppConstants.maxScore);
    state = state!.copyWith(player1Score: clampedScore);
    _saveState();
  }

  /// Définit directement le score du joueur 2
  void setPlayer2Score(int newScore) {
    if (state == null) return;

    final clampedScore = newScore.clamp(AppConstants.minScore, AppConstants.maxScore);
    state = state!.copyWith(player2Score: clampedScore);
    _saveState();
  }

  /// Passe au round suivant
  void nextRound() {
    if (state == null) return;

    final previousRound = state!.rounds.isEmpty
        ? null
        : state!.rounds.last;

    final player1Delta = previousRound == null
        ? state!.player1Score
        : state!.player1Score - previousRound.player1TotalScore;

    final player2Delta = previousRound == null
        ? state!.player2Score
        : state!.player2Score - previousRound.player2TotalScore;

    final newRound = RoundScore(
      roundNumber: state!.currentRound,
      player1Delta: player1Delta,
      player2Delta: player2Delta,
      player1TotalScore: state!.player1Score,
      player2TotalScore: state!.player2Score,
      timestamp: DateTime.now(),
    );

    state = state!.copyWith(
      currentRound: state!.currentRound + 1,
      rounds: [...state!.rounds, newRound],
    );
    _saveState();
  }

  /// Termine la partie en cours
  void finishGame() {
    if (state == null) return;

    state = state!.copyWith(
      status: GameStatus.finished,
      endTime: DateTime.now(),
    );

    // Supprimer la sauvegarde car la partie est terminée
    ref.read(gamePersistenceServiceProvider).clearGame();
  }

  /// Réinitialise la partie
  void resetGame() {
    // Supprimer la sauvegarde
    ref.read(gamePersistenceServiceProvider).clearGame();
    state = null;
  }

  /// Réinitialise uniquement les scores (garde les joueurs et l'état)
  void resetScores() {
    if (state == null) return;

    state = state!.copyWith(
      player1Score: 0,
      player2Score: 0,
    );
    _saveState();
  }

  /// Réinitialise le round complet (scores et victoires)
  void resetRound() {
    if (state == null) return;

    state = state!.copyWith(
      player1Score: 0,
      player2Score: 0,
      player1Wins: 0,
      player2Wins: 0,
      currentRound: 1,
      rounds: [],
      status: GameStatus.inProgress,
    );
    _saveState();
  }

  /// Change le nom du joueur 1
  void changePlayer1Name(String newName) {
    if (state == null) return;

    final updatedPlayer = state!.player1.copyWith(name: newName);
    state = state!.copyWith(player1: updatedPlayer);
    _saveState();
  }

  /// Change le nom du joueur 2
  void changePlayer2Name(String newName) {
    if (state == null) return;

    final updatedPlayer = state!.player2.copyWith(name: newName);
    state = state!.copyWith(player2: updatedPlayer);
    _saveState();
  }

  /// Change les couleurs de fond du joueur 1
  void changePlayer1BackgroundColors(Color start, Color end) {
    if (state == null) return;

    final updatedPlayer = state!.player1.copyWith(
      backgroundColorStart: start,
      backgroundColorEnd: end,
    );
    state = state!.copyWith(player1: updatedPlayer);
    _saveState();
  }

  /// Change les couleurs de fond du joueur 2
  void changePlayer2BackgroundColors(Color start, Color end) {
    if (state == null) return;

    final updatedPlayer = state!.player2.copyWith(
      backgroundColorStart: start,
      backgroundColorEnd: end,
    );
    state = state!.copyWith(player2: updatedPlayer);
    _saveState();
  }

  /// Change l'icône du joueur 1
  void changePlayer1Icon(String iconAssetPath) {
    if (state == null) return;

    final updatedPlayer = state!.player1.copyWith(
      iconAssetPath: iconAssetPath,
    );
    state = state!.copyWith(player1: updatedPlayer);
    _saveState();
  }

  /// Change l'icône du joueur 2
  void changePlayer2Icon(String iconAssetPath) {
    if (state == null) return;

    final updatedPlayer = state!.player2.copyWith(
      iconAssetPath: iconAssetPath,
    );
    state = state!.copyWith(player2: updatedPlayer);
    _saveState();
  }

  /// Ajoute une victoire au joueur 1 et réinitialise les scores pour la manche suivante
  void addPlayer1Win() {
    if (state == null) return;

    state = state!.copyWith(
      player1Wins: state!.player1Wins + 1,
      player1Score: 0,
      player2Score: 0,
      currentRound: state!.currentRound + 1,
      player1VictoryThreshold: 20,
      player2VictoryThreshold: 20,
      player1VictoryDeclined: false,
      player2VictoryDeclined: false,
    );
    _saveState();
  }

  /// Ajoute une victoire au joueur 2 et réinitialise les scores pour la manche suivante
  void addPlayer2Win() {
    if (state == null) return;

    state = state!.copyWith(
      player2Wins: state!.player2Wins + 1,
      player1Score: 0,
      player2Score: 0,
      currentRound: state!.currentRound + 1,
      player1VictoryThreshold: 20,
      player2VictoryThreshold: 20,
      player1VictoryDeclined: false,
      player2VictoryDeclined: false,
    );
    _saveState();
  }

  /// Change le format du match
  void setMatchFormat(MatchFormat format) {
    if (state == null) return;

    state = state!.copyWith(matchFormat: format);
    _saveState();
  }

  /// Confirme la victoire et termine la partie
  /// Note: Avec les seuils individuels, pas besoin de modifier l'état
  /// La victoire est automatiquement confirmée si le flag individuel est false
  void confirmVictory() {
    if (state == null) return;
    // Rien à faire : l'état actuel confirme déjà la victoire
    // car le joueur n'a pas refusé (flag victoryDeclined = false)
  }

  /// Refuse la victoire pour le joueur qui a atteint le seuil, augmente son seuil à 25 points
  void declineVictory() {
    if (state == null) return;

    // Déterminer quel joueur a atteint le seuil
    final isPlayer1 = state!.isPlayer1AtThreshold;

    if (isPlayer1) {
      state = state!.copyWith(
        player1VictoryDeclined: true,
        player1VictoryThreshold: 25,
      );
    } else {
      state = state!.copyWith(
        player2VictoryDeclined: true,
        player2VictoryThreshold: 25,
      );
    }
    _saveState();
  }

  /// Réinitialise les flags de victoire refusée individuellement pour chaque joueur
  void resetVictoryDeclined() {
    if (state == null) return;

    bool needsUpdate = false;
    Map<String, dynamic> updates = {};

    // Vérifier le joueur 1
    if (state!.player1VictoryDeclined) {
      // Cas 1 : Le score est retombé en dessous du seuil initial (20)
      if (state!.player1Score < 20) {
        updates['player1VictoryDeclined'] = false;
        updates['player1VictoryThreshold'] = 20;
        needsUpdate = true;
      }
      // Cas 2 : Le joueur 1 a atteint son nouveau seuil (25)
      else if (state!.player1Score >= state!.player1VictoryThreshold) {
        updates['player1VictoryDeclined'] = false;
        needsUpdate = true;
      }
    }

    // Vérifier le joueur 2
    if (state!.player2VictoryDeclined) {
      // Cas 1 : Le score est retombé en dessous du seuil initial (20)
      if (state!.player2Score < 20) {
        updates['player2VictoryDeclined'] = false;
        updates['player2VictoryThreshold'] = 20;
        needsUpdate = true;
      }
      // Cas 2 : Le joueur 2 a atteint son nouveau seuil (25)
      else if (state!.player2Score >= state!.player2VictoryThreshold) {
        updates['player2VictoryDeclined'] = false;
        needsUpdate = true;
      }
    }

    if (needsUpdate) {
      state = state!.copyWith(
        player1VictoryDeclined: updates['player1VictoryDeclined'] ?? state!.player1VictoryDeclined,
        player1VictoryThreshold: updates['player1VictoryThreshold'] ?? state!.player1VictoryThreshold,
        player2VictoryDeclined: updates['player2VictoryDeclined'] ?? state!.player2VictoryDeclined,
        player2VictoryThreshold: updates['player2VictoryThreshold'] ?? state!.player2VictoryThreshold,
      );
      _saveState();
    }
  }
}
