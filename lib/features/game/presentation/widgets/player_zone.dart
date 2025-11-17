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
    this.onScoreLongPress,
  });

  final Player player;
  final int score;
  final bool isRotated;
  final ValueChanged<int> onIncrement;
  final ValueChanged<int> onDecrement;
  final VoidCallback? onNameTap;
  final VoidCallback? onScoreLongPress;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            player.backgroundColorStart.withValues(alpha: 0.6),
            player.backgroundColorEnd.withValues(alpha: 0.4),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Affichage du score avec contrôles +/-
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Affichage du score avec contrôles +/-, descendu de 50 pixels
              Expanded(
                child: Transform.translate(
                  offset: const Offset(0, 50),
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Transform.translate(
                          offset: const Offset(0, 25),
                          child: _ScoreActionButton(
                            icon: Icons.remove,
                            playerColor: player.color,
                            semanticsLabel: 'Diminuer le score',
                            onTap: () {
                              HapticUtils.light();
                              onDecrement(1);
                            },
                          ),
                        ),
                        const SizedBox(width: AppConstants.defaultPadding * 2),
                        // Affichage du score avec cadre Lore
                        Expanded(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Cadre Lore en arrière-plan (rotation gérée par RotatedBox parent)
                              Image.asset(
                                'assets/images/lore_frame.png',
                                fit: BoxFit.contain,
                              ),
                              // Score au centre, descendu de 25 pixels
                              Transform.translate(
                                offset: const Offset(0, 25),
                                child: Center(
                                  child: GestureDetector(
                                    onLongPress: onScoreLongPress != null
                                        ? () {
                                            HapticUtils.medium();
                                            onScoreLongPress!();
                                          }
                                        : null,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Padding(
                                        padding: const EdgeInsets.all(AppConstants.defaultPadding * 2),
                                        child: Text(
                                          score.toString(),
                                          style: const TextStyle(
                                            fontSize: 62.1,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.black,
                                            letterSpacing: -4,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppConstants.defaultPadding * 2),
                        Transform.translate(
                          offset: const Offset(0, 25),
                          child: _ScoreActionButton(
                            icon: Icons.add,
                            playerColor: player.color,
                            semanticsLabel: 'Augmenter le score',
                            onTap: () {
                              HapticUtils.light();
                              onIncrement(1);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Avatar dans le coin haut-gauche (cliquable)
          Positioned(
            top: AppConstants.defaultPadding,
            left: AppConstants.defaultPadding,
            child: GestureDetector(
              onTap: onNameTap != null
                  ? () {
                      HapticUtils.light();
                      onNameTap!();
                    }
                  : null,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black,
                    width: 3.6,
                  ),
                ),
                child: CircleAvatar(
                  radius: 31.5,
                  backgroundColor: player.color.withValues(alpha: 0.08),
                  child: Icon(
                    IconData(
                      player.iconCodePoint,
                      fontFamily: 'MaterialIcons',
                    ),
                    color: player.color,
                    size: 36,
                  ),
                ),
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
    // Mélange de la couleur du joueur avec du blanc pour une teinte pastel
    final buttonColor = Color.lerp(Colors.white, playerColor, 0.15);

    return Semantics(
      button: true,
      label: semanticsLabel,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: buttonColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
          ),
          child: Icon(
            icon,
            color: Colors.black,
            size: 32,
          ),
        ),
      ),
    );
  }
}

