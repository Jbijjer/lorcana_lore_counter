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
  }) {
    state = GameState.create(
      player1: player1,
      player2: player2,
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
  void confirmVictory() {
    if (state == null) return;

    state = state!.copyWith(
      victoryDeclined: false,
    );
    _saveState();
  }

  /// Refuse la victoire, augmente le seuil à 25 points
  void declineVictory() {
    if (state == null) return;

    state = state!.copyWith(
      victoryDeclined: true,
      victoryThreshold: 25,
    );
    _saveState();
  }

  /// Réinitialise le flag de victoire refusée quand le score retombe en dessous de 20
  /// ou quand un joueur atteint le nouveau seuil de 25
  void resetVictoryDeclined() {
    if (state == null) return;

    if (state!.victoryDeclined) {
      // Cas 1 : Les deux scores sont retombés en dessous du seuil initial (20)
      if (state!.player1Score < 20 && state!.player2Score < 20) {
        state = state!.copyWith(
          victoryDeclined: false,
          victoryThreshold: 20,
        );
        _saveState();
      }
      // Cas 2 : Un joueur a atteint le nouveau seuil (25)
      else if (state!.player1Score >= state!.victoryThreshold ||
               state!.player2Score >= state!.victoryThreshold) {
        state = state!.copyWith(
          victoryDeclined: false,
        );
        _saveState();
      }
    }
  }
}
