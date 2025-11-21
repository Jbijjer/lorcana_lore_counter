import 'package:freezed_annotation/freezed_annotation.dart';
import 'player.dart';

part 'game_state.freezed.dart';
part 'game_state.g.dart';

/// État d'une partie en cours
@freezed
class GameState with _$GameState {
  const factory GameState({
    required String id,
    required Player player1,
    required Player player2,
    required DateTime startTime,
    DateTime? endTime,
    @Default(0) int player1Score,
    @Default(0) int player2Score,
    @Default(1) int currentRound,
    @Default([]) List<RoundScore> rounds,
    @Default(GameStatus.inProgress) GameStatus status,
    @Default(MatchFormat.bestOf3) MatchFormat matchFormat,
    @Default(0) int player1Wins,
    @Default(0) int player2Wins,
    @Default(false) bool player1VictoryDeclined,
    @Default(false) bool player2VictoryDeclined,
    @Default(20) int player1VictoryThreshold,
    @Default(20) int player2VictoryThreshold,
    @Default([]) List<String> player1DeckColors, // Les 2 couleurs du deck du joueur 1 pour cette partie
    @Default([]) List<String> player2DeckColors, // Les 2 couleurs du deck du joueur 2 pour cette partie
    @Default(false) bool isTimeMode, // Mode Time activé (fin de temps de jeu)
    @Default(5) int timeCount, // Compteur Time (0 à 5)
  }) = _GameState;

  const GameState._();

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);

  /// Crée une nouvelle partie
  factory GameState.create({
    required Player player1,
    required Player player2,
    MatchFormat matchFormat = MatchFormat.bestOf3,
  }) {
    return GameState(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      player1: player1,
      player2: player2,
      startTime: DateTime.now(),
      matchFormat: matchFormat,
    );
  }

  /// Vérifie si le joueur 1 a atteint son seuil de victoire
  bool get player1HasReachedThreshold => player1Score >= player1VictoryThreshold;

  /// Vérifie si le joueur 2 a atteint son seuil de victoire
  bool get player2HasReachedThreshold => player2Score >= player2VictoryThreshold;

  /// Vérifie si un joueur a atteint le seuil de victoire
  bool get hasReachedVictoryThreshold =>
      player1HasReachedThreshold || player2HasReachedThreshold;

  /// Vérifie si la partie est terminée (un joueur a atteint le seuil et la victoire est confirmée)
  bool get isFinished =>
      (player1HasReachedThreshold && !player1VictoryDeclined) ||
      (player2HasReachedThreshold && !player2VictoryDeclined);

  /// Retourne le joueur qui a atteint le seuil de victoire (null si aucun)
  Player? get playerAtThreshold {
    if (!hasReachedVictoryThreshold) return null;
    return player1HasReachedThreshold ? player1 : player2;
  }

  /// Retourne true si c'est le joueur 1 qui a atteint le seuil
  bool get isPlayer1AtThreshold => player1HasReachedThreshold;

  /// Retourne le gagnant du match (basé sur le nombre de victoires de rounds)
  Player? get winner {
    final winsNeeded = matchFormat.winsNeeded;

    // Vérifier qui a gagné le match complet
    if (player1Wins >= winsNeeded) return player1;
    if (player2Wins >= winsNeeded) return player2;

    // Aucun gagnant (match non terminé ou égalité)
    return null;
  }
}

/// Score d'un round
@freezed
class RoundScore with _$RoundScore {
  const factory RoundScore({
    required int roundNumber,
    required int player1Delta,
    required int player2Delta,
    required int player1TotalScore,
    required int player2TotalScore,
    required DateTime timestamp,
  }) = _RoundScore;

  factory RoundScore.fromJson(Map<String, dynamic> json) =>
      _$RoundScoreFromJson(json);
}

/// Statut de la partie
enum GameStatus {
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('finished')
  finished,
  @JsonValue('abandoned')
  abandoned,
}

/// Format du match (best of 1, 3 ou 5)
enum MatchFormat {
  @JsonValue('best_of_1')
  bestOf1,
  @JsonValue('best_of_3')
  bestOf3,
  @JsonValue('best_of_5')
  bestOf5,
}

/// Extension pour obtenir le nombre de victoires nécessaires
extension MatchFormatExtension on MatchFormat {
  int get winsNeeded {
    switch (this) {
      case MatchFormat.bestOf1:
        return 1;
      case MatchFormat.bestOf3:
        return 2;
      case MatchFormat.bestOf5:
        return 3;
    }
  }
}
