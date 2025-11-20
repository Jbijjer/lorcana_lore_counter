import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'game_history.freezed.dart';
part 'game_history.g.dart';

/// Historique d'une partie terminée
@freezed
@HiveType(typeId: 2)
class GameHistory with _$GameHistory {
  const factory GameHistory({
    @HiveField(0) required String id,
    @HiveField(1) required String player1Name,
    @HiveField(2) required String player2Name,
    @HiveField(3) required int player1FinalScore,
    @HiveField(4) required int player2FinalScore,
    @HiveField(5) String? winnerName, // Nullable pour les matchs nuls
    @HiveField(6) required DateTime startTime,
    @HiveField(7) required DateTime endTime,
    @HiveField(8) required String matchFormat,
    @HiveField(9) @Default(0) int player1Wins,
    @HiveField(10) @Default(0) int player2Wins,
    @HiveField(11) @Default([]) List<RoundResult> rounds,
    @HiveField(12) @Default([]) List<String> player1DeckColors, // Les 2 couleurs du deck du joueur 1
    @HiveField(13) @Default([]) List<String> player2DeckColors, // Les 2 couleurs du deck du joueur 2
  }) = _GameHistory;

  const GameHistory._();

  factory GameHistory.fromJson(Map<String, dynamic> json) =>
      _$GameHistoryFromJson(json);

  /// Durée de la partie
  Duration get duration => endTime.difference(startTime);

  /// Durée formatée (ex: "15m 30s")
  String get formattedDuration {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    }
    return '${seconds}s';
  }

  /// Vérifie si la partie s'est terminée en match nul
  bool get isDraw => winnerName == null || winnerName!.isEmpty;

  /// Retourne le texte du résultat (nom du gagnant ou "Match nul")
  String get resultText => isDraw ? 'Match nul' : winnerName!;
}

/// Résultat d'un round
@freezed
@HiveType(typeId: 3)
class RoundResult with _$RoundResult {
  const factory RoundResult({
    @HiveField(0) required int roundNumber,
    @HiveField(1) required int player1Score,
    @HiveField(2) required int player2Score,
    @HiveField(3) required String? winnerName,
    @HiveField(4) required DateTime timestamp,
  }) = _RoundResult;

  factory RoundResult.fromJson(Map<String, dynamic> json) =>
      _$RoundResultFromJson(json);
}
