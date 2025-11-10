import 'package:flutter/material.dart';
import '../../domain/player.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/haptic_utils.dart';

/// Widget représentant la zone d'un joueur
class PlayerZone extends StatelessWidget {
  const PlayerZone({
    super.key,
    required this.player,
    required this.score,
    required this.isRotated,
    required this.onIncrement,
    required this.onDecrement,
  });

  final Player player;
  final int score;
  final bool isRotated;
  final ValueChanged<int> onIncrement;
  final ValueChanged<int> onDecrement;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      color: player.color.withOpacity(0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Nom du joueur
          Text(
            player.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: player.color,
                  fontWeight: FontWeight.bold,
                ),
          ),
          
          const SizedBox(height: AppConstants.defaultPadding),
          
          // Score
          GestureDetector(
            onLongPress: () {
              HapticUtils.medium();
              _showScoreDialog(context);
            },
            child: Text(
              score.toString(),
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 96,
                    fontWeight: FontWeight.bold,
                    color: player.color,
                  ),
            ),
          ),
          
          const SizedBox(height: AppConstants.defaultPadding),
          
          // Barre de progression vers 20
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.largePadding,
            ),
            child: LinearProgressIndicator(
              value: score / AppConstants.winningScore,
              backgroundColor: Colors.grey.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(player.color),
              minHeight: 8,
            ),
          ),
          
          const SizedBox(height: AppConstants.defaultPadding),
          
          // Boutons de contrôle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Bouton -
              _ActionButton(
                icon: Icons.remove,
                color: Colors.red,
                onPressed: () {
                  HapticUtils.light();
                  onDecrement(1);
                },
                onLongPress: () {
                  HapticUtils.medium();
                  onDecrement(5);
                },
              ),

              // Bouton +
              _ActionButton(
                icon: Icons.add,
                color: Colors.green,
                onPressed: () {
                  HapticUtils.light();
                  onIncrement(1);
                },
                onLongPress: () {
                  HapticUtils.medium();
                  onIncrement(5);
                },
              ),
            ],
          ),
        ],
      ),
    );

    return Expanded(
      child: isRotated
          ? RotatedBox(
              quarterTurns: 2,
              child: content,
            )
          : content,
    );
  }

  void _showScoreDialog(BuildContext context) {
    // TODO: Implémenter le dialogue de modification manuelle du score
  }
}

/// Bouton d'action (+ ou -)
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    this.onLongPress,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppConstants.buttonSize,
      height: AppConstants.buttonSize,
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(AppConstants.buttonSize / 2),
        child: InkWell(
          onTap: onPressed,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(AppConstants.buttonSize / 2),
          child: Icon(
            icon,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),
    );
  }
}

