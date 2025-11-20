import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../domain/game_history.dart';
import '../domain/game_state.dart';

part 'game_statistics_service.g.dart';

/// Provider pour le service de statistiques
@riverpod
GameStatisticsService gameStatisticsService(Ref ref) {
  return GameStatisticsService();
}

/// Service pour gérer les statistiques et l'historique des parties
class GameStatisticsService {
  static const String _boxName = 'game_history';
  Box<GameHistory>? _box;

  /// Initialise le service en ouvrant la box Hive
  Future<void> init() async {
    _box = await Hive.openBox<GameHistory>(_boxName);
  }

  /// Sauvegarde une partie terminée
  Future<void> saveGame(GameHistory game) async {
    if (_box == null) await init();
    await _box!.put(game.id, game);
  }

  /// Récupère toutes les parties
  List<GameHistory> getAllGames() {
    if (_box == null) return [];
    return _box!.values.toList()
      ..sort((a, b) => b.endTime.compareTo(a.endTime)); // Plus récent en premier
  }

  /// Récupère une partie par son ID
  GameHistory? getGame(String id) {
    if (_box == null) return null;
    return _box!.get(id);
  }

  /// Supprime une partie
  Future<void> deleteGame(String id) async {
    if (_box == null) await init();
    await _box!.delete(id);
  }

  /// Supprime toutes les parties
  Future<void> deleteAllGames() async {
    if (_box == null) await init();
    await _box!.clear();
  }

  /// Récupère le nombre total de parties
  int getTotalGames() {
    return _box?.length ?? 0;
  }

  /// Récupère les statistiques pour un joueur
  PlayerStatistics getPlayerStatistics(String playerName) {
    final games = getAllGames();

    int wins = 0;
    int losses = 0;
    int totalScore = 0;

    for (final game in games) {
      if (game.player1Name == playerName) {
        totalScore += game.player1FinalScore;
        if (game.winnerName == playerName) {
          wins++;
        } else {
          losses++;
        }
      } else if (game.player2Name == playerName) {
        totalScore += game.player2FinalScore;
        if (game.winnerName == playerName) {
          wins++;
        } else {
          losses++;
        }
      }
    }

    final totalGames = wins + losses;
    final winrate = totalGames > 0 ? (wins / totalGames) * 100 : 0.0;
    final averageScore = totalGames > 0 ? totalScore / totalGames : 0.0;

    return PlayerStatistics(
      playerName: playerName,
      totalGames: totalGames,
      wins: wins,
      losses: losses,
      winrate: winrate,
      averageScore: averageScore,
    );
  }

  /// Récupère toutes les statistiques globales
  GlobalStatistics getGlobalStatistics() {
    final games = getAllGames();

    if (games.isEmpty) {
      return const GlobalStatistics(
        totalGames: 0,
        playerStats: {},
      );
    }

    // Créer un map des statistiques par joueur
    final Map<String, PlayerStatistics> playerStats = {};

    // Collecter tous les noms de joueurs uniques
    final Set<String> allPlayers = {};
    for (final game in games) {
      allPlayers.add(game.player1Name);
      allPlayers.add(game.player2Name);
    }

    // Calculer les statistiques pour chaque joueur
    for (final playerName in allPlayers) {
      playerStats[playerName] = getPlayerStatistics(playerName);
    }

    return GlobalStatistics(
      totalGames: games.length,
      playerStats: playerStats,
    );
  }

  /// Crée un GameHistory à partir d'un GameState terminé
  GameHistory createHistoryFromGameState(GameState gameState) {
    // Créer la liste des rounds
    final rounds = <RoundResult>[];
    int roundNumber = 1;

    // Si on a un gagnant, ajouter le round final
    if (gameState.winner != null) {
      rounds.add(RoundResult(
        roundNumber: roundNumber,
        player1Score: gameState.player1Score,
        player2Score: gameState.player2Score,
        winnerName: gameState.winner!.name,
        timestamp: DateTime.now(),
      ));
    }

    return GameHistory(
      id: gameState.id,
      player1Name: gameState.player1.name,
      player2Name: gameState.player2.name,
      player1FinalScore: gameState.player1Score,
      player2FinalScore: gameState.player2Score,
      winnerName: gameState.winner?.name ?? '',
      startTime: gameState.startTime,
      endTime: gameState.endTime ?? DateTime.now(),
      matchFormat: _formatToString(gameState.matchFormat),
      player1Wins: gameState.player1Wins,
      player2Wins: gameState.player2Wins,
      rounds: rounds,
    );
  }

  String _formatToString(MatchFormat format) {
    switch (format) {
      case MatchFormat.bestOf1:
        return 'Best of 1';
      case MatchFormat.bestOf3:
        return 'Best of 3';
      case MatchFormat.bestOf5:
        return 'Best of 5';
    }
  }
}

/// Statistiques pour un joueur
class PlayerStatistics {
  final String playerName;
  final int totalGames;
  final int wins;
  final int losses;
  final double winrate;
  final double averageScore;

  const PlayerStatistics({
    required this.playerName,
    required this.totalGames,
    required this.wins,
    required this.losses,
    required this.winrate,
    required this.averageScore,
  });
}

/// Statistiques globales
class GlobalStatistics {
  final int totalGames;
  final Map<String, PlayerStatistics> playerStats;

  const GlobalStatistics({
    required this.totalGames,
    required this.playerStats,
  });
}
