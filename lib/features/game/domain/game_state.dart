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
    @Default(MatchFormat.bestOf1) MatchFormat matchFormat,
    @Default(0) int player1Wins,
    @Default(0) int player2Wins,
  }) = _GameState;

  const GameState._();

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);

  /// Crée une nouvelle partie
  factory GameState.create({
    required Player player1,
    required Player player2,
  }) {
    return GameState(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      player1: player1,
      player2: player2,
      startTime: DateTime.now(),
    );
  }

  /// Vérifie si la partie est terminée (un joueur a atteint 20 points)
  bool get isFinished => player1Score >= 20 || player2Score >= 20;

  /// Retourne le gagnant si la partie est terminée
  Player? get winner {
    if (!isFinished) return null;
    return player1Score >= 20 ? player1 : player2;
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
