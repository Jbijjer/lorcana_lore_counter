import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'game_history.freezed.dart';
part 'game_history.g.dart';

/// Historique d'une partie terminée (une partie = un jeu jusqu'à 20/25 lore)
/// Note: Dans la terminologie de l'app, une "partie" est un jeu individuel jusqu'à 20 pts.
/// Un "round" (Best of 3/5) est composé de plusieurs parties.
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
    @HiveField(6) required DateTime timestamp, // Quand la partie s'est terminée
    @HiveField(7) @Default([]) List<String> player1DeckColors, // Les 2 couleurs du deck du joueur 1
    @HiveField(8) @Default([]) List<String> player2DeckColors, // Les 2 couleurs du deck du joueur 2
    @HiveField(9) String? note, // Note sur la partie (optionnel)
    @HiveField(10) String? firstToPlayName, // Nom du joueur qui a commencé la partie
  }) = _GameHistory;

  const GameHistory._();

  factory GameHistory.fromJson(Map<String, dynamic> json) =>
      _$GameHistoryFromJson(json);

  /// Vérifie si la partie s'est terminée en match nul
  bool get isDraw => winnerName == null || winnerName!.isEmpty;

  /// Retourne le texte du résultat (nom du gagnant ou "Match nul")
  String get resultText => isDraw ? 'Match nul' : winnerName!;
}
