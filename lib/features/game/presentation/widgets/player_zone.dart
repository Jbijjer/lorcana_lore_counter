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
            player.backgroundColorStart.withOpacity(0.6),
            player.backgroundColorEnd.withOpacity(0.4),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Nom du joueur (cliquable)
          Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: GestureDetector(
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
                child: Text(
                  player.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: player.color,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ),

          // Affichage du score avec contrôles +/-
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _ScoreActionButton(
                    icon: Icons.remove,
                    playerColor: player.color,
                    semanticsLabel: 'Diminuer le score',
                    onTap: () {
                      HapticUtils.light();
                      onDecrement(1);
                    },
                  ),
                  const SizedBox(width: AppConstants.defaultPadding * 2),
                  // Affichage du score avec cadre Lore
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Cadre Lore en arrière-plan
                        Transform.rotate(
                          angle: isRotated ? 3.14159 : 0, // 180 degrés en radians pour joueur 2
                          child: Image.asset(
                            'assets/images/lore_frame.png',
                            fit: BoxFit.contain,
                            color: player.color.withOpacity(0.3),
                          ),
                        ),
                        // Score au centre
                        Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Padding(
                              padding: const EdgeInsets.all(AppConstants.defaultPadding * 2),
                              child: Text(
                                score.toString(),
                                style: TextStyle(
                                  fontSize: 120,
                                  fontWeight: FontWeight.w900,
                                  color: player.color,
                                  letterSpacing: -4,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppConstants.defaultPadding * 2),
                  _ScoreActionButton(
                    icon: Icons.add,
                    playerColor: player.color,
                    semanticsLabel: 'Augmenter le score',
                    onTap: () {
                      HapticUtils.light();
                      onIncrement(1);
                    },
                  ),
                ],
              ),
            ),
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
}

/// Bouton d'action pour augmenter ou diminuer le score
class _ScoreActionButton extends StatelessWidget {
  const _ScoreActionButton({
    required this.icon,
    required this.playerColor,
    required this.semanticsLabel,
    required this.onTap,
  });

  final IconData icon;
  final Color playerColor;
  final String semanticsLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticsLabel,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: playerColor.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(
              color: playerColor.withOpacity(0.4),
              width: 2,
            ),
          ),
          child: Icon(
            icon,
            color: playerColor,
            size: 32,
          ),
        ),
      ),
    );
  }
}

