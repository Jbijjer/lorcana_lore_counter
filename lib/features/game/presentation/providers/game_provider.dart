import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/game_state.dart';
import '../../domain/player.dart';
import '../../../../core/constants/app_constants.dart';

part 'game_provider.g.dart';

/// Provider pour gérer l'état du jeu
@riverpod
class Game extends _$Game {
  @override
  GameState? build() {
    return null;
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
  }

  /// Incrémente le score du joueur 1
  void incrementPlayer1Score(int amount) {
    if (state == null) return;
    
    final newScore = (state!.player1Score + amount)
        .clamp(AppConstants.minScore, AppConstants.maxScore);
    
    state = state!.copyWith(player1Score: newScore);
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
  }

  /// Définit directement le score du joueur 2
  void setPlayer2Score(int newScore) {
    if (state == null) return;

    final clampedScore = newScore.clamp(AppConstants.minScore, AppConstants.maxScore);
    state = state!.copyWith(player2Score: clampedScore);
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
  }

  /// Termine la partie
  void endGame() {
    if (state == null) return;
    
    state = state!.copyWith(
      endTime: DateTime.now(),
      status: GameStatus.finished,
    );
  }

  /// Abandonne la partie
  void abandonGame() {
    if (state == null) return;
    
    state = state!.copyWith(
      endTime: DateTime.now(),
      status: GameStatus.abandoned,
    );
  }

  /// Réinitialise la partie
  void resetGame() {
    state = null;
  }

  /// Change le nom du joueur 1
  void changePlayer1Name(String newName) {
    if (state == null) return;

    final updatedPlayer = state!.player1.copyWith(name: newName);
    state = state!.copyWith(player1: updatedPlayer);
  }

  /// Change le nom du joueur 2
  void changePlayer2Name(String newName) {
    if (state == null) return;

    final updatedPlayer = state!.player2.copyWith(name: newName);
    state = state!.copyWith(player2: updatedPlayer);
  }
}
