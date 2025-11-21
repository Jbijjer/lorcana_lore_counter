import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/player_zone.dart';
import '../widgets/player_name_dialog.dart';
import '../widgets/score_edit_dialog.dart';
import '../widgets/game_setup_dialog.dart';
import '../widgets/radial_menu.dart';
import '../widgets/reset_confirmation_dialog.dart';
import '../widgets/victory_overlay.dart';
import '../widgets/round_victory_dialog.dart';
import '../providers/game_provider.dart';
import '../../domain/player.dart';
import '../../domain/game_state.dart';
import '../../data/player_history_service.dart';
import '../../data/game_persistence_service.dart';
import 'statistics_screen.dart';
import 'home_screen.dart';
import '../../../../core/utils/haptic_utils.dart';
import '../../../../core/theme/app_theme.dart';

/// Écran principal du jeu
class PlayScreen extends ConsumerStatefulWidget {
  const PlayScreen({super.key, this.shouldCheckForOngoingGame = true});

  /// Si true, vérifie automatiquement s'il y a une partie en cours au démarrage
  final bool shouldCheckForOngoingGame;

  @override
  ConsumerState<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends ConsumerState<PlayScreen> {
  bool _showVictoryOverlay = false;

  @override
  void initState() {
    super.initState();
    // Verrouiller l'orientation en portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    // Vérifier s'il y a une partie en cours ou démarrer une nouvelle (seulement si demandé)
    if (widget.shouldCheckForOngoingGame) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkForOngoingGame();
      });
    } else {
      // Si on ne vérifie pas automatiquement, afficher directement le dialog de setup
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showGameSetupDialog();
      });
    }
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
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: true,
      builder: (context) => const GameSetupDialog(),
    );

    if (result != null && mounted) {
      final player1 = result['player1'] as Player;
      final player2 = result['player2'] as Player;
      final matchFormat = result['matchFormat'] as MatchFormat;

      ref.read(gameProvider.notifier).startGame(
            player1: player1,
            player2: player2,
            matchFormat: matchFormat,
          );

      // Sauvegarder l'utilisation des joueurs dans l'historique
      final historyService = ref.read(playerHistoryServiceProvider);
      await historyService.addOrUpdatePlayerName(player1.name);
      await historyService.addOrUpdatePlayerName(player2.name);
    } else if (mounted) {
      // L'utilisateur a annulé, retourner à l'écran d'accueil
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
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
                      wins: gameState.player1Wins,
                      winsNeeded: gameState.matchFormat.winsNeeded,
                      onIncrement: (amount) {
                        ref.read(gameProvider.notifier).incrementPlayer1Score(amount);
                        _handleScoreChange();
                      },
                      onDecrement: (amount) {
                        ref.read(gameProvider.notifier).decrementPlayer1Score(amount);
                        _handleScoreChange();
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
                      wins: gameState.player2Wins,
                      winsNeeded: gameState.matchFormat.winsNeeded,
                      onIncrement: (amount) {
                        ref.read(gameProvider.notifier).incrementPlayer2Score(amount);
                        _handleScoreChange();
                      },
                      onDecrement: (amount) {
                        ref.read(gameProvider.notifier).decrementPlayer2Score(amount);
                        _handleScoreChange();
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

                // Overlay de victoire (au-dessus du menu radial)
                if (_showVictoryOverlay)
                  Positioned.fill(
                    child: VictoryOverlay(
                      isPlayer1: gameState.isPlayer1AtThreshold,
                      onConfirm: _handleVictoryConfirm,
                      onDecline: _handleVictoryDecline,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleScoreChange() {
    final gameState = ref.read(gameProvider);
    if (gameState == null) return;

    // Vérifier si le score est retombé en dessous de 20 ou si on a atteint le nouveau seuil de 25
    ref.read(gameProvider.notifier).resetVictoryDeclined();

    // Relire l'état après la réinitialisation potentielle du flag victoryDeclined
    final updatedGameState = ref.read(gameProvider);
    if (updatedGameState == null) return;

    // Vérifier si un joueur a atteint son seuil de victoire et n'a pas refusé
    final player1ShouldShowOverlay =
        updatedGameState.player1HasReachedThreshold &&
        !updatedGameState.player1VictoryDeclined;

    final player2ShouldShowOverlay =
        updatedGameState.player2HasReachedThreshold &&
        !updatedGameState.player2VictoryDeclined;

    if (player1ShouldShowOverlay || player2ShouldShowOverlay) {
      setState(() {
        _showVictoryOverlay = true;
      });
    }
  }

  Future<void> _checkWinner() async {
    final gameState = ref.read(gameProvider);
    if (gameState == null || !gameState.isFinished) return;

    HapticUtils.success();

    // Déterminer qui a gagné la manche (vérifier les seuils individuels)
    final isPlayer1Winner =
        gameState.player1HasReachedThreshold &&
        !gameState.player1VictoryDeclined;

    final winner = isPlayer1Winner ? gameState.player1 : gameState.player2;
    final loser = isPlayer1Winner ? gameState.player2 : gameState.player1;
    final winnerWins = isPlayer1Winner ? gameState.player1Wins + 1 : gameState.player2Wins + 1;
    final loserWins = isPlayer1Winner ? gameState.player2Wins : gameState.player1Wins;
    final winsNeeded = gameState.matchFormat.winsNeeded;

    // Vérifier si le joueur a gagné le match complet
    final isMatchComplete = winnerWins >= winsNeeded;

    // Afficher le dialog de victoire avec saisie de note et couleurs
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (context) => RoundVictoryDialog(
        winner: winner,
        loser: loser,
        isMatchComplete: isMatchComplete,
        winnerWins: winnerWins,
        loserWins: loserWins,
        previousPlayer1DeckColors: gameState.player1DeckColors,
        previousPlayer2DeckColors: gameState.player2DeckColors,
        isPlayer1Winner: isPlayer1Winner,
      ),
    );

    // Si l'utilisateur a annulé (ne devrait pas arriver car barrierDismissible = false)
    if (result == null) return;

    final note = result['note'] as String?;
    final player1DeckColors = result['player1DeckColors'] as List<String>;
    final player2DeckColors = result['player2DeckColors'] as List<String>;

    // Ajouter une victoire au gagnant de la manche avec les informations saisies
    if (isPlayer1Winner) {
      ref.read(gameProvider.notifier).addPlayer1Win(
        note: note,
        player1DeckColors: player1DeckColors,
        player2DeckColors: player2DeckColors,
      );
    } else {
      ref.read(gameProvider.notifier).addPlayer2Win(
        note: note,
        player1DeckColors: player1DeckColors,
        player2DeckColors: player2DeckColors,
      );
    }

    if (isMatchComplete) {
      // Match terminé
      ref.read(gameProvider.notifier).finishGame();

      if (mounted) {
        // Afficher le dialog de sélection des joueurs pour une nouvelle partie
        ref.read(gameProvider.notifier).resetGame();
        await _showGameSetupDialog();
      }
    }
  }

  void _handleVictoryConfirm() {
    ref.read(gameProvider.notifier).confirmVictory();
    setState(() {
      _showVictoryOverlay = false;
    });
    _checkWinner();
  }

  void _handleVictoryDecline() {
    ref.read(gameProvider.notifier).declineVictory();
    setState(() {
      _showVictoryOverlay = false;
    });
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
      _handleScoreChange();
    }
  }

  /// Gère l'ouverture de l'écran des statistiques
  void _handleStatisticsTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const StatisticsScreen(),
      ),
    );
  }

  /// Gère le reset de la partie avec confirmation
  void _handleResetTap() async {
    final choice = await showDialog<ResetOption>(
      context: context,
      builder: (context) => const ResetConfirmationDialog(),
    );

    if (choice == ResetOption.scores && mounted) {
      HapticUtils.medium();
      // Animation: faire un flash sur l'écran
      _animateReset(() {
        ref.read(gameProvider.notifier).resetScores();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: AppTheme.pureWhite),
              SizedBox(width: 8),
              Text('Scores remis à 0'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else if (choice == ResetOption.round && mounted) {
      HapticUtils.medium();
      // Animation: faire un flash sur l'écran
      _animateReset(() {
        ref.read(gameProvider.notifier).resetRound();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: AppTheme.pureWhite),
              SizedBox(width: 8),
              Text('Round réinitialisé'),
            ],
          ),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  /// Anime le reset avec un effet de flash
  void _animateReset(VoidCallback onReset) {
    // Créer un overlay pour l'animation de flash
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _ResetFlashAnimation(
        onComplete: () {
          overlayEntry.remove();
          onReset();
        },
      ),
    );

    overlay.insert(overlayEntry);
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

/// Animation de flash lors du reset
class _ResetFlashAnimation extends StatefulWidget {
  const _ResetFlashAnimation({
    required this.onComplete,
  });

  final VoidCallback onComplete;

  @override
  State<_ResetFlashAnimation> createState() => _ResetFlashAnimationState();
}

class _ResetFlashAnimationState extends State<_ResetFlashAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.3)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.3, end: 0.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 60,
      ),
    ]).animate(_controller);

    _controller.forward().then((_) {
      widget.onComplete();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          color: AppTheme.pureWhite.withValues(alpha: _animation.value),
          child: Center(
            child: Icon(
              Icons.restart_alt,
              size: 80,
              color: AppTheme.pureBlack.withValues(alpha: _animation.value * 0.5),
            ),
          ),
        );
      },
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
      color: AppTheme.pureBlack,
    );
  }
}
