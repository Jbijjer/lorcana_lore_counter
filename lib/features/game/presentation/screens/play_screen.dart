import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/player_zone.dart';
import '../widgets/player_name_dialog.dart';
import '../widgets/score_edit_dialog.dart';
import '../widgets/game_setup_dialog.dart';
import '../widgets/radial_menu.dart';
import '../providers/game_provider.dart';
import '../../domain/player.dart';
import '../../data/player_history_service.dart';
import '../../data/game_persistence_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/haptic_utils.dart';

/// Écran principal du jeu
class PlayScreen extends ConsumerStatefulWidget {
  const PlayScreen({super.key});

  @override
  ConsumerState<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends ConsumerState<PlayScreen> {
  @override
  void initState() {
    super.initState();
    // Verrouiller l'orientation en portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    // Vérifier s'il y a une partie en cours ou démarrer une nouvelle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForOngoingGame();
    });
  }

  /// Vérifie s'il y a une partie en cours et la charge, sinon affiche le dialog de sélection
  Future<void> _checkForOngoingGame() async {
    final persistenceService = ref.read(gamePersistenceServiceProvider);
    final savedGame = persistenceService.loadLastGame();

    if (savedGame != null && mounted) {
      // Charger la partie sauvegardée
      ref.read(gameProvider.notifier).loadGame(savedGame);
    } else if (mounted) {
      // Afficher le dialog de sélection des joueurs
      await _showGameSetupDialog();
    }
  }

  /// Affiche le dialog de sélection des joueurs pour démarrer une nouvelle partie
  Future<void> _showGameSetupDialog() async {
    final result = await showDialog<(Player, Player)>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const GameSetupDialog(),
    );

    if (result != null && mounted) {
      final (player1, player2) = result;
      ref.read(gameProvider.notifier).startGame(
            player1: player1,
            player2: player2,
          );

      // Sauvegarder l'utilisation des joueurs dans l'historique
      final historyService = ref.read(playerHistoryServiceProvider);
      await historyService.addOrUpdatePlayerName(player1.name);
      await historyService.addOrUpdatePlayerName(player2.name);
    }
  }

  @override
  void dispose() {
    // Réactiver toutes les orientations
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);

    if (gameState == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                // Colonne avec les zones de joueurs et le diviseur
                Column(
                  children: [
                    // Zone joueur 1 (en haut, tournée à 180°)
                    PlayerZone(
                      player: gameState.player1,
                      score: gameState.player1Score,
                      isRotated: true,
                      onIncrement: (amount) {
                        ref.read(gameProvider.notifier).incrementPlayer1Score(amount);
                        _checkWinner();
                      },
                      onDecrement: (amount) {
                        ref.read(gameProvider.notifier).decrementPlayer1Score(amount);
                      },
                      onNameTap: () => _showPlayerNameDialog(
                        currentName: gameState.player1.name,
                        playerColor: gameState.player1.color,
                        isPlayer1: true,
                      ),
                      onScoreLongPress: () => _showScoreEditDialog(
                        currentScore: gameState.player1Score,
                        playerName: gameState.player1.name,
                        playerColor: gameState.player1.color,
                        isPlayer1: true,
                      ),
                    ),

                    // Ligne centrale (barre noire de 10 pixels seulement)
                    _CenterDivider(
                      currentRound: gameState.currentRound,
                    ),

                    // Zone joueur 2 (en bas)
                    PlayerZone(
                      player: gameState.player2,
                      score: gameState.player2Score,
                      isRotated: false,
                      onIncrement: (amount) {
                        ref.read(gameProvider.notifier).incrementPlayer2Score(amount);
                        _checkWinner();
                      },
                      onDecrement: (amount) {
                        ref.read(gameProvider.notifier).decrementPlayer2Score(amount);
                      },
                      onNameTap: () => _showPlayerNameDialog(
                        currentName: gameState.player2.name,
                        playerColor: gameState.player2.color,
                        isPlayer1: false,
                      ),
                      onScoreLongPress: () => _showScoreEditDialog(
                        currentScore: gameState.player2Score,
                        playerName: gameState.player2.name,
                        playerColor: gameState.player2.color,
                        isPlayer1: false,
                      ),
                    ),
                  ],
                ),

                // Menu radial au centre (au-dessus de tout)
                Center(
                  child: RadialMenu(
                    onStatisticsTap: _handleStatisticsTap,
                    onResetTap: _handleResetTap,
                    onTimerTap: _handleTimerTap,
                    onHistoryTap: _handleHistoryTap,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _checkWinner() {
    final gameState = ref.read(gameProvider);
    if (gameState == null || !gameState.isFinished) return;

    HapticUtils.success();

    // Marquer la partie comme terminée et supprimer la sauvegarde
    ref.read(gameProvider.notifier).finishGame();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Victoire !'),
        content: Text(
          '${gameState.winner?.name} a gagné avec ${gameState.winner == gameState.player1 ? gameState.player1Score : gameState.player2Score} points !',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              ref.read(gameProvider.notifier).resetGame();
              // Afficher le dialog de sélection des joueurs pour une nouvelle partie
              await _showGameSetupDialog();
            },
            child: const Text('Nouvelle partie'),
          ),
        ],
      ),
    );
  }

  Future<void> _showPlayerNameDialog({
    required String currentName,
    required Color playerColor,
    required bool isPlayer1,
  }) async {
    final gameState = ref.read(gameProvider);
    if (gameState == null) return;

    final player = isPlayer1 ? gameState.player1 : gameState.player2;
    final otherPlayerName = isPlayer1 ? gameState.player2.name : gameState.player1.name;

    final newName = await showDialog<String>(
      context: context,
      builder: (context) => PlayerNameDialog(
        currentName: currentName,
        playerColor: playerColor,
        backgroundColorStart: player.backgroundColorStart,
        backgroundColorEnd: player.backgroundColorEnd,
        excludedPlayerName: otherPlayerName,
        onBackgroundColorsChanged: (start, end) {
          if (isPlayer1) {
            ref.read(gameProvider.notifier).changePlayer1BackgroundColors(start, end);
          } else {
            ref.read(gameProvider.notifier).changePlayer2BackgroundColors(start, end);
          }
          // Note: Ne PAS appeler updatePlayerColors ici car updatePlayerById
          // dans PlayerEditDialog a déjà sauvegardé les couleurs
        },
        onIconChanged: (iconAssetPath) {
          if (isPlayer1) {
            ref.read(gameProvider.notifier).changePlayer1Icon(iconAssetPath);
          } else {
            ref.read(gameProvider.notifier).changePlayer2Icon(iconAssetPath);
          }
          // Note: Ne PAS appeler updatePlayerIcon ici car updatePlayerById
          // dans PlayerEditDialog a déjà sauvegardé l'icône
        },
        onNameChanged: (newPlayerName) {
          // Mettre à jour le nom du joueur actuel dans la partie
          if (isPlayer1) {
            ref.read(gameProvider.notifier).changePlayer1Name(newPlayerName);
          } else {
            ref.read(gameProvider.notifier).changePlayer2Name(newPlayerName);
          }
        },
      ),
    );

    if (newName != null && newName.isNotEmpty && mounted) {
      final historyService = ref.read(playerHistoryServiceProvider);

      // Charger les couleurs sauvegardées pour ce joueur
      final (savedStartColor, savedEndColor) =
          historyService.getPlayerColors(newName);

      // Charger l'icône sauvegardée pour ce joueur
      final savedIcon = historyService.getPlayerIcon(newName);

      if (isPlayer1) {
        ref.read(gameProvider.notifier).changePlayer1Name(newName);

        // Appliquer les couleurs sauvegardées si elles existent
        if (savedStartColor != null && savedEndColor != null) {
          ref.read(gameProvider.notifier).changePlayer1BackgroundColors(
            savedStartColor,
            savedEndColor,
          );
        }

        // Appliquer l'icône sauvegardée si elle existe
        if (savedIcon != null) {
          ref.read(gameProvider.notifier).changePlayer1Icon(savedIcon);
        }
      } else {
        ref.read(gameProvider.notifier).changePlayer2Name(newName);

        // Appliquer les couleurs sauvegardées si elles existent
        if (savedStartColor != null && savedEndColor != null) {
          ref.read(gameProvider.notifier).changePlayer2BackgroundColors(
            savedStartColor,
            savedEndColor,
          );
        }

        // Appliquer l'icône sauvegardée si elle existe
        if (savedIcon != null) {
          ref.read(gameProvider.notifier).changePlayer2Icon(savedIcon);
        }
      }
    }
  }

  Future<void> _showScoreEditDialog({
    required int currentScore,
    required String playerName,
    required Color playerColor,
    required bool isPlayer1,
  }) async {
    final newScore = await showDialog<int>(
      context: context,
      builder: (context) => ScoreEditDialog(
        currentScore: currentScore,
        playerName: playerName,
        playerColor: playerColor,
      ),
    );

    if (newScore != null && mounted) {
      if (isPlayer1) {
        ref.read(gameProvider.notifier).setPlayer1Score(newScore);
      } else {
        ref.read(gameProvider.notifier).setPlayer2Score(newScore);
      }
      _checkWinner();
    }
  }

  /// Gère l'ouverture de l'écran des statistiques
  void _handleStatisticsTap() {
    // TODO: Implémenter la navigation vers l'écran des statistiques
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Statistiques - À implémenter'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  /// Gère le reset de la partie avec confirmation
  void _handleResetTap() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Réinitialiser la partie'),
        content: const Text(
          'Voulez-vous vraiment remettre les scores à zéro ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Réinitialiser'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      HapticUtils.medium();
      ref.read(gameProvider.notifier).resetScores();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Scores réinitialisés'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  /// Gère l'activation du timer
  void _handleTimerTap() {
    // TODO: Implémenter le timer de rounds
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Timer - À implémenter'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  /// Gère l'ouverture de l'historique des rounds
  void _handleHistoryTap() {
    // TODO: Implémenter l'historique des rounds
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Historique - À implémenter'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}

/// Ligne centrale (barre noire de séparation)
class _CenterDivider extends StatelessWidget {
  const _CenterDivider({
    required this.currentRound,
  });

  final int currentRound;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      color: Colors.black,
    );
  }
}
