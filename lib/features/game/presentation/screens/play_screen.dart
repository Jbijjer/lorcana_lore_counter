import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/player_zone.dart';
import '../providers/game_provider.dart';
import '../../domain/player.dart';
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
    
    // Démarrer une partie de test
    _startTestGame();
  }

  void _startTestGame() {
    final player1 = Player.create(
      name: 'Joueur 1',
      color: AppTheme.amberColor,
    );
    
    final player2 = Player.create(
      name: 'Joueur 2',
      color: AppTheme.sapphireColor,
    );
    
    ref.read(gameProvider.notifier).startGame(
          player1: player1,
          player2: player2,
        );
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
        child: Column(
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
            ),

            // Ligne centrale avec logo
            _CenterDivider(
              onNextRound: () {
                HapticUtils.medium();
                ref.read(gameProvider.notifier).nextRound();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Round ${gameState.currentRound + 1}'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
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
            ),
          ],
        ),
      ),
    );
  }

  void _checkWinner() {
    final gameState = ref.read(gameProvider);
    if (gameState == null || !gameState.isFinished) return;

    HapticUtils.success();
    
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
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(gameProvider.notifier).resetGame();
              _startTestGame();
            },
            child: const Text('Nouvelle partie'),
          ),
        ],
      ),
    );
  }
}

/// Ligne centrale avec logo et contrôles
class _CenterDivider extends StatelessWidget {
  const _CenterDivider({
    required this.onNextRound,
    required this.currentRound,
  });

  final VoidCallback onNextRound;
  final int currentRound;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Bouton historique
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // TODO: Afficher l'historique des rounds
            },
            iconSize: 32,
          ),

          // Logo Lorcana (temporaire avec icône Flutter)
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),

          // Bouton round suivant
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_next),
                onPressed: onNextRound,
                iconSize: 32,
              ),
              Text(
                'Round $currentRound',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
