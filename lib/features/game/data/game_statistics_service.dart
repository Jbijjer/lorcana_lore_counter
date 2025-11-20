import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive/hive.dart';
import '../domain/game_history.dart';
import '../domain/game_state.dart';

part 'game_statistics_service.g.dart';

/// Provider pour le service de statistiques (singleton)
@Riverpod(keepAlive: true)
GameStatisticsService gameStatisticsService(GameStatisticsServiceRef ref) {
  return GameStatisticsService();
}

/// Service pour gérer les statistiques et l'historique des parties
class GameStatisticsService {
  static const String _boxName = 'game_history';
  Box<GameHistory>? _box;

  /// Initialise le service en ouvrant la box Hive
  Future<void> init() async {
    print('📦 GameStatisticsService: Initialisation de la box Hive "$_boxName"');
    _box = await Hive.openBox<GameHistory>(_boxName);
    print('✅ Box Hive ouverte: ${_box!.length} partie(s) existante(s)');
  }

  /// Sauvegarde une partie terminée
  Future<void> saveGame(GameHistory game) async {
    print('💾 saveGame: Début de la sauvegarde');
    if (_box == null) {
      print('⚠️  Box null, initialisation...');
      await init();
    }

    print('📝 Sauvegarde de la partie: ${game.id}');
    print('  - ${game.player1Name} vs ${game.player2Name}');
    print('  - Gagnant: ${game.winnerName ?? "Match nul"}');

    await _box!.put(game.id, game);

    print('✅ Partie sauvegardée ! Total: ${_box!.length} partie(s)');
  }

  /// Récupère toutes les parties
  List<GameHistory> getAllGames() {
    if (_box == null) {
      print('⚠️  getAllGames: Box null, retour liste vide');
      return [];
    }

    final games = _box!.values.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Plus récent en premier

    print('📊 getAllGames: ${games.length} partie(s) récupérée(s)');
    return games;
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
    int draws = 0;
    int totalScore = 0;

    for (final game in games) {
      final isPlayer1 = game.player1Name == playerName;
      final isPlayer2 = game.player2Name == playerName;

      if (isPlayer1 || isPlayer2) {
        // Ajouter le score
        totalScore += isPlayer1 ? game.player1FinalScore : game.player2FinalScore;

        // Gérer les statistiques
        if (game.isDraw) {
          draws++;
        } else if (game.winnerName == playerName) {
          wins++;
        } else {
          losses++;
        }
      }
    }

    final totalGames = wins + losses + draws;
    final winrate = totalGames > 0 ? (wins / totalGames) * 100 : 0.0;
    final averageScore = totalGames > 0 ? totalScore / totalGames : 0.0;

    return PlayerStatistics(
      playerName: playerName,
      totalGames: totalGames,
      wins: wins,
      losses: losses,
      draws: draws,
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

  /// Sauvegarde une partie terminée (20 pts)
  Future<void> savePartie({
    required String player1Name,
    required String player2Name,
    required int player1Score,
    required int player2Score,
    required String? winnerName,
    required List<String> player1DeckColors,
    required List<String> player2DeckColors,
    String? note,
  }) async {
    final gameHistory = GameHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      player1Name: player1Name,
      player2Name: player2Name,
      player1FinalScore: player1Score,
      player2FinalScore: player2Score,
      winnerName: winnerName,
      timestamp: DateTime.now(),
      player1DeckColors: player1DeckColors,
      player2DeckColors: player2DeckColors,
      note: note,
    );

    await saveGame(gameHistory);
  }
}

/// Statistiques pour un joueur
class PlayerStatistics {
  final String playerName;
  final int totalGames;
  final int wins;
  final int losses;
  final int draws;
  final double winrate;
  final double averageScore;

  const PlayerStatistics({
    required this.playerName,
    required this.totalGames,
    required this.wins,
    required this.losses,
    required this.draws,
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
