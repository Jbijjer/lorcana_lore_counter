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
    this.onNameTap,
  });

  final Player player;
  final int score;
  final bool isRotated;
  final ValueChanged<int> onIncrement;
  final ValueChanged<int> onDecrement;
  final VoidCallback? onNameTap;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            player.color.withOpacity(0.15),
            player.color.withOpacity(0.05),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Nom du joueur (cliquable)
          GestureDetector(
            onTap: onNameTap != null
                ? () {
                    HapticUtils.light();
                    onNameTap!();
                  }
                : null,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: onNameTap != null
                  ? BoxDecoration(
                      color: player.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: player.color.withOpacity(0.3),
                        width: 1,
                      ),
                    )
                  : null,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    player.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: player.color,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (onNameTap != null) ...[
                    const SizedBox(width: 8),
                    Icon(
                      Icons.edit,
                      size: 18,
                      color: player.color.withOpacity(0.7),
                    ),
                  ],
                ],
              ),
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
                    fontSize: 120,
                    fontWeight: FontWeight.w900,
                    color: player.color,
                    letterSpacing: -4,
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

