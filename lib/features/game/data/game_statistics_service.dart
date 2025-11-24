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

    // Stats "Premier à jouer"
    int gamesAsFirstPlayer = 0;
    int winsAsFirstPlayer = 0;
    int gamesAsSecondPlayer = 0;
    int winsAsSecondPlayer = 0;

    for (final game in games) {
      final isPlayer1 = game.player1Name == playerName;
      final isPlayer2 = game.player2Name == playerName;

      if (isPlayer1 || isPlayer2) {
        // Ajouter le score
        totalScore += isPlayer1 ? game.player1FinalScore : game.player2FinalScore;

        // Déterminer si le joueur était premier à jouer
        final wasFirstToPlay = game.firstToPlayName == playerName;
        final wasSecondToPlay = game.firstToPlayName != null && game.firstToPlayName != playerName;

        if (wasFirstToPlay) {
          gamesAsFirstPlayer++;
        } else if (wasSecondToPlay) {
          gamesAsSecondPlayer++;
        }

        // Gérer les statistiques
        if (game.isDraw) {
          draws++;
        } else if (game.winnerName == playerName) {
          wins++;
          // Compter les victoires selon le rôle
          if (wasFirstToPlay) {
            winsAsFirstPlayer++;
          } else if (wasSecondToPlay) {
            winsAsSecondPlayer++;
          }
        } else {
          losses++;
        }
      }
    }

    final totalGames = wins + losses + draws;
    final winrate = totalGames > 0 ? (wins / totalGames) * 100 : 0.0;
    final averageScore = totalGames > 0 ? totalScore / totalGames : 0.0;
    final winrateAsFirstPlayer = gamesAsFirstPlayer > 0
        ? (winsAsFirstPlayer / gamesAsFirstPlayer) * 100
        : 0.0;
    final winrateAsSecondPlayer = gamesAsSecondPlayer > 0
        ? (winsAsSecondPlayer / gamesAsSecondPlayer) * 100
        : 0.0;

    return PlayerStatistics(
      playerName: playerName,
      totalGames: totalGames,
      wins: wins,
      losses: losses,
      draws: draws,
      winrate: winrate,
      averageScore: averageScore,
      gamesAsFirstPlayer: gamesAsFirstPlayer,
      winsAsFirstPlayer: winsAsFirstPlayer,
      gamesAsSecondPlayer: gamesAsSecondPlayer,
      winsAsSecondPlayer: winsAsSecondPlayer,
      winrateAsFirstPlayer: winrateAsFirstPlayer,
      winrateAsSecondPlayer: winrateAsSecondPlayer,
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
    String? firstToPlayName,
    int? roundNumber,
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
      firstToPlayName: firstToPlayName,
      roundNumber: roundNumber,
    );

    await saveGame(gameHistory);
  }

  /// Récupère les statistiques head-to-head entre deux joueurs
  HeadToHeadStatistics getHeadToHeadStatistics(String playerName, String opponentName) {
    final games = getAllGames();

    int wins = 0;
    int losses = 0;
    int draws = 0;

    for (final game in games) {
      final isPlayer1 = game.player1Name == playerName && game.player2Name == opponentName;
      final isPlayer2 = game.player2Name == playerName && game.player1Name == opponentName;

      if (isPlayer1 || isPlayer2) {
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

    return HeadToHeadStatistics(
      playerName: playerName,
      opponentName: opponentName,
      totalGames: totalGames,
      wins: wins,
      losses: losses,
      draws: draws,
      winrate: winrate,
    );
  }

  /// Récupère tous les adversaires d'un joueur
  List<String> getOpponents(String playerName) {
    final games = getAllGames();
    final opponents = <String>{};

    for (final game in games) {
      if (game.player1Name == playerName) {
        opponents.add(game.player2Name);
      } else if (game.player2Name == playerName) {
        opponents.add(game.player1Name);
      }
    }

    return opponents.toList()..sort();
  }

  /// Récupère les statistiques contre chaque couleur de deck
  List<ColorStatistics> getColorStatistics(String playerName) {
    final games = getAllGames();
    final colorStats = <String, Map<String, int>>{};

    // Initialiser les couleurs Lorcana
    const lorcanaColors = ['Amber', 'Amethyst', 'Emerald', 'Ruby', 'Sapphire', 'Steel'];
    for (final color in lorcanaColors) {
      colorStats[color] = {'wins': 0, 'losses': 0, 'draws': 0};
    }

    for (final game in games) {
      List<String> opponentColors = [];
      bool isInGame = false;

      if (game.player1Name == playerName) {
        opponentColors = game.player2DeckColors;
        isInGame = true;
      } else if (game.player2Name == playerName) {
        opponentColors = game.player1DeckColors;
        isInGame = true;
      }

      if (isInGame && opponentColors.isNotEmpty) {
        for (final color in opponentColors) {
          if (colorStats.containsKey(color)) {
            if (game.isDraw) {
              colorStats[color]!['draws'] = colorStats[color]!['draws']! + 1;
            } else if (game.winnerName == playerName) {
              colorStats[color]!['wins'] = colorStats[color]!['wins']! + 1;
            } else {
              colorStats[color]!['losses'] = colorStats[color]!['losses']! + 1;
            }
          }
        }
      }
    }

    // Convertir en liste de ColorStatistics
    return lorcanaColors.map((color) {
      final stats = colorStats[color]!;
      final wins = stats['wins']!;
      final losses = stats['losses']!;
      final draws = stats['draws']!;
      final totalGames = wins + losses + draws;
      final winrate = totalGames > 0 ? (wins / totalGames) * 100 : 0.0;

      return ColorStatistics(
        colorName: color,
        totalGames: totalGames,
        wins: wins,
        losses: losses,
        draws: draws,
        winrate: winrate,
      );
    }).where((stats) => stats.totalGames > 0).toList();
  }

  /// Récupère tous les noms de joueurs uniques
  List<String> getAllPlayerNames() {
    final games = getAllGames();
    final players = <String>{};

    for (final game in games) {
      players.add(game.player1Name);
      players.add(game.player2Name);
    }

    return players.toList()..sort();
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
  // Statistiques "Premier à jouer"
  final int gamesAsFirstPlayer; // Nombre de parties où le joueur a commencé
  final int winsAsFirstPlayer; // Victoires quand il a commencé
  final int gamesAsSecondPlayer; // Nombre de parties où le joueur n'a pas commencé
  final int winsAsSecondPlayer; // Victoires quand il n'a pas commencé
  final double winrateAsFirstPlayer; // Winrate quand il commence
  final double winrateAsSecondPlayer; // Winrate quand il ne commence pas

  const PlayerStatistics({
    required this.playerName,
    required this.totalGames,
    required this.wins,
    required this.losses,
    required this.draws,
    required this.winrate,
    required this.averageScore,
    this.gamesAsFirstPlayer = 0,
    this.winsAsFirstPlayer = 0,
    this.gamesAsSecondPlayer = 0,
    this.winsAsSecondPlayer = 0,
    this.winrateAsFirstPlayer = 0.0,
    this.winrateAsSecondPlayer = 0.0,
  });
}

/// Statistiques head-to-head entre deux joueurs
class HeadToHeadStatistics {
  final String playerName;
  final String opponentName;
  final int totalGames;
  final int wins;
  final int losses;
  final int draws;
  final double winrate;

  const HeadToHeadStatistics({
    required this.playerName,
    required this.opponentName,
    required this.totalGames,
    required this.wins,
    required this.losses,
    required this.draws,
    required this.winrate,
  });
}

/// Statistiques contre une couleur de deck
class ColorStatistics {
  final String colorName;
  final int totalGames;
  final int wins;
  final int losses;
  final int draws;
  final double winrate;

  const ColorStatistics({
    required this.colorName,
    required this.totalGames,
    required this.wins,
    required this.losses,
    required this.draws,
    required this.winrate,
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
