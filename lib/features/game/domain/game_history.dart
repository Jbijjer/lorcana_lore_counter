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
    @HiveField(5) required String winnerName,
    @HiveField(6) required DateTime startTime,
    @HiveField(7) required DateTime endTime,
    @HiveField(8) required String matchFormat,
    @HiveField(9) @Default(0) int player1Wins,
    @HiveField(10) @Default(0) int player2Wins,
    @HiveField(11) @Default([]) List<RoundResult> rounds,
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
